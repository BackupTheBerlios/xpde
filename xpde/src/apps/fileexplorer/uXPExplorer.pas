unit uXPExplorer;

interface

uses
    uExplorerAPI, Classes;

type
    TXPExplorer=class(TInterfacedObject, IXPExplorer)
    private
        roots: TInterfaceList;
    public
        procedure registerRootItem(item:IXPVirtualFile);
        function getRootItems: TInterfaceList;        
        constructor Create;
        destructor Destroy;override;
    end;

implementation

{ TXPExplorer }

constructor TXPExplorer.Create;
begin
    roots:=TInterfaceList.create;
end;

destructor TXPExplorer.Destroy;
begin
  roots.free;
  inherited;
end;

function TXPExplorer.getRootItems: TInterfaceList;
begin
    result:=roots;
end;

procedure TXPExplorer.registerRootItem(item: IXPVirtualFile);
begin
    roots.add(item);    
end;

initialization
    XPExplorer:=TXPExplorer.create;

end.
