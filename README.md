# Overview

iOS application example demonstrating modern Swift architecture patterns with RAWG Video Games API integration.

This README is structured to help you quickly understand the layering, how to run the project, and what is covered by tests today.

## Architecture

This project follows a clean architecture approach combining:
- **TCA (The Composable Architecture)** for state management
- **Clean Swift** principles for layer separation  
- **SwiftUI** for declarative UI development
- **Swift Testing** for tests
- **Swift 6.2** with upcoming features (`InferIsolatedConformances`, `NonisolatedNonsendingByDefault`)

**Swift 6 Migration**: The project has completed migration to Swift 6.2 with default actor isolation enabled. SwiftUI Views are automatically isolated to `@MainActor` for type-safe UI operations. Network operations use `@concurrent` to execute outside the main actor, preventing UI blocking.

The architecture ensures separation of concerns, testability, and scalability.

## Quick Start

### Prerequisites
- Xcode 15+
- iOS 17+ simulator

### First Run Setup

1. **RAWG API Registration**:
   - Visit https://rawg.io/apidocs and create an account
   - Generate an API key from your dashboard
   
2. **SPM Dependencies**: On first launch, Xcode will download Swift Package Manager dependencies. Since TCA uses macros, you may see system popups requesting permission to enable them - please allow these requests.

3. **Configuration Files**: 
   - Navigate to `Core/Infrastructure/Configurations/Secrets/`
   - Copy `Development-Secrets.xcconfig.template` → `Development-Secrets.xcconfig`  
   - Copy `Production-Secrets.xcconfig.template` → `Production-Secrets.xcconfig` 
   - Update both files with your RAWG API credentials:
     ```
     API_KEY = your_actual_api_key
     API_BASE_URL = your_actual_base_url
     ```
   - Note: In a real project these files should be git-ignored; templates should be committed instead.

4. **Build & Run**:
   - Open `ArtemPoluyanovichTechTask.xcodeproj`
   - Select `Debug-Dev` scheme for development
   - Build and run on iOS simulator

### Current Test Coverage
The project already includes solid test coverage for:
  - Data layer mappers (GameModelMapperTests, GenreModelMapperTests)
  - TCA Features (GamesFeatureTests, GenresFeatureTests)  
  - Test helpers and mock repositories (TestDataHelpers, MockGamesRepository)
  - Network layer (DefaultInterceptorChainTests, SessionExecutorTests, AuthInterceptorTests, RetryInterceptorTests, URLProtocolMock)

## Project Structure

```
App/
└── ArtemPoluyanovichTechTaskApp.swift      # App entry point

Core/
├── Data/                                   # Data layer (DTOs, Repositories)
├── Domain/                                 # Business logic (Entities, UseCases)  
└── Infrastructure/                         # Configuration & networking

Presentation/
├── DesignSystem/                           # UI components & styling
└── Features/                               # TCA features (State/Action/Reducer + View)

ArtemPoluyanovichTechTaskTests/
├── Data/Mappers/                           # Data mapper tests
├── Features/                               # TCA feature tests  
├── Helpers/                                # Test helpers
├── Infrastructure/Network/                 # Network layer tests
└── Mocks/                                  # Mock implementations
```

### Architecture Flow

#### Core Layer Interactions

```
User Action
    ↓
Presentation Layer (TCA Feature)
    ↓
Domain Layer (UseCase)
    ↓
Data Layer (Repository)
    ↓
Infrastructure (Network Service)
    ↓
External API
```

#### Presentation Layer (TCA Pattern)

```
SwiftUI View → Sends Action → TCA Reducer
       ↑                          ↓
       ←── Updates State ──────────
       ↑                          ↓  
       ←── Returns Effect ────────→ Domain Layer
```

#### Design System Layer

The Design System provides a centralized, consistent UI foundation through tokens, components, and styling utilities.

```
Colors/
├── Palette.swift                    # Base color tokens from Assets
└── Color+Semantic.swift             # Semantic color system
    ├── Background (primary, secondary, tertiary, Gradient)
    ├── Surface (card, elevated, overlay)
    ├── Text (primary, secondary, tertiary, disabled, onColor)
    ├── Interactive (neutral, primary/secondary/tertiary + states)
    ├── Border (primary, secondary, focus, error)
    ├── Status (success, warning, error, info + backgrounds)
    └── Special (shadow, divider, shimmer)

Typography/
├── AppFont.swift                    # Inter Variable Fonts management
│   └── Font weights & sizes (display, heading, body, caption)
├── TestStyle.swift                  # Complete text styles (font + color + spacing + kerning)
└── Text+Extensions.swift            # Convenience modifiers for views (.heading1(), .body(), etc.)

Components/
├── EmptyStateView.swift             # Empty state placeholder
├── ListCell.swift                   # Reusable list cell container
├── LoadingView.swift                 # Loading indicator
├── PaginationFooter.swift           # Pagination loading footer
└── ToastView.swift                  # Toast notification component

Layout/
├── SpacingToken.swift               # Spacing scale (xxs, xs, sm, md, xl)
├── CornerRadiusToken.swift          # Border radius tokens
└── ShadowToken.swift                # Shadow elevation tokens

Animation/
├── AnimationToken.swift             # Animation duration & spring configs
└── TransitionToken.swift            # View transition tokens

Modifiers/
├── NavigationStyling.swift          # Navigation bar styling
└── ToastModifier.swift              # Toast presentation modifier

Assets/
└── Image+SF.swift                   # SF Symbols extensions
```

