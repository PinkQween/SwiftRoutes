# SwiftRoutes

Build programmatic navigation flows for SwiftUI with screens, sheets, alerts, modals, transitions, and modules.

## Overview

Add a ``RouterView`` at the root of a routing hierarchy, then use the router provided to its content closure to present destinations.

```swift
RouterView { router in
    HomeView()
}
```

The router is also available in descendant views through the SwiftUI environment. Destination builders accept concrete SwiftUI view types, while routing stores destinations for later presentation because the destination type is chosen at runtime.

## Presenting resizable sheets

Provide multiple detents to let a sheet move between sizes. Fractional detents are measured against the available sheet height, while height detents use points.

```swift
router.showScreen(
    .sheetConfig(config: ResizableSheetConfig(
        detents: [.fraction(0.25), .medium, .large]
    ))
) {
    DetailsView()
}
```

You can also bind the selected detent to control the initial size and respond to changes:

```swift
@State private var sheetSize: PresentationDetentTransformable = .fraction(0.25)

ResizableSheetConfig(
    detents: [.fraction(0.25), .medium, .large],
    selection: $sheetSize
)
```

## Topics

### Routing

- ``RouterView``
- ``AnyRouter``

### Destinations

- ``AnyDestination``
- ``AnyDestinationStack``
- ``AnyModal``
- ``AnyAlert``
- ``AnyTransitionDestination``

### Alerts and modals

- ``AnyAlert``
- ``AlertLocation``
- ``AlertStyle``
- ``AnyModal``

### Presentation and transitions

- ``SegueOption``
- ``SegueLocation``
- ``FullScreenCoverConfig``
- ``EnvironmentBackgroundOption``
- ``BackgroundEffect``
- ``TransitionOption``
- ``TransitionMemoryBehavior``
- ``AnyDestinationStack``

### Logging

- ``RoutingLogger``
- ``SwiftRoutesLogger``
- ``RoutingLogEvent``
- ``RoutingLogType``

### Sheets

- ``ResizableSheetConfig``
- ``PresentationDetentTransformable``
- ``PresentationBackgroundInteractionBackSupport``
- ``PresentationContentInteractionBackSupport``

### Recursive presentation

- ``LazyZStack``
- ``AnyRecursiveView``
- ``IntegerIdentifiable``
- ``BoolIdentifiable``
