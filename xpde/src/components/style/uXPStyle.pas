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
unit uXPStyle;

interface
uses
    Classes, QForms, QGraphics,
    Types, QMenus, Qt, uXPStyleConsts,
    QDialogs, QStyle, QControls, uXPPopupMenu,
    QStdCtrls, Sysutils;

type
    TXPStyle=class(TComponent)
  private
        procedure DrawTabEvent(Sender, Source: TObject; Canvas: TCanvas; Index, HorizonalPadding, VerticalPadding, Overlap: Integer; Selected: Boolean);
        procedure GetItemRectEvent(Sender: TObject; Canvas: TCanvas; var Rect: TRect; Flags: Integer; Enabled: Boolean; Bitmap: TBitmap; const Text: WideString);
    public
        toleft:TBitmap;
        toRight: TBitmap;
        toRightWhite: TBitmap;
        toTop:TBitmap;
        toBottom: TBitmap;
        procedure loaded;override;
        procedure setXPStyle(app: TApplication);
        procedure OnShowHint(var HintStr: WideString; var CanShow: Boolean; var HintInfo: THintInfo);

        procedure DrawFocusRectEvent(Sender: TObject; Canvas: TCanvas; const Rect: TRect; AtBorder: Boolean; var DefaultDraw: Boolean);
        procedure DrawArrowEvent(Sender: TObject; Canvas: TCanvas; const Rect: TRect; Arrow: ArrowType; Down, Enabled: Boolean);
        procedure DrawComboButton(Sender: TObject; Canvas: TCanvas; const Rect: TRect; Sunken, ReadOnly, Enabled: Boolean; var DefaultDraw: Boolean);
        procedure BeforeDrawButton(Sender, Source: TObject; Canvas: TCanvas; var DefaultDraw: Boolean);
        procedure DrawButtonLabel(Sender, Source: TObject; Canvas: TCanvas; var DefaultDraw: Boolean);
        procedure DrawButtonFrame(Sender: TObject; Canvas: TCanvas; const Rect: TRect; Down: Boolean; var DefaultDraw: Boolean);
        procedure DrawButtonMask(Sender: TObject; Canvas: TCanvas; const Rect: TRect);
        procedure BeforeDrawMenuItem(Sender, Source: TObject; Canvas: TCanvas; Highlighted, Enabled: Boolean; const Rect: TRect; Checkable: Boolean; CheckMaxWidth, LabelWidth: Integer; var DefaultDraw: Boolean);
        procedure MenuItemHeightEvent(Sender, Source: TObject; Checkable: Boolean; FontMetrics: QFontMetricsH; var Height: Integer);
        procedure DrawMenuFrame(Sender: TObject; Canvas: TCanvas; const R: TRect;LineWidth: Integer; var DefaultDraw: Boolean);
        procedure DrawScrollBarEvent(Sender: TObject; ScrollBar: QScrollBarH; Canvas: TCanvas; const Rect: TRect; SliderStart, SliderLength, ButtonSize: Integer; Controls: TScrollBarControls; DownControl: TScrollBarControl; var DefaultDraw: Boolean);
        procedure DrawFrameEvent(Sender: TObject; Canvas: TCanvas; const Rect: TRect; Sunken: Boolean; LineWidth: Integer; var DefaultDraw: Boolean);
        constructor Create(AOwner: TComponent);override;
    end;

procedure Register;

procedure SetXPStyle(app:TApplication);

implementation

var
    st: TXPStyle=nil;

procedure SetXPStyle(app:TApplication);
begin
    if not (assigned(st)) then st:=TXPStyle.create(app);

    st.setXPStyle(app);

end;

procedure Register;
begin
    RegisterComponents('XPde',[TXPStyle]);
end;

