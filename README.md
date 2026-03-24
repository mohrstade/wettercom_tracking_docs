# wetter.com Tracking Docs

This repository contains the wetter.com tracking documentation site, built with Docusaurus and powered by [docusaurus-plugin-generate-schema-docs](https://www.npmjs.com/package/docusaurus-plugin-generate-schema-docs).

## Repository Structure

```
wettercom_tracking_docs/
├── docs/           # Docusaurus site (tracking documentation)
├── proxy/          # Cloud Run proxy service
├── terraform/      # GCP infrastructure (GCS, load balancer, IAP, Cloud Run)
└── .github/
    └── workflows/  # CI, deploy, and PR commands
```

## Getting Started

Install dependencies and start the local dev server:

```bash
npm install
npm run start
```

## How it Works

The project follows a schema-first approach.

1. **Define a schema:** Create or update a `.json` file in `docs/static/schemas/next/events/`. You can reference shared components from `docs/static/schemas/next/events/components/`.
2. **Generate documentation:** The plugin reads the schemas and generates `.mdx` files in `docs/docs/`.
3. **View the documentation:** The sidebar is automatically updated to include the newly generated docs.

## Available Commands

All commands can be run from the root:

| Command | Description |
|---|---|
| `npm run start` | Start local dev server |
| `npm run build` | Build the static site |
| `npm run gen-docs` | Generate MDX docs from schemas |
| `npm run validate-schemas` | Validate all schemas and examples |
| `npm run lint` | Lint schema files |

## Schema Validation

Schemas are validated automatically in CI. To run locally:

```bash
npm run validate-schemas
```

## Release Process

### Creating a New Version

1. **Make your changes** to the schemas in `docs/static/schemas/next/events/` on a new branch and open a pull request.
2. **Trigger versioning** by commenting on the PR:
   `/release-demo <version>`
   For example: `/release-demo 1.2.0`
3. **CI** will automatically run the versioning command, commit the result back to your branch, and the build will include the new version.
4. **Merge** the pull request. The deploy workflow will push the updated site to GCS.

Alternatively, run the versioning command manually from the `docs/` folder:

```bash
npm run version 1.2.0
```

#### What Versioning Does

The `version-with-schemas` command:

1. Copies `docs/docs/` to `docs/versioned_docs/version-<version>/`
2. Copies `docs/static/schemas/next/` to `docs/static/schemas/<version>/`
3. Updates all `$id` fields in the versioned schemas to include the version number
4. Generates MDX documentation for the new version

#### Directory Structure

```
docs/
├── docs/                           # Current/next version docs (auto-generated)
├── versioned_docs/
│   └── version-1.0.1/             # Versioned docs
├── static/
│   └── schemas/
│       ├── next/                  # Current/next version schemas (source of truth)
│       └── 1.0.1/                 # Versioned schemas
└── versions.json                  # List of all versions
```

### Other Versioning Commands

Update schema IDs for a specific version (useful if the base URL changes):

```bash
npm run update-schema-ids 1.2.0
```

Update schema IDs for all versions:

```bash
npm run update-schema-ids
```
