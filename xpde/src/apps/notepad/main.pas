{
    XPde Notepad
    (c) 2003 Khasan Balaev <balaev@inbox.ru>
    Distributed under GNU GPL

    <http://www.xpde.com/>

    Current limitations:
        page setup is not implemented (until XPde APIs are developed)
        preferences are not saved (font & word wrap)
        go to line is not (yet) available
}

unit main;

interface

uses
  SysUtils,
  Types,
  Classes,
  Variants,
  QTypes,
  QGraphics,
  QControls,
  QForms,
  QDialogs,
  QStdCtrls,
  QExtCtrls,
  QComCtrls,
  QMenus,
  QPrinters,
  QStdActns,
  QActnList,
  StrUtils,
  uXPAPI;

type
  TfrmMain = class(TForm)
    Memo: TMemo;
    MainMenu: TMainMenu;
    mnuFile: TMenuItem;
    mnuFileNew: TMenuItem;
    mnuFileOpen: TMenuItem;
    mnuFileSave: TMenuItem;
    mnuFileSaveAs: TMenuItem;
    N5: TMenuItem;
    mnuFilePageSetup: TMenuItem;
    mnuFilePrint: TMenuItem;
    N1: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuEdit: TMenuItem;
    mnuEditUndo: TMenuItem;
    N2: TMenuItem;
    mnuEditCut: TMenuItem;
    mnuEditCopy: TMenuItem;
    mnuEditPaste: TMenuItem;
    mnuEditDelete: TMenuItem;
    N3: TMenuItem;
    mnuEditFind: TMenuItem;
    mnuEditFindNext: TMenuItem;
    mnuEditReplace: TMenuItem;
    mnuEditGoTo: TMenuItem;
    N6: TMenuItem;
    mnuEditSelectAll: TMenuItem;
    mnuEditTimeDate: TMenuItem;
    mnuFormat: TMenuItem;
    mnuFormatWordWrap: TMenuItem;
    mnuFormatSetFont: TMenuItem;
    mnuHelp: TMenuItem;
    mnuHelpAbout: TMenuItem;
    FindDialog: TFindDialog;
    ReplaceDialog: TReplaceDialog;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    FontDialog: TFontDialog;
    StatusBar: TStatusBar;
    ActionList: TActionList;
    EditCut: TEditCut;
    EditCopy: TEditCopy;
    EditPaste: TEditPaste;
    EditSelectAll: TEditSelectAll;
    EditUndo: TEditUndo;
    EditDelete: TEditDelete;
    procedure FindDialogFind(Sender: TObject);
    procedure ReplaceDialogReplace(Sender: TObject);
    procedure mnuEditGoToClick(Sender: TObject);
    procedure mnuFileNewClick(Sender: TObject);
    procedure mnuFileOpenClick(Sender: TObject);
    procedure mnuFileSaveClick(Sender: TObject);
    procedure mnuFileSaveAsClick(Sender: TObject);
    procedure mnuFilePageSetupClick(Sender: TObject);
    procedure mnuFilePrintClick(Sender: TObject);
    procedure mnuFileExitClick(Sender: TObject);
    procedure mnuEditFindClick(Sender: TObject);
    procedure mnuEditFindNextClick(Sender: TObject);
    procedure mnuEditReplaceClick(Sender: TObject);
    procedure mnuEditTimeDateClick(Sender: TObject);
    procedure mnuFormatWordWrapClick(Sender: TObject);
    procedure mnuFormatSetFontClick(Sender: TObject);
    procedure mnuHelpAboutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function IsAllowed(s: string): boolean;
  public
    { Public declarations }
    CurrentFileName: string;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.xfm}

resourcestring
    CaptionText = ' - XPde Notepad';
    Untitled = 'Untitled';
    SavePrompt = ' has been modified. Do you want to save it?';
    SearchStringNotFound = 'Search string not found!';

function TfrmMain.IsAllowed(s: string): boolean;
    var AsciiCode: byte;
begin
    AsciiCode := Ord(s[1]);

    Result := ((AsciiCode >= 32) and (AsciiCode <= 47)) or
        ((AsciiCode >= 58) and (AsciiCode <= 64)) or
        ((AsciiCode >= 91) and (AsciiCode <= 96)) or
        ((AsciiCode >= 123) and (AsciiCode <= 126));
end;

procedure TfrmMain.FindDialogFind(Sender: TObject);
    var
        SelPos, // where text to find is
        SPos, // Memo.SelStart
        SLen, // Memo.SelLen
        TextLength: LongInt; // the length of memo's text
        SearchString: string; // text that is searched in
        TextToFind: string; // text than needs to be found
        SearchStringClone: string; // attack of the clones
        lc, rc: string;
