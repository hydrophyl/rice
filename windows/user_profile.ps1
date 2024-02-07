# Don't forget to install ripgrep(rg) and fd for searching file fzf
oh-my-posh init pwsh --config 'C:\Users\forev\AppData\Local\Programs\oh-my-posh\themes\lambdageneration.omp.json' | Invoke-Expression
#PSReadLine
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyhandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Fzf
Import-Module PSFzf
Set-PSFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

function openMidiProjectFolder {
   	cd C:\Users\forev\Documents\sps_programs\midi_project && conda activate beckerath
}

function openTextual_My {
   	cd C:\Users\forev\Documents\textual\my-xinh && conda activate beckerath
}

function openDocumentFolder {
   	cd C:\Users\forev\Documents
}

function openst_katharinenBS {
   	cd C:\Users\forev\Documents\bs-audiomat && aev 
}

function openMidiAppRepo {
   	cd C:\Users\forev\Documents\midi && beck && aev 
}

function activatePythonENV {
   	venv\Scripts\Activate.ps1
}

function openPowershellConfigFile {
	nvim C:\Users\forev\AppData\Local\.config\powershell\user_profile.ps1
}

function openlfConfigFile {
	nvim C:\Users\forev\AppData\Local\lf\lfrc
}

function openNeovimConfigFile {
   nvim C:\Users\forev\AppData\Local\nvim\init.lua
}

function openAlacrittyConfigFile {
   nvim C:\Users\forev\AppData\Roaming\alacritty\alacritty.yml
}

function openFolderinVsCode {
   code .
}

function openCurrentFolder {
   start .
}

function goUp1Folder {
   cd ..
}
Set-Alias cd1 goUp1Folder 

function goUp2Folder {
  cd ../..
}
Set-Alias cd2 goUp2Folder 

function goUp3Folder {
  cd ../../..
}
Set-Alias cd3 goUp3Folder 

function activateBeckerath {
  conda activate beckerath
}

function downloadAudioFromPlaylistYoutube($link) {
	yt-dlp --yes-playlist -x --audio-format mp3 $link
}

function fullTree($folder) {
	tree $folder /F
}

function gitStatus {
	git status
}

function gitAddAll {
	git add .
}

function killPython{
	taskkill /IM python
}

# Alias
Set-Alias kp killPython
Set-Alias gs gitStatus
Set-Alias ga gitAddAll
Set-Alias v nvim
Set-Alias l ls
Set-Alias grep findstr
Set-Alias g git
Set-Alias c cls
Set-Alias d openDocumentFolder
Set-Alias o openCurrentFolder
Set-Alias pcfg openPowershellConfigFile
Set-Alias vcfg openNeovimConfigFile
Set-Alias acfg openAlacrittyConfigFile
Set-Alias lfcfg openlfConfigFile 
Set-Alias co openFolderinVsCode
Set-Alias bs openst_katharinenBS
Set-Alias aev activatePythonENV 
Set-Alias beck activateBeckerath
Set-Alias t fullTree
Set-Alias midi openMidiProjectFolder 

