unit uXPExplorer;

interface

uses
    uExplorerAPI, QGraphics, QImgList,Classes;

type
    TXPExplorer=class(TInterfacedObject, IXPExplorer)
    private
        roots: TInterfaceList;
        images: TImageList;
    public
        function registerImage(const bmp: TBitmap):integer;
        procedure registerRootItem(item:IXPVirtualFile);
        function getImageList: TImageList;
        function getRootItems: TInterfaceList;
        constructor Create;
        destructor Destroy;override;
    end;

implementation

uses
    main;

{ TXPExplorer }

constructor TXPExplorer.Create;
begin
    roots:=TInterfaceList.create;
    images:=TImageList.create(nil);
end;

destructor TXPExplorer.Destroy;
begin
    images.free;
    roots.free;
    inherited;
end;

function TXPExplorer.getImageList: TImageList;
begin
    result:=images;
end;

function TXPExplorer.getRootItems: TInterfaceList;
begin
    result:=roots;
end;

function TXPExplorer.registerImage(const bmp: TBitmap): integer;
begin
    result:=images.Add(bmp,nil);
end;

procedure TXPExplorer.registerRootItem(item: IXPVirtualFile);
begin
    roots.add(item);    
end;

initialization
    XPExplorer:=TXPExplorer.create;

end.
