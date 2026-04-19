@echo off
echo ========================================
echo   Animation Blueprint DSL - Push to GitHub
echo ========================================
echo.

cd /d "%~dp0"

echo [1/2] Checking GitHub connection...
ping -n 1 github.com >nul 2>&1
if errorlevel 1 (
    echo ERROR: Cannot reach GitHub. Check your internet connection.
    pause
    exit /b 1
)

echo [2/2] Pushing to GitHub...
git push -u origin master

if errorlevel 1 (
    echo.
    echo Push failed. Try again later or check your GitHub credentials.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Push successful!
echo ========================================
echo.
echo Next steps:
echo   1. Enable GitHub Pages:
echo      https://github.com/Asukacodes/animation-blueprint-dsl/settings/pages
echo      Source: master branch, / (root)
echo.
echo   2. Take screenshot and save as docs/preview.png
echo.
echo   3. Your demo will be live at:
echo      https://Asukacodes.github.io/animation-blueprint-dsl/editor/
echo.
pause
