{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003, Valeriy Gabrusev <valery@xpde.com>                      }
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

unit uGroupAndUser;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QComCtrls, QCheckLst;

type
  TSelUserGroup = class(TForm)
    Label1: TLabel;
    edObjectType: TEdit;
    Label2: TLabel;
    edLocation: TEdit;
    Label3: TLabel;
    btnObjTypes: TButton;
    btnLocation: TButton;
    btnCheckName: TButton;
    btnOk: TButton;
    btnCancel: TButton;
    chckUserGroup: TCheckListBox;
    procedure btnObjTypesClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnLocationClick(Sender: TObject);
    procedure btnCheckNameClick(Sender: TObject);
  private
    { Private declarations }
   ObjectType : string;
   Location : string;

   procedure FillchckUserGroup;
  public
    { Public declarations }
  end;

function RunSelectObjDlg(SelType : string; var ListObject : TStringList) : boolean;

var
  SelUserGroup: TSelUserGroup;
  MemberListStr : TStringList;

implementation

uses uSelectObj, uLocationObj, uGroupUserResourse, uXPuserUtils, SysProvider;

{$R *.xfm}

function RunSelectObjDlg(SelType : string; var ListObject : TStringList) : boolean;
 var
  i : integer;
  sp : TSysProvider;
begin
 ListObject.Clear;
 with TSelUserGroup.Create(Application) do begin
  ObjectType := SelType;
  sp := TSysProvider.Create;
  Location := sp.HostName;
  sp.Destroy;
  edObjectType.Text := ObjectType;
  edLocation.Text := Location;
  FillchckUserGroup;
  ShowModal;
  if ModalResult = mrOk then begin
    for i := 0 to chckUserGroup.Items.Count-1 do
     if chckUserGroup.Checked[i] then ListObject.Add(chckUserGroup.Items.Strings[i]);
    Result := True
   end
    else Result := False;
 end;
end;

procedure TSelUserGroup.FillchckUserGroup;
 var
   ObjectList :TStringList;
   i : integer;
begin
  ObjectList := TStringList.Create;
  ObjectList.Clear;
  chckUserGroup.Items.Clear;
  chckUserGroup.Items.BeginUpdate;
  if ObjectType =  objtypestr1 then begin
    MakeUserList(ObjectList, True);
    for i := 0 to ObjectList.Count-1 do chckUserGroup.Items.Add(ObjectList.Strings[i])
  end;

  if ObjectType =  objtypestr2 then begin
   MakeGroupList(ObjectList);
    for i := 0 to ObjectList.Count-1 do chckUserGroup.Items.Add(ObjectList.Strings[i])
  end;

  if ObjectType =  objtypestr3 then begin
   MakeUserList(ObjectList, False);
    for i := 0 to ObjectList.Count-1 do chckUserGroup.Items.Add(ObjectList.Strings[i])
  end;

//  if ObjectType =  objtypestr4 then begin
//  end;
  chckUserGroup.Items.EndUpdate;
  ObjectList.Free;
end;

procedure TSelUserGroup.btnObjTypesClick(Sender: TObject);
 var
   ObjType : string;
   ObjectList :TStringList;
   i : integer;
begin
  chckUserGroup.Items.Clear;
  RunObjTypesDlg(ObjectType);
  edObjectType.Text := ObjectType;
  FillchckUserGroup;
end;

procedure TSelUserGroup.btnOkClick(Sender: TObject);
begin
 ModalResult := mrOk;
// btnOk.ModalResult;
end;

procedure TSelUserGroup.btnCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TSelUserGroup.btnLocationClick(Sender: TObject);
begin
 if RunLocationObjDlg(Location) then edLocation.Text:= Location;
end;

procedure TSelUserGroup.btnCheckNameClick(Sender: TObject);
begin
 FillchckUserGroup;
end;

end.
