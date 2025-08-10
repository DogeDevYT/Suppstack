Suppstack
Stop Guessing. Start Knowing.

Supplement Advisor is a mobile application designed to help users make informed, science-backed decisions about their supplement stack. It cuts through the marketing fluff and social media hype to provide clear, personalized, and unbiased information.

Core Features
Full User Authentication: Secure sign-up, sign-in, and password reset functionality powered by Supabase Auth, including Google OAuth.

Personal Supplement Stack: Users can build and manage their personal list of supplements.

Comprehensive Database Search: Search a massive, real-world database of supplements (powered by the NIH DSLD) to find and add new products to your stack.

Daily Tracking: A "to-do list" style interface on the home page allows users to check off the supplements they've taken each day.

Personalized Details: For each supplement in their stack, users can:

Upload a custom photo of their supplement bottle.

Set and update their personal dosage.

Remove the supplement and its associated reminders.

Push Notification Reminders: A robust, server-side push notification system (using Supabase Edge Functions and Firebase Cloud Messaging) reminds users to take their supplements, even when the app is closed.

Discover News: A dedicated news feed that pulls the latest health and pharmacology headlines from NewsAPI.org.

User Profile: A profile page where users can manage their notification settings and sign out.

Tech Stack
Frontend: Flutter (Dart)

Backend: Supabase (PostgreSQL, Authentication, Storage, Edge Functions)

Push Notifications: Firebase Cloud Messaging (FCM)

News Source: NewsAPI.org

Setup and Installation
To get this project running locally, please follow these steps.

1. Prerequisites
Flutter SDK installed.

An editor like VS Code or Android Studio with the Flutter plugin.

A Supabase project created and ready.

A Firebase project created for push notifications.

An API key from NewsAPI.org.

2. Clone the Repository
git clone <your-repository-url>
cd supplement-advisor

3. Configure Environment Variables
In the root directory of the project, create a file named .env.

Add your secret keys to this file. It should look like this:

SUPABASE_URL=YOUR_SUPABASE_URL
SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
NEWS_API_KEY=YOUR_NEWS_API_KEY
GOOGLE_SERVER_CLIENT_ID=YOUR_GOOGLE_WEB_CLIENT_ID
GOOGLE_IOS_CLIENT_ID=YOUR_GOOGLE_IOS_CLIENT_ID

Add the .env file to your pubspec.yaml assets so Flutter can access it:

flutter:
  assets:
    - .env

Make sure your .gitignore file contains a line for .env to keep your keys secure.

4. Install Dependencies
Run the following command in your terminal from the project's root directory:

flutter pub get

5. Run the App
Make sure you have an emulator running or a physical device connected, then run:

flutter run

Backend Setup
This project relies on a properly configured Supabase backend. This includes:

Specific database tables (supplements, user_stacks, profiles, reminders, dsld_supplements).

Row Level Security (RLS) policies on all tables.

Database functions (add_dsld_supplement_to_stack).

Edge Functions (send-reminder, check-reminders, cleanup-sent-reminders).

A Storage bucket named supplement-images.

Please refer to the SQL and TypeScript files in the project for the exact setup instructions.