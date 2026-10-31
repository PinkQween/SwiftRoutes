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

### Recursive presentation

- ``LazyZStack``
- ``AnyRecursiveView``
- ``IntegerIdentifiable``
- ``BoolIdentifiable``
