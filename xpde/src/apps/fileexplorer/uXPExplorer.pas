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
unit uXPExplorer;

interface

uses
    uExplorerAPI, QGraphics, QImgList ,
    Classes, uProgressDlg, QForms;

type
    TXPExplorer=class(TInterfacedObject, IXPExplorer)
    private
        roots: TInterfaceList;
        images: TImageList;
        clipboard: TStringList;
    public
        function ClipboardEmpty:boolean;
        function getClipboard:TStringList;
        procedure clearclipboard;
        procedure copytoclipboard(const item:string); overload;
        procedure copytoclipboard(const items:TStrings); overload;
        function createNewProgressDlg(const title:string):TForm;
        procedure updateProgressDlg(const dialog:TForm; const progress: integer; const max: integer; const str: string; const status: string; const eta:string);
        function registerImage(const bmp: TBitmap):integer;
        procedure registerRootItem(item:IXPVirtualFile);
        function getImageList: TImageList;
        function getRootItems: TInterfaceList;
        constructor Create;
        destructor Destroy;override;
    end;

implementation

uses
    main;

{ TXPExplorer }

procedure TXPExplorer.clearclipboard;
begin
    clipboard.clear;
end;

procedure TXPExplorer.copytoclipboard(const item: string);
begin
    clearclipboard;
    clipboard.add(item);
end;

function TXPExplorer.ClipboardEmpty: boolean;
begin
    result:=(clipboard.count=0);
end;

procedure TXPExplorer.copytoclipboard(const items: TStrings);
begin
    clearclipboard;
    clipboard.addstrings(items);
end;

constructor TXPExplorer.Create;
begin
    roots:=TInterfaceList.create;
    images:=TImageList.create(nil);
    clipboard:=TStringList.create;
end;

destructor TXPExplorer.Destroy;
begin
    clipboard.free;
    images.free;
    roots.free;
    inherited;
end;

function TXPExplorer.getClipboard: TStringList;
begin
    result:=clipboard;
end;

function TXPExplorer.getImageList: TImageList;
begin
    result:=images;
end;

function TXPExplorer.getRootItems: TInterfaceList;
begin
    result:=roots;
end;

function TXPExplorer.registerImage(const bmp: TBitmap): integer;
begin
    result:=images.Add(bmp,nil);
end;

procedure TXPExplorer.registerRootItem(item: IXPVirtualFile);
begin
    roots.add(item);    
end;

function TXPExplorer.createNewProgressDlg(const title: string): TForm;
begin
    result:=TProgressDlg.create(application);
    result.caption:=title;
end;

procedure TXPExplorer.updateProgressDlg(const dialog: TForm;
  const progress, max: integer; const str, status, eta: string);
begin
    (dialog as TProgressDlg).updateDialog(progress,max,str,status,eta);
end;

initialization
    XPExplorer:=TXPExplorer.create;

end.
