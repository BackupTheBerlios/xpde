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
unit uXPListview;

interface

uses
    QComCtrls,Classes, QForms,
    QStdCtrls,Types, Sysutils,
    QDialogs, QGraphics, QControls,
    Qt, uXPImageList, Math, uXPCommon;


type
    //Forward declarations
    TXPListItem=class;
    TXPListItems=class;

    TXPViewStyle=(vsIcon, vsDetail);

    //Listview control, based on TCustomControl, needs the focus
    TXPListview=class(TCustomControl)
    private
        //Scrollbars
        FVertScrollBar: TScrollbar;
        FHorzScrollBar: TScrollbar;

        //Header
        FHeaderControl: THeaderControl;

        //List of items
        FItems: TXPListItems;

        //Horizontal and Vertical spacing
        FIconHSpacing: integer;
        FIconVSpacing: integer;

        //ImageList for items
        FImageList: TXPImageList;
        FSelected: TXPListItem;
        FIconSize: integer;

        //Last scrollcode
        lastcode: TScrollCode;

        FViewStyle: TXPViewStyle;
        FSmallIconSize: integer;
        FSmallImageList: TXPImageList;
    FViewOrigin: TPoint;

        procedure SetVertScrollBar(const Value: TScrollbar);
        procedure SetHorzScrollBar(const Value: TScrollbar);
        procedure SetItems(const Value: TXPListItems);
        procedure SetIconVSpacing(const Value: integer);
        procedure SetIconHSpacing(const Value: integer);
        procedure SetImageList(const Value: TXPImageList);

        //Handy functions for calculations
        function IconsPerRow: integer;
        function IconsPerCol: integer;
        function HiddenRows:integer;
        function RowHeight:integer;
        function ColWidth: integer;
        procedure SetSelected(const Value: TXPListItem);
        procedure SetIconSize(const Value: integer);
        procedure SetViewStyle(const Value: TXPViewStyle);
        procedure SetSmallIconSize(const Value: integer);
        procedure SetSmallImageList(const Value: TXPImageList);
    procedure SetViewOrigin(const Value: TPoint);
    protected
        procedure InvalidateClientRect;
        //Called when the mouse wheel is rotated
        function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; const MousePos: TPoint): Boolean; override;
        //Called when the mouse buttons are pressed
        procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
        //Fired when scrollbars change
        procedure VertScrollBarsScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
        procedure HorzScrollBarsScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
        //Used to prevent blinking
        function WidgetFlags: Integer; override;
        //When scrollbars are visible, the client rect must be returned accordingly
        function getClientRect: TRect; override;
        //Update scrollbars depending on control dimensions and content
        procedure updateScrollBars;
        procedure HeaderControlSectionResize(HeaderControl: TCustomHeaderControl; Section: TCustomHeaderSection);
        procedure genericInvalidate(sender:TObject);
    public
        function GetLeftOrigin:integer;
        //When control size is changed
        procedure ChangeBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
        //Repaints the control
        procedure paint;override;
        constructor Create(AOwner:TComponent);override;
        destructor Destroy;override;
        property ViewOrigin: TPoint read FViewOrigin write SetViewOrigin;
    published
        property Color;
        property Font;
        property VertScrollBar: TScrollbar read FVertScrollBar write SetVertScrollBar;
        property HorzScrollBar: TScrollbar read FHorzScrollBar write SetHorzScrollBar;
        property Items: TXPListItems read FItems write SetItems;
        property IconHSpacing: integer read FIconHSpacing write SetIconHSpacing;
        property IconVSpacing: integer read FIconVSpacing write SetIconVSpacing;
        property IconSize:integer read FIconSize write SetIconSize;
        property SmallIconSize:integer read FSmallIconSize write SetSmallIconSize;
        property ImageList: TXPImageList read FImageList write SetImageList;
        property SmallImageList: TXPImageList read FSmallImageList write SetSmallImageList;
        property Selected:TXPListItem read FSelected write SetSelected;
        property ViewStyle: TXPViewStyle read FViewStyle write SetViewStyle;
        property HeaderControl: THeaderControl read FHeaderControl;
    end;

    //Single item, derived from TPersistent to allow serialization
    TXPListItem=class(TPersistent)
    private
        back:TBitmap;
        FListItems: TXPListItems;
        FCaption: string;
        FImageIndex: integer;
        FSelected: boolean;
    FSubitems: TStrings;
        procedure SetCaption(const Value: string);
        procedure SetImageIndex(const Value: integer);
        procedure SetSelected(const Value: boolean);
        procedure SetSubitems(const Value: TStrings);
    public
        //Returns the rectangle used for the full item
        data: TObject;
        function getItemRect(const x,y:integer):TRect;
        function getTextRect(const x,y:integer):TRect;
        function getFilledTextRect(const ACanvas:TCanvas; const x,y:integer):TRect;
        function getHotRect(const ACanvas:TCanvas; const x,y:integer): TRect;
        function HitTest(const ACanvas:TCanvas;const ox,oy:integer; const x,y:integer):boolean;
        //Paints the item on the canvas
        procedure paint(ACanvas:TCanvas; x,y:integer);
        constructor Create;
        destructor Destroy;override;
    published
        property Caption:string read FCaption write SetCaption;
        property ImageIndex:integer read FImageIndex write SetImageIndex;
        property Selected:boolean read FSelected write SetSelected;
        property Subitems: TStrings read FSubitems write SetSubitems;
    end;

    //List of items
    TXPListItems=class(TPersistent)
    private
        //Attached listview
        FListView:TXPListView;
        //List of items
        FItems:TList;
        function GetItem(Index: Integer): TXPListItem;
        procedure SetItem(Index: Integer; const Value: TXPListItem);
        function GetCount: Integer;
    public
        function Add: TXPListItem;
        function AddObject(const obj:TObject): TXPListItem;
        property Count: Integer read GetCount;
        constructor Create(AListView:TXPListView);
        destructor Destroy;override;
        property Item[Index: Integer]: TXPListItem read GetItem write SetItem; default;
    end;

