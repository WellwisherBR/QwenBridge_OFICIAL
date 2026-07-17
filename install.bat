```bat
@echo off
title QwenProxy Installer

echo === QwenProxy: Instalador y Compilador Automatico ===
echo.

:: 1. Verificar si Node.js esta instalado
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js no esta instalado en este sistema.
    echo Por favor descarga e instala Node.js [Version 20 o superior] desde https://nodejs.org/
    pause
    exit /b
)

:: 2. Instalar dependencias del backend
echo [1/6] Instalando dependencias del backend...
call npm install
if %errorlevel% neq 0 (
    echo [ERROR] Hubo un error al instalar las dependencias del backend.
    pause
    exit /b
)

:: 3. Instalar navegadores de Playwright
echo.
echo [2/6] Instalando motores de Playwright (Chromium)...
call npx playwright install chromium
if %errorlevel% neq 0 (
    echo [ERROR] No se pudo instalar Chromium para Playwright.
    pause
    exit /b
)

call npx playwright install
if %errorlevel% neq 0 (
    echo [ERROR] No se pudieron instalar los componentes de Playwright.
    pause
    exit /b
)

:: 4. Crear archivo .env si no existe
echo.
echo [3/6] Configurando variables de entorno (.env)...
if not exist .env (
    copy .env.example .env >nul
    echo Archivo .env creado a partir de .env.example.
) else (
    echo El archivo .env ya existe, saltando...
)

:: 5. Instalar dependencias y compilar el frontend
echo.
echo [4/6] Instalando dependencias y compilando el frontend...

cd frontend

call npm install
if %errorlevel% neq 0 (
    echo [ERROR] Hubo un error al instalar las dependencias del frontend.
    pause
    exit /b
)

call npm run build
if %errorlevel% neq 0 (
    echo [ERROR] Fallo la compilacion del frontend.
    pause
    exit /b
)

cd ..

:: 6. Compilar el backend
echo.
echo [5/6] Compilando el backend TypeScript...

call npm run build

echo Build finalizado. ErrorLevel=%errorlevel%

if %errorlevel% neq 0 (
    echo [ERROR] Fallo la compilacion del backend.
    pause
    exit /b
)

:: Finalizacion
echo.
echo [6/6] Instalacion completada con exito.
echo.

set /p start_choice="Deseas iniciar el servidor y abrir el panel administrativo ahora? (S/N): "

if /i "%start_choice%"=="S" (
    call npm start
)

echo.
echo Proceso de configuracion terminado. Usa "npm start" para arrancar el servidor en cualquier momento.
pause
```
