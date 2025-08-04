@echo off
setlocal

:: Set playlists directory
set "playlistDir=%appdata%\EyePeaTV\playlists"

:: Create directory if it doesn't exist
if not exist "%playlistDir%" (
    mkdir "%playlistDir%"
)

:: Set assets URL
set "assetsURL=https://raw.githubusercontent.com/EyePeaTV/EyePeaTV/refs/heads/main/src/assets"

:: Set playlist details
set "playlist=%playlistDir%\fox.m3u"
set "playlistTitle=FOX"
set "playlistLogoURL=%assetsURL%/logos/fox.png"
set "playlistURL=%assetsURL%/playlists/fox.m3u"

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

start %playlist%

:end
endlocal
exit /b
