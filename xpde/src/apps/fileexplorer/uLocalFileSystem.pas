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
unit uLocalFileSystem;

interface

uses
    Classes, SysUtils, QGraphics,
    uExplorerAPI, QDialogs, uXPAPI;

type

    TLocalFile=class(TInterfacedObject, IXPVirtualFile)
    private
        node: TObject;
        iOpen: integer;
        iOpenwith: integer;
        iSendto: integer;
        iCut: integer;
        iCopy: integer;
        iPaste: integer;
        iCreateShortcut: integer;
        iDelete: integer;
        iRename: integer;
        iProperties: integer;
    public
        function hasChild: boolean; virtual;
        function getChildren: TInterfaceList; virtual;
        function getDisplayName: string; virtual;
        procedure getColumns(const columns:TStrings); virtual;
        function getUniqueID:string; virtual;
        procedure setNode(anode:TObject); virtual;
        function getNode:TObject; virtual;
        procedure doubleClick; virtual;
        procedure getColumnData(const columns:TStrings); virtual;
        procedure getStatusData(const status:TStrings);virtual;
        procedure getVerbItems(const verbs:TStrings); virtual;
        procedure executeVerb(const verb:integer); virtual;
        function getIcon: integer; virtual;
        function getCategory: string; virtual;
        constructor Create;
    end;

    TFile=class(TLocalFile)
    private
        FPath: string;
    public
        filesize: integer;
        time: integer;
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        procedure doubleClick; override;
        function getUniqueID:string; override;
        procedure getColumnData(const columns:TStrings); override;
        constructor Create(const APath:string); virtual;
        function getIcon: integer; override;
    end;

    TFolder=class(TLocalFile)
    private
        iExplore: integer;
        iOpen: integer;
        iFind: integer;
        iSharingandSecurity: integer;
        iSendto: integer;
        iCut: integer;
        iCopy: integer;
        iPaste: integer;
        iDelete: integer;
        iRename: integer;
        iProperties: integer;

        children: TInterfaceList;
        FPath: string;
        procedure SetPath(const Value: string);
    public
        size: integer;
        time: integer;
        function hasChild: boolean; override;
        function getUniqueID:string; override;
        function getChildren: TInterfaceList; override;
        procedure getStatusData(const status:TStrings);override;
        procedure getColumnData(const columns:TStrings); override;
        procedure getVerbItems(const verbs:TStrings); override;
        function getDisplayName: string; override;
        function getIcon: integer; override;

        property Path: string read FPath write SetPath;

        constructor Create(const APath:string); virtual;
        destructor Destroy;override;
    end;

    TMyDocuments=class(TFolder)
    public
        function getDisplayName: string; override;
        constructor Create; reintroduce;
        function getIcon: integer; override;
        procedure getVerbItems(const verbs:TStrings); override;
    end;

    TUserDocuments=class(TMyDocuments)
    public
        function getDisplayName: string; override;
    end;

    TDevice=class(TFolder)
    private
        name:string;
        FIcon: integer;
    public
        function getDisplayName: string; override;
        constructor Create(const APath:string; const AName:string; icon: integer=-1); reintroduce;
        function getIcon: integer; override;
    end;

    TFloppy=class(TDevice)
    public
        procedure getVerbItems(const verbs:TStrings); override;
    end;

    THarddisk=class(TDevice)
    public
        procedure getVerbItems(const verbs:TStrings); override;
    end;

    TCDDrive=class(TDevice)
    public
        procedure getVerbItems(const verbs:TStrings); override;
    end;

    TMyPC=class(TLocalFile)
    private
        children: TInterfaceList;
    public
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        procedure getColumns(const columns:TStrings); override;
        function getChildren: TInterfaceList; override;
        procedure getVerbItems(const verbs:TStrings); override;
        constructor Create;
        destructor Destroy;override;
        function getIcon: integer; override;        
    end;

    TControlPanel=class(TLocalFile)
    private
        children: TInterfaceList;
    public
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        procedure getVerbItems(const verbs:TStrings); override;
        function getChildren: TInterfaceList; override;
        function getIcon: integer; override;
        constructor Create;
        destructor Destroy;override;
    end;

    TMyNetworkPlaces=class(TLocalFile)
    private
        children: TInterfaceList;
    public
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        function getChildren: TInterfaceList; override;
        constructor Create;
        destructor Destroy;override;
        function getIcon: integer; override;
    end;

    TRecycleBin=class(TLocalFile)
    private
        children: TInterfaceList;
    public
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        function getChildren: TInterfaceList; override;
        constructor Create;
        procedure getVerbItems(const verbs:TStrings); override;
        destructor Destroy;override;
        function getIcon: integer; override;
    end;

    TDesktopItem=class(TLocalFile)
    private
        myDocuments: TMyDocuments;
        children: TInterfaceList;
    public
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        function getChildren: TInterfaceList; override;
        function getIcon: integer; override;
        procedure getVerbItems(const verbs:TStrings); override;

        constructor Create;
        destructor Destroy;override;
    end;

