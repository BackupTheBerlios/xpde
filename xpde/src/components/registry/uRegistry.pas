{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 Theo Lustenberger                                        }
{                                                                             }
{ This software is provided "as-is".  This software comes without warranty    }
{ or garantee, explicit or implied.  Use this software at your own risk.      }
{ The author will not be liable for any damage to equipment, data, or         }
{ information that may result while using this software.                      } 
{                                                                             }
{ By using this software, you agree to the conditions stated above.           }
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

Interface

Uses
  Libc, Classes, Sysutils;

Type
  ERegistryException = Class(Exception);

  TRegDataType = (rdUnknown, rdString, rdExpandString, rdInteger, rdBinary);

  TRegDataInfo = Record
  RegData: TRegDataType;
  DataSize: Integer;
End;

TRegistry = Class(TObject)
Private
  FRootKey: String;
  fCurrentPath:string;
  Procedure SetRootKey(const Value: string);
  Function GetRootPath: String;
  Function GetCurrentPath: String;
  Procedure PutData(const Name: String; Buffer: Pointer;
  BufSize: Integer; RegData: TRegDataType);
  Function GetData(const Name: String; Buffer: Pointer;
  BufSize: Integer; Var RegData: TRegDataType): Integer;
Public
  constructor Create;
  destructor Destroy; Override;
  Function OpenKey(const Key: String; CanCreate: Boolean): Boolean;
  Procedure CloseKey;
  Procedure DeleteKey;
  Function GetDataInfo(const ValueName: String; Var Value: TRegDataInfo): Boolean;
  Function Getdatatype(Const Valuename: String): Tregdatatype;
  Function Getdatasize(Const Valuename: String): Integer;
  Function Valueexists(Const Name: String): Boolean;
  Function Readinteger(Const Name: String): Integer;
  Function Readfloat(Const Name: String): Double;
  Function Readstring(Const Name: String): String;
  Function Readbool(Const Name: String): Boolean;
  Function Readdate(Const Name: String): Tdatetime;
  Function Readdatetime(Const Name: String): Tdatetime;
  Function Readtime(Const Name: String): Tdatetime;
  Function Readcurrency(Const Name: String): Currency;
  Function Readbinarydata(Const Name: String; Var Buffer; BufSize: Integer): Integer;
  Procedure Writeinteger(Const Name: String; Value: Integer);
  Procedure Writefloat(Const Name: String; Value: Double);
  Procedure Writestring(Const Name, Value: String);
  Procedure Writebool(Const Name: String; Value: Boolean);
  Procedure Writedate(Const Name: String; Value: Tdatetime);
  Procedure Writedatetime(Const Name: String; Value: Tdatetime);
  Procedure Writetime(Const Name: String; Value: Tdatetime);
  Procedure Writecurrency(Const Name: String; Value: Currency);
  Procedure Writebinarydata(Const Name: String; Var Buffer; BufSize: Integer);
  Property RootKey:string read FRootKey write SetRootKey;
  Property RootPath:string read GetRootPath;
  Property CurrentPath: String read GetCurrentPath;
End; 

Function Regdatatodatatype(Value: Tregdatatype): Integer;
Function Myfilesize(Const Name: String ): Longint;
Procedure Deletefiles(Path : String);
Function getHomeDir:String;


Const
  HKEY_CLASSES_ROOT = 'HKEY_CLASSES_ROOT';
  HKEY_CURRENT_USER = 'HKEY_CURRENT_USER';
  HKEY_LOCAL_MACHINE = 'HKEY_LOCAL_MACHINE';
  HKEY_USERS = 'HKEY_USERS';
  HKEY_PERFORMANCE_DATA = 'HKEY_PERFORMANCE_DATA';
  HKEY_CURRENT_CONFIG = 'HKEY_CURRENT_CONFIG';
  HKEY_DYN_DATA = 'HKEY_DYN_DATA';


  REG_SZ=0;
  REG_EXPAND_SZ=1;
  REG_DWORD=2;
  REG_BINARY=3;
  REG_NONE=4;

  file_types:array[0..3] of String=('.SZ','.EXPAND','.DWORD','.BINARY');

Implementation

Uses
  RTLConsts;

Procedure Readerror(Const Name: String);
Begin 
  raise ERegistryException.CreateResFmt(@SInvalidRegType, [Name]);
End;

{ TRegistry }

constructor TRegistry.Create;
Begin 
  FRootKey:=GetRootPath+'/'+HKEY_CURRENT_USER;
  fCurrentPath:='';
End; 

destructor TRegistry.Destroy;
Begin 
  inherited;
End; 

Function Regdatatodatatype(Value: Tregdatatype): Integer;
Begin 
  case Value Of 
    rdString: Result := REG_SZ;
    rdExpandString: Result := REG_EXPAND_SZ;
    rdInteger: Result := REG_DWORD;
    rdBinary: Result := REG_BINARY;
    Else
    Result := REG_NONE;
  End; 
End;

Function Tregistry.GetCurrentPath: String;
Begin 
  result:=fCurrentPath+'/';
End; 

