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
unit uRun;

interface

uses
  SysUtils, Types, Classes,
  QGraphics, QControls, QForms,
  QDialogs, uXPStyleConsts,
  QStdCtrls, QExtCtrls, uXPAPI, uXPLocalizator;

type
  TRunDlg = class(TForm)
        Button3:TButton;
    btnCancel: TButton;
    btnOk: TButton;
        CheckBox1:TCheckBox;
    cbOpen: TComboBox;
        Label2:TLabel;
        Label1:TLabel;
    Image1: TImage;
    XPLocalizator1: TXPLocalizator;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RunDlg: TRunDlg;

procedure showRunDlg;

implementation

uses uTaskBar;

{$R *.xfm}


procedure showRunDlg;
begin
    if not assigned(RunDlg) then RunDlg:=TRunDlg.create(application);

    rundlg.left:=5;
    rundlg.top:=taskbar.Top-rundlg.height-30;
    RunDlg.show;
    rundlg.activecontrol:=nil;
    rundlg.activecontrol:=rundlg.cbOpen;    
end;

procedure TRunDlg.btnOkClick(Sender: TObject);
begin
    XPAPI.ShellExecute(cbOpen.text,false);
    close;
end;

 procedure TRunDlg.btnCancelClick(Sender: TObject);
begin
    close;
end;

procedure TRunDlg.FormCreate(Sender: TObject);
begin
        image1.Picture.LoadFromFile(XPAPI.getsysinfo(siSystemDir)+sRUN);
end;

end.
