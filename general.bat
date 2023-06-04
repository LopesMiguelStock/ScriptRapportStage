@echo off

chcp 65001 > nul

net session >  nul:

if %errorlevel% == 0 goto suite

echo.
echo.
echo.
echo.
echo.
echo					/!\/!\/!\	ATTENTION	/!\/!\/!\
echo.
echo.
echo.
echo.
echo.
echo			/!\/!\/!\    EXECUTEZ LE SCRIPT EN TANT QU'ADMINISTRATEUR    /!\/!\/!\
echo.
echo.
echo.
echo.
echo.
echo					/!\/!\/!\	ATTENTION	/!\/!\/!\
echo.
echo.
echo.
echo.
echo.

set /p adminrequis="Lancer le script en admim !!!"

exit

:suite
goto:start
:start

cls

echo  ******************************************************
echo  ****************************************************** 
echo  ******************** SCRIPT PREPA ********************
echo  ****************************************************** 
echo  ******************************************************
echo.

echo 1: HP
echo 2: Autre

echo.

set /p pc="Quelle est la marque du PC ? (1/2) : "

cls

echo  ******************************************************
echo  ****************************************************** 
echo  ******************** SCRIPT PREPA ********************
echo  ****************************************************** 
echo  ******************************************************
echo.

echo 1: 32 bits
echo 2: 64 bits
echo 3: aucun

echo.

set /p office="Quelle version Office365 ? (1/2/3) : "

cls

echo  ******************************************************
echo  ****************************************************** 
echo  ******************** SCRIPT PREPA ********************
echo  ****************************************************** 
echo  ******************************************************
echo.

echo 1: Oui
echo 2: Non

echo.

set /p WG="Installer WatchGuard ? (1/2) : "

cls

echo  ******************************************************
echo  ****************************************************** 
echo  ********* Suppressions logicielles inutiles **********
echo  ****************************************************** 
echo  ******************************************************
echo.

net use \\NASPREPA\PREPA /user:login password

if /i "%WG%" =="1" (
  echo Installation de WatchGuard...
  "\\NASPREPA\PREPA\PACK SS2\WG-MVPN-SSL_12_7.exe"
  echo Installation terminée.
)

REM desinstallation d'office
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_16130-20218.exe', 'C:\officedeploymenttool.exe')" > nul
mkdir C:\ODT > nul
C:\officedeploymenttool.exe /extract:"C:\ODT" /quiet
echo ^<Configuration^> > C:\configuration.xml
echo   ^<Remove All="TRUE"^> >> C:\configuration.xml
echo     ^<Product ID="O365ProPlusRetail"^> >> C:\configuration.xml
echo       ^<Language ID="fr-fr" /^> >> C:\configuration.xml
echo       ^<Language ID="en-gb" /^> >> C:\configuration.xml
echo     ^</Product^> >> C:\configuration.xml
echo   ^</Remove^> >> C:\configuration.xml
echo ^</Configuration^> >> C:\configuration.xml
echo Désinstallation de Office 365...
C:\ODT\setup.exe /configure C:\configuration.xml 
echo Désinstallation terminée.
rmdir "C:\ODT" /S /Q > nul
del C:\officedeploymenttool.exe > nul
del C:\configuration.xml > nul

if /i "%pc%"=="1" (
  REM desinstallation de HP documentation
  echo Désinstallation de HP Documentation...
  reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\HP_Documentation" /f
  del /q /f "C:\Users\All Users\Microsoft\Windows\Start Menu\Programs\HP Documentation.lnk"
  del /q /f "C:\Users\All Users\Microsoft\Windows\Start Menu\Programs\HP\HP Documentation.lnk"
  rmdir /S /Q "C:\Program Files\HP\Documentation"
  echo Désinstallation terminée.
)

echo  ******************************************************
echo  ****************************************************** 
echo  ****************** Ajout des icônes ******************
echo  ****************************************************** 
echo  ******************************************************

echo.

REM ACTIVATION NUMPAD AU BOOT 
reg add "HKEY_USERS\.Default\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d "2" /f > nul
reg add "HKEY_CURRENT_USER\Control" /v "InitialKeyboardIndicators" /t REG_SZ /d "2" /f > nul
echo Ajout du NumPad au Boot

REM Montrer l'icône Control Panel
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d 0 /f > nul
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d 0 /f > nul
echo Ajout de l'icône 'Control Panel'

REM Montrer l'icône Network
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 0 /f > nul
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 0 /f > nul
echo Ajout de l'icône 'Network'

REM Montrer l'icône User Files
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f > nul
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f > nul		
echo Ajout de l'icône 'User Files'

REM Montrer l'icône CE PC
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f > nul	
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f > nul	
echo Ajout de l'icône 'Ce PC'

powercfg /change monitor-timeout-dc 0
powercfg /change standby-timeout-dc 0
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0