Function Tregistry.GetRootPath: String;
Begin 
  result := getHomeDir + '/.registry';
End; 

Function Tregistry.Openkey(Const Key: String; Cancreate: Boolean): Boolean;
Begin 
  fCurrentPath:=FRootKey+'/'+Key;
  If cancreate then
    Begin 
      result:=ForceDirectories(fCurrentPath);
    End 
    Else
    Begin 
      result:=DirectoryExists(fCurrentPath);
    End; 
End; 

Procedure Tregistry.Closekey;
Begin 
  fCurrentPath:='';
End; 

Function Tregistry.Readinteger(Const Name: String): Integer;
Var
  RegData: TRegDataType;
Begin 
  GetData(Name, @Result, SizeOf(Integer), RegData);
  If RegData <> rdInteger then ReadError(Name);
End; 

Procedure Tregistry.Writeinteger(Const Name: String; Value: Integer);
Begin 
  PutData(Name,@Value, SizeOf(Integer),rdinteger);
End; 

Function Tregistry.Readstring(Const Name: String): String;
Var
  Len: Integer;
  RegData: TRegDataType;
Begin 
  Len := GetDataSize(Name);
  If Len > 0 then
    Begin 
      SetString(Result, nil, Len);
      GetData(Name, PChar(Result), Len, RegData);
    if (RegData = rdString) Or (RegData = rdExpandString) then
      SetLength(Result, StrLen(PChar(Result)))
      Else ReadError(Name);
    End 
    Else Result := '';
End; 


Procedure Tregistry.Writestring(Const Name, Value: String);
Begin 
  PutData(Name,Pchar(Value),Length(Value)+1,rdstring);
End; 

Function Tregistry.Readbool(Const Name: String): Boolean;
Begin 
  Result:=Boolean(ReadInteger(Name));
End; 

Procedure Tregistry.Writebool(Const Name: String; Value: Boolean);
Begin 
  WriteInteger(Name,Integer(Value));
End; 

Procedure Tregistry.Writefloat(Const Name: String; Value: Double);
Begin 
  PutData(Name, @Value, SizeOf(Double), rdBinary);
End; 

Function Tregistry.Readfloat(Const Name: String): Double;
Var
  Len: Integer;
  RegData: TRegDataType;
Begin 
  Len := GetData(Name, @Result, SizeOf(Double), RegData);
  if (RegData <> rdBinary) Or (Len <> SizeOf(Double)) then
    ReadError(Name);
End; 

Procedure Tregistry.Writedatetime(Const Name: String; Value: Tdatetime);
Begin 
  PutData(Name, @Value, SizeOf(TDateTime), rdBinary);
End; 

Function Tregistry.Readdatetime(Const Name: String): Tdatetime;
Var
  Len: Integer;
  RegData: TRegDataType;
Begin 
  Len := GetData(Name, @Result, SizeOf(TDateTime), RegData);
  if (RegData <> rdBinary) Or (Len <> SizeOf(TDateTime)) then
    ReadError(Name);
End; 

Procedure Tregistry.Writedate(Const Name: String; Value: Tdatetime);
Begin 
  WriteDateTime(Name, Value);
End; 

Function Tregistry.Readdate(Const Name: String): Tdatetime;
Begin 
  Result := ReadDateTime(Name);
End; 

Procedure Tregistry.Writetime(Const Name: String; Value: Tdatetime);
Begin 
  WriteDateTime(Name, Value);
End; 

Function Tregistry.Readtime(Const Name: String): Tdatetime;
Begin 
  Result := ReadDateTime(Name);
End; 

Procedure Tregistry.Writecurrency(Const Name: String; Value: Currency);
Begin 
  PutData(Name, @Value, SizeOf(Currency), rdBinary);
End; 

Function Tregistry.Readcurrency(Const Name: String): Currency;
Var
  Len: Integer;
  RegData: TRegDataType;
Begin
  Len := GetData(Name, @Result, SizeOf(Currency), RegData);
  if (RegData <> rdBinary) Or (Len <> SizeOf(Currency)) then
    ReadError(Name);
End; 

Procedure Tregistry.Writebinarydata(Const Name: String; Var Buffer;
           BufSize: Integer);
Begin 
  PutData(Name, @Buffer, BufSize, rdBinary);
End; 

Function Tregistry.Readbinarydata(Const Name: String; Var Buffer;
         BufSize: Integer): Integer;
Var
  RegData: TRegDataType;
  Info: TRegDataInfo;
Begin 
  If GetDataInfo(Name, Info) then
    Begin 
      Result := Info.DataSize;
      RegData := Info.RegData;
    if ((RegData = rdBinary) ) And (Result <= BufSize) then
      GetData(Name, @Buffer, Result, RegData)
      Else ReadError(Name);
    End
    Else
    Result := 0;
End; 

Function Tregistry.Getdata(Const Name: String; Buffer: Pointer;
         BufSize: Integer; Var RegData: TRegDataType): Integer;
Var
  filename: String;
  m:TMemoryStream;
  di:TRegDataInfo;
