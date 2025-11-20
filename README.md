# Neon Chip E-Store Application

Computer accessories e‑commerce app. The app exposes a Spring Boot REST API backed by MongoDB and a Flutter desktop/web frontend for browsing products, managing a cart, and placing orders.

## Features

- **Product catalog**
  - Gaming accessories (keyboards, mice, headsets, mouse pads, storage).
  - Images, rich descriptions, categories, prices, and stock.
  - Search, category filter, price filter, and sorting (price, name).
- **Shopping cart**
  - One cart per user (`desktop-user-1` in the demo).
  - Add/remove products, update quantities.
  - Live cart total.
- **Orders**
  - Place an order from the cart.
  - View order history per user.
  - Status tracking: `PENDING`, `SHIPPED`, `DELIVERED`, `CANCELLED`.
- **Neon UI**
  - Neon dark theme, Jersey 25 typography.
  - Responsive layout: side nav on wide screens, bottom nav on mobile.

## Tech Stack

- **Backend**
  - Java 17, Spring Boot 3
  - Spring Web, Spring Data MongoDB
  - MongoDB
- **Frontend**
  - Flutter 3 (desktop + web)
  - Provider for state management
  - `http` for REST integration
- **Containerization**
  - Docker, Docker Compose
  - Nginx (serving Flutter web build)

---

## Running Locally (without Docker)

### Prerequisites

- Java 17 (JDK)
- Maven (or use the included `mvnw` wrapper)
- MongoDB running locally on `mongodb://localhost:27017`
- Flutter 3.x (for frontend)

### 1. Start MongoDB

Ensure MongoDB is running and accessible at:

```text
mongodb://localhost:27017/neon_chip_estore
```

### 2. Run the backend

```bash
cd backend
./mvnw spring-boot:run   # or mvnw.cmd on Windows
```

This starts the API at `http://localhost:8080`. On first run, `NeonChipEstoreRunner` seeds a set of gaming products into MongoDB.

### 3. Run the frontend (desktop or web)

From the repo root:

```bash
cd frontend
flutter pub get
```

#### Desktop

```bash
flutter config --enable-windows-desktop --enable-macos-desktop --enable-linux-desktop
flutter run -d windows   # or macos / linux
```

#### Web

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080/api
```

If you omit `API_BASE_URL`, the default in code is also `http://localhost:8080/api`.

---

## Running with Docker

### Prerequisites

- Docker + Docker Compose (Docker Desktop on Windows/macOS, or Docker Engine on Linux)

### 1. Build and start the stack

From the repo root:

```bash
docker compose up --build
```

This starts:

- `mongo` — MongoDB
- `backend` — Spring Boot API on port `8080`
- `frontend` — Flutter web (built to static assets, served by Nginx) on port `8081`

### 2. Access the app

- Backend API (for debugging):  
  `http://localhost:8080/api/products?page=0&size=20`

- Frontend web UI (recommended entrypoint):  
  `http://localhost:8081`

The containers will also seed products via `NeonChipEstoreRunner` on backend startup if the `products` collection is empty.

### 3. Stopping the stack

```bash
docker compose down
```

Add `-v` if you want to drop MongoDB data:

```bash
docker compose down -v
```

---

## Notes

- CORS is enabled on `/api/**` so Flutter web can call the backend from a different port.
- The demo uses a hard-coded user ID (`desktop-user-1`) for cart and order flows; no authentication layer yet.
