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
unit main;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, uXPAPI,
  uExplorerAPI, QExtCtrls, Qt,
  QMenus, QImgList, QButtons,
  uQXPComCtrls;

type
  TExplorerForm = class(TForm)
    StatusBar1: TStatusBar;
    lvItems: TListView;
    spLeft: TSplitter;
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
    sbBack: TSpeedButton;
    sbNext: TSpeedButton;
    sbUp: TSpeedButton;
    sbSearch: TSpeedButton;
    sbFolders: TSpeedButton;
    sbMove: TSpeedButton;
    sbCopy: TSpeedButton;
    sbStop: TSpeedButton;
    sbUndo: TSpeedButton;
    ToolButton1: TToolButton;
    sbView: TSpeedButton;
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
    pnFolders: TPanel;
    tvItems: TTreeView;
    Panel2: TPanel;
    pmProperties: TPopupMenu;
    Expand1: TMenuItem;
    miVerbs: TMenuItem;
    cbAddress: TComboBox;
    Panel3: TPanel;
    pmItemProperties: TPopupMenu;
    About1: TMenuItem;
    procedure tvItemsExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvItemsEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure tvItemsChange(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Expand1Click(Sender: TObject);
    procedure pmPropertiesPopup(Sender: TObject);
    procedure lvItemsEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure lvItemsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure sbFoldersClick(Sender: TObject);
    procedure lvItemsItemDoubleClick(Sender: TObject; Item: TListItem);
    procedure sbUpClick(Sender: TObject);
    procedure pmItemPropertiesPopup(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
  private
    { Private declarations }
    FVerbs: TList;
    FItemVerbs: TList;
    procedure ItemPropertiesClick(Sender: TObject);
    procedure PropertiesClick(Sender: TObject);
  public
    { Public declarations }
    procedure ChildrenNotified(const sender: IXPVirtualFile; const op: TXPChildrenOperation; const item: IXPVirtualFile);
    procedure updateall;
    procedure setLocation(const location:string);
    procedure populatenodes(parent: TTreeNode; const item: IXPVirtualFile);
    procedure addnodes(parent: TTreeNode; const item: IXPVirtualFile);
    procedure updatelistview(const item: IXPVirtualFile);
    procedure updatestatusbar(const item: IXPVirtualFile);
    procedure updatemenus(const item: IXPVirtualFile);
    procedure updateitemsmenu(const item: IXPVirtualFile);
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
    item.setNode(n);
    n.ImageIndex:=item.getIcon;
    if item.hasChild then begin
        items:= item.getChildren;
        if assigned(items) then begin
            for i:=0 to items.count-1 do begin
                f:=(items[i] as IXPVirtualFile);
                f.setChildrenModified(ChildrenNotified);
                p:=tvItems.Items.AddChildObject(n, f.getDisplayName, pointer(f));
                f.setNode(p);
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
        tvItems.Selected:=tvItems.Items[0];
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
    w: integer;
    procedure addItem;
    var
        k: integer;
    begin
        l:=lvItems.Items.Add;
        l.Data:=TObject(f);
        f.setChildrenModified(ChildrenNotified);
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
                    if f.hasChild then begin
                        addItem;
                    end;
                end;

                for i:=0 to items.count-1 do begin
                    f:=(items[i] as IXPVirtualFile);
                    if not f.hasChild then begin
                        addItem;
                    end;
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
                    f.setNode(p);
                    f.setChildrenModified(ChildrenNotified);
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
    if paramstr(1)<>'' then setLocation(paramstr(1));
end;

procedure TExplorerForm.FormCreate(Sender: TObject);
begin
    sbBack.Glyph.LoadFromFile(XPAPI.getsysinfo(siMediumSystemDir)+'back.png');
    sbNext.Glyph.LoadFromFile(XPAPI.getsysinfo(siMediumSystemDir)+'forward.png');
    sbUp.Glyph.LoadFromFile(XPAPI.getsysinfo(siMediumSystemDir)+'up.png');
    sbSearch.Glyph.LoadFromFile(XPAPI.getsysinfo(siMediumSystemDir)+'find.png');
    sbFolders.Glyph.LoadFromFile(XPAPI.getsysinfo(siMediumSystemDir)+'folder.png');
//    sbMove.Glyph.LoadFromFile(XPAPI.getsysinfo(siMediumSystemDir)+'moveto.png');
//    sbCopy.Glyph.LoadFromFile(XPAPI.getsysinfo(siMediumSystemDir)+'copyto.png');
    sbStop.Glyph.LoadFromFile(XPAPI.getsysinfo(siMediumSystemDir)+'stop.png');
    sbUndo.Glyph.LoadFromFile(XPAPI.getsysinfo(siMediumSystemDir)+'reload.png');
    sbView.Glyph.LoadFromFile(XPAPI.getsysinfo(siMediumSystemDir)+'view_folders.png');                            

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

    
        for i:=0 to verbs.count-1 do begin
            m:=TMenuItem.create(self);
            m.Caption:=verbs[i];
            m.Tag:=i;
            m.OnClick:=PropertiesClick;
            FVerbs.add(m);
            s1.Add(m);
        end;

        for i:=verbs.count-1 downto 0 do begin
            m:=TMenuItem.create(self);
            m.Caption:=verbs[i];
            m.tag:=i;
            m.OnClick:=PropertiesClick;
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
  FItemVerbs:=TList.create;
end;

destructor TExplorerForm.Destroy;
begin
  FItemVerbs.free;
  FVerbs.free;
  inherited;
end;

procedure TExplorerForm.Expand1Click(Sender: TObject);
begin
    if tvitems.Selected.Expanded then tvItems.selected.Collapse(false)
    else tvItems.selected.expand(false);
end;

procedure TExplorerForm.pmPropertiesPopup(Sender: TObject);
var
    f: IXPVirtualFile;
begin
    if assigned(tvItems.selected) then begin
        if tvItems.Selected.Expanded then expand1.caption:='Collapse'
        else expand1.caption:='Expand';

        f:=IXPVirtualFile(tvItems.selected.data);
        updateMenus(f);
    end
    else begin
        expand1.caption:='Expand';
    end;
end;

procedure TExplorerForm.lvItemsEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
    allowedit:=false;
end;

procedure TExplorerForm.lvItemsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
    f: IXPVirtualFile;
begin
    f:=IXPVirtualFile(item.data);
    updateitemsmenu(f);
end;

procedure TExplorerForm.sbFoldersClick(Sender: TObject);
begin
    pnFolders.visible:=not sbFolders.down;
    spLeft.visible:=pnFolders.visible;
    spLeft.left:=pnFolders.BoundsRect.right;
end;

procedure TExplorerForm.lvItemsItemDoubleClick(Sender: TObject;
  Item: TListItem);
var
    f: IXPVirtualFile;
    n: TTreeNode;
begin
    tvItems.Selected.expand(false);
    f:=IXPVirtualFile(item.data);
    n:=f.getNode as TTreeNode;
    if assigned(n) then begin
        tvItems.selected:=n;
        tvItems.Selected.MakeVisible;
    end
    else begin
        f.doubleclick;
    end;
end;

procedure TExplorerForm.sbUpClick(Sender: TObject);
begin
    if (assigned(tvitems.selected)) then begin
        if (assigned(tvitems.selected.parent)) then begin
            tvItems.Selected:=tvItems.selected.Parent;
            tvItems.Selected.MakeVisible;
        end;
    end;
end;

procedure TExplorerForm.ItemPropertiesClick(Sender: TObject);
var
    f: IXPVirtualFile;
begin
    if assigned(lvItems.selected) then begin
        f:=IXPVirtualFile(lvItems.selected.data);
        f.executeVerb((sender as TMenuItem).tag);
    end
    else begin
        if assigned(tvItems.selected) then begin
            f:=IXPVirtualFile(tvItems.selected.data);
            f.executeVerb((sender as TMenuItem).tag);
        end;
    end;
end;

procedure TExplorerForm.updateitemsmenu(const item: IXPVirtualFile);
var
    itemverbs: TStringList;
    i: longint;
    m: TMenuItem;
begin
    itemverbs:=TStringList.create;
    try
        for i:=Fitemverbs.count-1 downto 0 do begin
            m:=Fitemverbs[i];
            Fitemverbs.delete(i);
            m.free;
        end;
        item.getVerbItems(itemverbs);

        for i:=itemverbs.count-1 downto 0 do begin
            m:=TMenuItem.create(self);
            m.Caption:=itemverbs[i];
            Fitemverbs.add(m);
            m.tag:=i;
            m.OnClick:=ItemPropertiesClick;
            pmItemProperties.Items.Insert(0,m);
        end;
    finally
        itemverbs.free;
    end;
end;

procedure TExplorerForm.pmItemPropertiesPopup(Sender: TObject);
var
    f: IXPVirtualFile;
begin
    if not assigned(lvItems.Selected) then begin
        f:=IXPVirtualFile(tvItems.selected.data);
        updateitemsmenu(f);
    end;
end;

procedure TExplorerForm.About1Click(Sender: TObject);
begin
    XPAPI.showaboutdlg('XPde File Explorer');
end;

procedure TExplorerForm.Copy1Click(Sender: TObject);
begin
    XPExplorer.copycurrentselectiontoclipboard;
end;

procedure TExplorerForm.ChildrenNotified(const sender: IXPVirtualFile;
  const op: TXPChildrenOperation; const item: IXPVirtualFile);
var
    f: IXPVirtualFile;
    procedure addItem;
    var
        k: integer;
        l: TListItem;
        cols: TStringList;
        w: integer;
    begin
        cols:=TStringList.create;
        try
            l:=lvItems.Items.Add;
            l.Data:=TObject(item);
            item.setChildrenModified(ChildrenNotified);
            item.getcolumndata(cols);
            l.Caption:=item.getDisplayName;
            l.SubItems.assign(cols);
            for k:=0 to l.subitems.count-1 do begin
                l.SubItemImages[k]:=-1;
                w:=canvas.textwidth(l.subitems[k])+20;
                if lvItems.Columns[k+1].Width<w then lvItems.Columns[k+1].Width:=w;
            end;
            l.ImageIndex:=item.getIcon;
            QListView_clearSelection(lvItems.Handle);
            l.Selected:=true;
            l.MakeVisible;
        finally
            cols.free;
        end;
    end;
begin
    f:=IXPVirtualFile(tvItems.selected.data);
    if f=sender then begin
        case op of
            coAdd: begin
                addItem;
            end;
        end;
    end;
end;

procedure TExplorerForm.PropertiesClick(Sender: TObject);
var
    f: IXPVirtualFile;
begin
    if assigned(tvItems.selected) then begin
        f:=IXPVirtualFile(tvItems.selected.data);
        f.executeVerb((sender as TMenuItem).tag);
    end;
end;

procedure TExplorerForm.setLocation(const location: string);
var
    i: longint;
    roots: TInterfaceList;
    f: IXPVirtualFile;
    a: IXPVirtualFile;
    pieces: TStringList;
    k: integer;
    l: integer;
    n: TTreeNode;
    r: TTreeNode;
    cl: string;
    sl: string;
begin
    r:=tvItems.Items[0];
    for i:=0 to r.count-1 do begin
        n:=r.Item[i];
        f:=IXPVirtualFile(n.data);
        if f.locationExists(location) then begin
            n.Expand(false);
            pieces:=TStringList.create;
            try
                f.striplocation(location,pieces);
                cl:='';
                for k:=0 to pieces.count-1 do begin
                    cl:=cl+pieces[k];
                    for l:=0 to n.Count-1 do begin
                        a:=IXPVirtualFile(n.item[l].data);
                        sl:=a.getUniqueID;
                        if sl=cl then begin
                            n:=n.Item[l];
                            n.Expand(false);
                            break;
                        end;
                    end;
                end;
            finally
                pieces.free;
            end;
            n.Selected:=true;
            n.MakeVisible;
            break;
        end;
    end;
end;

end.
