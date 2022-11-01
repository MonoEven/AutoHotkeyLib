class debug
{
    static _gui := "", hwnd := 0, ctlHwnd := 0
    static StartMakingGui := 0, locked := 1
    static WinName := "Debug Window"
    ; Change this to change the decimal places
    static FloatPos := 8
    
    __New(Content, TimeStamp := true)
    {
        debug.Msg(Content, TimeStamp)
    }
    
    static Msg(Content, TimeStamp := true)
    {
        this.makeGui()
        Content := debug.ToString(Content)
        
        If (TimeStamp) ; append timestamp + str
            Content := "[" A_Hour ":" A_Min ":" A_Sec "] " Content "`r`n"
        
        If (this.hwnd)
        {
            Lst_Content := StrSplit(Content, "`n")
            
            Loop Lst_Content.Length
            {
                this.AppendTxt(this.ctlHwnd, StrPtr(Lst_Content[A_Index]))
                this._gui["EditBox"].Value .= "`n"
            }
        }
    }
    
    static makeGui()
    {
        If (WinExist("ahk_id " this.hwnd))
            return
        
        If (this.hwnd Or this.StartMakingGui) ; skip making the GUI
            return
        
        this.StartMakingGui := 1
        
        guiClose := ObjBindMethod(this,"gClose")
        this.guiClose := guiClose
        guiSize := ObjBindMethod(this,"gSize")
        this.guiSize := guiSize
        ctlEvent := ObjBindMethod(this,"event")
        this.ctlEvent := ctlEvent
        
        ArkDebugObj := Gui("+Resize", this.WinName)
        ArkDebugObj.OnEvent("close", this.guiClose)
        ArkDebugObj.OnEvent("size", this.guiSize)
        
        ArkDebugObj.SetFont("s11","Courier New")
        ctl := ArkDebugObj.Add("Button","vCopy x5 y5 Section","Copy to Clipboard").OnEvent("Click",ctlEvent)
        ctl := ArkDebugObj.Add("Button","vClear yp x+5","Clear Window").OnEvent("Click",ctlEvent)
        
        ctl := ArkDebugObj.Add("Edit","vEditBox xs y+0 w700 h500 Multi ReadOnly")
        this.ctlHwnd := ctl.hwnd, ctl := ""
        
        ArkDebugObj.Show("NA NoActivate")
        
        this.locked := 0
        this.hwnd := ArkDebugObj.hwnd
        this.locked := 1
        
        this._gui := ArkDebugObj
    }
    
    static gClose(g)
    {
        this._gui.Destroy()
        this.hwnd := 0, this.ctlHwnd := 0
        this.StartMakingGui := 0
    }
    
    static gSize(g, MinMax, Width, Height)
    {
        ; msgbox "in size"
        x := "", y := "", w := "", h := "", ctl := ""
        w := Width - 10, h := Height - 10 - 40
        ctl := g["EditBox"]
        ctl.GetPos(&x,&y)
        ctl.Move(x,y,w,h)
    }
    
    static AppendTxt(hEdit, ptrText, loc:="bottom")
    {
        charLen := SendMessage(0x000E, 0, 0, , "ahk_id " hEdit)                        ;WM_GETTEXTLENGTH
        If (loc = "bottom")
            SendMessage 0x00B1, charLen, charLen, , "ahk_id " hEdit    ;EM_SETSEL
        Else If (loc = "top")
            SendMessage 0x00B1, 0, 0,, "ahk_id " hEdit
        SendMessage 0x00C2, False, ptrText, , "ahk_id " hEdit            ;EM_REPLACESEL
    }
    
    static event(ctl,info)
    {
        If (ctl.Name = "Copy")
            A_Clipboard := ctl.gui["EditBox"].Value
        Else If (ctl.Name = "Clear")
            ctl.gui["EditBox"].Value := ""
    }
    
    static ToString(Text)
    {
        if HasMethod(Text, "ToString")
            return Text.ToString()
        
        else if Type(Text) == "Array"
        {
            if Text.Length < 1
                Text.InsertAt(1, "")
            
            String_Plus := ""
            String_Text := "[" . debug.ToString(Text[1])
            
            Loop Text.Length - 1
                String_Plus .= "," . debug.ToString(Text[A_Index + 1])
            
            String_Text .= String_Plus
            String_Text .= "]"
            
            return String_Text
        }
        
        else if Type(Text) == "ComObjArray"
        {
            if Text.MaxIndex() < 0
            {
                Text := ComObjArray(VT_VARIANT:=12, 1)
                Text[0] := ""
            }
            
            String_Plus := ""
            String_Text := "[" . debug.ToString(Text[0])
            
            Loop Text.MaxIndex()
                String_Plus .= "," . debug.ToString(Text[A_Index])
            
            String_Text .= String_Plus
            String_Text .= "]"
            
            return String_Text
        }
        
        else if Type(Text) == "Map"
        {
            String_Text := "{"
            
            For i, Value in Text
                String_Text .= debug.ToString(i) . ":" . debug.ToString(Value) . ","
            
            if SubStr(String_Text, -1) !== "{"
                String_Text := SubStr(String_Text, 1, StrLen(String_Text) - 1)
            
            String_Text .= "}"
            
            return String_Text
        }
        
        else if Type(Text) == "Integer" || Type(Text) == "String"
            return String(Text)
        
        else if Type(Text) == "Float"
            return Round(Text, this.FloatPos)
        
        else if Type(Text) == "Object"
        {
            String_Text := "{"
            
            For i, Value in Text.OwnProps()
                String_Text .= debug.ToString(i) . ":" . debug.ToString(Value) . ","
            
            if SubStr(String_Text, -1) !== "{"
                String_Text := SubStr(String_Text, 1, StrLen(String_Text) - 1)
            
            String_Text .= "}"
            
            return String_Text
        }
        
        else if Type(Text) == "Cv_Mat_Object"
        {
            String_Text := "Channels: " Text.Channels
            String_Text .= "`nData: " Text.Data
            String_Text .= "`nDepth: " Text.Depth
            String_Text .= "`nShape: " debug.ToString([Text.Rows, Text.Cols, Text.Channels])
            String_Text .= "`nSize: " Text.Size
            String_Text .= "`nStep1: " Text.Step1
            String_Text .= "`nTotal: " Text.Total
            String_Text .= "`nType: " Text.Type
            String_Text .= "`nCols: " Text.MAT.Cols
            String_Text .= "`nDims: " Text.MAT.Dims
            String_Text .= "`nRows: " Text.MAT.Rows
            
            return String_Text
        }
        
        else if Type(Text) == "Func"
        {
            String_Text := "Name: " Text.Name
            String_Text .= "`nIsBuiltIn: " Text.IsBuiltIn
            String_Text .= "`nIsVariadic: " Text.IsVariadic
            String_Text .= "`nMinParams: " Text.MinParams
            String_Text .= "`nMaxParams: " Text.MaxParams
            
            return String_Text
        }
        
        else if Type(Text) == "Class"
        {
            String_Text := ""
            
            For item, value in Text.Prototype.OwnProps()
                String_Text .= item ": " value "`n"
            
            return SubStr(String_Text, 1, StrLen(String_Text) - 1)
        }
        
        else if Type(Text) == "Gui"
        {
            String_Text := "BackColor: " Text.BackColor
            String_Text .= "`nFocusedCtrl: " Text.FocusedCtrl
            String_Text .= "`nHwnd: " Text.Hwnd
            String_Text .= "`nMarginX: " Text.MarginX
            String_Text .= "`nMarginY: " Text.MarginY
            String_Text .= "`nMenuBar: " Text.MenuBar
            String_Text .= "`nName: " Text.Name
            String_Text .= "`nTitle: " Text.Title
            String_Text .= "`nItem: `n{`n"
            
            For Hwnd, GuiCtrlObj in Text
            {
                String_Text .= "  Control #" A_Index "[Hwnd: " Hwnd ",ClassNN: " GuiCtrlObj.ClassNN "]`n"
            }
            
            String_Text .= "}"
            
            return String_Text
        }
        
        else
            return "#Type: " Type(Text) "#"
    }
}

class notype
{
    __new(reason := 0)
    {
        this.reason := reason
    }
    
    tostring()
    {
        if !this.reason
            return ">> notype: no reason."
        else
            return format(">> notype: {}.", this.reason)
    }
}