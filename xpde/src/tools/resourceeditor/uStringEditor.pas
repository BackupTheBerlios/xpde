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
  QStdCtrls, uResources, uFormEditor,
  uResourceAPI, QGrids;

type
  TStringResourceEditor=class;

  //The form to edit strings
  TStringEditor = class(TForm)
    sgStrings: TStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure sgStringsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: WideString);
  private
    { Private declarations }
    editor: TResourceEditor;                                              //The editor
  public
    { Public declarations }
    procedure loadfromstrings(strings:TStrings);
  end;

  TStringResourceEditor=class(TResourceEditor)
  private
       stringeditor: TStringEditor;                                             //The form
  public
       procedure loadeditor; override;
       procedure savefromeditor; override;
       procedure edit(const anentry:TResourceEntry);override;                     //Creates the string editor form
       destructor Destroy;override;                                             //Closes and saves
  end;

  TFormResourceEditor=class(TResourceEditor)
  private
       stringeditor: TStringEditor;                                             //The form
  public
       procedure loadeditor; override;
       procedure savefromeditor; override;
       procedure edit(const anentry:TResourceEntry);override;                     //Creates the string editor form
       destructor Destroy;override;                                             //Closes and saves
  end;

implementation

{$R *.xfm}

{ TStringResourceEditor }

destructor TStringResourceEditor.Destroy;
begin
    //When the editor must close, saves the data to the entry if modified and releases the form
    if entry.Modified then savefromeditor;
    stringeditor.release;
    stringeditor:=nil;
    inherited;
end;

procedure TStringResourceEditor.edit(const anentry: TResourceEntry);
begin
    if not assigned(stringeditor) then begin
        //Create the editor and setup all is needed
        stringeditor:=TStringEditor.create(nil);
        stringeditor.editor:=self;
        stringeditor.caption:=stringeditor.caption+' - '+anentry.resourcename;
        entry:=anentry;
        loadeditor;

    end;
end;

procedure TStringEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    //Closes the editor
    editor.free;
end;

procedure TStringEditor.FormResize(Sender: TObject);
var
    w: integer;
begin
    w:=(clientwidth - 2) - sgStrings.ColWidths[0];
    sgStrings.ColWidths[1]:=w;
end;

procedure TStringResourceEditor.loadeditor;
var
    b: byte;
    strings: TStringList;
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
    strings:=TStringList.create;
    try
        entry.data.Position:=0;
        line:='';
        while entry.data.position<entry.data.size do begin
            entry.data.Read(b,1);
            if b=0 then break;
            //b= size of the string to read *2 (unicode)
            line:=readstring(b);
            strings.add(line+'='+line);
        end;
        entry.data.Position:=0;
        stringeditor.loadfromstrings(strings);
    finally
        strings.free;
    end;
    entry.Modified:=false;
end;

procedure TStringResourceEditor.savefromeditor;
var
    i:integer;
    line:string;
    c: byte;
    d: char;
    k: integer;
begin
    entry.data.Clear;
    for i:=0 to stringeditor.sgStrings.rowcount-1 do begin
        line:=stringeditor.sgStrings.cells[1,i];
        c:=length(line);
        entry.data.Write(c,1);
        for k:=1 to length(line) do begin
            d:=#0;
            entry.data.Write(d,1);
            d:=line[k];
            entry.data.Write(d,1);
        end;
        d:=#0;
        entry.data.Write(d,1);
    end
end;

{ TFormResourceEditor }

destructor TFormResourceEditor.Destroy;
begin
    //When the editor must close, saves the data to the entry if modified and releases the form
    if entry.Modified then savefromeditor;
    stringeditor.release;
    stringeditor:=nil;
    inherited;
end;

procedure TFormResourceEditor.edit(const anentry: TResourceEntry);
begin
    if not assigned(stringeditor) then begin
        //Create the editor and setup all is needed
        stringeditor:=TStringEditor.create(nil);
        stringeditor.editor:=self;
        stringeditor.caption:=stringeditor.caption+' - '+anentry.resourcename;
        entry:=anentry;
        loadeditor;
    end;
end;

procedure TStringEditor.loadfromstrings(strings: TStrings);
var
    i:longint;
begin
    sgStrings.RowCount:=strings.count;
    for i:=0 to strings.count-1 do begin
        sgStrings.Cells[0,i]:=strings.names[i];
        sgStrings.Cells[1,i]:=strings.values[strings.names[i]];
    end;
end;

procedure TFormResourceEditor.loadeditor;
var
    str: TStringList;
begin
    str:=TStringList.create;
    try
        GetFormRes(entry,str);
        stringeditor.loadfromstrings(str);
    finally
        str.free;
    end;
    entry.Modified:=false;
end;

procedure TFormResourceEditor.savefromeditor;
var
    str: TStringList;
    i:integer;
    name:string;
    value:string;
begin
    str:=TStringList.create;
    try
        for i:=0 to stringeditor.sgStrings.rowcount-1 do begin
            name:=stringeditor.sgStrings.cells[0,i];
            value:=stringeditor.sgStrings.cells[1,i];
            str.add(name+'='+value);
        end;
        SetFormRes(entry, str);
    finally
        str.free;
    end;
end;

procedure TStringEditor.sgStringsSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: WideString);
begin
    editor.entry.Modified:=true;
end;

initialization
    ResourceAPI.registerEditor('string',TStringResourceEditor);
    ResourceAPI.registerEditor('RCDATA',TFormResourceEditor);

end.
