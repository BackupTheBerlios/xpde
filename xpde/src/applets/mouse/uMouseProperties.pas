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
  QStdCtrls, QExtCtrls, QComCtrls, Qt, uQXPComCtrls,uRegistry, uMouseAPI, Xlib;


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
    procedure RB1Click(Sender: TObject);
  private
    Procedure Fill_Components;
    Procedure Save_Properties;
    procedure updateMouseAccel;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MousePropertiesDlg: TMousePropertiesDlg;

implementation

{$R *.xfm}

procedure TMousePropertiesDlg.CB1Click(Sender: TObject);
begin
    if CB1.Checked then imRight.bringtofront
    else imLeft.BringToFront;

    setButtonMapping(cb1.checked);
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

procedure TMousePropertiesDlg.FormCreate(Sender: TObject);
begin
        readMousePropertiesFromRegistry;
        applyMouseProperties;
        Fill_Components;
end;

Procedure TMousePropertiesDlg.Fill_Components;
Begin
        CB1.Checked:=left_handed;
        TB1.Position:=dblclick_;
        CB2.Checked:=click_Lock;
        TB2.Position:=accel_;
        CB4.Checked:=pointer_precision;
        CB5.Checked:=def_button;
        CB6.Checked:=display_trails;
        TB3.Position:=num_trails;
        CB7.Checked:=hide_pointer;
        CB8.Checked:=show_location;
        ED1.Text:=IntToStr(num_lines);
        RB1.Checked:=notch_to_scroll=0;
        RB2.Checked:=notch_to_scroll=1;
End;



Procedure TMousePropertiesDlg.Save_Properties;
Begin
        left_handed:=CB1.Checked;
        dblclick_:=TB1.Position;
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

        saveMousePropertiesToRegistry;
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
        setDoubleClickInterval(tb1.position);
end;

procedure TMousePropertiesDlg.TB2Change(Sender: TObject);
begin
    updateMouseAccel;
end;

procedure TMousePropertiesDlg.CB4Click(Sender: TObject);
begin
    updateMouseAccel;
end;

procedure TMousePropertiesDlg.Button5Click(Sender: TObject);
begin
        ShowMessage('Please, write some code for me ;)'+#13#10);
end;

procedure TMousePropertiesDlg.updateMouseAccel;
var
    th: integer;
begin
    if CB4.Checked then th:=2
    else th:=4;
    setMouseAccel(tb2.position,th);
end;

procedure TMousePropertiesDlg.RB1Click(Sender: TObject);
begin
    setWheelScrollLines(rb1.checked, strtoint(ed1.text));
end;

end.
