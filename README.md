# ELBAYAA Store

Flutter mobile accessories store with Supabase backend.

## Included
- Arabic RTL storefront
- Product listing, search and categories
- Product details
- Shopping cart
- Customer orders
- Supabase database schema in `database.sql`
- Android project files
- GitHub Actions workflow for release APK

## Supabase
1. Open your Supabase SQL Editor.
2. Run `database.sql` once.
3. Confirm the project URL and publishable key in `lib/main.dart`.

## Build APK on GitHub
1. Upload all files to the repository root.
2. Push to `main`, or open **Actions → Build ELBAYAA Store APK → Run workflow**.
3. After the workflow succeeds, open the run and download the artifact named `ELBAYAA-Store-APK`.

The workflow runs `flutter create --platforms=android` on CI to guarantee a valid Android Gradle wrapper before building.
