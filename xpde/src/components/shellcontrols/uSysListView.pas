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
unit uSysListView;

interface

uses
  SysUtils, Types, Classes, uSysListItem,
  QGraphics, QControls, QForms, Qt,
  QDialogs, QExtCtrls, uXPStyleConsts,
  resample;

type
  TDirection=(dRight,dLeft,dUp,dDown);

  TSysListView = class(TCustomPanel)
  private
    FItems: TList;
    FAlignToGrid: boolean;
    FHorizontalSpacing: integer;
    FVerticalSpacing: integer;
    FSelected: TSysListItem;
    procedure SetAlignToGrid(const Value: boolean);
    procedure SetHorizontalSpacing(const Value: integer);
    procedure SetVerticalSpacing(const Value: integer);
    procedure GetDefaultCoords(var x, y: integer; icon: TSysListItem);
    function FindItem(x, y: integer; exclude: TSysListItem=nil): TSysListItem;
    procedure SetSelected(const Value: TSysListItem);
    function FindNextItem(current: TSysListItem;
      direction: TDirection): TSysListItem;
    { Private declarations }
  protected
    { Protected declarations }
    procedure OnItemDblClick(Sender: TObject);    
    procedure OnItemMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnItemMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    { Public declarations }
    procedure GetAlignedCoords(var x, y: integer);    
    procedure alignIcons;
    procedure clearbackground;
    function addItem(const Caption, Image:string;islnk:boolean):TSysListItem;
    procedure setDesktopImage(const filename: string; amethod: integer);
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    property Items:TList read FItems;
  published
    { Published declarations }
    property Selected:TSysListItem read FSelected write SetSelected;
    property HorizontalSpacing:integer read FHorizontalSpacing write SetHorizontalSpacing;
    property VerticalSpacing:integer read FVerticalSpacing write SetVerticalSpacing;
    property AlignToGrid:boolean read FAlignToGrid write SetAlignToGrid;
    property Align default alNone;
    property Alignment;
    property Anchors;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property Bitmap;
    property BorderWidth;
    property BorderStyle;
    property Caption;
    property Color default clBackground;
    property Constraints;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default False;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
  end;

procedure Register;

const
    w=32;
    h=32;

implementation

procedure Register;
begin
  RegisterComponents('XPde', [TSysListView]);
end;

{ TSysListView }

function TSysListView.FindItem(x, y: integer;exclude:TSysListItem=nil): TSysListItem;
var
    i:longint;
    d:TSysListItem;
    p: TPoint;
    r: TRect;
begin
    result:=nil;
    p:=Point(x,y);
    for i:=0 to items.count-1 do begin
        d:=items[i];
        if d<>exclude then begin
            UnionRect(r,d.BoundsRect,d.itemText.BoundsRect);
            if PtInRect(r,p) then begin
                result:=d;
                break;
            end;
        end;
    end;
end;

procedure TSysListView.GetDefaultCoords(var x, y: integer;icon:TSysListItem);
var
    cx,cy:integer;
begin
    cx:=0;
    while cx<width do begin
        cy:=0;
        while cy<height do begin
            GetAlignedCoords(cx,cy);
            if (not assigned(FindItem(cx,cy))) then begin
                if (icon.height+4+icon.itemtext.height+cy)<=clientheight then begin
                    x:=cx;
                    y:=cy;
                    exit;
                end;
            end;
            inc(cy, FVerticalSpacing*2);
        end;
        inc(cx, FHorizontalSpacing*2);
    end;
end;

procedure TSysListView.GetAlignedCoords(var x, y: integer);
var
    dx: integer;
    dy: integer;
begin
    dx:=(FHorizontalSpacing*2)-6;
    if dx>200 then dx:=200;
    x:=x+w;

    dy:=(FVerticalSpacing*2)-5;
    if dy>190 then dy:=190;
    y:=y+h;

    x:=(trunc(x / dx) * dx)+(FHorizontalSpacing div 2)+3;
    y:=(trunc(y / dy) * dy)+2;
end;

function TSysListView.addItem(const Caption, Image: string;islnk:boolean): TSysListItem;
var
    ax,ay:integer;
