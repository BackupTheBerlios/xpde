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

unit uOpenWith;

interface

uses
  SysUtils, Types, Classes,
  QGraphics, QControls, QForms,
  QDialogs,uXPStyleConsts,
  QStdCtrls, QComCtrls, QExtCtrls;

type
  TOpenWithDlg = class(TForm)
        btnCancel: TButton;
        btnOk: TButton;
        btnBrowse: TButton;
        cbAlways: TCheckBox;
        tvPrograms: TTreeView;
        GroupBox1:TGroupBox;
        lbDocument: TLabel;
        Label2:TLabel;
        Label1:TLabel;
        Image1:TImage;
        Panel1:TPanel;
        odProgram: TOpenDialog;
        procedure btnBrowseClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure btnOkClick(Sender: TObject);
        procedure btnCancelClick(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
        filename:string;
        executable: string;
  end;

var
  OpenWithDlg: TOpenWithDlg;

implementation

uses uXPAPI,uXPAPI_imp;

{$R *.xfm}

procedure TOpenWithDlg.btnBrowseClick(Sender: TObject);
begin
    if odProgram.execute then begin
        executable:=odProgram.filename;        
    end;
end;

procedure TOpenWithDlg.FormShow(Sender: TObject);
begin
    executable:='';
end;
procedure TOpenWithDlg.btnOkClick(Sender: TObject);
var
    ext:string;
begin
    ext:=ansilowercase(extractfileext(filename));
    if executable<>'' then begin
        if cbAlways.Checked then begin
            XPAPI.storeExecutable(ext,executable+' %1');
        end;
        StartApp(executable,filename);
    end;
    close;
end;

procedure TOpenWithDlg.btnCancelClick(Sender: TObject);
begin
    close;
end;

procedure TOpenWithDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    action:=caFree;
end;


procedure TOpenWithDlg.FormCreate(Sender: TObject);
begin
    image1.picture.loadfromfile(XPAPI.getSysInfo(siSystemDir)+gSEARCH);
end;

end.
