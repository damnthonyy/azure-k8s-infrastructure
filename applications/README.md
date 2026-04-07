# Applications

This directory contains the application source code for backend and frontend.

## Structure

```
applications/
├── backend/          # .NET Core Web API
│   └── (Backend source code will go here)
└── frontend/         # Next.js Application
    └── (Frontend source code will go here)
```

## Backend (.NET Core)

The backend is a .NET Core Web API that:
- Connects to Azure PostgreSQL database
- Implements RESTful API endpoints
- Includes health check endpoints
- Sends structured logs to ELK
- Uses Azure Key Vault for secrets

### Local Development

```bash
cd applications/backend
dotnet restore
dotnet build
dotnet run
```

### Tests

```bash
dotnet test
```

## Frontend (Next.js)

The frontend is a Next.js application that:
- Provides server-side rendering
- Connects to backend API
- Implements responsive UI
- Sends logs to ELK
- Uses environment variables for configuration

### Local Development

```bash
cd applications/frontend
npm install
npm run dev
```

### Build

```bash
npm run build
npm start
```

## Docker

Each application has an optimized Dockerfile:
- Multi-stage builds for smaller images
- Non-root user for security
- Health check endpoints
- Layer caching for faster builds

See individual application directories for specific Dockerfiles.

## Environment Variables

Both applications use environment variables for configuration:
- Database connection strings
- API endpoints
- Feature flags
- Secrets (from Key Vault)

Use `.env.local` for local development (gitignored).

## CI/CD

Applications are automatically built and deployed via GitHub Actions:
- Build on PR (validation)
- Deploy to dev on merge to develop
- Deploy to staging on merge to staging
- Deploy to production on merge to main (with approval)
