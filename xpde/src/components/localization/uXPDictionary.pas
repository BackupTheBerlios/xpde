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

unit uXPDictionary;

interface

uses Classes, SysUtils, QForms, uRegistry, QDialogs;

type
    TXPDictionary=class(TComponent)
    private
        values:TStringList;
        hints:TStringList;
    FActive: boolean;
    procedure SetActive(const Value: boolean);
    public
        strings:TStringList;
        procedure loaded;override;
        procedure loadfromfile(const filename:string);
        procedure savetofile(const filename:string);
        procedure addstring(const str,hint:string);
        function Translate(const str:string):string;
        constructor Create(AOwner:TComponent);override;
        destructor Destroy;override;
    published
        property Active:boolean read FActive write SetActive;
    end;

implementation

{ TXPDictionary }

procedure TXPDictionary.addstring(const str, hint: string);
begin
    if (trim(str)<>'') then begin
        if strings.indexof(str)=-1 then begin
            strings.add(str);
            values.add(str);
            hints.add(hint);
        end;
    end;
end;

constructor TXPDictionary.Create(AOwner: TComponent);
begin
  inherited;
  FActive:=false;
  strings:=TStringList.create;
  values:=TStringList.create;
  hints:=TStringList.create;
end;

destructor TXPDictionary.Destroy;
begin
    hints.free;
    values.free;    
    strings.free;
    inherited;
end;

procedure TXPDictionary.loaded;
var
    language: string;
    rlang:string;
    reg: TRegistry;
begin
  inherited;
  if not (csDesigning in ComponentState) then begin
      if FActive then begin
        language:='english';
        reg:=TRegistry.create;
        try
            if reg.OpenKey('Software/XPde/Desktop/Regional Settings',true) then begin
                rlang:=reg.ReadString('Language');
                if (rlang='') then begin
                    reg.WriteString('Language',language);
                end
                else language:=rlang;
            end;
        finally
            reg.free;
        end;
        loadfromfile(changefileext(application.exename,'.'+language));
      end;
  end;
end;

procedure TXPDictionary.loadfromfile(const filename: string);
var
    f: TStringList;
    i:integer;
    line:string;
    k:integer;
    str,val,hin: string;
begin
    if fileexists(filename) then begin
        strings.Clear;
        values.clear;
        hints.clear;
        f:=TStringList.create;
        try
            f.loadfromfile(filename);
            for i:=0 to f.count-1 do begin
                line:=f[i];
                k:=pos('=',line);
                str:='';
                val:='';
                hin:='';
                if k<>0 then begin
                    str:=copy(line,1,k-1);
                    val:=trim(copy(line,k+1,length(line)));
                    k:=pos('#',val);
                    if k<>0 then begin
                        hin:=copy(val,k+1,length(val));
                        val:=trim(copy(val,1,k-1));
                    end;
                    strings.add(str);
                    values.add(val);
                    hints.add(hin);
                end;
            end;
        finally
            f.free;
        end;
    end
    else begin
        showmessage('Dictionary '+filename+' not found');
    end;
end;

procedure TXPDictionary.savetofile(const filename: string);
var
    i:longint;
    line:string;
    f: TStringList;
begin
    f:=TStringList.create;
    try
        for i:=0 to strings.count-1 do begin
            line:=strings[i]+'='+values[i];
            line:=line+stringofchar(' ',500-length(line))+'#'+hints[i];
            f.add(line);
        end;
        f.savetofile(filename);
    finally
        f.free;
    end;
end;

procedure TXPDictionary.SetActive(const Value: boolean);
begin
    if FActive<>Value then begin
          FActive := Value;
    end;
end;

function TXPDictionary.Translate(const str: string): string;
var
    k:integer;
begin
    if trim(str)<>'' then begin
        result:=str;
        k:=strings.indexof(str);
        if k<>-1 then begin
            result:=values[k];
        end;
    end;
end;

end.
