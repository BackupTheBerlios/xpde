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
unit uTCPIPFiltering;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, uQXPComCtrls;

type
  TTCPIPFilteringDlg = class(TForm)
        Button8:TButton;
        Button7:TButton;
        Button6:TButton;
        Button5:TButton;
        ListView3:TListView;
        Label3:TLabel;
        RadioButton6:TRadioButton;
        RadioButton5:TRadioButton;
        GroupBox3:TGroupBox;
        Button4:TButton;
        Button3:TButton;
        ListView2:TListView;
        Label2:TLabel;
        RadioButton4:TRadioButton;
        RadioButton3:TRadioButton;
        GroupBox2:TGroupBox;
        Button2:TButton;
        Button1:TButton;
        ListView1:TListView;
        Label1:TLabel;
        RadioButton2:TRadioButton;
        RadioButton1:TRadioButton;
        GroupBox1:TGroupBox;
        CheckBox1:TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TCPIPFilteringDlg: TTCPIPFilteringDlg;

implementation

{$R *.xfm}

end.
