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
unit uEthernetAdapterProperties;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, QExtCtrls, uQXPComCtrls,SysProvider;

type
  TEthernetAdapterPropertiesDlg = class(TForm)
        Label27:TLabel;
        Button12:TButton;
        CheckBox1:TCheckBox;
        ComboBox3:TComboBox;
        ListView1:TListView;
        Label20:TLabel;
        Label19:TLabel;
        Image3:TImage;
        Panel3:TPanel;
        Label18:TLabel;
        Button11:TButton;
        Label17:TLabel;
        Button10:TButton;
        Label16:TLabel;
        Button9:TButton;
        Label15:TLabel;
        Button8:TButton;
        Edit9:TEdit;
        Label14:TLabel;
        Edit8:TEdit;
        Label13:TLabel;
        Edit7:TEdit;
        Label12:TLabel;
        Edit6:TEdit;
        Label11:TLabel;
        Label10:TLabel;
        Image2:TImage;
        Panel2:TPanel;
        Label9:TLabel;
        ComboBox2:TComboBox;
        Edit5:TEdit;
        Label8:TLabel;
        ListBox1:TListBox;
        Label7:TLabel;
        Label6:TLabel;
        ComboBox1:TComboBox;
        Label5:TLabel;
        Button5:TButton;
        GroupBox1:TGroupBox;
        Edit3:TEdit;
        Label4:TLabel;
        Edit2:TEdit;
        Label3:TLabel;
        Edit1:TEdit;
        Label2:TLabel;
    labDevice: TLabel;
        Image1:TImage;
        Panel1:TPanel;
        TabSheet4:TTabSheet;
        TabSheet3:TTabSheet;
        TabSheet2:TTabSheet;
        PageControl1:TPageControl;
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Button1:TButton;
        TabSheet1:TTabSheet;
    Memo1: TMemo;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label25: TLabel;
    Memo2: TMemo;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    Procedure GetDeviceInfo(device:string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EthernetAdapterPropertiesDlg: TEthernetAdapterPropertiesDlg;

implementation

uses uConnectionProperties,hwinfo;

{$R *.xfm}

procedure TEthernetAdapterPropertiesDlg.Button2Click(Sender: TObject);
begin
        Close;
end;

procedure TEthernetAdapterPropertiesDlg.Button1Click(Sender: TObject);
begin
        // save setting
        Close;
end;

procedure TEthernetAdapterPropertiesDlg.FormActivate(Sender: TObject);
begin
      ConnectionPropertiesDlg.Hide;
end;

procedure TEthernetAdapterPropertiesDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        Action:=caFree;
        Application.Terminate;
end;

Procedure TEthernetAdapterPropertiesDlg.GetDeviceInfo(device:string);
Begin
{
        if not
        IsValidNetDevice(device) then
        ShowMessage('Unknown device '+device)
        else begin
        if not
        Is_CableUnplugged(device) then
        ShowMessage('Cable is unplugged.');
        // else
        // put in tray
        End;
}
End;

procedure TEthernetAdapterPropertiesDlg.FormShow(Sender: TObject);
var pro:TSysProvider;
begin
//        ReadHW('/proc/pci');
//        GetDeviceInfo('eth0');
        writeln('Creating provider !');
        try
        pro:=TSysProvider.Create;
        pro.WriteHwInfo;
        pro.Free;
        except
        writeln('Cannot create provider!');
        End;
        // device is parameter -> progname -i ethXX !
end;

end.
