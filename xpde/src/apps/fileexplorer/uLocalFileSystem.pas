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
    uExplorerAPI, QDialogs, uXPAPI,
    QForms, Libc, uLNKFile;

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
        FChildrenModified: TXPChildrenModified;
        parent: TLocalFile;
    public
        procedure doChildrenModified(const op: TXPChildrenOperation; const item: IXPVirtualFile);
        function hasChild: boolean; virtual;
        function locationExists(const location:string):boolean; virtual;
        function getChildren: TInterfaceList; virtual;
        function getDisplayName: string; virtual;
        procedure getColumns(const columns:TStrings); virtual;
        procedure stripLocation(const location:string;pieces:TStrings); virtual;
        function getUniqueID:string; virtual;
        procedure setNode(anode:TObject); virtual;
        function getNode:TObject; virtual;
        procedure doubleClick; virtual;
        procedure getColumnData(const columns:TStrings); virtual;
        procedure getStatusData(const status:TStrings);virtual;
        procedure getVerbItems(const verbs:TStrings); virtual;
        procedure executeVerb(const verb:integer); virtual;
        procedure setChildrenModified(value: TXPChildrenModified);virtual;
        function getIcon: integer; virtual;
        function getCategory: string; virtual;
        constructor Create;
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
        procedure addFile(const path:string);
        procedure addFolder(const path:string);
        function getChildren: TInterfaceList; override;
        procedure getStatusData(const status:TStrings);override;
        procedure getColumnData(const columns:TStrings); override;
        procedure executeVerb(const verb:integer); override;
        procedure getVerbItems(const verbs:TStrings); override;
        function getDisplayName: string; override;
        function getIcon: integer; override;

        property Path: string read FPath write SetPath;

        constructor Create(const APath:string); virtual;
        destructor Destroy;override;
    end;

    TFile=class(TLocalFile)
    private
        FPath: string;
        smallicon: integer;
    public
        filesize: integer;
        time: integer;
        parentfolder: TFolder;
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        procedure doubleClick; override;
        function getUniqueID:string; override;
        procedure getColumnData(const columns:TStrings); override;
        constructor Create(const APath:string); virtual;
        procedure executeVerb(const verb:integer); override;
        function getIcon: integer; override;
    end;


    TMyDocuments=class(TFolder)
    public
        function getDisplayName: string; override;
        constructor Create; reintroduce;
        function locationExists(const location:string):boolean; override;
        function getIcon: integer; override;
        procedure getVerbItems(const verbs:TStrings); override;
    end;

    THomeFolder=class(TFolder)
    public
        function getDisplayName: string; override;
        constructor Create; reintroduce;
        function getUniqueID:string; override;        
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
        function locationExists(const location:string):boolean; override;
        function getChildren: TInterfaceList; override;
        procedure getVerbItems(const verbs:TStrings); override;
        constructor Create;
        destructor Destroy;override;
        function getIcon: integer; override;
    end;

    TControlPanel=class(TFolder)
    public
        procedure getColumns(const columns:TStrings); override;
        function getDisplayName: string; override;
        constructor Create; reintroduce;
        function getIcon: integer; override;
        procedure getVerbItems(const verbs:TStrings); override;
    end;

    {
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
    }

    TMyNetworkPlaces=class(TLocalFile)
    private
        children: TInterfaceList;
    public
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        function locationExists(const location:string):boolean; override;
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
        function locationExists(const location:string):boolean; override;        
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

    TFileCopier=class(TObject)
    public
        targetFolder: TFolder;
        sourcepaths: TStringList;
        basepaths: TStringList;
        sources: TStringList;
        target: string;
        copydlg: TForm;
        currentfile: string;
        currentsource: string;
        currenttarget: string;

        starttime: integer;
        currenttime: integer;
        currentsize: integer;
        totalsize: integer;
        eta: string;
        lasteta: integer;
        procedure copyFile(const source:string; const target, basepath:string);
        procedure OnFileProgress;
        procedure fillArchives(const dirname:string; list:TStrings; paths: TStrings; const basepath:string);
        procedure fillSources;
        procedure calculatesize;
        procedure start;
        constructor Create;
        destructor Destroy;override;
    end;

