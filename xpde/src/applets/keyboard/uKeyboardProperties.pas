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
unit uKeyboardProperties;
// {$DEFINE DEBUG_XKB}
interface

uses
  Libc,SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, QExtCtrls, uQXPComCtrls, uRegistry,Xlib,xlib_binds;

{             REPEAT
              Change  the keyboard repeat rate to rate cps.   For
              Intel-based systems, the allowable  range  is  from
              2.0 to 30.0 cps.  Only certain, specific values are
              possible, and the program will select  the  nearest
              possible  value to the one specified.  The possible
              values are given, in characters per second, as fol-
              lows:  2.0, 2.1, 2.3, 2.5, 2.7, 3.0, 3.3, 3.7, 4.0,
              4.3, 4.6, 5.0, 5.5, 6.0, 6.7, 7.5, 8.0,  8.6,  9.2,
              10.0,  10.9,  12.0,  13.3,  15.0, 16.0, 17.1, 18.5,
              20.0, 21.8, 24.0, 26.7, 30.0.

              So this is an idea:
              All those float values (32) will be an Array[0..31] of single
              and TTrackBar will be 0..31 so each tick is an point of that array
              of single.


              For SPARC-based systems,  the allowable range is
              from 0 (no repeat) to 50 cps.
}

{             DELAY
              Change the delay to delay milliseconds.  For Intel-
              based  systems,  the allowable range is from 250 to
              1000 ms, in 250 ms steps. For SPARC systems, possi-
              ble  values are between 10 ms and 1440 ms, in 10 ms
              steps.
}

Const rpts :Array [ 0..31 ] of single=(2.0, 2.1, 2.3, 2.5, 2.7, 3.0, 3.3, 3.7, 4.0,
                                      4.3, 4.6, 5.0, 5.5, 6.0, 6.7, 7.5, 8.0,  8.6,  9.2,
                                      10.0,  10.9,  12.0,  13.3,  15.0, 16.0, 17.1, 18.5,
                                      20.0, 21.8, 24.0, 26.7, 30.0);
      Xkbd_Key = 'Keyboard';
      Xkbd_Repeat = 'Repeat';   // 2.0-30.0 cps for x86 saved as integer which is the position in array rpts[]!
      Xkbd_Delay = 'Delay';    // 250-1000 ms (250ms steps for x86 !!)
      Xkbd_CursorBlink = 'CursorBlink';
type
  TKeyboardPropertiesDlg = class(TForm)
        TabSheet3:TTabSheet;
    TB3: TTrackBar;
        Label11:TLabel;
        Label10:TLabel;
        Label9:TLabel;
        Label8:TLabel;
        GroupBox2:TGroupBox;
    ED1: TEdit;
        Label7:TLabel;
    TB2: TTrackBar;
        Label6:TLabel;
        Label5:TLabel;
        Label4:TLabel;
        Image2:TImage;
        Panel2:TPanel;
    TB1: TTrackBar;
        Label3:TLabel;
        Label2:TLabel;
        Label1:TLabel;
        Image1:TImage;
        Panel1:TPanel;
        GroupBox1:TGroupBox;
        TabSheet2:TTabSheet;
        PageControl1:TPageControl;
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Button1:TButton;
        TabSheet1:TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure TB1Change(Sender: TObject);
  private
        Procedure Read_Registry;
        Procedure Write_Registry;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  KeyboardPropertiesDlg: TKeyboardPropertiesDlg;
  rpt:integer=20; // default rpt is 10.9 = rpts[20] This have no meaning under X
                 // since we will use xlib_binds :)
  repeat_rate:integer=650; // 660 is default (650) , we will use values 50-1000 in steps of 50
  dly:integer=40; // 10-110 in steps of 10
  curs:integer=1;

implementation
Const key_ = 'Control Panel/';

var   disply:PDisplay;
      reg:TRegistry;

{$R *.xfm}

Function SetRateAndDelay(rptdelay:integer; rptinterval:integer):boolean;
var i,y:integer;
    stt:PStatus;
    decp:XkbDescPtr;
    ind:XkbIndicatorPtr;
    rezult:bool;
Begin
        i:=1;
        rezult:=0;

        decp:=XkbAllocKeyboard;

        stt:=XkbAllocControls(decp,i);

        {$IFDEF DEBUG_XKB}
        writeln('STATUS ALLOC_CONTROLS ',longint(stt));
        {$ENDIF}

        {$IFDEF DEBUG_XKB}
        stt:=XkbAllocIndicatorMaps(decp);

        writeln('STATUS ALLOC_INDICATORS ',longint(stt));
        {$ENDIF}


        if decp<>NiL then begin

        stt:=XkbGetControls(disply,i,decp);

        {$IFDEF DEBUG_XKB}
        writeln(decp.flags);
        writeln(decp.device_spec);
        writeln(decp.min_key_code);
        writeln(decp.max_key_code);
        {$ENDIF}


        {$IFDEF DEBUG_XKB}
        if decp.ctrls<>Nil then begin
        writeln('CTRLS ',decp.ctrls.mk_dflt_btn);
        writeln(decp.ctrls.num_groups);
        writeln(decp.ctrls.groups_wrap);
        writeln(decp.ctrls.internal.mask);
        writeln('DELAY ',decp.ctrls.repeat_delay,' INTERVAL ',decp.ctrls.repeat_interval);
        End;
        {$ENDIF}

        End;

      decp.ctrls.repeat_delay:=rptdelay;   // 660
      decp.ctrls.repeat_interval:=rptinterval; // 40

      // Now we set keyboard according our needs

      y:=XkbSetControls(disply,i,decp);

        {$IFDEF DEBUG_XKB}
        writeln('XKBSETCONTROLS ',y);
        {$ENDIF}
        if decp<>Nil then begin
        XkbFreeKeyboard(decp,i,rezult);

        {$IFDEF DEBUG_XKB}
        writeln('FREEING XKB ',rezult);
        {$ENDIF}

        XkbFreeControls(decp,i,rezult);

        {$IFDEF DEBUG_XKB}
        writeln('FREEING XKBCONTROLS ',rezult);
        {$ENDIF}

       {$IFDEF DEBUG_XKB}
        XkbFreeIndicatorMaps(decp);
        {$ENDIF}
        End;

        Result:=true;

