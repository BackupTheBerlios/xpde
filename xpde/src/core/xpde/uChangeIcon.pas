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
unit uChangeIcon;

interface

uses
  SysUtils, Types, Classes,
  QGraphics, QControls, QForms,
  uXPStyleConsts, QDialogs, QStdCtrls,
  uXPAPI, uXPAPI_imp, QComCtrls,
  QImgList, uXPLocalizator, uXPdeconsts;

type
  TChangeIconDlg = class(TForm)
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Label2:TLabel;
    btnBrowse: TButton;
    edDirectory: TEdit;
        Label1:TLabel;
    ivIcons: TIconView;
    images: TImageList;
    XPLocalizator1: TXPLocalizator;
    procedure FormShow(Sender: TObject);
    procedure edDirectoryChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    icondir:string;
    iconfilename: string;
    iconslist:TStringList;
    procedure updateList;
  end;

var
  ChangeIconDlg: TChangeIconDlg;

implementation

uses uDesktopMain;



{$R *.xfm}
procedure TChangeIconDlg.FormShow(Sender: TObject);
begin
    left:=(screen.width-clientwidth) div 2;
    top:=(screen.height-clientheight) div 2;
    if trim(icondir)='' then begin
        icondir:=XPAPI.getSysInfo(siSystemDir);
    end;
    if (iconfilename='') then begin
        iconfilename:=icondir+gNOICON;
    end;
    edDirectory.text:='';
    edDirectory.text:=icondir;
end;


procedure TChangeIconDlg.updateList;
var
    sr: TSearchRec;
    list: TStringList;
    exts: TStringList;
    i:integer;
    li: TIconViewItem;
    f: TPicture;
    b: TBitmap;
    img: integer;
    ts: TIconViewItem;
    direct:string;
begin
    ts:=nil;
    if directoryexists(edDirectory.text) then begin
        list:=TStringList.create;
        exts:=TStringList.create;
        ivIcons.items.beginupdate;
        try
            exts.add('*.ico');
            exts.add('*.bmp');
            exts.add('*.xpm');
            exts.add('*.png');
            direct:=edDirectory.text;
            if direct[length(direct)]<>'/' then direct:=direct+'/';
            for i:=0 to exts.count-1 do begin
                if findfirst(direct+exts[i],faAnyFile,sr)=0 then begin
                    repeat
                           list.add(sr.PathOnly+sr.name);
                    until findnext(sr)<>0;
                    findclose(sr);
                end;
            end;
            ivIcons.items.clear;
            ts:=nil;
            images.Clear;
            iconslist.clear;
            for i:=0 to list.count-1 do begin
                try
                    f:=TPicture.create;
                    b:=TBitmap.create;
                    try
                        b.width:=32;
                        b.height:=33;
                        b.canvas.brush.color:=clFuchsia;
                        f.LoadFromFile(list[i]);
                        f.Graphic.width:=32;
                        f.Graphic.height:=32;
                        b.canvas.draw(0,0,f.graphic);
                        img:=images.Add(b,nil);
                        li:=ivIcons.items.add;
                        if iconfilename=list[i] then begin
                            ts:=li;
                        end;
                        li.ImageIndex:=img;
                        li.AllowRename:=false;
                        li.Caption:=format('%.3d',[img]);
                        iconslist.add(list[i]);
                    finally
                        f.free;
                        b.free;
                    end;
                except
                end;
            end;
        finally
            ivIcons.items.endupdate;
            ivIcons.selected:=ts;
            if assigned(ts) then ivIcons.EnsureItemVisible(ivIcons.selected);
            exts.free;
            list.free;
        end;
    end;
end;
procedure TChangeIconDlg.edDirectoryChange(Sender: TObject);
begin
    updateList;
end;

procedure TChangeIconDlg.FormCreate(Sender: TObject);
begin
    iconsList:=TStringList.create;
end;

procedure TChangeIconDlg.FormDestroy(Sender: TObject);
begin
    iconslist.free;
end;

procedure TChangeIconDlg.Button3Click(Sender: TObject);
begin
    iconfilename:=iconslist[ivIcons.selected.imageindex];
end;

procedure TChangeIconDlg.btnBrowseClick(Sender: TObject);
var
    dir:widestring;
begin
    dir:=edDirectory.text;
    if SelectDirectory(sSelectADirectory,'/',dir,true) then begin
        edDirectory.text:=dir;
    end;
end;


end.