Begin 
  result:=-1;
  if (fCurrentPath='') Or (fRootKey='') Or (fCurrentPath=fRootKey) then
    raise ERegistryException.CreateResFmt(@SRegGetDataFailed, [Name]) Else
    Begin 
    If  GetDataInfo(Name,di) then
      Begin 
        filename:=fCurrentPath+'/'+Name+file_types[RegDataToDataType(di.RegData)];
      If fileexists(filename) then
        Begin 
          m:=TMemoryStream.create;
          Try 
            m.LoadFromFile(filename);
            m.position:=0;
            m.Read(Buffer^,BufSize);
            Result := di.DataSize;
            RegData := di.RegData;
            finally
            m.free;
          End; 
        End; 
      End; 
    End; 
End; 

Procedure Tregistry.Putdata(Const Name: String; Buffer: Pointer;
          BufSize: Integer; RegData: TRegDataType);
Var
  DataType: Integer;
  filename: String;
  m:TMemoryStream;
Begin 
  if (fCurrentPath='') Or (fRootKey='') Or (fCurrentPath=fRootKey) then
    raise ERegistryException.CreateResFmt(@SRegSetDataFailed, [Name]) Else
    Begin 
      DataType := RegDataToDataType(RegData);
      filename:=fCurrentPath+'/'+Name+file_types[DataType];
      m:=TMemoryStream.create;
      Try 
        m.write(buffer^,BufSize);
        m.position:=0;
        m.SaveToFile(filename);
        finally
        m.free;
      End; 
    End; 
End;

Procedure Tregistry.Setrootkey(Const Value: String);
Begin 
  FRootKey := GetRootPath+'/'+Value;
End; 

Function Tregistry.Valueexists(Const Name: String): Boolean;
Var
  sr:TRegDataInfo;
Begin 
  result:= GetDataInfo(Name,sr)
End;

Function Tregistry.Getdatainfo(Const Valuename: String;
         Var Value: TRegDataInfo): Boolean;
Var
  KeyName: String;
Begin 
  KeyName:=fCurrentPath+'/'+ValueName;

  Value.RegData:=rdunknown;
  Result:=false;
  If fileexists(KeyName+file_types[REG_SZ]) then
    Begin 
      Value.RegData:=rdString;
      Value.DataSize:=MyFileSize(KeyName+file_types[REG_SZ]);
    End 
    Else
  If fileexists(KeyName+file_types[REG_DWORD]) then
    Begin 
      Value.RegData:=rdInteger;
      Value.DataSize:=MyFileSize(KeyName+file_types[REG_DWORD]);
    End 
    Else
  If fileexists(KeyName+file_types[REG_BINARY]) then
    Begin 
      Value.RegData:=rdBinary;
      Value.DataSize:=MyFileSize(KeyName+file_types[REG_BINARY]);
    End; 

  If Value.RegData<>rdunknown then result:=true;
End; 

Function Tregistry.Getdatasize(Const Valuename: String): Integer;
Var
  Info: TRegDataInfo;
Begin 
  If GetDataInfo(ValueName, Info) then
    Result := Info.DataSize Else
    Result := -1;
End; 

Function Tregistry.Getdatatype(Const Valuename: String): Tregdatatype;
Var
  Info: TRegDataInfo;
Begin 
  If GetDataInfo(ValueName, Info) then
    Result := Info.RegData Else
    Result := rdUnknown;
End; 

Procedure Tregistry.Deletekey;
Begin 
  if (fCurrentPath='') Or (fRootKey='') Or (fCurrentPath=fRootKey) then
    raise ERegistryException.CreateFmt('Cannot delete Key ', [fCurrentPath]) Else
    Begin 
      DeleteFiles(fCurrentPath);
      RemoveDir(fCurrentPath);
    End; 
End; 

//***************** Helpers *********************************

Procedure Deletefiles(Path : String);
Var
  SearchRec : TSearchRec;
  Found     : Integer;
Begin 
  If IsPathDelimiter(Path,length(Path)) then Path:=copy(Path,1,length(Path)-1);
    Found := FindFirst(Path+PathDelim+'*',faAnyFile,SearchRec);
  If Found = 0 THEN
    Begin 
      While Found = 0 DO
      Begin 
      IF (SearchRec.Attr And faDirectory) = faDirectory THEN
        Begin 
        IF (SearchRec.Name <> '.') And (SearchRec.Name <> '..') THEN
          Begin 
            DeleteFiles(Path+PathDelim+SearchRec.Name);
            RemoveDir(Path+PathDelim+SearchRec.Name);
          End; 
        End
        Else
        Begin 
          DeleteFile(Path+PathDelim+SearchRec.Name);
        End; 
        Found := FindNext(SearchRec);
      End; 
      FindClose(SearchRec);
    End; 
End; 

Function Myfilesize(Const Name: String ): Longint;
Var
  SRec: TSearchRec;
Begin 
  If FindFirst( name, faAnyfile, SRec ) = 0 Then
    Begin 
      Result := SRec.Size;
      Sysutils.FindClose( SRec );
    End 
    Else
    Result := 0;
End;

Function getHomeDir:String;
begin
    result := getpwuid(getuid)^.pw_dir;
end;

end.

