{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003 Valery Gabrusev <valera@xpde.com>                           }
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

unit uSmbOption;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, uXPPNG, QExtCtrls, uRegistry;

type
  TsmbOption = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    btnOk: TButton;
    btnCancel: TButton;
    smbName: TEdit;
    smbPass: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    smbGroup: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    WinsInp: TEdit;
    btnAdd: TButton;
    btnRemove: TButton;
    WinsStr: TMemo;
    cbxWins: TCheckBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
   smbUser, smbPassword, WorkGroup : string;
   procedure smbWriteData(var wgroup: string; var user: string; var pass: string);
   procedure smbLoadData(var wgroup: string; var user: string; var pass: string);
  public
    { Public declarations }
  end;

var
  smbOption: TsmbOption;

implementation

{$R *.xfm}

procedure TsmbOption.smbWriteData(var wgroup: string; var user: string; var pass: string);
var
    reg: TRegistry;
begin
    reg:=TRegistry.create;
    try
     if reg.OpenKey('SmbNetwork',true) then begin
            reg.WriteString('Smbworkgroup', wgroup);
            reg.WriteString('Smbuser', user);
            reg.WriteString('Smbpassword', pass);
        end;
    finally
        reg.Free;
    end;
end;

procedure TsmbOption.smbLoadData(var wgroup: string; var user: string; var pass: string);
var
    reg:TRegistry;
begin
    reg:=TRegistry.create;
    try
        if reg.OpenKey('SmbNetwork',false) then begin
            wgroup :=reg.ReadString('Smbworkgroup');
            user := reg.ReadString('Smbuser');
            pass := reg.ReadString('Smbpassword');
        end
    finally
        reg.Free;
    end;
end;


procedure TsmbOption.btnOkClick(Sender: TObject);
var
 wgroup, user, pass: string;
begin
 wgroup := smbGroup.text;
 user := smbName.text;
 pass := smbPass.text;
 smbWriteData(wgroup, user, pass);
 Close;
end;

procedure TsmbOption.btnCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TsmbOption.btnAddClick(Sender: TObject);
begin
  WinsStr.Lines.Add(WinsInp.Text);
end;

procedure TsmbOption.FormShow(Sender: TObject);
var
 wgroup, user, pass: string;
begin

 smbLoadData(wgroup, user, pass);
 smbGroup.text := wgroup;
 smbName.text := user;
 smbPass.text := pass;
 cbxWins.Enabled := False;
 WinsInp.Enabled := False;
 WinsStr.Enabled := False;
end;

end.
