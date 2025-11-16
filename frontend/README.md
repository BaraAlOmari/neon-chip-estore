Neon Chip E-shop — Flutter Frontend

Responsive desktop UI for the Neon Chip E-store, integrated with the Spring Boot backend.

Prerequisites
- Flutter 3.22+ (desktop enabled)
- Backend running at `http://localhost:8080` (see project root `docker-compose.yml`)

Run (Desktop)
```
cd frontend
flutter create .        # if platform folders are missing
flutter config --enable-windows-desktop --enable-macos-desktop --enable-linux-desktop
flutter pub get
flutter run -d windows   # or macos / linux
```

Optional: override API base URL
```
flutter run --dart-define=API_BASE_URL=http://localhost:8080/api
```

Run (Web, optional)
```
flutter run -d chrome
```

Features
- Product catalog with search, filtering, sorting, and pagination
- Shopping cart with quantity updates and item removal
- Order placement and history view

Code Structure
- `lib/api` — lightweight HTTP client + API facades
- `lib/models` — plain models mirroring backend
- `lib/state` — Provider stores for products, cart, orders
- `lib/pages` — UI pages (products, cart, orders)
- `lib/widgets` — reusable widgets (product cards)

Backend API base is `http://localhost:8080/api` by default. Use `--dart-define=API_BASE_URL=...` to change.

Assets
- Place your logo image at `frontend/assets/logo.png`. The AppBar shows it with a neon glow. If the asset is missing, a chip icon is shown instead.
