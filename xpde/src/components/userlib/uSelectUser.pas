{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003 Valeriy Gabrusev <valera@xpde.com>                           }
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

unit uSelectUser;

interface

uses SysUtils, Classes, QGraphics, QForms,
  QButtons, QExtCtrls, QControls, QStdCtrls, uXPPNG;

const
  mrOk     = 1;
  mrCancel = 0;


type
  TdlgSelectUserDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Image1: TImage;
    inptUser: TComboBox;
    inptPass: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
   newUser, newPassword : string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgSelectUserDlg: TdlgSelectUserDlg;

function RunSelectUser(var user: string; var passwd : string) : boolean;

implementation

{$R *.xfm}

function RunSelectUser(var user: string; var passwd : string) : boolean;
begin
 with TdlgSelectUserDlg.Create(Application) do begin;
  inptUser.Text := user;
  inptPass.Text := passwd;
  ShowModal;
  if ModalResult =mrOk then begin
    user := newUser;
    passwd := newPassword;
    result := True;
  end
   else result := False;
 end;
end;



procedure TdlgSelectUserDlg.OKBtnClick(Sender: TObject);
begin
  newUser := inptUser.Text;
  newPassword := inptPass.Text;
  ModalResult := mrOk;
end;

procedure TdlgSelectUserDlg.CancelBtnClick(Sender: TObject);
begin
  newUser := inptUser.Text;
  newPassword := inptPass.Text;
  ModalResult := mrCancel;
end;

end.
