# LearnESO - Project Documentation & Guide

A simple, visually appealing Flutter flashcards application designed for personal use to learn English vocabularies, particularly integrated with translating tools using Google Cloud Translation API.

---

## 📱 Platform Support
* **Target Platform:** Android Only (All other platform folders like iOS, Windows, macOS, Linux, and Web have been cleaned up to keep the codebase lightweight and highly focused).

---

## 🛠️ Environment & Setup Requirements
To build and run this project, ensure your computer has the following tools installed and configured in the system `PATH`:

1. **Flutter SDK:** Stable channel (currently built using `3.47.0`).
2. **Java Runtime:** JDK 17 (recommended: *Microsoft Build of OpenJDK 17*).
3. **Android SDK:**
   * **API Level:** 36 (Android 16)
   * **Build-Tools:** 36.0.0
   * **Platform-Tools:** Installed (includes `adb`)
   * **Environment Variable:** `ANDROID_HOME` pointing to your Android SDK root directory (e.g., `C:\AndroidSDK`).

---

## 🔑 Secret & Environment Configuration
The app uses `flutter_dotenv` to handle runtime configuration secrets.
* **File:** `.env` (located in the project root directory, ignored by Git).
* **Variables:**
  ```env
  GOOGLE_TRANSLATION_API_KEY=your_google_cloud_translation_api_key_here
  ```
* **Required Activation:** Ensure that **Cloud Translation API** is enabled in your Google Cloud Project and linked to an active Billing Account (even though it provides a generous monthly free tier).

---

## 🗄️ Database Architecture & Migrations
The local vocabulary database uses SQLite (`sqflite`).

### Schema Overview (Table: `words`)
| Column Name | SQLite Type | Description |
| :--- | :--- | :--- |
| `id` | `INTEGER PRIMARY KEY AUTOINCREMENT` | Auto-incrementing identifier. |
| `original` | `TEXT` | The English word/phrase to translate. |
| `translated` | `TEXT` | The translated Polish word/phrase. |
| `description` | `TEXT` | Optional description or category (defaults to 'słowo'). |
| `priority` | `INTEGER` | Active learning priority level (defaults to 5). |
| `translate_from`| `TEXT` | Source locale (defaults to 'en'). |
| `translate_to` | `TEXT` | Target locale (defaults to 'pl'). |
| `return_at_count`| `INTEGER` | Global question counter milestone when a mastered word should return to the queue (defaults to 0). |

### Migration History
* **v1:** Initial schema creation (no `return_at_count`).
* **v2:** Added `return_at_count` column via standard `onUpgrade` alter table execution (safe schema evolution; user's existing database progress is preserved).

---

## 🧠 Spaced Repetition Algorithm

The application uses an automated priority-based spaced repetition mechanism:
1. **Initial State:** New words are added with a default `priority = 5`.
2. **Wrong Answers:** Adds `+1` to the word's `priority`, increasing its frequency of appearance.
3. **Correct Answers:** Subtracts `-1` from `priority`.
4. **Mastery & Cooldown (The 100-word cycle):**
   * When `priority` reaches `0` (word is successfully guessed), it falls out of the active queue.
   * On dropping to `0`, `return_at_count` is set to `current_total_asked_count + 100`.
5. **Auto-Restoration:**
   * During fetch, the database automatically checks if any mastered words have finished their 100-question cooldown:
     ```sql
     UPDATE words 
     SET priority = 1, return_at_count = 0 
     WHERE priority <= 0 AND return_at_count > 0 AND return_at_count <= currentAskedCount
     ```
   * Restored words return to the learning queue with a low priority (`1`) for a single repetition test.

---

## 💻 Useful Development Commands

### 1. Compile & Build Debug APK
```powershell
flutter build apk --debug
```

### 2. Run / Debug with Hot Reload on Connected Phone
```powershell
flutter run
```

### 3. Deploy APK to Device via ADB
```powershell
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

### 4. Manually Launch App via ADB
```powershell
adb shell am start -n com.example.learneso/com.example.learneso.MainActivity
```
