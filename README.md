# Gold Jewelry E-commerce App

A Flutter UI skeleton for a gold jewelry e-commerce app built with **Clean Architecture** and **MVVM** pattern.

## Architecture

- **Presentation**: Views, ViewModels, Widgets
- **Domain**: Entities, Repository interfaces
- **Data**: Firebase Realtime Database (products), local storage (cart)
- **Core**: Constants, utils, theme, routing

## Features

- Login (Email/Password, Google, Facebook placeholders)
- Register with form validation
- Home with product grid and category filter (Rings, Necklaces, Bracelets)
- Product details with Add to Cart
- Cart with quantity selector and total
- State management with **Riverpod**
- Responsive layout (2 cols mobile, 3 cols tablet)
- Loading placeholders for async data
- Material Design with gold theme

## Run

```bash
flutter pub get
flutter run
```

For Android: ensure `android/` platform exists (`flutter create .` to add if missing).  
For web: `flutter run -d chrome`  
For Linux: `flutter run -d linux`

## Firebase Setup

**Realtime Database** – Expected structure:
- `/categories` – bracelets, necklaces, rings (each: image, name)
- `/products` – prod_1, prod_2, etc. (name, description, price, images, category, etc.)
- `/topProducts` – top_1, top_2, top_3 (product-like objects with id, name, badge, images, etc.)

Database rules:
```json
{
  "rules": {
    "products": { ".read": true },
    "categories": { ".read": true },
    "topProducts": { ".read": true },
    "users": {
      "$userId": {
        "orders": {
          ".read": "auth != null && auth.uid == $userId",
          ".write": "auth != null && auth.uid == $userId"
        }
      }
    }
  }
}
```
