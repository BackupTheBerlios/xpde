{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003, Valeriy Gabrusev <valery@xpde.com>                      }
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

unit uUserPropeties;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QComCtrls, QExtCtrls;

type
  TProperties = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    lbUserName: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbChange: TCheckBox;
    cbNotChange: TCheckBox;
    cbExpires: TCheckBox;
    cbDisable: TCheckBox;
    Panel1: TPanel;
    edFullName: TEdit;
    edDescrip: TEdit;
    cbSamba: TCheckBox;
    cbLocked: TCheckBox;
    ListView1: TListView;
    btnAdd: TButton;
    btnRemove: TButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Properties: TProperties;

implementation

{$R *.xfm}

procedure TProperties.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TProperties.btnCancelClick(Sender: TObject);
begin
   Close;
end;

procedure TProperties.btnApplyClick(Sender: TObject);
begin
  Close;
end;

end.
