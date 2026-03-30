@echo off
echo ========================================
echo Quick Build Script for Flutter APK
echo ========================================
echo.

echo Choose build type:
echo 1. Debug APK (Fastest - for testing with debugger)
echo 2. Profile APK (Fast - run without debugging)
echo 3. Release APK (Optimized - for distribution)
echo 4. Run with debugging (Fastest - on connected device)
echo 5. Run without debugging (Fast - profile mode on device)
echo.

set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo.
    echo Building Debug APK with split-per-abi...
    flutter build apk --debug --split-per-abi
) else if "%choice%"=="2" (
    echo.
    echo Building Profile APK with split-per-abi...
    flutter build apk --profile --split-per-abi
) else if "%choice%"=="3" (
    echo.
    echo Building Release APK with split-per-abi...
    flutter build apk --release --split-per-abi
) else if "%choice%"=="4" (
    echo.
    echo Running with debugging on connected device...
    flutter run --debug
) else if "%choice%"=="5" (
    echo.
    echo Running without debugging (profile mode) on connected device...
    flutter run --profile
) else (
    echo Invalid choice!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Build Complete!
echo ========================================
pause
