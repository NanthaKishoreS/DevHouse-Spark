m@echo off
cd /d "c:\Users\KAVIYA\Downloads\Latest_Proj_File\Smart India Hacathon 2026 new"
@echo off
cd /d "%~dp0"
if not exist artifacts\reports mkdir artifacts\reports
py -3 tools\qa\run_tests.py > artifacts\reports\test_out.txt 2> artifacts\reports\test_err.txt
echo done
