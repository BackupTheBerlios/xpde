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
  TStringResourceEditor=class;

  //The form to edit strings
  TStringEditor = class(TForm)
    meStrings: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure meStringsChange(Sender: TObject);
  private
    { Private declarations }
    editor: TStringResourceEditor;                                              //The editor
    loading:boolean;                                                            //A simple switch
  public
    { Public declarations }
    procedure loadfromentry;                                                    //Load the strings into the memo
    procedure savetoentry;                                                      //Save the memo strings to the stream
  end;

  TStringResourceEditor=class(TResourceEditor)
  private
       stringeditor: TStringEditor;                                             //The form
       entry: TResourceEntry;
  public
       procedure edit(const entry:TResourceEntry);override;                     //Creates the string editor form
       destructor Destroy;override;                                             //Closes and saves
  end;

var
  StringEditor: TStringEditor;

implementation

{$R *.xfm}

{ TStringResourceEditor }

destructor TStringResourceEditor.Destroy;
begin
    //When the editor must close, saves the data to the entry if modified and releases the form
    if entry.Modified then stringeditor.savetoentry;
    stringeditor.release;
    stringeditor:=nil;
    inherited;
end;

procedure TStringResourceEditor.edit(const entry: TResourceEntry);
begin
    if not assigned(stringeditor) then begin
        //Create the editor and setup all is needed
        stringeditor:=TStringEditor.create(nil);
        stringeditor.editor:=self;
        stringeditor.caption:=stringeditor.caption+' - '+entry.resourcename;
        self.entry:=entry;
        stringeditor.loadfromentry;

    end;
end;

procedure TStringEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    //Closes the editor
    editor.free;
end;

//It must support unicode!!!
procedure TStringEditor.loadfromentry;
var
    b: byte;
    line:string;
    function readString(length:integer):string;
    var
        c: char;
        k: integer;
    begin
        result:='';
        for k:=0 to length-1 do begin
            editor.entry.data.Read(c,1); //#0
            editor.entry.data.Read(c,1);
            result:=result+c;
        end;
        editor.entry.data.Read(c,1); //#0
    end;
begin
    loading:=true;
    try
        meStrings.lines.clear;
        editor.entry.data.Position:=0;
        line:='';
        while editor.entry.data.position<editor.entry.data.size do begin
            editor.entry.data.Read(b,1);
            if b=0 then break;
            //b= size of the string to read *2 (unicode)
            line:=readstring(b);
            meStrings.lines.add(line);
        end;
        editor.entry.data.Position:=0;
        meStrings.modified:=false;
    finally
        loading:=false;
    end;
end;

procedure TStringEditor.meStringsChange(Sender: TObject);
begin
    //If not loading and the memo changes, then, the entry must be marked as modified
    if not loading then begin
        editor.entry.Modified:=true;
    end;
end;

procedure TStringEditor.savetoentry;
var
    i:integer;
    line:string;
    c: byte;
    d: char;
    k: integer;
begin
    editor.entry.data.Clear;
    for i:=0 to meStrings.Lines.count-1 do begin
        line:=meStrings.lines[i];
        c:=length(line);
        editor.entry.data.Write(c,1);
        for k:=1 to length(line) do begin
            d:=#0;
            editor.entry.data.Write(d,1);
            d:=line[k];
            editor.entry.data.Write(d,1);
        end;
        d:=#0;
        editor.entry.data.Write(d,1);
    end;
end;

initialization
    ResourceAPI.registerEditor('string',TStringResourceEditor);

end.
