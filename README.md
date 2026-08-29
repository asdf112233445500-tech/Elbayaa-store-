# ELBAYAA Store

Flutter e-commerce app for phone accessories with Supabase backend.

## Included
- Arabic RTL storefront
- Product catalog from Supabase
- Product image URLs with loading/error fallback
- Search and categories
- Working cart and checkout
- Orders saved to Supabase
- Admin authentication via Supabase Auth
- Admin dashboard for products and orders
- Product show/hide and delete controls

## Supabase
Run `database.sql` in the Supabase SQL Editor before using the app. Create an admin user in Supabase Auth, then insert/update its row in `admin_profiles` with `is_admin = true`.

## Build
From a Flutter environment:

```bash
flutter pub get
flutter build apk --release
```
