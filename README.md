
# WEARN: Walk & Earn
WEARN is a mobile app that turns daily walking into rewards. It reads your steps from your phone's health data, validates them on the backend, and lets you earn [points / coins] that can be spent at partner merchants.
> Thesis project, B.Sc. Software Engineering, National University of Mongolia (2026)

## Why WEARN?
Many people want to walk more but lack a reason to keep going. WEARN adds a simple incentive: the more you walk, the more you earn. [One sentence about who it is for or what makes it different.]

## What's inside
The repository contains three parts:

| Folder | What it is |
|--------|------------|
| `frontend/mobile` | Flutter app for iOS and Android |
| `backend` | Node.js + Express REST API |
| `dashboard` | React admin and merchant dashboard |

## Features
- **Step tracking:** collects step data from Health Connect (Android) and HealthKit (iOS)
- **Rewards:** [how steps convert into points, daily limits, what users can redeem]
- **Fraud detection:** backend logic that checks step data before rewarding it [e.g. unrealistic step counts]
- **Authentication and roles:** JWT-based login with role-based access control (user, merchant, admin)
- **Admin and merchant dashboard:** web interface with light and dark mode [manage users, rewards, merchants, statistics]
- **Safe point transactions:** balance updates use database transactions (`BEGIN` / `COMMIT` / `ROLLBACK`) and `SELECT ... FOR UPDATE` to avoid inconsistent balances

## Screenshots
| Home | Activity | Rewards | Dashboard |
|------|----------|---------|-----------|
| ![Home](docs/screenshots/home.png) | ![Activity](docs/screenshots/activity.png) | ![Rewards](docs/screenshots/rewards.png) | ![Dashboard](docs/screenshots/dashboard.png) |

## Architecture
```
Flutter app ──HTTPS──► Nginx (reverse proxy, Let's Encrypt SSL)
                          │
                          ▼
                 Node.js + Express API (Docker)
                          │
                          ▼
                 MySQL (DigitalOcean Managed, SSL)

React dashboard ──HTTPS──► same API
```

## Tech Stack
| Component | Technology |
|-----------|------------|
| Mobile client | Flutter (Dart), Health Connect / HealthKit |
| Backend API | Node.js, Express, REST |
| Database | MySQL (DigitalOcean Managed) |
| Admin & merchant dashboard | React 18, Vite |
| Auth & security | JWT, bcrypt password hashing, role-based access control |
| Reverse proxy | Nginx with Let's Encrypt SSL |
| Containers | Docker |
| CI/CD | GitHub Actions: push to Git → build Docker image → push to Docker Hub → deploy to DigitalOcean Droplet |
| Cloud | DigitalOcean (Droplet, Managed MySQL, firewall) |

## Security
- Passwords are hashed with bcrypt
- API is protected with JWT and role checks
- HTTPS everywhere, database connection over SSL
- Firewall allows only HTTP/HTTPS and SSH
- Secrets are stored in GitHub Secrets, not in the repository

## Getting Started

### Backend
```bash
cd backend
cp .env.example .env     # fill in your own values
npm install
npm run dev
```

Or with Docker:
```bash
docker build -t wearn-backend ./backend
docker run -d --name wearn-backend --restart unless-stopped -p 5000:5000 --env-file backend/.env wearn-backend
```

### Dashboard
```bash
cd dashboard
npm install
npm run dev
```

### Mobile app
```bash
cd frontend/mobile
flutter pub get
flutter run
```

Requirements: Node.js [version], Flutter SDK [version], a MySQL database, Android Studio and/or Xcode.

## Environment variables
Copy `.env.example` to `.env`. Never commit the real `.env` file.

```
PORT=5000
DB_HOST=
DB_USER=
DB_PASSWORD=
DB_NAME=
JWT_SECRET=
```

[Adjust to match your real variable names.]

## CI/CD
A GitHub Actions workflow builds the backend Docker image, pushes it to Docker Hub, and deploys it to a DigitalOcean Droplet on every push to `main`.

## Roadmap

- [ ] [Planned feature]
- [ ] [Planned feature]

## Author

**U. Byambabolor**
GitHub: [@wsteria41](https://github.com/wsteria41) | bolor4821@gmail.com
