unit uLocalFileSystem;

interface

uses
    Classes, SysUtils, QGraphics,
    uExplorerAPI, QDialogs;

type

    TLocalFile=class(TInterfacedObject, IXPVirtualFile)
    public
        function hasChild: boolean; virtual; abstract;
        function getChildren: TInterfaceList; virtual; 
        function getDisplayName: string; virtual; abstract;
        procedure getColumns(const columns:TStrings); virtual; abstract;
        procedure getVerbItems(const verbs:TStrings); virtual; abstract;
        procedure executeVerb(const verb:integer); virtual; abstract;
        function getIcon: TBitmap; virtual; abstract;
        function getCategory: string; virtual; abstract;
    end;

    TFile=class(TLocalFile)
    private
        FPath: string;
    public
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        constructor Create(const APath:string); virtual;
    end;

    TFolder=class(TLocalFile)
    private
        children: TInterfaceList;
        FPath: string;
        procedure SetPath(const Value: string);
    public
        function hasChild: boolean; override;
        function getChildren: TInterfaceList; override;
        function getDisplayName: string; override;

        property Path: string read FPath write SetPath;

        constructor Create(const APath:string); virtual;
        destructor Destroy;override;
    end;

    TMyDocuments=class(TFolder)
    public
        function getDisplayName: string; override;
        constructor Create;
    end;

    TUserDocuments=class(TMyDocuments)
    public
        function getDisplayName: string; override;
    end;

    TDevice=class(TFolder)
    private
        name:string;
    public
        function getDisplayName: string; override;
        constructor Create(const APath:string; const AName:string); virtual;
    end;

    TMyPC=class(TLocalFile)
    private
        children: TInterfaceList;
    public
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        function getChildren: TInterfaceList; override;
        constructor Create;
        destructor Destroy;override;
    end;

    TControlPanel=class(TLocalFile)
    private
        children: TInterfaceList;
    public
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        function getChildren: TInterfaceList; override;
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
    end;

    TRecycleBin=class(TLocalFile)
    private
        children: TInterfaceList;
    public
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        function getChildren: TInterfaceList; override;
        constructor Create;
        destructor Destroy;override;
    end;

    TDesktopItem=class(TLocalFile)
    private
        myDocuments: TMyDocuments;
        children: TInterfaceList;
    public
        function hasChild: boolean; override;
        function getDisplayName: string; override;
        function getChildren: TInterfaceList; override;

        constructor Create;
        destructor Destroy;override;
    end;


implementation

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
    i: integer;
begin
    if children.count=0 then begin
        if Findfirst(FPath+'/*',faHidden or faAnyFile or faSysFile or faDirectory or faArchive,f)=0 then begin
//        if Findfirst(FPath+'/*',faDirectory,f)=0 then begin
            try
               repeat
                    if (f.name='.') or (f.name='..') then continue;
                    if ((faDirectory and f.Attr)=faDirectory) then begin
                        children.add(TFolder.Create(f.PathOnly+f.Name));
                    end
                    else begin
                        children.add(TFile.Create(f.PathOnly+f.Name));
                    end;
               until (findnext(f)<>0);
            finally
                findclose(f);
            end;
        end;
    end;
    result:=children;
end;

function TFolder.getDisplayName: string;
begin
    result:=extractdirname(FPath);
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

function TFile.getDisplayName: string;
begin
    result:=extractfilename(FPath);
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

{ TMyPC }

constructor TMyPC.Create;
begin
    children:=TInterfaceList.create;
    children.add(TDevice.create('/mnt/floppy','3" 1/2 Floppy'));
    children.add(TDevice.create('/','Local Disk'));
    children.add(TDevice.create('/mnt/cdrom','CD Drive'));
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

function TMyPC.getDisplayName: string;
begin
    result:='My Computer';
end;

function TMyPC.hasChild: boolean;
begin
    result:=true;
end;

{ TLocalFile }

function TLocalFile.getChildren: TInterfaceList;
begin
    result:=nil;
end;

{ TDevice }

constructor TDevice.Create(const APath:string; const AName:string); 
begin
    inherited Create(APath);
    name:=AName;
end;

function TDevice.getDisplayName: string;
begin
    result:=name;
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

function TControlPanel.hasChild: boolean;
begin
    result:=false;
end;

{ TUserDocuments }

function TUserDocuments.getDisplayName: string;
begin
    result:='ttm''s Documents';
end;

initialization
    XPExplorer.registerRootItem(TDesktopItem.create);

end.
