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
    meStrings: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    entry: TResourceEntry;
  public
    { Public declarations }
    procedure loadfromentry;
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
        editor.entry:=entry;
        editor.loadfromentry;
    end;
end;

procedure TStringEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    action:=caFree;
end;

procedure TStringEditor.loadfromentry;
var
    c: array [0..512] of char;
    b: byte;
    i: integer;
    line:string;
    function readString(length:integer):string;
    var
        c: char;
        k: integer;
    begin
        result:='';
        for k:=0 to length-1 do begin
            entry.data.Read(c,1); //#0
            entry.data.Read(c,1);
            result:=result+c;            
        end;
        entry.data.Read(c,1); //#0
    end;
begin
    meStrings.lines.clear;
    entry.data.Position:=0;
    line:='';
    while entry.data.position<entry.data.size do begin
        entry.data.Read(b,1);
        if b=0 then break;
        //b= size of the string to read *2 (unicode)
        line:=readstring(b);
        meStrings.lines.add(line);
    end;
    entry.data.Position:=0;
//    meStrings.Lines.LoadFromStream(entry.data);
end;

initialization
    ResourceAPI.registerEditor('string',TStringResourceEditor);

end.
