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

program ResourceEditor;

uses
  QForms,
  uXPStyle,
  main in 'main.pas' {MainForm},
  uResources in 'uResources.pas',
  uResourceFileFrm in 'uResourceFileFrm.pas' {ResourceFileFrm},
  uResourceAPI in 'uResourceAPI.pas',
  uStringEditor in 'uStringEditor.pas' {StringEditor},
  uFormEditor in 'uFormEditor.pas',
  uNew in 'uNew.pas' {NewTranslationDlg},
  uGlobals in 'uGlobals.pas',
  uGenerateSharedRes in 'uGenerateSharedRes.pas' {GenerateSharedResourcesDlg},
  uAboutDialog in 'uAboutDialog.pas' {AboutDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutDlg, AboutDlg);
  Application.Run;
end.
