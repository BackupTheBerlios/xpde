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

unit uRegList;

interface

uses VirtualTrees, Types, Classes, uRegistry, Sysutils, QControls,
  QDialogs, EdDword, EdString, EdBin;

type
  PValueData = ^TValueData;

  TValueData = record
    Name: TFileName;
    Vtype: TRegDataType;
  end;

  TRegList = class(TVirtualStringTree)
  private
    fReg: TRegistry;
    fFirstSel: PVirtualNode;
    fCurrentKey:String;
    fCurrrentRootKey:String;
    fNodeAtMouseDown:Boolean;
  protected
    procedure Dogettext(Node: Pvirtualnode; Column: Tcolumnindex; Texttype: Tvsttexttype;
      var Text: WideString); override;


    procedure Dogetimageindex(Node: Pvirtualnode; Kind: Tvtimagekind; Column: Tcolumnindex;
      var Ghosted: Boolean; var Index: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    procedure DoNewText(Node: PVirtualNode; Column: TColumnIndex; Text: WideString); override;
    procedure Setheaders;
    procedure DoColumnDblClick(Column: TColumnIndex; Shift: TShiftState); override;
    function Docompare(Node1, Node2: Pvirtualnode; Column: Tcolumnindex): Integer; override;
    procedure DoExit; override;
  public
    constructor Create(Aowner: TComponent); override;
    procedure ClientResized; override;
    destructor Destroy; override;
    procedure Initialize;
    procedure SetKey(RootKey, Key: string);
    function AddValue(VType:TRegDataType):PVirtualNode;
    procedure DeleteValue;
    function GetNamedRootChild(Name:String):PVirtualNode;
    procedure DoEditValue;
    property NodeAtMouseDown:Boolean read fNodeAtMouseDown;

  published
  end;
function GetRootPath: string;
function MakeUniqueName(Strili: TStrings; var NewName: string): boolean;
procedure SplitKey(Inp: string; var BaseKey, KeyPath, Key: string);

implementation
uses Math, RTLConsts, DmFrame, QGraphics, uRegTree;

constructor TRegList.Create;
begin
  inherited;
  fReg := TRegistry.Create;
  fReg.RootKey := '';
  fReg.OpenKey('', false);
  Header.Style := hsXPStyle;
  BevelInner := bvNone;
  TreeOptions.SelectionOptions :=
    TreeOptions.SelectionOptions + [toRightClickSelect] - [tofullRowSelect];
  TreeOptions.MiscOptions :=
    TreeOptions.MiscOptions + [toReportMode, toEditable];
  TreeOptions.PaintOptions := TreeOptions.PaintOptions - [toShowTreeLines];

  Indent := 4;

  SetHeaders;

  NodeDataSize := SizeOf(TValueData);

end;

procedure TRegList.ClientResized;
begin
  inherited;
  Header.Columns[2].Width := Width - 260;
end;


procedure TRegList.Initialize;
begin
  inherited;
end;

procedure TRegList.DoExit;
var Node:PVirtualNode;
begin
 inherited;
 Node:=GetFirstSelected;
 if assigned(Node) then
   if tsEditing in TreeStates then EndEditNode;
end;



destructor TRegList.Destroy;
begin
  fReg.free;
  inherited;
end;

procedure TRegList.Setheaders;
var compw: integer;
begin
  compw := Width;
  Header.Options := Header.Options + [hoVisible];
  Header.Height := 18;

  with Header.Columns.Add do
  begin
    Width := 150;
    Text := 'Name';
    Position := 0;
  end;
  with Header.Columns.Add do
  begin
    Width := 100;
    Text := 'Type';
    Position := 1;
  end;
  with Header.Columns.Add do
  begin
    Width := compw - 260;
    Text := 'Data';
    Position := 2;
  end;
end;

procedure TRegList.setKey(RootKey, Key: string);
var ValuesList: TStrings;
  NewNode: PVirtualNode;
  Data: PValueData;
  RDI: TRegDataInfo;
var i: integer;
begin
  ValuesList := TStringList.Create;
  fReg.RootKey := RootKey;
  fReg.OpenKey(Key, false);
  fReg.GetValueNames(ValuesList);

  self.Clear;
  for i := 0 to ValuesList.count - 1 do
  begin
    NewNode := AddChild(RootNode);
    Data := GetNodeData(NewNode);
    Data.Name := ValuesList[i];
    fReg.GetDataInfo(Data.Name, RDI);
    Data.Vtype := RDI.RegData;
  end;


  ValuesList.free;

  Sort(RootNode, 0, sdAscending);
end;

procedure TRegList.DeleteValue;
var SelNode: PVirtualNode;
Data: PValueData;
begin
  SelNode:=GetFirstSelected;
  if Assigned(SelNode) then
  begin
    if MessageDlg('Really delete this value? '{+GetPath(fFirstSel)}, mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    begin
      Data := GetNodeData(SelNode);
      fReg.DeleteValue(Data.Name);
      DeleteNode(SelNode);
    end;
  end;
end;

function TRegList.AddValue(VType:TRegDataType):PVirtualNode;
var
NewNode: PVirtualNode;
Data: PValueData;
NewString:String;
Buf:Pchar;
StrLi:TStrings;
begin
  NewString:='New Value';
  Result:=Nil;

  StrLi := TStringList.create;
  fReg.GetValueNames(StrLi);
  MakeUniqueName(StrLi, NewString);
  StrLi.free;

  Case Vtype of
    rdInteger: fReg.Writeinteger(NewString,0);
    rdString: fReg.WriteString(NewString,'');
    rdBinary: fReg.Writebinarydata(NewString,Buf,0);
  end;
  NewNode := AddChild(RootNode);
  Data := GetNodeData(NewNode);
  Data.Name := NewString;
  Data.Vtype:=Vtype;

  Selected[NewNode] := true;
  FocusedNode := NewNode;
  EditNode(NewNode, 0);

  Result:=NewNode;
end;

function TRegList.GetNamedRootChild(Name:String):PVirtualNode;
var NewNode: PVirtualNode;
  Data: PValueData;
begin
  Result:=Nil;
  NewNode:=GetFirstChild(RootNode);
  While assigned(NewNode) and (PValueData(GetNodeData(NewNode)).Name<>Name) do
  begin
    NewNode:=GetNextSibling(NewNode);
  end;
  if assigned(NewNode) then
  begin
    if (PValueData(GetNodeData(NewNode)).Name=Name) then Result:=NewNode;
  end;
end;

function TRegList.Docompare(Node1, Node2: Pvirtualnode; Column: Tcolumnindex): Integer;
begin
  if Column = 0 then
   Result:=AnsiCompareText(PValueData(GetNodeData(Node1)).Name,PValueData(GetNodeData(Node2)).Name) else
   Result := 0;
end;


procedure TRegList.Dogettext(Node: Pvirtualnode; Column: Tcolumnindex; Texttype: Tvsttexttype;
  var Text: WideString);
var Data: pValueData;
  tempInt, i: integer;
  MemStr: TMemoryStream;
  bufb: byte;
begin
  Data := GetNodeData(Node);
  if Assigned(Data) then
    case Column of
      0: Text := Data.Name;
      1: case Data.Vtype of
          rdString: Text := 'REG_SZ';
          rdExpandString: Text := 'REG_EXPAND_SZ';
          rdInteger: Text := 'REG_DWORD';
          rdBinary: Text := 'REG_BINARY';
        else
          Text := 'REG_UNKNOWN';
        end;
      2: case Data.Vtype of
          rdString: Text := fReg.ReadString(Data.Name);
          rdExpandString: Text := '';
          rdInteger:
            begin
              tempInt := fReg.ReadInteger(Data.Name);
              Text := '0x' + inttohex(tempInt, 8) + ' (' + inttostr(tempInt) + ')';
            end;
          rdBinary:
            begin
              MemStr := TMemoryStream.create;

              MemStr.SetSize(fReg.GetDataSize(Data.Name));
              if MemStr.Size>0 then
              begin
              fReg.ReadBinaryData(Data.Name, Memstr.Memory^, MemStr.Size);
              Memstr.Position := 0;
              Text := '';
              for i := 0 to Min(15,MemStr.Size-1) do
              begin
                Memstr.ReadBuffer(bufb, 1);
                Text := Text + inttohex(bufb, 2) + ' ';
              end;
              end else Text:='(Binary data of length zero)';
              Memstr.free;
            end;
        else
          Text := 'REG_UNKNOWN';
        end;

    end;
end;



procedure TRegList.Dogetimageindex(Node: Pvirtualnode; Kind: Tvtimagekind; Column: Tcolumnindex;
  var Ghosted: Boolean; var Index: Integer);
var Data: pValueData;
begin
  inherited;
  if Column = 0 then
  begin
    Data := GetNodeData(Node);
    case Data.Vtype of
      rdString, rdExpandString: Index := 3;
      rdInteger, rdBinary: Index := 4;
    end;
  end;
end;




procedure TRegList.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var Node: PVirtualNode;
var Data: PValueData;
begin
  inherited;
end;

procedure TRegList.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
fNodeAtMouseDown:=Assigned(GetNodeAt(X,Y));
inherited;
end;


procedure TRegList.DoNewText(Node: PVirtualNode; Column: TColumnIndex; Text: WideString);
var BaseKey, KeyPath, Key, OldKey, NewKey: string;
var Data: PValueData;
begin
  inherited;
  if Column=0 then
  begin
  Data:=GetNodeData(Node);
  if not fReg.Valueexists(Text) then
  begin
  fReg.RenameValue(Data.Name,Text);
  Data.Name:=text;
  InvalidateNode(Node);
  SetFocus;
  end else
  SetFocus;
  Selected[Node] := true;
  FocusedNode := Node;
  EditNode(Node, 0); //No Work
  end;
end;

procedure TRegList.DoEditValue;
var Data: PValueData;
  Node: PVirtualNode;
  intVal: Cardinal; //Integer;
begin
  Node := GetFirstSelected;
  if Assigned(Node) then
  begin
    Data := GetNodeData(Node);
    case Data.Vtype of
      rdString: begin
          FrmEditString.Name := Data.Name;
          FrmEditString.Value := fReg.ReadString(Data.Name);
          if FrmEditString.ShowModal = mrOK then
          begin
            fReg.Writestring(Data.Name, FrmEditString.Value);
            InvalidateNode(Node);
          end;
        end;
      rdBinary: begin
          EdBin.Form2.Hex.Data.SetSize(fReg.GetDataSize(Data.Name));
          fReg.ReadBinaryData(Data.Name, EdBin.Form2.Hex.Data.Memory^, EdBin.Form2.Hex.Data.Size);
          EdBin.Form2.Hex.Data.Position := 0;
          EdBin.Form2.Edit1.Text := Data.Name;

          Edbin.Form2.ShowModal;
        end;

      rdInteger: begin

          EdDWord1.Name := Data.Name;
          EdDWord1.RadioGroup1.ItemIndex := 0;
          IntVal := fReg.ReadInteger(Data.Name);
          if intVal >= 0 then
            EdDWord1.Value := IntToHex(IntVal, 1) else
          begin
            EdDWord1.RadioGroup1.ItemIndex := 1;
            EdDWord1.RadioGroup1.Enabled := false;
            EdDWord1.Value := IntToStr(IntVal);
          end;
          if EdDWord1.ShowModal = mrOK then
          begin
            fReg.Writeinteger(Data.Name, StrToIntDef(EdDWord1.Value, 0));
            InvalidateNode(Node);
          end;
          EdDWord1.RadioGroup1.Enabled := true;

        end;
    end;
  end;
end;


procedure TRegList.DoColumnDblClick(Column: TColumnIndex; Shift: TShiftState);
begin
DoEditValue;
end;


//******* LIB

function GetRootPath: string;
begin
  result := getHomeDir + '/.registry';
end;

procedure SplitKey(Inp: string; var BaseKey, KeyPath, Key: string);
var Interest, RegDir: string;
  Poso: integer;
begin
  RegDir := VirtualRootName;
  if Length(Inp) < Length(RegDir) then
    raise Exception.Create('SplitKey: Input too short');
  Interest := Copy(Inp, Length(RegDir) + 2, Length(Inp));
  if Interest <> '' then
  begin
    if Interest[Length(Interest)] = PathDelim then
      Interest := (Copy(Interest, 1, Length(Interest) - 1));
    Poso := Pos(PathDelim, Interest);
    BaseKey := Copy(Interest, 1, Poso - 1);
    Interest := Copy(Interest, Poso + 1, Length(Interest));
    Poso := LastDelimiter(PathDelim, Interest);
    KeyPath := Copy(Interest, 1, Poso - 1);
    Key := Copy(Interest, Poso + 1, Length(Interest));
    if BaseKey = '' then
    begin
      BaseKey := Key;
      Key := '';
    end;
  end;
end;

function MakeUniqueName(Strili: TStrings; var NewName: string): boolean;
var i: integer;
  StoredNew: string;
  count: integer;
  StoredCount: integer;
  changed: Boolean;
begin
  changed := false;
  if newName = '' then newName := 'untitled';
  StoredNew := NewName;
  count := 1;
  StoredCount := 0;
  for i := 0 to Strili.count - 1 do
  begin
    if NewName = Strili[i] then
    begin
      NewName := StoredNew + ' #' + inttostr(Count) + '';
      changed := true;
    end;
  end;
  if changed then
  begin
    while StoredCount <> Count do
    begin
      StoredCount := Count;
      for i := 0 to Strili.count - 1 do
      begin
        if (StoredNew + ' #' + inttostr(Count) + '' = Strili[i]) then
        begin
          changed := true;
          inc(Count);
        end;
      end;
    end;
    NewName := StoredNew + ' #' + inttostr(Count) + '';
  end;
  result := changed;
end;

end.


