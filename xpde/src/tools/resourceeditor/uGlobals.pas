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

unit uGlobals;

interface

var
 g_strResbind : string = '/opt/kylix3/bin/resbind----';

function striplocale(const str:string):string;
function StartApp(name: string; arguments: array of string;waitfor:boolean=false): Integer;

implementation

uses
  libc, QForms;

function striplocale(const str:string):string;
var
  k:integer;
begin
  result:='';
  k:=pos('[',str);
  if k<>0 then begin
     result:=copy(str,k+1,length(str));
     k:=pos(']',result);
     if k<>0 then begin
           result:=copy(result,1,k-1);
     end;
  end;
end;

function StartApp(name: string; arguments: array of string;waitfor:boolean=false): Integer;
var
  pid: PID_T;
  Max: Integer;
  I: Integer;
  parg: PPCharArray;
  argnum: Integer;

begin
  Result := -1;

  pid := fork;

  if pid = 0 then
  begin
    Max := sysconf(_SC_OPEN_MAX);
    for i := (STDERR_FILENO+1) to Max do
    begin
      fcntl(i, F_SETFD, FD_CLOEXEC);
    end;

    argnum := High(Arguments) + 1;

    GetMem(parg,(2 + argnum) * sizeof(PChar));
    parg[0] := PChar(Name);

    i := 0;
    while i <= high(arguments) do
    begin
      inc(i);
      parg[i] := PChar(arguments[i-1]);
    end;

    parg[i+1] := nil;
    execvp(PChar(name),PPChar(@parg[0]));
    halt;
  end;

  if pid > 0 then
  begin
    if waitfor then begin
        result:=-1;
        while (result=-1)  do begin
            application.processmessages;
            waitpid(pid,@Result,wnohang);
        end;
    end;
  end;
end;


end.
