# Pawdle iOS App

## App Overview

A good friend of yours loves dogs, but struggles to remember which breed is which. They have approached you to see if you can build an app that will help them remember. They’d love an app that shows them a
picture of a dog and asks them which breed it is- and gives them a warm sense of satisfaction when they get it right.

### How It Works

The premise of the app is simple: show a picture of a dog, ask the user to identify the breed, and provide feedback on their answer. The app is designed to be used once a day, to help the user gradually learn and remember different dog breeds. If the user's still wanting to continue after reaching their daily goal, they have the option to continue playing indefinitely.

## Code Overview

- **Architecture**: MVVM pattern with SwiftUI, keeping views thin and moving business logic to view models
- **Repository Pattern**: Abstracted data layer with protocol-based repositories for easy testing and dependency injection
- **Dependency Injection**: Constructor injection for repositories into view models, enabling clean testing boundaries
- **Functional Programming**: Repositories implemented as structs with closures rather than protocols, making mocking simple
- **State Management**: Single source of truth with `@Published` properties and enum-based game states
- **Theme System**: Centralized design system with custom colors, sizes, and text styles using asset catalogs
- **Testing Strategy**: Unit tests for view models, snapshot tests for UI components, mock implementations for repositories
- **Error Handling**: Comprehensive error states with user-friendly messaging and recovery options
- **Component Architecture**: Reusable UI components with clear state management (AnswerButton, DogImageCard)
- **Modern Swift**: Uses async/await for networking, new Testing framework, and MainActor for UI updates
- **Testability**: Stubbable protocol for easy test data generation, separate mock implementations

## What I Would Add Next

- Testing support for the repositories. Perhaps by injecting a mock network layer with relevant spy methods to capture functionality within the repository functions.
- Add some UI tests for basic functionality of certain features of the app.
- Spike some better architecture design patters for the storage and business logic of the app - instead of having a single class view model, using dependency injection to further modularise the logic to improve testability, maintainability, and extensibility.
- Add custom fonts to add a bit of personality to the app.
- Add an animation to the celebration screen when the user gets all answers correct.
- Add nicer animations for when an answer is selected.
- Improve the appearance and functionality of the toolbar.

## Additional Notes

Tests were run on an iPhone 16 Pro.
