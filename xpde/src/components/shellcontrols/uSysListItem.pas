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
unit uSysListItem;

interface

uses
  SysUtils, Types, Classes, uXPCommon, 
  QGraphics, QControls, QForms, uXPAPI,
  QDialogs, QExtCtrls, Qt, uRegistry,
  QStdCtrls, uXPStyleConsts;

type
  TSysListItem=class;

  TSysItemLabel=class(TCustomControl)
  private
    FCaption: string;
    procedure SetCaption(const Value: string);
  public
    item:TSysListItem;
    procedure DblClick;override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure FontChanged; override;
    procedure ColorChanged; override;    
    function WidgetFlags: Integer; override;
    procedure updatedimensions;
    procedure paint;override;
    constructor Create(AOwner:TComponent);override;
    property Caption:string read FCaption write SetCaption;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property Color;
    property Font;
  end;

  TSysListItem = class(TCustomControl)
  private
    dummy:TSysListItem;
    lastover: TSysListItem;
    moving: boolean;
    realmove: boolean;
    ox,oy: integer;
    background:TBitmap;
    mask: TBitmap;
    selectedbitmap: TBitmap;
    QB: QPixmapH;
    QP: QPainterH;
    acanvas:TCanvas;
    FTransparent: boolean;
    FSelected: boolean;
    FData: string;
    procedure SetTransparent(const Value: boolean);
    function GetCaption: string;
    procedure setCaption(const Value: string);
    procedure SetSelected(const Value: boolean);
    procedure SetData(const Value: string);
  protected
    procedure DrawMask(Canvas: TCanvas); override;
    function WidgetFlags: Integer; override;
    procedure paintWidget(ACanvas:TCanvas);
    procedure Paint;override;
    procedure createMask;
    procedure destroyMask;
  public
    original: TBitmap;
    lnk:boolean;
    inmove:boolean;
    itemText: TSysItemLabel;
    function loadFromRegistry: boolean;
    function savetoRegistry: boolean;
    procedure updateItemText;
    procedure loadImageFromFile(const imgfile:string);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetParent(const Value: TWidgetControl); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    constructor Create(AOwner:TComponent;const imgfile:string;islnk:boolean); reintroduce; overload;
    constructor Create(AOwner:TComponent;fromitem:TSysListItem); reintroduce; overload;
    destructor Destroy;override;
  published
    property Data:string read FData write SetData;
    property Masked;
    property Transparent:boolean read FTransparent write SetTransparent;
    property Caption:string read GetCaption write setCaption;
    property Selected:boolean read FSelected write SetSelected;
    property OnMouseUp;
    property PopupMenu;    
    property OnMouseDown;
    property OnDblClick;    
  end;

implementation

const
    w=32;
    h=33;
    thres=3;

constructor TSysListItem.Create(AOwner: TComponent;const imgfile:string;islnk:boolean);
begin
  inherited Create(AOwner);
  inmove:=false;
  lastover:=nil;
  lnk:=islnk;
  FData:='';
  moving:=false;
  realmove:=false;
  FSelected:=false;
  itemtext:=TSysItemLabel.create(nil);
  itemtext.item:=self;

  controlstyle:=controlstyle+[csCaptureMouse,csNoFocus];
  width:=w;
  height:=h;

  loadimagefromfile(imgfile);
end;

constructor TSysListItem.Create(AOwner: TComponent; fromitem: TSysListItem);
begin
  inherited Create(AOwner);
  inmove:=false;
  lastover:=nil;
  lnk:=fromitem.lnk;
  FData:='';
  FSelected:=fromitem.selected;
  itemtext:=TSysItemLabel.create(nil);
  itemtext.item:=self;
  itemtext.Caption:=fromitem.itemtext.caption;
  background:=TBitmap.create;
  controlstyle:=controlstyle+[csCaptureMouse,csNoFocus];
  width:=w;
  height:=h;

  mask:=TBitmap.create;
  mask.PixelFormat:=pf1bit;

  selectedbitmap:=TBitmap.create;
  selectedbitmap.width:=w;
  selectedbitmap.height:=h;

  original:=TBitmap.create;
  original.assign(fromitem.original);
  original.transparent:=true;

  createMask;

  FTransparent:=fromitem.transparent;
  masked:=fromitem.masked;
  left:=fromitem.left;
  top:=fromitem.top;
  parent:=fromitem.parent;
  visible:=fromitem.visible;

  selectedbitmap.assign(fromitem.selectedbitmap);
