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

unit uGenerateSharedRes;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QButtons;

type
  TGenerateSharedResourcesDlg = class(TForm)
    sbExe: TSpeedButton;
    sbResbind: TSpeedButton;
    Label1: TLabel;
    edExe: TEdit;
    Label2: TLabel;
    cbLocales: TComboBox;
    Label3: TLabel;
    edResbind: TEdit;
    btnOK: TButton;
    meOperations: TMemo;
    btnCancel: TButton;
    OpenExe: TOpenDialog;
    OpenResbind: TOpenDialog;
    Label4: TLabel;
    edResFile: TEdit;
    sbResFile: TSpeedButton;
    OpenResFile: TOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbExeClick(Sender: TObject);
    procedure sbResbindClick(Sender: TObject);
    procedure edResbindChange(Sender: TObject);
    procedure cbLocalesChange(Sender: TObject);
    procedure edResFileChange(Sender: TObject);
    procedure edExeChange(Sender: TObject);
    procedure sbResFileClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private-Deklarationen }
    m_strSharedresources : string;
    procedure updateOperations;
  public
    { Public-Deklarationen }
  end;

var
  GenerateSharedResourcesDlg: TGenerateSharedResourcesDlg;

implementation

{$R *.xfm}

uses
  uGlobals;

procedure TGenerateSharedResourcesDlg.FormShow(Sender: TObject);
var
  str : string;
  i : integer;
begin
   str := edResFile.text;
   str := changeFileExt(str,'');
   for i := 0 to cbLocales.Items.count-1 do begin
     if '.'+striplocale(cbLocales.Items[i]) = extractfileext(str) then begin
       cbLocales.Itemindex := i;
       break;
     end;
   end;
   str := changeFileExt(str,'');
   edExe.text := str;
   edResbind.Text := g_strResbind;
   updateOperations;
end;

procedure TGenerateSharedResourcesDlg.FormDestroy(Sender: TObject);
begin
;
end;

procedure TGenerateSharedResourcesDlg.updateOperations;
var
    source: string;
    sharedresources: string;
    locale:string;
    strResbind : string;
    strResourceFile : string;
begin
    strResourceFile := edResFile.text;
    source          := edExe.Text;
    locale          := striplocale(cbLocales.Text);
    strResbind      := edResbind.Text;
    btnOK.enabled   := false;
    meOperations.lines.beginupdate;
    try
        meOperations.lines.clear;
        if (strresourceFile<>'') and (locale<>'') and (source<>'') and (strResbind<>'') then begin
            m_strSharedresources := ChangeFileExt(source,'.'+locale);
            meOperations.Lines.add(format('Source-Executable: %s',[source]));
            meOperations.Lines.add(format('Resource-File: %s',[strresourcefile]));
            meOperations.Lines.add(format('Shared resources: %s',[sharedresources]));
            meOperations.Lines.add('');

            meOperations.Lines.add(format('%s -s %s %s %s',[strresbind, sharedresources, source, strresourcefile]));
            btnOK.enabled := fileexists(strresbind) and fileexists(source) and fileexists(strResourceFile);
        end;
    finally
        meOperations.lines.endupdate;
    end;
end;

procedure TGenerateSharedResourcesDlg.sbExeClick(Sender: TObject);
begin
    openExe.InitialDir := extractFilePath(edResFile.Text);
    if openExe.Execute then begin
      edExe.text := openexe.FileName;
      updateOperations;
    end;
end;

procedure TGenerateSharedResourcesDlg.sbResbindClick(Sender: TObject);
begin
    if openresbind.Execute then begin
      edResbind.Text := openresbind.FileName;
      updateOperations;
    end;
end;

procedure TGenerateSharedResourcesDlg.sbResFileClick(Sender: TObject);
begin
    if openresbind.Execute then begin
      edResFile.Text := openresFile.FileName;
      updateOperations;
    end;
end;

procedure TGenerateSharedResourcesDlg.edResbindChange(Sender: TObject);
begin
   updateOperations;
end;

procedure TGenerateSharedResourcesDlg.cbLocalesChange(Sender: TObject);
begin
   updateOperations;
end;

procedure TGenerateSharedResourcesDlg.edResFileChange(Sender: TObject);
begin
   updateOperations;
end;

procedure TGenerateSharedResourcesDlg.edExeChange(Sender: TObject);
begin
   updateOperations;
end;

procedure TGenerateSharedResourcesDlg.btnOKClick(Sender: TObject);
begin
    g_strResbind := edResbind.Text;
    if startapp(g_strresbind, ['-s', m_strSharedresources, edExe.text, edresFile.text], true) <> 0 then
       raise Exception.Create('Error in executing resbind!');
end;

end.
