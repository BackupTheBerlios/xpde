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

unit EdString;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls;
type
  TFrmEditString = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
    procedure SetName(Value: string);
    procedure SetValue(Value: string);
    function GetValue: string;
  public
    property Name: string write SetName;
    property Value: string read GetValue write SetValue;
    { Public declarations }
  end;
var
  FrmEditString: TFrmEditString;
implementation
{$R *.xfm}

procedure TFrmEditString.SetName(Value: string);
begin
  Edit1.Text := Value;
end;

procedure TFrmEditString.SetValue(Value: string);
begin
  Edit2.Text := Value;
end;

function TFrmEditString.GetValue: string;
begin
  Result := Edit2.Text;
end;
end.

