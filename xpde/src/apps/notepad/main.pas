unit main;

interface

uses
  Sysutils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QMenus;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    FileMNU: TMenuItem;
    NewMNU: TMenuItem;
    OpenMNU: TMenuItem;
    SaveMNU: TMenuItem;
    SaveAsMNU: TMenuItem;
    N1: TMenuItem;
    ExitMNU: TMenuItem;
    EditMNU: TMenuItem;
    Search1: TMenuItem;
    CutMNU: TMenuItem;
    CopyMNU: TMenuItem;
    PasteMNU: TMenuItem;
    FindMNU: TMenuItem;
    FindAgainMNU: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Memo: TMemo;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    FindDialog: TFindDialog;
    FontDialog: TFontDialog;
    N2: TMenuItem;
    SetFontMNU: TMenuItem;
    UndoMNU: TMenuItem;
    N3: TMenuItem;
    DeleteMNU: TMenuItem;
    SelectAllMNU: TMenuItem;
    TimeDateMNU: TMenuItem;
    N4: TMenuItem;
    WordWrapMNU: TMenuItem;
    N5: TMenuItem;
    Print1: TMenuItem;
    PageSetupMNU: TMenuItem;
    procedure NewMNUClick(Sender: TObject);
    procedure OpenMNUClick(Sender: TObject);
    procedure SaveAsMNUClick(Sender: TObject);
    procedure SaveMNUClick(Sender: TObject);
    procedure SetFontMNUClick(Sender: TObject);
    procedure FindMNUClick(Sender: TObject);
    procedure ExitMNUClick(Sender: TObject);
    procedure FindAgainMNUClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure CutMNUClick(Sender: TObject);
    procedure CopyMNUClick(Sender: TObject);
    procedure PasteMNUClick(Sender: TObject);
    procedure WordWrapMNUClick(Sender: TObject);
    procedure DeleteMNUClick(Sender: TObject);
    procedure SelectAllMNUClick(Sender: TObject);
    procedure TimeDateMNUClick(Sender: TObject);
    procedure UndoMNUClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MemoChange(Sender: TObject);
    procedure EditMNUClick(Sender: TObject);
    procedure FindDialogFind(Sender: TObject);
  private
    { Private declarations }
    CurrentFile: String;
    Changed: Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
 QClipbrd;

{$R *.xfm}

const
 CapText = ' - Notepad';

procedure TMainForm.NewMNUClick(Sender: TObject);
begin
Memo.Lines.Clear;
CurrentFile := 'Untitled';
MainForm.Caption := 'Untitled' + CapText;
Changed := False;
end;

procedure TMainForm.OpenMNUClick(Sender: TObject);
begin
if OpenDialog.Execute then
 begin
  Memo.Lines.LoadFromFile(OpenDialog.FileName);
  CurrentFile := OpenDialog.Filename;
  MainForm.Caption := OpenDialog.Filename + CapText;
  Changed := False;
 end;
end;

procedure TMainForm.SaveAsMNUClick(Sender: TObject);
begin
if SaveDialog.Execute then
 begin
  Memo.Lines.SaveToFile(SaveDialog.FileName);
  CurrentFile := SaveDialog.FileName;
  MainForm.Caption := SaveDialog.FileName + CapText;
 end;
end;

procedure TMainForm.SaveMNUClick(Sender: TObject);
begin
if FileExists(CurrentFile) then
 begin
   Memo.Lines.SaveToFile(CurrentFile);
 end
else
 SaveAsMNUClick(Self);
end;

procedure TMainForm.SetFontMNUClick(Sender: TObject);
begin
if FontDialog.Execute then
 begin
  Memo.Font := FontDialog.Font;
 end;
end;

procedure TMainForm.FindMNUClick(Sender: TObject);
begin
FindDialog.Execute;
end;

procedure TMainForm.ExitMNUClick(Sender: TObject);
begin
Close;
end;

procedure TMainForm.FindAgainMNUClick(Sender: TObject);
var
MatchCase: Boolean;
WholeWord: Boolean;
begin
if FindDialog.FindText <> '' then
 begin
  if frMatchCase in FindDialog.Options then MatchCase := True;
  if frWholeWord in FindDialog.Options then WholeWord := True;
  Memo.Search(FindDialog.FindText,MatchCase,True,WholeWord,False,Memo.Selection.Line2,Memo.Selection.Col2);
 end
else
 begin
  FindMNUClick(Self);
 end;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
ShowMessage('Notepad developed using Borland Kylix 3');
end;

procedure TMainForm.CutMNUClick(Sender: TObject);
begin
Memo.CutToClipboard;
end;

procedure TMainForm.CopyMNUClick(Sender: TObject);
begin
Memo.CopyToClipboard;
end;

procedure TMainForm.PasteMNUClick(Sender: TObject);
begin
if Memo.SelLength = 0 then
 Memo.PasteFromClipboard
else
 begin
  Memo.Insert('',True);
  Memo.Insert(ClipBoard.AsText,False);
 end;
end;

procedure TMainForm.WordWrapMNUClick(Sender: TObject);
begin
if not Memo.WordWrap then
 begin
  Memo.WordWrap := True;
  WordWrapMNU.Checked := True;
 end
else
 begin
  Memo.WordWrap := False;
  WordWrapMNU.Checked := False;
 end;
end;

procedure TMainForm.DeleteMNUClick(Sender: TObject);
begin
Memo.Insert('',True);
end;

procedure TMainForm.SelectAllMNUClick(Sender: TObject);
begin
Memo.SelectAll;
end;

procedure TMainForm.TimeDateMNUClick(Sender: TObject);
begin
Memo.Insert(DateTimeToStr(Now),False);
end;

procedure TMainForm.UndoMNUClick(Sender: TObject);
begin
Memo.Undo;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
if ParamCount = 1 then
 begin
  if FileExists(ParamStr(1)) then
   begin
    Memo.Lines.LoadFromFile(ParamStr(1));
    MainForm.Caption := ParamStr(1) + CapText;
   end
  else
   NewMNUClick(Self);
 end
else
 begin
  NewMNUClick(Self);
 end;
end;

procedure TMainForm.MemoChange(Sender: TObject);
begin
if not Changed then Changed := True;
end;

procedure TMainForm.EditMNUClick(Sender: TObject);
begin
if Clipboard.AsText <> '' then
 begin
  PasteMNU.Enabled := True;
 end
else
 begin
  PasteMNU.Enabled := False;
 end;
if Memo.SelLength <> 0 then
 begin
  CutMNU.Enabled := True;
  CopyMNU.Enabled := True;
  DeleteMNU.Enabled := True;
 end
else
 begin
  CutMNU.Enabled := False;
  CopyMNU.Enabled := False;
  DeleteMNU.Enabled := False;
 end;
if Changed then
 begin
  UndoMNU.Enabled := True;
 end
else
 begin
  UndoMNU.Enabled := False;
 end;
if Memo.Lines.Text <> '' then
 begin
  SelectAllMNU.Enabled := True;
 end
else
 begin
  SelectAllMNU.Enabled := False;
 end;
end;

procedure TMainForm.FindDialogFind(Sender: TObject);
var
MatchCase: Boolean;
WholeWord: Boolean;
begin
if frMatchCase in FindDialog.Options then MatchCase := True;
if frWholeWord in FindDialog.Options then WholeWord := True;
Memo.Search(FindDialog.FindText,MatchCase,True,WholeWord,True,Memo.Selection.Line2,Memo.Selection.Col2);
end;

end.