implementation

{ TXPListview }

constructor TXPListview.Create(AOwner: TComponent);
begin
  inherited;
  FViewStyle:=vsIcon;

  lastcode:=scendscroll;
  FViewOrigin:=Point(0,0);
  FImageList:=nil;
  FSmallImageList:=nil;
  FIconHSpacing:=43;
  FIconVSpacing:=43;
  FIconSize:=32;
  FSmallIconSize:=16;

  width:=120;
  height:=100;

  FItems:=TXPListItems.create(self);

  FHeaderControl:=THeaderControl.Create(self);
  FHeaderControl.OnSectionResize:=HeaderControlSectionResize;
  FHeaderControl.visible:=false;
  FHeaderControl.Width:=2048;
  FHeaderControl.parent:=self;

  //Creates the scrollbars
  FVertScrollBar:=TScrollbar.Create(self);
  FVertScrollBar.OnScroll:=VertScrollBarsScroll;

  FHorzScrollBar:=TScrollbar.Create(self);
  FHorzScrollBar.OnScroll:=HorzScrollBarsScroll;

  //Setup initial properties
  FVertScrollBar.Kind:=sbVertical;
  FVertScrollBar.visible:=false;
  FVertScrollBar.parentcolor:=false;
  FVertScrollBar.parent:=self;
  FVertScrollBar.left:=width;
  FVertScrollBar.top:=clientrect.top;
  FVertScrollBar.height:=height-FVertScrollbar.width;
  FVertScrollBar.Anchors:=[akTop,akBottom,akRight];

  FHorzScrollBar.Kind:=sbHorizontal;
  FHorzScrollBar.visible:=false;
  FHorzScrollBar.parent:=self;

  FHorzScrollBar.left:=0;
  FHorzScrollBar.top:=height-FHorzScrollbar.height;
  FHorzScrollBar.width:=width-FHorzScrollbar.height;
  FHorzScrollBar.Anchors:=[akLeft,akBottom,akRight];

  parentcolor:=false;
  ParentFont:=true;
  color:=clWindow;
end;

destructor TXPListview.Destroy;
begin
    { TODO : Destroy all created control }
  FItems.free;
  inherited;
end;

procedure TXPListview.paint;
var
    i: integer;
    l: TXPListItem;
    x,y: integer;
    ACanvas: TCanvas;
    llimit: integer;
    s: integer;
    o: TRect;
