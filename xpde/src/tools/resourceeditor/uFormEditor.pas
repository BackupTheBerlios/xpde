{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002                                                          }
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

unit uFormEditor;

interface

uses
  uResources, classes;

procedure GetFormRes( entry : TresourceEntry; strings : TStrings );
procedure SetFormRes( entry : TresourceEntry; strings : TStrings );

implementation

uses
  sysUtils, rtlConsts;

type
  TMyWriter = class(TWriter)
     public
       procedure WritePrefix(Flags: TFilerFlags; AChildPos: Integer);
  end;

procedure TMyWriter.WritePrefix(Flags: TFilerFlags; AChildPos: Integer);
begin
   inherited WritePrefix(Flags, AChildPos);
end;

//************************************************************************
procedure GetFormRes( entry : TresourceEntry; strings : TStrings );
var
  SaveSeparator: Char;
  Reader: TReader;
  strObjectName, strPropName: string;
  iPropSubNo : integer;

  procedure ConvertBinary;
  var
    Count: Longint;
  begin
    Reader.ReadValue;
    Reader.Read(Count, SizeOf(Count));
    Reader.Position := Reader.Position + count;
  end;

  procedure ConvertProperty; forward;

  procedure ConvertValue;
  var
    strId, strVal : string;
  begin
    case Reader.NextValue of
      vaList:
        begin
          iPropSubNo := 0;
          Reader.ReadValue;
          while not Reader.EndOfList do begin
            ConvertValue;
            inc(iPropSubNo);
          end;
          Reader.ReadListEnd;
        end;
      vaInt8, vaInt16, vaInt32:
        Reader.ReadInteger;
      vaExtended:
        Reader.ReadFloat;
      vaSingle:
        Reader.ReadSingle;
      vaCurrency:
        Reader.ReadCurrency;
      vaDate:
        Reader.ReadDate;
      //strings
      vaWString, vaUTF8String,
      vaString, vaLString:
        begin
          if Reader.NextValue in [vaWString, vaUTF8String] then
             strVal := Reader.ReadWideString;
          if Reader.NextValue in [vaString, vaLString] then
             strVal := Reader.ReadString;
          strId := strObjectname+'.'+strPropname;
          if iPropSubNo <> -1 then
            strId := strId + inttostr(iPropSubNo);
          strings.Add(strId+'='+strVal);
        end;
      /////
      vaIdent, vaFalse, vaTrue, vaNil, vaNull:
          Reader.ReadIdent;
      vaBinary:
        ConvertBinary;
      vaSet:
        begin
          Reader.ReadValue;
          repeat
          until Reader.ReadStr = '';
        end;
      vaCollection:
        begin
          Reader.ReadValue;
          while not Reader.EndOfList do begin
            if Reader.NextValue in [vaInt8, vaInt16, vaInt32] then begin
              ConvertValue;
            end;
            Reader.CheckValue(vaList);
            while not Reader.EndOfList do ConvertProperty;
            Reader.ReadListEnd;
          end;
          Reader.ReadListEnd;
        end;
      vaInt64:
        Reader.ReadInt64;
    else
      raise EReadError.CreateResFmt(@sPropertyException,
        [strObjectName, '.', strPropName, IntToStr(Ord(Reader.NextValue))]);
    end;
  end;

  procedure ConvertProperty;
  begin
    strPropName := Reader.ReadStr;  // save for error reporting
    iPropSubNo  := -1;
    ConvertValue;
  end;

  procedure ConvertHeader;
  var
    ClassName: string;
    Flags: TFilerFlags;
    Position: Integer;
  begin
    Reader.ReadPrefix(Flags, Position);
    ClassName := Reader.ReadStr;
    strObjectName := Reader.ReadStr;

    if strObjectName = '' then
      strObjectName := ClassName;  // save for error reporting
  end;

  procedure ConvertObject;
  begin
    ConvertHeader;
    while not Reader.EndOfList do ConvertProperty;
    Reader.ReadListEnd;
    while not Reader.EndOfList do ConvertObject;
    Reader.ReadListEnd;
  end;

begin
  strings.clear;
   //only resourcetype RCData
   //all forms begin with TFilerSignature signature TPF0 (Turbo-Pascal-Filer)
  if not (entry.resourceType = rtRCData) then exit;
  if not comparemem( entry.data.memory, pchar('TPF0'), 4 ) then exit;

  entry.data.position := 0;
  Reader              := TReader.Create(entry.data, 4096);
  SaveSeparator       := DecimalSeparator;
  DecimalSeparator    := '.';
  try
      Reader.ReadSignature;
      ConvertObject;
  finally
    DecimalSeparator := SaveSeparator;
    Reader.Free;
  end;
end;

