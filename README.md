# Signup App (MAD In-Class Activity 10)

Track: Undergraduate, Task A only

Team members: Uyiosa Nehikhuere 

## What it does

A simple Flutter signup screen with Name, Email, and Password fields. Each field has a validator. A green SnackBar appears only when all three are valid.

Task A adds a "Get a signup tip" button. It shows a loading spinner, then a preset tip from a fixed list in the app (category: password_help). The result is labeled "Preset demo tip—not live AI." A switch on the screen turns on a local error so the error message and Retry button can be shown. No internet, AI, or server is used, so it works offline.

## Tests I ran

1. Empty fields, press Sign Up: all three error messages show.
2. Email without "@": email error shows.
3. Password under 6 characters: password error shows.
4. Valid name, email, and password: green SnackBar shows.
5. Tap "Get a signup tip": spinner, then a tip with the preset label.
6. Turn on "Simulate tip error", tap the tip button: error message and Retry show. Turn the switch off and tap Retry: a tip shows.

## Reflection: Uyiosa Nehikhuere

Q1. Trace the local tip feature from button tap to displayed text.
Tapping the button calls _getTip, which sets _tipStatus to loading with setState, so the button disables and a spinner shows. After a one second delay, the code reads the list for the fixed category and picks the next tip. It then sets _tipStatus to success and stores the text, and the build method shows that text with the preset label. The widget that changes is the tip area under the buttons, driven by the _tipStatus state.

Q2. Which fixed local category selects the tip, and what form information does the feature leave out?
The category is password_help, stored as a constant in the code. The feature never reads the name, email, or password the user typed, so tips cannot approve a signup or replace the validators.


## Build the APK

    flutter build apk --release

The file is at build/app/outputs/flutter-apk/app-release.apk
