unit VTHeaderPopup;

//----------------------------------------------------------------------------------------------------------------------
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// The Original Code is VTHeaderPopup.pas.
//
// The Initial Developer of the Original Code is Ralf Junker <delphi@zeitungsjunge.de>. All Rights Reserved.
//
// Modifed 2.17.02 by Jim Kueneman.  Added the event to filter items added to menu
//----------------------------------------------------------------------------------------------------------------------

{$I Compilers.inc}

interface

uses
{$IFNDEF QT_CLX}
  Menus,
{$ELSE}
  QMenus,
{$ENDIF}
  VirtualTrees;

type
  TAddPopupItemType = (
    apNormal,
    apDisabled,
    apHidden
  );

type
  TOnAddHeaderPopupItem = procedure(Sender: TBaseVirtualTree; ColumnIndex: integer;
    var Cmd: TAddPopupItemType) of object;

type
  TVTHeaderPopupMenu = class(TPopupMenu)
  private
    FOnAddHeaderPopupItem: TOnAddHeaderPopupItem;
  protected
    procedure DoAddHeaderPopupItem(ColumnIndex: TColumnIndex; var Cmd: TAddPopupItemType);
    procedure OnMenuItemClick(Sender: TObject);
  public
    procedure Popup(X, Y: Integer); override;
  published
    property OnAddHeaderPopupItem: TOnAddHeaderPopupItem read FOnAddHeaderPopupItem write FOnAddHeaderPopupItem;
  end;

//----------------------------------------------------------------------------------------------------------------------

implementation

uses
  Classes;

type
  TVirtualTreeCast = class(TBaseVirtualTree); // Necessary to make the header accessible.

//----------------- TVTHeaderPopupMenu ---------------------------------------------------------------------------------

procedure TVTHeaderPopupMenu.DoAddHeaderPopupItem(ColumnIndex: TColumnIndex; var Cmd: TAddPopupItemType);

begin
  Cmd := apNormal;
  if Assigned(OnAddHeaderPopupItem) then
    OnAddHeaderPopupItem(TVirtualTreeCast(PopupComponent), ColumnIndex, Cmd);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVTHeaderPopupMenu.OnMenuItemClick(Sender: TObject);

var
  I: Integer;

begin
  if Assigned(PopupComponent) then
  begin
    I := Items.IndexOf(TMenuItem(Sender));
    if I >= 0 then
    begin
      with TVirtualTreeCast(PopupComponent).Header.Columns.Items[I] do
        if TMenuItem(Sender).Checked then
          Options := Options - [coVisible]
        else
          Options := Options + [coVisible];
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TVTHeaderPopupMenu.Popup(X, Y: Integer);

var
  I: Integer;
  NewMenuItem: TMenuItem;
  Cmd: TAddPopupItemType;

begin
  if PopupComponent = nil then
    Exit;

  // Delete existing menu items.
  I := Items.Count;
  while I > 0 do
    begin
      Dec(I);
      Items.Delete(I);
    end;

  // Add column menu items.
  with TVirtualTreeCast(PopupComponent).Header do
  begin
    if hoShowImages in Options then
      Self.Images := Images;
    for I := 0 to Columns.Count - 1 do
      with Columns[I] do
      begin
        DoAddHeaderPopupItem(I, Cmd);
        if Cmd <> apHidden then
        begin
          NewMenuItem := TMenuItem.Create(Self);
          NewMenuItem.Caption := Text;
          NewMenuItem.Hint := Hint;
          NewMenuItem.ImageIndex := ImageIndex;
          NewMenuItem.Checked := coVisible in Options;
          NewMenuItem.OnClick := OnMenuItemClick;
          NewMenuItem.Enabled := Cmd = apNormal;
          Items.Add(NewMenuItem);
        end
      end;
  end;

  inherited;
end;

//----------------------------------------------------------------------------------------------------------------------

end.

