{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003 Theo Lustenberger                                        }
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

unit uPrinterInfo;

interface

uses Classes;
type
  TQueueType = (pqtLOCAL, pqtLPD, pqtSMB, pqtNCP, pqtJETDIRECT);
const
  LPC_PRINTER = 0;
  LPC_PRINTING = 1;
  LPC_SPOOLING = 2;
type
  TPrinterInfo = class
    Name: string;
    Alias: string;
    LP: string;
    RP: string;
    SD: string;
    RM: string;
  end;
function GetLPCStatus(Printer: string; Value: integer): Boolean;
procedure ReadPrintCap(PrcInfo: TStrings);
function GetPRCValue(Item, S: string): string;
implementation
uses LibC, Types, Sysutils, QDialogs;

function GetCommandOutputEx(Command: string): string;
var
  Output: PIOFile;
  line: PChar;
  txt: string;
  str: string;
  StrLst: TStringList;
  rb: integer;
const
  BufferSize: Integer = 1000;
begin
  SetLength(txt, 0);
  Output := popen(Pchar(Command), 'r');
  StrLst := TStringList.Create;
  GetMem(Line, BufferSize);
  if Assigned(output) then
  begin
    while FEOF(Output) = 0 do
    begin
      rb := libc.fread(line, 1, BufferSize, output);
      SetLength(Txt, length(txt) + rb);
      MemCpy(@txt[length(txt) - (rb - 1)], line, rb);
      while pos(#10, txt) > 0 do
      begin
        str := copy(txt, 1, pos(#10, txt) - 1);
        StrLst.Add(str);
        txt := copy(txt, pos(#10, txt) + 1, length(txt));
      end;
    end;
  end;
  Result := StrLst.text;
  StrLst.Free;
  libc.pclose(output);
  wait(nil);
  FreeMem(Line, BufferSize);
end;



function GetLPCStatus(Printer: string; Value: integer): Boolean;
var Mesg: TStrings;
var Det: TStrings;
  i: integer;
//Someone tell me a better way to find printer status...
begin
  Result := false;
  Mesg := TStringList.create;
  Det := TStringList.create;
  Mesg.text := (GetCommandOutputEx('lpc status'));
  for i := 0 to Mesg.count - 1 do
  begin
    Det.CommaText := mesg[i];
    if Pos(Printer, Det[LPC_PRINTER]) > 0 then if Det[Value] = 'enabled' then Result := true;
  end;
  Det.free;
  Mesg.free;
end;

function GetPRCValue(Item, S: string): string;
begin
  if Pos(':' + Item + '=', S) = 1 then
    Result := Copy(S, Length(Item) + 3, Length(S) - Length(Item) - 4) else
    Result := '';
end;


{
NO WORK: NO rights on the spool dir.
procedure GetCnfData(TmpPrinterInfo:TPrinterInfo);
var mfList:TStrings;
begin
if FileExists(TmpPrinterInfo.SD+'/mf.cfg') then
begin
 mfList:=TStringList.create;
 mfList.LoadFromFile(TmpPrinterInfo.SD+'/mf.cfg');
 ShowMessage(mfList.text);
 mfList.free;
end else ShowMessage('not found'+TmpPrinterInfo.SD+'/mf.cfg');
end; }

procedure ReadPrintCap(PrcInfo: TStrings);
var CapList: TStrings;
  Aline, Res: string;
  i, ui, alipos: integer;
  TmpPrinterInfo: TPrinterInfo;
begin
  TmpPrinterInfo := nil;
  CapList := TStringList.create;
  CapList.LoadFromFile('/etc/printcap');
  i := 0;
  while i < CapList.count do
  begin
    ALine := Trim(CapList[i]);
    if (Length(ALine) > 0) and (ALine[1] <> ':') and (ALine[1] <> '|') and (ALine[1] <> '#') then
    begin
 //if Assigned(TmpPrinterInfo) then GetCnfData(TmpPrinterInfo);
      TmpPrinterInfo := TPrinterInfo.create;
      Aline := Copy(Aline, 1, Length(Aline) - 2);
      alipos := Pos('|', Aline);
      if alipos > 0 then
      begin
        TmpPrinterInfo.Alias := Copy(Aline, alipos + 1, Length(Aline));
        Aline := Copy(Aline, 1, alipos - 1);
      end;
      TmpPrinterInfo.Name := Aline;
      PrcInfo.addObject(Aline, TmpPrinterInfo);
    end else
    begin
      if Assigned(TmpPrinterInfo) then
      begin
        Res := GetPRCValue('lp', Aline);
        if Res <> '' then TmpPrinterInfo.LP := Res;
        Res := GetPRCValue('rp', Aline);
        if Res <> '' then TmpPrinterInfo.RP := Res;
        Res := GetPRCValue('sd', Aline);
        if Res <> '' then TmpPrinterInfo.SD := Res;
        Res := GetPRCValue('rm', Aline);
        if Res <> '' then TmpPrinterInfo.RM := Res;
      end;
    end;
    inc(i);
  end;
  CapList.free;
end;
end.
