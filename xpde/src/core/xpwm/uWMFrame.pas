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
unit uWMFrame;

interface

uses
  Xlib,SysUtils, Types,
  Classes, QGraphics, uXPStyleConsts,
  QControls, QForms, QDialogs, resample,
  QButtons, QStdCtrls, uWindowManager,
  QExtCtrls, Qt, QMenus, QTypes, uXPPopupMenu;

type
    TWindowsClassic = class(TForm)
        btnClose: TBitBtn;
        btnMaximize: TBitBtn;
        btnMinimize: TBitBtn;
        lbTitle: TLabel;
    restore: TImage;
    maximize: TImage;
    imgIcon: TImage;
    PopupMenu1: TXPPopupMenu;
    Restore1: TMenuItem;
    Move1: TMenuItem;
    Size1: TMenuItem;
    Minimize1: TMenuItem;
    Maximize1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
        procedure FormPaint(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormResize(Sender: TObject);
        procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
        procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure btnCloseClick(Sender: TObject);
        procedure btnMaximizeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDblClick(Sender: TObject);
    procedure imgIconClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    private
        { Private declarations }
      public
        { Public declarations }
        dblclickpending: boolean;
        client:TWMClient;
        mini_icon_a: TBitmap;
        mini_icon_i: TBitmap;
        mini_icon_s: TBitmap;

        icon_s: TBitmap;
        gradbmp: TBitmap;
        lastRect: TRect;                                                        //To hold the last rect drawn to prevent repaint the gradient

        brTopLeft: TRect;
        brTop: TRect;
        brTopRight: TRect;

        brTopLeft2: TRect;
        brTopRight2: TRect;

        brRight: TRect;
        brBottomRight: TRect;
        brBottom: TRect;
        brBottomLeft: TRect;
        brLeft: TRect;
        moving: boolean;
        resizetype: integer;
        ox:longint;
        oy:longint;
        ow: longint;
        oh: longint;
        ore: TRect;
        windowtitle:widestring;
        procedure paintTitle;
        function getFrameBorderSizes:TRect;
        function getOrigin:TPoint;
        procedure setClient(AClient:TWMClient);
        procedure updatewindowtitle;
        procedure setTitle(ATitle:widestring);
        function getTitle:widestring;
        procedure updateActiveState;
        procedure setupIcons;
  end;

var
  WindowsClassic: TWindowsClassic;

const
    iBorder=3;
    iTitleHeight=23;

    rtTopLeft=1;
    rtTop=2;
    rtTopRight=3;
    rtLeft=4;
    rtRight=5;
    rtBottomLeft=6;
    rtBottom=7;
    rtBottomRight=8;

implementation

{$R *.xfm}

function ptInRect(pt:TPoint;rc:TRect):boolean;
begin
    if (pt.x>=rc.Left) and (pt.Y>=rc.top) and (pt.x<=rc.right) and (pt.y<=rc.bottom) then result:=true
    else result:=false;
end;

function rgbtocolor(r,g,b:byte):TColor;
begin
   result:=b shl 16;
   result:=result+(g shl 8);
   result:=result+r;
end;

procedure TWindowsClassic.FormPaint(Sender: TObject);
var
    fbs: TRect;
    co: TPoint;
begin
    fbs:=getframebordersizes;
    co:=getorigin;
    R3D(canvas,clientrect,false,true,false);
     with canvas do begin
        pen.color:=clBtnFace;
        brush.color:=clBtnFace;
        rectangle(fbs.left,co.y-1,clientwidth-fbs.right,co.y-1);

        pen.color:=clBtnFace;
        brush.Style:=bsClear;
        pen.style:=psSolid;
        rectangle(fbs.left-2,fbs.top-2,clientwidth-fbs.right+2,clientheight-fbs.bottom+2);
        rectangle(fbs.left-1,fbs.top-1,clientwidth-fbs.right+1,clientheight-fbs.bottom+1);
        brush.Style:=bsSolid;
        paintTitle;

        pen.color:=clBtnFace;
        moveto(fbs.left-2,co.y-1);
        lineto(clientwidth-2, co.y-1);
     end;
end;

procedure TWindowsClassic.FormCreate(Sender: TObject);
var
    co: TPoint;
begin
    dblclickpending:=false;
    mini_icon_a:=TBitmap.create;
    mini_icon_a.width:=16;
    mini_icon_a.height:=16;

    mini_icon_i:=TBitmap.create;
    mini_icon_i.width:=16;
    mini_icon_i.height:=16;

    mini_icon_s:=TBitmap.create;
    mini_icon_s.width:=16;
    mini_icon_s.height:=16;

    icon_s:=TBitmap.create;
    icon_s.width:=32;
    icon_s.height:=32;

    resizetype:=0;
    client:=nil;
    lbTitle.font.color:=clSilver;
    co:=getorigin;
    moving:=false;
    gradbmp:=TBitmap.create;
    gradbmp.height:=co.y-1;
    gradbmp.Width:=2048;
    btnClose.Width:=16;
    btnClose.Height:=14;
    btnMaximize.Width:=16;
    btnMaximize.Height:=14;
    btnMinimize.Width:=16;
    btnMinimize.Height:=14;
    FormResize(self);
end;

procedure TWindowsClassic.FormResize(Sender: TObject);
begin
    btnClose.left:=clientwidth-22;
    btnMaximize.left:=btnClose.left-18;
    btnMinimize.left:=btnMaximize.left-16;

    brBottomRight.left:=clientwidth-13;
    brBottomRight.top:=clientheight-13;
    brBottomRight.right:=clientwidth;
    brBottomRight.bottom:=clientheight;

    brRight.left:=clientwidth-3;
    brRight.top:=13;
    brRight.right:=clientwidth;
    brRight.bottom:=clientheight-13;

    brTopRight.left:=clientwidth-13;
    brTopRight.top:=0;
    brTopRight.right:=clientwidth;
    brTopRight.bottom:=3;

    brTop.left:=13;
    brTop.top:=0;
    brTop.right:=clientwidth-13;
    brTop.bottom:=3;

    brTopLeft.left:=0;
    brTopLeft.top:=0;
    brTopLeft.right:=13;
    brTopLeft.bottom:=3;

    brTopRight2.left:=clientwidth-3;
    brTopRight2.top:=0;
    brTopRight2.right:=clientwidth;
    brTopRight2.bottom:=13;

    brTopLeft2.left:=0;
    brTopLeft2.top:=0;
    brTopLeft2.right:=3;
    brTopLeft2.bottom:=13;

    brLeft.left:=0;
    brLeft.top:=13;
    brLeft.right:=3;
    brLeft.bottom:=clientheight-13;

    brBottomLeft.left:=0;
    brBottomLeft.top:=clientheight-13;
    brBottomLeft.right:=13;
    brBottomLeft.bottom:=clientheight;

    brBottom.left:=13;
    brBottom.top:=clientheight-13;
    brBottom.right:=clientwidth-13;
    brBottom.bottom:=clientheight;

    FormPaint(self);
end;

procedure TWindowsClassic.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    ow:=clientwidth;
    oh:=clientheight;
    ox:=x;
    oy:=y;
    ore:=boundsrect;
    if assigned(client) then begin
        if (not client.isactive) then client.activate;
        SetCaptureControl((sender as TControl));
        if (ptInRect(Point(x,y),lastRect)) then begin
            if client.windowstate=wsNormal then begin
                moving:=true;
                ox:=x;
                oy:=y;
            end;
        end
        else if (ptInRect(Point(x,y),brBottomRight)) then begin
            resizetype:=rtBottomRight;
        end
        else if (ptInRect(Point(x,y),brTopLeft)) or (ptInRect(Point(x,y),brTopLeft2)) then begin
            resizetype:=rtTopLeft;
        end
        else if (ptInRect(Point(x,y),brRight)) then begin
            resizetype:=rtRight;
        end
        else if (ptInRect(Point(x,y),brLeft)) then begin
            resizetype:=rtLeft;
        end
        else if (ptInRect(Point(x,y),brTopRight)) or (ptInRect(Point(x,y),brTopRight2)) then begin
            resizetype:=rtTopRight;
        end
        else if (ptInRect(Point(x,y),brBottomLeft)) then begin
            resizetype:=rtBottomLeft;
        end
        else if (ptInRect(Point(x,y),brTop)) then begin
            resizetype:=rtTop;
        end
        else if (ptInRect(Point(x,y),brBottom)) then begin
            resizetype:=rtBottom;
        end;
    end;
end;

procedure TWindowsClassic.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
//var
//    r: TRect;
var
    r: TRect;
    nw,nh: integer;
begin
    if moving then begin
//        if th then begin
            XSync(xpwindowmanager.display,1);
            QWidget_move(self.handle,left+(x-ox),top+(y-oy));
            XSync(xpwindowmanager.display,0);
//        end
//        else begin
//            th:=(abs(x-ox)>1) or (abs(y-oy)>1);
//        end;
   end
    else begin
        if resizetype<>0 then begin
            client.beginresize;
            try
            nw:=ow+(x-ox);
            nh:=oh+(y-oy);

            r:=ore;
            case resizetype of
                rtBottomRight: begin
                  r.Right:=r.left+nw;
                  r.bottom:=r.bottom+(y-oy);
                end;

                rtBottom: begin
                  r.bottom:=r.bottom+(y-oy);
                end;

                rtRight: begin
                  r.Right:=r.right+(x-ox);
                end;

                rtTopRight: begin
                  r.Right:=r.right+(x-ox);
                  r.top:=boundsrect.top+(y-oy);
                  if ((r.bottom-r.top)<Constraints.MinHeight) then r.top:=boundsrect.top;
                end;

                rtTop: begin
                  r.top:=boundsrect.top+(y-oy);
                  if ((r.bottom-r.top)<Constraints.MinHeight) then r.top:=boundsrect.top;
                end;

                rtLeft: begin
                  r.left:=boundsrect.left+(x-ox);
                  if ((r.Right-r.Left)<Constraints.MinWidth) then r.left:=boundsrect.left;
                end;

                rtTopLeft: begin
                  r.top:=boundsrect.top+(y-oy);     
                  r.left:=boundsrect.left+(x-ox);
                  if ((r.Right-r.Left)<Constraints.MinWidth) then r.left:=boundsrect.left;
                  if ((r.bottom-r.top)<Constraints.MinHeight) then r.top:=boundsrect.top;
                end;

                rtBottomLeft: begin
                  r.bottom:=r.bottom+(y-oy);
                  r.left:=boundsrect.left+(x-ox);
                  if ((r.Right-r.Left)<Constraints.MinWidth) then r.left:=boundsrect.left;
                end;

            end;

            boundsrect:=r;

            if assigned(client) then begin
                XResizeWindow(XPWindowManager.Display,client.getwindow,(clientwidth-iBorder*2)-2,(clientheight-iBorder*2-iTitleHeight)+2);
            end;
            finally
                client.endresize;
            end;



            {
            if resizetype=rtBottomRight then begin
                QWidget_resize(self.handle,nw,nh);
                if assigned(client) then begin
                    XResizeWindow(XPWindowManager.Display,client.getwindow,(clientwidth-iBorder*2)-2,(clientheight-iBorder*2-iTitleHeight)+2);
                end;
            end
            else
            if resizetype=rtRight then begin
                QWidget_resize(self.handle,nw,oh);
                if assigned(client) then begin
                    XResizeWindow(XPWindowManager.Display,client.getwindow,(clientwidth-iBorder*2)-2,(clientheight-iBorder*2-iTitleHeight)+2);
                end;
            end
            else
            if resizetype=rtBottom then begin
                QWidget_resize(self.handle,ow,nh);
                if assigned(client) then begin
                    XResizeWindow(XPWindowManager.Display,client.getwindow,(clientwidth-iBorder*2)-2,(clientheight-iBorder*2-iTitleHeight)+2);
                end;
            end;

            if resizetype=rtTop then begin

                r.top:=r.top+(y-oy);
                boundsrect:=r;
                if assigned(client) then begin
                    XResizeWindow(XPWindowManager.Display,client.getwindow,(clientwidth-iBorder*2)-2,(clientheight-iBorder*2-iTitleHeight)+2);
                end;
            end;
            }
            
        end
        else begin
            if (ptInRect(Point(x,y),brBottomRight)) or (ptInRect(Point(x,y),brTopLeft)) or (ptInRect(Point(x,y),brTopLeft2)) then begin
                screen.cursor:=crSizeNWSE;
            end
            else if (ptInRect(Point(x,y),brRight)) or (ptInRect(Point(x,y),brLeft)) then begin
                screen.cursor:=crSizeWE;
            end
            else if (ptInRect(Point(x,y),brTopRight)) or (ptInRect(Point(x,y),brTopRight2)) or  (ptInRect(Point(x,y),brBottomLeft)) then begin
                screen.cursor:=crSizeNESW;
            end
            else if (ptInRect(Point(x,y),brTop)) or  (ptInRect(Point(x,y),brBottom)) then begin
                screen.cursor:=crSizeNS;
            end
            else begin
                screen.cursor:=crDefault;
                //XPAPI.setDefaultCursor;
            end;
        end;
    end;
end;

procedure TWindowsClassic.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    resizetype:=0;
    moving:=false;
    SetCaptureControl(nil);
    if dblclickpending then begin
        dblclickpending:=false;
        btnMaximizeClick(btnMaximize);
    end
    else begin

    end;
end;

procedure TWindowsClassic.btnCloseClick(Sender: TObject);
begin
    if assigned(client) then client.close;
end;


procedure TWindowsClassic.btnMaximizeClick(Sender: TObject);
begin
    if assigned(client) then begin
        if client.windowstate<>wsMaximized then begin
            client.maximize;
            btnMaximize.glyph.Assign(restore.picture.graphic);
            FormPaint(self);
            Restore1.Enabled:=true;
            Maximize1.Enabled:=false;
        end
        else begin
            client.restore;
            btnMaximize.glyph.Assign(maximize.picture.graphic);
            FormPaint(self);
            Restore1.Enabled:=false;
            Maximize1.Enabled:=true;
        end;
    end;
end;

procedure TWindowsClassic.setClient(AClient: TWMClient);
begin
    client:=AClient;
end;

function TWindowsClassic.getFrameBorderSizes: TRect;
begin
    result.left:=4;
    result.top:=4;
    result.right:=4;
    result.bottom:=4;
end;

procedure TWindowsClassic.updateActiveState;
begin
    if assigned(client) then begin
        lastrect.right:=lastrect.right-1;
        if client.isactive then lbTitle.Font.color:=clWhite
        else lbTitle.Font.color:=clSilver;
        paintTitle;
    end;
end;

function TWindowsClassic.getOrigin: TPoint;
begin
    result.X:=4;
    result.Y:=23;
end;

procedure TWindowsClassic.setTitle(ATitle: widestring);
begin
    windowtitle:=ATitle;
    updatewindowtitle;
end;

function TWindowsClassic.getTitle: widestring;
begin
    result:=windowtitle;
end;

procedure TWindowsClassic.paintTitle;
    procedure gradient(startColor,endColor: TColor;arect:TRect);
    var
        sr,sg,sb: byte;
        er,eg,eb: byte;

        dr,dg,db: extended;
        ir,ig,ib: extended;
        dx: longint;

        x: longint;
        step: longint;
        limit: longint;
        lbottom:longint;
    begin
        if arect.right<>lastrect.right then begin
            lastrect:=arect;
            limit:=arect.right-arect.left;
            lbottom:=arect.bottom-arect.top;

            gradbmp.width:=limit;
            gradbmp.height:=lbottom;

            step:=6;
            dx:=limit div step;
            if dx=0 then dx:=1;

            sr:=startColor;
            sg:=startColor shr 8;
            sb:=startColor shr 16;

            er:=endColor;
            eg:=endColor shr 8;
            eb:=endColor shr 16;

            dr:=(er-sr) / dx;
            dg:=(eg-sg) / dx;
            db:=(eb-sb) / dx;


            x:=0;
            ir:=sr;
            ig:=sg;
            ib:=sb;

            while x<limit-step do begin
                gradbmp.canvas.brush.color:=rgbtocolor(round(ir),round(ig),round(ib));
                gradbmp.canvas.fillrect(rect(x,0,x+step+3,lbottom));
                ir:=ir+dr;
                ig:=ig+dg;
                ib:=ib+db;
                x:=x+step;
            end;
            gradbmp.canvas.brush.color:=endcolor;
            gradbmp.canvas.fillrect(rect(limit-step,0,limit,lbottom));
            imgIcon.picture.Graphic.Transparent:=true;

//            gradbmp.Canvas.StretchDraw(rect(1,1,17,17),imgIcon.picture.graphic);
            if client.isactive then begin
                mini_icon_a.Transparent:=false;
                gradbmp.Canvas.Draw(1,1,mini_icon_a);
            end
            else begin
                mini_icon_i.Transparent:=false;
                gradbmp.Canvas.Draw(1,1,mini_icon_i);
            end;
        end;
        canvas.Draw(arect.Left,arect.top,gradbmp);
    end;
var
    fbs: TRect;
    co: TPoint;
begin
    if assigned(client) then begin
        fbs:=getframebordersizes;
        co:=getorigin;
        if client.isactive then begin
            gradient($6b2408,$f7cba5,Rect(fbs.left,fbs.top,clientWidth-(fbs.right),co.y-1));
        end
        else begin
            gradient(clGray,clSilver,Rect(fbs.left,fbs.top,clientWidth-(fbs.right),co.y-1))
        end;
        updatewindowtitle;
    end;
end;

procedure TWindowsClassic.FormDestroy(Sender: TObject);
begin
    mini_icon_a.free;
    mini_icon_i.free;
    mini_icon_s.free;
    icon_s.free;
    gradbmp.free;
end;

procedure TWindowsClassic.btnMinimizeClick(Sender: TObject);
begin
    if assigned(client) then begin
        if client.windowstate<>wsMinimized then begin
            client.minimize;
        end
        else begin
            client.restore;
        end;
    end;
end;

procedure TWindowsClassic.updatewindowtitle;
var
    w: integer;
    fw: integer;
    wc: widestring;
    k: integer;
begin
    wc:=windowtitle;

    k:=1;
    canvas.Font.assign(lbTitle.font);
    w:=canvas.TextWidth(wc);
    fw:=(btnMinimize.left-lbTitle.Left)-2;

    while w>fw do begin
        wc:=copy(windowtitle,1,length(windowtitle)-k)+'...';
        w:=canvas.TextWidth(wc);
        inc(k);
    end;

    lbTitle.Caption:=wc;

end;

procedure TWindowsClassic.setupIcons;
var
    s: TBitmap;
    m: TBitmap;
    x,y: integer;
begin
    s:=TBitmap.create;
    try
        s.Canvas.Brush.Color:=$6b2408;
        s.canvas.pen.color:=$6b2408;
        s.width:=imgIcon.picture.bitmap.width;
        s.height:=imgIcon.picture.bitmap.height;
        s.Canvas.Draw(0,0,imgIcon.picture.bitmap);
        strecth(s,mini_icon_a,resampleFilters[1].filter,resamplefilters[1].width);
    finally
        s.free;
    end;

    s:=TBitmap.create;
    try
        s.Canvas.Brush.Color:=clGray;
        s.canvas.pen.color:=clGray;
        s.width:=imgIcon.picture.bitmap.width;
        s.height:=imgIcon.picture.bitmap.height;
        s.Canvas.Draw(0,0,imgIcon.picture.bitmap);
        strecth(s,mini_icon_i,resampleFilters[1].filter,resamplefilters[1].width);
    finally
        s.free;
    end;

    m:=TBitmap.create;
    try

        m.width:=16;
        m.height:=16;
        m.Canvas.Brush.Color:=clFuchsia;
        m.canvas.pen.color:=clFuchsia;
        m.Canvas.StretchDraw(rect(0,0,16,16),imgIcon.Picture.Bitmap);

        strecth(imgIcon.picture.bitmap,mini_icon_s,resampleFilters[1].filter,resamplefilters[1].width);

        for y:=0 to 15 do begin
            for x:=0 to 15 do begin
                if m.Canvas.Pixels[x,y]=clFuchsia then begin
                    mini_icon_s.Canvas.Pixels[x,y]:=clFuchsia;
                end;
            end;
        end;
    finally
        m.free;
    end;

    m:=TBitmap.create;
    try

        m.width:=32;
        m.height:=32;
        m.Canvas.Brush.Color:=clFuchsia;
        m.canvas.pen.color:=clFuchsia;
        m.Canvas.StretchDraw(rect(0,0,32,32),imgIcon.Picture.Bitmap);

        strecth(imgIcon.picture.bitmap,icon_s,resampleFilters[1].filter,resamplefilters[1].width);

        for y:=0 to 31 do begin
            for x:=0 to 31 do begin
                if m.Canvas.Pixels[x,y]=clFuchsia then begin
                    icon_s.Canvas.Pixels[x,y]:=clFuchsia;
                end;
            end;
        end;
    finally
        m.free;
    end;
end;

procedure TWindowsClassic.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    showmessage(inttostr(key));
end;

procedure TWindowsClassic.FormDblClick(Sender: TObject);
begin
    if ptinrect(point(ox,oy),rect(1,1,17,17)) then begin
        btnClose.Click;
    end
    else dblclickpending:=true;
end;

procedure TWindowsClassic.imgIconClick(Sender: TObject);
begin
//    PopupMenu1.Popup(Mouse.CursorPos.x,Mouse.Cursorpos.y);
end;

procedure TWindowsClassic.FormClick(Sender: TObject);
begin
    if ptinrect(point(ox,oy),rect(1,1,17,17)) then begin
        PopupMenu1.Popup(mouse.CursorPos.x,mouse.cursorpos.y);
    end;
end;

initialization
    XPWindowManager.Frame:=TWindowsClassic;

end.