begin
    //Setup initial paint properties
    if assigned(FImageList) then FImageList.BackgroundColor:=Color;
    if assigned(FSmallImageList) then FSmallImageList.BackgroundColor:=Color;    

    ACanvas:=self.canvas;
    ACanvas.Font.Assign(self.font);
    ACanvas.Brush.color:=color;
    ACanvas.Pen.Color:=acanvas.Brush.color;

    if FViewStyle=vsIcon then begin
        //Initial left coordinate
        llimit:=GetLeftOrigin;
        x:=llimit;

        //Initial top coordinate
        y:=-FViewOrigin.Y+ClientRect.top;

        //Calculates how much rows are hidden and which item is the first to be drawn
        s:=HiddenRows*IconsPerRow;
        y:=y+(HiddenRows*RowHeight);

//        if (acanvas.ClipRect.Left=0) and (acanvas.ClipRect.top=0) then ACanvas.SetClipRect(clientrect);

        //Starts to draw the items
        for i:=s to FItems.Count-1 do begin
            l:=FItems[i];
            { TODO : Isolate these calculations }
            //If the item doesn't fit into the control
            if (x+FIconSize+(FIconHSpacing div 2)+4)>clientwidth then begin
                //Paints a rectangle to erase that area and any previous content
                ACanvas.Pen.Color:=self.color;
                ACanvas.Rectangle(l.getitemrect(x,y));
                //Advances to the next row
                x:=llimit;
                inc(y,FIconSize+FIconVSpacing+1);
            end;
            //If the item it's visible, then, paint it
            if (y+FiconSize+FIconVSpacing>1) then begin
                if (IntersectRect(o,ACanvas.ClipRect,l.getItemRect(x,y))) then begin
                    l.paint(ACanvas,x,y);
                end;
            end;

            //Advances the next colum
            inc(x,FIconSize+FIconHSpacing+1);

            //If we are out the control, then we have finish painting
            if (y>clientheight) then break;
        end;

        //Paints the remaining area of the control to erase any previous content
        ACanvas.Rectangle(rect(x-(FIconHSpacing div 2),y-1,clientwidth+1,clientheight+2));
        ACanvas.Rectangle(rect(0,y+FIconSize+FIconVSpacing,clientwidth+1,clientheight+2));
    end
    else begin
        { TODO : Optimize this drawing by using cliprect }
        x:=clientrect.left+4-FViewOrigin.x;
        y:=FHeaderControl.BoundsRect.Bottom+2;
        ACanvas.Rectangle(rect(0,FHeaderControl.BoundsRect.Bottom,clientwidth+1,y));
        for i:=FViewOrigin.Y to FItems.count-1 do begin
            l:=FItems[i];
            //Draw the item
            l.paint(ACanvas,x,y);
            inc(y, FSmallIconSize+2);
            //If we are out the control, then we have finish painting
            if (y>clientheight) then break;
        end;
        //Paints the remaining area of the control to erase any previous content
        ACanvas.Rectangle(rect(0,y,clientwidth+1,clientheight+2));
    end;


    //ACanvas.SetClipRect(rect(0,0,width,height));
    //Paint the border
    (*
    { TODO : Border Properties }
    ACanvas.Pen.Color:=clLtGray;
    ACanvas.MoveTo(0,0);
    ACanvas.LineTo(width,0);
    ACanvas.MoveTo(0,0);
    ACanvas.LineTo(0,height);

    ACanvas.Pen.Color:=clDkGray;
    ACanvas.MoveTo(1,1);
    ACanvas.LineTo(width,1);
    ACanvas.MoveTo(1,1);
    ACanvas.LineTo(1,height);

    ACanvas.Pen.Color:=clWhite;
    ACanvas.MoveTo(width-1,height-1);
    ACanvas.LineTo(width-1,0);
    ACanvas.MoveTo(width-1,height-1);
    ACanvas.LineTo(0,height-1);

    ACanvas.Pen.Color:=clBackground;
    ACanvas.MoveTo(width-2,height-2);
    ACanvas.LineTo(width-2,1);
    ACanvas.MoveTo(width-2,height-2);
    ACanvas.LineTo(1,height-2);
    *)
    if (FVertScrollBar.Visible) and (fhorzscrollbar.visible) then begin
        Acanvas.Brush.Color:=clBackground;
        ACanvas.pen.color:=clBackground;
        acanvas.Rectangle(rect(width-FVertScrollBar.Width-2,height-FHorzScrollBar.Height-1,width-1,height-1));

    end;
