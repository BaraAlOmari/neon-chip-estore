FROM ghcr.io/cirruslabs/flutter:3.24.0 AS build

WORKDIR /app

# Pre-copy pubspec to leverage Docker layer cache for dependencies
COPY pubspec.yaml .
COPY pubspec.lock ./

RUN flutter pub get

# Copy the rest of the project and build for web
COPY . .

RUN flutter build web --release --dart-define=API_BASE_URL=http://localhost:8080/api

FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html

COPY --from=build /app/build/web ./

EXPOSE 80

