unit uExplorerAPI;

interface

uses
    Classes, QGraphics, QImgList;

type
    IXPVirtualFile=interface
    ['{58DC80AF-0C3D-D711-9EF1-0002443C1C5D}']
        function hasChild: boolean;
        function getChildren: TInterfaceList;
        function getDisplayName: string;
        procedure getColumns(const columns:TStrings);
        procedure getColumnData(const columns:TStrings);
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
    end;

var
    XPExplorer: IXPExplorer=nil;    

implementation

end.
