@echo off
echo Installing dependencies...
npm install
if %errorlevel% neq 0 (
    echo Failed to install dependencies
    pause
    exit /b 1
)

echo Building project...
npm run build
if %errorlevel% neq 0 (
    echo Build failed
    pause
    exit /b 1
)

echo Starting WebPrint Agent...
npm run dev
pause
