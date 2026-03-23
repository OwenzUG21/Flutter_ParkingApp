@echo off
echo ========================================
echo Building Database Code Generators
echo ========================================
echo.

echo Step 1: Getting dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Failed to get dependencies
    pause
    exit /b %errorlevel%
)
echo.

echo Step 2: Running build_runner...
call flutter pub run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo ERROR: Build runner failed
    pause
    exit /b %errorlevel%
)
echo.

echo ========================================
echo SUCCESS! Database code generated.
echo ========================================
echo.
echo Generated files:
echo - lib/models/isar/*.g.dart
echo - lib/models/hive/*.g.dart
echo.
echo You can now run your app!
echo.
pause
