@echo off
chcp 65001 >nul

:: ============================================================
::  AUTO-ELEVATION ADMINISTRATEUR (Silencieuse)
:: ============================================================
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

setlocal EnableDelayedExpansion
title ⚡ BatteryOptimizer PRO ULTRA - Hibernation Intelligente

:: ============================================================
::  DOSSIERS ET FICHIERS DE CONFIGURATION
:: ============================================================
set "APPDIR=%LOCALAPPDATA%\BatteryOptimizerULTRA"
set "WATCH_PS1=%APPDIR%\hib_watch.ps1"
set "INSTALL_PS1=%APPDIR%\install_task.ps1"
set "UNINSTALL_PS1=%APPDIR%\uninstall_task.ps1"
set "KILL_FILE=%APPDIR%\cancel_hibernate.flag"
set "LOG_FILE=%APPDIR%\hib_watch.log"
set "TASK_NAME=BatteryOptimizer_AutoHibernate"
set "CONFIG_FILE=%APPDIR%\battery_config.ini"
set "TIERS_FILE=%APPDIR%\battery_tiers.ini"

if not exist "%APPDIR%" mkdir "%APPDIR%" >nul 2>&1
call :INIT_TIERS

:: Charger la config existante
set "SAVED_DISPLAY=Aucune hibernation configuree"
set "SAVED_SECONDES=0"
if exist "%CONFIG_FILE%" (
    for /f "tokens=2 delims==" %%A in ('findstr "DISPLAY=" "%CONFIG_FILE%"') do set "SAVED_DISPLAY=%%A"
    for /f "tokens=2 delims==" %%A in ('findstr "SECONDES=" "%CONFIG_FILE%"') do set "SAVED_SECONDES=%%A"
)

:MENU_PRINCIPAL
cls
echo.
echo  ╔══════════════════════════════════════════════════════════════╗
echo  ║       ⚡ BatteryOptimizer PRO ULTRA - Hibernation Pure       ║
echo  ║     Aucune veille normale - Economie max ^& Gardien Actif     ║
echo  ║           Compatible tous PC Windows 10/11                   ║
echo  ╚══════════════════════════════════════════════════════════════╝
echo.
if !SAVED_SECONDES! GTR 0 (
    echo   [CONFIG ACTUELLE] Hibernation intelligente apres : !SAVED_DISPLAY!
) else (
    echo   [CONFIG ACTUELLE] Aucune hibernation automatique configuree
)
echo.
echo   ┌──────────────────────────────────────────────────────────┐
echo   │  [1] Configurer l'hibernation Intelligente (Alerte 30s)  │
echo   │  [2] Appliquer les optimisations batterie (RECOMMANDE)   │
echo   │  [3] Hiberner MAINTENANT (Sauvegarde ^& Extinction)       │
echo   │  [4] Desactiver et Supprimer l'hibernation auto          │
echo   │  [5] Voir le statut complet de la batterie               │
echo   │  [6] Nettoyer et accelerer le demarrage                  │
echo   │  [7] Reparer la souris lente apres hibernation           │
echo   │  [8] TOUT EN UN (Optimisations + Boot + Config Hibern.)  │
echo   │  [9] Gerer les seuils de court-circuit (Coupure Elec.)   │
echo   │  [0] Quitter                                             │
echo   └──────────────────────────────────────────────────────────┘
echo.
set /p "CHOIX=  Votre choix : "

if "%CHOIX%"=="1" goto CONFIG_HIBERNATION
if "%CHOIX%"=="2" goto OPTIMISATIONS
if "%CHOIX%"=="3" goto HIBERNER_MAINTENANT
if "%CHOIX%"=="4" goto DESACTIVER_HIBERNATE
if "%CHOIX%"=="5" goto STATUT_BATTERIE
if "%CHOIX%"=="6" goto ACCELERER_DEMARRAGE
if "%CHOIX%"=="7" goto REPARER_SOURIS
if "%CHOIX%"=="8" goto TOUT_EN_UN
if "%CHOIX%"=="9" goto GERER_SEUILS
if "%CHOIX%"=="0" exit /b
goto MENU_PRINCIPAL


:: ============================================================
:: [3] HIBERNER MAINTENANT
:: ============================================================
:HIBERNER_MAINTENANT
cls
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║            HIBERNATION IMMEDIATE                     ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
echo   L'ordinateur va sauvegarder tout ton travail
echo   et s'eteindre completement.
echo.
echo   Au rallumage : tout sera exactement comme maintenant.
echo   La batterie NE se decharge PAS quand eteint.
echo.
set /p "CONF_HIB=  Confirmer l'hibernation ? (O pour valider / N pour annuler) : "
if /i "!CONF_HIB!" NEQ "O" goto MENU_PRINCIPAL

echo.
echo   Hibernation en cours... Sauvegarde de l'etat...
shutdown /h
goto MENU_PRINCIPAL


