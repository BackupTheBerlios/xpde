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
unit uSelectNetworkClient;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QComCtrls, uQXPComCtrls;

type
  TSelectNetworkClientDlg = class(TForm)
        Label2:TLabel;
        Label1:TLabel;
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Image1:TImage;
        Panel2:TPanel;
        Panel1:TPanel;
        ListView3:TListView;
        ListView2:TListView;
        ListView1:TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectNetworkClientDlg: TSelectNetworkClientDlg;

implementation

{$R *.xfm}

end.