end;

procedure TSysListItem.createMask;
begin
  QB := QPixmap_create(self.width, self.height, 1, QPixmapOptimization_DefaultOptim);
  QP := QPainter_create(QB, Handle);
  aCanvas := TCanvas.Create;
  aCanvas.start(false);
  aCanvas.Handle := QP;

  mask.handle:=QPixmap_mask(original.handle);
  acanvas.CopyRect(rect(0,0,self.width,self.height),mask.Canvas,rect(0,0,self.width,self.height));
end;


destructor TSysListItem.Destroy;
begin
  destroymask;
  original.free;
  selectedbitmap.free;
  background.free;
  if not (csDestroying in itemtext.ComponentState) then begin
      itemtext.free;
  end;
  itemtext:=nil;
  inherited;
end;

function TSysListItem.savetoRegistry: boolean;
var
    reg:TRegistry;
begin
    reg:=TRegistry.create;
    try
        if reg.OpenKey('Software/XPde/Desktop/IconLocations/'+caption,true) then begin
            reg.WriteInteger('Left',FLeft);
            reg.WriteInteger('Top',FTop);
            result:=true;
        end
        else result:=false;
    finally
        reg.Free;
    end;
end;

function TSysListItem.loadFromRegistry:boolean;
var
    reg:TRegistry;
begin
    reg:=TRegistry.create;
    try
        if reg.OpenKey('Software/XPde/Desktop/IconLocations/'+caption,false) then begin
            left:=reg.ReadInteger('Left');
            top:=reg.ReadInteger('Top');
            result:=true;
        end
        else result:=false;
    finally
        reg.Free;
    end;
end;


procedure TSysListItem.destroyMask;
begin
  aCanvas.stop;
  aCanvas.free;
  QPainter_destroy(QP);
  QPixmap_destroy(QB);
end;

procedure TSysListItem.DrawMask(Canvas: TCanvas);
begin
    canvas.CopyRect(rect(0,0,self.width,self.height),acanvas,rect(0,0,self.width,self.height));
end;

function TSysListItem.GetCaption: string;
begin
    result:=itemtext.caption;
end;


procedure TSysListItem.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  parent.setfocus;
  application.cancelhint;
  if button=mbLeft then begin
      showhint:=false;
      dummy:=TSysListItem.create(nil,self);
      bringtofront;
      itemtext.bringtofront;
      QPixmap_grabWindow(background.handle,QWidget_winId(parent.handle),0,0,parent.width,parent.height);
      ox:=x;
      oy:=y;
      moving:=true;
  end;
end;
procedure TSysListItem.MouseMove(Shift: TShiftState; X, Y: Integer);
var
    p: TRect;
    i:integer;
    o: TSysListItem;
    d: TObject;
    found: boolean;
    r:TRect;
begin
  inherited;
  if not inmove then begin
    inmove:=true;
    try
  if moving then begin
        if not (realmove) then begin
            if (abs(x-ox)>thres) or (abs(y-oy)>thres) then realmove:=true;
        end
        else begin
            p:=boundsrect;
            p.left:=p.left+(x-ox);
            p.top:=p.top+(y-oy);
            p.right:=p.right+(x-ox);
            p.bottom:=p.bottom+(y-oy);
            boundsrect:=p;
            invalidate;
            itemtext.invalidate;
            found:=false;
            o:=nil;
            for i:=0 to parent.ControlCount-1 do begin
                d:=parent.controls[i];
                if d is TSysListItem then begin
                    o:=(d as TSysListItem);
                    if (o<>dummy) and (o<>self) then begin
                        if IntersectRect(r,o.boundsrect,self.boundsrect) then begin
                            found:=true;
                            break;
                        end;
                    end;
                end;
            end;
            if found then begin
                if assigned(lastover) then begin
                    lastover.selected:=false;
                    background.canvas.draw(lastover.left,lastover.top,lastover.original);
                end;
                lastover:=o;
                lastover.selected:=true;
                background.canvas.draw(lastover.left,lastover.top,lastover.selectedbitmap);
            end
            else begin
                if assigned(lastover) then begin
                    lastover.selected:=false;
                    background.canvas.draw(lastover.left,lastover.top,lastover.original);
                end;
                lastover:=nil;
            end;
        end;
  end;
  finally
    inmove:=false;
  end;
  end;
