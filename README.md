# Edit Temperature Photo App

A photo editing app built with SwiftUI that lets users adjust the color temperature of JPEG images, creating warmer or cooler tones with ease.

## Features

- **Photo Picker**: Select and load a JPEG image from your device.
- **Temperature Adjustment**: Modify the image's color temperature using a slider.
- **Save Image**: Export and save the edited image in JPEG format

## Screenshots

<img src="https://github.com/user-attachments/assets/c37ff316-18dd-4a3e-8e4f-47186b893409" width="240">

<img src="https://github.com/user-attachments/assets/a52d6900-a226-46ef-a933-bd2865e03a5c" width="240">

## Video Screenshot

https://github.com/user-attachments/assets/ede42723-93aa-44ac-8d42-e51038f5a352

## Requirements

- iOS 18.0+
- Xcode 16.2+
- Swift 5.0+

## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/Photo-Temperature.git
    cd Photo-Temperature
    ```

2. Open the workspace in Xcode:

    ```bash
    open Photo-Temperature.xcodeproj
    ```

4. Build and run the project on your simulator or device.

## Usage

1. **Photo Picker**:
    - Select a photo to edit.
    - Only JPEG photos are supported.

2. **Temperature Adjustment**:
    - Use the slider to modify the image’s color tones.
    - Move right (toward 0) for warmer (reddish) tones and left (negative values) for cooler (bluish) hues.

3. **Save Image**:
    - Tap "Export" (top-right corner) to save the edited image.
    - Ensure the app has permission to save photos in Settings.

## Depedencies
This project uses **Swift Package Manager (SwiftPM)** to manage dependencies.
### Installed Packages:
- [SwiftUI](https://developer.apple.com/documentation/swiftui)(Built-in)
- [OpenCV](https://opencv.org/releases/)(via SwiftPM)
### Installing Dependencies:
No extra setup is required—Xcode will automatically resolve dependencies when you open the project.

If needed, update dependencies manually:
```bash
swift package update
```
---

Feel free to reach out if you have any questions or need further assistance!
