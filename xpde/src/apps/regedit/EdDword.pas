{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003 Theo Lustenberger                                        }
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

unit EdDword;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls, RegLib, QMask;

type
  TEdDWord1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    Button2: TButton;
    procedure RadioGroup1Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }

  procedure SetName(Value:String);
  procedure SetValue(Value:String);
  function GetValue:String;
  public
  property Name:String write SetName;
  property Value:String read GetValue write SetValue;
  end;

var
  EdDWord1: TEdDWord1;

implementation

{$R *.xfm}

 procedure TEdDWord1.SetName(Value:String);
 begin
 Edit1.Text:=Value;
 end;

 procedure TEdDWord1.SetValue(Value:String);
 begin
 Edit2.Text:=Value;
 end;

 function TEdDWord1.GetValue:String;
 begin
 if(Edit2.text='') then Result:='0' else
 begin
 Result:=Edit2.Text;
 if RadioGroup1.ItemIndex=0 then Result:=inttostr(HexStringToInt(Edit2.text));
 end;
 end;

procedure TEdDWord1.RadioGroup1Click(Sender: TObject);
begin
 if RadioGroup1.ItemIndex=0 then Edit2.text:=IntToHex(strToInt64(Edit2.text),0);
 if RadioGroup1.ItemIndex=1 then Edit2.text:=inttostr(HexStringToInt(Edit2.text));
end;


procedure TEdDWord1.Edit2Change(Sender: TObject);
begin
//
end;

procedure TEdDWord1.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//
end;

procedure TEdDWord1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
if Length(Edit2.Text)<10 then
begin
 if not (Ord(Key) = 8 ) then
 begin
  if RadioGroup1.ItemIndex=1 then  if not (Key in ['0'..'9']) then Key:=Chr(0);
  if RadioGroup1.ItemIndex=0 then  if not (Key in ['0'..'9','a'..'f','A'..'F']) then Key:=Chr(0);
 end;
end else Key:=Chr(0);
end;

end.