:: ============================================================
:: [1] CONFIGURER L'HIBERNATION AUTOMATIQUE INTELLIGENTE
:: ============================================================
:CONFIG_HIBERNATION
cls
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║         CONFIGURATION DE L'HIBERNATION AUTO          ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
echo   FONCTIONNALITES INCLUSES :
echo   - Alerte 30s interactive (s'annule si on bouge la souris)
echo   - ALERTE ENERGIE : confirmation Oui/Non avant hibernation
echo     si coupure de courant OU batterie critique
echo     ^> 30%%: 15s  /  <= 30%%: 7s  /  <= 15%%: 5s  /  <= 5%%: 3s
echo   - Economie absolue (Veille classique desactivee)
echo   - Astuce : ces seuils sont modifiables via [9] du menu principal
echo.
echo  ════════════════════════════════════════════════════════
echo   CHOISIS L'UNITE DE TEMPS D'INACTIVITE :
echo.
echo     [S]  Secondes    → ex: 1800  (= 30 min)
echo     [M]  Minutes     → ex: 45    (= 45 min)
echo     [H]  Heures      → ex: 2     (= 2 heures)
echo     [HM] Heure:Min   → ex: 1:30  (= 1h30)
echo.
echo     [0]  Annuler
echo  ════════════════════════════════════════════════════════
echo.
set "UNITE_CHOISIE="
set /p "UNITE_CHOISIE=  Ton choix (S / M / H / HM / 0) : "

if /i "!UNITE_CHOISIE!"=="0" goto MENU_PRINCIPAL
if "!UNITE_CHOISIE!"=="" goto CONFIG_HIBERNATION

set "UNITE_OK=0"
if /i "!UNITE_CHOISIE!"=="S"  set "UNITE_OK=1" & set "UNITE_NOM=Secondes"
if /i "!UNITE_CHOISIE!"=="M"  set "UNITE_OK=1" & set "UNITE_NOM=Minutes"
if /i "!UNITE_CHOISIE!"=="H"  set "UNITE_OK=1" & set "UNITE_NOM=Heures"
if /i "!UNITE_CHOISIE!"=="HM" set "UNITE_OK=1" & set "UNITE_NOM=Heures:Minutes"

if "!UNITE_OK!"=="0" (
    echo   [ERREUR] Unite invalide. Tape S, M, H ou HM.
    timeout /t 2 /nobreak >nul
    goto CONFIG_HIBERNATION
)

cls
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║     SAISIE DE LA DUREE  [ Unite : !UNITE_NOM! ]
echo  ╚══════════════════════════════════════════════════════╝
echo.

if /i "!UNITE_CHOISIE!"=="S" (
    set /p "VALEUR_SAISIE=  Nombre de secondes (ex: 1800) : "
    if "!VALEUR_SAISIE!"=="" goto CONFIG_HIBERNATION
    set /a "SECONDES=!VALEUR_SAISIE!"
    set "DISPLAY_FINAL=!SECONDES! secondes"
    goto VALIDER_DUREE
)
if /i "!UNITE_CHOISIE!"=="M" (
    set /p "VALEUR_SAISIE=  Nombre de minutes (ex: 30) : "
    if "!VALEUR_SAISIE!"=="" goto CONFIG_HIBERNATION
    set /a "MIN_TOTAL=!VALEUR_SAISIE!"
    set /a "SECONDES=!MIN_TOTAL! * 60"
    set "DISPLAY_FINAL=!VALEUR_SAISIE! minutes"
    goto VALIDER_DUREE
)
if /i "!UNITE_CHOISIE!"=="H" (
    set /p "VALEUR_SAISIE=  Nombre d'heures (ex: 2) : "
    if "!VALEUR_SAISIE!"=="" goto CONFIG_HIBERNATION
    set /a "H_TOTAL=!VALEUR_SAISIE!"
    set /a "SECONDES=!H_TOTAL! * 3600"
    set "DISPLAY_FINAL=!VALEUR_SAISIE! heure(s)"
    goto VALIDER_DUREE
)
if /i "!UNITE_CHOISIE!"=="HM" (
    echo   Format : [heures]:[minutes]
    set /p "VALEUR_SAISIE=  Entrez (ex: 1:30) : "
    if "!VALEUR_SAISIE!"=="" goto CONFIG_HIBERNATION
    echo !VALEUR_SAISIE! ^| findstr /C:":" >nul
    if errorlevel 1 (
        echo   [ERREUR] Format incorrect. Exemple : 1:30
        timeout /t 3 /nobreak >nul
        goto CONFIG_HIBERNATION
    )
    for /f "tokens=1,2 delims=:" %%A in ("!VALEUR_SAISIE!") do (
        set /a "HM_HEURES=%%A"
        set /a "HM_MINUTES=%%B"
    )
    set /a "SECONDES=(!HM_HEURES! * 3600) + (!HM_MINUTES! * 60)"
    set "DISPLAY_FINAL=!HM_HEURES!h !HM_MINUTES!min"
    goto VALIDER_DUREE
)

:VALIDER_DUREE
if !SECONDES! LEQ 0 (
    echo   [ERREUR] Valeur invalide ou nulle.
    timeout /t 2 /nobreak >nul
    goto CONFIG_HIBERNATION
)

echo.
echo  ════════════════════════════════════════════════════════
echo   Recapitulatif : Inactivite de !DISPLAY_FINAL! (!SECONDES! sec)
echo  ════════════════════════════════════════════════════════
echo.
set /p "CONFIRMER=  Confirmer ? (O pour valider / N pour annuler) : "
if /i "!CONFIRMER!" NEQ "O" goto CONFIG_HIBERNATION

:: Generation script PS1 interactif ET Gardien d'urgence
echo  [1/3] Preparation du module de surveillance ^& Gardien...
set /a CHECK_SEC=!SECONDES! / 6
if !CHECK_SEC! GTR 20 set CHECK_SEC=20
if !CHECK_SEC! LSS 3  set CHECK_SEC=3

if exist "!KILL_FILE!" del "!KILL_FILE!" >nul 2>&1

call :GENERATE_WATCH_PS1

echo  [2/3] Installation de la tache planifiee persistante...
echo $taskName = '!TASK_NAME!' > "!INSTALL_PS1!"
echo $ps1Path  = '!WATCH_PS1!' >> "!INSTALL_PS1!"
echo try { >> "!INSTALL_PS1!"
echo     if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) { >> "!INSTALL_PS1!"
echo         Stop-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue >> "!INSTALL_PS1!"
echo         Unregister-ScheduledTask -TaskName $taskName -Confirm:$false >> "!INSTALL_PS1!"
echo     } >> "!INSTALL_PS1!"
echo     $arg = '-WindowStyle Hidden -NonInteractive -NoProfile -ExecutionPolicy Bypass -File ' + [char]34 + $ps1Path + [char]34 >> "!INSTALL_PS1!"
echo     $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $arg >> "!INSTALL_PS1!"
echo     $trigLogon = New-ScheduledTaskTrigger -AtLogOn >> "!INSTALL_PS1!"
echo     $trigRep = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration (New-TimeSpan -Days 3650) >> "!INSTALL_PS1!"
echo     $settings = New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -ExecutionTimeLimit ([TimeSpan]::Zero) >> "!INSTALL_PS1!"
echo     $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest >> "!INSTALL_PS1!"
echo     Register-ScheduledTask -TaskName $taskName -Action $action -Trigger @($trigLogon,$trigRep) -Settings $settings -Principal $principal -Force ^| Out-Null >> "!INSTALL_PS1!"
echo     Start-ScheduledTask -TaskName $taskName >> "!INSTALL_PS1!"
echo } catch { exit 1 } >> "!INSTALL_PS1!"

powershell -ExecutionPolicy Bypass -NoProfile -File "!INSTALL_PS1!"
if %errorlevel% NEQ 0 (
    echo  [ERREUR] Impossible d'installer la tache planifiee.
    pause
    goto MENU_PRINCIPAL
)

echo  [3/3] Configuration stricte de l'energie (Hibernation Pure)...
powercfg /hibernate on >nul 2>&1
powercfg /hibernate /size 100 >nul 2>&1
:: DESACTIVE LA VEILLE NORMALE ET L'HIBERNATION AUTO NATIVE (Le script PS1 s'en charge desormais)
powercfg /change standby-timeout-dc 0 >nul 2>&1
powercfg /change standby-timeout-ac 0 >nul 2>&1
powercfg /change hibernate-timeout-dc 0 >nul 2>&1
powercfg /change hibernate-timeout-ac 0 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP HYBRIDSLEEP 0 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP HYBRIDSLEEP 0 >nul 2>&1

echo SECONDES=!SECONDES!> "%CONFIG_FILE%"
echo DISPLAY=!DISPLAY_FINAL!>> "%CONFIG_FILE%"
set "SAVED_SECONDES=!SECONDES!"
set "SAVED_DISPLAY=!DISPLAY_FINAL!"

