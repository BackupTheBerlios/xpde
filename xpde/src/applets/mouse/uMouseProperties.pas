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

unit uMouseProperties;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QComCtrls, Qt, uQXPComCtrls,uRegistry, Xlib;

Const Mouse_Settings_Key = 'Mouse';
      Mouse_Acceleration = 'Acceleration';
      Mouse_EnhancePrecision = 'Enhance_Precision';
      Mouse_Threshold = 'Threshold';
      Mouse_DblClickTime = 'Double_Click_Time';
      Mouse_LeftHanded = 'Left_Handed';
      Mouse_ClickLock = 'Click_Lock';
      Mouse_DefButton = 'Default_Button';
      Mouse_DisplayTrails='Display_Trails';
      Mouse_NumOfTrails='Num_Trails';
      Mouse_HidePointer='Hide_Pointer';
      Mouse_ShowLocation='Show_Location';
      Mouse_NotchToScroll='Notch_To_Scroll';
      Mouse_WheelNumLines='Wheel_Num_Lines';
type
  TMousePropertiesDlg = class(TForm)
        TabSheet6:TTabSheet;
    ED1: TEdit;
    RB2: TRadioButton;
    RB1: TRadioButton;
        Label13:TLabel;
        Image8:TImage;
        Panel8:TPanel;
        GroupBox8:TGroupBox;
    CB8: TCheckBox;
    CB7: TCheckBox;
        Image7:TImage;
        Panel7:TPanel;
        Image6:TImage;
        Panel6:TPanel;
    TB3: TTrackBar;
        Label12:TLabel;
        Label11:TLabel;
        Image5:TImage;
        Panel5:TPanel;
    CB6: TCheckBox;
        GroupBox7:TGroupBox;
        Image4:TImage;
        Panel4:TPanel;
    CB5: TCheckBox;
        GroupBox6:TGroupBox;
    CB4: TCheckBox;
    TB2: TTrackBar;
        Label10:TLabel;
        Label9:TLabel;
        Label8:TLabel;
        Image3:TImage;
        Panel3:TPanel;
        GroupBox5:TGroupBox;
        Button9:TButton;
        Button8:TButton;
    CB3: TCheckBox;
        ListBox1:TListBox;
        Label7:TLabel;
        Image2:TImage;
        Panel2:TPanel;
        Button7:TButton;
        Button6:TButton;
        ComboBox1:TComboBox;
        GroupBox4:TGroupBox;
        Button5:TButton;
        Label6:TLabel;
    CB2: TCheckBox;
        GroupBox3:TGroupBox;
    imOpen: TImage;
        Panel1:TPanel;
        Label5:TLabel;
    TB1: TTrackBar;
        Label4:TLabel;
        Label3:TLabel;
        Label2:TLabel;
        GroupBox2:TGroupBox;
        Label1:TLabel;
    CB1: TCheckBox;
        GroupBox1:TGroupBox;
        TabSheet5:TTabSheet;
        TabSheet4:TTabSheet;
        TabSheet3:TTabSheet;
        TabSheet2:TTabSheet;
        PageControl1:TPageControl;
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Button1:TButton;
        TabSheet1:TTabSheet;
    imLeft: TImage;
    imRight: TImage;
    imClosed: TImage;
    procedure CB1Click(Sender: TObject);
    procedure imClosedDblClick(Sender: TObject);
    procedure imOpenDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ED1Exit(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TB1Change(Sender: TObject);
    procedure TB2Change(Sender: TObject);
    procedure CB4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    Procedure Read_Registry_Key;
    Procedure Fill_Components;
    Procedure Save_Properties;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MousePropertiesDlg: TMousePropertiesDlg;
  accel_:integer=2;
  pointer_precision:boolean=false;
  threshold_:integer=2;
  dblclick_:integer=400;
  dragstarttime:integer=500;
  dragdist:integer=4;
  wheelscroll_lines:integer=3;
  left_handed:boolean=false;
  click_lock:boolean=false;
  def_button:boolean=false;
  display_trails:boolean=false;
  num_trails:integer=0;
  hide_pointer:boolean=false;
  show_location:boolean=false;
  notch_to_scroll:integer=0;
  num_lines:integer=3;
  middle_button:integer;
  num_buttons:integer;
  map:Array [0..5] of byte;


implementation
Const  key='Control Panel/';
var disply:PDisplay;
{$R *.xfm}


procedure TMousePropertiesDlg.CB1Click(Sender: TObject);
var remap,lefthand:boolean;
    retval:integer;
begin
        remap:=true;
    if CB1.Checked then imRight.bringtofront
    else imLeft.BringToFront;

    lefthand:=CB1.Checked;
    num_buttons := XGetPointerMapping(disply, @map, 5);

    case num_buttons of
        3,5:middle_button:=map[1];
    End;

    case num_buttons of
        1:map[0]:=1;
        2:Begin
          if not lefthand then begin
              map[0] := 1;
              map[1] := 3;
          End else begin
              map[0] := 3;
              map[1] := 1;
          End;
          End;
        3:Begin
          if not lefthand then begin
              map[0] := 1;
              map[1] := middle_button;
              map[2] := 3;
          end else begin
              map[0] := 3;
              map[1] := middle_button;
              map[2] := 1;
          End;
          End;
        5:Begin
          // Intellimouse case, where buttons 1-3 are left, middle, and
          // right, and 4-5 are up/down
          if not lefthand then begin
              map[0] := 1;
              map[1] := 2;
              map[2] := 3;
              map[3] := 4;
              map[4] := 5;
          end else begin
              map[0] := 3;
              map[1] := 2;
              map[2] := 1;
              map[3] := 4;
              map[4] := 5;
          End;
          End;
          else begin
          remap:=false; // Don't do anything since we don't know what to do... ;)
          End;
          End;
    

    if remap then begin
        repeat
         retval:=XSetPointerMapping(disply, @map,num_buttons);
         Application.ProcessMessages;
        until retval<>MappingBusy;
    End;
     
end;

procedure TMousePropertiesDlg.imClosedDblClick(Sender: TObject);
begin
    imClosed.visible:=false;
    imOpen.visible:=true;
end;

procedure TMousePropertiesDlg.imOpenDblClick(Sender: TObject);
begin
    imOpen.visible:=false;
    imClosed.visible:=true;
end;

Procedure TMousePropertiesDlg.Read_Registry_Key;
var reg:TRegistry;
Begin
        reg:=TRegistry.Create;
        reg.RootKey:=HKEY_CURRENT_USER;

        if reg.OpenKey(key+Mouse_Settings_Key,false) then begin
                threshold_:=reg.Readinteger(Mouse_Threshold);
                accel_:=reg.Readinteger(Mouse_Acceleration);
                pointer_precision:=reg.Readbool(Mouse_EnhancePrecision);
                dblclick_:=reg.Readinteger(Mouse_DblClickTime);
                left_handed:=reg.Readbool(Mouse_LeftHanded);
                click_lock:=reg.Readbool(Mouse_ClickLock);
                def_button:=reg.Readbool(Mouse_DefButton);
                display_trails:=reg.Readbool(Mouse_DisplayTrails);
                num_trails:=reg.Readinteger(Mouse_NumOfTrails);
                hide_pointer:=reg.Readbool(Mouse_HidePointer);
                show_location:=reg.Readbool(Mouse_ShowLocation);
                notch_to_scroll:=reg.Readinteger(Mouse_NotchToScroll);
                num_lines:=reg.Readinteger(Mouse_WheelNumLines);
        End else begin
        reg.OpenKey(key+Mouse_Settings_Key,true);
        reg.Writeinteger(Mouse_Threshold,2);
        reg.Writeinteger(Mouse_Acceleration,2);
        reg.Writebool(Mouse_EnhancePrecision,false);
        reg.Writeinteger(Mouse_DblClickTime,400);
        reg.Writebool(Mouse_LeftHanded,false);
        reg.Writebool(Mouse_ClickLock,false);
        reg.Writebool(Mouse_DefButton,false);
        reg.Writebool(Mouse_DisplayTrails,false);
        reg.Writeinteger(Mouse_NumOfTrails,0);
        reg.Writebool(Mouse_HidePointer,false);
        reg.Writebool(Mouse_ShowLocation,false);
        reg.Writeinteger(Mouse_NotchToScroll,0);
        reg.Writeinteger(Mouse_WheelNumLines,3);
        End;
        reg.Free;
End;

Function WriteCount_Msecs_DblClick(value:integer):integer;
Begin
        case value of
                0:result:=900;
                1:result:=800;
                2:result:=700;
                3:result:=600;
                4:result:=500;
                5:result:=400;
                6:result:=300;
                7:result:=200;
                8:result:=100;
                else
                Result:=400;
        End;
End;

Function ReadCount_Msecs_DblClick(value:integer):integer;
Begin
        case value of
                100:result:=8;
                200:result:=7;
                300:result:=6;
                400:result:=5;
                500:result:=4;
                600:result:=3;
                700:result:=2;
                800:result:=1;
                900:result:=0;
                else
                Result:=4;
        End;
End;


Procedure TMousePropertiesDlg.Fill_Components;
Begin
        CB1.Checked:=left_handed;
        TB1.Position:=ReadCount_Msecs_DblClick(dblclick_);
        CB2.Checked:=click_Lock;
        TB2.Position:=accel_;
        CB4.Checked:=pointer_precision;
        CB5.Checked:=def_button;
        CB6.Checked:=display_trails;
        TB3.Position:=num_trails;
        CB7.Checked:=hide_pointer;
        CB8.Checked:=show_location;
        RB1.Checked:=notch_to_scroll=0;
        ED1.Text:=IntToStr(num_lines);
        RB2.Checked:=notch_to_scroll=1;

End;

procedure TMousePropertiesDlg.FormCreate(Sender: TObject);
begin
        disply:=Application.Display;
        Read_Registry_Key;
        Fill_Components;
end;

Procedure TMousePropertiesDlg.Save_Properties;
var reg:TRegistry;
Begin
        left_handed:=CB1.Checked;
        dblclick_:=WriteCount_Msecs_DblClick(TB1.Position);
        accel_:=TB2.Position;
        pointer_precision:=CB4.Checked;
        click_lock:=CB2.Checked;
        def_button:=CB5.Checked;
        display_trails:=CB6.Checked;
        num_trails:=TB3.Position;
        hide_pointer:=CB7.Checked;
        show_location:=CB8.Checked;
        if RB1.Checked then notch_to_scroll:=0
        else
        if RB2.Checked then notch_to_scroll:=1;
        num_lines:=StrToInt(ED1.Text);

        if notch_to_scroll=0 then
                QApplication_setWheelScrollLines(num_lines)
        else
        if notch_to_scroll=1 then
        QApplication_setWheelScrollLines(20); // UGLY ;)

        reg:=TRegistry.Create;
        reg.RootKey:=HKEY_CURRENT_CONFIG;

        if reg.OpenKey(key+Mouse_Settings_Key,false) then begin
                reg.Writeinteger(Mouse_Acceleration,accel_);
                reg.Writebool(Mouse_EnhancePrecision,pointer_precision);
                if pointer_precision then threshold_:=4 else threshold_:=2;
                reg.Writeinteger(Mouse_Threshold,threshold_);
                reg.Writeinteger(Mouse_DblClickTime,dblclick_);
                reg.Writebool(Mouse_LeftHanded,left_handed);
                reg.Writebool(Mouse_ClickLock,click_lock);
                reg.Writebool(Mouse_DefButton,def_button);
                reg.Writebool(Mouse_DisplayTrails,display_trails);
                reg.Writeinteger(Mouse_NumOfTrails,num_trails);
                reg.Writebool(Mouse_HidePointer,hide_pointer);
                reg.Writebool(Mouse_ShowLocation,show_location);
                reg.Writeinteger(Mouse_NotchToScroll,notch_to_scroll);
                reg.Writeinteger(Mouse_WheelNumLines,num_lines);
        End;
        reg.Free;
End;

procedure TMousePropertiesDlg.Button3Click(Sender: TObject);
begin
        Save_Properties;
end;

procedure TMousePropertiesDlg.ED1Exit(Sender: TObject);
var ss:string;
    i:integer;
begin
        i:=0;
        ss:=ED1.Text;
        if not TryStrToInt(ss,i) then
        raise Exception.Create('Field must contain number !');
end;

procedure TMousePropertiesDlg.Button2Click(Sender: TObject);
begin
        Close;
end;

procedure TMousePropertiesDlg.Button1Click(Sender: TObject);
begin
        Save_Properties;
        Close;
end;

procedure TMousePropertiesDlg.TB1Change(Sender: TObject);
begin
        dblclick_:=WriteCount_Msecs_DblClick(TB1.Position);
        QApplication_setDoubleClickInterval(dblclick_);
end;

procedure TMousePropertiesDlg.TB2Change(Sender: TObject);
var acc_,acc_n,thr:integer;
begin
          XGetPointerControl(disply,@accel_,@acc_n,@threshold_);
          accel_:=TB2.Position;
          XChangePointerControl(disply,1, 1, accel_, 1, threshold_);
end;

procedure TMousePropertiesDlg.CB4Click(Sender: TObject);
var acc_n:integer;
begin
          XGetPointerControl(disply,@accel_,@acc_n,@threshold_);
          if CB4.Checked then threshold_:=2 else threshold_:=4;
          XChangePointerControl(disply,1, 1, accel_, 1, threshold_);
end;

procedure TMousePropertiesDlg.Button5Click(Sender: TObject);
begin
        ShowMessage('Please, write some code for me ;)'+#13#10);
end;

end.
