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
unit uServiceSettings;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, uQXPComCtrls;

type
  TServiceSettingsDlg = class(TForm)
        Button2:TButton;
        Button1:TButton;
        Edit4:TEdit;
        Label4:TLabel;
        RadioButton2:TRadioButton;
        RadioButton1:TRadioButton;
        Edit3:TEdit;
        Label3:TLabel;
        Edit2:TEdit;
        Label2:TLabel;
        Edit1:TEdit;
        Label1:TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServiceSettingsDlg: TServiceSettingsDlg;

implementation

{$R *.xfm}

end.
