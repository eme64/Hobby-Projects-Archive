Rem

Clipboard functions by Suco-X

End Rem 

Strict

Extern "Win32"
	Function OpenClipboard(hwnd:Int)
	Function CloseClipboard()
	Function EmptyClipboard()
	Function GetClipboardData:Byte Ptr(Format:Int)
	Function SetClipboardData(format:Int, hMem:Byte Ptr)
	
	Function GlobalAlloc(Flags:Int, Bytes:Int)
	Function GlobalFree(Mem:Int)
	Function GlobalLock:Byte Ptr(Mem:Int)
	Function GlobalUnlock(Mem:Int)
End Extern

?Win32
	Const CF_TEXT = $01
	Const GMEM_MOVEABLE = 2
	Const GMEM_DDESHARE = $2000
	
	
	Function TextFromClipboard:String()
		If Not OpenClipboard(0)
			Return ""
		EndIf
		Local TextBuf:Byte Ptr
		TextBuf = GetClipboardData(CF_TEXT)
		CloseClipboard()
		
		Return String.FromCString(TextBuf)
	End Function
	
	
	Function TextToClipboard(txt:String)
		
		If txt$="" Return
		
		Local TextBuf:Byte Ptr
		Local Memblock:Int
		Local DataBuf:Byte Ptr
		
		TextBuf  = Txt.ToCString()
		Memblock = GlobalAlloc(GMEM_MOVEABLE|GMEM_DDESHARE, txt.length+1)
		DataBuf  = GlobalLock(Memblock)
		
		MemCopy DataBuf, TextBuf, Txt.length
		
		If OpenClipboard(0)
			EmptyClipboard
			SetClipboardData(CF_TEXT, DataBuf)
			CloseClipboard
		EndIf
		
		GlobalUnlock(Memblock)
		GlobalFree(Memblock)
		
	End Function
?


' -------------------------------------------------

Rem

Print "~n~nEnter some text for the clipboard"
Print "Alternatively, leave BLANK to see clipboard contents"
Local ctext$=Input$("> ")

If ctext$
	TextToClipboard ctext$
	Print "Text sent to clipboard."
	End
EndIf

Local ClipText:String = TextFromClipboard()
If ClipText
	Print ""
	Print "Clipboard Text:~n================="
	Print ClipText
	Print "==============="
EndIf
end rem