procedure TXPStyle.setXPStyle(app: TApplication);
begin
    app.OnShowHint:=self.OnShowHint;

    //Sets the default style
    app.Style.DefaultStyle:=dsWindows;
    app.font.Name:=sDefaultFontName;
    app.font.size:=iDefaultFontSize;
    app.font.height:=iDefaultFontHeight;

    //Sets the palette

    app.Palette.SetColor(cgActive,crBackground,dclBtnFace);
    app.Palette.SetColor(cgActive,crHighlight,dclHighlight);
    app.Palette.SetColor(cgActive,crButton,dclBtnFace);
    app.Palette.SetColor(cgInactive,crButton,dclBtnFace-1);

    //Sets the paint events
    app.Style.BeforeDrawmenuItem:=self.beforedrawmenuitem;
    app.Style.MenuItemHeight:=self.menuitemheightevent;
    app.Style.DrawScrollBar:=self.drawscrollbarevent;
    app.Style.BeforeDrawButton:=self.BeforeDrawButton;
    app.Style.DrawButtonLabel:=self.DrawButtonLabel;
    app.Style.DrawMenuFrame:=self.DrawMenuFrame;
    app.Style.GetItemRect:=self.GetItemRectEvent;
    app.Style.DrawComboButton:=self.DrawComboButton;
    app.Style.DrawFrame:=self.DrawFrameEvent;
    app.Style.DrawArrow:=self.DrawArrowEvent;
    app.Style.DrawTab:=self.DrawTabEvent;
    app.Style.DrawTabMask:=self.DrawTabEvent;
    app.Style.DrawFocusRect:=self.DrawFocusRectEvent;

end;

procedure TXPStyle.BeforeDrawButton(Sender, Source: TObject;
  Canvas: TCanvas; var DefaultDraw: Boolean);
begin
    if (source is TButton) then begin
        drawButton(canvas,(source as TControl).ClientRect,(source as TButton).Down,true,(source as TButton).default);
        defaultdraw:=false;
    end
    else begin
        defaultdraw:=true;
    end;
end;

procedure TXPStyle.BeforeDrawMenuItem(Sender, Source: TObject;
  Canvas: TCanvas; Highlighted, Enabled: Boolean; const Rect: TRect;
  Checkable: Boolean; CheckMaxWidth, LabelWidth: Integer;
  var DefaultDraw: Boolean);
var
    s: string;
    d: longint;
    m: TMenuItem;
    tx,ty:integer;
    gy:integer;
    ob:TBitmap;
    pRect:TRect;
    mRect:TRect;        //Menu Rect
    cRect: TRect;
    mh:integer;
begin
    m:=(source as TMenuItem);

    cRect:=Rect;
    mRect:=canvas.cliprect;
    inflaterect(mRect,2,2);

    with canvas do begin
        pen.color:=dclBtnFace;
        moveto(mRect.left+2,mRect.top+2);
        lineto(mRect.right-3,mRect.top+2);
        lineto(mRect.right-3,mRect.bottom-3);
        lineto(mRect.left+2,mRect.bottom-3);
        lineto(mRect.left+2,mRect.top+2);

        if (m.parent.owner is TXPPopupMenu) then begin
            ob:=(m.parent.Owner as TXPPopupMenu).BackBitmap;
            if not (ob.empty) then begin
                mh:=mRect.bottom-mRect.Top;
                canvas.SetClipRect(types.rect(3,3,ob.width+3,mh-3));
                canvas.draw(3,3-(ob.height-(mRect.Bottom-mRect.top)),ob);
                canvas.SetClipRect(types.rect(0,0,16386,16386));
                cRect.left:=cRect.left+ob.width;
            end;
        end;

        font.Name:=SDefaultFontName;
        font.size:=iDefaultFontSize;
        font.height:=iDefaultFontHeight;
        pRect:=rect;
        cRect.left:=cRect.Left+1;
        cRect.right:=cRect.right-1;
        cRect.top:=cRect.top+1;
        if m.MenuIndex=m.Parent.Count-1 then cRect.bottom:=cRect.bottom-2;
        cRect.bottom:=cRect.bottom+1;
        brush.color:=dclBtnFace;
        pRect.left:=cRect.left;
        fillrect(pRect);
        if highlighted then begin
            brush.color:=dclHighLight;
            font.color:=clWhite;
        end
        else begin
            brush.color:=dclBtnFace;
            font.color:=clBlack;
        end;
        fillrect(crect);
        s:=m.Caption;
        if s<>'-' then begin
            tx:=24;
            if not (m.bitmap.empty) then begin
                tx:=m.bitmap.width+9;
                gy:=crect.top+((crect.bottom-crect.top)-m.bitmap.height) div 2;
                draw(cRect.left+2,gy,m.bitmap);
            end;

            if (m.imageindex<>-1) then begin
                tx:=m.getparentmenu.Images.width+5;
                gy:=crect.top+((crect.bottom-crect.top)-m.getparentmenu.Images.height) div 2;
                ob:=TBitmap.create;
                try
                    m.getparentmenu.Images.GetBitmap(m.imageindex,ob);
                    ob.transparent:=true;
                    draw(cRect.left,gy,ob);
                finally
                    ob.free;
                end;
            end;

            ty:=crect.top+((crect.bottom-crect.top)-textheight(s)) div 2;
            textrect(crect,crect.left+tx,ty,s,integer(AlignmentFlags_ShowPrefix));
            if m.Count>=1 then begin
                gy:=crect.top+((crect.bottom-crect.top)-7) div 2;
                if highlighted then draw(crect.right-14,gy,toRightWhite)
                else draw(crect.right-14,gy,toRight);
            end;
        end
        else begin
            d:=(crect.bottom-crect.top) div 2;
            pen.color:=dclBtnShadow;
            moveto(crect.left+2,crect.top+d);
            lineto(crect.right-2,crect.top+d);
            pen.color:=clWhite;
            moveto(crect.left+2,crect.top+d+1);
            lineto(crect.right-2,crect.top+d+1);
        end;
    end;

    defaultdraw:=false;
