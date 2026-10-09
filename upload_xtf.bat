@echo off
cd /d "%~dp0"
if not exist artifacts\reports mkdir artifacts\reports
py -3 tools\qa\upload_xtf.py > artifacts\reports\upload_xtf_console.txt 2>&1
echo DONE > artifacts\reports\upload_xtf_done.txt
