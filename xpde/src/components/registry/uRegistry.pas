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

unit uRegistry;

interface

//Enable/Disable this declaration to enable/disable debugging
//{$define DEBUG}

uses Libc, Classes, 
{$ifdef DEBUG}
QDialogs,
{$endif}
Sysutils;

type
    TRegistry = class(TObject)
  private
        FRootKey: string;
        FLastPath:string;
        procedure SetRootKey(const Value: string);
        function GetRootPath: string;
        function GetLastPath: string;
    public
        constructor Create;
        destructor Destroy; override;
        function OpenKey(const Key: string; CanCreate: Boolean): Boolean;
        function ReadInteger(const Name: string): Integer;
        function ReadString(const Name: string): string;
        function ValueExists(const Name: string): Boolean;
        procedure WriteInteger(const Name: string; Value: Integer);
        procedure WriteString(const Name, Value: string);
        property RootKey:string read FRootKey write SetRootKey;
        property RootPath:string read GetRootPath;
        property LastPath: string read GetLastPath;
    end;

const
    HKEY_CLASSES_ROOT = 'HKEY_CLASSES_ROOT';
    HKEY_CURRENT_USER = 'HKEY_CURRENT_USER';
    HKEY_LOCAL_MACHINE = 'HKEY_LOCAL_MACHINE';
    HKEY_USERS = 'HKEY_USERS';
    HKEY_PERFORMANCE_DATA = 'HKEY_PERFORMANCE_DATA';
    HKEY_CURRENT_CONFIG = 'HKEY_CURRENT_CONFIG';
    HKEY_DYN_DATA = 'HKEY_DYN_DATA';

    DATA_TYPES=1;
    DATA_TYPE_STRING=0;
    DATA_TYPE_INTEGER=1;

    VALUE_EXTENSIONS:array[0..DATA_TYPES] of string=('.SZ','.DWORD');

implementation

procedure OutputDebugString(const str:string);
begin
{$ifdef DEBUG}
    showmessage(str);
{$endif}
end;

{ TRegistry }

constructor TRegistry.Create;
begin
    FRootKey:=GetRootPath+'/'+HKEY_CURRENT_USER;
    FLastPath:='';
end;

destructor TRegistry.Destroy;
begin

  inherited;
end;

function TRegistry.GetLastPath: string;
begin

end;

function TRegistry.GetRootPath: string;
begin
    result := getpwuid(getuid)^.pw_dir + '/.registry';
end;

function TRegistry.OpenKey(const Key: string; CanCreate: Boolean): Boolean;
begin
    FLastPath:=FRootKey+'/'+Key;
    if cancreate then begin
        result:=ForceDirectories(FLastPath);
    end
    else begin
        result:=DirectoryExists(FLastPath);
    end;
end;

function TRegistry.ReadInteger(const Name: string): Integer;
var
    filename: string;
    m:TMemoryStream;
begin
    filename:=FLastPath+'/'+Name+value_extensions[data_type_integer];
    result:=0;
    if fileexists(filename) then begin
        m:=TMemoryStream.create;
        try
            m.LoadFromFile(filename);
            m.position:=0;
            m.Read(result,sizeof(integer));
        finally
            m.free;
        end;
    end;
end;

function TRegistry.ReadString(const Name: string): string;
var
    filename: string;
    m:TMemoryStream;
    buf: array[0..255] of char;
begin
    FillChar(buf,256,0);
    filename:=FLastPath+'/'+Name+value_extensions[data_type_string];
    result:='';
    if fileexists(filename) then begin
        m:=TMemoryStream.create;
        try
            m.LoadFromFile(filename);
            m.position:=0;
            m.Read(buf,m.size);
            result:=string(buf);
        finally
            m.free;
        end;
    end;
end;

procedure TRegistry.SetRootKey(const Value: string);
begin
    FRootKey := GetRootPath+'/'+Value;
end;

function TRegistry.ValueExists(const Name: string): Boolean;
var
    filename: string;
begin
    filename:=FLastPath+'/'+Name+value_extensions[data_type_string];
    result:=fileexists(filename);
end;

procedure TRegistry.WriteInteger(const Name: string; Value: Integer);
var
    filename: string;
    m:TMemoryStream;
begin
    filename:=FLastPath+'/'+Name+value_extensions[data_type_integer];
    m:=TMemoryStream.create;
    try
        m.write(value,sizeof(integer));
        m.position:=0;
        m.SaveToFile(filename);
    finally
        m.free;
    end;
end;

procedure TRegistry.WriteString(const Name, Value: string);
var
    filename: string;
    m:TMemoryStream;
begin
    filename:=FLastPath+'/'+Name+value_extensions[data_type_string];
    m:=TMemoryStream.create;
    try
        m.write(PChar(Value)^,length(value));
        m.position:=0;
        m.savetofile(filename);
    finally
        m.free;
    end;
end;

end.

