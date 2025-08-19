@echo off
echo Starting WebPrint Agent...
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Node.js is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

REM Check if dependencies are installed
if not exist "node_modules" (
    echo Installing dependencies...
    npm install
    if %errorlevel% neq 0 (
        echo Error: Failed to install dependencies
        pause
        exit /b 1
    )
)

REM Build the project
echo Building project...
npm run build
if %errorlevel% neq 0 (
    echo Error: Build failed
    pause
    exit /b 1
)

REM Start the agent
echo Starting WebPrint Agent...
echo.
echo The agent will be available at: http://127.0.0.1:5123
echo Your API key will be displayed in the console below.
echo.
echo Press Ctrl+C to stop the agent.
echo.

npm run start

pause
