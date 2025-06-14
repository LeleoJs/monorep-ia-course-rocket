@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

echo Procurando por Python >= 3.10 em C:\Python...

set "BEST_VERSION="
set "BEST_MAJOR="
set "BEST_MINOR="
set "BEST_PATH="

REM Percorre todas as pastas C:\Python\Python*
for /d %%D in (C:\Python\Python*) do (
    if exist "%%D\python.exe" (
        for /f "tokens=2 delims= " %%V in ('"%%D\python.exe" --version 2^>nul') do (
            for /f "tokens=1,2 delims=." %%A in ("%%V") do (
                set "MAJOR=%%A"
                set "MINOR=%%B"
                
                REM Verifica se é Python >= 3.10
                if !MAJOR! GEQ 3 (
                    if !MAJOR! GTR 3 (
                        set "BEST_VERSION=%%V"
                        set "BEST_MAJOR=%%A"
                        set "BEST_MINOR=%%B"
                        set "BEST_PATH=%%D\python.exe"
                    ) else if !MINOR! GEQ 10 (
                        if not defined BEST_PATH (
                            set "BEST_VERSION=%%V"
                            set "BEST_MAJOR=%%A"
                            set "BEST_MINOR=%%B"
                            set "BEST_PATH=%%D\python.exe"
                        ) else (
                            REM Compara versões: pega a maior
                            if %%B GTR !BEST_MINOR! (
                                set "BEST_VERSION=%%V"
                                set "BEST_MAJOR=%%A"
                                set "BEST_MINOR=%%B"
                                set "BEST_PATH=%%D\python.exe"
                            )
                        )
                    )
                )
            )
        )
    )
)

if not defined BEST_PATH (
    echo.
    echo ❌ Nenhuma versão do Python 3.10 ou superior foi encontrada em C:\Python
    exit /b 1
)

echo ✅ Usando Python: !BEST_PATH! (versão !BEST_VERSION!)
echo.

REM Ativa o ambiente virtual se existir, senão cria
if exist venv (
    call venv\Scripts\activate
) else (
    "!BEST_PATH!" -m venv venv
    call venv\Scripts\activate
)

REM Instala dependências
pip install -r requirements.txt