var
    imDESKTOP: integer=-1;
    imMYDOCUMENTS: integer=-1;
    imMYCOMPUTER: integer=-1;
    imMYNETWORKPLACES: integer=-1;
    imRECYCLEBIN: integer=-1;
    imFLOPPY: integer=-1;
    imCLOSEDFOLDER: integer=-1;
    imHARDDISK: integer=-1;
    imCDDRIVE: integer=-1;
    imCONTROLPANEL: integer=-1;
    imNOICON: integer=-1;    

implementation

var
    bmp: TBitmap;

function extractdirname(const str:string):string;
var
    i:longint;
begin
    result:=str;
    for i:=length(str) downto 1 do begin
        if (str[i]='/') then begin
            result:=copy(str,i+1,length(str));
            break;
        end;
    end;
end;


{ TDesktopItem }

constructor TDesktopItem.Create;
begin
    children:=TInterfaceList.create;
    children.add(TMyDocuments.create);
    children.add(TMyPC.create);
    children.add(TMyNetworkPlaces.create);
    children.add(TRecycleBin.create);
end;

destructor TDesktopItem.Destroy;
begin
  children.free; 
  inherited;
end;

function TDesktopItem.getChildren: TInterfaceList;
begin
    result:=children;
end;

function TDesktopItem.getDisplayName: string;
begin
    result:='Desktop';
end;

function TDesktopItem.getIcon: integer;
begin
    result:=imDESKTOP;
end;

procedure TDesktopItem.getVerbItems(const verbs: TStrings);
begin
    with verbs do begin
        clear;
        add('Explore');
        add('Open');
        add('-');
        add('Properties');
    end;
end;

function TDesktopItem.hasChild: boolean;
begin
    result:=true;
end;

{ TFolder }

constructor TFolder.Create(const APath:string);
begin
  children:=TInterfaceList.create;
  FPath:=APath;
end;

destructor TFolder.Destroy;
begin
    children.free;
  inherited;
end;

function TFolder.getChildren: TInterfaceList;
var
    f: TSearchRec;
    a: TFile;
    b: TFolder;
    ss: TStringList;
    locfile: TLocalFile;
    i: integer;
begin
    if children.count=0 then begin
        size:=0;
        if Findfirst(FPath+'/*',faHidden or faAnyFile or faSysFile or faDirectory,f)=0 then begin
            ss:=TStringList.create;
            ss.sorted:=true;
            try
               repeat
                    if (f.name='.') or (f.name='..') then continue;
                    if ((faDirectory and f.Attr)=faDirectory) then begin
                        b:=TFolder.Create(f.PathOnly+f.Name);
                        b.time:=f.Time;
                        ss.AddObject(f.name,b)
                        //children.add(b);
                    end
                    else begin
                        a:=TFile.Create(f.PathOnly+f.Name);
                        a.filesize:=f.Size;
                        size:=size+a.filesize;
                        a.time:=f.Time;
                        ss.AddObject(f.name,a)
                        //children.add(a);
                    end;
               until (findnext(f)<>0);

               for i:=0 to ss.count-1 do begin
                    locfile:=ss.Objects[i] as TLocalFile;
                    children.add(locfile);
               end;
            finally
                ss.free;
                findclose(f);
            end;
        end;
    end;
    result:=children;
end;

procedure TFolder.getColumnData(const columns: TStrings);
begin
    columns.clear;
    columns.add('');
    columns.add('File Folder');
    columns.add(datetimetostr(FileDateToDateTime(time)));