end;

procedure TSysListItem.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if button=mbLeft then begin
        showhint:=true;
         dummy.free;
        moving:=false;
        realmove:=false;
        invalidate;
        itemtext.invalidate;
        background.free;
        background:=TBitmap.create;
  end;
end;


procedure TSysListItem.Paint;
begin
    paintwidget(canvas);
end;
procedure TSysListItem.paintWidget(ACanvas: TCanvas);
var
    back:TBitmap;
    trans:TBitmap;
begin
    if not realmove then begin
        if FSelected then begin
            acanvas.draw(0,0,selectedbitmap);
        end
        else acanvas.draw(0,0,original);
    end
    else begin
        if FTransparent then begin
            back:=TBitmap.create;
            trans:=TBitmap.create;
            try
                back.width:=self.width;
                back.height:=self.height;
                trans.Width:=self.width;
                trans.height:=self.height;
                back.Canvas.CopyRect(rect(0,0,self.width,self.height),background.canvas,bounds(left,top,self.width,self.height));
                MergeBitmaps(original,back,trans,14);
                acanvas.draw(0,0,trans);
            finally
                trans.free;
                back.free;
            end;
        end
        else begin
            acanvas.draw(0,0,original);
        end;
    end;
end;

procedure TSysListItem.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  updateItemtext;
end;

procedure TSysListItem.setCaption(const Value: string);
begin
    itemtext.Caption:=value;
end;

procedure TSysListItem.SetData(const Value: string);
begin
  FData := Value;
end;



procedure TSysListItem.SetParent(const Value: TWidgetControl);
begin
  inherited;
  if assigned(itemtext) then begin
    itemtext.parent:=parent;
    updateitemtext;
  end;
end;

procedure TSysListItem.SetSelected(const Value: boolean);
begin
    if FSelected<>Value then begin
          FSelected := Value;
          invalidate;
          itemtext.Invalidate;
    end;
end;



procedure TSysListItem.SetTransparent(const Value: boolean);
begin
    if FTransparent<>value then begin
        FTransparent := Value;
    end;
end;

procedure TSysListItem.updateItemText;
var
    tx:integer;
begin
  if assigned(itemtext) then begin
    tx:=((itemtext.width-width) div 2);
    itemtext.left:=left-tx;
    itemtext.top:=top+height+4;
  end;
end;

function TSysListItem.WidgetFlags: Integer;
begin
  Result := inherited WidgetFlags  or Integer(WidgetFlags_WMouseNoMask) or Integer(WidgetFlags_WRepaintNoErase);
end;



{ TSysItemLabel }

procedure TSysItemLabel.ColorChanged;
begin
  inherited;
  updatedimensions;
  invalidate;
end;

constructor TSysItemLabel.Create(AOwner: TComponent);
begin
  inherited;
  controlstyle:=controlstyle+[csCaptureMouse];
  width:=80;
  height:=20;
  Caption:='My Computer';
end;

procedure TSysItemLabel.DblClick;
begin
  inherited;
  item.dblclick;    
end;

procedure TSysItemLabel.FontChanged;
begin
  inherited;
  updatedimensions;
  invalidate;  
end;

procedure TSysItemLabel.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
    inherited;
    item.MouseDown(button,shift,x,y);
end;

procedure TSysItemLabel.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
    inherited;
    item.MouseMove(shift,x,y);
end;

procedure TSysItemLabel.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
    inherited;
    item.MouseUp(button,shift,x,y);
end;

procedure TSysItemLabel.paint;
var
    r:TRect;
    text: TBitmap;
    back: TBitmap;
    trans:TBitmap;    