end;



constructor TXPStyle.Create(AOwner: TComponent);
begin
  inherited;
  toLeft:=TBitmap.create;
  with toLeft do begin
    width:=4;
    height:=7;
    canvas.Pen.Color:=clBlack;
    with Canvas do begin
        moveto(3,0);
        lineto(3,6);
        moveto(2,1);
        lineto(2,5);
        moveto(1,2);
        lineto(1,4);
        moveto(0,3);
        lineto(0,3);
    end;
    transparentcolor:=clWhite;
    Transparent:=true;
  end;

  toRight:=TBitmap.create;
  with toRight do begin
    width:=4;
    height:=7;
    canvas.Pen.Color:=clBlack;
    with Canvas do begin
        moveto(0,0);
        lineto(0,6);
        moveto(1,1);
        lineto(1,5);
        moveto(2,2);
        lineto(2,4);
        moveto(3,3);
        lineto(3,3);
    end;
    transparentcolor:=clWhite;
    Transparent:=true;
  end;

  toRightWhite:=TBitmap.create;
  with toRightWhite do begin
    width:=4;
    height:=7;
    canvas.brush.Color:=clBlack;
    canvas.Pen.Color:=clWhite;
    with Canvas do begin
        fillrect(rect(0,0,4,7));
        moveto(0,0);
        lineto(0,6);
        moveto(1,1);
        lineto(1,5);
        moveto(2,2);
        lineto(2,4);
        moveto(3,3);
        lineto(3,3);
    end;
    transparentcolor:=clBlack;
    Transparent:=true;
  end;

  toTop:=TBitmap.create;
  with toTop do begin
    width:=7;
    height:=4;
    canvas.Pen.Color:=clBlack;
    with Canvas do begin
        moveto(0,3);
        lineto(6,3);
        moveto(1,2);
        lineto(5,2);
        moveto(2,1);
        lineto(4,1);
        moveto(3,0);
        lineto(3,0);
    end;
    transparentcolor:=clWhite;
    Transparent:=true;
  end;

  toBottom:=TBitmap.create;
  with toBottom do begin
    width:=7;
    height:=4;
    canvas.Pen.Color:=clBlack;
    with Canvas do begin
        moveto(0,0);
        lineto(6,0);
        moveto(1,1);
        lineto(5,1);
        moveto(2,2);
        lineto(4,2);
        moveto(3,3);
        lineto(3,3);
    end;
    transparentcolor:=clWhite;
    Transparent:=true;
  end;

end;

procedure TXPStyle.DrawArrowEvent(Sender: TObject; Canvas: TCanvas;
  const Rect: TRect; Arrow: ArrowType; Down, Enabled: Boolean);
begin
    showmessage('ok');
end;

procedure TXPStyle.DrawButtonFrame(Sender: TObject; Canvas: TCanvas;
  const Rect: TRect; Down: Boolean; var DefaultDraw: Boolean);
begin
    DefaultDraw:=false;
end;

procedure TXPStyle.DrawButtonLabel(Sender, Source: TObject;
  Canvas: TCanvas; var DefaultDraw: Boolean);
var
    caption:string;
    x,y:integer;
    w,h:integer;
    t: TSize;
