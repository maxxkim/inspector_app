# Inspector TPS Mobile Application

A Flutter-based mobile application for facilities management and maintenance operations using the Maximo backend system.

## Overview

Inspector TPS helps field technicians and facility managers conduct audits, process maintenance tasks, manage service requests, and document their work with photos and comments. The application supports both online and offline operations, allowing technicians to continue working even without internet connectivity.

## Key Features

### Audits Module
- Download and complete inspection checklists
- Add comments and attach photos to audit items
- Track completed vs. outstanding inspection items
- Synchronize completed audits with the Maximo server

### Claims Module
- Create and submit service requests with location and description
- Process work assignments (РЗ)
- Link assets to work orders
- Track claim status and history

### PPR Module (Planned Preventative Maintenance)
- View scheduled maintenance tasks
- Process maintenance operations with pass/fail results
- Add evidence and documentation with photos
- Change task status (take work, send for approval, etc.)
- Filter tasks by different criteria (current shift, outdated, completed)

### User Management
- Role-based access control
- User profile and authentication
- Group-specific permissions and features

## Technical Details

- **Framework**: Flutter (Dart)
- **Architecture**: Redux with Thunks for async operations
- **Database**: SQLite for local data storage
- **Networking**: Dio for API communication
- **Navigation**: GoRouter
- **Dependency Injection**: GetIt
- **Camera Integration**: Native camera support for documentation
- **Offline Support**: Complete workflows available without connectivity

## Getting Started

### Prerequisites
- Flutter SDK
- Android Studio or Xcode
- Maximo server access credentials

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Configure the server endpoint in the application settings
4. Build and run the application on your device

## Development

The codebase is organized into feature modules:
- `/audit`: Inspection and audit functionality
- `/auth`: Authentication and user management
- `/claims`: Service requests and work assignments
- `/ppr`: Preventative maintenance tasks
- `/core`: Shared utilities and services
- `/data`: Data models and repositories

## License

[Your license information here]

## Contact

[Your contact information here]
