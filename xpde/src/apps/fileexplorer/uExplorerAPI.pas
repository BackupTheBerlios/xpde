unit uExplorerAPI;

interface

uses
    Classes, QGraphics;

type
    IXPVirtualFile=interface
    ['{58DC80AF-0C3D-D711-9EF1-0002443C1C5D}']
        function hasChild: boolean;
        function getChildren: TInterfaceList;
        function getDisplayName: string;
        procedure getColumns(const columns:TStrings);
        procedure getVerbItems(const verbs:TStrings);
        procedure executeVerb(const verb:integer);
        function getIcon: TBitmap;
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
        function getRootItems: TInterfaceList;
    end;

var
    XPExplorer: IXPExplorer=nil;    

implementation

end.
