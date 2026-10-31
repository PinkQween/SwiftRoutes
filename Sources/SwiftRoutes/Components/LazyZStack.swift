import Foundation
import SwiftUI

/// Displays an ordered collection of views with the transitions of a `ZStack`.
///
/// The container retains the selected item and, when `allowSimultaneous` is `true`,
/// the previously selected items. Set it to `false` to keep only the selected item
/// in the view hierarchy. Items are selected by their `Identifiable.ID`.
///
/// Use the integer `Range` initializer for integer identifiable items, or the Boolean
/// initializer for a two state presentation.
public typealias LazyZStack<T: Identifiable, Content: View> = AnyRecursiveView<T, Content>

/// Builds an ordered recursive view hierarchy while preserving concrete content types.
///
/// The first item is the root of the hierarchy and each subsequent item is a child
/// of the previous item. The container renders the selected item and applies its
/// transitions as the selection changes.
public struct AnyRecursiveView<T: Identifiable, Content: View>: View {
    private let allowSimultaneous: Bool
    private let selection: T?
    private let items: [T]
    private let recursiveItem: AnyRecursiveModel<T>?
    private let view: (T) -> Content

    /// Creates a recursive view from identifiable items.
    /// - Parameters:
    ///   - allowSimultaneous: Whether previous items remain in the hierarchy.
    ///   - selection: The currently selected item.
    ///   - items: Ordered items to display.
    ///   - view: A view builder for each item.
    public init(
        allowSimultaneous: Bool,
        selection: T?,
        items: [T],
        @ViewBuilder view: @escaping (T) -> Content
    ) {
        self.allowSimultaneous = allowSimultaneous
        self.selection = selection
        self.items = items
        self.recursiveItem = try? items.asAnyRecursiveModelWithDepthOfOne()
        self.view = view
    }

    /// Creates a recursive view for a half-open integer range.
    /// - Parameters:
    ///   - allowSimultaneous: Whether previous items remain in the hierarchy.
    ///   - selection: The currently selected integer item.
    ///   - items: The half-open range of integer identifiable items.
    ///   - view: A view builder for each item.
    public init(
        allowSimultaneous: Bool,
        selection: T?,
        items: Range<T>,
        @ViewBuilder view: @escaping (T) -> Content
    ) where T: IntegerIdentifiable & Comparable {
        let values = (items.lowerBound.id..<items.upperBound.id).map(T.init(id:))
        self.init(allowSimultaneous: allowSimultaneous, selection: selection, items: values, view: view)
    }

    /// Creates a two state recursive view selected by a Boolean.
    /// - Parameters:
    ///   - allowSimultaneous: Whether the previous state remains in the hierarchy.
    ///   - selection: The selected Boolean state. `nil` selects `false`.
    ///   - view: A view builder for each Boolean state.
    public init(
        allowSimultaneous: Bool,
        selection: Bool?,
        @ViewBuilder view: @escaping (T) -> Content
    ) where T: BoolIdentifiable {
        let selected = selection ?? false
        let items: [T] = [.init(id: false), .init(id: true)]
        self.allowSimultaneous = allowSimultaneous
        self.selection = .init(id: selected)
        self.items = items
        self.recursiveItem = try? items.asAnyRecursiveModelWithDepthOfOne()
        self.view = view
    }

    public var body: some View {
        AnyConditionalView(
            removePrevious: !allowSimultaneous,
            showView1: selection?.id == items.first?.id,
            view1: {
                if let item = items.first { view(item) } else { EmptyView() }
            },
            view2: {
                RecursiveView(
                    removePrevious: !allowSimultaneous,
                    selection: selection,
                    items: recursiveItem?.children ?? [],
                    view: { value in view(value.value) }
                )
            }
        )
    }
}

/// Identifies values whose IDs are integers and can be initialized from an ID.
public protocol IntegerIdentifiable: Identifiable where ID == Int {
    /// Creates a value with the specified integer identifier.
    init(id: Int)
}

extension Int: IntegerIdentifiable {
    public var id: Int { self }
    public init(id: Int) { self = id }
}

/// Identifies values whose IDs are Boolean and can be initialized from an ID.
public protocol BoolIdentifiable: Identifiable where ID == Bool {
    /// Creates a value with the specified Boolean identifier.
    init(id: Bool)
}

extension Bool: BoolIdentifiable {
    public var id: Bool { self }
    public init(id: Bool) { self = id }
}

/// Stores one value and its remaining ordered descendants.
struct AnyRecursiveModel<Value: Identifiable>: Hashable, Identifiable {
    var id: AnyHashable
    var value: Value
    var children: [AnyRecursiveModel<Value>]?

    init(value: Value) {
        self.id = AnyHashable(value.id)
        self.value = value
        self.children = nil
    }

    static func == (lhs: AnyRecursiveModel<Value>, rhs: AnyRecursiveModel<Value>) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

private struct RecursiveView<T: Identifiable, Content: View>: View {
    let removePrevious: Bool
    let selection: T?
    let items: [AnyRecursiveModel<T>]
    let view: (AnyRecursiveModel<T>) -> Content

    var body: some View {
        AnyConditionalView(
            removePrevious: removePrevious,
            showView1: selection?.id == items.first?.id,
            view1: {
                if let item = items.first { view(item) } else { EmptyView() }
            },
            view2: {
                if let children = items.first?.children {
                    RecursiveView(removePrevious: removePrevious, selection: selection, items: children, view: view)
                } else {
                    EmptyView()
                }
            }
        )
    }
}

private struct AnyConditionalView<First: View, Second: View>: View {
    let removePrevious: Bool
    let showView1: Bool
    @ViewBuilder let view1: () -> First
    @ViewBuilder let view2: () -> Second

    @ViewBuilder var body: some View {
        if showView1 || !removePrevious { view1() }
        if !showView1 { view2() }
    }
}

private extension Array where Element: Identifiable {
    func asAnyRecursiveModelWithDepthOfOne() throws -> AnyRecursiveModel<Element> {
        guard let first = first else { throw URLError(.dataNotAllowed) }
        var model = AnyRecursiveModel(value: first)
        let remaining = Array(dropFirst())
        if !remaining.isEmpty {
            model.children = remaining.map { value in
                var child = AnyRecursiveModel(value: value)
                let descendants = Array(remaining.drop { $0.id != value.id }.dropFirst())
                if !descendants.isEmpty {
                    child.children = descendants.map(AnyRecursiveModel.init(value:))
                }
                return child
            }
        }
        return model
    }
}