end;

function TFolder.getDisplayName: string;
begin
    result:=extractdirname(FPath);
end;

function TFolder.getIcon: integer;
begin
    result:=imCLOSEDFOLDER;
end;

procedure TFolder.getStatusData(const status: TStrings);
    function formatfilesize(size:extended):string;
    begin
        result:=formatfloat('###,###,###,###,###,##0',trunc(size));
    end;
    function formatsize(size:extended):string;
    var
        kfs:extended;
    begin
        if size>1024 then begin
            if (size>1024*1024) then begin
                kfs:=size / (1024*1024);
                result:=formatfilesize(kfs)+' MB';
            end
            else begin
                kfs:=size / 1024;
                result:=formatfilesize(kfs)+' KB';
            end;
        end
        else begin
            result:=formatfilesize(size)+' bytes';
        end;
    end;
begin
    status.clear;
    status.add(format('%d objects',[children.count]));
    status.add(formatsize(size));
    status.add('My Computer');
end;

function TFolder.getUniqueID: string;
begin
    result:=FPath;
end;

procedure TFolder.getVerbItems(const verbs: TStrings);
begin
    with verbs do begin
        clear;
        iExplore:=add('Explore');
        iOpen:=add('Open');
        iFind:=add('Find...');
        add('-');
        iSharingandSecurity:=add('Sharing and Security...');
        add('-');
        iSendto:=add('Send to');
        add('-');
        iCut:=add('Cut');
        iCopy:=add('Copy');
        if not XPExplorer.ClipboardEmpty then begin
            iPaste:=add('Paste');
        end;
        add('-');
        iDelete:=add('Delete');
        iRename:=add('Rename');
        add('-');
        iProperties:=add('Properties');
    end;
end;

function TFolder.hasChild: boolean;
begin
    //Checkout if there are subdirs/files in FPath
    result:=true; //For now
end;

procedure TFolder.SetPath(const Value: string);
begin
  FPath := Value;
end;

{ TFile }

constructor TFile.Create(const APath: string);
begin
    FPath:=APath;
end;

procedure TFile.doubleClick;
begin
    XPAPI.ShellDocument(FPath);
end;

procedure TFile.getColumnData(const columns: TStrings);
var
    f: extended;
begin
    columns.clear;

    f:=round(filesize/1024);

    //Format float it seems not to work here 
    columns.add(formatfloat('#,##0',f)+' KB');
    columns.add('File');

    columns.add(datetimetostr(FileDateToDateTime(time)));
end;

function TFile.getDisplayName: string;
begin
    result:=extractfilename(FPath);
end;

function TFile.getIcon: integer;
begin
    result:=imNOICON;
end;

function TFile.getUniqueID: string;
begin
    result:=FPath;
end;

function TFile.hasChild: boolean;
begin
    result:=false;
end;

{ TMyDocuments }

constructor TMyDocuments.Create;
begin
    inherited Create('/home/ttm/.xpde/My Documents');
end;

function TMyDocuments.getDisplayName: string;
begin
    result:='My Documents';
end;

function TMyDocuments.getIcon: integer;
begin
    result:=imMYDOCUMENTS;
end;

procedure TMyDocuments.getVerbItems(const verbs: TStrings);
begin
    with verbs do begin
        clear;
        add('Explore');
        add('Open');
        add('Find...');
        add('-');
        add('Copy');
        add('-');
        add('Delete');
        add('Rename');
        add('-');
        add('Properties');
    end;
end;

{ TMyPC }

constructor TMyPC.Create;
begin
    children:=TInterfaceList.create;
    children.add(TFloppy.create('/mnt/floppy','3" 1/2 Floppy',imFLOPPY));
    children.add(THardDisk.create('/','Local Disk',imHARDDISK));
    children.add(TCDDrive.create('/mnt/cdrom','CD Drive',imCDDRIVE));
    children.add(TControlPanel.create);
    children.add(TFolder.create('/opt/xpde/share/Shared Documents'));
    children.add(TUserDocuments.create);                
end;

destructor TMyPC.Destroy;
begin
  children.free;
  inherited;
end;

function TMyPC.getChildren: TInterfaceList;
begin
    result:=children;
end;