var
    imDESKTOP: integer=-1;
    imHOME: integer=-1;    
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

const
    bufsize=32768;


implementation

var
    bmp: TBitmap;

function registerBitmap(const path:string):integer;
begin
    bmp:=TBitmap.create;
    try
        bmp.loadfromfile(path);
        result:=XPExplorer.registerImage(bmp);
    finally
        bmp.free;
    end;
end;

function getTickCount:integer;
var
    tv: timeval;
    tz: timezone;
begin
    gettimeofday(tv,tz);
    result:=tv.tv_sec;
end;

function removeTrailingSlash(const str:string):string;
begin
    result:=str;
    if result<>'/' then begin
        if result[length(result)]='/' then result:=copy(result,1,length(result)-1);
    end;
end;

function extractdirname(const str:string):string;
var
    i:longint;
begin
    result:=removetrailingslash(str);
    for i:=length(str)-1 downto 1 do begin
        if (str[i]='/') then begin
            result:=copy(result,i+1,length(result));
            break;
        end;
    end;
end;

function extractdirpart(const str:string):string;
var
    i:longint;
begin
    result:=removetrailingslash(str);
    for i:=length(str)-1 downto 1 do begin
        if (str[i]='/') then begin
            result:=copy(result,1,i);
            break;
        end;
    end;
end;

function addTrailingSlash(const str:string):string;
begin
    result:=str;
    if result<>'' then begin
        if result[length(result)]<>'/' then result:=result+'/';
    end;
end;

function getnewdir(const path:string; const basepath:string):string;
var
    spath:string;
    rightpath: string;
    k: integer;
begin
    result:='';
    spath:=extractfilepath(path);
    rightpath:=copy(spath,length(basepath)+1,length(spath));

    rightpath:=addTrailingSlash(rightpath);
    k:=pos('/',rightpath);
    if k<>0 then begin
        result:=copy(rightpath,1,k-1);
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

procedure TFolder.addFile(const path: string);
var
    a: TFile;
    st: _stat;
begin
    if children.count=0 then getChildren;
    a:=TFile.Create(path);
    a.parentfolder:=self;
    stat(pchar(path),st);
    a.filesize:=st.st_size;
    size:=size+a.filesize;
    a.time:=st.st_mtime;
    children.add(a);
    doChildrenModified(coAdd,a);
end;

procedure TFolder.addFolder(const path: string);
var
    a: TFolder;
    st: _stat;
begin
    if children.count=0 then getChildren;
    a:=TFolder.Create(path);
    stat(pchar(path),st);
    a.time:=st.st_mtime;
    children.add(a);
    doChildrenModified(coAdd,a);
end;

constructor TFolder.Create(const APath:string);
var
    statbuff: _stat;
begin
    stat(PChar(apath),statbuff);
    time:=statbuff.st_mtime;
  children:=TInterfaceList.create;
  FPath:=APath;
end;

destructor TFolder.Destroy;
begin
    children.free;
  inherited;
end;

procedure TFolder.executeVerb(const verb: integer);
var
    f: TFileCopier;
    copydlg:TForm;
begin
    if verb=iCopy then begin
        XPExplorer.copycurrentselectiontoclipboard;
    end;

    if verb=iPaste then begin
        copydlg:=XPExplorer.createNewProgressDlg('Copying...');
        copydlg.show;
        f:=TFileCopier.create;
        try
            f.copydlg:=copydlg;
            f.target:=extractfilepath(FPath);
            f.sourcepaths.assign(XPExplorer.getClipboard);
            f.targetFolder:=Self;
            f.start;
        finally
            copydlg.free;
            f.free;
        end;
    end;
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

        FPath:=addTrailingSlash(FPath);

        if Findfirst(FPath+'*',faHidden or faAnyFile or faSysFile or faDirectory,f)=0 then begin
            ss:=TStringList.create;
            ss.sorted:=true;
            try
               repeat
                    if (f.name='.') or (f.name='..') then continue;
                    if ((faDirectory and f.Attr)=faDirectory) then begin
                        b:=TFolder.Create(f.PathOnly+f.Name);
                        b.parent:=Self;
                        b.time:=f.Time;
                        ss.AddObject(f.name,b)
                        //children.add(b);
                    end
                    else begin
                        a:=TFile.Create(f.PathOnly+f.Name);
                        a.parent:=Self;
                        a.parentfolder:=self;
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
    smallicon:=imNOICON;
    FPath:=APath;
