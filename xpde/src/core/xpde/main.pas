{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 Jos� Le�n Serna <ttm@xpde.com>                           }
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
unit main;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QMenus, uXPPopupMenu,
  QExtCtrls,uSysListView, uSysListItem,
  uXPAPI, uXPStyleConsts, uRegistry, uXPAPI_imp,
  uLNKFile, uCreateShortcut,
  uLNKProperties, Qt, uXPDictionary, uXPLocalizator, uXPStyle;

type
  TMainForm = class(TForm)
    deskpopup: TXPPopupMenu;
    ArrangeIconsBy1: TMenuItem;
    Name1: TMenuItem;
    Size1: TMenuItem;
    Type1: TMenuItem;
    Modified1: TMenuItem;
    N4: TMenuItem;
    ShowinGroups1: TMenuItem;
    AutoArrange1: TMenuItem;
    AligntoGrid1: TMenuItem;
    N5: TMenuItem;
    ShowDesktopIcons1: TMenuItem;
    LockWebItemsonDesktop1: TMenuItem;
    RunDesktopCleanupWizard1: TMenuItem;
    Refresh1: TMenuItem;
    N1: TMenuItem;
    Paste1: TMenuItem;
    PasteShortcut1: TMenuItem;
    N2: TMenuItem;
    New1: TMenuItem;
    Folder1: TMenuItem;
    Shortcut1: TMenuItem;
    N3: TMenuItem;
    Properties1: TMenuItem;
    itempopup: TXPPopupMenu;
    Open1: TMenuItem;
    Runas1: TMenuItem;
    N8: TMenuItem;
    Sendto1: TMenuItem;
    N9: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    N10: TMenuItem;
    CreateShortcut1: TMenuItem;
    Delete1: TMenuItem;
    Rename1: TMenuItem;
    Properties2: TMenuItem;
    XPDictionary: TXPDictionary;
    XPLocalizator: TXPLocalizator;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure Shortcut1Click(Sender: TObject);
    procedure Properties2Click(Sender: TObject);
    procedure Folder1Click(Sender: TObject);
  private
    { Private declarations }
    procedure createFolder(ix, iy: integer);
  public
    { Public declarations }
    desktopproperties: boolean;
    desktop:TSysListView;
    method: integer;
    desktopimage: string;
    procedure initTheme;
    procedure DesktopOnDblClick(Sender:TObject);
    function addIcon(const caption,image,fullpath:string;islnk:boolean):TSysListItem;
    procedure addSystemIcons;
    procedure readDesktopItems;
    procedure LoadBackGroundFromRegistry;
    procedure LoadProperties;
    procedure clearBackground;
    procedure setDesktopImage(const filename: string; amethod: integer);
    procedure loadDesktopProperties;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.xfm}

procedure TMainForm.readDesktopItems;
var
    sr: TSearchRec;
    ext:string;
    lnk: TLNKFile;
begin
    if findfirst(XPAPI.getSysInfo(siUserDir)+'/.xpde/Desktop/*',faAnyFile,sr)=0 then begin
        repeat
            if (sr.Attr and faDirectory)=faDirectory then begin
                if (sr.name<>'.') and (sr.name<>'..') then addIcon(sr.name,sFOLDER,sr.PathOnly+sr.name,false);
            end
            else begin
               ext:=copy(ansilowercase(extractfileext(sr.name)),2,255);
               if ext='lnk' then begin
                    lnk:=TLNKFile.create(nil);
                    try
                        lnk.loadfromfile(sr.pathonly+sr.name);
                        addIcon(lnk.caption,lnk.icon,sr.PathOnly+sr.name,true);
                    finally
                        lnk.free;
                    end;
               end
               else if ext='ico' then begin
                    addIcon(sr.name,sr.PathOnly+sr.name,sr.PathOnly+sr.name,false);
               end
               else addIcon(sr.name,XPAPI.getSysInfo(siFileTypesDir)+ext+'.png',sr.PathOnly+sr.name,false);
            end;
        until findnext(sr)<>0;
    end;
    findclose(sr);
end;

procedure TMainform.addSystemIcons;
begin
    addIcon('My Documents',sMYDOCUMENTS,'%MYDOCUMENTS%',false);
    addIcon('My Computer',sMYCOMPUTER,'%MYCOMPUTER%',false);
    addIcon('My Home',sMYHOME,'%MYHOME%',false);
    addIcon('My Network Places',sMYNETWORKPLACES,'%MYNETWORKPLACES%',false);
    addIcon('Recycle Bin',sRECYCLEBINEMPTY,'%RECYCLEBIN%',false);
end;

function TMainform.addIcon(const caption, image, fullpath: string;islnk:boolean): TSysListItem;
var
    iconfile:string;
begin
    { TODO : Store the fullpath somewhere }
    if (image<>'') and (fileexists(image)) then iconfile:=image
    else begin
        if (image='') then iconfile:=XPAPI.getSysInfo(siSystemDir)+sNOICON
        else begin
            iconfile:=XPAPI.getSysInfo(siSystemDir)+image;
            if (not fileexists(iconfile)) then begin
                iconfile:=XPAPI.getSysInfo(siSystemDir)+sNOICON;
            end;
        end;
    end;
    result:=desktop.addItem(caption,iconfile,islnk);
    if assigned(result) then begin
        result.data:=fullpath;
        result.popupmenu:=itempopup;
        result.itemText.PopupMenu:=itempopup;
    end;
