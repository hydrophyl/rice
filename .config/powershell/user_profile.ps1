# Prompt
Import-Module posh-git 
oh-my-posh init pwsh --config 'C:\Users\forev\scoop\apps\oh-my-posh\current\themes\dracula.omp.json' | Invoke-Expression
# Icons
Import-Module -Name Terminal-Icons

#PSReadLine
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyhandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Fzf
Import-Module PSFzf
Set-PSFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'


function openDocumentFolder {
   	cd C:\Users\forev\Documents
}

function openNextMusicFolder {
   	cd E:\Nextcloud\music
}

function openPowershellConfigFile {
	nvim C:\Users\forev\.config\powershell\user_profile.ps1
}

function openlfConfigFile {
	nvim C:\Users\forev\AppData\Locallf\lfrc
}

function openNeovimConfigFile {
   nvim C:\Users\forev\AppData\Local\nvim\init.lua
}

function openFolderinVsCode {
   code .
}
function openCurrentFolder {
   start .
}

function downloadAudioFromPlaylistYoutube($link) {
	yt-dlp --yes-playlist -x --audio-format mp3 $link
}

# Alias
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias grep findstr
Set-Alias g git
Set-Alias c cls
Set-Alias d openDocumentFolder
Set-Alias o openCurrentFolder
Set-Alias pcfg openPowershellConfigFile
Set-Alias vcfg openNeovimConfigFile
Set-Alias lfcfg openlfConfigFile 
Set-Alias co openFolderinVsCode
Set-Alias m openNextMusicFolder 

# Dracula readline configuration. Requires version 2.0, if you have 1.2 convert to `Set-PSReadlineOption -TokenType`
Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::Green
    "Parameter" = [ConsoleColor]::Gray
    "Operator" = [ConsoleColor]::Magenta
    "Variable" = [ConsoleColor]::White
    "String" = [ConsoleColor]::Yellow
    "Number" = [ConsoleColor]::Blue
    "Type" = [ConsoleColor]::Cyan
    "Comment" = [ConsoleColor]::DarkCyan
}
# Dracula Prompt Configuration
$GitPromptSettings.DefaultPromptPrefix.Text = "$([char]0x2192) " # arrow unicode symbol
$GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Green
$GitPromptSettings.DefaultPromptPath.ForegroundColor =[ConsoleColor]::Cyan
$GitPromptSettings.DefaultPromptSuffix.Text = "$([char]0x203A) " # chevron unicode symbol
$GitPromptSettings.DefaultPromptSuffix.ForegroundColor = [ConsoleColor]::Magenta
# Dracula Git Status Configuration
$GitPromptSettings.BeforeStatus.ForegroundColor = [ConsoleColor]::Blue
$GitPromptSettings.BranchColor.ForegroundColor = [ConsoleColor]::Blue
$GitPromptSettings.AfterStatus.ForegroundColor = [ConsoleColor]::Blue
