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

unit xpnewuser;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls;

type
  TNew_User = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cbChange: TCheckBox;
    cbNotChange: TCheckBox;
    cbExpires: TCheckBox;
    cbDisable: TCheckBox;
    btnCreate: TButton;
    btnClose: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    edName: TEdit;
    edFullName: TEdit;
    edDescrip: TEdit;
    edPasswd: TEdit;
    edPasswd2: TEdit;
    cbSamba: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  New_User: TNew_User;

implementation

uses uUserPropeties;

{$R *.xfm}

procedure TNew_User.btnCloseClick(Sender: TObject);
begin
  Properties.Show;
// Close;
end;

procedure TNew_User.btnCreateClick(Sender: TObject);
begin
// AddNewUser();
// if cbSamba.Checked = true then AddNewSmbUser();
 Close;
end;

end.