end;

procedure TXPListview.SetHorzScrollBar(const Value: TScrollbar);
begin
  FHorzScrollBar.assign(value);
end;

procedure TXPListview.SetIconVSpacing(const Value: integer);
begin
    if FIconVSpacing<>Value then begin
        FIconVSpacing := Value;
        invalidate;
    end;
end;

procedure TXPListview.SetIconHSpacing(const Value: integer);
begin
    if FIconVSpacing<>Value then begin
        FIconHSpacing := Value;
        invalidate;
    end;
end;

procedure TXPListview.SetItems(const Value: TXPListItems);
begin
  if FItems <> Value then FItems.Assign(Value);
end;

procedure TXPListview.SetVertScrollBar(const Value: TScrollbar);
begin
  FVertScrollBar.assign(value);
end;

function TXPListview.WidgetFlags: Integer;
begin
    Result := Inherited WidgetFlags or Integer(WidgetFlags_WRepaintNoErase) or Integer(WidgetFlags_WResizeNoErase);
end;

procedure TXPListview.SetImageList(const Value: TXPImageList);
begin
  FImageList := Value;
end;

procedure TXPListview.updateScrollBars;
var
    ih: integer;
    iv: integer;
    cr: TRect;
    sw: integer;
    i: integer;
begin
    if assigned(parent) then begin
        cr:=ClientRect;

        if (FViewStyle=vsIcon) then begin
            iv:=IconsPerCol;
            ih:=IconsPerRow;
            //If the items that fit into the control area are less than the total items
            //it's time to show some scrollbars
            if (iv*ih<FItems.Count) then begin
                if (FHorzScrollbar.visible) then begin
                    FVertScrollBar.height:=height-FVertScrollbar.width;
                end
                else FVertScrollBar.height:=clientheight;

                //The max of the scrollbar is how much rows * rowspacing - clientheight
                { TODO : Isolate these calculations }
                FVertScrollBar.max:=abs((ceil(FItems.count / IconsPerRow)*(FIconSize+FIconVSpacing+1))-clientheight);

                //Setup the scrollbar
                FVertScrollBar.LargeChange:=clientheight;
                FVertScrollBar.smallchange:=FIconVSpacing;
                FVertScrollBar.top:=clientrect.top;
                FVertScrollBar.Left:=self.Width-FVertScrollbar.width-clientrect.left;
                if not (FVertScrollBar.visible) then begin
                    FVertScrollBar.Visible:=true;
                    //Shows the scrollbar
                    Application.HandleMessage;
                end;
                FViewOrigin.Y:=FVertScrollBar.position;
            end
            else FVertScrollBar.Visible:=false;
        end
        else begin
            iv:=IconsPerCol;
            sw:=0;
            for i:=0 to FHeaderControl.Sections.Count-1 do begin
                sw:=sw+FHeaderControl.Sections[i].Width;
            end;
            if (sw>ClientWidth) then begin
                if not (FHorzScrollBar.visible) then begin
                    FHorzScrollBar.Visible:=true;
                    //Shows the scrollbar
                    Application.HandleMessage;
                end;
                FHorzScrollBar.Width:=ClientWidth;
                FHorzScrollBar.max:=sw-ClientWidth;
                //Setup the scrollbar
                FHorzScrollBar.LargeChange:=ClientWidth;
                FHorzScrollBar.smallchange:=1;
                FHorzScrollBar.top:=self.height-FHorzScrollbar.height-clientrect.top;
                FHorzScrollBar.Left:=0;
            end
            else begin
                FHorzScrollBar.Visible:=false;
            end;

            if (iv<FItems.Count) then begin
//                if (FHorzScrollbar.visible) then begin
//                    FVertScrollBar.height:=height-FHorzScrollbar.height-clientrect.top-1;
//                end
//                else
                if (FHorzScrollbar.visible) then begin
                    FVertScrollBar.height:=clientheight-1
                end
                else FVertScrollBar.height:=clientheight;

                FVertScrollBar.max:=FItems.count-iv;
                //Setup the scrollbar
                FVertScrollBar.LargeChange:=iv;
                FVertScrollBar.smallchange:=1;
                FVertScrollBar.top:=clientrect.top;
                FVertScrollBar.Left:=self.Width-FVertScrollbar.width-clientrect.left;
                if not (FVertScrollBar.visible) then begin
                    FVertScrollBar.Visible:=true;
                    //Shows the scrollbar
                    Application.HandleMessage;
                end;
                FViewOrigin.Y:=FVertScrollBar.position;
            end
            else FVertScrollBar.Visible:=false;
        end;
    end;