begin
    if (source is TButton) then begin
        caption:=(source as TButton).caption;
        canvas.font.assign((source as TButton).font);
        w:=(source as TControl).width;
        h:=(source as TControl).height;
        t:=canvas.TextExtent(caption,integer(AlignmentFlags_ShowPrefix));
        x:=(w-t.cx) div 2;
        y:=(h-t.cy) div 2;

        if (source as TButton).down then begin
            canvas.TextRect(rect(0,0,w,h),x+1,y+1,caption,integer(AlignmentFlags_ShowPrefix));
        end
        else begin
            if (source as TButton).enabled then begin
                canvas.TextRect(rect(0,0,w,h),x,y,caption,integer(AlignmentFlags_ShowPrefix));
            end
            else begin
                canvas.Font.color:=dclBtnHighlight;
                canvas.TextRect(rect(0,0,w,h),x+1,y+1,caption,integer(AlignmentFlags_ShowPrefix));
                canvas.Font.color:=dclBtnShadow;
                canvas.TextRect(rect(0,0,w,h),x,y,caption,integer(AlignmentFlags_ShowPrefix));
            end;
        end;
        defaultdraw:=false;
    end
    else defaultdraw:=true;
end;

procedure TXPStyle.DrawButtonMask(Sender: TObject; Canvas: TCanvas;
  const Rect: TRect);
begin
    canvas.TextOut(0,0,'h');
end;

procedure TXPStyle.DrawComboButton(Sender: TObject; Canvas: TCanvas;
  const Rect: TRect; Sunken, ReadOnly, Enabled: Boolean;
  var DefaultDraw: Boolean);
var
    r:TRect;
begin
    defaultdraw:=false;
    r:=rect;
    r.top:=r.top+2;
    r.right:=r.right-2;
    r.bottom:=r.bottom-2;
    r.Left:=r.right-16;
    r3d(canvas,rect,false,false,true);
    canvas.brush.color:=dclBtnFace;
    r3d(canvas,r,false,not sunken,true);
    if (sunken) then begin
        r.left:=r.Left+1;
        r.top:=r.top+1;
    end;

    canvas.Draw(r.left+5,r.top+7,toBottom)
end;

procedure TXPStyle.DrawFocusRectEvent(Sender: TObject; Canvas: TCanvas;
  const Rect: TRect; AtBorder: Boolean; var DefaultDraw: Boolean);
begin
    defaultdraw:=false;
end;

procedure TXPStyle.DrawFrameEvent(Sender: TObject; Canvas: TCanvas;
  const Rect: TRect; Sunken: Boolean; LineWidth: Integer;
  var DefaultDraw: Boolean);
begin
    defaultdraw:=false;
    r3d(canvas,rect,false,not Sunken,false);
end;

procedure TXPStyle.DrawMenuFrame(Sender: TObject; Canvas: TCanvas;
  const R: TRect; LineWidth: Integer; var DefaultDraw: Boolean);
begin
    r3d(canvas,r,false,true,false);
    defaultdraw:=false;
end;

procedure TXPStyle.DrawScrollBarEvent(Sender: TObject;
  ScrollBar: QScrollBarH; Canvas: TCanvas; const Rect: TRect; SliderStart,
  SliderLength, ButtonSize: Integer; Controls: TScrollBarControls;
  DownControl: TScrollBarControl; var DefaultDraw: Boolean);
var
    x,y: longint;
    w,h: longint;
    slideRect: TRect;
    down: boolean;
