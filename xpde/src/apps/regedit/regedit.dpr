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

program regedit;

uses
  QForms,
  QDialogs,
  uXPStyle,
  Main in 'Main.pas' {Form1},
  uFileFinder in 'uFileFinder.pas',
  SearchForm in 'SearchForm.pas' {FSearchForm},
  EdDword in 'EdDword.pas',
  EdString in 'EdString.pas',
  EdBin in 'EdBin.pas',
  Sysutils,
  uRegistry,
  HexEd in 'HexEd.pas';

{$R *.res}

var Reg:TRegistry;

begin
  if ParamCount=0 then
  begin
  Application.Initialize;
  SetXPStyle(Application);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFSearchForm, FSearchForm);
  Application.CreateForm(TEdDword1, EdDword1);
  Application.CreateForm(TFrmEditString, FrmEditString);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
  end else
  begin
    if ExtractFileExt(ParamStr(1))='.reg' then
    begin
      SetXPStyle(Application);
      if MessageDlg('Regedit','Would you like to add the information in '+ParamStr(1)+' to the registry?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = 3 then
      begin
      Reg:=TRegistry.create;
      if Reg.ImportRegData(ParamStr(1)) then
      MessageDlg('Regedit','The Information in '+ParamStr(1)+' has been added to the registry', mtInformation, [mbOK], 0, mbOK);
      Reg.Free;
      end;
    end;
  end;
end.

