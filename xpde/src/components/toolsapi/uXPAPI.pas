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
// This unit specifies the interface to the API it's available to every part of the desktop
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
    siMyDocuments,                                                              //User Documents
    siControlPanel,                                                             //Control Panel
    siMiscDir,                                                                  //User Documents
    siAppDir,                                                                   //Where the executable resides
    siAppsDir,                                                                  //Where the apps reside    
    siAppletsDir,                                                               //Where the applets reside
    siDesktopDir,                                                               //User desktop directory
    siThemesDir,                                                                //Themes directory
    siCurrentThemeDir,                                                          //Current theme directory
    siFileTypesDir,                                                             //File types directory
    siSystemDir,                                                                //System icons directory
    siSmallSystemDir,                                                           //Small system icons directory
    siMediumSystemDir,                                                          //Small system icons directory
    siApplicationsDir,                                                          //Application icons directory
    siNetworkDir,                                                               //Network directory
    siTempDir);                                                                 //Temp files directory

    IWMClient=interface
    ['{8225D62E-CEE8-D611-927C-000244219999}']
        procedure focus;
        procedure minimize;
        procedure maximize;
        procedure beginresize;
        procedure endresize;        
        procedure restore;
        procedure close;
        procedure map;
        procedure bringtofront;
        procedure updateactivestate;
        function isactive:boolean;
        procedure activate(restore:boolean=true);
        function getTitle: widestring;
        function getBitmap: TBitmap;
        function getWindow: Window;
    end;

    IWMFrame=interface
    ['{ACBEF30D-B7EA-D611-9252-000244219999}']
    end;

    TXPDesktopCustomize=procedure;

    IXPDesktop=interface
    ['{BCE03A86-A6E6-D611-9051-000244219999}']
        procedure registerCustomizeProcedure(const proc: TXPDesktopCustomize);
        procedure customize;
        procedure applychanges;
        procedure addDebugMessage(const msg:string);
        function GetClientArea:TRect;
    end;

    IXPTaskBar=interface
    ['{7E36AA90-A6E6-D611-9051-000244219999}']
        procedure updatetask(const task:IWMClient);
        procedure addtask(const task:IWMClient);
        procedure activatetask(const task:IWMClient);
        procedure removetask(const task:IWMClient);
        function getRect:TRect;
        procedure bringtofront;
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
        function ReplaceSystemPaths(const path:string):string;
        procedure showAboutDlg(const programname:string);
        function getVersionString:string;              
        procedure OutputDebugString(const str:string);
    end;

var
    XPAPI:IXPAPI=nil;                                                           //Global API variable
    XPDesktop:IXPDesktop=nil;                                                   //Global Desktop variable
    XPTaskBar:IXPTaskBar=nil;                                                   //Global TaskBar variable

function listtostr(const str:string):string;

implementation

function listtostr(const str:string):string;
var
    k:integer;
    i: integer;
begin
    result:=str;
    k:=pos(#27,result);
    while (k<>0) do begin
        i:=pos(#2,result);
        Delete(result,k,i-k+1);
        k:=pos(#27,result);
    end;
end;

end.
