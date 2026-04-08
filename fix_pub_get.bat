@echo off
echo ========================================
echo Flutter Pub Get Fix Script
echo ========================================
echo.

echo Step 1: Stopping Dart/Flutter processes...
taskkill /F /IM dart.exe 2>nul
taskkill /F /IM flutter.exe 2>nul
timeout /t 2 /nobreak >nul

echo.
echo Step 2: Cleaning pub cache and project...
flutter pub cache clean -f
flutter clean

echo.
echo Step 3: Removing lock file...
if exist pubspec.lock del /f pubspec.lock
if exist .dart_tool rmdir /s /q .dart_tool
if exist .packages del /f .packages

echo.
echo Step 4: Repairing pub cache...
flutter pub cache repair

echo.
echo Step 5: Getting dependencies (this should work now)...
flutter pub get --verbose

echo.
echo Step 6: Verifying installation...
flutter pub get

echo.
echo ========================================
echo Pub Get Fixed!
echo If you still have issues, run: flutter doctor -v
echo ========================================
pause
