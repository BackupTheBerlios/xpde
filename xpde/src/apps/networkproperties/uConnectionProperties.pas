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
unit uConnectionProperties;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, QExtCtrls, uQXPComCtrls;

type
  TConnectionPropertiesDlg = class(TForm)
        CheckBox7:TCheckBox;
        CheckBox6:TCheckBox;
        Label7:TLabel;
        Button10:TButton;
        ComboBox2:TComboBox;
        Label6:TLabel;
        CheckBox5:TCheckBox;
        Button9:TButton;
        CheckBox2:TCheckBox;
        GroupBox2:TGroupBox;
        CheckBox1:TCheckBox;
        Label3:TLabel;
        GroupBox1:TGroupBox;
        Button8:TButton;
        Button7:TButton;
        Button6:TButton;
        ListView1:TListView;
        Label2:TLabel;
        Button5:TButton;
        Panel1:TPanel;
        Edit2:TEdit;
        Edit1:TEdit;
        Label1:TLabel;
        TabSheet3:TTabSheet;
        TabSheet2:TTabSheet;
        PageControl1:TPageControl;
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Button1:TButton;
        TabSheet1:TTabSheet;
    Panel2: TPanel;
    Image1: TImage;
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConnectionPropertiesDlg: TConnectionPropertiesDlg;

implementation

uses uEthernetAdapterProperties;

{$R *.xfm}

procedure TConnectionPropertiesDlg.Button5Click(Sender: TObject);
begin
        EthernetAdapterPropertiesDlg:=TEthernetAdapterPropertiesDlg.Create(Application);
        EthernetAdapterPropertiesDlg.Show;
end;

end.