end;


function TXPListview.getClientRect: TRect;
begin
    result:=inherited getClientRect;
    //If the scrollbar is visible, the client area is calculated accordingly
    if assigned(FVertScrollBar) then begin
        if (FVertScrollBar.Visible) then begin
            result.right:=width-fvertscrollbar.Width;
        end;
    end;
    if assigned(FHorzScrollBar) then begin
        if (FHorzScrollBar.Visible) then begin
            result.bottom:=height-fhorzscrollbar.height;
        end;
    end;
    {
    result.left:=2;
    result.top:=2;
    if (assigned(FVertScrollBar)) then begin
        if (not FHorzScrollBar.Visible) then result.bottom:=height-2;
        if (not FVertScrollBar.Visible) then result.Right:=width-2;
    end;
    }
end;

procedure TXPListview.ChangeBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  updateScrollBars;
end;

function TXPListview.IconsPerCol: integer;
begin
    if FViewStyle=vsIcon then begin
        result:=(clientheight-3) div (FIconSize+FIconVSpacing+1);
    end
    else begin
        result:=(clientheight-FHeaderControl.Height-2) div (FSmallIconSize+2);
    end;
end;

function TXPListview.IconsPerRow: integer;
begin
    result:=(clientwidth-3) div (FIconSize+FIconHSpacing+1);
end;

function TXPListview.HiddenRows: integer;
begin
    result:=FViewOrigin.Y div RowHeight;
end;

function TXPListview.RowHeight: integer;
begin
    result:=(FIconSize+FIconVSpacing+1);
end;

procedure TXPListview.SetSelected(const Value: TXPListItem);
begin
    if Value<>FSelected then begin
        if assigned(FSelected) then FSelected.Selected:=false;
        FSelected := Value;
        if assigned(FSelected) then FSelected.Selected:=true;
        invalidateclientrect;
    end;
end;

procedure TXPListview.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
    cx: integer;
    cy: integer;
    index: integer;
    dy: integer;
    dx: integer;
    temp: TXPListItem;
begin
    //Calculate which item has been clicked
    //Change the selected property
    if FViewStyle=vsIcon then begin
        cy:=FViewOrigin.Y+y;
        cy:=cy div RowHeight;
        cx:=x div ColWidth;
        if cx<IconsPerRow then begin
            index:=(cy * IconsPerRow)+cx;
            dy:=(cy * RowHeight)-FViewOrigin.Y;
            dx:=(cx * ColWidth)+GetLeftOrigin;
            if (index>=0) and (index<FItems.count) then begin
                temp:=FItems[index];
                if temp.hittest(canvas, dx,dy,x,y) then selected:=temp
                else selected:=nil;
            end
            else Selected:=nil;
        end
        else selected:=nil;
    end
    else begin
        index:=(y-FHeaderControl.BoundsRect.Bottom-2) div (FSmallIconSize+2)+FViewOrigin.Y;
        if (index>=0) and (index<FItems.count) then begin
            selected:=FItems[index];
        end
        else Selected:=nil;
    end;
    inherited;
end;

function TXPListview.ColWidth: integer;
begin
    result:=(FIconSize+FIconHSpacing+1);
end;

function TXPListview.GetLeftOrigin: integer;
begin
    result:=(FIconHSpacing div 2)+ClientRect.left;
end;

function TXPListview.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  const MousePos: TPoint): Boolean;
var
    sp: integer;
begin
    if (fviewstyle=vsdetail) then begin
        wheeldelta:=(wheeldelta div 120)*3;
    end;

    sp:=FViewOrigin.Y;
    sp:=sp-WheelDelta;
    if (sp>FVertScrollBar.max) then sp:=FVertScrollBar.max;
    if (sp<0) then sp:=0;
        
    if wheeldelta>0 then VertScrollBarsScroll(FVertScrollBar, scPageDown, sp)
    else VertScrollBarsScroll(FVertScrollBar, scPageUp, sp);
    
    lastcode:=scEndScroll;
    FVertScrollbar.position:=sp;
    result:=inherited DoMouseWheel(Shift, WheelDelta, MousePos);
