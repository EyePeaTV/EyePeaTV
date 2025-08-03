@echo off
setlocal

:: Set playlists directory
set "playlistDir=%appdata%\EyePeaTV\playlists"

:: Create directory if it doesn't exist
if not exist "%playlistDir%" (
    mkdir "%playlistDir%"
)

:: Set assets URL
set "assetsURL=../assets"

:: Set playlist details
set "playlist=%playlistDir%\ssc.m3u"
set "playlistTitle=SSC"
set "playlistLogoURL=%assetsURL%/logos/ssc.png"
set "playlistURL=%assetsURL%/playlists/ssc.m3u"

:: Write to the .m3u file
(
    echo #EXTM3U
    echo #EXTINF:0 type="playlist" tvg-logo=%playlistLogoURL%, %playlistTitle%
    echo #EXTSIZE: Medium
    echo %playlistURL%
) > "%playlist%"

echo Playlist created: "%playlist%"

:PlayNow
set "playerFound=0"

:: --- Try MPV ---
start "" mpv.exe "%playlist%"
::timeout /t 2 >nul
tasklist | findstr /i "mpv.exe" >nul && set "playerFound=1"

:: --- Try VLC if MPV didn't work ---
if %playerFound%==0 (
    start "" vlc.exe "%playlist%"
    ::timeout /t 2 >nul
    tasklist | findstr /i "vlc.exe" >nul && set "playerFound=1"
)

:: --- Try MPC-HC if previous failed ---
if %playerFound%==0 (
    start "" mpc-hc.exe "%playlist%"
    ::timeout /t 2 >nul
    tasklist | findstr /i "mpc-hc.exe" >nul && set "playerFound=1"
)

:: --- Try PotPlayer if still no luck ---
if %playerFound%==0 (
    start "" PotPlayerMini64.exe "%playlist%"
    ::timeout /t 2 >nul
    tasklist | findstr /i "PotPlayerMini64.exe" >nul && set "playerFound=1"
)

:: --- If none of the players launched, fallback ---
if %playerFound%==0 (
    start "" "%playlist%"

    powershell -NoProfile -Command "Add-Type -AssemblyName 'System.Windows.Forms'; $result = [System.Windows.Forms.MessageBox]::Show('Did not find any URL video-stream player installed. We suggest downloading VLC Media Player. Do you like to download it now?', 'No Media Player Found', [System.Windows.Forms.MessageBoxButtons]::OKCancel, [System.Windows.Forms.MessageBoxIcon]::Information); if ($result -eq [System.Windows.Forms.DialogResult]::OK) { Start-Process 'https://www.videolan.org/vlc/' }"
)

:end
endlocal
exit /b
