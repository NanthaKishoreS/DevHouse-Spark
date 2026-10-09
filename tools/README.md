# Project tools

Run these scripts with the project root as the current directory so their legacy root-relative input/output paths continue to work:

- QA/integration: `python -m tools.qa.run_tests`
- A specific verifier: `python -m tools.qa.verify_imports`
- A legacy maintenance script: `python -m tools.maintenance.<module_name>`
- Scratch experiments: `cd tools/scratch` and run the script directly from that directory.

Scripts in `maintenance/` are historical source-editing utilities. Many overwrite production files and should be reviewed before execution. QA scripts may call a running local server or Supabase; inspect each script before invoking it. Local audit/report artifacts are under the ignored `artifacts/` directory.