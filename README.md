# VideoFlex - iOS Video Conversion App

## Overview

VideoFlex is a modern iOS application built with SwiftUI that provides powerful video conversion and manipulation tools. The app allows users to:

- **Convert Video to Audio**: Extract audio from videos in multiple formats (M4A, WAV, CAF)
- **Convert Video to GIF**: Create animated GIFs from videos with customizable frame rates
- **Merge Videos**: Combine multiple videos into a single file with orientation options

All processing happens on-device, ensuring user privacy and data security.

## Technical Stack

- **iOS 14.0+** minimum deployment target
- **SwiftUI** for the entire UI layer
- **AVFoundation** for video/audio processing
- **Combine** for reactive programming
- **Swift Package Manager** for dependency management
- **MVVM Architecture** with observable data flow

## Project Structure

```
ios-app-test/
├── VideoFlex/                     # Main iOS app
│   ├── Assets.xcassets/          # Images, colors, and app icons
│   ├── Configuration/            # App-wide configuration
│   │   └── AppConfig.swift      # Centralized settings (IAP, AdMob, limits)
│   ├── DataManager/             # Core business logic
│   │   ├── DataManager.swift   # Main data orchestrator
│   │   ├── Video+GIF.swift     # GIF conversion implementation
│   │   ├── Video+Merge.swift   # Video merging logic
│   │   └── Video+Sound.swift   # Audio extraction logic
│   ├── Flows/                   # UI screens and flows
│   │   ├── DashboardContentView.swift  # Main app screen
│   │   ├── BottomSheetView.swift      # Dynamic tool configuration sheet
│   │   ├── GalleryAssetPickerView.swift # Photo library picker
│   │   └── SettingsContentView.swift   # Settings screen
│   ├── Helper/                  # Utilities and extensions
│   ├── Lifecycle/              # App lifecycle management
│   │   ├── ConvertlyApp.swift # Main app entry point
│   │   └── AppDelegate.swift  # UIKit bridge for legacy features
│   ├── SubView/                # Reusable UI components
│   ├── Utils/                  # Utilities
│   │   └── Analytics/         # Analytics system
│   └── PurchaseKit.xcframework/ # In-app purchase framework
│
├── CommonSwiftUI/              # Shared SwiftUI components (Swift Package)
│   └── Sources/CommonSwiftUI/
│       ├── Extensions/        # SwiftUI & UIKit extensions
│       ├── PropertyWrappers/  # Custom @AppStorage variants
│       ├── ViewModifiers/     # Reusable view modifiers
│       └── Views/            # Reusable views
│
├── SDKMockup/                 # Mock SDK for premium features (Swift Package)
│   └── Sources/SDK/
│       ├── TheSDK.swift      # Main SDK interface
│       └── Views/            # SDK UI components
│
└── NotificationServiceExtension/ # Rich push notifications
```

## Architecture

### MVVM Pattern
The app follows MVVM architecture with SwiftUI's built-in data flow:

- **Models**: Video processing logic in DataManager extensions
- **ViewModels**: `DataManager` serves as the main view model, using `@Published` properties
- **Views**: SwiftUI views observe the view model through `@EnvironmentObject`

### Key Components

#### 1. DataManager
Central orchestrator for all app operations:
- Manages video selection and processing
- Handles file operations and history
- Controls UI state (sheets, loading, etc.)
- Implements `UIDocumentPickerDelegate` for file imports

#### 2. Video Processing Extensions
Modular approach with focused extensions:
- `Video+Sound.swift`: Audio extraction using `AVAssetReader/Writer`
- `Video+GIF.swift`: Frame extraction and GIF generation
- `Video+Merge.swift`: Video composition and merging

#### 3. UI Flow
- **DashboardContentView**: Main screen with tool selection
- **BottomSheetView**: Dynamic configuration based on selected tool
- **Share Sheet**: Automatic presentation after conversion

### Data Flow
1. User selects a tool → Updates `DataManager.videoToolType`
2. User imports video → `DataManager.handleSelectedAsset()`
3. Bottom sheet appears → User configures options
4. Conversion starts → Progress shown via `LoadingView`
5. Result saved → Share sheet presented

