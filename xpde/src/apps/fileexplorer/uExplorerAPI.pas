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
unit uExplorerAPI;

interface

uses
    Classes, QGraphics, QImgList,
    QForms;

type
    IXPVirtualFile=interface
    ['{58DC80AF-0C3D-D711-9EF1-0002443C1C5D}']
        function hasChild: boolean;
        function getChildren: TInterfaceList;
        function getDisplayName: string;
        procedure getColumns(const columns:TStrings);
        procedure setNode(node:TObject);
        function getNode:TObject; 
        procedure getColumnData(const columns:TStrings);
        procedure doubleClick;
        function getUniqueID:string;
        procedure getStatusData(const status:TStrings);
        procedure getVerbItems(const verbs:TStrings);
        procedure executeVerb(const verb:integer);
        function getIcon: integer;
        function getCategory: string;
    end;

    {
    IXPVirtualFileSystem=interface
        procedure getFiles(const alist: TInterfaceList);                        //Get files from the current location
        procedure changeDir
    end;
    }

    IXPExplorer=interface
        procedure registerRootItem(item:IXPVirtualFile);
        function registerImage(const bmp: TBitmap):integer;
        function getRootItems: TInterfaceList;
        function getImageList: TImageList;
        function getClipboard:TStringList;
        function ClipboardEmpty:boolean;
        procedure clearclipboard;
        procedure copytoclipboard(const item:string); overload;
        procedure copytoclipboard(const items:TStrings); overload;
        function createNewProgressDlg(const title:string):TForm;
    end;

var
    XPExplorer: IXPExplorer=nil;    

implementation

end.
