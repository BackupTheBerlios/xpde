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

unit uSelectObj;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QComCtrls, QCheckLst;

type
  TObjTypes = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    chckObject: TCheckListBox;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chckObjectClick(Sender: TObject);
    procedure chckObjectClickCheck(Sender: TObject);
  private
    { Private declarations }
    ObjectType : string;
    CurrentSelect : byte;

  public
    { Public declarations }
  end;

function RunObjTypesDlg(var SelType : string) : boolean;

var
  ObjTypes: TObjTypes;

implementation

 uses uGroupUserResourse;

{$R *.xfm}
function RunObjTypesDlg(var SelType : string) : boolean;
 var
  i : integer;
begin
 with TObjTypes.Create(Application) do begin
   ObjectType := SelType;
   for i := 0 to chckObject.Items.Count -1 do
    if chckObject.Items.Strings[i] = ObjectType then begin
      chckObject.Checked[i] := True;
      chckObject.Selected[i] := True;
      CurrentSelect := i;
    end;
   ShowModal;
   if ModalResult = mrOk then begin
     SelType := ObjectType;
     Result := True;
     Close;
   end
    else Result := False;
 end
end;

procedure TObjTypes.btnOkClick(Sender: TObject);
 var
  i : integer;
begin
 ObjectType := chckObject.Items.Strings[chckObject.ItemIndex];
 ModalResult := mrOk;
end;

procedure TObjTypes.btnCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TObjTypes.FormCreate(Sender: TObject);

begin
 chckObject.Items.Add(objtypestr1);
 chckObject.Items.Add(objtypestr2);
 chckObject.Items.Add(objtypestr3);
// chckObject.Items.Add(objtypestr4) ;
end;

procedure TObjTypes.chckObjectClick(Sender: TObject);
var
  i : byte;
begin
 chckObject.Checked[CurrentSelect] := False;
 for i := 0 to chckObject.Items.Count -1 do
   if chckObject.Selected[i] then CurrentSelect := i;
 chckObject.Checked[CurrentSelect] := True;
end;

procedure TObjTypes.chckObjectClickCheck(Sender: TObject);
begin
 chckObject.Checked[CurrentSelect] := False;
 CurrentSelect := chckObject.ItemIndex;
end;

end.
