@echo off
setlocal

:: --- Configuration ---
set "PROJECT_PATH=C:\Users\kjunwoo23\Documents\Games\TestGame"
set "MCP_SERVER_PATH=C:\Users\kjunwoo23\Documents\GitHub\Project-RPGMV-MCP\rpg-makermv-mcp"
set "PORT=8080"

echo [1/3] Checking for running server on port %PORT%...
netstat -ano | findstr :%PORT% > nul
if %errorlevel% == 0 (
    echo Server is already running on port %PORT%.
) else (
    echo [2/3] Starting local web server...
    cd /d "%PROJECT_PATH%"
    start /min "RPG Maker Server" npx.cmd -y http-server . -p %PORT% -c-1
    timeout /t 3 > nul
)

echo [3/3] Launching TestGame in Chrome Incognito mode...
start chrome --incognito "http://localhost:%PORT%"

echo.
echo Game launched successfully!
echo You can close this window.
pause
