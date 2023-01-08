# c-search-tca
🏢 This is an app to search corporate info

## Goal
Experiment with an **engaging approach** for iOS app development
[The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)

## Dependencies
```mermaid
flowchart TB
  subgraph Project
    App<-->A
    subgraph Package
      A[Some Module]
    end
  end
  subgraph Third Party
    A<-->E[Some Packages]
    A<-->F[swift-composable-architecture]
  end
```
