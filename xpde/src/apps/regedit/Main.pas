{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003 Theo Lustenberger                                        }
{                                                                             }
{ This program is free software; you can redistribute it and/or               }
{ modify it under the terms of the GNU General Public                         }
{ License as published by the Free Software Foundation; either                }
{ version 2 of the License, or (at your option) any later version.            }
{                                                                             }
{ This program is distributed in the hope that it will be useful,             }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of              }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU           }
{ General Public License for more details.                                    }
{                                                                             }
{ You should have received a copy of the GNU General Public License           }
{ along with this program; see the file COPYING.  If not, write to            }
{ the Free Software Foundation, Inc., 59 Temple Place - Suite 330,            }
{ Boston, MA 02111-1307, USA.                                                 }
{                                                                             }
{ *************************************************************************** }

unit Main;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QMenus, uRegTree, uRegList, QImgList,
  QExtCtrls, QComCtrls, VirtualTrees, uRegistry, uFileFinder,
  uXPPopupMenu, QClipbrd, QActnList, UEasyPrint, uXPdePrintDialog;
type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    ImageList1: TImageList;
    PopupMenu1: TXPPopupMenu;
    New1: TMenuItem;
    Key2: TMenuItem;
    Delete1: TMenuItem;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    Edit1: TMenuItem;
    View1: TMenuItem;
    Favorites1: TMenuItem;
    Help1: TMenuItem;
    Change1: TMenuItem;
    N1: TMenuItem;
    New2: TMenuItem;
    N2: TMenuItem;
    Delete2: TMenuItem;
    Rename1: TMenuItem;
    N3: TMenuItem;
    CopyKeyName1: TMenuItem;
    N4: TMenuItem;
    Find1: TMenuItem;
    Findnext1: TMenuItem;
    PopupMenu2: TXPPopupMenu;
    New3: TMenuItem;
    Delete: TMenuItem;
    Key1: TMenuItem;
    DWORDValue1: TMenuItem;
    String1: TMenuItem;
    BinaryData1: TMenuItem;
    Rename: TMenuItem;
    N7: TMenuItem;
    Change: TMenuItem;
    About1: TMenuItem;
    ActionList1: TActionList;
    AStatusbar: TAction;
    Statusbar2: TMenuItem;
    N8: TMenuItem;
    Split1: TMenuItem;
    N9: TMenuItem;
    Refresh1: TMenuItem;
    AChange: TAction;
    ARename: TAction;
    ADelete: TAction;
    ANewKey: TAction;
    Keyx1: TMenuItem;
    N10: TMenuItem;
    DWORDValue2: TMenuItem;
    String2: TMenuItem;
    BinaryData2: TMenuItem;
    Print1: TMenuItem;
    N6: TMenuItem;
    N5: TMenuItem;
      Export: TMenuItem;
    Import: TMenuItem;
    Exit1: TMenuItem;
    N11: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Expand1: TMenuItem;
    N12: TMenuItem;
    DWORDValue3: TMenuItem;
    String3: TMenuItem;
    Binarydata3: TMenuItem;
    N13: TMenuItem;
    Find2: TMenuItem;
    Rename2: TMenuItem;
    N14: TMenuItem;
    CopyKeyName2: TMenuItem;
    AFind: TAction;
    ANewDWord: TAction;
    ANewString: TAction;
    ANewBinary: TAction;
    ACopyKeyName: TAction;
    AExpColl: TAction;
    XPStyle1: TMenuItem;
    N15: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Findnext1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure AStatusbarExecute(Sender: TObject);
    procedure AStatusbarUpdate(Sender: TObject);
    procedure Split1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure AChangeExecute(Sender: TObject);
    procedure AChangeUpdate(Sender: TObject);
    procedure ARenameExecute(Sender: TObject);
    procedure ARenameUpdate(Sender: TObject);
    procedure ADeleteExecute(Sender: TObject);
    procedure ADeleteUpdate(Sender: TObject);
    procedure ANewKeyExecute(Sender: TObject);
    procedure ANewKeyUpdate(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure ImportClick(Sender: TObject);
    procedure ExportClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure AFindExecute(Sender: TObject);
    procedure ANewDWordExecute(Sender: TObject);
    procedure ANewDWordUpdate(Sender: TObject);
    procedure ANewStringExecute(Sender: TObject);
    procedure ANewStringUpdate(Sender: TObject);
    procedure ANewBinaryExecute(Sender: TObject);
    procedure ANewBinaryUpdate(Sender: TObject);
    procedure ACopyKeyNameExecute(Sender: TObject);
    procedure ACopyKeyNameUpdate(Sender: TObject);
    procedure AExpCollExecute(Sender: TObject);
    procedure AExpCollUpdate(Sender: TObject);
    procedure XPStyle1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SetColors(XPStyle: Boolean);
  public
    { Public declarations }
  end;

const XPColor = $DBEAEB;

var
  Form1: TForm1;
  Tree: TRegTree;
  List: TRegList;
  fReg: TRegistry;
  ff: TFileFinder;
  CurrentColor: TColor;
implementation
uses DmFrame, DmGraphics, SearchForm, uXPAPI, EdDword, EdString, EdBin, uXPStyle;

{$R *.xfm}

procedure TForm1.FormCreate(Sender: TObject);
var MS: TMemoryStream;
  buf: byte;
  i: integer;
begin
  CurrentColor := XPColor;
  Font.Name := '';

  List := TRegList.Create(self);
  List.Parent := Panel2;
  List.Align := alClient;
  List.Images := ImageList1;
  List.PopupMenu := PopUpMenu2;
  List.Header.Font := Font;

  Tree := TRegTree.Create(self);
  Tree.Parent := Panel1;
  Tree.Align := alClient;
  Tree.Images := ImageList1;
  Tree.PopupMenu := PopUpMenu1;
  Tree.List := List;
  Tree.OnFocusChanged := TreeFocusChanged;

  fReg := TRegistry.Create;
  fReg.RootKey := HKEY_CURRENT_USER;
  if fReg.OpenKey(Appkey, true) then
  begin
    if fReg.Valueexists('left') then
    begin
      SetBounds(fReg.Readinteger('left'),
        fReg.Readinteger('top'),
        fReg.Readinteger('width'),
        fReg.Readinteger('height'));
    end;
    fReg.CloseKey;

    fReg.RootKey := 'HKEY_CLASSES_ROOT';
    if not fReg.KeyExists('.reg') then
    begin
    fReg.OpenKey('.reg', true);
    fReg.Writestring('Default', '.reg.document.1');
    fReg.CloseKey;

    fReg.OpenKey('.reg.document.1/Shell/open/command/', true);
    fReg.Writestring('Default', Paramstr(0) + ' %1');
    fReg.CloseKey;
    end;

  end;
  ff := TFileFinder.Create;
  ff.Startpath := fReg.RootPath + PathDelim;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ff.Free;
  fReg.Free;
  Tree.free;
  List.free;
end;

procedure TForm1.SetColors(XPStyle: Boolean);
begin
  if XPStyle then
    CurrentColor := XPColor else CurrentColor := clBackGround;
  DmGraphics.XPMainHeaderColorUp := CurrentColor;
  List.Refresh;
  MainMenu1.Color := CurrentColor;
  Statusbar1.Color := CurrentColor;
  FSearchForm.Color := CurrentColor;
  EdDword1.Color := CurrentColor;
  FrmEditString.Color := CurrentColor;
  Form2.Color := CurrentColor;
  Splitter1.Color := CurrentColor;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Tree.SetFocus;
  Tree.Initialize;
  Icon.Transparent := true;
  Application.Icon := Icon;
  SetColors(false);
end;

procedure TForm1.TreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  StatusBar1.SimpleText := ' ' + Tree.GetPath(Node);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fReg.RootKey := HKEY_CURRENT_USER;
  if fReg.OpenKey(Appkey, true) then
  begin
    fReg.Writeinteger('left', left);
    fReg.Writeinteger('top', top);
    fReg.Writeinteger('width', width);
    fReg.Writeinteger('height', height);
    fReg.CloseKey;
  end;

end;

procedure TForm1.Findnext1Click(Sender: TObject);
var Path, RegPath: string;
  SR: TSearchRec;
  ResNode: PVirtualNode;
begin
  if FF.GetNext(Path, SR) then
  begin
    Tree.SetFocus;
    RegPath := Copy(Path, Length(fReg.RootPath) + 2, length(Path));
    Resnode := Tree.ExpandPath(RegPath + PathDelim + SR.Name);
    if (Resnode <> nil) then
    begin
      Tree.FocusedNode := Resnode;
      Tree.Selected[Resnode] := true;
      if SR.Attr = faDirectory then
      begin
      end else
      begin
        ResNode := List.GetNamedRootChild(Copy(SR.Name, 1, Length(SR.Name) - Length(ExtractFileExt(SR.Name))));
        if ResNode <> nil then List.Selected[ResNode] := true;
        List.SetFocus;
      end;
    end else Findnext1Click(Sender);
  end else MessageDlg('The registry has been searched', mtInformation,      [mbOk], 0, mbOk);
end;

procedure TForm1.AFindExecute(Sender: TObject);
begin
  if FSearchForm.ShowModal = mrOK then
  begin
    Screen.Cursor:=crHourGlass;
    FF.Search := FSearchForm.EdFind.Text;
    FF.FindOptions := [];
    if FSearchForm.CBKeys.Checked then FF.FindOptions := FF.FindOptions + [foDir];
    if FSearchForm.CBValues.Checked then FF.FindOptions := FF.FindOptions + [foName];
    if FSearchForm.CBData.Checked then FF.FindOptions := FF.FindOptions + [foContents];
    FF.Start;
    FindNext1Click(Sender);
    Screen.Cursor:=crDefault;
  end;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  XPAPI.showaboutdlg('XPde Registry Editor');
end;

procedure TForm1.AStatusbarExecute(Sender: TObject);
begin
  if Statusbar1.Visible then Statusbar1.Hide else
    Statusbar1.Show;
end;

procedure TForm1.AStatusbarUpdate(Sender: TObject);
begin
  AStatusbar.Checked := Statusbar1.visible;
end;

procedure TForm1.Split1Click(Sender: TObject);
begin
  Mouse.CursorPos := ClientToScreen(Point(Splitter1.Left + 2, Splitter1.top + (Splitter1.Height div 2)));
end;

procedure TForm1.Refresh1Click(Sender: TObject);
begin
  Tree.Clear;
  Tree.StartInit;
end;

procedure TForm1.AChangeExecute(Sender: TObject);
begin
  if List.Focused then
    List.DoEditValue;
end;

procedure TForm1.AChangeUpdate(Sender: TObject);
begin
  AChange.Enabled := (List.Focused) and (List.getFirstSelected <> nil);
end;

procedure TForm1.ARenameExecute(Sender: TObject);
begin
  if List.Focused then
    if List.GetFirstSelected <> nil then List.EditNode(List.GetFirstSelected, 0);
  if Tree.Focused then
    if Tree.GetFirstSelected <> nil then Tree.EditNode(Tree.GetFirstSelected, -1);
end;

procedure TForm1.ARenameUpdate(Sender: TObject);
begin
  if Tree.Focused then ARename.Enabled := Tree.CanDeleteKey else
    ARename.Enabled := True;
end;

procedure TForm1.ADeleteExecute(Sender: TObject);
begin
  if Tree.Focused then Tree.DeleteKey;
  if List.Focused then List.DeleteValue;
end;

procedure TForm1.ADeleteUpdate(Sender: TObject);
begin
  if Tree.Focused then ADelete.Enabled := Tree.CanDeleteKey;
  if List.Focused then
  begin
    ADelete.Enabled := true;

    if not List.NodeAtMouseDown then
    begin
      N7.Visible := false;
      Change.Visible := false;
      Delete.Visible := false;
      Rename.Visible := false;
      New3.Visible := true;
    end else
    begin
      N7.Visible := true;
      Change.Visible := true;
      Delete.Visible := true;
      Rename.Visible := true;
      New3.Visible := false;
    end;
  end;
end;

procedure TForm1.ANewKeyExecute(Sender: TObject);
begin
  Tree.AddKey;
end;

procedure TForm1.ANewKeyUpdate(Sender: TObject);
begin
  ANewKey.Enabled := Tree.CanCreateKey;
end;

procedure TForm1.Print1Click(Sender: TObject);
var Node: PVirtualNode;
var BaseKey, KeyPath, Key: string;
  Prn: TEasyPrint;
  i:integer;
  TempStriLi:TStrings;
begin
  TempStriLi:=TStringList.create;
  XPdePrintDialog.CustomPrintOptions:=[cpoPages,cpoCopies,cpoMargins];
  if XPdePrintDialog.Execute then
  begin
    Prn:=TEasyPrint.Create;
    Prn.Font.Size:=11;
    Prn.Font.Name:='courier';
    Node := Tree.GetFirstSelected;
    if Assigned(Node) then
    begin
      uRegTree.SplitKey(Tree.GetPath(Node), BaseKey, KeyPath, Key);
      fReg.RootKey := BaseKey;
      if KeyPath <> '' then
        fReg.ExportRegDataStrings(KeyPath + PathDelim + Key, TempStriLi) else
        fReg.ExportRegDataStrings(Key, TempStriLi);
      Prn.Text:=TempStriLi.Text;
    For i:=0 to XPdePrintDialog.NumCopies-1 do Prn.Print;
    end;
  Prn.Free;
  end;
TempStriLi.free;
end;

procedure TForm1.importClick(Sender: TObject);
begin
  OpenDialog1.DefaultExt := '.reg';
  if Opendialog1.Execute then
  begin
    fReg.ImportRegData(OpenDialog1.Filename);
  end;
end;

procedure TForm1.exportClick(Sender: TObject);
var Node: PVirtualNode;
var BaseKey, KeyPath, Key: string;
begin
  Node := Tree.GetFirstSelected;
  if Assigned(Node) then
  begin
    SaveDialog1.FileName := 'untitled.reg';
    SaveDialog1.Title := 'Save: ' + Tree.GetPath(Node);
    if Savedialog1.Execute then
    begin
      uRegTree.SplitKey(Tree.GetPath(Node), BaseKey, KeyPath, Key);
      fReg.RootKey := BaseKey;
      if KeyPath <> '' then
        fReg.ExportRegDataFile(KeyPath + PathDelim + Key, SaveDialog1.Filename) else
        fReg.ExportRegDataFile(Key, SaveDialog1.Filename);
    end;
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.ANewDWordExecute(Sender: TObject);
begin
  List.AddValue(rdInteger);
end;

procedure TForm1.ANewDWordUpdate(Sender: TObject);
begin
  ANewDWord.Enabled := Tree.CanCreateKey;
end;

procedure TForm1.ANewStringExecute(Sender: TObject);
begin
  List.AddValue(rdString);
end;

procedure TForm1.ANewStringUpdate(Sender: TObject);
begin
  ANewString.Enabled := Tree.CanCreateKey;
end;

procedure TForm1.ANewBinaryExecute(Sender: TObject);
begin
  List.AddValue(rdBinary);
end;

procedure TForm1.ANewBinaryUpdate(Sender: TObject);
begin
  ANewBinary.Enabled := Tree.CanCreateKey;
end;

procedure TForm1.ACopyKeyNameExecute(Sender: TObject);
var FilePath: string;
begin
  FilePath := Tree.GetPath(Tree.GetFirstSelected);
  Clipboard.AsText := Copy(FilePath, Length(VirtualRootName) + 2, Length(FilePath));
end;

procedure TForm1.ACopyKeyNameUpdate(Sender: TObject);
begin
//
end;

procedure TForm1.AExpCollExecute(Sender: TObject);
var Node: PVirtualNode;
begin
  Node := Tree.GetFirstSelected;
  if Assigned(Node) then Tree.Expanded[Node] := not Tree.Expanded[Node];
end;

procedure TForm1.AExpCollUpdate(Sender: TObject);
var Node: PVirtualNode;
begin
  Node := Tree.GetFirstSelected;
  if Assigned(Node) then
    if Node.ChildCount > 0 then
    begin
      AExpColl.Enabled := true;
      if Tree.Expanded[Node] then AExpColl.Caption := 'Collapse' else
        AExpColl.Caption := 'Expand';
    end else AExpColl.Enabled := false;
end;

procedure TForm1.XPStyle1Click(Sender: TObject);
begin
  SetColors(CurrentColor = clBackground);
end;
end.


