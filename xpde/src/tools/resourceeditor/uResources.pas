{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002                                                          }
{ José León Serna <ttm@xpde.com>                                              }
{ Jens Kühner <jens@xpde.com>                                                 }
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

{ extract resources from elf-application to res-file:
    resbind /app -r /untranslated.res

  create so-language-file of tranmslated res-file
    resbind -s ./app.de_DE ./app ./translated.res
  where de_DE is the contents of the enviroment-var "lang"
}


unit uResources;

interface

uses Contnrs, SysUtils, Classes, QDialogs;

type
    TResourceType=(rtCursor, rtBitmap, rtIcon, rtMenu, rtDialog, rtString, rtFontdir, rtFont, rtAccelerator, rtRCData, rtGroupCursor, rtGroupIcon, rtMessageTable, rtVersion, rtDLGInclude, rtPlugPlay, rtVXD, rtAnicursor, rtNone);

    //A resource file, just a list of resource entries
    TResourceFile=class(TComponent)
    private
        function getIsModified: boolean;
    public
        resources: TObjectList;
        procedure getResourceNames(strings: TStrings);
        procedure loadfromfile(const filename:string);
        procedure savetofile(const filename:string);
        constructor Create(AOwner:TComponent);override;
        destructor Destroy;override;
        property IsModified:boolean read getIsModified;
    end;

    //A resource entry
    TResourceEntry=class(TObject)
    private
        FModified: boolean;
        procedure SetModified(const Value: boolean);
    public
        //Just 32 byte resources, 16 bit not supported
        datasize:integer;
        headersize: integer;
        resourcetype: TResourceType;
        sResourcetype: string;
        //If first two are $FFFF, the subsequent two bytes are numeric value
        //else, the first two are the first Unicode in a zs
        sResourcename: string;
        wResourcename : word;
        dataversion: integer;
        flags: word;
        language: word;
        version:integer;
        characteristics: integer;
        data: TMemoryStream;
        resourcefile: TResourceFile;
        procedure ReadFromStream(stream:TStream);
        procedure WriteToStream(stream: TStream);
        constructor Create;
        destructor Destroy;override;
        property Modified:boolean read FModified write SetModified;
    end;

function ResourceTypeToString(const rt: TResourceType):string;

implementation

function ResourceTypeToString(const rt: TResourceType):string;
begin
    result:='(none)';
    case rt of
        rtCursor: result:='Cursor';
        rtBitmap: result:='Bitmap';
        rtIcon: result:='Icon';
        rtMenu: result:='Menu';
        rtDialog: result:='Dialog';
        rtString: result:='String';
        rtFontdir: result:='Fontdir';
        rtFont: result:='Font';
        rtAccelerator: result:='Accelerator';
        rtRCData: result:='RCData';
        rtGroupCursor: result:='GroupCursor';
        rtGroupIcon: result:='GroupIcon';
        rtMessageTable: result:='MessageTable';
        rtVersion: result:='Version';
        rtDLGInclude: result:='DLGInclude';
        rtPlugPlay: result:='PlugPlay';
        rtVXD: result:='VXD';
        rtAnicursor: result:='Anicursor';
        rtNone: result:='None';
    end;
end;


{ TResourceFile }

constructor TResourceFile.Create(AOwner: TComponent);
begin
  inherited;
  resources:=TObjectList.create;
end;

destructor TResourceFile.Destroy;
begin
  resources.free;
  inherited;
end;

function TResourceFile.getIsModified: boolean;
var
    i:longint;
begin
    result:=false;
    for i:=0 to resources.count-1 do begin
        result:=(resources[i] as TResourceEntry).Modified;
        if result then break;
    end;
end;

//Return all the resource names in strings
procedure TResourceFile.getResourceNames(strings: TStrings);
var
    i:longint;
begin
    for i:=0 to resources.count-1 do begin
        strings.add((resources[i] as TResourceEntry).sResourcename);
    end;
end;

//Loads a resource file
procedure TResourceFile.loadfromfile(const filename:string);
var
    f: TFileStream;
    r: TResourceEntry;
begin
    resources.Clear;
    f:=TFileStream.create(filename,fmOpenRead);
    try
        //Skip first 32 bytes
        f.Position:=32;

        while f.Position<f.size do begin
            r:=TResourceEntry.create;
            try
                r.resourcefile:=self;
                r.ReadFromStream(f);
                resources.add(r);
            except
                r.free;
                raise;
            end;
        end;
    finally
        f.free;
    end;