begin
    result:=TSysListItem.create(nil,image,islnk);
    result.caption:=Caption;
    if not result.loadFromRegistry then begin
        GetDefaultCoords(ax,ay,result);
        result.left:=ax;
        result.Top:=ay;
    end;
    result.parent:=self;
    result.hint:=Caption;
    result.showhint:=true;
    result.itemtext.hint:=Caption;
    result.itemtext.showhint:=true;
    result.ondblclick:=OnItemdblclick;
    result.onmouseup:=OnItemMouseUp;
    result.onmousedown:=OnItemMousedown;
    FItems.add(result);
end;

procedure TSysListView.alignIcons;
begin

end;

constructor TSysListView.Create(AOwner: TComponent);
begin
  inherited;
  InputKeys := [ikArrows];
  ControlStyle:=ControlStyle-[csNoFocus];
  FSelected:=nil;
  FHorizontalSpacing:=43;
  FVerticalSpacing:=43;
  FAlignToGrid:=true;
  FItems:=TList.create;
  bevelouter:=bvNone;
  caption:='';
  color:=dclBtnHighlight;
  TabStop:=true;
end;

destructor TSysListView.Destroy;
begin
  FItems.free;
  inherited;
end;


procedure TSysListView.OnItemMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    item: TSysListItem;
    l,t: integer;
begin
    item:=(sender as TSysListItem);
    if FAlignToGrid then begin
        l:=item.left;
        t:=item.top;
        GetAlignedCoords(l,t);
        item.left:=l;
        item.top:=t;
    end;
    item.savetoregistry;
end;

procedure TSysListView.SetAlignToGrid(const Value: boolean);
begin
    if FAlignToGrid<>Value then begin
        FAlignToGrid := Value;
        alignicons;
    end;
end;

procedure TSysListView.SetHorizontalSpacing(const Value: integer);
begin
    if FHorizontalSpacing<>Value then begin
        FHorizontalSpacing:=Value;
        alignIcons;
    end;
end;

procedure TSysListView.SetVerticalSpacing(const Value: integer);
begin
  if FVerticalSpacing<>Value then begin
      FVerticalSpacing := Value;
      alignIcons;
  end;
end;

procedure TSysListView.clearbackground;
begin
    bitmap.width:=clientwidth;
    bitmap.height:=clientwidth;
    bitmap.canvas.brush.color:=color;
    bitmap.canvas.fillrect(clientrect);
end;

procedure TSysListView.setDesktopImage(const filename: string;amethod:integer);
var
    b: TBitmap;
    c: TBitmap;
    ax,ay:integer;
begin
    if fileexists(filename) then begin
        b:=TBitmap.create;
        c:=TBitmap.create;
        try
            b.loadfromfile(filename);
            bitmap.canvas.Brush.color:=self.color;
            bitmap.canvas.pen.color:=self.color;
            bitmap.width:=width;
            bitmap.height:=height;

            c.width:=width;
            c.height:=height;
            bitmap.Canvas.Rectangle(0,0,width,height);

            case amethod of
                0: begin
                    ax:=(bitmap.width-b.Width) div 2;
                    ay:=(bitmap.height-b.height) div 2;
                    bitmap.Canvas.draw(ax,ay,b);
                end;
                1: begin
                    ax:=0;
                    while (ax<bitmap.width) do begin
                        ay:=0;
                        while (ay<bitmap.height) do begin
                            bitmap.Canvas.draw(ax,ay,b);
                            inc(ay,b.height);
                        end;
                        inc(ax,b.width);
                    end;
                end;
                2: begin
                    //bitmap.canvas.StretchDraw(clientrect,b);
                    //bitmap.assign(b);
                    Strecth(b,c,resampleFilters[1].filter,resamplefilters[1].width);
                    bitmap.assign(c);
                end;
            end;

        finally
            c.free;
            b.free;
        end;
    end;
end;

procedure TSysListView.OnItemMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    selected:=(sender as TSysListItem);
    setfocus;
end;

procedure TSysListView.SetSelected(const Value: TSysListItem);
begin
    if FSelected<>Value then begin
        if assigned(FSelected) then FSelected.selected:=false;
        FSelected:=value;
        if assigned(FSelected) then FSelected.Selected:=true;
    end;
