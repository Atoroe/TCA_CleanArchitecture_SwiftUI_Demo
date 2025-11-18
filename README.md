# Overview

iOS Technical Task application built with modern Swift architecture patterns.

This README is structured to help you quickly understand the layering, how to run the project, and what is covered by tests today, while also outlining concrete, realistic next steps. If you’d like, I can prioritize any of the improvements above (e.g., grid UI, more tests) and implement them next.

## Architecture

This project follows a clean architecture approach combining:
- **TCA (The Composable Architecture)** for state management
- **Clean Swift** principles for layer separation  
- **SwiftUI** for declarative UI development

The architecture ensures separation of concerns, testability, and scalability.

## Quick Start

### Prerequisites
- Xcode 15+
- iOS 17+ simulator

### First Run Setup

1. **SPM Dependencies**: On first launch, Xcode will download Swift Package Manager dependencies. Since TCA uses macros, you may see system popups requesting permission to enable them - please allow these requests.

2. **Configuration Files**: 
   - Navigate to `Core/Infrastructure/Configurations/Secrets/`
   - Copy `Development-Secrets.xcconfig.template` → `Development-Secrets.xcconfig`  
   - Copy `Production-Secrets.xcconfig.template` → `Production-Secrets.xcconfig` 
   - Update both files with your actual API credentials:
     ```
     API_KEY = your_actual_api_key
     API_BASE_URL = your_actual_base_url
     ```
   - Note: In a real project these files should be git-ignored; templates should be committed instead.

3. **Build & Run**:
   - Open `ArtemPoluyanovichTechTask.xcodeproj`
   - Select `Debug-Dev` scheme for development
   - Build and run on iOS simulator

### Current Test Coverage
The project already includes solid test coverage for:
  - Data layer mappers (MainTypeModelMapperTests, ManufacturerModelMapperTests)
  - TCA Features (CarTypesFeatureTests, ManufacturersFeatureTests)  
  - Test helpers and mock repositories (TestDataHelpers, MockCarsRepository)
```

## Project Structure

<pre>
App/
└── ArtemPoluyanovichTechTaskApp.swift      # App entry point

Core/
├── Data/                                   # Data layer (DTOs, Repositories)
├── Domain/                                 # Business logic (Entities, UseCases)  
└── Infrastructure/                         # Configuration & networking

Presentation/
├── DesignSystem/                           # UI components & styling
└── Features/                               # TCA features (State/Action/Reducer + View)
</pre>

### Architecture Flow

#### Core Layer Interactions

<pre>
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
</pre>

#### Presentation Layer (TCA Pattern)

<pre>
SwiftUI View → Sends Action → TCA Reducer
       ↑                          ↓
       ←── Updates State ──────────
       ↑                          ↓  
       ←── Returns Effect ────────→ Domain Layer
</pre>

#### Detailed Data Flow

<pre>
[View] --(User Action)--> [TCA Feature] --(Call UseCase)--> [Domain]
     ↑                       ↓                               ↓
     ←──(State Update)───────┘                               ↓
                                                          [Repository]
                                                               ↓
                                                        [Network Service]
                                                               ↓
                                                          [External API]
</pre>

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

###  SwiftLint
SwiftLint is included to enforce code style.
  - Run: locally via `swiftlint` (install with `brew install swiftlint`).
  - Configuration: `.swiftlint.yml` at the repository root (if present); otherwise default rules apply.

## Potential Improvements
  - Extract reusable modules (e.g., `DesignSystem`, `Networking`) as SPM packages.
  - Consider feature flags for experimental UI variations.
  - Add a GitHub Actions (or similar) workflow for build + test + lint on PRs.
  - Add UseCase tests to validate domain logic independently of repositories.
  - Pull-to-refresh and load-more pagination affordances.
  - Add a grid layout where it improves scannability.