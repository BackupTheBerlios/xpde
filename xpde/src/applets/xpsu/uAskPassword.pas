{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 José León Serna <ttm@xpde.com>                           }
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
unit uAskPassword;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, Libc,
  QDialogs, QStdCtrls, QExtCtrls;

type
  TAskPasswordDlg = class(TForm)
    imKeys: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edPassword: TEdit;
    cbUsername: TComboBox;
    rbCustom: TRadioButton;
    rbCurrentUser: TRadioButton;
    cbProtect: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);  private
    { Private declarations }
  public
    { Public declarations }
    names: TStringList;
  end;

var
  AskPasswordDlg: TAskPasswordDlg;

implementation

{$R *.xfm}

procedure getUserList(strings: TStrings;names: TStrings);
var
    pw: PPasswordRecord;
begin
    pw:=getpwent;
    try
        while assigned(pw) do begin
            strings.add(pw^.pw_name);
            names.add(pw^.pw_gecos);
            pw:=getpwent;
        end;
    finally
        endpwent;
    end;
end;


procedure TAskPasswordDlg.FormCreate(Sender: TObject);
begin
    names:=TStringList.create;
    getUserList(cbUsername.items,names);
end;

procedure TAskPasswordDlg.FormDestroy(Sender: TObject);
begin
    names.free;
end;

end.
