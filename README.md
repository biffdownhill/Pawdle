# Pawdle iOS App

## App Requirement

A good friend of yours loves dogs, but struggles to remember which breed is which. They have approached you to see if you can build an app that will help them remember. They’d love an app that shows them a
picture of a dog and asks them which breed it is- and gives them a warm sense of satisfaction when they get it right.

## 🏗️ Architecture Overview

This boilerplate provides a solid foundation for iOS app development with:

- **MVVM Architecture**: Clean separation of concerns
- **SwiftUI**: Modern declarative UI framework
- **Theme System**: Consistent design language
- **Network Layer**: Simplified HTTP networking
- **Type Safety**: Leveraging Swift's type system

## 📁 Project Structure

```
Pawdle/
├── Core/
│   └── BaseViewModel.swift          # Base class for ViewModels
├── Network/
│   └── NetworkManager.swift        # HTTP networking utilities
├── Theme/
│   ├── Colors.swift                 # Color system
│   ├── TextStyles.swift            # Typography system
│   ├── Sizes.swift                 # Spacing and sizing system
│   └── Theme.swift                 # Theme configuration
├── PawdleApp.swift                 # App entry point
└── ContentView.swift               # Main view
```

## 🎨 Theme System

### Colors (`Theme/Colors.swift`)

Provides a centralized color system using native iOS colors for automatic light/dark mode support:

```swift
// Usage
Color.theme.textPrimary         // Primary text color
Color.theme.textSecondary       // Secondary text color
Color.theme.backgroundPrimary   // Primary background
Color.theme.backgroundSecondary // Secondary background
Color.theme.accent             // App accent color
Color.theme.success            // Success state color
Color.theme.warning            // Warning state color
Color.theme.error              // Error state color
```

**Available Colors:**

- **Text**: `textPrimary`, `textSecondary`, `textTertiary`
- **Backgrounds**: `backgroundPrimary`, `backgroundSecondary`, `backgroundTertiary`
- **Accents**: `accent`, `accentForeground`
- **Fills**: `fill`, `fillSecondary`, `fillTertiary`
- **Semantic**: `success`, `warning`, `error`

### Typography (`Theme/TextStyles.swift`)

Defines a comprehensive text style system with automatic font weights and line spacing:

```swift
// Usage
Text("Hello World")
    .textStyle(.largeTitle)

Text("Body content")
    .textStyle(.body)
```

**Available Text Styles:**

- `largeTitle`, `title1`, `title2`, `title3`
- `headline`, `body`, `bodyLarge`
- `callout`, `caption`, `caption2`
- `footnote`, `button`

### Sizes (`Theme/Sizes.swift`)

Provides consistent spacing and sizing throughout the app:

```swift
// Direct usage
VStack(spacing: Size.lg.rawValue) {
    // content
}

// With extensions
Text("Hello")
    .padding(.md)
    .cornerRadius(.sm)
    .frame(size: .xl)
```

**Available Sizes:**

- `zero` (0pt), `xxs` (2pt), `xs` (4pt), `sm` (8pt)
- `md` (12pt), `lg` (16pt), `xl` (20pt), `xxl` (24pt)
- `xxxl` (32pt), `xxxxl` (40pt), `xxxxxl` (48pt)

**Size Extensions:**

- `.padding(Size)` - Apply padding with Size enum
- `.cornerRadius(Size)` - Apply corner radius with Size enum
- `.frame(size: Size)` - Apply square frame with Size enum
- `EdgeInsets(Size)` - Create EdgeInsets with Size enum

## 🏛️ MVVM Architecture

### BaseViewModel (`Core/BaseViewModel.swift`)

A base class for all ViewModels providing common functionality:

```swift
@MainActor
class MyViewModel: BaseViewModel {
    @Published var data: [MyModel] = []

    func loadData() {
        setLoading(true)

        // Async operation
        Task {
            do {
                let result = try await networkManager.get(...)
                data = result
            } catch {
                handleError(error)
            }
            setLoading(false)
        }
    }
}
```

