<div align="center">

<br/>

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
<img src="https://img.shields.io/badge/Hive-FFB300?style=for-the-badge&logo=hive&logoColor=white" />
<img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" />

<br/><br/>

</div>

# Foodgo

A beautifully crafted, feature-rich Flutter food delivery app designed from a Figma UI template. Featuring Firebase backend, local caching with Hive, custom burger & pizza builders, spicy level sliders, real-time chat support, favourites, and a smooth checkout flow — all wrapped in a polished, production-grade UI.

---

## Features

**Home & Browsing**
- Branded splash screen with the Foodgo logo
- Home screen with user profile avatar, search bar, and filter button
- Category filter tabs: All, Combos, Sliders, Classic, Customized
- 2-column food grid with item image, name, subtitle, star rating, and favourite toggle

**Food Details**
- Full-screen item detail view with large food image
- Star rating and estimated delivery time
- Item description
- Spicy level slider (Mild → Hot)
- Portion quantity selector (− / +)
- Price display and ORDER NOW button

**Custom Builder (Burger & Pizza)**
- Dedicated customization screen for buildable items
- Spicy level slider and portion counter
- Horizontally scrollable Toppings grid with add/remove toggle per item
- Horizontally scrollable Side options grid with add/remove toggle per item
- Live total price calculation including extras and portion count

**Checkout & Payment**
- Order summary screen showing itemized order, taxes, and delivery fee
- Total and estimated delivery time
- Payment method selection: Credit card (MasterCard) and Debit card (Visa)
- Save card details checkbox
- Pay Now button
- Success dialog with payment confirmation and email receipt notice

**Favourites**
- Dedicated favourites screen showing saved items
- Item count ("X items saved")
- Each item shows image, name, subtitle, rating or CUSTOM badge
- Remove from favourites with trash icon

**Profile**
- Profile screen with header banner and user photo
- Editable fields: Name, Email, Delivery address, Password
- Links to Payment Details and Order History
- Edit Profile and Log Out buttons

**Chat / Support**
- In-app chat screen with support agent
- Message bubbles with timestamps
- User avatar shown on sent messages
- Text input field with send button

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | setState + ChangeNotifier |
| Auth & Cloud | Firebase Authentication + Cloud Firestore |
| Local Storage | Hive (hive_flutter) |
| Preferences | shared_preferences |
| Unique IDs | uuid |

---

## Screenshots

<table>
  <tr>
    <td align="center"><img src="app screenshots/1.jpg" width="220"/></td>
    <td align="center"><img src="app screenshots/2.jpg" width="220"/></td>
    <td align="center"><img src="app screenshots/3.jpg" width="220"/></td>
  </tr>
  <tr>
    <td align="center"><img src="app screenshots/4.jpg" width="220"/></td>
    <td align="center"><img src="app screenshots/5.jpg" width="220"/></td>
    <td align="center"><img src="app screenshots/6.jpg" width="220"/></td>
  </tr>
  <tr>
    <td align="center"><img src="app screenshots/7.jpg" width="220"/></td>
    <td align="center"><img src="app screenshots/8.jpg" width="220"/></td>
    <td align="center"><img src="app screenshots/9.jpg" width="220"/></td>
  </tr>
  <tr>
    <td align="center"><img src="app screenshots/10.jpg" width="220"/></td>
    <td align="center"><img src="app screenshots/11.jpg" width="220"/></td>
    <td align="center"><img src="app screenshots/12.jpg" width="220"/></td>
  </tr>
</table>

---

## Architecture

```
lib/
├── models/          # Hive data models + generated adapters
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart          # Search, category tabs, food grid
│   ├── detail_screen.dart        # Item detail: spicy slider, portion, order
│   ├── custom_builder_screen.dart # Burger/Pizza builder: toppings, sides
│   ├── checkout_screen.dart      # Order summary + payment method
│   ├── favourites_screen.dart    # Saved items list
│   ├── profile_screen.dart       # User profile + settings
│   └── chat_screen.dart          # Support chat
├── widgets/         # Reusable UI components
└── main.dart        # Firebase init, Hive adapters, app entry
```

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.x
- A Firebase project with **Authentication** (Email/Password) and **Firestore** enabled

### Setup

1. **Clone the repository**

```bash
git clone https://github.com/TanvirAhmedCSE/foodgo-figma-to-flutter-food-app.git
cd foodgo-figma-to-flutter-food-app
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Firebase setup**

   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable Email/Password authentication
   - Enable Cloud Firestore
   - Download `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) and place them in the correct platform directories
   - Run `flutterfire configure` or manually add `firebase_options.dart`

4. **Assets**

   Place food images and fonts in `assets/images/` and `assets/fonts/` respectively, then declare them in `pubspec.yaml`:

   ```yaml
   flutter:
     assets:
       - assets/images/
   ```

5. **Run the app**

```bash
flutter run
```

---

## Key Dependencies

```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  firebase_core: ^3.3.0
  cloud_firestore: ^5.2.0
  shared_preferences: ^2.2.2
  uuid: ^4.5.1

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.9
```

---

## Security Notes

- Firebase security rules must be configured before production deployment.
- **Get your own `firebase_options.dart`, `google-services.json`, and `firebase.json` files.** Never commit these to a public repository.

---

## License

This project is open-source and available under the [MIT License](LICENSE).

---

<div align="center">

Made with ❤️ and Flutter by **[TanvirAhmedCSE](https://github.com/TanvirAhmedCSE)**

*If you like this project, give it a ⭐ on GitHub!*

</div>
