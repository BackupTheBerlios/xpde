{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 Jens Kühner (jens@xpde.com)                              }
{                                                                             }
{ This software is provided "as-is".  This software comes without warranty    }
{ or garantee, explicit or implied.  Use this software at your own risk.      }
{ The author will not be liable for any damage to equipment, data, or         }
{ information that may result while using this software.                      }
{                                                                             }
{ By using this software, you agree to the conditions stated above.           }
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

unit uInetDialForm;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QActnList, QExtCtrls;

type
  TINetDialFm = class(TForm)
    btnDial: TButton;
    btnDisconnect: TButton;
    ActionList1: TActionList;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    efPhone: TEdit;
    efUserName: TEdit;
    efPassword: TEdit;
    TimerUpdateControls: TTimer;
    procedure btnDisConnectClick(Sender: TObject);
    procedure btnDialClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure efPhoneKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure TimerUpdateControlsTimer(Sender: TObject);
  private
    { Private-Deklarationen }
    m_pidChild : integer;
    function IsConnected : boolean;
    procedure ConfigModem;
  public
    { Public-Deklarationen }
  end;

var
  INetDialFm: TINetDialFm;

implementation

{$R *.xfm}

uses
  LibC, IniFiles, uRegistry;

const
  strCONFFILENAME = '/etc/wvdial.conf';
  strREGKEY       = 'Software/XPde/InternetConnection';

procedure TINetDialFm.FormShow(Sender: TObject);
begin
   clientwidth     := 250;
{   efPhone.text    := '019161';
   efUserName.text := 'cbc@global-village.de';
   efPassword.text := 'internet';}
   with TRegistry.create do begin
       if openkey(strREGKEY, false) then begin
          if valueexists('Phone') then
             efPhone.Text := readstring('Phone');
          if valueexists('UserName') then
             efUserName.Text := readstring('UserName');
          if valueexists('Password') then
             efPassword.Text := readstring('Password');
       end;
       free;
   end;
end;

procedure TInetDialFm.ConfigModem;
var
  ipid, istatloc : integer;
begin
  //if there is not configfile execute wvdialconf
  if not fileexists(strCONFFILENAME) then begin
    ipid := vfork;
    case ipid of
      0: begin //child
        execlp('wvdialconf', 'wvdialconf', strCONFFILENAME, nil);
        raise Exception.Create('Cannot execute wvdialconf!');
      end;
      -1:
        raise Exception.Create('Cannot execute wvdialconf!');
      else
        waitpid(ipid, @istatloc, 0);
    end;
  end;
end;

procedure TINetDialFm.btnDisConnectClick(Sender: TObject);
begin
   if btnDisconnect.enabled then
     kill(m_pidChild, SIGTERM);
end;

procedure TINetDialFm.btnDialClick(Sender: TObject);
begin
   //save settings to registry
   with TRegistry.create do begin
       if openkey(strREGKEY, true) then begin
          writestring('Phone', efPhone.Text);
          writestring('UserName', efUserName.Text);
          writestring('Password', efPassword.Text);
       end;
       free;
   end;

  //write to conf-file for wvdial
  with TIniFile.create(strCONFFILENAME) do begin
    try
     writestring('Dialer Defaults', 'Phone', efPhone.Text);
     writestring('Dialer Defaults', 'Username', efUserName.Text);
     writestring('Dialer Defaults', 'Password', efPassword.Text);
    finally
     free;
    end;
  end;

  ConfigModem;

  //execute wvdial
  m_pidChild := vfork;
  case m_pidChild of
    0: begin //child
      execlp('wvdial', nil);
      raise Exception.Create('Cannot execute wvdial!');
    end;
    -1:
      raise Exception.Create('Cannot execute wvdial!');
  end;
end;

procedure TINetDialFm.btnCancelClick(Sender: TObject);
begin
  btnDisconnectClick(nil);
  close;
end;

procedure TINetDialFm.efPhoneKeyPress(Sender: TObject; var Key: Char);
begin
   if not (key in ['0'..'9']) then
     key := #0;
end;

function TINetDialFm.IsConnected : boolean;
var
  istatloc : integer;
begin
  result := (m_pidChild <> 0) and (waitpid(m_pidChild, @istatloc, WNOHANG) = 0);
{  result := false;
  if m_pidChild <> 0 then begin
     result := waitpid(m_pidChild, @istatloc, WNOHANG) = 0;
  end;}
end;

procedure TINetDialFm.TimerUpdateControlsTimer(Sender: TObject);
begin
  btnDial.enabled       := not IsConnected;
  btnDisConnect.enabled := IsConnected;
end;

end.
