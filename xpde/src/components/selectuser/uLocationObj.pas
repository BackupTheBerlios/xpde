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

unit uLocationObj;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QComCtrls, QCheckLst;

type
  TLocationObj = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    trvLocation: TTreeView;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    LocationPath: string;
    LocationList : TStringList;
    procedure MakeLocationList;

  public
    { Public declarations }
  end;

var
  LocationObj: TLocationObj;

function RunLocationObjDlg(var Location : string) : boolean;

implementation

 uses uGroupUserResourse, SysProvider;

{$R *.xfm}
function RunLocationObjDlg(var Location : string) : boolean;
 var
  i : integer;
begin
 with TLocationObj.Create(Application) do begin
   LocationPath := Location;
   ShowModal;
   if ModalResult = mrOk then begin
     Location := LocationPath;
     Result := True;
     Close;
   end
    else Result := False;
 end
end;


procedure TLocationObj.MakeLocationList;
 var
   sp : TSysProvider;
begin
 sp := TSysProvider.Create;
 LocationList.Add(sp.HostName);
 sp.Destroy;
end;

procedure TLocationObj.FormCreate(Sender: TObject);
 var
  rootItem : TTreeNode;
  i : byte;
begin
 LocationList := TStringList.Create;
 MakeLocationList;
 for i := 0 to LocationList.Count-1 do
  rootItem := trvLocation.Items.Add(nil, LocationList.Strings[i]);
 trvLocation.Items.Item[0].Selected := true;
end;

procedure TLocationObj.FormDestroy(Sender: TObject);
begin
 LocationList.Free;
end;

procedure TLocationObj.btnOkClick(Sender: TObject);
 var
  i : integer;
begin
 LocationPath := trvLocation.Selected.Text;
 ModalResult := mrOk;
end;

procedure TLocationObj.btnCancelClick(Sender: TObject);
begin
 Close;
end;

end.
