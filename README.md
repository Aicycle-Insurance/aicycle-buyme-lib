# Getting started

### 1. Add dependency

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

### Advanced Configuration

You can customize which angles to show and how they should be named:

```dart
AiCycleBuyMe(
  aiCycleConfig: AiCycleConfig(
    generalConfig: GeneralConfig(
      apiToken: '61a688:b97cd78259f9...',
      documentId: '9121',
      environment: AiCycleEnvironment.stage,
      organization: AiCycleOrg.partner,
      loggingEnabled: true,
    ),
    validationConfig: ValidationConfig(
      sameCarValidation: true,
      missingPartValidation: true,
    ),
    displayConfig: DisplayConfig(
      carAnglesWithDisplayName: {
        AicycleCarAngle.front: 'Trước',
        AicycleCarAngle.rear: 'Sau',
        AicycleCarAngle.left: 'Trái',
        AicycleCarAngle.right: 'Phải',
        AicycleCarAngle.vinNumber: 'Số khung',
      },
      showResultScreen: true, // Navigate to a detailed damage result page
    ),
  ),
  onComplete: (data) {
    // Handle the result data
  },
)
```

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