begin
        TextLength:=Length(Memo.Lines.Text);
        SPos:=Memo.SelStart;
        SLen:=Memo.SelLength;
        TextToFind := FindDialog.FindText;

        { copy a block of Memo's text according to user's selection }
        if frDown in FindDialog.Options then begin
            SearchString := Copy(Memo.Lines.Text, SPos + SLen + 1,
                TextLength - SLen + 1)
        end
        else begin
            SearchString := ReverseString(Copy(Memo.Lines.Text, 0, SPos{ + SLen}));
            TextToFind := ReverseString(TextToFind);
        end;

        if not (frMatchCase in FindDialog.Options) then begin
            SearchString := LowerCase(SearchString);
            TextToFind := LowerCase(TextToFind);
        end;
        { / }

        { search the text then }
        if frWholeWord in FindDialog.Options then begin
            SearchStringClone := Copy(SearchString, 0, Length(SearchString) + 99);
            repeat
                SelPos := Pos(TextToFind, SearchStringClone);

                if SelPos = 0 then
                    Break;

                lc := Copy(SearchStringClone, SelPos - 1, 1);
                rc := Copy(SearchStringClone, SelPos + Length(TextToFind), 1);

                if IsAllowed(lc) and IsAllowed(rc) then
                    Break;

                SearchStringClone := Copy(SearchStringClone, SelPos + 1,
                    Length(SearchStringClone) + 99); { copy the whole string }
            until false;

            if SelPos <> 0 then begin
                SelPos := Length(SearchString) - (Length(SearchStringClone) - SelPos);
            end;
        end
        else begin
            SelPos := Pos(TextToFind, SearchString);
        end;


        if SelPos = 0 then begin
            MessageDlg(SearchStringNotFound, mtError, [mbOk], 0);
            Exit;
        end
        else begin
            if frDown in FindDialog.Options then begin
                Memo.SelStart := (SelPos - 1) + (SPos + SLen);
                Memo.SelLength := Length(TextToFind);
            end
            else begin
                Memo.SelStart := Length(SearchString) - SelPos - Length(TextToFind) + 1;
                Memo.SelLength := Length(TextToFind);
            end; {if frDown}
        end; {SelPos = 0}
end;

procedure TfrmMain.ReplaceDialogReplace(Sender: TObject);
    var
        SelPos,
        SPos,
        SLen,
        TextLength: LongInt;
        SearchString: string;
        SearchStringClone: string;
        TextToFind: string;
        ReplaceWith: string;
        lc, rc: string;
        ItsOverBaby: boolean;
