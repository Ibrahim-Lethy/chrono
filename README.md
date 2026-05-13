<div align="center">

<image src="icon.png" height="100"/>

# Chrono

### A modern and powerful clock, alarms, timer and stopwatch app for Android!
![alt text](cover.png)

![tests](https://github.com/vicolo-dev/chrono/actions/workflows/tests.yml/badge.svg)
[![codecov](https://codecov.io/gh/vicolo-dev/chrono/branch/master/graph/badge.svg?token=cKxMm8KVev)](https://codecov.io/gh/vicolo-dev/chrono)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/7dc1e51c1616482baa5392bc0826c50a)](https://app.codacy.com/gh/vicolo-dev/chrono/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
<a href="https://hosted.weblate.org/engage/chrono/">
<img src="https://hosted.weblate.org/widget/chrono/app/svg-badge.svg" alt="Translation status" />
</a>
<span class="badge-patreon"><a href="https://patreon.com/vicolo" title="Donate to this project using Patreon"><img src="https://img.shields.io/badge/patreon-donate-orange.svg" alt="Patreon donate button" /></a></span>

<a href="https://hosted.weblate.org/engage/chrono/">
<img src="https://hosted.weblate.org/widget/chrono/app/287x66-grey.png" alt="Translation status" />
</a>

[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png" alt="Get it on F-Droid" height="80">](https://f-droid.org/packages/com.vicolo.chrono)
[<img src="https://gitlab.com/IzzyOnDroid/repo/-/raw/master/assets/IzzyOnDroid.png" alt="Get it on IzzyOnDroid" height=80/>](https://apt.izzysoft.de/fdroid/index/apk/com.vicolo.chrono)
[<img src="https://i.ibb.co/q0mdc4Z/get-it-on-github.png" alt="Get it on Github" height=80/>](https://github.com/vicolo-dev/chrono/releases/latest)


</div>


Its usable, but still WIP, so you might encounter some bugs. Make sure to test it out thorougly on your device before using it for critical alarms. Feel free to open an issue.

# Table of Content
- [Features](#features)
- [Platforms](#platforms)
- [Contribute](#contribute)
- [Development](#development)
- [Todo](#todo)
- [Screenshots](#screenshots)

## Features
- Modern and easy to use interface
- Available in variety of [languages](#translations)
### Alarms
- Customizable schedules (Daily, Weekly, Specific week days, Specific dates, Date range)
- Configure melody/ringtone, rising volume and vibrations
- Configure Snooze length, max snoozes and other snooze behaviour
- Option to auto delete dismissed alarms and skip alarms
- Alarm tasks (Math problems, Retype text, Sequence, more to come)
- Dial, spinner and text time pickers
- Filter and sort alarms
- Add tags
### Clock
- Customizable clock display
- World clocks with relative time difference
- Search and add cities
### Timer
- Support for multiple timers
- Configure melody/ringtone, rising volume and vibrations
- Timer presets
- Option to fullscreen a timer
- Dial and spinner duration pickers
- Filter and sort timers
- Add tags
### Stopwatch
- Lap history with lap times and elapsed times
- Lap comparisons (fastest, slowest, average, previous)
### Appearance
- Material You icons and themes
- Highly customizable color themes
- Highly customizable style themes
- Other options like animations, nav bar styles, time picker styles

## Platforms
Currently, the app is only available for android. I don't have an apple device to develop for iOS, but feel free
to contribute if you want iOS support. The alarm and timer features
use android-only code, so that will need to be ported. Everything else should mostly work fine.

## Contribute
All contributions are welcome, whether creating issues, pull requests or translations. 
### Issues
Feel free to create issues regarding any issues you might be facing, any improvements or enhancements, or any feature-requests. Try to follow the templates and include as much information as possible in your issues.
### Pull Requests
Pull Requests are highly welcome. When contributing to this repository, please first discuss the change you wish to make via an issue. Also, please refer to [Effective Dart](https://dart.dev/effective-dart) as a guideline for the coding standards expected from pull requests.
### Translations
You can help translate the app into your preferred language using weblate at https://hosted.weblate.org/projects/chrono/.

<a href="https://hosted.weblate.org/engage/chrono/">
<img src="https://hosted.weblate.org/widget/chrono/app/287x66-grey.png" alt="Translation status" />
</a>

Current progress:

<a href="https://hosted.weblate.org/engage/chrono/">
<img src="https://hosted.weblate.org/widget/chrono/app/horizontal-auto.svg" alt="Translation status" />
</a>

### Spread the word!
If you found the app useful, you can help the project by sharing it with friends and family.
### Donate
The amount of time I can given to the app is bound by financial constraints. Donations will really help allow me in giving more and more time to the development of this app.

<span class="badge-patreon"><a href="https://patreon.com/vicolo" title="Donate to this project using Patreon"><img src="https://img.shields.io/badge/patreon-donate-orange.svg" alt="Patreon donate button" /></a></span>

### Our generous patreons
- Potato @potatocinna
- Thorsten @th23x

## Development

This app is built using flutter. To start developing:
1. Follow [this](https://docs.flutter.dev/get-started/install) guide to install flutter and all required tools.
2. Run the app by `flutter run --flavor dev`. For production builds, use `flutter build apk --release --split-per-abi --flavor prod`.

### Verified Android build baseline

The current Android build is verified with Flutter 3.22.2, Dart 3.4.3, Java 17, Android SDK 34, Gradle 7.6.4, Android Gradle Plugin 7.4.2, and Kotlin 1.8.0.

Use these commands from the repository root:

```sh
flutter pub get
flutter test
flutter build apk --debug --flavor dev
```

`flutter analyze` should not report build-blocking errors, but this fork still has pre-existing warnings and info-level lints. Local release builds require signing inputs at `android/key.properties` and `android/app/release-key.jks`; CI creates those files from secrets before running release builds.

### Advanced CAPTCHA protection verification checklist

Use a physical Android device or an emulator with camera support:

1. Create or edit an alarm and add the QR task.
2. Open the QR task customization screen, tap the QR setup control, scan a QR code, and confirm the saved value snackbar appears.
3. Use the task try flow or let the alarm fire. Scanning the same QR payload should complete the task; scanning a different QR payload should show the wrong-code message.
4. During first-run onboarding, verify the "CAPTCHA No cheating", "Device admin", and "Accessibility service" education pages are shown and that Agree opens the correct Android permission screen.
5. Open Settings > Protection. Enable "Power off protection"; if Accessibility is not enabled, the app should open Android Accessibility settings.
6. Enable "Force stop and uninstall protection"; if Device Admin is not active, the app should open the Android Device Admin activation screen. If Device Admin is already active but Accessibility is missing, it should open Accessibility settings.
7. While an alarm notification screen is active, try to open the power menu. With power-off protection enabled and the Accessibility Service active, the app should close the power menu and relaunch itself.
8. While an alarm notification screen is active, try to reach Android app-info, force-stop, uninstall, Device Admin deactivation, or Accessibility deactivation screens. With force-stop/uninstall protection enabled and the Accessibility Service active, the app should close common escape screens and relaunch itself.
9. Dismiss or snooze the alarm and confirm the shared `alarm_active` state is cleared so the Accessibility Service stops blocking system screens.
10. Open Settings > Protection > Diagnostics and confirm the status rows match the device state.
11. Configure an alarm's protection requirement. Verify warning chips appear when required protections are not set up, and verify enabling/saving the alarm shows a setup warning.
12. Add an NFC task, scan the NFC tag to save it, then confirm the same NFC tag is required when the alarm task runs.
13. Review recent blocked attempts in Protection diagnostics after trying blocked power-menu or app-info flows.

Limitations:

- Android does not allow a normal Play Store app to fully prevent every force-stop or uninstall path. Device Admin adds uninstall/deactivation friction; Accessibility heuristics make common escape paths harder while an alarm task is active.
- Power menu and Settings screens vary by Android version and device manufacturer, so physical-device testing is required.
- NFC tag scanning can behave differently while the device is locked. Test NFC alarms on the exact device you plan to use before relying on them.

## Todo
Stuff I would like to do soon™. In no particular order:
- Alarms
  - Alarm reliability testing system
  - Vibration patterns
  - Alternative time picker interfaces
  - Array alarms (alarm that will ring after set interval (10 minutes etc.)
  - More tasks
- Color schemes
  - More prebuilt themes  
  - Filter
  - Tags
  - Icon colors
- Theme
  - Icon themes
  - Font themes
  - System fonts
- Timer
  - Alternative duration picker interfaces
- Widgets
  - Clock
  - Clock faces
  - Alarms
  - Timers
  - Stopwatch
  - Customization
 
## Screenshots
<p float="left">
<image src="fastlane/metadata/android/en-US/images/phoneScreenshots/1.png" height="400"/>
<image src="fastlane/metadata/android/en-US/images/phoneScreenshots/2.png" height="400"/>
<image src="fastlane/metadata/android/en-US/images/phoneScreenshots/3.png" height="400"/>
<image src="fastlane/metadata/android/en-US/images/phoneScreenshots/4.png" height="400"/>
<image src="fastlane/metadata/android/en-US/images/phoneScreenshots/5.png" height="400"/>
</p>


