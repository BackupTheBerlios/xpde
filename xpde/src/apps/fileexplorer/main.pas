unit main;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls,
  uExplorerAPI, QExtCtrls,
  QMenus, QImgList, QButtons;

type
  TExplorerForm = class(TForm)
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
    New1: TMenuItem;
    N1: TMenuItem;
    CreateShortcut1: TMenuItem;
    Delete1: TMenuItem;
    Rename1: TMenuItem;
    Properties1: TMenuItem;
    N2: TMenuItem;
    s1: TMenuItem;
    N3: TMenuItem;
    Close1: TMenuItem;
    Undo1: TMenuItem;
    N4: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    PasteShortcut1: TMenuItem;
    N5: TMenuItem;
    Selectall1: TMenuItem;
    Invertselection1: TMenuItem;
    Folderoptions1: TMenuItem;
    Panel1: TPanel;
    tvItems: TTreeView;
    Panel2: TPanel;
    pmProperties: TPopupMenu;
    Expand1: TMenuItem;
    miVerbs: TMenuItem;
    cbAddress: TComboBox;
    Panel3: TPanel;
    procedure tvItemsExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvItemsEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure tvItemsChange(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Close1Click(Sender: TObject);
  private
    { Private declarations }
    FVerbs: TList;
  public
    { Public declarations }
    procedure updateall;
    procedure populatenodes(parent: TTreeNode; const item: IXPVirtualFile);
    procedure addnodes(parent: TTreeNode; const item: IXPVirtualFile);
    procedure updatelistview(const item: IXPVirtualFile);
    procedure updatestatusbar(const item: IXPVirtualFile);
    procedure updatemenus(const item: IXPVirtualFile);
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  end;

var
  ExplorerForm: TExplorerForm;

implementation

{$R *.xfm}

procedure TExplorerForm.populatenodes(parent: TTreeNode; const item: IXPVirtualFile);
var
    i: longint;
    items: TInterfaceList;
    f: IXPVirtualFile;
    n: TTreeNode;
    p: TTreeNode;
begin
    n:=tvItems.Items.AddChildObject(parent, item.getDisplayName, pointer(item));
    n.ImageIndex:=item.getIcon;
    if item.hasChild then begin
        items:= item.getChildren;
        if assigned(items) then begin
            for i:=0 to items.count-1 do begin
                f:=(items[i] as IXPVirtualFile);
                p:=tvItems.Items.AddChildObject(n, f.getDisplayName, pointer(f));
                p.ImageIndex:=f.getIcon;
                tvItems.Items.AddChild(p,'dummy');
                //if f.hasChild then populatenodes(n,f);
            end;
        end;
    end;

end;

procedure TExplorerForm.updateall;
var
    i: longint;
    roots: TInterfaceList;
    f: IXPVirtualFile;
begin
    tvItems.Items.BeginUpdate;
    try
        roots:= XPExplorer.getRootItems;
        for i:=0 to roots.count-1 do begin
            f:=(roots[i] as IXPVirtualFile);
            populatenodes(nil,f);
        end;
        tvItems.Items[0].Expand(false);
    finally
        tvItems.Items.EndUpdate;
    end;
end;

procedure TExplorerForm.updatelistview(const item: IXPVirtualFile);
var
    i: longint;
    items: TInterfaceList;
    f: IXPVirtualFile;
    l: TListItem;
    cols: TStringList;
    c: TListColumn;
    k: integer;
    w: integer;
begin
    lvItems.Items.BeginUpdate;
    cols:=TStringList.create;
    try
        lvItems.items.clear;
        lvItems.Columns.Clear;
        if item.hasChild then begin
            item.getColumns(cols);
            for i:=0 to cols.count-1 do begin
                c:=lvItems.Columns.Add;
                c.Caption:=cols[i];
                c.Width:=canvas.TextWidth(c.caption)+20;
            end;
            items:= item.getChildren;
            if assigned(items) then begin
                for i:=0 to items.count-1 do begin

                    f:=(items[i] as IXPVirtualFile);

                    l:=lvItems.Items.Add;
                    f.getcolumndata(cols);
                    l.Caption:=f.getDisplayName;
                    l.SubItems.assign(cols);

                    for k:=0 to l.subitems.count-1 do begin
                        l.SubItemImages[k]:=-1;
                        w:=canvas.textwidth(l.subitems[k])+20;
                        if lvItems.Columns[k+1].Width<w then lvItems.Columns[k+1].Width:=w;
                    end;
                    l.ImageIndex:=f.getIcon;
                end;
            end;
        end;
    finally
        cols.free;
        lvItems.Items.EndUpdate;
    end;
end;

procedure TExplorerForm.tvItemsExpanding(Sender: TObject; Node: TTreeNode;
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

procedure TExplorerForm.addnodes(parent: TTreeNode; const item: IXPVirtualFile);
var
    i: longint;
    items: TInterfaceList;
    f: IXPVirtualFile;
    p: TTreeNode;
begin
    if item.hasChild then begin
        items:= item.getChildren;
        if assigned(items) then begin
            for i:=0 to items.count-1 do begin
                f:=(items[i] as IXPVirtualFile);
                if (f.hasChild) then begin
                    p:=tvItems.Items.AddChildObject(parent, f.getDisplayName, pointer(f));
                    p.ImageIndex:=f.getIcon;
                    tvItems.Items.AddChildObject(p,'dummy',nil);
                end;
            end;
        end;
    end;
end;

procedure TExplorerForm.tvItemsEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
    allowedit:=false;
end;

procedure TExplorerForm.tvItemsChange(Sender: TObject; Node: TTreeNode);
var
    f: IXPVirtualFile;
begin
    f:=IXPVirtualFile(node.data);
    caption:=f.getDisplayName;
    updateMenus(f);
    updateListView(f);
    updateStatusBar(f);
end;

procedure TExplorerForm.FormShow(Sender: TObject);
begin
    updateall;
end;

procedure TExplorerForm.FormCreate(Sender: TObject);
begin
    //These lines are here to set the font of the menubar
    font.name:='';
    parentfont:=true;

    cbAddress.align:=alClient;

    toolbar2.buttonheight:=28;

    //This must be read from somewhere ;-)
    shortDateFormat:='dd/mm/yyyy';
    longtimeformat:='hh:mm';

    tvItems.Images:=XPExplorer.getImageList;
    lvItems.Images:=XPExplorer.getImageList;    
end;

procedure TExplorerForm.updatestatusbar(const item: IXPVirtualFile);
var
    str: TStringList;
    sp: TStatusPanel;
    i: integer;
begin
    str:=TStringList.create;
    statusbar1.Panels.BeginUpdate;
    try
        item.getStatusData(str);
        statusbar1.Panels.clear;
        for i:=0 to str.count-1 do begin
            sp:=statusbar1.Panels.Add;
            sp.Text:=str[i];
            if sp.text<>'' then sp.Width:=canvas.TextWidth(sp.text)+40;
        end;
        FormResize(self);
    finally
        statusbar1.Panels.EndUpdate;
        str.free;
    end;
end;

procedure TExplorerForm.FormResize(Sender: TObject);
var
    rw: integer;
    i: integer;
begin
    if statusbar1.panels.count>=1 then begin
        rw:=0;
        for i:=1 to statusbar1.Panels.Count-1 do begin
            rw:=rw+statusbar1.Panels[i].Width;
        end;
        statusbar1.Panels[0].Width:=statusbar1.width-rw;
    end;

    if lvItems.columns.count>=1 then begin
        rw:=0;
        for i:=0 to lvItems.columns.Count-2 do begin
            rw:=rw+lvItems.columns[i].Width;
        end;
        lvItems.columns[lvItems.columns.count-1].Width:=lvItems.clientwidth-rw-4;
    end;
end;

procedure TExplorerForm.Close1Click(Sender: TObject);
begin
    close;
end;

procedure TExplorerForm.updatemenus(const item: IXPVirtualFile);
var
    verbs: TStringList;
    i: longint;
    m: TMenuItem;
begin
    s1.caption:=item.getDisplayName;
    verbs:=TStringList.create;
    try
        for i:=FVerbs.count-1 downto 0 do begin
            m:=FVerbs[i];
            FVerbs.delete(i);
            m.free;
        end;
        item.getVerbItems(verbs);

        if tvItems.Selected.Expanded then expand1.caption:='Collapse'
        else expand1.caption:='Expand';
        
        for i:=0 to verbs.count-1 do begin
            m:=TMenuItem.create(self);
            m.Caption:=verbs[i];
            FVerbs.add(m);
            s1.Add(m);
        end;

        for i:=verbs.count-1 downto 0 do begin
            m:=TMenuItem.create(self);
            m.Caption:=verbs[i];
            FVerbs.add(m);
            pmProperties.Items.Insert(miVerbs.menuindex+1,m);
        end;
    finally
        verbs.free;
    end;
end;

constructor TExplorerForm.Create(AOwner: TComponent);
begin
  inherited;
  FVerbs:=TList.create;
end;

destructor TExplorerForm.Destroy;
begin
  FVerbs.free;
  inherited;
end;

end.
