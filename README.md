# Getting started

### 1. Requirements

- Flutter: ">=1.17.0"
- Dart: "^3.11.1"

### 2. Add dependency

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  aicycle_buyme_plus: <lastest_version>
```

### 2. Platform Setup

#### iOS

Add the following keys to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to capture vehicle photos for AI inspection.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to upload vehicle photos.</string>
```

#### Android

Ensure your `minSdkVersion` is at least **21** in `android/app/build.gradle`.

## Usage

### Simple Implementation

```dart
import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';

// ... inside your widget ...

ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiCycleBuyMe(
          aiCycleConfig: AiCycleConfig(
            generalConfig: GeneralConfig(
              apiToken: 'YOUR_API_TOKEN',
              documentId: 'YOUR_CLAIM_ID', // e.g., Claim number or Job ID
              environment: AiCycleEnvironment.stage,
            ),
          ),
          onComplete: (data) {
            print('Inspection completed: $data');
            // 'data' contains 'damageStatistics' with full AI results
          },
          onError: (error) {
            print('Error: $error');
          },
        ),
      ),
    );
  },
  child: const Text('Start AI Inspection'),
)
```

## Configuration Reference

The `AiCycleConfig` class consists of four main configuration sections:

### 1. GeneralConfig
Core settings for API access and SDK behavior.

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `apiToken` | `String` | Required | Your AiCycle API token. |
| `documentId` | `String` | Required | Unique ID for the inspection (External ID). |
| `organization` | `AiCycleOrg` | Required | `AiCycleOrg.aicycle`, `partner`, or `others`. |
| `environment` | `AiCycleEnvironment`| `develop` | `develop`, `stage`, or `production`. |
| `documentName`| `String?` | `null` | Optional name for the inspection document. |
| `showResultScreen`| `bool` | `true` | Show AiCycle's built-in result screen after capture. |
| `loggingEnabled` | `bool` | `false` | Enable/disable Internal SDK logging. |

### 2. DisplayConfig
Customize the UI and visible capture angles.

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `loadingWidget` | `Widget?` | `null` | Custom widget to show during initialization. |
| `carAnglesWithDisplayName` | `Map` | All angles | Map of `AicycleCarAngle` to their display names. Controls which buttons appear. |

### 3. CarInformation
Pre-fill vehicle details to improve AI accuracy.

| Property | Type | Description |
| :--- | :--- | :--- |
| `carCompanyId` | `String?` | Vehicle brand ID (e.g., '5' for Mazda). |
| `carModelId` | `String?` | Vehicle model ID. |
| `manufacturingYear`| `int?` | Year of manufacture. |
| `vehicleSpec` | `String?` | Vehicle version/specification. |
| `licensePlate` | `String?` | Vehicle license plate number. |
| `vehicleType` | `String?` | `sedan`, `suv`, `truck`, `pickup`, etc. |
| `color` | `String?` | Hex color code (e.g., `#FFFFFF`). |

### 4. ValidationConfig
Toggle various AI validation features.

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `sameCarValidation` | `bool` | `true` | Verify if all photos belong to the same vehicle. |
| `missingPartValidation` | `bool` | `true` | Check if any required car parts are missing in photos. |

## Data Output Structure

The `onComplete` callback returns a `Map<String, dynamic>` containing:

```json
{
  "damageStatistics": [
    {
      "vehiclePartName": "Cánh cửa trước trái",
      "paintPercentage": 1.0,
      "dentedLevel": "slight",
      "damages": [
        {
          "damageTypeName": "Trầy (xước)",
          "damagePercentage": 0.007,
          "damageTypeColor": "#FFEC05"
        }
      ],
      "images": [...]
    }
  ]
}
```

## Support

For issues and feature requests, please contact [AiCycle Support](mailto:support@aicycle.ai).

