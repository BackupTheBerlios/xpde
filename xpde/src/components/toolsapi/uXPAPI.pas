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
// This unit specified the interface to the API it's available to every part of the desktop
unit uXPAPI;



interface

uses Classes, QExtCtrls, QForms,
     SysUtils, QGraphics, Types, Qt,
     XLib;

type
    //System Info
    TSysInfo=(
    siUserDir,                                                                  //User directory
    siUsername,                                                                 //User name
    siAppDir,                                                                   //Where the executable resides
    siDesktopDir,                                                               //User desktop directory
    siThemesDir,                                                                //Themes directory
    siCurrentThemeDir,                                                          //Current theme directory
    siFileTypesDir,                                                             //File types directory
    siSystemDir,                                                                //System icons directory
    siApplicationsDir);                                                         //Application icons directory

    IWMClient=interface
    ['{8225D62E-CEE8-D611-927C-000244219999}']
        function getWindow: TWindow;
        function getTitle: string;
        function getIcon: TBitmap;
        procedure setWindow(value:TWindow);
        procedure setTitle(value:string);
        procedure setIcon(value:TBitmap);
        procedure close;
        procedure maximize;
        procedure show;
        procedure bringtofront;
    end;

    IWMFrame=interface
    ['{ACBEF30D-B7EA-D611-9252-000244219999}']
    end;

    IXPDesktop=interface
    ['{BCE03A86-A6E6-D611-9051-000244219999}']
        procedure customize;
        procedure applychanges;
        procedure addDebugMessage(const msg:string);
        function GetClientArea:TRect;
    end;

    IXPWindowManager=interface
    ['{12C4C48B-A6E6-D611-9051-000244219999}']
        procedure setup;
    end;

    IXPTaskBar=interface
    ['{7E36AA90-A6E6-D611-9051-000244219999}']
        procedure addtask(task:IWMClient);
        procedure removetask(task:IWMClient);
    end;

    //XP API interface
    IXPAPI=interface
    ['{6681BE0D-8BDE-D611-9A9F-000244219999}']
        procedure checkcpuload;                                                 //Sets the hourglass cursor until cpu load decreases
        procedure setDefaultCursor;                                             //Sets the default cursor
        procedure setWaitCursor;                                                //Sets the hourglass cursor
        procedure storeExecutable(ext:string;executable:string);                //Associates an executable to a document
        procedure ShellDocument(const document:string);                         //Executes a document
        function setCursor(bmp:TBitmap):QCursorH;                               //Sets the desktop cursor
        function getExecutable(ext:string):string;                              //Returns the executable (if any) associated with a document
        function ShellExecute(const prog:string;waitfor:boolean):integer;       //Executes a program
        function getSysInfo(const info: TSysInfo):string;                       //Return system information
        procedure OutputDebugString(const str:string);
    end;

var
    XPAPI:IXPAPI=nil;                                                           //Global API variable
    XPDesktop:IXPDesktop=nil;                                                   //Global Desktop variable
    XPWindowManager:IXPWindowManager=nil;                                       //Global WindowManager variable
    XPTaskBar:IXPTaskBar=nil;                                                   //Global TaskBar variable

implementation

end.