end;

procedure TXPListview.SetIconSize(const Value: integer);
begin
    if FIconSize<>Value then begin
        FIconSize := Value;
        invalidate;
    end;
end;

procedure TXPListview.VertScrollBarsScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
var
    cr: TRect;
    ar: TRect;
    dy: integer;
begin
    if FViewStyle=vsIcon then begin
        ar:=clientrect;
        dy:=scrollpos-FViewOrigin.Y;
        case scrollcode of
            sclinedown,scpagedown: begin
                lastcode:=scrollcode;
                cr:=ar;
                cr.Top:=cr.bottom-dy;
                canvas.SetClipRect(cr);
                FViewOrigin.Y:=scrollpos;
                QWidget_scroll(self.handle,0,-dy,@ar);
            end;
            sclineup,scpageup: begin
                lastcode:=scrollcode;
                cr:=ar;
                cr.bottom:=cr.top-dy;
                canvas.SetClipRect(cr);
                FViewOrigin.Y:=scrollpos;
                QWidget_scroll(self.handle,0,-dy,@ar);
            end;
            sctrack: begin
                if (lastcode=scendscroll) or (lastcode=sctrack) then begin
                    FViewOrigin.Y:=scrollpos;
                    lastcode:=scrollcode;
                    invalidateclientrect;
                end;
            end;
            scendscroll: begin
                lastcode:=scrollcode;
            end;
        end;
    end
    else begin
        { TODO : Optimize this using QWidget_scroll }
        FViewOrigin.Y:=scrollpos;
        InvalidateClientRect;
    end;
end;

procedure TXPListview.InvalidateClientRect;
begin
    invalidaterect(clientrect,false);
end;

procedure TXPListview.SetViewStyle(const Value: TXPViewStyle);
begin
    if FViewStyle<>Value then begin
        FViewStyle := Value;
        FHeaderControl.visible:=(FViewStyle=vsDetail);
        updatescrollbars;        
        invalidateclientrect;
    end;
end;

procedure TXPListview.SetSmallIconSize(const Value: integer);
begin
    if FSmallIconSize<>Value then begin
        FSmallIconSize := Value;
        InvalidateClientRect;
    end;
end;

procedure TXPListview.SetSmallImageList(const Value: TXPImageList);
begin
  FSmallImageList := Value;
end;

procedure TXPListview.genericInvalidate(sender: TObject);
begin
    InvalidateClientRect;
end;

procedure TXPListview.HeaderControlSectionResize(
  HeaderControl: TCustomHeaderControl; Section: TCustomHeaderSection);
begin
    InvalidateClientRect;
    updatescrollbars;
end;

procedure TXPListview.SetViewOrigin(const Value: TPoint);
begin
    if (value.x<>FViewOrigin.x) or (value.y<>FViewOrigin.Y) then begin
        FViewOrigin := Value;
        InvalidateClientRect;
    end;
end;

procedure TXPListview.HorzScrollBarsScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
    if FViewStyle=vsDetail then begin
        FViewOrigin.X:=scrollpos;
        FHeaderControl.Align:=alNone;
        FHeaderControl.width:=2048;        
        InvalidateClientRect;
        FHeaderControl.Left:=-FViewOrigin.x;        
    end;
end;

{ TXPListItem }

constructor TXPListItem.Create;
begin
    FSelected:=False;
    FSubitems:=TStringList.create;
    FImageIndex:=-1;
end;

destructor TXPListItem.Destroy;
begin
    FSubitems.free;
  inherited;
end;

function TXPListItem.getHotRect(const ACanvas: TCanvas; const x,
  y: integer): TRect;
var
    tr: TRect;
    te: TRect;
begin
    tr:=getItemRect(x,y);
    te:=getFilledTextRect(ACanvas,x,y);
    te.left:=Min(te.left,((tr.right-tr.left)-FListItems.FListView.FIconSize) div 2);
    te.Right:=Max(te.Right,te.left+FListItems.FListView.FIconSize);
    result:=rect(tr.left+te.left,tr.top,tr.Left+te.right,tr.top+te.bottom);
end;

function TXPListItem.getFilledTextRect(const ACanvas:TCanvas; const x, y: integer): TRect;
begin
    result:=getTextRect(x,y);
    ACanvas.TextExtent(FCaption,result,integer(AlignmentFlags_AlignHCenter) or integer(AlignmentFlags_WordBreak));
    InflateRect(result,1,1);