end;

procedure TFile.doubleClick;
begin
    XPAPI.ShellDocument(FPath);
end;

procedure TFile.executeVerb(const verb: integer);
var
    f: TFileCopier;
    copydlg:TForm;
begin
    if verb=iCopy then begin
        XPExplorer.copycurrentselectiontoclipboard;
    end;

    if verb=iPaste then begin
        copydlg:=XPExplorer.createNewProgressDlg('Copying...');
        copydlg.show;
        f:=TFileCopier.create;
        try
            f.copydlg:=copydlg;
            f.target:=extractfilepath(FPath);
            f.sourcepaths.assign(XPExplorer.getClipboard);
            f.targetFolder:=parentfolder;
            f.start;
        finally
            copydlg.free;
            f.free;
        end;
    end;
end;

procedure TFile.getColumnData(const columns: TStrings);
var
    f: extended;
    l: TLNKFile;
begin
    columns.clear;
    if assigned(parent) and (parent is TControlPanel) then begin
        l:=TLNKFile.Create(nil);
        try
            l.loadfromfile(FPath);
            if (l.icon<>'') then begin
                smallicon:=registerBitmap(XPAPI.getsysinfo(siSmallSystemDir)+l.Icon);
            end
            else smallicon:=imNoicon;
            columns.add(l.Comment);
        finally
            l.free;
        end;
    end
    else begin
        f:=round(filesize/1024);
        //Format float it seems not to work here
        columns.add(formatfloat('#,##0',f)+' KB');
        columns.add('File');
        columns.add(datetimetostr(FileDateToDateTime(time)));
    end;
end;

function TFile.getDisplayName: string;
begin
    if assigned(parent) then begin
        if parent is TControlPanel then begin
            result:=changefileext(extractfilename(FPath),'');
        end
        else begin
            result:=extractfilename(FPath);
        end;
    end
    else begin
        result:=extractfilename(FPath);
    end;
end;

function TFile.getIcon: integer;
begin
    result:=smallicon;
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
    inherited Create(XPAPI.getsysinfo(siMyDocuments));
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

function TMyDocuments.locationExists(const location: string): boolean;
begin
    if (location='%MYDOCUMENTS%') then result:=true
    else result:=false;
end;

{ TMyPC }

constructor TMyPC.Create;
begin
    children:=TInterfaceList.create;
    children.add(TFloppy.create('/mnt/floppy','3" 1/2 Floppy',imFLOPPY));
    children.add(THardDisk.create('/','Local Disk',imHARDDISK));
    children.add(TCDDrive.create('/mnt/cdrom','CD Drive',imCDDRIVE));
    children.add(THomeFolder.create);
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

function TMyPC.locationExists(const location: string): boolean;
begin
    result:=DirectoryExists(location);
    if not result then result:=FileExists(location);
    if not result then begin
        if (location='%MYHOME%') then result:=true;
        if (location='%MYCOMPUTER%') then result:=true;        
    end;
end;

{ TLocalFile }

constructor TLocalFile.Create;
begin
    parent:=nil;
    node:=nil;
    FChildrenModified:=nil;
end;

procedure TLocalFile.doChildrenModified(const op: TXPChildrenOperation;
  const item: IXPVirtualFile);
begin
    if assigned(FChildrenModified) then FChildrenModified(self,op,item);
end;

procedure TLocalFile.doubleClick;
begin
    showmessage('Not implemented yet!');
end;

procedure TLocalFile.executeVerb(const verb: integer);
begin

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

function TLocalFile.locationExists(const location: string): boolean;
begin
    result:=false;
end;

procedure TLocalFile.setChildrenModified(value: TXPChildrenModified);
begin
    FChildrenModified:=value;
end;

procedure TLocalFile.setNode(anode: TObject);
begin
    node:=anode;
end;

