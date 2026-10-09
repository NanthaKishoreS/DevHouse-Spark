# TARANG Marine Intelligence Platform

Flask application for marine survey ingestion, sonar/XTF processing, detection review, and cleanup workflows. The established browser portals are standalone HTML pages served from the project root; Flask APIs and those pages use Supabase as the shared data layer.

## Run the Flask application

1. Use Python 3.10 or newer and install the dependencies from `requirements.txt`.
2. Copy `.env.example` to `.env` and configure the Supabase URL/key and a strong `FLASK_SECRET_KEY`. Never commit `.env` or paste its contents into logs/issues.
3. Ensure the `best.pt` model file is present in the project root.
4. Start with `./run.sh` (or run `python app.py` from any working directory). The application listens on port 3000 by default; set `PORT` to override it.
5. Open `http://localhost:3000/login.html`.

The local demo-access mode is enabled by default in `app.py`; set `TARANG_DEMO_MODE=false` for any deployment that must require real Supabase authentication. Do not deploy with the built-in demo signing-key fallback.

## Codebase map

| Path | Responsibility |
| --- | --- |
| `app.py` | Flask application, API routes, authentication/RBAC, file serving, survey workflows |
| `supabase_service.py` | Supabase REST, storage, identity, and persistence integration |
| `xtf_parser.py` | XTF parsing and sonar raster generation |
| `dbscan_service.py`, `tarang_geo.py`, `tarang_status.py`, `txt_metadata_parser.py` | Geospatial and survey-processing helpers |
| `index.html`, `login.html`, and other root HTML files | Existing Flask-served portal pages; keep at root while routes use root-relative URLs |
| `js/`, `assets/`, `static/`, `video/` | Browser scripts and media served by Flask |
| `Simulation/` | Separate Vite/TypeScript 3D simulation app; the Flask server serves its built output at `/simulation/` |
| `frontend/` | Separate React/Vite frontend project. It has its own install/build commands and API proxy; it is not currently the root Flask portal or served by the Flask production routes |
| `tools/qa/` | Endpoint tests, diagnostics, and verification scripts; run modules from the project root, e.g. `python -m tools.qa.run_tests` |
| `tools/maintenance/` | Legacy scripts that patch or regenerate root files. Review each script before running it; run from the project root with `python -m tools.maintenance.<module>` |
| `docs/` | Project guides, implementation notes, and reports |
| `artifacts/` | Local logs, scratch experiments, audit data, and quarantined unclassified files; excluded from version control |
| `outputs/` | Generated uploads, evidence, and processing artifacts; local runtime data, not source |

Root-level HTML, `app.py`, core imported Python modules, model weights, and runtime `outputs/` are deliberately kept in place for compatibility with existing URLs and imports. Avoid moving these without updating Flask routes, browser links, and import paths together.

## Checks

- `python -m compileall -q app.py supabase_service.py xtf_parser.py dbscan_service.py tarang_geo.py txt_metadata_parser.py tools` checks Python syntax.
- `python -m tools.qa.run_tests` runs endpoint checks against a running local server with configured Supabase/demo access. It makes network calls and is not an isolated unit-test suite.
- `cd frontend && npm ci && npm run build` builds the separate React frontend.
- `cd Simulation && npm ci && npm run build` builds the simulation served under `/simulation/`.

## Important wiring notes

- The Flask portal and React frontend are currently parallel UIs. `frontend/vite.config.js` proxies API traffic to Flask in development, but Flask's `/` route serves the root `index.html`, not `frontend/dist`.
- `tools/qa/run_tests.py` is an integration test and needs the backend, model weights, environment configuration, and reachable Supabase service.
- Never add generated logs, tokens, output data, local virtual environments, or `.env` to version control. If any real credentials were committed previously, rotate them in Supabase; adding an ignore rule does not remove an already tracked secret.
- Legacy scripts in `tools/maintenance/` can overwrite source pages or backend code. They are grouped for discoverability, not endorsed for routine execution.
