unit main;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, uExplorerAPI, QExtCtrls, QMenus, QImgList, QButtons;

type
  TForm1 = class(TForm)
    tvItems: TTreeView;
    StatusBar1: TStatusBar;
    lvItems: TListView;
    Splitter1: TSplitter;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    View1: TMenuItem;
    Favorites1: TMenuItem;
    Tools1: TMenuItem;
    Help1: TMenuItem;
    ToolBar2: TToolBar;
    ToolButton5: TToolButton;
    ToolButton8: TToolButton;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    ToolButton1: TToolButton;
    SpeedButton10: TSpeedButton;
    procedure tvItemsExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvItemsEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure tvItemsChange(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure updateall;
    procedure populatenodes(parent: TTreeNode; const item: IXPVirtualFile);
    procedure addnodes(parent: TTreeNode; const item: IXPVirtualFile);
    procedure updatelistview(const item: IXPVirtualFile);    
  end;

var
  Form1: TForm1;

implementation

{$R *.xfm}

procedure TForm1.populatenodes(parent: TTreeNode; const item: IXPVirtualFile);
var
    i: longint;
    items: TInterfaceList;
    f: IXPVirtualFile;
    n: TTreeNode;
    p: TTreeNode;
begin
    n:=tvItems.Items.AddChildObject(parent, item.getDisplayName, pointer(item));
    if item.hasChild then begin
        items:= item.getChildren;
        if assigned(items) then begin
            for i:=0 to items.count-1 do begin
                f:=(items[i] as IXPVirtualFile);
                p:=tvItems.Items.AddChildObject(n, f.getDisplayName, pointer(f));
                tvItems.Items.AddChild(p,'dummy');
                //if f.hasChild then populatenodes(n,f);
            end;
        end;
    end;

end;

procedure TForm1.updateall;
var
    i: longint;
    roots: TInterfaceList;
    f: IXPVirtualFile;
    n: TTreeNode;
begin
    tvItems.Items.BeginUpdate;
    try
        roots:= XPExplorer.getRootItems;
        for i:=0 to roots.count-1 do begin
            f:=(roots[i] as IXPVirtualFile);
            populatenodes(nil,f);
        end;
    finally
        tvItems.Items.EndUpdate;
    end;
end;

procedure TForm1.updatelistview(const item: IXPVirtualFile);
var
    i: longint;
    items: TInterfaceList;
    f: IXPVirtualFile;
    n: TTreeNode;
    l: TListItem;
begin
    lvItems.Items.BeginUpdate;
    try
        lvItems.items.clear;
        if item.hasChild then begin
            items:= item.getChildren;
            if assigned(items) then begin
                for i:=0 to items.count-1 do begin
                    
                    f:=(items[i] as IXPVirtualFile);
                    
                    l:=lvItems.Items.Add;
                    l.Caption:=f.getDisplayName;
                end;
            end;
        end;
    finally
        lvItems.Items.EndUpdate;
    end;
end;

procedure TForm1.tvItemsExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
    f: IXPVirtualFile;
begin
    f:=IXPVirtualFile(node.data);
    if (f.hasChild) then begin
        if node.Count>=1 then begin
            if not (assigned(node.Item[0].Data)) then begin
                node.DeleteChildren;
                addnodes(node,f);
            end;
        end;
    end
    else begin
        if node.Count>=1 then begin
            if not (assigned(node.Item[0].Data)) then begin
                node.DeleteChildren;
            end;
        end;
    end;
end;

procedure TForm1.addnodes(parent: TTreeNode; const item: IXPVirtualFile);
var
    i: longint;
    items: TInterfaceList;
    f: IXPVirtualFile;
    n: TTreeNode;
    p: TTreeNode;
begin
    if item.hasChild then begin
        items:= item.getChildren;
        if assigned(items) then begin
            for i:=0 to items.count-1 do begin
                f:=(items[i] as IXPVirtualFile);
                if (f.hasChild) then begin
                    p:=tvItems.Items.AddChildObject(parent, f.getDisplayName, pointer(f));
                    tvItems.Items.AddChildObject(p,'dummy',nil);
                end;
            end;
        end;
    end;
end;

procedure TForm1.tvItemsEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
    allowedit:=false;
end;

procedure TForm1.tvItemsChange(Sender: TObject; Node: TTreeNode);
var
    f: IXPVirtualFile;
begin
    f:=IXPVirtualFile(node.data);
    caption:=f.getDisplayName;
    updateListView(f);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    updateall;
end;

end.