**Features:**

- `@Published var isLoading: Bool` - Loading state management
- `@Published var errorMessage: String?` - Error message handling
- `@Published var showError: Bool` - Error alert state
- `handleError(_:)` - Standardized error handling
- `setLoading(_:)` - Loading state management
- `clearError()` - Error state reset

**Future-Proofing:**

- Ready for migration to `@Observable` macro when iOS 16 support is dropped

## 🌐 Network Layer

### NetworkManager (`Network/NetworkManager.swift`)

A lightweight, type-safe HTTP client built on URLSession:

```swift
let networkManager = NetworkManager()

// GET request
let users = try await networkManager.get(
    endpoint: URL(string: "https://api.example.com/users")!,
    responseType: [User].self
)

// POST request
let newUser = try await networkManager.post(
    endpoint: URL(string: "https://api.example.com/users")!,
    body: try JSONEncoder().encode(userData),
    responseType: User.self
)
```

**Features:**

- **Type-Safe**: Generic methods with Codable support
- **Async/Await**: Modern concurrency patterns
- **Error Handling**: Comprehensive error types
- **Flexible**: Support for custom headers and request bodies
- **Lightweight**: No external dependencies

**HTTP Methods:**

- `GET`, `POST`, `PUT`, `DELETE`, `PATCH`

**Error Types:**

- `noData` - No response data
- `decodingError` - JSON decoding failed
- `serverError(Int)` - HTTP error with status code
- `networkError(Error)` - Network-level errors

## 🚀 Usage Examples

### Basic View with Theme

```swift
struct MyView: View {
    var body: some View {
        VStack(spacing: Size.lg.rawValue) {
            Text("Welcome")
                .textStyle(.largeTitle)
                .foregroundColor(Color.theme.textPrimary)

            Text("Description")
                .textStyle(.body)
                .foregroundColor(Color.theme.textSecondary)
        }
        .padding(.lg)
        .background(Color.theme.backgroundPrimary)
    }
}
```

### ViewModel with Network Calls

```swift
@MainActor
class ContentViewModel: BaseViewModel {
    @Published var items: [Item] = []
    private let networkManager = NetworkManager()

    func loadItems() {
        setLoading(true)

        Task {
            do {
                let url = URL(string: "https://api.example.com/items")!
                items = try await networkManager.get(
                    endpoint: url,
                    responseType: [Item].self
                )
            } catch {
                handleError(error)
            }
            setLoading(false)
        }
    }
}
```

### View with ViewModel

```swift
struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    // Your content here
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
        .onAppear {
            viewModel.loadItems()
        }
    }
}
```

## 🎯 Key Design Decisions

### Simplicity Over Convenience

- Removed convenience methods for cleaner, more explicit code
- Direct use of `.rawValue` instead of computed properties
- Focused on core functionality rather than syntactic sugar

### Type Safety

- Strong typing throughout the system
- Compile-time validation of sizes, colors, and text styles
- Generic network methods with Codable support

### Modern iOS Development

- iOS 16+ minimum deployment target
- SwiftUI-first approach
- Async/await for networking
- @MainActor for UI updates

### Extensibility

- Easy to add new colors, sizes, or text styles
- Base classes provide common functionality
- Modular architecture for easy feature addition

## 🔮 Future Considerations

- **@Observable Migration**: Ready to migrate from ObservableObject when iOS 16 support is dropped
- **Dependency Injection**: Consider adding a container for larger apps
- **Persistence**: Add Core Data or SwiftData support as needed
- **UI Components**: Build reusable components on top of the theme system

## 📱 Getting Started

1. **Clone the project**
2. **Open in Xcode 15+**
3. **Build and run** - the app will demonstrate the theme system
4. **Start building** - add your models, views, and business logic

The boilerplate provides a solid foundation while remaining lightweight and easy to understand. Perfect for rapid prototyping or production apps that need a clean, maintainable architecture.