begin
        if frReplaceAll in ReplaceDialog.Options then
            ItsOverBaby := false { it's only starting }
        else
            ItsOverBaby := true; { rejoice }

        repeat

        TextLength:=Length(Memo.Lines.Text);
        SPos:=Memo.SelStart;
        SLen:=Memo.SelLength;
        TextToFind := ReplaceDialog.FindText;
        ReplaceWith := ReplaceDialog.ReplaceText;

        { copy appropriate block of Memo's text according to user's selection }
        if frDown in ReplaceDialog.Options then begin
            SearchString := Copy(Memo.Lines.Text, SPos + SLen + 1,
                TextLength - SLen + 1)
        end
        else begin
            SearchString := ReverseString(Copy(Memo.Lines.Text, 0, SPos{ + SLen}));
            TextToFind := ReverseString(TextToFind);
        end;

        if not (frMatchCase in ReplaceDialog.Options) then begin
            SearchString := LowerCase(SearchString);
            TextToFind := LowerCase(TextToFind);
        end;
        { / }

        { search the text then }
        if frWholeWord in ReplaceDialog.Options then begin
            SearchStringClone := Copy(SearchString, 0, Length(SearchString) + 99);
            repeat
                SelPos := Pos(TextToFind, SearchStringClone);

                if SelPos = 0 then
                    Break;

                lc := Copy(SearchStringClone, SelPos - 1, 1);
                rc := Copy(SearchStringClone, SelPos + Length(TextToFind), 1);

                if IsAllowed(lc) and IsAllowed(rc) then
                    Break;

                SearchStringClone := Copy(SearchStringClone, SelPos + 1,
                    Length(SearchStringClone) + 99); { copy the whole string }
            until false;

            if SelPos <> 0 then begin
                SelPos := Length(SearchString) - (Length(SearchStringClone) - SelPos);
            end;
        end
        else begin
            SelPos := Pos(TextToFind, SearchString);
        end;


        if SelPos = 0 then begin
            if frReplaceAll in ReplaceDialog.Options then begin
                ItsOverBaby := true;
                Exit;
            end;
            MessageDlg(SearchStringNotFound, mtError, [mbOk], 0);
        end
        else begin
            if frDown in ReplaceDialog.Options then begin
                Memo.SelStart := (SelPos - 1) + (SPos + SLen);
                Memo.SelLength := Length(TextToFind);
                Memo.SelText := ReplaceWith;
            end
            else begin
                Memo.SelStart := Length(SearchString) - SelPos - Length(TextToFind) + 1;
                Memo.SelLength := Length(TextToFind);
                Memo.SelText := ReplaceWith;
            end; {if frDown}
        end; {SelPos = 0}

        until ItsOverBaby;
end;

procedure TfrmMain.mnuEditGoToClick(Sender: TObject);
begin
    // go go go!!
end;

procedure TfrmMain.mnuFileNewClick(Sender: TObject);
begin
    Memo.Clear();
    CurrentFileName := Untitled;
    frmMain.Caption := Untitled + CaptionText;
    StatusBar.SimpleText := CurrentFileName;
end;

procedure TfrmMain.mnuFileOpenClick(Sender: TObject);
    var mr: integer;
begin
    if Memo.Modified then begin
        mr := MessageDlg(CurrentFileName + SavePrompt, mtWarning, [mbYes, mbNo, mbCancel], 0, mbYes);

        if mr = mrYes then begin 
            if FileExists(CurrentFileName) then begin
                mnuFileSave.Click();
            end
            else begin
                mnuFileSaveAs.Click();
            end;
        end
        else if mr = mrNo then begin
            ; // nothing
        end
        else if mr = mrCancel then begin
            Exit;
        end;
    end;

    if OpenDialog.Execute() then begin
            CurrentFileName := OpenDialog.FileName;
            Memo.Lines.LoadFromFile(CurrentFileName);
            frmMain.Caption := CurrentFileName + CaptionText;
            StatusBar.SimpleText := CurrentFileName;
    end;
end;

procedure TfrmMain.mnuFileSaveClick(Sender: TObject);
begin
    if FileExists(CurrentFileName) then begin
        Memo.Lines.SaveToFile(CurrentFileName);
        StatusBar.SimpleText := CurrentFileName;
    end
    else
        mnuFileSaveAs.Click();
end;

procedure TfrmMain.mnuFileSaveAsClick(Sender: TObject);
begin
    if SaveDialog.Execute() then begin
        CurrentFileName := SaveDialog.FileName;
        Memo.Lines.SaveToFile(CurrentFileName);
        frmMain.Caption := CurrentFileName + CaptionText;
        StatusBar.SimpleText := CurrentFileName;
    end;
end;

procedure TfrmMain.mnuFilePageSetupClick(Sender: TObject);
begin
    MessageDlg('Sorry, not implemented yet', mtInformation, [mbOK], 0, mbOk);
end;

procedure TfrmMain.mnuFilePrintClick(Sender: TObject);
    var TextToPrint: TextFile;
        i: LongInt;
begin
    AssignPrn(TextToPrint);
    Rewrite(TextToPrint);

    try
        try
            for i := 0 to Memo.Lines.Count - 1 do
                WriteLn(TextToPrint, Memo.Lines[i]);
            except on E:EInOutError do
                MessageDlg('An error occured while printing. Error: '
                    + IntToStr(E.ErrorCode), mtError, [mbOK], 0);
        end;
    finally
        CloseFile(TextToPrint);
    end;
end;

procedure TfrmMain.mnuFileExitClick(Sender: TObject);
    var mr: integer;
begin
    if Memo.Modified then begin
        mr := MessageDlg(CurrentFileName + SavePrompt,
            mtWarning, [mbYes, mbNo, mbCancel], 0, mbYes);

        if mr = mrYes then begin
            if FileExists(CurrentFileName) then begin
                mnuFileSave.Click();
                Close();
            end
            else begin
                mnuFileSaveAs.Click();
                Close();
            end;
        end;

        if mr = mrNo then
            Close();

        if mr = mrCancel then
            Exit;
    end
    else begin
        Close();
    end;
end;

procedure TfrmMain.mnuEditFindClick(Sender: TObject);
begin
    FindDialog.Execute();
end;

procedure TfrmMain.mnuEditFindNextClick(Sender: TObject);
begin
    FindDialogFind(frmMain);
end;

procedure TfrmMain.mnuEditReplaceClick(Sender: TObject);
begin
    ReplaceDialog.Execute();
end;

procedure TfrmMain.mnuEditTimeDateClick(Sender: TObject);
begin
    Memo.Insert(DateTimeToStr(Now),False); 
end;

procedure TfrmMain.mnuFormatWordWrapClick(Sender: TObject);
begin
    mnuFormatWordWrap.Checked := not mnuFormatWordWrap.Checked;
    Memo.WordWrap := mnuFormatWordWrap.Checked;
end;

procedure TfrmMain.mnuFormatSetFontClick(Sender: TObject);
begin
    if FontDialog.Execute() then begin
        Memo.Font := FontDialog.Font;
        { save settings }
    end;
end;

procedure TfrmMain.mnuHelpAboutClick(Sender: TObject);
begin
    XPAPI.ShowAboutDlg('XPde Notepad'); 
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    //These lines are here to set the font of the menubar
    font.name:='';
    parentfont:=true;

    if ParamCount = 1 then begin
        if FileExists(ParamStr(1)) then begin
            CurrentFileName := ParamStr(1);
            Memo.Lines.LoadFromFile(CurrentFileName);
            frmMain.Caption := Untitled + CaptionText;
            StatusBar.SimpleText := CurrentFileName;
        end
        else begin
            mnuFileNew.Click();
            Exit;
        end;
    end;

    mnuFileNew.Click();
end;

end.