//**********************************************************************
procedure SetFormRes( entry : TresourceEntry; strings : TStrings );
var
  input : TMemoryStream;
  SaveSeparator: Char;
  Reader: TReader;
  Writer : TMyWriter;
  strObjectName, strPropName: string;
  iPropSubNo : integer;

  procedure ConvertBinary;
  var
    Count: Longint;
    i : LongInt;
    bt : byte;
  begin
    writer.Writevalue( Reader.ReadValue );
    Reader.Read(Count, SizeOf(Count));
    writer.Write(Count, sizeof(Count) );
    //not the fastest but it works
    for i := 1 to Count do begin
      Reader.Read(bt,1);
      Writer.Write(bt, 1);
    end;
  end;

  procedure ConvertProperty; forward;

  procedure ConvertValue;
  var
    strId : string;
    strTmp : string;
  begin
//    assert(reader.position = writer.position);
    case Reader.NextValue of
      vaList:
        begin
          iPropSubNo := 0;
          writer.writeValue( reader.ReadValue );
          while not Reader.EndOfList do begin
            ConvertValue;
            inc(iPropSubNo);
          end;
          Reader.ReadListEnd;
          writer.writeListEnd;
        end;
      vaInt8, vaInt16, vaInt32:
        writer.writeInteger( Reader.ReadInteger );
      vaExtended:
        writer.WriteFloat( Reader.ReadFloat );
      vaSingle:
        writer.WriteSingle( Reader.ReadSingle );
      vaCurrency:
        writer.writeCurrency( Reader.ReadCurrency );
      vaDate:
        writer.WriteDate( reader.ReadDate );
      //strings
      vaWString, vaUTF8String,
      vaString, vaLString:
        begin
          strId := strObjectname+'.'+strPropname;
          if iPropSubNo <> -1 then
            strId := strId + inttostr(iPropSubNo);
          if Reader.NextValue in [vaWString, vaUTF8String] then begin
             Reader.ReadWideString;
             writer.writeWideString( strings.Values[strId] );
          end;
          if Reader.NextValue in [vaString, vaLString] then begin
             Reader.ReadString;
             writer.Writestring( strings.Values[strId] );
          end;
        end;
      /////
      vaIdent, vaFalse, vaTrue, vaNil, vaNull:
          writer.WriteIdent( reader.ReadIdent );
      vaBinary:
        ConvertBinary;
      vaSet:
        begin
          writer.writeValue( Reader.ReadValue );
          repeat
            strTmp := Reader.ReadStr;
            writer.WriteStr(strTmp);
          until strTmp = '';
        end;
      vaCollection:
        begin
          writer.WriteValue( Reader.ReadValue );
          while not Reader.EndOfList do begin
            if Reader.NextValue in [vaInt8, vaInt16, vaInt32] then begin
              ConvertValue;
            end;
            Reader.CheckValue(vaList);
            while not Reader.EndOfList do ConvertProperty;
            Reader.ReadListEnd;
            Writer.WriteListEnd;
          end;
          Reader.ReadListEnd;
          Writer.WriteListEnd;
        end;
      vaInt64:
        writer.writeInteger( Reader.ReadInt64 );
    else
      raise EReadError.CreateResFmt(@sPropertyException,
        [strObjectName, '.', strPropName, IntToStr(Ord(Reader.NextValue))]);
    end;
  end;

  procedure ConvertProperty;
  begin
    strPropName := Reader.ReadStr;  // save for error reporting
    Writer.WriteStr(strPropName);
    iPropSubNo  := -1;
    ConvertValue;
  end;

  procedure ConvertHeader;
  var
    strClassName: string;
    Flags: TFilerFlags;
    Position: Integer;
  begin
    Reader.ReadPrefix(Flags, Position);
    Writer.WritePrefix(Flags, Position);
    strClassName  := Reader.ReadStr;
    strObjectName := Reader.ReadStr;
    Writer.WriteStr(strClassName);
    Writer.WriteStr(strObjectName);

    if strObjectName = '' then
      strObjectName := strClassName;  // save for error reporting
  end;

  procedure ConvertObject;
  begin
    ConvertHeader;
    while not Reader.EndOfList do ConvertProperty;
    Reader.ReadListEnd;
    Writer.WriteListEnd;
    while not Reader.EndOfList do ConvertObject;
    Reader.ReadListEnd;
    Writer.WriteListEnd;
  end;

begin
   //only resourcetype RCData
   //all forms begin with TFilerSignature signature TPF0 (Turbo-Pascal-Filer)
  if not (entry.resourceType = rtRCData) then exit;
  if not comparemem( entry.data.memory, pchar('TPF0'), 4 ) then exit;

  //input
  //copy entry.data to read from orginal-resource
  entry.data.position := 0;
  Input := TMemoryStream.Create;
  Input.LoadFromStream(entry.data);
  Input.Position := 0;
  Reader              := TReader.Create(Input, 4096);

  //output
  entry.data.clear;
  Writer              := TMyWriter.Create(entry.data, 4096);

  SaveSeparator       := DecimalSeparator;
  DecimalSeparator    := '.';
  try
      Reader.ReadSignature;
      Writer.WriteSignature;
      ConvertObject;
  finally
    DecimalSeparator := SaveSeparator;
    Reader.Free;
    Writer.Free;
    Input.Free;
  end;
end;


end.
