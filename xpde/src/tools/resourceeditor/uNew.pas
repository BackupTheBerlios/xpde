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

unit uNew;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QButtons, Libc;


type
  TNewTranslationDlg = class(TForm)
    Label1: TLabel;
    edExe: TEdit;
    Label2: TLabel;
    cbLocales: TComboBox;
    Label3: TLabel;
    edResbind: TEdit;
    btnOK: TButton;
    meOperations: TMemo;
    sbExe: TSpeedButton;
    sbResbind: TSpeedButton;
    OpenExe: TOpenDialog;
    OpenResbind: TOpenDialog;
    btnCancel: TButton;
    procedure edExeChange(Sender: TObject);
    procedure cbLocalesChange(Sender: TObject);
    procedure sbResbindClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbExeClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edResbindChange(Sender: TObject);
  private
    { Private declarations }
    m_strResourceFile : string;
  public
    { Public declarations }
    procedure updateOperations;
    property ResourceFileName : string read m_strResourceFile;
  end;

var
  NewTranslationDlg: TNewTranslationDlg;

implementation

{$R *.xfm}

uses
  uGlobals;

{ TNewTranslationDlg }

procedure TNewTranslationDlg.FormShow(Sender: TObject);
begin
    edResbind.Text := g_strResbind;
    updateOperations;
end;

procedure TNewTranslationDlg.updateOperations;
var
    source: string;
    sharedresources: string;
    locale:string;
    strResbind : string;
begin
    source        := edExe.Text;
    locale        := striplocale(cbLocales.Text);
    strResbind    := edResbind.Text;
    btnOK.enabled := false;
    meOperations.lines.beginupdate;
    try
        meOperations.lines.clear;
        if (locale<>'') and (source<>'') and (strResbind<>'') then begin
            m_strResourceFile := ChangeFileExt(source,'.'+locale+'.res');
            sharedresources:=ChangeFileExt(source,'.'+locale);
            meOperations.Lines.add(format('Source-Executable: %s',[source]));
            meOperations.Lines.add(format('Resource-File: %s',[m_strresourcefile]));
            meOperations.Lines.add('');

            meOperations.Lines.add(format('%s %s -r %s',[strresbind, source, m_strresourcefile]));
            btnOK.enabled := fileexists(strresbind) and fileexists(source);
        end;
    finally
        meOperations.lines.endupdate;
    end;
end;

procedure TNewTranslationDlg.edExeChange(Sender: TObject);
begin
    updateOperations;
end;

procedure TNewTranslationDlg.cbLocalesChange(Sender: TObject);
begin
    updateOperations;
end;

procedure TNewTranslationDlg.edResbindChange(Sender: TObject);
begin
    updateOperations;
end;

procedure TNewTranslationDlg.sbResbindClick(Sender: TObject);
begin
    if openresbind.Execute then begin
      edResbind.Text := openresbind.FileName;
      updateOperations;
    end;
end;

procedure TNewTranslationDlg.sbExeClick(Sender: TObject);
begin
    if openExe.Execute then begin
      edExe.text := openexe.FileName;
      updateOperations;
    end;
end;

procedure TNewTranslationDlg.btnOKClick(Sender: TObject);
begin
    g_strResbind := edResbind.Text;
//    if xpapi.ShellExecute(strresbind+' '+edexe.text+' -r '+m_strResourceFile, true) <> 0 then
    if startapp(g_strresbind, [edexe.text, '-r', m_strResourceFile], true) <> 0 then
       raise Exception.Create('Error in executing resbind!');
end;

end.