end;

procedure TSysListView.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  selected:=nil;
  setfocus;
end;

procedure TSysListView.OnItemDblClick(Sender: TObject);
begin
    if assigned(OnDblClick) then OnDblClick(self);
end;

function TSysListView.FindNextItem(current:TSysListItem;direction: TDirection):TSysListItem;
var
    origr: TRect;
    searchr:TRect;
    x,y: integer;
    maxx,maxy: integer;
    ix,iy: integer;
    w,h: integer;

    function finditematrect(brect:TRect):TSysListItem;
    var
        d: TObject;
        o: TSysListItem;
        r: TRect;
        i:integer;
    begin
            result:=nil;
            for i:=0 to ControlCount-1 do begin
                d:=controls[i];
                if d is TSysListItem then begin
                    o:=(d as TSysListItem);
                    if IntersectRect(r,o.boundsrect,brect) then begin
                        result:=o;
                        break;
                    end;
                end;
            end;
    end;
begin
    result:=nil;
    if assigned(current) then begin
        origr:=current.BoundsRect;
        searchr:=origr;
        w:=current.width;
        h:=current.height;
        case direction of
            dRight: begin
                searchr.left:=searchr.Right;
                searchr.right:=searchr.left+w;
                ix:=searchr.left;
                y:=searchr.top;
                maxx:=self.Width;
                maxy:=y+(h*4);
                while (y<=maxy) do begin
                    x:=ix;
                    while(x<=maxx) do begin
                        searchr:=rect(x,y,x+w,y+h);
                        result:=finditematrect(searchr);
                        if assigned(result) then break;
                        inc(x,w);
                    end;
                    if assigned(result) then break;
                    inc(y,h);
                end;
            end;
            dLeft: begin
                searchr.right:=searchr.left;
                searchr.left:=searchr.Right-w;
                ix:=searchr.left;
                y:=searchr.top;
                maxx:=0;
                maxy:=y+(h*4);
                while (y<=maxy) do begin
                    x:=ix;
                    while(x>=maxx) do begin
                        searchr:=rect(x,y,x+w,y+h);
                        result:=finditematrect(searchr);
                        if assigned(result) then break;
                        dec(x,w);
                    end;
                    if assigned(result) then break;
                    inc(y,h);
                end;
            end;
            dDown: begin
                searchr.top:=searchr.bottom;
                searchr.bottom:=searchr.left+h;
                iy:=searchr.top;
                x:=searchr.left;
                maxx:=x+(w*4);
                maxy:=self.height;
                while (x<=maxx) do begin
                    y:=iy;
                    while(y<=maxy) do begin
                        searchr:=rect(x,y,x+w,y+h);
                        result:=finditematrect(searchr);
                        if assigned(result) then break;
                        inc(y,h);
                    end;
                    if assigned(result) then break;
                    inc(x,w);
                end;
            end;
            dUp: begin
                searchr.bottom:=searchr.top;
                searchr.top:=searchr.bottom-h;
                iy:=searchr.top;
                x:=searchr.left;
                maxx:=x+(w*4);
                maxy:=0;
                while (x<=maxx) do begin
                    y:=iy;
                    while(y>=maxy) do begin
                        searchr:=rect(x,y,x+w,y+h);
                        result:=finditematrect(searchr);
                        if assigned(result) then break;
                        dec(y,h);
                    end;
                    if assigned(result) then break;
                    inc(x,w);
                end;
            end;
        end;
    end
    else begin
        if items.count>=1 then result:=items[0]
        else result:=nil;
    end;
end;

procedure TSysListView.KeyDown(var Key: Word; Shift: TShiftState);
var
    d: TSysListItem;
begin
    d:=nil;
    case key of
        key_left: begin
            d:=findnextitem(selected,dLeft);
        end;
        key_up: begin
            d:=findnextitem(selected,dUp);
        end;
        key_down: begin
            d:=findnextitem(selected,dDown);
        end;
        key_right: begin
            d:=findnextitem(selected,dRight);
        end;
        key_return,key_enter: begin
            OnItemDblClick(self);
        end;
    end;
    if assigned(d) then selected:=d;
  inherited;
end;

end.
