{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 Zeljan Rikalo <zeljko@xpde.com>                          }
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

unit uAboutTaskManager;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls;

type
  TAboutTaskManagerDlg = class(TForm)
        Button1:TButton;
        Label9:TLabel;
        Label8:TLabel;
        Label7:TLabel;
        Label6:TLabel;
        Label5:TLabel;
        Label3:TLabel;
        Label2:TLabel;
        Label1:TLabel;
        Image1:TImage;
        Panel1:TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutTaskManagerDlg: TAboutTaskManagerDlg;
  tm_version,tm_build:string;
implementation

{$R *.xfm}

procedure TAboutTaskManagerDlg.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TAboutTaskManagerDlg.FormShow(Sender: TObject);
begin
Label2.Caption:='Version '+tm_version+' (Build '+tm_build+')';
end;

procedure TAboutTaskManagerDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action:=caFree;
end;

end.
