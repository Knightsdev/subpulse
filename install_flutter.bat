@echo off
echo ========================================
echo   Installing Flutter SDK
echo ========================================

echo.
echo Step 1: Downloading Flutter (may take 2-3 minutes)...
curl -L -o "%USERPROFILE%\Downloads\flutter.zip" "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.0-stable.zip"

echo.
echo Step 2: Extracting to C:\flutter...
powershell -Command "Expand-Archive -Path '%USERPROFILE%\Downloads\flutter.zip' -DestinationPath 'C:\' -Force"

echo.
echo Step 3: Adding to PATH...
setx PATH "%PATH%;C:\flutter\bin"

echo.
echo ========================================
echo   Flutter Installation Complete!
echo ========================================
echo.
echo NOW RESTART VS Code and run these commands:
echo.
echo 1. cd "E:\Laptop data-drive\Laptop data\subpulse"
echo 2. flutter pub get
echo 3. flutter build apk --debug
echo.
pause