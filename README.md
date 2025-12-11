# CavRideShare

## Backend setup (MySQL + RBAC)

1. Create a database (default name `cavrideshare`).
2. Run the schema to install tables/roles:
   ```sql
   SOURCE cav-rideshare-api/schema.sql;
   ```
   Add password storage for login:
   ```sql
   ALTER TABLE User ADD COLUMN password_hash VARCHAR(255) NOT NULL AFTER phone_number;
   ```
3. Create at least one user:
   - **API option (recommended):** `POST http://localhost:4000/api/auth/signup` with `{ uvaId, password, role }`.
   - **SQL option:** hash the password manually
     ```bash
     node -e "console.log(require('bcryptjs').hashSync('change-me', 10))"
     ```
     ```sql
     INSERT INTO User (uva_id, fname, lname, phone_number, password_hash)
     VALUES ('ab123c','Ava','Kim','8045551234','<hash-from-above>');
     ```
4. Copy environment variables:
   ```bash
   cd cav-rideshare-api
   cp .env.example .env
   # update DB_* values + JWT_SECRET
   ```
5. Start the API:
   ```bash
   npm install
   npm run dev
   ```
   The server listens on `http://localhost:4000` and exposes:
   - `POST /api/auth/signup` – create a user (rider/driver) and receive a JWT immediately
   - `POST /api/auth/login` – returns a JWT + role (for RBAC)
   - `GET /api/trips` – token required (any role)
   - `POST /api/trips` – token + `driver` or `admin` role required

## Frontend setup (Vite React)

```bash
cd cav-rideshare-web
npm install   # already run once; repeat if package-lock changes
npm run dev
```

## Running everything locally

1. **Start MySQL** and ensure the `cavrideshare` DB exists with tables from `cav-rideshare-api/schema.sql`.
2. **Backend**  
   ```bash
   cd cav-rideshare-api
   cp .env.example .env   # only first time
   npm install
   npm run dev
   ```
   The API serves `http://localhost:4000`.
3. **Frontend**  
   ```bash
   cd cav-rideshare-web
   npm install
   npm run dev
   ```
   Vite runs at `http://localhost:5173` and proxies requests to the API URL defined by `VITE_API_BASE_URL`.

Key screens:
- **Home** – hero section plus a “New Trip” button that toggles a trip form. Submitting calls `POST /api/trips` with the JWT that was cached from the Login screen.
- **Login** – posts to `/api/auth/login`, displays the returned JWT, and saves it to `localStorage` for later API calls.
- **Sign Up** – lets you create a rider or driver account using the Express API and immediately stores the returned JWT for testing.

Trip endpoints (CRUD + RBAC):
- `GET /api/trips` – list trips (auth required)
- Optional query parameters on `GET /api/trips` for filtering: `startLocationId`, `arrivalLocationId`, `after`, `before`, `minSeats`
- `POST /api/trips` – create trip (driver/admin, uses `startLocationId`, `arrivalLocationId`, `departureTime`, `seatsAvailable`, `notes`)
- `PUT /api/trips/:tripId` – update trip (driver owner or admin)
- `DELETE /api/trips/:tripId` – delete trip (driver owner or admin)
- `GET /api/locations` – list locations for the trip form

To point the UI at a different backend, create `cav-rideshare-web/.env`:

```
VITE_API_BASE_URL=http://localhost:4000
```

## RBAC flow

1. User submits credentials on `/login`.
2. Backend checks MySQL (`users` table) and issues a JWT with the user’s role claim.
3. The frontend stores the JWT (localStorage, cookie, etc.) and sets the `Authorization: Bearer <token>` header for any privileged requests.
4. Protected routes (`/api/trips`) apply `authenticate` + `authorizeRoles(...)`, ensuring only drivers/admins can create trips.