procedure TMyPC.getColumns(const columns: TStrings);
begin
    columns.clear;
    columns.add('Name');
    columns.add('Type');
    columns.add('Total Size');
    columns.add('Available');
end;

function TMyPC.getDisplayName: string;
begin
    result:='My Computer';
end;

function TMyPC.getIcon: integer;
begin
    result:=imMYCOMPUTER;
end;

procedure TMyPC.getVerbItems(const verbs: TStrings);
begin
    with verbs do begin
        clear;
        add('Explore');
        add('Open');
        add('Find...');
        add('Manage');
        add('-');
        add('Connect to a network drive...');
        add('Disconnect from a network drive...');
        add('-');
        add('Delete');
        add('Rename');
        add('-');
        add('Properties');
    end;
end;

function TMyPC.hasChild: boolean;
begin
    result:=true;
end;

{ TLocalFile }

constructor TLocalFile.Create;
begin
    node:=nil;
end;

procedure TLocalFile.doubleClick;
begin
    showmessage('Not implemented yet!');
end;

procedure TLocalFile.executeVerb(const verb: integer);
begin
    if verb=iCopy then begin
        XPExplorer.copytoclipboard(getUniqueID);
    end;

    if verb=iPaste then begin
        showmessage('ok');
    end;
end;

function TLocalFile.getCategory: string;
begin

end;

function TLocalFile.getChildren: TInterfaceList;
begin
    result:=nil;
end;

procedure TLocalFile.getColumnData(const columns: TStrings);
begin
    columns.clear;
    columns.add('');
    columns.add('File');
    columns.add('');
end;

procedure TLocalFile.getColumns(const columns: TStrings);
begin
    columns.clear;
    columns.add('Name');
    columns.add('Size');
    columns.add('Type');
    columns.add('Modification Date');
end;

function TLocalFile.getDisplayName: string;
begin
    result:='';
end;

function TLocalFile.getIcon: integer;
begin
    result:=imNOICON;
end;

function TLocalFile.getNode: TObject;
begin
    result:=node;
end;

procedure TLocalFile.getStatusData(const status: TStrings);
var
    f: TInterfaceList;
begin

    status.clear;
    f:=getchildren;
    if assigned(f) then begin
        status.add(format('%d objects',[f.count]));
    end
    else begin
        status.add('0 objects');
    end;
    status.add('');
    status.add('My Computer');
end;

function TLocalFile.getUniqueID: string;
begin
    result:='';
end;

procedure TLocalFile.getVerbItems(const verbs: TStrings);
begin
    verbs.clear;
    with verbs do begin
        clear;
        iOpen:=add('Open');
        iOpenWith:=add('Open with...');
        add('-');
        iSendto:=add('Send to');
        add('-');
        iCut:=add('Cut');
        iCopy:=add('Copy');
        if not XPExplorer.ClipboardEmpty then begin
            iPaste:=add('Paste');
        end;
        add('-');
        iCreateshortcut:=add('Create shortcut');
        iDelete:=add('Delete');
        iRename:=add('Rename');
        add('-');
        iProperties:=add('Properties');
    end;
end;

function TLocalFile.hasChild: boolean;
begin
    result:=false;
end;

procedure TLocalFile.setNode(anode: TObject);
begin
    node:=anode;
end;

{ TDevice }

constructor TDevice.Create(const APath:string; const AName:string; icon: integer=-1);
begin
    inherited Create(APath);
    ficon:=icon;
    name:=AName;
end;

function TDevice.getDisplayName: string;
begin
    result:=name;
end;

function TDevice.getIcon: integer;
begin
    result:=FIcon;
end;

{ TMyNetworkPlaces }

constructor TMyNetworkPlaces.Create;
begin

end;

destructor TMyNetworkPlaces.Destroy;
begin

  inherited;
end;

function TMyNetworkPlaces.getChildren: TInterfaceList;
begin
    result:=nil;
end;

function TMyNetworkPlaces.getDisplayName: string;
begin
    result:='My Network Places';
end;

function TMyNetworkPlaces.getIcon: integer;
begin
    result:=imMYNETWORKPLACES;
end;

function TMyNetworkPlaces.hasChild: boolean;
begin
    result:=false;
end;

{ TRecycleBin }