echo "Temps de Veille mis à 0"

echo.

echo  ******************************************************
echo  ****************************************************** 
echo  ***************** Copie des fichiers *****************
echo  ****************************************************** 
echo  ******************************************************
echo.

echo Ajout de l'cône SUPPORT OCI dans le Bureau Public

echo Dossier OCI a été créer à la racine du disque C:
mkdir C:\OCI

REM copie des fonds d'écrans dans le dossier OCI
copy "\\Nasprepa\prepa\PACK SS2\fond de veille OCI.png" "C:\OCI"
copy "\\Nasprepa\prepa\PACK SS2\fond décran OCI.png" "C:\OCI"

copy "\\NASPREPA\PREPA\PACK SS2\readerdc64_fr_l_cra_mdr_install.exe" "C:\OCI" > nul
if exist "C:\OCI\readerdc64_fr_l_cra_mdr_install.exe" (
  echo Acrobat a été copié
)

copy "\\NASPREPA\PREPA\PACK SS2\jre-8u361-windows-x64.exe" "C:\OCI" > nul
if exist "C:\OCI\jre-8u361-windows-x64.exe" (
  echo Java a été copié
)

copy "\\NASPREPA\PREPA\PACK SS2\Ninite 7Zip Chrome Edge Firefox TeamViewer 15 VLC Installer.exe" "C:\OCI" > nul
if exist "C:\OCI\Ninite 7Zip Chrome Edge Firefox TeamViewer 15 VLC Installer.exe" (
  echo Ninite a été copié
)

if /i "%pc%"=="1" (
  copy "\\NASPREPA\PREPA\PACK SS2\hp-hpia-5.1.7.exe" "C:\OCI" > nul
  if exist "C:\OCI\hp-hpia-5.1.7.exe" (
    echo HP-hpia a été copié
  )
)

if /i "%office%"=="1" (
  xcopy "\\NASPREPA\PREPA\PACK SS2\OFFICE_VERSIONS\32b\OFFICE365_32bits" "C:\" /E /I > nul 
  if exist "C:\ODT\setup.exe" (
    echo Office365 32bits a été copié
  )
)
if /i "%office%"=="2" (
  mkdir "C:\ODT"
  xcopy "\\NASPREPA\PREPA\PACK SS2\OFFICE_VERSIONS\64b\O365Business" "C:\ODT" /E /I > nul 
  if exist "C:\ODT\setup.exe" (
    echo Office365 64bits a été copié
  )
)



if /i "%WG%" =="1" (
  copy "\\NASPREPA\PREPA\PACK SS2\WG-MVPN-SSL_12_7.exe" "C:\OCI" > nul
  if exist "C:\OCI\WG-MVPN-SSL_12_7.exe" (
    echo WatchGuard a été copié
  )
)

REM Mettre le Support OCI dans le bureau public
copy "\\NASPREPA\PREPA\PACK SS2\DL CLIENT\SUPPORT OCI.exe" "C:\Users\Public\Desktop" > nul

echo.
echo  ******************************************************
echo  ****************************************************** 
echo  ************* Installation des logiciels *************
echo  ****************************************************** 
echo  ******************************************************
echo.

REM installation des logiciels

echo Installation de Acrobat...
\\Nasprepa\prepa\Script\AcrobatReaderDC\setup.exe
echo Installation terminée.

if /i "%office%"=="1" (
  echo Installation de Office365 32bits...
  "C:\ODT\setup.exe" /configure "C:\ODT\configuration.xml" > nul
)
if /i "%office%"=="2" (
  echo Installation de Office365 64bits...
  "C:\ODT\setup.exe" /configure "C:\ODT\configuration.xml" > nul
)


echo Installation de Chrome...
start "" /b /wait cmd /c "\\Nasprepa\prepa\Script\sous-script\chrome.bat" > nul

echo Installation de Java...
start "" /b /wait cmd /c "\\Nasprepa\prepa\Script\sous-script\java.bat" > nul

echo Installation de 7zip
start "" /b /wait cmd /c "\\Nasprepa\prepa\Script\sous-script\7zip.bat" > nul

echo Installation de Firefox...
start "" /b /wait cmd /c "\\Nasprepa\prepa\Script\sous-script\firefox.bat" > nul

echo Installation de TeamViewer...
start "" /b /wait cmd /c "\\Nasprepa\prepa\Script\sous-script\TV.bat" > nul

echo Installation de VLC
start "" /b /wait cmd /c "\\Nasprepa\prepa\Script\sous-script\vlc.bat" > nul

if /i "%pc%"=="1" (
  start "" /b /wait cmd /c "\\Nasprepa\prepa\Script\sous-script\hp-hpia.bat" > nul
)

echo.
echo.
echo.

set /p finit="le script est fini ! Appuyer sur 'entrer' pour fermer le script. "
