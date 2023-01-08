# c-search-tca
🏢 This is an app to search corporate info

## Goal
Experiment with an **engaging approach** for iOS app development
[The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)

## Dependencies
```mermaid
flowchart TB
  subgraph Project
    App<-->View
    subgraph Package
      subgraph Presentation Layer
        ViewStore(ViewStore)-->View
        View-->Action
      end
      subgraph Domain Layer
        State(State)-->ViewStore
        Reducer(Reducer)-->State
        Action(Action)-->Reducer
        Reducer-->Effect
        Effect(Effect)-->Action
        UseCase<-->Effect
        UseCase<-->Gateway
      end
      subgraph Data Layer
        ApiRequest<-->Gateway
      end
    end
  end
```
