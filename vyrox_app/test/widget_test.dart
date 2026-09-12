
You are currently on a **commit details page**, which is read-only. That is why there is no place to paste code.

Follow only these steps:

## Step 1 — Return to the files

Tap **Browse files** near the upper-right corner of the page.

## Step 2 — Open the test file

Navigate through:

```text
vyrox_app
  → test
    → widget_test.dart
```

Tap `widget_test.dart`.

## Step 3 — Enter edit mode

On the file page:

1. Tap the **three dots (`…`)** near the top-right of the file.
2. Tap **Edit file**.

If you see a pencil icon instead, tap the pencil.

## Step 4 — Replace the contents

Delete the blank line or any existing content. Paste this exact code:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:vyrox_app/main.dart';

void main() {
  testWidgets('VYROX application launches', (WidgetTester tester) async {
    await tester.pumpWidget(const VyroxApp());
    await tester.pump();

    expect(find.text('VYROX AI'), findsOneWidget);
    expect(find.text('WHAT DO YOU WANT\nTO CREATE?'), findsOneWidget);
  });
}
```

To paste on Android:

1. Tap once inside the editor.
2. Long-press inside the editor.
3. Tap **Paste** from the keyboard menu.

## Step 5 — Commit the file

1. Tap **Commit changes…**
2. Commit message:

```text
Fix VYROX widget test
```

3. Select **Commit directly to the main branch**.
4. Tap the final **Commit changes** button.

## Step 6 — Watch the build

1. Tap **Actions** at the top.
2. Open the newest **Build VYROX Debug APK** run.
3. Wait for it to complete.

Do not change `main.dart` or `pubspec.yaml` right now.

If you cannot find **Edit file** after tapping `widget_test.dart`, send a screenshot of the actual file page—not the commit page—and I will point out the exact button.