begin
    with canvas do begin
        if item.Transparent and item.realmove then begin
            text:=TBitmap.create;
            back:=TBitmap.create;
            trans:=TBitmap.create;
            try
                text.width:=self.width;
                text.height:=self.height;
                text.canvas.font.assign(self.font);
                if item.Selected then begin
                    text.canvas.pen.color:=dclHighlight;
                    text.canvas.brush.color:=dclHighlight;
                end
                else begin
                    text.canvas.pen.color:=self.color;
                    text.canvas.brush.color:=self.color;
                end;
                r:=clientrect;
                text.canvas.rectangle(r);
                text.canvas.TextRect(r,0,-1,FCaption,1036);

                back.width:=self.width;
                back.height:=self.height;
                trans.Width:=self.width;
                trans.height:=self.height;

                back.Canvas.CopyRect(rect(0,0,self.width,self.height),item.background.canvas,bounds(self.left,self.top,self.width,self.height));
                MergeBitmaps(text,back,trans,14);

                draw(0,0,trans);

            finally
                text.free;
                trans.free;
                back.free;
            end;
        end
        else begin
                if item.Selected then begin
                    canvas.pen.color:=dclHighlight;
                    canvas.brush.color:=dclHighlight;
                end
                else begin
                    pen.color:=self.color;
                    brush.color:=self.color;
                end;
                font.assign(self.font);
                r:=clientrect;
                rectangle(r);
                TextRect(r,0,-1,FCaption,1036);
        end;
    end;
end;

procedure TSysItemLabel.SetCaption(const Value: string);
begin
    if FCaption<>Value then begin
        FCaption := Value;
        updatedimensions;
        invalidate;
    end;
end;

procedure TSysItemLabel.updatedimensions;
var
    maxtext:integer;
    r:TRect;
    aw,ah: integer;
begin
    with canvas do begin
        font.assign(self.font);
        maxtext:=(w*2)+10;
        r:=Rect(0,0,maxtext,canvas.TextHeight(FCaption));
        TextExtent(FCaption,r,1036);
        r.left:=r.Left-2;
        r.right:=r.right+2;

        aw:=(r.right-r.Left);
        ah:=(r.Bottom-r.top);
        if aw<>self.width then self.width:=aw;
        if ah<>self.height then self.height:=ah;
    end;

end;

function TSysItemLabel.WidgetFlags: Integer;
begin
  Result := inherited WidgetFlags  or Integer(WidgetFlags_WRepaintNoErase);
end;

procedure TSysListItem.loadImageFromFile(const imgfile: string);
var
    f: TPicture;
    b: TBitmap;
begin
  if assigned(background) then background.free;
  background:=TBitmap.create;
  if assigned(mask) then mask.free;
  mask:=TBitmap.create;
  mask.PixelFormat:=pf1bit;
  if assigned(selectedbitmap) then selectedbitmap.free;
  selectedbitmap:=TBitmap.create;
  selectedbitmap.width:=w;
  selectedbitmap.height:=h;

  original:=TBitmap.create;
  f:=TPicture.create;
  try
    f.LoadFromFile(imgfile);
    f.Graphic.Width:=w;
    f.Graphic.Height:=h-1;
    original.width:=w;
    original.height:=h;
    original.Canvas.Brush.Color:=clFuchsia;
    original.Canvas.Draw(0,0,f.graphic);
  finally
    f.free;
  end;

  original.transparent:=true;

  if lnk then begin
    b:=TBitmap.create;
    try
        b.loadfromfile(XPAPI.getSysInfo(siMiscDir)+gSHORTCUT);
        b.transparent:=false;
        original.canvas.draw(0,original.height-b.height-1,b);
        original.Transparent:=false;
        original.Transparent:=true;
    finally
        b.free;
    end;
  end;

  createMask;


  FTransparent:=true;
  masked:=true;

  MaskedBitmap(original,selectedbitmap);


  selectedbitmap.transparent:=false;
  selectedbitmap.transparent:=true;

  if lnk then begin
    b:=TBitmap.create;
    try
        b.loadfromfile(XPAPI.getSysInfo(siMiscDir)+gSHORTCUT);
        b.transparent:=false;
        selectedbitmap.canvas.draw(0,original.height-b.height-1,b);
    finally
        b.free;
    end;
  end;
end;

end.