End;

Function GetRateAndDelay(var rptdelay:integer; var rptinterval:integer):boolean;
// We need this func just when registry keys doesn't exist
var i,y:integer;
    stt:PStatus;
    decp:XkbDescPtr;
    xcp:XkbControlsPtr;
    rezult:bool;
Begin
        i:=1;
        rezult:=0;

        decp:=XkbAllocKeyboard;

        stt:=XkbAllocControls(decp,i);

        {$IFDEF DEBUG_XKB}
        writeln('STATUS ALLOC_CONTROLS ',longint(stt));
        {$ENDIF}

        if decp<>NiL then begin

        stt:=XkbGetControls(disply,i,decp);

        {$IFDEF DEBUG_XKB}
        writeln(decp.flags);
        writeln(decp.device_spec);
        writeln(decp.min_key_code);
        writeln(decp.max_key_code);
        {$ENDIF}


        {$IFDEF DEBUG_XKB}
        if decp.ctrls<>Nil then begin
        writeln('DELAY ',decp.ctrls.repeat_delay,' INTERVAL ',decp.ctrls.repeat_interval);
        End;
        {$ENDIF}
        try
        rptdelay:=longint(decp.ctrls.repeat_delay);
        rptinterval:=longint(decp.ctrls.repeat_interval);
        except
                raise Exception.Create('Cannot read keyboard values !');
        End;
        End;

        {$IFDEF DEBUG_XKB}
        writeln('XKBSETCONTROLS ',y);
        {$ENDIF}
        if decp<>Nil then begin
        XkbFreeKeyboard(decp,i,rezult);

        {$IFDEF DEBUG_XKB}
        writeln('FREEING XKB ',rezult);
        {$ENDIF}

        XkbFreeControls(decp,i,rezult);

        {$IFDEF DEBUG_XKB}
        writeln('FREEING XKBCONTROLS ',rezult);
        {$ENDIF}
        End;

        Result:=true;
End;




Procedure TKeyboardPropertiesDlg.Read_Registry;
Begin
        reg:=TRegistry.Create;
        reg.RootKey:=HKEY_CURRENT_USER;
        if reg.OpenKey(key_+Xkbd_Key,false) then begin
                repeat_rate:=reg.ReadInteger(Xkbd_Repeat);
                dly:=reg.Readinteger(Xkbd_Delay);
                curs:=reg.Readinteger(Xkbd_CursorBlink);
        End else begin
        GetRateAndDelay(repeat_rate,dly);
        reg.OpenKey(key_+Xkbd_Key,true);
        reg.WriteInteger(Xkbd_Repeat,repeat_rate);
        reg.Writeinteger(Xkbd_Delay,dly);
        reg.Writeinteger(Xkbd_CursorBlink,curs);
        End;
        reg.Free;
End;

Procedure TKeyboardPropertiesDlg.Write_Registry;
Begin
        repeat_rate:=TB1.Position;
        dly:=TB2.Position;
        curs:=TB3.Position;
        reg:=TRegistry.Create;
        reg.RootKey:=HKEY_CURRENT_USER;
        reg.OpenKey(key_+Xkbd_Key,false);
        reg.Writeinteger(Xkbd_Repeat,repeat_rate);
        reg.Writeinteger(Xkbd_Delay,dly);
        reg.Writeinteger(Xkbd_CursorBlink,curs);
        reg.Free;
End;


procedure TKeyboardPropertiesDlg.FormCreate(Sender: TObject);
begin
        disply:=Application.Display;
        Read_Registry;
        TB1.Position:=repeat_rate;
        TB2.Position:=dly;
        TB3.Position:=curs;
        
end;

procedure TKeyboardPropertiesDlg.Button3Click(Sender: TObject);
begin
        if not SetRateAndDelay(repeat_rate,dly) then
        raise Exception.Create('Cannot set keyboard rate !');
        Write_Registry;
end;

procedure TKeyboardPropertiesDlg.Button2Click(Sender: TObject);
begin
        Close;
end;

procedure TKeyboardPropertiesDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        Action:=caFree;
end;

procedure TKeyboardPropertiesDlg.Button1Click(Sender: TObject);
begin
        if not SetRateAndDelay(repeat_rate,dly) then
        raise Exception.Create('Cannot set keyboard rate !');
        Write_Registry;
        Close;
end;

procedure TKeyboardPropertiesDlg.TB1Change(Sender: TObject);
var ttb:TTrackBar;
begin

        ttb:=Sender as TTrackBar;

        if ttb.Name='TB1' then
        repeat_rate:=TB1.Position
        else
        if ttb.Name='TB2' then
        dly:=TB2.Position;

        {$IFDEF DEBUG_XKB}
        writeln('POSITION ',ttb.position);
        {$ENDIF}
end;


end.