## Key Features Implementation

### Video to Audio Conversion
```swift
// Located in Video+Sound.swift
- Uses AVAssetReader to read video tracks
- AVAssetWriter to write audio-only file
- Supports M4A, WAV, and CAF formats
- Configurable audio settings (22050Hz, mono)
```

### Video to GIF Conversion
```swift
// Located in Video+GIF.swift
- Extracts frames using AVAssetImageGenerator
- Creates animated GIF with CGImageDestination
- Configurable frame rate (5-15 FPS)
- Maximum 5-second duration for performance
```

### Video Merging
```swift
// Located in Video+Merge.swift
- Uses AVMutableComposition for combining videos
- Handles different orientations and aspect ratios
- Exports at 1280x720 resolution
- Supports portrait/landscape output
```

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd ios-app-test
   ```

2. **Open in Xcode**
   ```bash
   open VideoFlex.xcodeproj
   ```

3. **Build and Run**
   - Select a physical device or simulator (iOS 14.0+)
   - Press Cmd+R to build and run
   - **Note**: Physical device recommended for camera/photo library testing

## Configuration

### AppConfig.swift
Central configuration file containing:
- **AdMob IDs**: Ad integration settings
- **IAP Product ID**: Premium version identifier
- **Video Limits**: Max GIF duration, frame rates
- **Email/URLs**: Support and privacy links

### Monetization
- **Ads**: Google AdMob integration (interstitial ads)
- **Premium**: In-app purchase removes ads, unlocks all features
- **Premium Features**: Video to GIF, Merge Videos

## Adding New Features

### To add a new video conversion tool:

1. **Update VideoToolType enum** in `AppConfig.swift`
   ```swift
   enum VideoToolType {
       case regular, videoGIF, mergeVideos, yourNewTool
   }
   ```

2. **Create processing extension** in DataManager/
   ```swift
   // Video+YourFeature.swift
   extension DataManager {
       func processYourFeature(from video: AVAsset) {
           // Implementation
       }
   }
   ```

3. **Add UI in DashboardContentView**
   - Add button in `ImportMediaSectionView` or `OtherToolsView`
   - Set appropriate `videoToolType` on tap

4. **Configure BottomSheetView**
   - Add case in switch statement for your tool
   - Create configuration UI components

5. **Update convertSelectedAsset()** in DataManager
   - Add case to handle your new tool type

### Code Style Guidelines
- Use SwiftUI's declarative syntax
- Follow MVVM pattern
- Keep views focused and extract reusable components
- Use `@Published` for UI-reactive properties
- Implement proper error handling with user alerts

## Testing Considerations

- **Device Testing**: Always test video features on real devices
- **Memory Management**: Monitor memory usage during video processing
- **File Formats**: Test with various video formats (MOV, MP4, etc.)
- **Permissions**: Ensure photo library and camera permissions work
- **Share Extensions**: Verify share sheet functionality

## Important Notes

1. **Privacy First**: All processing happens on-device
2. **Performance**: GIF conversion limited to 5 seconds for optimal performance
3. **Resolution**: Merged videos output at 720p for balance of quality/size
4. **Analytics**: Comprehensive event tracking for user actions
5. **Localization**: Currently English-only

## Common Tasks for Candidates

Potential interview tasks might include:
- Adding a new video filter/effect feature
- Implementing video trimming functionality
- Adding watermark to converted videos
- Implementing batch processing
- Adding cloud backup for converted files
- Improving the UI/UX of existing features
- Adding unit tests for video processing logic

## Support & Resources

- **Bundle ID**: Check Info.plist for current bundle identifier
- **Minimum iOS**: 14.0 (consider compatibility when adding features)
- **Swift Version**: 5.5+
- **UI Framework**: SwiftUI only (no UIKit views except for system integrations)

## Debugging Tips

1. **Check Console**: Detailed logs for video processing
2. **Memory Graph**: Monitor retain cycles in closures
3. **Instruments**: Profile video processing performance
4. **Test Various Inputs**: Different video sizes, formats, durations

---

**Good luck with your interview task! Remember to read through the existing code to understand patterns and maintain consistency.**