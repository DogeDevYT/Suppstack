# 📱 Suppstack
> **Stop Guessing. Start Knowing.**  

![Suppstack Banner](/assets/icon.png)

**Supplement Advisor** is a mobile application that helps users make informed, **science-backed** decisions about their supplement stack.  
It cuts through marketing fluff and social media hype to deliver **clear, personalized, and unbiased** information.

---

## ✨ Core Features

<details>
<summary>🔐 Full User Authentication</summary>

- Secure sign-up, sign-in, and password reset functionality powered by **Supabase Auth**.
- Includes **Google OAuth** login support.

</details>

<details>
<summary>💊 Personal Supplement Stack</summary>

- Build and manage your personalized list of supplements.

</details>

<details>
<summary>🔍 Comprehensive Database Search</summary>

- Search a massive, real-world database of supplements powered by the **NIH DSLD**.
- Easily add new products to your stack.

</details>

<details>
<summary>✅ Daily Tracking</summary>

- A “to-do list” style home page to check off supplements taken each day.

</details>

<details>
<summary>📄 Personalized Details</summary>

For each supplement, users can:
- Upload a **custom photo** of their supplement bottle.
- Set and update **personal dosage**.
- Remove supplements and their reminders.

</details>

<details>
<summary>🔔 Push Notification Reminders</summary>

- Server-side push notifications using **Supabase Edge Functions** and **Firebase Cloud Messaging**.
- Works even when the app is closed.

</details>

<details>
<summary>📰 Discover News</summary>

- Dedicated news feed pulling the latest health & pharmacology headlines from **NewsAPI.org**.

</details>

<details>
<summary>👤 User Profile</summary>

- Manage notification settings and sign out from a central profile page.

</details>

---

## 🛠 Tech Stack

| Area              | Technology |
|-------------------|------------|
| **Frontend**      | Flutter (Dart) |
| **Backend**       | Supabase (PostgreSQL, Auth, Storage, Edge Functions) |
| **Push Notifications** | Firebase Cloud Messaging (FCM) |
| **News Source**   | NewsAPI.org |

---

## 🚀 Setup & Installation

### 1️⃣ Prerequisites
- Flutter SDK installed  
- VS Code / Android Studio with Flutter plugin  
- A **Supabase** project ready  
- A **Firebase** project for push notifications  
- An **API key** from [NewsAPI.org](https://newsapi.org/)  

### 2️⃣ Clone the Repository
```bash
git clone <your-repository-url>
cd supplement-advisor
```

### 3️⃣ Configure Environment Variables
Create a `.env` file in the project root:
```env
SUPABASE_URL=YOUR_SUPABASE_URL
SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
NEWS_API_KEY=YOUR_NEWS_API_KEY
GOOGLE_SERVER_CLIENT_ID=YOUR_GOOGLE_WEB_CLIENT_ID
GOOGLE_IOS_CLIENT_ID=YOUR_GOOGLE_IOS_CLIENT_ID
```

Add `.env` to your `pubspec.yaml` so Flutter can access it:
```yaml
flutter:
  assets:
    - .env
```

Make sure `.gitignore` contains:
```
.env
```

### 4️⃣ Install Dependencies
```bash
flutter pub get
```

### 5️⃣ Run the App
Make sure you have an emulator or connected device, then:
```bash
flutter run
```

---

## 🗄 Backend Setup

The app relies on a **properly configured Supabase backend**:
- **Database Tables:** `supplements`, `user_stacks`, `profiles`, `reminders`, `dsld_supplements`
- **RLS Policies:** Enabled on all tables
- **Database Functions:** `add_dsld_supplement_to_stack`
- **Edge Functions:** `send-reminder`, `check-reminders`, `cleanup-sent-reminders`
- **Storage:** A bucket named `supplement-images`

Refer to the included **SQL** and **TypeScript** setup files for exact configuration details.

---

## 📜 License
This project is licensed under the **MIT License**.

---

### 📌 Notes
- Replace `docs/banner.png` with your own banner image for a polished look.
- Consider adding screenshots of the app in action for better visual appeal.
