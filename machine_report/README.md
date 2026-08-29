# MachinePulse

MachinePulse is a Flutter-based industrial maintenance dashboard for logging, tracking, and resolving equipment failures across a factory or production floor.

The application gives maintenance teams a single place to review active incidents, classify failures by type, search for specific assets, and submit new problem reports from a guided mobile-friendly workflow.

## Why this project exists

In industrial environments, downtime can be expensive. MachinePulse helps teams move quickly from detection to action by making it easy to:

- record equipment issues as soon as they appear
- categorize failures by type such as mechanical, electrical, hydraulic, or software
- monitor the current incident load for each category
- filter and search the active report list for faster triage
- distinguish between admin and technician access in the workflow

## Features

- Role-based login for administrators and technicians
- Dashboard overview with totals for each failure category
- Search and filtering by equipment, keywords, and reporter
- Guided form to log a new machine failure report
- Quick resolution flow to remove incidents from the active list
- Cross-platform Flutter UI for Android, iOS, Web, and Windows

## Demo accounts

The project includes lightweight in-memory authentication for demo use:

- Admin: `admin` / `admin123`
- Technician: `tech` / `tech123`

## Project structure

- `lib/main.dart` – app entry point and route setup
- `lib/screens/` – login, incident list, and new failure forms
- `lib/services/` – authentication and failure data services
- `lib/models/` – data models for users and reports
- `lib/theme/` – branding and application styling
- `android/`, `ios/`, `web/`, `windows/` – platform targets

## Getting started

### Prerequisites

- Flutter SDK 3.13 or newer
- An IDE such as VS Code or Android Studio
- A connected device or emulator

### Run the app

```bash
cd machine_report
flutter pub get
flutter run
```

### Validate the app

```bash
flutter test
```

## Notes

This project is intended as a polished prototype for an industrial incident management workflow. It demonstrates how a maintenance team could capture, classify, and resolve equipment problems in a streamlined interface.