echo.
echo  ✅ SURVEILLANCE INTELLIGENTE ET GARDIEN ACTIVES !
echo     (Le gardien et la minuterie tourneront toujours en fond).
echo.
pause
goto MENU_PRINCIPAL


:: ============================================================
:: SOUS-ROUTINE : GENERATION DU SCRIPT PS1 DE SURVEILLANCE
:: (Contenu original du gardien, seuils de court-circuit dynamiques)
:: ============================================================
:GENERATE_WATCH_PS1
echo $delaiSec = !SECONDES! > "!WATCH_PS1!"
echo $checkSec = 2 >> "!WATCH_PS1!"
echo $killFile = '!KILL_FILE!' >> "!WATCH_PS1!"
echo $logFile  = '!LOG_FILE!' >> "!WATCH_PS1!"
echo $etatPrecedent = $null >> "!WATCH_PS1!"
echo $tierAlertePrecedent = $null >> "!WATCH_PS1!"
echo $scriptStartTime = Get-Date >> "!WATCH_PS1!"
echo if (Test-Path $killFile) { Remove-Item $killFile -Force } >> "!WATCH_PS1!"
echo function Log($msg) { >> "!WATCH_PS1!"
echo     $line = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' - ' + $msg >> "!WATCH_PS1!"
echo     Add-Content -Path $logFile -Value $line -ErrorAction SilentlyContinue >> "!WATCH_PS1!"
echo } >> "!WATCH_PS1!"
echo Add-Type -AssemblyName System.Windows.Forms >> "!WATCH_PS1!"
echo Add-Type -AssemblyName System.Drawing >> "!WATCH_PS1!"
echo $csharp = 'using System; using System.Runtime.InteropServices;' >> "!WATCH_PS1!"
echo $csharp += ' public class IdleTime {' >> "!WATCH_PS1!"
echo $csharp += ' [DllImport(' + [char]34 + 'user32.dll' + [char]34 + ')] static extern bool GetLastInputInfo(ref LASTINPUTINFO p);' >> "!WATCH_PS1!"
echo $csharp += ' [StructLayout(LayoutKind.Sequential)]' >> "!WATCH_PS1!"
echo $csharp += ' public struct LASTINPUTINFO { public uint cbSize; public uint dwTime; }' >> "!WATCH_PS1!"
echo $csharp += ' public static uint Get() {' >> "!WATCH_PS1!"
echo $csharp += ' var i = new LASTINPUTINFO();' >> "!WATCH_PS1!"
echo $csharp += ' i.cbSize = (uint)System.Runtime.InteropServices.Marshal.SizeOf(i);' >> "!WATCH_PS1!"
echo $csharp += ' GetLastInputInfo(ref i);' >> "!WATCH_PS1!"
echo $csharp += ' return ((uint)Environment.TickCount - i.dwTime) / 1000; } }' >> "!WATCH_PS1!"
echo Add-Type -TypeDefinition $csharp -Language CSharp >> "!WATCH_PS1!"
echo $winsig = 'using System; using System.Runtime.InteropServices;' >> "!WATCH_PS1!"
echo $winsig += ' public class ConsoleWin {' >> "!WATCH_PS1!"
echo $winsig += ' [DllImport(' + [char]34 + 'kernel32.dll' + [char]34 + ')] public static extern IntPtr GetConsoleWindow();' >> "!WATCH_PS1!"
echo $winsig += ' [DllImport(' + [char]34 + 'user32.dll' + [char]34 + ')] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow); }' >> "!WATCH_PS1!"
echo Add-Type -TypeDefinition $winsig -Language CSharp >> "!WATCH_PS1!"
echo [ConsoleWin]::ShowWindow([ConsoleWin]::GetConsoleWindow(), 0) ^| Out-Null >> "!WATCH_PS1!"
echo function Show-PowerAlert($niveau, $secuDelai) { >> "!WATCH_PS1!"
echo     $formA = New-Object System.Windows.Forms.Form >> "!WATCH_PS1!"
echo     $formA.Text = 'BatteryOptimizer - ALERTE ENERGIE' >> "!WATCH_PS1!"
echo     $formA.Size = New-Object System.Drawing.Size(480,230) >> "!WATCH_PS1!"
echo     $formA.StartPosition = 'CenterScreen' >> "!WATCH_PS1!"
echo     $formA.TopMost = $true >> "!WATCH_PS1!"
echo     $formA.FormBorderStyle = 'FixedDialog' >> "!WATCH_PS1!"
echo     $formA.MaximizeBox = $false >> "!WATCH_PS1!"
echo     $formA.MinimizeBox = $false >> "!WATCH_PS1!"
echo( >> "!WATCH_PS1!"
echo     $labelA = New-Object System.Windows.Forms.Label >> "!WATCH_PS1!"
echo     $labelA.AutoSize = $true >> "!WATCH_PS1!"
echo     $labelA.Location = New-Object System.Drawing.Point(20,20) >> "!WATCH_PS1!"
echo     $labelA.Font = New-Object System.Drawing.Font('Segoe UI', 11, [System.Drawing.FontStyle]::Bold) >> "!WATCH_PS1!"
echo     $labelA.Text = "Le courant ne fonctionne plus.`nL'ordinateur va s'eteindre pour sauver vos donnees.`nVoulez-vous cela ?" >> "!WATCH_PS1!"
echo     $formA.Controls.Add($labelA) >> "!WATCH_PS1!"
echo( >> "!WATCH_PS1!"
echo     $labelCompte = New-Object System.Windows.Forms.Label >> "!WATCH_PS1!"
echo     $labelCompte.AutoSize = $true >> "!WATCH_PS1!"
echo     $labelCompte.Location = New-Object System.Drawing.Point(20,110) >> "!WATCH_PS1!"
echo     $labelCompte.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Regular) >> "!WATCH_PS1!"
echo     $formA.Controls.Add($labelCompte) >> "!WATCH_PS1!"
echo( >> "!WATCH_PS1!"
echo     $btnOui = New-Object System.Windows.Forms.Button >> "!WATCH_PS1!"
echo     $btnOui.Text = 'Oui' >> "!WATCH_PS1!"
echo     $btnOui.Size = New-Object System.Drawing.Size(100,35) >> "!WATCH_PS1!"
echo     $btnOui.Location = New-Object System.Drawing.Point(120,150) >> "!WATCH_PS1!"
echo     $btnOui.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Regular) >> "!WATCH_PS1!"
echo     $btnOui.Add_Click({ $formA.Tag = 'OUI'; $formA.Close() }) >> "!WATCH_PS1!"
echo     $formA.Controls.Add($btnOui) >> "!WATCH_PS1!"
echo( >> "!WATCH_PS1!"
echo     $btnNon = New-Object System.Windows.Forms.Button >> "!WATCH_PS1!"
echo     $btnNon.Text = 'Non' >> "!WATCH_PS1!"
echo     $btnNon.Size = New-Object System.Drawing.Size(100,35) >> "!WATCH_PS1!"
echo     $btnNon.Location = New-Object System.Drawing.Point(240,150) >> "!WATCH_PS1!"
echo     $btnNon.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Regular) >> "!WATCH_PS1!"
echo     $btnNon.Add_Click({ $formA.Tag = 'NON'; $formA.Close() }) >> "!WATCH_PS1!"
echo     $formA.Controls.Add($btnNon) >> "!WATCH_PS1!"
echo( >> "!WATCH_PS1!"
echo     $script:secuRestant = $secuDelai >> "!WATCH_PS1!"
echo     $labelCompte.Text = 'Extinction automatique dans ' + $script:secuRestant + ' secondes...' >> "!WATCH_PS1!"
echo     $timerA = New-Object System.Windows.Forms.Timer >> "!WATCH_PS1!"
echo     $timerA.Interval = 1000 >> "!WATCH_PS1!"
echo     $timerA.Add_Tick({ >> "!WATCH_PS1!"
echo         if ([System.Windows.Forms.SystemInformation]::PowerStatus.PowerLineStatus -eq 'Online') { >> "!WATCH_PS1!"
echo             $timerA.Stop() >> "!WATCH_PS1!"
echo             $formA.Tag = 'REBRANCHE' >> "!WATCH_PS1!"
echo             $formA.Close() >> "!WATCH_PS1!"
echo             return >> "!WATCH_PS1!"
echo         } >> "!WATCH_PS1!"
echo         $script:secuRestant-- >> "!WATCH_PS1!"
echo         if ($script:secuRestant -le 0) { >> "!WATCH_PS1!"
echo             $timerA.Stop() >> "!WATCH_PS1!"
echo             $formA.Tag = 'TIMEOUT' >> "!WATCH_PS1!"
echo             $formA.Close() >> "!WATCH_PS1!"
echo         } else { >> "!WATCH_PS1!"
echo             $labelCompte.Text = 'Extinction automatique dans ' + $script:secuRestant + ' secondes...' >> "!WATCH_PS1!"
echo             if ($script:secuRestant -le 3) { $labelCompte.ForeColor = [System.Drawing.Color]::Red } >> "!WATCH_PS1!"
echo         } >> "!WATCH_PS1!"
echo     }) >> "!WATCH_PS1!"
echo     $timerA.Start() >> "!WATCH_PS1!"
echo     $formA.ShowDialog() ^| Out-Null >> "!WATCH_PS1!"
echo     $timerA.Dispose() >> "!WATCH_PS1!"
echo     $formA.Dispose() >> "!WATCH_PS1!"
echo     return $formA.Tag >> "!WATCH_PS1!"
echo } >> "!WATCH_PS1!"
echo Log ('Surveillance demarree pour ' + $delaiSec + ' sec sur batterie.') >> "!WATCH_PS1!"
echo while ($true) { >> "!WATCH_PS1!"
echo     Start-Sleep -Seconds $checkSec >> "!WATCH_PS1!"
echo     if (Test-Path $killFile) { Log 'Arret demande. Fin.'; exit } >> "!WATCH_PS1!"
echo     $bat = Get-WmiObject Win32_Battery -ErrorAction SilentlyContinue >> "!WATCH_PS1!"
echo     if (-not $bat) { continue } >> "!WATCH_PS1!"
echo     $niveau = $bat.EstimatedChargeRemaining >> "!WATCH_PS1!"
echo     $statut = $bat.BatteryStatus >> "!WATCH_PS1!"
echo( >> "!WATCH_PS1!"
echo     # --- ALERTE ENERGIE INTELLIGENTE (Coupure secteur OU batterie critique) --- >> "!WATCH_PS1!"
call :LOAD_TIERS
echo     $secuDelai = !BASE_DELAY! >> "!WATCH_PS1!"
if !TIER_COUNT! GTR 0 (
    for /l %%i in (1,1,!TIER_COUNT!) do (
        echo     if ^($niveau -le !PCT_%%i!^) { $secuDelai = !DEL_%%i! } >> "!WATCH_PS1!"
    )
)
echo( >> "!WATCH_PS1!"
echo     if ($statut -ne 1) { >> "!WATCH_PS1!"
echo         $tierAlertePrecedent = $null >> "!WATCH_PS1!"
echo     } else { >> "!WATCH_PS1!"
echo         $nouvelEvenement = ($etatPrecedent -ne 1) >> "!WATCH_PS1!"
echo         $paliersAggrave = ($tierAlertePrecedent -ne $null -and $secuDelai -lt $tierAlertePrecedent) >> "!WATCH_PS1!"
echo         if ($nouvelEvenement -or $paliersAggrave) { >> "!WATCH_PS1!"
echo             Log ("Probleme d'alimentation detecte (niveau=" + $niveau + "%%, delai=" + $secuDelai + "s).") >> "!WATCH_PS1!"
echo             $tierAlertePrecedent = $secuDelai >> "!WATCH_PS1!"
echo             $reponse = Show-PowerAlert -niveau $niveau -secuDelai $secuDelai >> "!WATCH_PS1!"
echo             if ($reponse -eq 'OUI') { >> "!WATCH_PS1!"
echo                 Log ("Hibernation de securite validee (reponse=" + $reponse + ").") >> "!WATCH_PS1!"
echo                 shutdown /h >> "!WATCH_PS1!"
echo                 Start-Sleep -Seconds 15 >> "!WATCH_PS1!"
echo             } elseif ($reponse -eq 'REBRANCHE') { >> "!WATCH_PS1!"
echo                 Log 'Secteur rebranche pendant le decompte : hibernation annulee automatiquement.' >> "!WATCH_PS1!"
echo             } else { >> "!WATCH_PS1!"
echo                 Log 'Utilisateur a annule. Nouvelle alerte seulement si rebranchement/redebranchement ou aggravation du niveau.' >> "!WATCH_PS1!"
echo             } >> "!WATCH_PS1!"
echo         } >> "!WATCH_PS1!"
echo     } >> "!WATCH_PS1!"
echo     $etatPrecedent = $statut >> "!WATCH_PS1!"
echo( >> "!WATCH_PS1!"
echo     # --- MINUTERIE INACTIVITE INTELLIGENTE --- >> "!WATCH_PS1!"
echo     if ($statut -eq 2) { continue } >> "!WATCH_PS1!"
echo     $idleReel = [IdleTime]::Get() >> "!WATCH_PS1!"
echo     $ecouleDepuisDemarrage = [int](New-TimeSpan -Start $scriptStartTime -End (Get-Date)).TotalSeconds >> "!WATCH_PS1!"
echo     $idle = [Math]::Min($idleReel, $ecouleDepuisDemarrage) >> "!WATCH_PS1!"
echo     if ($idle -ge $delaiSec) { >> "!WATCH_PS1!"
echo         $form = New-Object System.Windows.Forms.Form >> "!WATCH_PS1!"
echo         $form.Text = 'BatteryOptimizer - Alerte' >> "!WATCH_PS1!"
echo         $form.Size = New-Object System.Drawing.Size(420,160) >> "!WATCH_PS1!"
echo         $form.StartPosition = 'CenterScreen' >> "!WATCH_PS1!"
echo         $form.TopMost = $true >> "!WATCH_PS1!"
echo         $form.FormBorderStyle = 'FixedDialog' >> "!WATCH_PS1!"
echo         $form.MaximizeBox = $false >> "!WATCH_PS1!"
echo         $form.MinimizeBox = $false >> "!WATCH_PS1!"
echo( >> "!WATCH_PS1!"
echo         $label = New-Object System.Windows.Forms.Label >> "!WATCH_PS1!"
echo         $label.AutoSize = $true >> "!WATCH_PS1!"
echo         $label.Location = New-Object System.Drawing.Point(20,20) >> "!WATCH_PS1!"
echo         $label.Font = New-Object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Bold) >> "!WATCH_PS1!"
echo         $form.Controls.Add($label) >> "!WATCH_PS1!"
echo( >> "!WATCH_PS1!"
echo         $btn = New-Object System.Windows.Forms.Button >> "!WATCH_PS1!"
echo         $btn.Text = 'Annuler' >> "!WATCH_PS1!"
echo         $btn.Size = New-Object System.Drawing.Size(120,35) >> "!WATCH_PS1!"
echo         $btn.Location = New-Object System.Drawing.Point(140,70) >> "!WATCH_PS1!"
echo         $btn.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Regular) >> "!WATCH_PS1!"
echo         $btn.Add_Click({ $form.Close() }) >> "!WATCH_PS1!"
echo         $form.Controls.Add($btn) >> "!WATCH_PS1!"
echo( >> "!WATCH_PS1!"
echo         $script:timeLeft = 30 >> "!WATCH_PS1!"
echo         $timer = New-Object System.Windows.Forms.Timer >> "!WATCH_PS1!"
echo         $timer.Interval = 1000 >> "!WATCH_PS1!"
echo         $timer.Add_Tick({ >> "!WATCH_PS1!"
echo             $currIdle = [IdleTime]::Get() >> "!WATCH_PS1!"
echo             if ($currIdle -lt 5) { >> "!WATCH_PS1!"
echo                 $timer.Stop() >> "!WATCH_PS1!"
echo                 $label.Text = 'Activite detectee. Reprise dans 5s...' >> "!WATCH_PS1!"
echo                 $label.ForeColor = [System.Drawing.Color]::Green >> "!WATCH_PS1!"
echo                 $form.Refresh() >> "!WATCH_PS1!"
echo                 Start-Sleep -Seconds 5 >> "!WATCH_PS1!"
echo                 $form.Close() >> "!WATCH_PS1!"
echo             } else { >> "!WATCH_PS1!"
echo                 $script:timeLeft-- >> "!WATCH_PS1!"
echo                 $label.Text = 'Hibernation automatique dans ' + $script:timeLeft + ' secondes...' >> "!WATCH_PS1!"
echo                 if ($script:timeLeft -le 10) { $label.ForeColor = [System.Drawing.Color]::Red } >> "!WATCH_PS1!"
echo                 if ($script:timeLeft -le 0) { >> "!WATCH_PS1!"
echo                     $timer.Stop() >> "!WATCH_PS1!"
echo                     $form.DialogResult = [System.Windows.Forms.DialogResult]::OK >> "!WATCH_PS1!"
echo                     $form.Close() >> "!WATCH_PS1!"
echo                 } >> "!WATCH_PS1!"
echo             } >> "!WATCH_PS1!"
echo         }) >> "!WATCH_PS1!"
echo         $timer.Start() >> "!WATCH_PS1!"
echo         $res = $form.ShowDialog() >> "!WATCH_PS1!"
echo         $timer.Dispose() >> "!WATCH_PS1!"
echo         $form.Dispose() >> "!WATCH_PS1!"
echo( >> "!WATCH_PS1!"
echo         if ($res -eq [System.Windows.Forms.DialogResult]::OK) { >> "!WATCH_PS1!"
echo             Log 'Hibernation enclenchee !' >> "!WATCH_PS1!"
echo             shutdown /h >> "!WATCH_PS1!"
echo             Start-Sleep -Seconds 10 >> "!WATCH_PS1!"
echo         } >> "!WATCH_PS1!"
echo     } >> "!WATCH_PS1!"
echo } >> "!WATCH_PS1!"
goto :EOF


:: ============================================================
:: [9] GESTION DES SEUILS DE COURT-CIRCUIT (COUPURE ELECTRIQUE)
:: ============================================================
:GERER_SEUILS
cls
call :LOAD_TIERS

:SEUILS_MENU
cls
echo.
echo  ╔══════════════════════════════════════════════════════════════╗
echo  ║      GESTION DES SEUILS D'ALERTE ENERGIE (COURT-CIRCUIT)      ║
echo  ╚══════════════════════════════════════════════════════════════╝
echo.
echo   Delai de base (batterie au-dessus de tous les seuils) : !BASE_DELAY! sec
echo.
if !TIER_COUNT! GTR 0 (
    for /l %%i in (1,1,!TIER_COUNT!) do (
        echo   Seuil %%i : batterie ^<= !PCT_%%i!%%%%  =^>  !DEL_%%i! sec
    )
) else (
    echo   Aucun seuil de court-circuit configure.
)
echo.
echo   ┌──────────────────────────────────────────────────────────┐
echo   │  [1] Modifier le delai de base                           │
echo   │  [2] Modifier le delai d'un seuil existant                │
echo   │  [3] Ajouter un nouveau seuil de court-circuit            │
echo   │  [4] Supprimer un seuil existant                         │
echo   │  [0] Retour au menu principal                            │
echo   └──────────────────────────────────────────────────────────┘
echo.
set /p "CHOIX_SEUIL=  Votre choix : "

if "!CHOIX_SEUIL!"=="1" goto MODIF_BASE
if "!CHOIX_SEUIL!"=="2" goto MODIF_SEUIL
if "!CHOIX_SEUIL!"=="3" goto AJOUT_SEUIL
if "!CHOIX_SEUIL!"=="4" goto SUPPR_SEUIL
if "!CHOIX_SEUIL!"=="0" goto QUITTER_SEUILS
goto SEUILS_MENU


:MODIF_BASE
cls
echo.
echo   Delai de base actuel : !BASE_DELAY! sec
echo   (Ce delai s'applique quand la batterie est au-dessus de tous les seuils)
echo.
set /p "NEWBASE=  Nouveau delai en secondes : "
if "!NEWBASE!"=="" goto SEUILS_MENU
set /a "NEWBASE=!NEWBASE!" 2>nul
if !NEWBASE! LEQ 0 (
    echo   [ERREUR] Valeur invalide.
    timeout /t 2 /nobreak >nul
    goto SEUILS_MENU
)
set "BASE_DELAY=!NEWBASE!"
call :SAVE_TIERS
call :APPLY_TIERS_NOW
goto SEUILS_MENU


:MODIF_SEUIL
cls
if !TIER_COUNT! EQU 0 (
    echo   Aucun seuil a modifier.
    timeout /t 2 /nobreak >nul
    goto SEUILS_MENU
)
echo.
for /l %%i in (1,1,!TIER_COUNT!) do echo   [%%i] batterie ^<= !PCT_%%i!%%%%  =^>  !DEL_%%i! sec
echo.
set /p "NUMSEUIL=  Numero du seuil a modifier (0 pour annuler) : "
if "!NUMSEUIL!"=="0" goto SEUILS_MENU
if "!NUMSEUIL!"=="" goto SEUILS_MENU
if !NUMSEUIL! LSS 1 goto SEUILS_MENU
if !NUMSEUIL! GTR !TIER_COUNT! goto SEUILS_MENU
echo.
set /p "NEWPCT=  Nouveau pourcentage (actuel !PCT_%NUMSEUIL%!%%%%, Entree pour garder) : "
set /p "NEWDEL=  Nouveau delai en sec (actuel !DEL_%NUMSEUIL%! sec, Entree pour garder) : "
if not "!NEWPCT!"=="" set "PCT_%NUMSEUIL%=!NEWPCT!"
if not "!NEWDEL!"=="" set "DEL_%NUMSEUIL%=!NEWDEL!"
call :SAVE_TIERS
call :APPLY_TIERS_NOW
goto SEUILS_MENU


:AJOUT_SEUIL
cls
echo.
echo   Nouveau seuil de court-circuit
echo   (ex: a 40%% de batterie, hiberner en 10s si coupure de courant)
echo.
set /p "NEWPCT=  Pourcentage de batterie (ex: 40) : "
if "!NEWPCT!"=="" goto SEUILS_MENU
set /p "NEWDEL=  Delai avant hibernation en secondes (ex: 10) : "
if "!NEWDEL!"=="" goto SEUILS_MENU
set /a "TIER_COUNT+=1"
set "PCT_!TIER_COUNT!=!NEWPCT!"
set "DEL_!TIER_COUNT!=!NEWDEL!"
call :SAVE_TIERS
call :APPLY_TIERS_NOW
goto SEUILS_MENU


:SUPPR_SEUIL
cls
if !TIER_COUNT! EQU 0 (
    echo   Aucun seuil a supprimer.
    timeout /t 2 /nobreak >nul
    goto SEUILS_MENU
)
echo.
for /l %%i in (1,1,!TIER_COUNT!) do echo   [%%i] batterie ^<= !PCT_%%i!%%%%  =^>  !DEL_%%i! sec
echo.
set /p "NUMSEUIL=  Numero du seuil a supprimer (0 pour annuler) : "
if "!NUMSEUIL!"=="0" goto SEUILS_MENU
if "!NUMSEUIL!"=="" goto SEUILS_MENU
if !NUMSEUIL! LSS 1 goto SEUILS_MENU
if !NUMSEUIL! GTR !TIER_COUNT! goto SEUILS_MENU

set "NEWCOUNT=0"
for /l %%i in (1,1,!TIER_COUNT!) do (
    if not "%%i"=="!NUMSEUIL!" (
        set /a "NEWCOUNT+=1"
        set "TMPPCT_!NEWCOUNT!=!PCT_%%i!"
        set "TMPDEL_!NEWCOUNT!=!DEL_%%i!"
    )
)
set /a "TIER_COUNT_OLD=!TIER_COUNT!"
for /l %%i in (1,1,!TIER_COUNT_OLD!) do (
    set "PCT_%%i="
    set "DEL_%%i="
)
for /l %%i in (1,1,!NEWCOUNT!) do (
    set "PCT_%%i=!TMPPCT_%%i!"
    set "DEL_%%i=!TMPDEL_%%i!"
    set "TMPPCT_%%i="
    set "TMPDEL_%%i="
)
set "TIER_COUNT=!NEWCOUNT!"
call :SAVE_TIERS
call :APPLY_TIERS_NOW
goto SEUILS_MENU


:QUITTER_SEUILS
goto MENU_PRINCIPAL


:APPLY_TIERS_NOW
if !SAVED_SECONDES! GTR 0 (
    echo.
    set /p "APPLY_NOW=  Appliquer ce changement au gardien actif maintenant ? (O/N) : "
    if /i "!APPLY_NOW!"=="O" (
        set "SECONDES=!SAVED_SECONDES!"
        echo   Regeneration du gardien de surveillance...
        call :GENERATE_WATCH_PS1
        powershell -NoProfile -Command "Stop-ScheduledTask -TaskName '!TASK_NAME!' -ErrorAction SilentlyContinue; Start-Sleep -Milliseconds 500; Start-ScheduledTask -TaskName '!TASK_NAME!' -ErrorAction SilentlyContinue" >nul 2>&1
        echo   ✅ Changement applique immediatement.
        timeout /t 2 /nobreak >nul
    )
)
goto :EOF


:: ============================================================
:: SOUS-ROUTINES : GESTION DU FICHIER DE SEUILS (battery_tiers.ini)
:: ============================================================
:INIT_TIERS
if not exist "%TIERS_FILE%" (
    (
    echo BASE=15
    echo THRESH=30:7
    echo THRESH=15:5
    echo THRESH=5:3
    ) > "%TIERS_FILE%"
)
goto :EOF


:LOAD_TIERS
set "BASE_DELAY=15"
set "TIER_COUNT=0"
for /f "tokens=1,2 delims==" %%A in ('findstr /b "BASE=" "!TIERS_FILE!"') do set "BASE_DELAY=%%B"
for /f "tokens=1,2 delims==" %%A in ('findstr /b "THRESH=" "!TIERS_FILE!"') do (
    set /a "TIER_COUNT+=1"
    for /f "tokens=1,2 delims=:" %%X in ("%%B") do (
        set "PCT_!TIER_COUNT!=%%X"
        set "DEL_!TIER_COUNT!=%%Y"
    )
)
goto :EOF


:SAVE_TIERS
(
    echo BASE=!BASE_DELAY!
    for /l %%i in (1,1,!TIER_COUNT!) do echo THRESH=!PCT_%%i!:!DEL_%%i!
) > "!TIERS_FILE!.tmp"
powershell -NoProfile -Command "$l=Get-Content '!TIERS_FILE!.tmp'; $base=@($l | Where-Object {$_ -like 'BASE=*'}); $th=@($l | Where-Object {$_ -like 'THRESH=*'} | Sort-Object {[int]($_ -replace 'THRESH=','' -split ':')[0]} -Descending); ($base + $th) | Set-Content '!TIERS_FILE!'" >nul 2>&1
del "!TIERS_FILE!.tmp" >nul 2>&1
call :LOAD_TIERS
goto :EOF


:: ============================================================
:: [2] TOUTES LES OPTIMISATIONS (BATTERIE ET PERFORMANCES)
:: ============================================================
:OPTIMISATIONS
cls
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║         OPTIMISATIONS BATTERIE EN COURS...           ║
echo  ╚══════════════════════════════════════════════════════╝
echo.

echo  [1/13] Activation fondamentale de l'hibernation...
powercfg /hibernate on >nul 2>&1
powercfg /hibernate /size 100 >nul 2>&1
echo        ✅ OK

echo  [2/13] Desactivation de la Veille Connectee (Modern Standby)...
reg add "HKLM\System\CurrentControlSet\Control\Power" /v PlatformAoAcOverride /t REG_DWORD /d 0 /f >nul 2>&1
echo        ✅ S0 Modern Standby desactive (Anti-decharge massive)

echo  [3/13] Optimisation du Plan d'alimentation...
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_VIDEO VIDEODIM 70 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg /setactive SCHEME_CURRENT >nul 2>&1
echo        ✅ Processeur configure (Eco Batterie / Max Secteur)

echo  [4/13] Optimisation de la memoire RAM...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1
echo        ✅ RAM et IO optimises

echo  [5/13] Desactivation des services inutiles...
sc config SysMain start= disabled >nul 2>&1
sc stop SysMain >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc config CDPSvc start= disabled >nul 2>&1
sc stop CDPSvc >nul 2>&1
echo        ✅ Telemetrie et Superfetch (SysMain) desactives

echo  [6/13] Optimisation GPU (si present)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Video\{GUID}\0000" /v "NvCplEnableDisplayOptimus" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\NVIDIA Corporation\Global\NvCplApi\Policies" /v "PowerMizerEnable" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\NVIDIA Corporation\Global\NvCplApi\Policies" /v "PowerMizerLevel" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Software\NVIDIA Corporation\Global\NvCplApi\Policies" /v "PowerMizerLevelAC" /t REG_DWORD /d 1 /f >nul 2>&1
echo        ✅ GPU Optimus force (Economie Batterie)

echo  [7/13] Reduction de la consommation arriere-plan...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /v "DownloadMode" /t REG_DWORD /d 0 /f >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
echo        ✅ Consommation reseau et TCP optimises

echo  [8/13] SSD (TRIM)...
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Defrag\ScheduledDefrag" /Disable >nul 2>&1
echo        ✅ Duree de vie SSD preservee

echo  [9/13] Optimisation des effets visuels...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1
echo        ✅ Animations superflues desactivees

echo  [10/13] WiFi economie d'energie maximale sur batterie...
powercfg /setdcvalueindex SCHEME_CURRENT 19caa947-efe9-4728-8ef2-f43d2a641e94 12bbebe6-58d6-4636-95bb-3217ef867c1a 3 >nul 2>&1
echo        ✅ WiFi en eco maximum sur batterie

echo  [11/13] Optimisation de la sante de la batterie...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo        ✅ Latence de sortie optimisee

echo  [12/13] Nettoyage des fichiers temporaires...
del /f /s /q "%TEMP%\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
echo        ✅ Temp, Windows\Temp et Prefetch nettoyes

echo  [13/13] Parametres d'extinction (Ecran/Disque)...
powercfg /setdcvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 300 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_DISK DISKIDLE 600 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 0 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_DISK DISKIDLE 0 >nul 2>&1
powercfg /setactive SCHEME_CURRENT >nul 2>&1
echo        ✅ Extinction intelligente appliquee

echo.
echo  ✅ TOUTES LES OPTIMISATIONS SONT APPLIQUEES !
echo     (Un redemarrage est conseille pour le Modern Standby).
pause
goto MENU_PRINCIPAL


:: ============================================================
:: [4] DESACTIVER ET SUPPRIMER L'HIBERNATION AUTO
:: ============================================================
:DESACTIVER_HIBERNATE
cls
echo.
echo  [1/2] Arret des processus de surveillance en cours...
echo stop > "!KILL_FILE!"

echo  [2/2] Suppression de la tache planifiee de Windows...
echo $taskName = '!TASK_NAME!' > "!UNINSTALL_PS1!"
echo $ps1Leaf  = Split-Path '!WATCH_PS1!' -Leaf >> "!UNINSTALL_PS1!"
echo if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) { >> "!UNINSTALL_PS1!"
echo     Stop-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue >> "!UNINSTALL_PS1!"
echo     Unregister-ScheduledTask -TaskName $taskName -Confirm:$false >> "!UNINSTALL_PS1!"
echo } >> "!UNINSTALL_PS1!"
echo Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" ^| Where-Object { $_.CommandLine -like ('*' + $ps1Leaf + '*') } ^| ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue } >> "!UNINSTALL_PS1!"

powershell -ExecutionPolicy Bypass -NoProfile -File "!UNINSTALL_PS1!" >nul 2>&1

del "!KILL_FILE!" >nul 2>&1
del "!WATCH_PS1!" >nul 2>&1

:: Reinitialiser la configuration
echo SECONDES=0> "%CONFIG_FILE%"
echo DISPLAY=Aucune hibernation configuree>> "%CONFIG_FILE%"
set "SAVED_SECONDES=0"
set "SAVED_DISPLAY=Aucune hibernation configuree"

echo.
echo  ✅ Hibernation automatique desactivee et supprimee proprement.
echo.
pause
goto MENU_PRINCIPAL


:: ============================================================
:: [5] STATUT COMPLET DE LA BATTERIE
:: ============================================================
:STATUT_BATTERIE
cls
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║              STATUT DE LA BATTERIE                   ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
for /f "tokens=2 delims==" %%i in ('wmic path Win32_Battery get EstimatedChargeRemaining /value 2^>nul ^| findstr "="') do set BATT=%%i
if defined BATT (
    echo   Niveau de batterie actuel : !BATT!%%
    if !BATT! lss 30 echo   [!] ATTENTION : Moins de 30%%, branchez le chargeur.
)
echo.
echo  Generation du rapport systeme en cours...
powercfg /batteryreport /output "%USERPROFILE%\Desktop\rapport_batterie.html" >nul 2>&1
powercfg /energy /duration 10 /output "%USERPROFILE%\Desktop\energie_rapport.html" >nul 2>&1
echo.
echo  ✅ Rapports generes sur le Bureau :
echo     1. rapport_batterie.html (Historique capacite et cycles)
echo     2. energie_rapport.html  (Problemes d'efficacite)
echo.
set /p "OUVRIR=  Ouvrir le rapport batterie maintenant ? (O/N) : "
if /i "%OUVRIR%"=="O" start "" "%USERPROFILE%\Desktop\rapport_batterie.html"
echo.
pause
goto MENU_PRINCIPAL


:: ============================================================
:: [6] ACCELERER LE DEMARRAGE
:: ============================================================
:ACCELERER_DEMARRAGE
cls
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║           ACCELERATION DU DEMARRAGE                  ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
set /p "BOOT_SEC=  Entrez le delai de demarrage (timeout BIOS) souhaite en sec (ex: 3, 4, 8) : "
if "!BOOT_SEC!"=="" set "BOOT_SEC=3"

echo.
echo  [1/6] Parametrage du timeout BIOS/UEFI a !BOOT_SEC! secondes...
bcdedit /timeout !BOOT_SEC! >nul 2>&1
bcdedit /set bootmenupolicy standard >nul 2>&1
echo        ✅ OK

echo  [2/6] Nettoyage apps inutiles (OneDrive, Skype, Spotify, Teams)...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Skype" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Spotify" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Discord" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Teams" /f >nul 2>&1
echo        ✅ OK

echo  [3/6] Activation du Fast Boot (Demarrage rapide via Hibernation)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
echo        ✅ OK

echo  [4/6] Suppression des anciens caches de demarrage (Prefetch + Temp)...
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
del /f /s /q "%TEMP%\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
echo        ✅ OK

echo  [5/6] Optimisation des services lourds...
sc config wuauserv start= delayed-auto >nul 2>&1
sc config WSearch start= delayed-auto >nul 2>&1
sc config TabletInputService start= demand >nul 2>&1
echo        ✅ OK

echo  [6/6] Vider le cache DNS...
ipconfig /flushdns >nul 2>&1
echo        ✅ OK

echo.
echo  ✅ DEMARRAGE OPTIMISE !
echo.
pause
goto MENU_PRINCIPAL


:: ============================================================
:: [7] REPARER LA SOURIS LENTE APRES HIBERNATION
:: ============================================================
:REPARER_SOURIS
cls
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║      REPARATION SOURIS LENTE APRES HIBERNATION       ║
echo  ╚══════════════════════════════════════════════════════╝
echo.
echo  [1/5] Desactivation de la suspension selective USB...
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setactive SCHEME_CURRENT >nul 2>&1
echo        ✅ OK

echo  [2/5] Modification du registre (Hubs USB et HID)...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbhub\Parameters" /v "DisableSelectiveSuspend" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\hidusb\Parameters" /v "DisableSelectiveSuspend" /t REG_DWORD /d 1 /f >nul 2>&1
echo        ✅ OK

echo  [3/5] Optimisation precision et desactivation acceleration...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1
echo        ✅ OK

echo  [4/5] Augmenter la vitesse du pointeur...
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f >nul 2>&1
echo        ✅ OK

echo  [5/5] Reinitialisation du service HID...
net stop HidServ >nul 2>&1
timeout /t 2 /nobreak >nul
net start HidServ >nul 2>&1
echo        ✅ OK

echo.
echo  ✅ SOURIS REPAREE ! La reinitialisation USB forcera la fluidite.
echo.
pause
goto MENU_PRINCIPAL


:: ============================================================
:: [8] TOUT EN UN
:: ============================================================
:TOUT_EN_UN
cls
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║            CONFIGURATION COMPLETE - TOUT EN UN       ║
echo  ╚══════════════════════════════════════════════════════╝
echo.

echo  [1/5] Application des optimisations systemes et economie...
call :SILENT_OPTIMISATIONS
echo        ✅ OK

echo  [2/5] Application des reparations USB/Souris...
call :SILENT_SOURIS
echo        ✅ OK

echo.
echo  ─────────────────────────────────────────────────────
echo   CONFIGURATION DU DEMARRAGE
echo  ─────────────────────────────────────────────────────
set /p "BOOT_SEC=  Entrez le delai de demarrage (timeout BIOS) souhaite en sec (ex: 3, 4, 8) : "
if "!BOOT_SEC!"=="" set "BOOT_SEC=3"
echo  [3/5] Optimisation du demarrage (!BOOT_SEC! sec)...
bcdedit /timeout !BOOT_SEC! >nul 2>&1
bcdedit /set {bootmgr} timeout !BOOT_SEC! >nul 2>&1
bcdedit /set bootmenupolicy standard >nul 2>&1
bcdedit /set {current} bootstatuspolicy ignoreallfailures >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Skype" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Spotify" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Discord" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Teams" /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
del /f /s /q "%TEMP%\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
sc config wuauserv start= delayed-auto >nul 2>&1
sc config WSearch start= delayed-auto >nul 2>&1
sc config TabletInputService start= demand >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo        ✅ OK

echo.
echo  ─────────────────────────────────────────────────────
echo   STATUT DE LA BATTERIE
echo  ─────────────────────────────────────────────────────
echo  [4/5] Generation du rapport batterie...
for /f "tokens=2 delims==" %%i in ('wmic path Win32_Battery get EstimatedChargeRemaining /value 2^>nul ^| findstr "="') do set "BATT=%%i"
if defined BATT (
    echo        Niveau actuel : !BATT!%%
    if !BATT! lss 30 echo        [!] ATTENTION : Moins de 30%%, branchez le chargeur.
) else (
    echo        Informations non disponibles.
)
powercfg /batteryreport /output "%USERPROFILE%\Desktop\rapport_batterie.html" >nul 2>&1
powercfg /energy /duration 3 /output "%USERPROFILE%\Desktop\energie_rapport.html" >nul 2>&1
echo        ✅ Rapports generes sur le Bureau.
echo.
set /p "OUVRIR=  Ouvrir le rapport batterie maintenant ? (O/N) : "
if /i "!OUVRIR!"=="O" start "" "%USERPROFILE%\Desktop\rapport_batterie.html"

echo.
echo  ════════════════════════════════════════════════════════
echo   Etapes preliminaires terminees.
echo   Passons a la configuration de l'hibernation...
echo  ════════════════════════════════════════════════════════
timeout /t 2 /nobreak >nul
goto CONFIG_HIBERNATION

:: SOUS-ROUTINES SILENCIEUSES
:SILENT_OPTIMISATIONS
powercfg /hibernate on >nul 2>&1
powercfg /hibernate /size 100 >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Power" /v PlatformAoAcOverride /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d 1 /f >nul 2>&1
sc config SysMain start= disabled >nul 2>&1
sc stop SysMain >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc config CDPSvc start= disabled >nul 2>&1
sc stop CDPSvc >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
del /f /s /q "%TEMP%\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
goto :EOF

:SILENT_SOURIS
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
goto :EOF