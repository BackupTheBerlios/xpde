{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 José León Serna <ttm@xpde.com>                           }
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
unit uStringEditor;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, uResources, uResourceAPI;

type
  TStringEditor = class(TForm)
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TStringResourceEditor=class(TResourceEditor)
  private
       editor: TStringEditor;
  public
       procedure edit(const entry:TResourceEntry);override;
       procedure close;override;
  end;

var
  StringEditor: TStringEditor;

implementation

{$R *.xfm}

{ TStringResourceEditor }

procedure TStringResourceEditor.close;
begin
    editor.release;
    editor:=nil;
end;

procedure TStringResourceEditor.edit(const entry: TResourceEntry);
begin
    if not assigned(editor) then begin
        editor:=TStringEditor.create(nil);
        editor.caption:=editor.caption+' - '+entry.resourcename;
    end;
end;

procedure TStringEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    action:=caFree;
end;

initialization
    ResourceAPI.registerEditor('string',TStringResourceEditor);

end.