begin
    defaultdraw:=false;
    with canvas do begin
        case QScrollBar_orientation(ScrollBar) of
        Orientation_Horizontal: begin
            if sbcSlider in controls then begin

                slideRect:=rect;
                slideRect.left:=slideRect.left+16;
                slideRect.right:=rect.left+sliderstart;
                brush.color:=clWhite;
                brush.style:=bsSolid;
                fillrect(slideRect);
                brush.color:=dclBtnFace;
                brush.style:=bsDense4;
                fillrect(slideRect);

                slideRect:=rect;
                slideRect.left:=rect.left+sliderstart+sliderlength;
                slideRect.right:=rect.right-16;

                brush.color:=clWhite;
                brush.style:=bsSolid;
                fillrect(slideRect);
                brush.color:=dclBtnFace;
                brush.style:=bsDense4;
                fillrect(slideRect);


                x:=rect.left+sliderstart;
                y:=rect.top;
                w:=x+sliderlength;
                h:=rect.bottom;
                r3d(canvas,types.rect(x,y,w,h));
            end;
            if sbcSubButton in controls then begin
                x:=rect.left;
                y:=rect.top;
                w:=x+16;
                h:=y+16;
                brush.color:=dclBtnFace;
                fillrect(types.rect(x,y,w,h));
                down:=(downcontrol=sbcSubButton);
                r3d(canvas,types.rect(x,y,w,h),down);
                if not down then canvas.Draw(x+5,y+4,toLeft)
                else canvas.Draw(x+6,y+5,toLeft);
            end;
            if sbcAddButton in controls then begin
                x:=rect.right-16;
                y:=rect.top;
                w:=x+16;
                h:=y+16;
                brush.color:=dclBtnFace;
                fillrect(types.rect(x,y,w,h));
                down:=(downcontrol=sbcAddButton);
                r3d(canvas,types.rect(x,y,w,h),down);
                if not down then canvas.Draw(x+6,y+4,toRight)
                else canvas.Draw(x+7,y+5,toRight);
            end;
        end;
        Orientation_Vertical: begin
            if sbcSlider in controls then begin
                slideRect:=rect;
                slideRect.top:=slideRect.top+16;
                slideRect.bottom:=rect.top+sliderstart;
                brush.color:=clWhite;
                brush.style:=bsSolid;
                fillrect(slideRect);
                brush.color:=dclBtnFace;
                brush.style:=bsDense4;
                fillrect(slideRect);

                slideRect:=rect;
                slideRect.top:=rect.top+sliderstart+sliderlength;
                slideRect.bottom:=rect.bottom-16;
                brush.color:=clWhite;
                brush.style:=bsSolid;
                fillrect(slideRect);
                brush.color:=dclBtnFace;
                brush.style:=bsDense4;
                fillrect(slideRect);

                x:=rect.left;
                y:=rect.top+sliderstart;
                w:=rect.right;
                h:=y+sliderlength;

                r3d(canvas,types.rect(x,y,w,h));
            end;
            if sbcSubButton in controls then begin
                x:=rect.left;
                y:=rect.top;
                w:=x+16;
                h:=y+16;
                brush.color:=dclBtnFace;
                fillrect(types.rect(x,y,w,h));
                down:=(downcontrol=sbcSubButton);
                r3d(canvas,types.rect(x,y,w,h),down);
                if not down then canvas.Draw(x+5,y+6,toTop)
                else canvas.Draw(x+6,y+7,toTop);
            end;
            if sbcAddButton in controls then begin
                x:=rect.left;
                y:=rect.bottom-16;
                w:=x+16;
                h:=y+16;
                brush.color:=dclBtnFace;
                fillrect(types.rect(x,y,w,h));
                down:=(downcontrol=sbcAddButton);
                r3d(canvas,types.rect(x,y,w,h),down);
                if not down then canvas.Draw(x+5,y+6,toBottom)
                else canvas.Draw(x+6,y+7,toBottom);
                end;
            end;
        end;
    end;
end;

procedure TXPStyle.DrawTabEvent(Sender, Source: TObject;
  Canvas: TCanvas; Index, HorizonalPadding, VerticalPadding,
  Overlap: Integer; Selected: Boolean);
begin
    canvas.FillRect(rect(0,0,100,100));
end;

procedure TXPStyle.GetItemRectEvent(Sender: TObject; Canvas: TCanvas;
  var Rect: TRect; Flags: Integer; Enabled: Boolean; Bitmap: TBitmap;
  const Text: WideString);
begin
    rect.bottom:=rect.bottom-10;
end;

procedure TXPStyle.loaded;
begin
  inherited;
end;

procedure TXPStyle.MenuItemHeightEvent(Sender, Source: TObject;
  Checkable: Boolean; FontMetrics: QFontMetricsH; var Height: Integer);
var
    s: string;
    m: TMenuItem;
begin
    m:=(source as TMenuItem);
    s:=m.Caption;
    if s<>'-' then begin
        height:=17;
        if not (m.bitmap.Empty) then begin
            height:=m.bitmap.height;
            if height=16 then height:=18;
        end;
        if (m.ImageIndex<>-1) then begin
                if (m.getparentmenu<>nil) then begin
                        if m.GetParentmenu.images<>nil then begin
                                height:=m.getparentmenu.Images.Height;
                        end;
                end;
        end;
        if (assigned(m.parent)) then begin
                if m.MenuIndex=m.Parent.Count-1 then begin
                    height:=height+2;
                end;
        end;
    end
    else height:=9;
end;

procedure TXPStyle.OnShowHint(var HintStr: WideString; var CanShow: Boolean; var HintInfo: THintInfo);
begin
    canshow:=true;
    hintinfo.HintPos.Y:=hintinfo.HintPos.Y+48;
end;

end.