**Usage Flow:**
- **Colors**: Use semantic colors (`Color.Text.primary`, `Color.Background.primary`) instead of raw palette values
- **Typography**: In views, use `Text+Extensions` methods (`.heading1()`, `.body()`) for complete styling
- **Components**: Reusable UI building blocks with consistent styling
- **Tokens**: Layout and animation tokens ensure consistent spacing and motion

#### Detailed Data Flow

```
[View] --(User Action)--> [TCA Feature] --(Call UseCase)--> [Domain]
     ↑                       ↓                               ↓
     ←──(State Update)───────┘                               ↓
                                                          [Repository]
                                                               ↓
                                                        [Network Service]
                                                               ↓
                                                          [External API]
```

### Layer Responsibilities

- **Presentation Layer**: 
  - TCA Features: Manage UI state, handle user actions
  - SwiftUI Views: Render UI based on state
  - DesignSystem: Reusable UI components and styling

- **Domain Layer**:
  - UseCases: Coordinate business logic and data flow
  - Entities: Core business models and rules
  - Interfaces: Protocol definitions for dependencies

- **Data Layer**:
  - Repositories: Data access and transformation
  - Models: Data transfer objects (DTOs)
  - Mappers: Convert between DTOs and Entities

- **Infrastructure Layer**:
  - Network: API clients and networking logic
  - Configuration: Build settings and environment configs

### Network Layer

The network layer implements the **Chain of Responsibility** pattern, providing a flexible and extensible architecture for handling HTTP requests and responses.

#### Pattern Overview

The Chain of Responsibility pattern allows multiple interceptors to process requests sequentially. Each interceptor can:
- Modify the request before it's sent
- Handle errors and retries
- Transform responses
- Log network activity

#### Architecture Components

- **RestService**: Entry point that coordinates the interceptor chain
- **DefaultInterceptorChain**: Stateless chain manager that routes requests through interceptors
- **SessionExecutor**: Executes the final HTTP request via URLSession and validates HTTP status codes
- **Interceptors**: Modular components that process requests/responses

#### Request Flow

```
RestService
    ↓
DefaultInterceptorChain
    ↓
AuthInterceptor (adds API key)
    ↓
RetryInterceptor (handles retries)
    ↓
ErrorHandlerInterceptor (transforms errors)
    ↓
LoggerInterceptor (logs request/response)
    ↓
SessionExecutor (executes HTTP request)
    ↓
URLSession (network call)
```

#### Interceptors

1. **AuthInterceptor**
   - Purpose: Adds API key to request query parameters
   - Position: First in chain (modifies request before other processing)

2. **RetryInterceptor**
   - Purpose: Automatically retries failed requests
   - Retry conditions: Network timeouts, connection errors, 5xx server errors
   - Configuration: Max retries and delay between attempts

3. **ErrorHandlerInterceptor**
   - Purpose: Transforms low-level errors into domain-specific NetworkError types
   - Handles: URLError → NetworkError mapping, HTTP status code interpretation

4. **LoggerInterceptor**
   - Purpose: Logs request/response details for debugging
   - Features: Masks sensitive data (API keys), logs headers, body preview
   - Configuration: Can be enabled/disabled via NetworkConfiguration

#### Benefits

- **Separation of Concerns**: Each interceptor has a single responsibility
- **Testability**: Interceptors can be tested independently
- **Extensibility**: New interceptors can be added without modifying existing code
- **Stateless Design**: Chain and interceptors are stateless, making them thread-safe
- **Professional Architecture**: Industry-standard pattern used in libraries like OkHttp and Alamofire

###  SwiftLint
SwiftLint is included to enforce code style.
  - Run: locally via `swiftlint` (install with `brew install swiftlint`).
  - Configuration: `.swiftlint.yml` at the repository root (if present); otherwise default rules apply.

## Potential Improvements
  - Extract reusable modules (e.g., `DesignSystem`, `Networking`) as SPM packages.
  - Consider feature flags for experimental UI variations.
  - Add a GitHub Actions (or similar) workflow for build + test + lint on PRs.
  - Add UseCase tests to validate domain logic independently of repositories.