end;

function TXPListItem.getItemRect(const x, y: integer): TRect;
var
    tr: TRect;
    iw,ih: integer;
    tw: integer;
begin
    iw:=FListItems.FListView.FIconHSpacing;
    ih:=FListItems.FListView.FIconVSpacing;
    tw:=FListItems.FListView.FIconSize+iw;
    tr.left:=x-((tw-FListItems.FListView.FIconSize) div 2);
    tr.top:=y+FListItems.FListView.FIconSize+4;
    tr.Right:=tr.left+tw+1;
    tr.Bottom:=tr.top+ih-2;

    result:=Rect(tr.left,y,tr.right,tr.bottom);
end;

function TXPListItem.getTextRect(const x, y: integer): TRect;
var
    iw,ih: integer;
    tr: TRect;
begin
    tr:=getItemRect(x,y);
    iw:=FListItems.FListView.FIconHSpacing;
    ih:=FListItems.FListView.FIconVSpacing;

    result.Left:=((tr.Right-tr.Left)-(iw+FListItems.FListView.FIconSize-2)) div 2;
    result.top:=FListItems.FListView.FIconSize+4;
    result.Right:=result.left+iw+FListItems.FListView.FIconSize-2;
    result.bottom:=result.top+ih;
end;

procedure TXPListItem.paint(ACanvas: TCanvas; x, y: integer);
var
    tr: TRect;
    te: TRect;
    cr: TRect;
    hr: TRect;
    iw,ih: integer;
    itemState: TXPImageStates;
    i: integer;
    sr: TRect;
    hs: THeaderSection;
    add: integer;