constructor TRecycleBin.Create;
begin

end;

destructor TRecycleBin.Destroy;
begin

  inherited;
end;

function TRecycleBin.getChildren: TInterfaceList;
begin
    result:=nil;
end;

function TRecycleBin.getDisplayName: string;
begin
    result:='Recycle Bin';
end;

function TRecycleBin.getIcon: integer;
begin
    result:=imRECYCLEBIN;
end;

procedure TRecycleBin.getVerbItems(const verbs: TStrings);
begin
    with verbs do begin
        clear;
        add('Explore');
        add('Open');
        add('Empty Recycle Bin');
        add('-');
        add('Properties');
    end;
end;

function TRecycleBin.hasChild: boolean;
begin
    result:=false;
end;

{ TControlPanel }

constructor TControlPanel.Create;
begin

end;

destructor TControlPanel.Destroy;
begin

  inherited;
end;

function TControlPanel.getChildren: TInterfaceList;
begin
    result:=nil;
end;

function TControlPanel.getDisplayName: string;
begin
    result:='Control Panel';
end;

function TControlPanel.getIcon: integer;
begin
    result:=imCONTROLPANEL;
end;

procedure TControlPanel.getVerbItems(const verbs: TStrings);
begin
    with verbs do begin
        clear;
        add('Explore');
        add('Open');
    end;
end;

function TControlPanel.hasChild: boolean;
begin
    result:=true;
end;

{ TUserDocuments }

function TUserDocuments.getDisplayName: string;
begin
    result:='ttm''s Documents';
end;

{ TFloppy }

procedure TFloppy.getVerbItems(const verbs: TStrings);
begin
    with verbs do begin
        clear;
        add('Explore');
        add('Open');
        add('Find...');
        add('-');
        add('Sharing and Security...');
        add('-');
        add('Copy disk');
        add('-');
        add('Format');
        add('-');
        add('Cut');
        add('Copy');
        add('-');
        add('Rename');
        add('-');
        add('Properties');
    end;
end;

{ THarddisk }

procedure THarddisk.getVerbItems(const verbs: TStrings);
begin
    with verbs do begin
        clear;
        add('Explore');
        add('Open');
        add('Find...');
        add('-');
        add('Sharing and Security...');
        add('-');
        add('Format');
        add('-');
        add('Copy');
        add('-');
        add('Rename');
        add('-');
        add('Properties');
    end;
end;

{ TCDDrive }

procedure TCDDrive.getVerbItems(const verbs: TStrings);
begin
    with verbs do begin
        clear;
        add('Explore');
        add('Open');
        add('Find...');
        add('-');
        add('Sharing and Security...');
        add('-');
        add('Eject');
        add('-');
        add('Copy');
        add('-');
        add('Properties');
    end;
end;

initialization
    bmp:=TBitmap.create;
    try
        bmp.loadfromfile('/home/ttm/xpde/themes/default/16x16/system/desktop.png');
        imDESKTOP:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile('/home/ttm/xpde/themes/default/16x16/system/mydocuments.png');
        imMYDOCUMENTS:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile('/home/ttm/xpde/themes/default/16x16/system/mycomputer.png');
        imMYCOMPUTER:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile('/home/ttm/xpde/themes/default/16x16/system/network.png');
        imMYNETWORKPLACES:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile('/home/ttm/xpde/themes/default/16x16/system/recyclebin.png');
        imRECYCLEBIN:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile('/home/ttm/xpde/themes/default/16x16/system/floppy.png');
        imFLOPPY:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile('/home/ttm/xpde/themes/default/16x16/system/closedfolder.png');
        imCLOSEDFOLDER:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile('/home/ttm/xpde/themes/default/16x16/system/harddisk.png');
        imHARDDISK:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile('/home/ttm/xpde/themes/default/16x16/system/cddrive.png');
        imCDDRIVE:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile('/home/ttm/xpde/themes/default/16x16/system/controlpanel.png');
        imCONTROLPANEL:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile('/home/ttm/xpde/themes/default/16x16/system/noiconsm.png');
        imNOICON:=XPExplorer.registerImage(bmp);
    finally
        bmp.free;
    end;

    XPExplorer.registerRootItem(TDesktopItem.create);

end.
