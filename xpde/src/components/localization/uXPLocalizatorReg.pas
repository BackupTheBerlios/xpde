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

unit uXPLocalizatorReg;

interface

uses uXPDictionary, uXPLocalizator, uXPLocalizationDlg,
     TypInfo, DesignEditors, DesignIntf,
     QControls, QDialogs, Classes,
     SysUtils;

type
    TXPDictionaryEditor=class(TComponentEditor)
    public
        procedure Edit; override;
        procedure ExecuteVerb(Index: Integer); override;
        function GetVerb(Index: Integer): string; override;
        function GetVerbCount: Integer; override;
    end;

    TXPLocalizatorEditor=class(TComponentEditor)
    public
        procedure Edit; override;
        procedure ExecuteVerb(Index: Integer); override;
        function GetVerb(Index: Integer): string; override;
        function GetVerbCount: Integer; override;
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('XPde',[TXPDictionary]);
    RegisterComponentEditor(TXPDictionary, TXPDictionaryEditor);

    RegisterComponents('XPde',[TXPLocalizator]);
    RegisterComponentEditor(TXPLocalizator, TXPLocalizatorEditor);
end;

{ TXPDictionaryEditor }

procedure TXPDictionaryEditor.Edit;
var
    sp: TSaveDialog;
    dc: TXPDictionary;
begin
    sp:=TSaveDialog.create(nil);
    try
        if sp.Execute then begin
            dc:=(component as TXPDictionary);
            dc.savetofile(sp.FileName);
        end;
    finally
        sp.free;
    end;
end;

procedure TXPDictionaryEditor.ExecuteVerb(Index: Integer);
var
    op: TOpenDialog;
    dc: TXPDictionary;
begin
    case index of
        0: begin
            edit;
        end;
        1: begin
            op:=TOpenDialog.create(nil);
            try
                if op.Execute then begin
                    dc:=(component as TXPDictionary);
                    dc.loadfromfile(op.FileName);
                end;
            finally
                op.free;
            end;
        end;
    end;
end;

function TXPDictionaryEditor.GetVerb(Index: Integer): string;
begin
    case index of
        0: result:='Save dictionary to file...';
        1: result:='Load dictionary from file...';
    end;
end;

function TXPDictionaryEditor.GetVerbCount: Integer;
begin
    result:=2;
end;

{ TXPLocalizatorEditor }

procedure TXPLocalizatorEditor.Edit;
var
    dc: TXPDictionary;
    lc: TXPLocalizator;
    i:integer;
begin
    lc:=(component as TXPLocalizator);
    dc:=lc.Dictionary;
    if assigned(dc) then begin
        with TXPLocalizationDlg.create(nil) do begin
            try
                lc.EnumerateForm;
                sgStrings.rowcount:=lc.strings.count;
                sgStrings.Cols[0].assign(lc.strings);
                sgStrings.Cols[1].assign(lc.strings);
                sgStrings.Cols[2].assign(lc.hints);
                if showmodal=mrOk then begin
                    for i:=0 to lc.strings.count-1 do begin
                        dc.addstring(lc.strings[i],lc.hints[i]);
                    end;
                    showmessage(inttostr(dc.strings.count));
                end;
            finally
                free;
            end;
        end;
    end
    else begin
        showmessage('You must set the Dictionary property!');
    end;
end;

procedure TXPLocalizatorEditor.ExecuteVerb(Index: Integer);
begin
  edit;
end;

function TXPLocalizatorEditor.GetVerb(Index: Integer): string;
begin
    result:='Get this form strings...';
end;

function TXPLocalizatorEditor.GetVerbCount: Integer;
begin
    result:=1;
end;

end.
