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
    IXPVirtualFile=interface;

    { TODO : This will be removed as soon as cut/copy/paste operations are fully functional }
    TXPChildrenOperation=(coAdd, coRemove);
    TXPChildrenModified=procedure(const sender: IXPVirtualFile; const op: TXPChildrenOperation; const item: IXPVirtualFile) of object;

    IXPVirtualFile=interface
    ['{58DC80AF-0C3D-D711-9EF1-0002443C1C5D}']
        function hasChild: boolean;                                             //Must return if the item has children as fast as possible
        function getChildren: TInterfaceList;                                   //Must return a list of children encapsulated on IXPVirtualFile
        function getDisplayName: string;                                        //Must return the name to display for that item
        procedure getColumnHeaders(const columns:TStrings);                     //Must return the caption of the headers for that item
        procedure getColumnData(const columns:TStrings);                        //Must return the data for each column
        procedure setNode(node:TObject);                                        //Must store the node
        function getNode:TObject;                                               //Must return the node
        procedure doubleClick;                                                  //Must execute a double click over the item
        function getUniqueID:string;                                            //Must return an uniqueID for the item (i.e. /home/foo/bar.txt ; smb://computer/share/file.txt)
        { TODO : Improve these functions to make locate items easier and faster }
        { TODO : Change the names }
        function locationExists(const location:string):boolean;
        procedure stripLocation(const location:string;pieces:TStrings);

        procedure getStatusData(const status:TStrings);                         //Must return the status zones for the statusbar
        procedure getVerbItems(const verbs:TStrings);                           //Must return the caption for the menu items for the properties menu
        procedure executeVerb(const verb:integer);                              //Must execute the action attached to the item

        procedure setChildrenModified(value: TXPChildrenModified);              //Will be removed, right now it's used to be informed about children changes

        function getIcon: integer;                                              //Must return the icon image number stored on the global IXPExplorer imagelist
        function getCategory: string;                                           //Must return the category, to allow categories on the listview
    end;

    IXPExplorer=interface
        procedure registerRootItem(item:IXPVirtualFile);                        //Registers a root item
        { TODO : Change TBitmap for TGraphic }
        function registerImage(const bmp: TBitmap):integer;                     //Register an image on the global imagelist and return the position
        { TODO : Provide a system to unregister images, not position based? }
        function getRootItems: TInterfaceList;

        function getImageList: TImageList;                                      //Returns the global imagelist
        { TODO : Change this to be a list of interfaces, not a list of uniqueIDs }
        function getClipboard:TStringList;                                      //Returns the items on the clipboard
        procedure clearclipboard;                                               //Clears the clipboard
        //Clipboard functions, must change
        procedure copycurrentselectiontoclipboard;
//        procedure copytoclipboard(const item:string); overload;
        procedure copytoclipboard(const item:IXPVirtualFile);
//        procedure copytoclipboard(const items:TStrings); overload;
        function ClipboardEmpty:boolean;                                        //Returns true if the clipboard is empty
        function getcurrentpath:string;                                         //Returns the current path using the getUniqueID of the selected folder
        function createNewProgressDlg(const title:string):TForm;                //Creates a progressdlg
        procedure updateProgressDlg(const dialog:TForm; const progress: integer; const max: integer; const str: string; const status:string; const eta:string); //Updates a progressDlg
    end;

var
    XPExplorer: IXPExplorer=nil;                                                //Global explorer var    

implementation

end.