end;

procedure TMainForm.DesktopOnDblClick(Sender: TObject);
begin
    if assigned(desktop.selected) then begin
        XPAPI.ShellDocument(desktop.Selected.data);
    end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    initTheme;
    if paramstr(1)='full' then begin
        borderstyle:=fbsNone;
        left:=0;
        top:=0;
        width:=screen.width;
        height:=screen.height;
        sendtoback;
    end;

    desktopproperties:=false;
    method:=2;

    XPAPI.setdefaultcursor;    
    font.name:=sDefaultFontName;
    font.size:=iDefaultFontSize;
    font.Height:=iDefaultFontHeight;
    font.color:=dclBtnHighlight;
    desktop:=TSysListView.create(self);
    desktop.Align:=alClient;
    desktop.parent:=self;
    desktop.Color:=dclDesktopBackground;
    desktop.sendtoback;
    desktop.OnDblClick:=DesktopOnDblClick;
    desktop.PopupMenu:=deskpopup;

    addSystemIcons;
    readDesktopItems;
    loadbackgroundfromregistry;
    loadproperties;
end;

procedure TMainForm.LoadBackGroundFromRegistry;
var
    reg:TRegistry;
    path:string;
begin
    reg:=TRegistry.create;
    try
        if reg.OpenKey('Software/XPde/Desktop/Wallpaper',false) then begin
            path:=reg.ReadString('Background');
            method:=reg.ReadInteger('Method');
            if path='none' then begin
                clearBackground;
            end
            else setDesktopImage(path,method);
        end
        else setDesktopImage(XPAPI.getSysInfo(siUserDir)+'/.xpde/Wallpapers/default.jpg',method);
    finally
        reg.Free;
    end;
end;

procedure TMainForm.clearBackground;
var
    reg: TRegistry;
begin
    desktopimage:='';
    desktop.clearbackground;

    reg:=TRegistry.create;
    try
        if reg.OpenKey('Software/XPde/Desktop/Wallpaper',true) then begin
            reg.WriteString('Background','none');
        end;
    finally
        reg.Free;
    end;
end;


procedure TMainForm.setDesktopImage(const filename: string;amethod:integer);
var
    reg:TRegistry;
begin
    if fileexists(filename) then begin
        desktop.setdesktopimage(filename,amethod);
        desktopimage:=filename;

        method:=amethod;

        reg:=TRegistry.create;
        try
            if reg.OpenKey('Software/XPde/Desktop/Wallpaper',true) then begin
                reg.WriteString('Background',filename);
                reg.WriteInteger('Method',method);
            end;
        finally
            reg.Free;
        end;
    end;
end;


procedure TMainForm.LoadProperties;
var
    reg:TRegistry;
    col: string;
begin
    reg:=TRegistry.create;
    try
        if reg.OpenKey('Software/XPde/Desktop',false) then begin
            if reg.ValueExists('BackgroundColor') then begin
                col:=reg.ReadString('BackgroundColor');
                desktop.color:=stringtocolor(col);
            end
            else desktop.color:=dclDesktopBackground;
        end
        else desktop.color:=dclDesktopBackground;
    finally
        reg.Free;
    end;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
    if paramstr(1)='full' then sendtoback;
    desktop.SetFocus;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
    if paramstr(1)='full' then begin
    end;
end;

procedure TMainform.loadDesktopProperties;
begin
    loadBackgroundFromRegistry;
    loadproperties;
end;

procedure TMainForm.Properties1Click(Sender: TObject);
var
    arg: string;
begin
    if not desktopproperties then begin
        desktopproperties:=true;
        try
            arg:='';
            if StartApp(XPAPI.getSysInfo(siUserDir)+'/xpde/desk.cpl',arg,true)<>0 then begin
                loadDesktopProperties;
            end;
        finally
            desktopproperties:=false;
        end;
    end;
end;

procedure TMainForm.Shortcut1Click(Sender: TObject);
begin
    CreateShortCut(deskpopup.px,deskpopup.py);
end;

procedure TMainForm.Properties2Click(Sender: TObject);
var
    s: TSysListItem;
begin
    s:=desktop.Selected;
    if s.lnk then begin
        showlinkproperties(s.Data,s);
    end;
end;

procedure TMainForm.Folder1Click(Sender: TObject);
begin
    CreateFolder(deskpopup.px,deskpopup.py);
end;

procedure TMainform.createFolder(ix, iy: integer);
var
    fullpath: string;
    d: TSysListItem;
    i:integer;
    dirname: string;
begin
    i:=1;
    repeat
        dirname:=format('New Folder (%d)',[i]);
        fullpath:=XPAPI.getSysInfo(siDesktopdir)+dirname;
        inc(i);
    until not (directoryexists(fullpath));

    if ForceDirectories(fullpath) then begin
        d:=addIcon(dirname,sFOLDER,fullpath,false);
        if desktop.aligntogrid then begin
            desktop.GetAlignedCoords(ix,iy);
        end;
        d.left:=ix;
        d.top:=iy;
        d.savetoregistry;
    end;
end;

procedure TMainForm.initTheme;
begin
        shortcut1.Bitmap.LoadFromFile(XPAPI.getSysInfo(siSystemDir)+sSHORTCUTSMALL);
        folder1.Bitmap.LoadFromFile(XPAPI.getSysInfo(siSystemDir)+sFOLDERSMALL);
end;

end.