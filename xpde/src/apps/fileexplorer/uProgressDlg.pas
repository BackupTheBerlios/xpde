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
unit uProgressDlg;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs, uXPAPI,
  QStdCtrls, QExtCtrls, QComCtrls,
  uQXPComCtrls;

type
  TProgressDlg = class(TForm)
    imProgress: TImage;
    lbFile: TLabel;
    lbStatus: TLabel;
    pbProgress: TProgressBar;
    btnCancel: TButton;
    lbETA: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure updateDialog(const progress, max: integer; const str, status, eta: string);
  end;

var
  ProgressDlg: TProgressDlg;

implementation

{$R *.xfm}

{ TProgressDlg }

procedure TProgressDlg.updateDialog(const progress, max: integer;
  const str, status, eta: string);
begin
    lbFile.caption:=str;
    lbStatus.caption:=status;
    lbETA.caption:=eta;
    pbProgress.Max:=max;
    pbProgress.Position:=progress;
end;

procedure TProgressDlg.btnCancelClick(Sender: TObject);
begin
    tag:=1;
end;

procedure TProgressDlg.FormCreate(Sender: TObject);
begin
    imProgress.Picture.LoadFromFile(XPAPI.getsysinfo(siMiscDir)+'copyprogress.png');
end;

end.
