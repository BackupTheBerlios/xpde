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
unit uAdvancedSettings;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, uQXPComCtrls;

type
  TAdvancedSettingsDlg = class(TForm)
        Label7:TLabel;
        GroupBox3:TGroupBox;
        ListView2:TListView;
        Label6:TLabel;
        Button9:TButton;
        Label5:TLabel;
        Edit2:TEdit;
        Label4:TLabel;
        Button8:TButton;
        Edit1:TEdit;
        Label3:TLabel;
        GroupBox2:TGroupBox;
        CheckBox2:TCheckBox;
        CheckBox1:TCheckBox;
        GroupBox1:TGroupBox;
        Button7:TButton;
        Button6:TButton;
        Button5:TButton;
        ListView1:TListView;
        Label2:TLabel;
        Label1:TLabel;
        TabSheet3:TTabSheet;
        TabSheet2:TTabSheet;
        PageControl1:TPageControl;
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Button1:TButton;
        TabSheet1:TTabSheet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AdvancedSettingsDlg: TAdvancedSettingsDlg;

implementation

{$R *.xfm}

end.