begin
    { TODO : Optimize paint operations using back bitmaps}
    { TODO : Use getItemRect }
    { TODO : Ellipsis (...) when the text doesn't fit }
    if  FListItems.FListView.FViewStyle=vsIcon then begin
        tr:=getItemRect(x,y);
        back:=TBitmap.create;
        try
            back.Width:=tr.Right-tr.Left;
            back.Height:=tr.Bottom-tr.Top;
            back.Canvas.Brush.Color:=FListItems.FListView.color;
            back.canvas.pen.color:=back.canvas.brush.color;
            { TODO : Solve this without rectangle, it's slow }
            back.Canvas.Rectangle(0,0,back.width,back.height);
            if (FImageIndex<>-1) and (assigned(FListItems.FListView.FImageList)) then begin
                if FSelected then itemState:=[isSelected]
                else itemState:=[isNormal];
                FListItems.FListView.FImageList.DrawImage(back.Canvas,(back.width-FListItems.FListView.FIconSize) div 2,1,FImageIndex,itemState);
            end;

            iw:=FListItems.FListView.FIconHSpacing;
            ih:=FListItems.FListView.FIconVSpacing;

            cr.Left:=(back.width-(iw+FListItems.FListView.FIconSize-2)) div 2;
            cr.top:=FListItems.FListView.FIconSize+4;
            cr.Right:=cr.left+iw+FListItems.FListView.FIconSize-2;
            cr.bottom:=cr.top+ih;

            back.canvas.Font.assign(FListItems.FListView.Font);
            { TODO : Properties to draw the icons text in different ways }
            te:=cr;
            back.Canvas.TextExtent(FCaption,te,integer(AlignmentFlags_AlignHCenter) or integer(AlignmentFlags_WordBreak));
            InflateRect(te,1,1);
            te.top:=te.top+1;
            te.Left:=te.left-1;
            te.Right:=te.right+1;
            hr:=getHotRect(back.canvas,x,y);
            if FSelected then begin
                back.canvas.Font.Color:=clHighlightedText;
                back.Canvas.Pen.Color:=clActiveHighlight;
                back.Canvas.Brush.Color:=clActiveHighlight;
                back.canvas.Rectangle(te);
            end;
            back.Canvas.TextRect(cr,cr.left,cr.top,FCaption,integer(AlignmentFlags_AlignHCenter) or integer(AlignmentFlags_WordBreak));
            acanvas.Draw(tr.left,tr.top,back);
        finally
            back.free;
        end;
    end
    else begin
        back:=TBitmap.create;
        try
            back.Width:=FListItems.FListView.ClientWidth;
            back.Height:=FListItems.FListView.FSmallIconSize+2;
            back.Canvas.Brush.Color:=FListItems.FListView.color;
            back.canvas.pen.color:=back.canvas.brush.color;
            { TODO : Solve this without rectangle, it's slow }
            back.Canvas.Rectangle(0,0,back.width,back.height);
            if (FImageIndex<>-1) and (assigned(FListItems.FListView.FSmallImageList)) then begin
                if FSelected then itemState:=[isSelected]
                else itemState:=[isNormal];
                FListItems.FListView.FSmallImageList.DrawImage(back.Canvas,x,0,FImageIndex,itemState);
            end;
            cr.left:=x+FListItems.FListView.FSmallIconSize+3;
            cr.top:=0;
            cr.right:=back.width;
            cr.Bottom:=back.height;
            if FListItems.FListView.FHeaderControl.Sections.Count>=1 then begin
                cr.Right:=FListItems.FListView.FHeaderControl.Sections[0].width;
            end;
            te:=cr;
            back.Canvas.TextExtent(FCaption,te,0);
            InflateRect(te,1,1);
            te.top:=0;
            te.Left:=te.left-1;
            te.Right:=te.right+1;
            te.Bottom:=back.height-2;
            add:=0;
            if (FListItems.FListView.FHeaderControl.Sections.count>=1) then begin
                te.right:=Min(te.right,FListItems.FListView.FHeaderControl.Sections[0].width-2);
                add:=FListItems.FListView.FHeaderControl.Sections[0].width;
            end;
            if FSelected then begin
                back.canvas.Font.Color:=clHighlightedText;
                back.Canvas.Pen.Color:=clActiveHighlight;
                back.Canvas.Brush.Color:=clActiveHighlight;
                back.canvas.Rectangle(te);
            end;

            back.Canvas.TextRect(cr,cr.left,cr.top,GetTrimmedText(back.canvas,FCaption,te.right-te.left-2),0);
            back.Canvas.Font.Color:=clText;
            for i:=1 to FListItems.FListView.FHeaderControl.Sections.count-1 do begin
                hs:=FListItems.FListView.FHeaderControl.Sections[i];
                if i-1<=FSubitems.Count-1 then begin
                    sr:=cr;
                    sr.left:=x+add;
                    sr.Right:=sr.left+hs.Width;
                    back.Canvas.TextRect(sr,sr.Left,sr.top,gettrimmedText(back.canvas,FSubitems[i-1],sr.Right-sr.left-2));
                    add:=add+hs.width;
                end
                else break;
            end;
            acanvas.Draw(0,y,back);
        finally
            back.free;
        end;
    end;
end;

procedure TXPListItem.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TXPListItem.SetImageIndex(const Value: integer);
begin
  FImageIndex := Value;
end;

procedure TXPListItem.SetSelected(const Value: boolean);
begin
  FSelected := Value;
end;

function TXPListItem.HitTest(const ACanvas: TCanvas; const ox, oy, x,
  y: integer): boolean;
var
    hr: TRect;
begin
    hr:=getHotRect(ACanvas,ox,oy);
    result:=PtInRect(hr,point(x,y));
end;

procedure TXPListItem.SetSubitems(const Value: TStrings);
begin
  FSubitems.assign(Value);
end;

{ TXPListItems }

function TXPListItems.Add: TXPListItem;
begin
    result:=TXPListItem.create;
    result.FListItems:=self;
    FItems.Add(result);
    FListView.updateScrollBars;
end;

function TXPListItems.AddObject(const obj: TObject): TXPListItem;
begin
    result:=TXPListItem.create;
    result.FListItems:=self;
    result.data:=obj;
    FItems.Add(result);
    FListView.updateScrollBars;
end;

constructor TXPListItems.Create(AListView:TXPListView);
begin
  FListView:=AListView;
  FItems:=TList.create;
end;

destructor TXPListItems.Destroy;
begin
  FItems.free;
  inherited;
end;

function TXPListItems.GetCount: Integer;
begin
    result:=FItems.count;
end;

function TXPListItems.GetItem(Index: Integer): TXPListItem;
begin
    result:=FItems[index];
end;

procedure TXPListItems.SetItem(Index: Integer; const Value: TXPListItem);
begin
    FItems[index]:=Value;
end;

end.
