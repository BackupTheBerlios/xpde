{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003, Valeriy Gabrusev <g_valery@ukr.net>                           }
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

unit uChangePassw;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, uXPStyle, uXpUserUtils, QMask;

type
  TChangePasswd = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    XPStyle1: TXPStyle;
    NewPasswd: TEdit;
    ConfPasswd: TEdit;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure RunChangeUserPasswd(UserName : string);

var
  ChangePasswd: TChangePasswd;

implementation
 uses uResString;

{$R *.xfm}

procedure TChangePasswd.btnOkClick(Sender: TObject);
begin
 //Change Password and save
 if (NewPasswd.Text <> '') AND (NewPasswd.Text = ConfPasswd.Text) then
    if ChangeUserPassword(UserSelected, NewPasswd.Text) = 0 then begin
      ShowMessage(sMsg8);
      Close;
     end
      else ShowMessage(sMsg9 + UserSelected)
 else
     ShowMessage(sMsg10);
end;

procedure TChangePasswd.btnCancelClick(Sender: TObject);
begin
 //Do not Change Password and save
 Close;
end;

procedure TChangePasswd.FormShow(Sender: TObject);
begin
  Caption :=   sMsg11 + UserSelected;
end;


//*****************************************************************************
procedure RunChangeUserPasswd(UserName : string);
begin
  UserSelected := UserName;
  ChangePasswd.ShowModal;
end;


end.
