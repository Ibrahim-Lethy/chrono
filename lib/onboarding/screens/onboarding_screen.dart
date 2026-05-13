import 'package:clock_app/common/logic/card_decoration.dart';
import 'package:clock_app/navigation/screens/nav_scaffold.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/screens/settings_group_screen.dart';
import 'package:clock_app/settings/widgets/protection_illustration.dart';
import 'package:clock_app/system/native_features_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    GetStorage().write('onboarded', true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const NavScaffold()),
    );
  }

  Future<void> _requestDeviceAdmin() async {
    await NativeFeaturesService.requestDeviceAdmin();
  }

  Future<void> _openAccessibilitySettings() async {
    await NativeFeaturesService.openAccessibilitySettings();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    const pageDecoration = PageDecoration(
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: colorScheme.background,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: true,
      pages: [
        PageViewModel(
          title: "CAPTCHA No cheating",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: ProtectionIllustration(size: 220)),
              const SizedBox(height: 24),
              Text(
                "Make alarm tasks harder to bypass",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Advanced protection combines QR and other alarm tasks with Android Device Admin and Accessibility permissions. It cannot make cheating impossible, but it can make common escape paths much harder while an alarm is active.",
                style: textTheme.bodyLarge,
              ),
            ],
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Device admin",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: ProtectionIllustration(size: 220)),
              const SizedBox(height: 24),
              Text(
                "Force stop and uninstall protection",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Device Admin adds an extra Android confirmation before the app can be removed. You can revoke it later from the app's Protection settings.",
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _requestDeviceAdmin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Agree',
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
              ),
            ],
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Accessibility service",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: ProtectionIllustration(size: 220)),
              const SizedBox(height: 24),
              Text(
                "Block common cheating paths",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "The Accessibility Service can close power-off and app-settings screens while an alarm task is active. It is used only for alarm protection; no private information is collected.",
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _openAccessibilitySettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Agree',
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
              ),
            ],
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Important",
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onBackground,
                  )),
              const SizedBox(height: 16),
              Text(
                  "Some devices have battery optimizations that prevent background app from functioning properly. This might cause alarms and timers to not go off reliably. Please click the button below and follow the guide to disable these optimizations for your device. You can also do so later by going to Settings > General > Reliability",
                  style: textTheme.bodyLarge),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingGroupScreen(
                                settingGroup:
                                    appSettings.getGroup("Reliability"),
                                isAppSettings: false,
                              )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'View Settings',
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
              ),
            ],
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: getCardDecoration(context),
    );
  }
}