procedure TLocalFile.stripLocation(const location: string; pieces: TStrings);
var
    i: integer;
    s: string;
    li: integer;
    loc: string;
begin
    if pos('%',location)<>0 then begin
        pieces.add(location);
    end
    else begin
        li:=1;
        loc:=removeTrailingSlash(location);
        for i:=length(loc) downto 1 do begin
            if loc[i]='/' then begin
                if i=1 then begin
                    s:=copy(loc,i+1,li);
                end
                else begin
                    s:=copy(loc,i,li);
                end;
                if trim(s)<>'' then begin
                    s:=removeTrailingSlash(s);
                    pieces.insert(0,s);
                end;
                li:=0;
            end;
            inc(li);
        end;
        pieces.insert(0,'/');
    end;
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

function TMyNetworkPlaces.locationExists(const location: string): boolean;
begin
    if (location='%MYNETWORKPLACES%') then result:=true
    else result:=false;
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

function TRecycleBin.locationExists(const location: string): boolean;
begin
    if (location='%RECYCLEBIN%') then result:=true
    else result:=false;
end;

{ TControlPanel }

constructor TControlPanel.Create;
begin
    inherited Create(XPAPI.getsysinfo(siControlPanel));
end;

procedure TControlPanel.getColumns(const columns: TStrings);
begin
    columns.clear;
    columns.add('Name');
    columns.add('Comments');
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

{ TFileCopier }

procedure TFileCopier.calculatesize;
var
    source: string;
    i: integer;
    statbuff: _stat;
begin
    XPExplorer.updateProgressDlg(copydlg,0,0,'','','Calculating size...');
    totalsize:=0;
    for i:=0 to sources.count-1 do begin
        source:=sources[i];
        stat(PChar(source), statbuff);
        totalsize:=totalsize+statbuff.st_size;
    end;
end;

procedure TFileCopier.copyFile(const source, target, basepath: string);
var
    s: TFileStream;
    t: TFileStream;
    basedir: string;
    sourcename:string;
    targetname:string;
    k: integer;
    newdir: string;
    addnew: boolean;

    buf: array [0..bufsize-1] of byte;
    rsize: integer;
begin
    sourcename:=copy(source,length(basepath)+1,length(source));
    currentfile:=extractfilename(sourcename);

    currenttarget:=extractdirname(target);
    currentsource:=extractdirname(extractfilepath(source));

    targetname:=target+sourcename;
    if fileexists(targetname) then begin
        targetname:=target+'Copy of '+sourcename;
        if fileexists(targetname) then begin
            k:=1;
            while fileexists(targetname) do begin
                targetname:=target+'Copy ('+inttostr(k)+') of '+sourcename;
                inc(k);
            end;

        end;
    end;

    s:=TFileStream.Create(source, fmOpenRead);
    newdir:=getNewDir(targetname,basepath);
    addnew:=not directoryexists(basepath+newdir);
    ForceDirectories(extractfilepath(targetname));
    if (addnew) then begin
        targetFolder.addFolder(basepath+newdir);
    end;

    basedir:=extractdirpart(extractfilepath(targetname));

    if (addnew) or (basedir=XPExplorer.getcurrentpath) then begin
        targetFolder.addFolder(extractfilepath(targetname));
    end;

    t:=TFileStream.Create(targetname, fmOpenWrite or fmCreate);
    try
        while t.size<s.size do begin
            rsize:=s.Read(buf,sizeof(buf));
            t.Write(buf,rsize);
            currentsize:=currentsize+rsize;
            OnFileProgress;
            application.processmessages;
            if copydlg.tag=1 then break;
        end;
        if (newdir='') or (targetFolder.getDisplayName=newdir) or (extractfilepath(targetname)=XPExplorer.getcurrentpath) then targetFolder.addFile(targetname);
    finally
        t.free;
        s.free;
    end;
end;

constructor TFileCopier.Create;
begin
    sources:=TStringList.create;
    sourcepaths:=TStringList.create;
    basepaths:=TStringList.create;
end;

destructor TFileCopier.Destroy;
begin
    basepaths.free;
    sourcepaths.free;
    sources.free;
    inherited;
end;