end;

//Saves a resource file
procedure TResourceFile.savetofile(const filename:string);
var
    f: TFileStream;
    i : integer;
const
  header : array[0..7] of Cardinal = ($0,$20,$FFFF,$FFFF,0,0,0,0);
begin
    f:=TFileStream.create(filename,fmCreate or fmOpenWrite);
    try
        //Skip first 32 bytes
        f.Write(header, 32);

        for i := 0 to resources.Count-1 do begin
           (resources[i] as TResourceEntry).WriteToStream(f);
        end;
    finally
        f.free;
    end;
end;

{ TResourceEntry }

constructor TResourceEntry.Create;
begin
    inherited;
    FModified:=false;
    data:=TMemoryStream.create;
    resourceType:=rtNone;
    sresourcetype:='';
end;

destructor TResourceEntry.Destroy;
begin
  data.free;
  inherited;
end;

procedure TResourceEntry.ReadFromStream(stream: TStream);
var
    w: word;
    //Aligns a integer to a dword
    function dwordalign(const value:integer):integer;
    begin
        result:=value;
        if (result mod 2)<>0 then result:=result+1;
        if (result mod 4)<>0 then result:=result+2;
    end;
begin
    FModified:=false;

    stream.Read(datasize,4);
    stream.Read(headersize,4);

    //Reads the resource type
    stream.Read(w,2);
    if (w=$FFFF) then begin
        stream.Read(w,2);
        resourceType:=TResourceType(w-1);
    end
    else begin
        sresourcetype:='';
        while (w<>0) do begin
            sresourcetype:=sresourcetype+chr(w);
            stream.Read(w,2);
        end;
    end;

    //Reads the resource name
    stream.Read(w,2);
    if (w=$FFFF) then begin
        stream.Read(w,2);
        sResourcename:=inttostr(w);
        wResourceName:=w;
    end
    else begin
        sResourcename:='';
        while (w<>0) do begin
            sResourcename:=sResourcename+chr(w);
            stream.Read(w,2);
        end;
    end;

    //Align dword boundaries
    stream.position:=dwordalign(stream.position);

    stream.Read(dataversion,4);
    stream.Read(flags,2);
    stream.Read(language,2);
    stream.Read(version,4);
    stream.Read(characteristics,4);

    //Stores the resource data in the stream
    data.CopyFrom(stream,datasize);

    //Align dword boundaries for next resource entry
    stream.position:=dwordalign(stream.position);
end;

procedure TResourceEntry.WriteToStream(stream: TStream);
var
    w: word;
    dw : Cardinal;
    i : integer;
    //Aligns a integer to a dword
    function dwordalign(const value:integer):integer;
    begin
        result:=value;
        if (result mod 2)<>0 then result:=result+1;
        if (result mod 4)<>0 then result:=result+2;
    end;
begin
    FModified:=false;

    dw := data.size;
    stream.Write(dw,4);//write new data-size
    stream.Write(headersize,4);//always equal to loaded

    //Writes the resource type
    if sResourceType <> '' then begin
      //string
      for i := 1 to length(sResourceType) do begin
         w := ord(sResourceType[i]);
         stream.Write(w, 2);
      end;
      w := 0;
      stream.Write(w, 2);
    end else begin
      //numeric
      w := $FFFF;
      stream.Write(w, 2);
      w := ord(resourceType)+1;
      stream.Write(w, 2);
    end;

    //writes the resource name
    if wResourceName = 0 then begin
      //string
      for i := 1 to length(sResourceName) do begin
         w := ord(sResourceName[i]);
         stream.Write(w, 2);
      end;
      w := 0;
      stream.Write(w, 2);
    end else begin
      //numeric
      w := $FFFF;
      stream.Write(w, 2);
      stream.Write(wResourceName, 2);
    end;

    //Align dword boundaries
    stream.position:=dwordalign(stream.position);

    stream.Write(dataversion,4);
    stream.Write(flags,2);
    stream.Write(language,2);
    stream.Write(version,4);
    stream.Write(characteristics,4);

    //Stores the resource data in the stream
    data.Position := 0;
    data.SaveToStream(stream);

    //Align dword boundaries for next resource entry
    stream.position:=dwordalign(stream.position);
end;

procedure TResourceEntry.SetModified(const Value: boolean);
begin
    if value<>FModified then begin
        FModified := Value;
    end;
end;

end.
