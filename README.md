# Bucket Catch Game

COMP-5450 Mobile Programming

A simple 2D Flutter game where the player controls a bucket to catch falling balls and accumulate score.

## Project Structure

```
lib/
├── main.dart                # App entry point
├── components/
│   ├── ball.dart            # Ball rendering and movement
│   └── bucket.dart          # Bucket rendering
├── game/
│   └── bucket_catch_game.dart  # Game logic and mechanics
└── screens/
    ├── splash_screen.dart     # Splash animation before main menu
    ├── main_menu_screen.dart  # Home screen with Play/Exit buttons
    ├── game_screen.dart       # Core gameplay UI
    └── game_over_screen.dart  # Shown when lives run out
```

## How to Run

1. Ensure you have Flutter and Dart installed.
2. Open the project in Android Studio (or another Flutter-supported IDE).
3. Connect an emulator or physical device.
4. Run the app with:

```bash
flutter pub get (to get all current dependencies)
flutter run
```

## Navigate the App

- The app opens with a splash screen that transitions to the main menu.
- From the main menu, you can:
  - Tap **Play** to start the game.
  - Tap **Exit** to close the app (or return).
- After losing all lives, the **Game Over Screen** appears:
  - Tap **Play Again** to restart the game.
  - Tap **Main Menu** to return to the home screen.

## How It Works

- Balls fall from the top at regular intervals.
- You move a bucket left/right by dragging your finger.
- Catching a ball gives you +1 point.
- Missing a ball takes away a life.
- The game ends after 3 missed balls.
- Every 5 points, the ball drop speed increases slightly.
