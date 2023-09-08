/*
    C:\Users\[UserName]\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\ScreenCapture.ahk
    ^  :  Ctrl
    !  :  Alt
    +  :  Shift
    #  :  Win
    The hotkey is Ctrl+Alt+A 
*/

SetTitleMatchMode(2)

+#A::Run "C:\DRIVERS\tools\ScreenCapture.exe"

^!O::Run "C:\Users\Linwei\AppData\Local\Obsidian\Obsidian.exe --proxy-server=socks5://127.0.0.1:1080"

^!P::Run "D:\dev\vim\nvim091\bin\nvim-qt.exe -- -u c:\users\linwei\.config\nvim\neovim.vim"


#HotIf WinActive("ahk_class MozillaWindowClass") and WinActive("ahk_exe firefox.exe")
	^+w::^w
#HotIf

