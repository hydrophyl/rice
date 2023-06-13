oh-my-posh init pwsh --config 'C:\Users\forev\AppData\Local\Programs\oh-my-posh\themes\lambdageneration.omp.json' | Invoke-Expression
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

function openVendingMachine {
   	cd C:\Users\forev\Documents\vendingmachine
}

function activateVendingMachineENV {
   	venv\Scripts\Activate.ps1
}

function openPowershellConfigFile {
	nvim $PROFILE
}

function openlfConfigFile {
	nvim C:\Users\forev\AppData\Local\lf\lfrc
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
Set-Alias vm openVendingMachine 
Set-Alias avm activateVendingMachineENV 
