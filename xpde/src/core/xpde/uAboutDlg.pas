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
unit uAboutDlg;

interface

uses
  SysUtils, Types, Classes,
  uXPAPI,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, Libc;

type
  TAboutDlg = class(TForm)
    lbProgram: TLabel;
    lbVersion: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lbFree: TLabel;
    Bevel1: TBevel;
    Button1: TButton;
    Image2: TImage;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutDlg: TAboutDlg;

implementation

{$R *.xfm}

procedure TAboutDlg.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if key=#27 then modalresult:=mrCancel;
end;

procedure TAboutDlg.FormShow(Sender: TObject);
var
    sinf:_sysinfo;
    freem: integer;
begin
    Libc.Sysinfo(sinf);
    freem:=sinf.freeram+sinf.bufferram;

    lbFree.Caption:= IntTostr(longint(freem) div 1024)+' Kb';
    lbVersion.Caption:= XPAPI.getversionstring;    
end;

end.
