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
unit uAdvancedTCPIPSettings;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, uQXPComCtrls;

type
  TAdvancedTCPIPSettingsDlg = class(TForm)
        Label8:TLabel;
        GroupBox6:TGroupBox;
        Button27:TButton;
        ListView3:TListView;
        Label7:TLabel;
        RadioButton5:TRadioButton;
        RadioButton4:TRadioButton;
        RadioButton3:TRadioButton;
        Label6:TLabel;
        GroupBox5:TGroupBox;
        Button26:TButton;
        CheckBox5:TCheckBox;
        Label5:TLabel;
        Button25:TButton;
        Button24:TButton;
        Button23:TButton;
        Button22:TButton;
        Button21:TButton;
        ListBox3:TListBox;
        GroupBox4:TGroupBox;
        CheckBox4:TCheckBox;
        CheckBox3:TCheckBox;
        Edit2:TEdit;
        Label4:TLabel;
        Button20:TButton;
        Button19:TButton;
        Button18:TButton;
        Button17:TButton;
        Button16:TButton;
        ListBox2:TListBox;
        RadioButton2:TRadioButton;
        CheckBox2:TCheckBox;
        RadioButton1:TRadioButton;
        Label3:TLabel;
        Button15:TButton;
        Button14:TButton;
        Button13:TButton;
        Button12:TButton;
        Button11:TButton;
        ListBox1:TListBox;
        Label2:TLabel;
        Edit1:TEdit;
        Label1:TLabel;
        CheckBox1:TCheckBox;
        GroupBox3:TGroupBox;
        Button10:TButton;
        Button9:TButton;
        Button8:TButton;
        ListView2:TListView;
        GroupBox2:TGroupBox;
        Button7:TButton;
        Button6:TButton;
        Button5:TButton;
        ListView1:TListView;
        GroupBox1:TGroupBox;
        TabSheet4:TTabSheet;
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
  AdvancedTCPIPSettingsDlg: TAdvancedTCPIPSettingsDlg;

implementation

{$R *.xfm}

end.
