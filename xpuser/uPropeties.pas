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

unit uPropeties;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QComCtrls, uXPUserUtils, uXPStyle, Libc;

type
  TPropeties = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    cbxGroup: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    UserName: TEdit;
    RealName: TEdit;
    XPStyle1: TXPStyle;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
  private
    UserRecord   : PPasswordRecord;
    { Private declarations }
  public
    { Public declarations }
    procedure SetSelectedUser(SelectedUser : string);
  end;

procedure RunPropeties(UserName : string);

var
  Propeties: TPropeties;

implementation

{$R *.xfm}

procedure TPropeties.SetSelectedUser(SelectedUser : string);
begin
 setpwent();
 UserRecord := getpwnam(PChar(SelectedUser));
 endpwent();
end;

procedure TPropeties.FormShow(Sender: TObject);
 var
  index : integer;
begin
 SetSelectedUser(UserSelected);
 with UserRecord^ do begin
  UserName.Text := pw_name;
  RealName.Text := pw_gecos;
  cbxGroup.Text := getgrgid(pw_gid)^.gr_name;

// UserRecord.p_dir;
// UserRecord.p_shell;
  end;
end;

procedure TPropeties.btnOkClick(Sender: TObject);
begin
 //Save Change to passwd file and ..., close dialog
 Close;
end;

procedure TPropeties.btnCancelClick(Sender: TObject);
begin
 //Do not save Change to passwd file and ..., close dialog
  Close;
end;


procedure TPropeties.btnApplyClick(Sender: TObject);
begin
 //Save Change to passwd file and ..., do not close dialog
end;




//*****************************************************************************
procedure RunPropeties(UserName : string);
begin
  UserSelected := UserName;
  Propeties.ShowModal;
end;

end.
