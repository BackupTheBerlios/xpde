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
unit uResourceFileFrm;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, uResources,
  QExtCtrls, uResourceAPI, QMenus;

type
  TResourceFileFrm = class(TForm)
    tvEntries: TTreeView;
    StatusBar1: TStatusBar;
    entryPopup: TPopupMenu;
    Edit1: TMenuItem;
    Rename1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tvEntriesEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure tvEntriesItemClick(Sender: TObject; Button: TMouseButton;
      Node: TTreeNode; const Pt: TPoint);
    procedure Edit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    editors: TList;
    resourceFile:TResourceFile;
    procedure destroyEditors;
    procedure updateResourceTree;
    procedure loadFromFile(const filename:string);
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  end;

var
  ResourceFileFrm: TResourceFileFrm;

implementation

{$R *.xfm}

{ TResourceFileFrm }

constructor TResourceFileFrm.Create(AOwner: TComponent);
begin
  inherited;
  resourceFile:=TResourceFile.create(nil);
  editors:=TList.create;
end;

destructor TResourceFileFrm.Destroy;
begin
    editors.free;
    resourceFile.free;
    inherited;
end;

procedure TResourceFileFrm.loadFromFile(const filename: string);
begin
    resourcefile.loadfromfile(filename);
    caption:=filename;
    updateResourceTree;
end;

procedure TResourceFileFrm.updateResourceTree;
var
    root: TTreeNode;
    catnode: TTreeNode;
    node: TTreeNode;
    i: integer;
    category: string;
    entry: TResourceEntry;
    function FindCategory(const caption:string):TTreeNode;
    var
        k:longint;
    begin
        result:=nil;
        for k:=0 to root.Count-1 do begin
            node:=root[k];
            if (AnsiCompareStr(node.Text,caption)=0) then begin
                result:=node;
                break;
            end;
        end;
    end;
begin
    tvEntries.Items.BeginUpdate;
    try
        tvEntries.Items.clear;
        root:=tvEntries.Items.AddChild(nil,'Resources');
        for i:=0 to resourcefile.resources.count-1 do begin
            entry:=resourcefile.resources[i];
            if entry.resourcetype<>rtNone then category:=ResourceTypeToString(entry.resourcetype)
            else category:=entry.sresourcetype;
            catnode:=FindCategory(category);
            if (not assigned(catnode)) then catnode:=tvEntries.Items.AddChild(root,category);
            node:=tvEntries.Items.AddChildObject(catnode,entry.resourcename,entry);            
        end;
    finally
        tvEntries.items.EndUpdate;
    end;
end;

procedure TResourceFileFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    //Check for modifications before close!!!
    action:=caFree;
    destroyEditors;
end;

procedure TResourceFileFrm.tvEntriesEditing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: Boolean);
begin
    allowedit:=false;
end;

procedure TResourceFileFrm.destroyEditors;
var
    ed: TResourceEditor;
    i:longint;
begin
    //Destroys all the editors
    for i:=editors.count-1 downto 0 do begin
        ed:=editors[i];
        ed.close;
        ed.free;
    end;
end;

procedure TResourceFileFrm.tvEntriesItemClick(Sender: TObject;
  Button: TMouseButton; Node: TTreeNode; const Pt: TPoint);
var
    entry: TResourceEntry;
    ed: TResourceEditor;
begin
    if button=mbRight then begin
        entry:=node.data;
        if assigned(entry) then begin
            //Call the right editor for this entry
            //ed:=ResourceAPI.callEditor(entry);
            //if assigned(ed) then editors.add(ed);
            entryPopup.Popup(pt.x,pt.y);
        end;
    end;
end;

procedure TResourceFileFrm.Edit1Click(Sender: TObject);
var
    entry: TResourceEntry;
    node: TTreeNode;
    ed: TResourceEditor;
begin
    node:=tvEntries.Selected;
    entry:=node.data;
    if assigned(entry) then begin
        //Call the right editor for this entry
        ed:=ResourceAPI.callEditor(entry);
        if assigned(ed) then editors.add(ed);
    end;
end;

end.