procedure TFileCopier.fillArchives(const dirname: string; list: TStrings; paths: TStrings; const basepath:string);
var
    f: TSearchRec;
    a: TFile;
    b: TFolder;
    ss: TStringList;
    locfile: TLocalFile;
    i: integer;
    aDir: string;
begin
    aDir:=addTrailingSlash(dirname);

    if Findfirst(aDir+'*',faHidden or faAnyFile or faSysFile or faDirectory,f)=0 then begin
        try
            repeat
                if (f.name='.') or (f.name='..') then continue;

                if ((faDirectory and f.Attr)=faDirectory) then begin
                    fillarchives(f.PathOnly+f.Name,list,paths,basepath);
                end
                else begin
                    list.add(f.PathOnly+f.Name);
                    paths.add(basepath);
                end;
            until (findnext(f)<>0);
        finally
            findclose(f);
        end;
    end;
end;

procedure TFileCopier.fillSources;
var
    i: integer;
    path: string;
begin
    for i:=0 to sourcepaths.count-1 do begin
        path:=sourcepaths[i];
        if DirectoryExists(path) then begin
            if path=target then begin
                raise Exception.create('Cannot copy '+extractdirname(path)+': The destination folder is the same as the source folder');
            end;
            fillarchives(path,sources,basepaths,extractfilepath(path));        
        end
        else if fileexists(path) then begin
            sources.add(path);
            basepaths.add(extractfilepath(path));
        end
        else showmessage(path);
    end;
end;

procedure TFileCopier.OnFileProgress;
var
    spent: integer;
    totaltime: extended;
    seconds: integer;
    minutes: integer;
begin
    currenttime:=gettickcount;
    spent:=currenttime-starttime;
    if (spent>5) then begin
        totaltime:=totalsize;
        totaltime:=totaltime*spent;
        totaltime:=totaltime / currentsize;

        seconds:=round(totaltime)-spent;

        if seconds<lasteta then begin
            lasteta:=seconds;
            if seconds>60 then begin
                minutes:=seconds div 60;
                seconds:=seconds mod 60;
                eta:=format('%d Minutes and %d Seconds Remaining',[minutes,seconds]);
            end
            else begin
                eta:=inttostr(seconds)+' Seconds Remaining';
            end;
        end;
    end;

    XPExplorer.updateProgressDlg(copydlg,currentsize,totalsize,currentfile,format('Copying from ''%s'' to ''%s''',[currentsource,currenttarget]),eta);
end;

procedure TFileCopier.start;
var
    i:longint;
    source: string;
begin
    currentsize:=0;
    lasteta:=high(integer);
    eta:='';
    fillsources;
    calculatesize;
    starttime:=gettickcount;
    for i:=0 to sources.count-1 do begin
        source:=sources[i];
        copyFile(source,target, basepaths[i]);
        if copydlg.tag=1 then break;
    end;
end;

{ THomeFolder }

constructor THomeFolder.Create;
begin
    inherited Create(XPAPI.getsysinfo(siUserDir));
end;

function THomeFolder.getDisplayName: string;
begin
    result:='Home Folder';
end;

function THomeFolder.getIcon: integer;
begin
    result:=imHOME;
end;

function THomeFolder.getUniqueID: string;
begin
    result:='%MYHOME%';
end;

procedure THomeFolder.getVerbItems(const verbs: TStrings);
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

initialization
    bmp:=TBitmap.create;
    try
        bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'desktop.png');
        imDESKTOP:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'home.png');
        imHOME:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'folder_documents.png');
        imMYDOCUMENTS:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'monitor.png');
        imMYCOMPUTER:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'network.png');
        imMYNETWORKPLACES:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'recyclebinempty.png');
        imRECYCLEBIN:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'floppy.png');
        imFLOPPY:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'folder.png');
        imCLOSEDFOLDER:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'harddrive.png');
        imHARDDISK:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'cdrom.png');
        imCDDRIVE:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'control_panel.png');
        imCONTROLPANEL:=XPExplorer.registerImage(bmp);

        bmp.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'textdoc.png');
        imNOICON:=XPExplorer.registerImage(bmp);
    finally
        bmp.free;
    end;

    XPExplorer.registerRootItem(TDesktopItem.create);

end.
