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

unit uRegTree;

interface

uses VirtualTrees, Types, Classes, uRegistry, Sysutils, QControls,
  QDialogs, uRegList;
type
  PDirData = ^TDirData;

  TDirData = record
    Name: TFileName;
    HasSubFolders: boolean;
  end;

  TRegTree = class(TVirtualStringTree)
  private
    fReg: TRegistry;
    fFirstSel: PVirtualNode;
    fRegList: TRegList;
  protected
    procedure Dogettext(Node: Pvirtualnode; Column: Tcolumnindex; Texttype: Tvsttexttype;
      var Text: WideString); override;
    function DoExpanding(Node: PVirtualNode): Boolean; override;
    function DoCollapsing(Node: PVirtualNode): Boolean; override;
    procedure Dogetimageindex(Node: Pvirtualnode; Kind: Tvtimagekind; Column: Tcolumnindex;
      var Ghosted: Boolean; var Index: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DoNewText(Node: PVirtualNode; Column: TColumnIndex; Text: WideString); override;
    function CanEdit(Node: PVirtualNode; Column: TColumnIndex): Boolean; override;
    procedure DoFocusChange(Node: PVirtualNode; Column: TColumnIndex); override;
    function DoCompare(Node1, Node2: PVirtualNode; Column: TColumnIndex): Integer; override;
    procedure DoExit; override;
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
    procedure GetKeys(Node: PVirtualNode);
    procedure Initialize;
    procedure AddKey;
    procedure DeleteKey;
    function CanCreateKey: boolean;
    function CanDeleteKey: boolean;
    function GetPath(Node: PVirtualNode): string;
    function GetPathOnly(Node: PVirtualNode): string;
    procedure SetListKey(Node: PVirtualNode);
    function ExpandPath(Path: string): PVirtualNode;
    procedure StartInit;
  published
    property List: TRegList read fRegList write fRegList;
  end;
function GetRootPath: string;
function MakeUniqueName(Strili: TStrings; var NewName: string): boolean;
procedure SplitKey(Inp: string; var BaseKey, KeyPath, Key: string);

const VirtualRootName = 'My Computer';
const Appkey = 'Software/XPde/Regedit';

implementation
uses RTLConsts, DmFrame, Math;

constructor TRegTree.Create;
begin
  inherited;
  BevelInner := bvNone;
  fReg := TRegistry.Create;
  fReg.RootKey := '';
  fReg.OpenKey('', false);
  TreeOptions.PaintOptions := [toUseBlendedImages, toShowButtons, toShowRoot, toShowTreeLines];
  TreeOptions.SelectionOptions := [toRightClickSelect];
  TreeOptions.MiscOptions := TreeOptions.MiscOptions + [toEditable];
  CheckImageKind := ckXP;
  ButtonFillMode := fmShaded;

  NodeDataSize := SizeOf(TDirData);
  StartInit;

end;

procedure TRegTree.StartInit;
var NewNode: PVirtualNode;
  Data: PDirData;
begin
  NewNode := AddChild(RootNode);
  Data := GetNodeData(NewNode);
  Data.Name := VirtualRootName;
  Data.HasSubFolders := true;
  NewNode.States := NewNode.States + [vsHasChildren];
  Selected[NewNode] := true;
end;

function TRegTree.CanEdit(Node: PVirtualNode; Column: TColumnIndex): Boolean;
begin
  result := CanDeleteKey;
end;

procedure TRegTree.DoExit;
var Node:PVirtualNode;
begin
 inherited;
 Node:=GetFirstSelected;
 if assigned(Node) then
   if tsEditing in TreeStates then EndEditNode;
end;

procedure TRegTree.DoFocusChange(Node: PVirtualNode; Column: TColumnIndex);
begin
  inherited;
  if assigned(Node) then SetListKey(Node);
end;

function TRegTree.ExpandPath(Path: string): PVirtualNode;
var NewNode, BaseNode: PVirtualNode;
  Data: PDirData;
  Count, ListSize: integer;
  PathList: TStrings;

  procedure CheckNode;
  begin
    Data := GetNodeData(NewNode);

    if Data.Name = pathList[count] then
    begin
      Expanded[NewNode] := true;
      Result := NewNode;
      if count < ListSize then
        BaseNode := NewNode.FirstChild
      else
        BaseNode := nil;
    end;
  end;

begin
  Result:=nil;
  pathList := TStringList.create;
  pathList.Text := StringReplace(Path, '/', #13#10, [rfReplaceAll]);
  Count := 0;

  Expanded[RootNode.FirstChild] := true;
  ListSize := pathList.count - 1;
  BaseNode := nil;
  NewNode := RootNode.FirstChild.FirstChild;
  repeat
    if NewNode <> nil then
    begin
      CheckNode;
      repeat
        NewNode := NewNode.NextSibling;
        if NewNode <> nil then CheckNode;
      until NewNode = nil;
    end;
    NewNode := BaseNode;
    if count < ListSize then
      inc(count) else BaseNode := nil;
  until (BaseNode = nil);

  pathList.free;
end;

procedure TRegTree.Initialize;
var Resnode: PVirtualNode;
var LastKey: string;
begin
  fReg.RootKey := HKEY_CURRENT_USER;

  if fReg.OpenKey(AppKey, false) then
  begin
    LastKey := fReg.Readstring('lastkey');
    fReg.CloseKey;
    if Lastkey <> '' then
    begin
      ResNode := ExpandPath(LastKey);
      FocusedNode := Resnode;
      Selected[Resnode] := true;
    end;
  end;

end;



destructor TRegTree.Destroy;
var pn: string;
begin
  pn := GetPath(GetFirstSelected);
  pn := Copy(pn, Length(VirtualRootName) + 2, Length(pn));
  fReg.RootKey := HKEY_CURRENT_USER;
  fReg.OpenKey(AppKey, true);
  fReg.Writestring('lastkey', pn);
  fReg.free;
  inherited;
end;


function TRegTree.GetPath(Node: PVirtualNode): string;
var NewNode: PVirtualNode;
begin
  if Node<>nil then
  begin
  NewNode := Node;
  Result := '';
  if NewNode <> RootNode then
    repeat
      Result := PDirData(GetNodeData(NewNode)).Name + PathDelim + Result;
      NewNode := NewNode.Parent;
    until NewNode = RootNode;
  end;    
end;

function TRegTree.GetPathOnly(Node: PVirtualNode): string;
var BaseKey, KeyPath, Key: string;
begin
  SplitKey(GetPath(Node), BaseKey, KeyPath, Key);
  if KeyPath <> '' then
    Result := KeyPath + PathDelim + Key else
    Result := Key;
end;

procedure TRegTree.GetKeys(Node: PVirtualNode);
var
  Fobj: PDirData;
  NewNode: PVirtualNode;
  Data: PDirData;
  DataList, KeyNames: TStrings;
  Ki: TRegKeyInfo;
  i: integer;
  NodePath: string;
  BaseKey, KeyPath, Key: string;
begin

  SplitKey(GetPath(Node), BaseKey, KeyPath, Key);
  fReg.RootKey := BaseKey;
  fReg.OpenKey(KeyPath + PathDelim + Key, false);

  DataList := TStringList.create;
  KeyNames := TStringList.create;

  NewNode := Node.FirstChild;
  if NewNode <> nil then
  begin
    Data := GetNodeData(NewNode);
    DataList.AddObject(Data.Name, TObject(NewNode));
    repeat
      NewNode := NewNode.NextSibling;
      if NewNode <> nil then
      begin
        Data := GetNodeData(NewNode);
        DataList.AddObject(Data.Name, TObject(NewNode));
      end;
    until NewNode = nil;
  end;

  fReg.GetKeyNames(KeyNames);

  NodePath := GetPathOnly(Node);
  if NodePath <> '' then NodePath := NodePath + PathDelim;

  for i := 0 to KeyNames.count - 1 do
  begin
    if DataList.IndexOf(KeyNames[i]) = -1 then
    begin

      fReg.OpenKey(NodePath + KeyNames[i], false);
      fReg.GetKeyInfo(Ki);
      fReg.CloseKey;
      NewNode := AddChild(Node);
      Fobj := GetNodeData(NewNode);
      Fobj.Name := KeyNames[i];
      Fobj.HasSubFolders := Ki.NumSubKeys > 0;
      if Fobj.HasSubFolders then
        NewNode.States := NewNode.States + [vsHasChildren];
    end;
  end;

  DataList.free;
  KeyNames.free;
  Sort(Node, 0, sdAscending);
end;

procedure TRegTree.Dogettext(Node: Pvirtualnode; Column: Tcolumnindex; Texttype: Tvsttexttype;
  var Text: WideString);
var Data: pDirData;
begin
  Data := GetNodeData(Node);
  if Assigned(Data) then Text := Data.Name;
end;

function TRegTree.DoExpanding(Node: PVirtualNode): Boolean;
begin
  Result := true;
  GetKeys(Node);
  SetFocus;
end;

function TRegTree.DoCollapsing(Node: PVirtualNode): Boolean;
begin
  Result := true;
  Selected[Node] := true;
  FocusedNode := Node;
  SetFocus;
end;

procedure TRegTree.Dogetimageindex(Node: Pvirtualnode; Kind: Tvtimagekind; Column: Tcolumnindex;
  var Ghosted: Boolean; var Index: Integer);
begin
  inherited;
  if Node = RootNode.FirstChild then Index := 2 else
    if vsSelected in Node.States then
      Index := 0 else Index := 1;
end;


procedure TRegTree.AddKey;
var OpenKey, NewString: string;
  StrLi: TStrings;
  NewNode:PVirtualNode;
  Data: pDirData;
var BaseKey, KeyPath, Key: string;
begin
  fFirstSel := GetFirstSelected;
  if assigned(fFirstSel) then
  begin
    SplitKey(GetPath(fFirstSel), BaseKey, KeyPath, Key);
    fReg.RootKey := BaseKey;
    OpenKey := KeyPath + PathDelim + Key;

    begin
      NewString := 'New Key';
      StrLi := TStringList.create;
      fReg.OpenKey(Openkey, true);
      fReg.GetKeyNames(StrLi);
      fReg.CloseKey;
      MakeUniqueName(StrLi, NewString);
      StrLi.free;




      if OpenKey <> '' then OpenKey := OpenKey + '/' + NewString else Openkey := NewString;
      if not fReg.OpenKey(Openkey, true) then
        raise ERegistryException.CreateResFmt(@SRegCreateFailed, [Openkey]);


      NewNode:=AddChild(fFirstSel);
      Data := GetNodeData(NewNode);
      Data.Name := NewString;
      Data.HasSubFolders := false;

      Selected[NewNode] := true;
      FocusedNode := NewNode;
      EditNode(NewNode, -1);
    end;
  end;
end;

procedure TRegTree.DeleteKey;
var BaseKey, KeyPath, Key: string;
NextKey:PVirtualNode;
begin
  fFirstSel := GetFirstSelected;
  if assigned(fFirstSel) then
  begin
    if MessageDlg('Really delete this key? '{+GetPath(fFirstSel)}, mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
    begin
      SplitKey(GetPath(fFirstSel), BaseKey, KeyPath, Key);
      fReg.RootKey := BaseKey;
      if fReg.OpenKey(KeyPath + PathDelim + Key, false) then
      begin
        fReg.DeleteKey;

        if assigned(fFirstSel.PrevSibling)
         then NextKey:=fFirstSel.PrevSibling else
         NextKey:=fFirstSel.Parent;
         Selected[NextKey] := true;
         FocusedNode := NextKey;
        DeleteNode(fFirstSel, false);
      end;
    end;
  end;
end;

procedure TRegTree.SetListKey(Node: PVirtualNode);
var BaseKey, KeyPath, Key: string;
begin
  SplitKey(GetPath(Node), BaseKey, KeyPath, Key);
  fRegList.setKey(BaseKey, KeyPath +PathDelim+ Key);
end;

procedure TRegTree.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var Node: PVirtualNode;
var Data: PDirData;
begin
  inherited;
end;

procedure TRegTree.DoNewText(Node: PVirtualNode; Column: TColumnIndex; Text: WideString);
var BaseKey, KeyPath, Key, OldKey, NewKey: string;
var Data: PDirData;
begin
  inherited;
  fFirstSel := GetFirstSelected;
  if assigned(fFirstSel) then
  begin
    SplitKey(GetPath(fFirstSel), BaseKey, KeyPath, Key);
    fReg.RootKey := BaseKey;
    OldKey := KeyPath + PathDelim + Key;
    NewKey := KeyPath + PathDelim + Text;

    if not fReg.KeyExists(NewKey) then
    begin
      fReg.MoveKey(OldKey, NewKey, true);
      Data := GetNodeData(fFirstSel);
      Data.Name := Text;
      InvalidateNode(fFirstSel);
      SetFocus;
    end else
    begin
      SetFocus;
      EditNode(fFirstSel, -1); //No Work
    end;
  end;
end;

function TRegTree.CanDeleteKey: boolean;
begin
  fFirstSel := GetFirstSelected;
  Result := not ((fFirstSel.Parent = RootNode) or (fFirstSel.Parent.Parent = RootNode));
end;

function TRegTree.CanCreateKey: boolean;
begin
  fFirstSel := GetFirstSelected;
  Result := not ((fFirstSel.Parent = RootNode));
end;

function getFirstDiffChar(Str1, Str2: string): integer;
var Len, i: integer;
begin
  Len := Min(Length(Str1), Length(Str2));
  for i := 1 to Len do
    if Str1[i] <> Str2[i] then break;
  Result := i;
end;


function TRegTree.Docompare(Node1, Node2: Pvirtualnode; Column: Tcolumnindex): Integer;
var Str1, Str2: string;
  i: integer;
begin
  if Column = 0 then
  begin

    Str1 := lowercase(PDirData(GetNodeData(Node1)).Name);
    Str2 := lowercase(PDirData(GetNodeData(Node2)).Name);
    Result:=AnsiCompareText(Str1,Str2);
  end else
    Result := 0;
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


