# NAPOS

The framework for a Flutter project.

## Install and Use

Ensure you have Flutter and dart installed on your machine. 
- [How to: Set up Flutter and dart on your Windows machine](https://docs.flutter.dev/get-started/install/windows)

To use Flutter commands outside of a Flutter terminal, you will have to add the full path to the Flutter SDK in you path environment variable.

Use `> flutter doctor` to ensure your Flutter setup is working
Use `> flutter devices` to see the devices currently connected to your machine. This will include browsers.
Using `> flutter run` will run the project on the default machine.
You can specify which device you want to run it on with `> flutter run -d [device name]`
You can specify which file to run as an entry point with `> flutter run -t lib/[file name]`
Once the program is running, pressing 'r' while focused on the terminal will hot reload the app, meaning you don't have to build it from scratch again. Variables stay the same value since the program is not restarted.

## Development Help

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Changing project name and icons:
Windows Desktop: https://stackoverflow.com/questions/64800455/how-to-change-app-icon-and-app-name-for-flutter-desktop-application
Android: https://stackoverflow.com/questions/51419998/how-can-i-run-a-different-dart-file-in-flutter