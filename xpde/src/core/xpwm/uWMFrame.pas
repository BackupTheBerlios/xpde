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
  QControls, QForms, QDialogs,
  QButtons, QStdCtrls, uWindowManager,
  QExtCtrls, Qt;

type
    TWindowsClassic = class(TForm)
        btnClose: TBitBtn;
        btnMaximize: TBitBtn;
        btnMinimize: TBitBtn;
        lbTitle: TLabel;
    restore: TImage;
    maximize: TImage;
    imgIcon: TImage;
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
    private
        { Private declarations }
      public
        { Public declarations }
        client:TWMClient;
        gradbmp: TBitmap;
        lastRect: TRect;                                                        //To hold the last rect drawn to prevent repaint the gradient
        brRight: TRect;
        moving: boolean;
        ox:longint;
        oy:longint;
        windowtitle:string;
        procedure paintTitle;
        function getFrameBorderSizes:TRect;
        function getOrigin:TPoint;
        procedure setClient(AClient:TWMClient);
        procedure updatewindowtitle;
        procedure setTitle(ATitle:string);
        function getTitle:string;        
        procedure updateActiveState;
  end;

var
  WindowsClassic: TWindowsClassic;

const
    iBorder=3;
    iTitleHeight=23;

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

    brRight.left:=clientwidth-3;
    brRight.top:=clientheight-13;
    brRight.right:=clientwidth;
    brRight.bottom:=clientheight;

    FormPaint(self);
end;

procedure TWindowsClassic.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if assigned(client) then begin
        if (not client.isactive) then client.activate;
        SetCaptureControl((sender as TControl));
        if (ptInRect(Point(x,y),lastRect)) then begin
            if client.windowstate=wsNormal then begin
                moving:=true;
                ox:=x;
                oy:=y;
            end;
        end;
    end;
end;

procedure TWindowsClassic.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
//var
//    r: TRect;
begin
    if moving then begin
        {
        r:=boundsrect;
        r.left:=r.left+(x-ox);
        r.top:=r.top+(y-oy);
        r.Right:=r.left+width;
        r.Bottom:=r.top+height;
        }


        XSync(xpwindowmanager.display,1);
        QWidget_move(self.handle,left+(x-ox),top+(y-oy));
//        sendsyn(qwidget_winid(self.handle));
        XSync(xpwindowmanager.display,0);

//        XSync(XPWindowManager.Display,0);
//        boundsrect:=r;
//        XSync(XPWindowManager.Display,0);
   end
    else begin
    {
        if resform4 then begin
            nw:=width+(x-ox);
            nh:=height+(y-oy);

            ox:=x;
            oy:=y;
            if assigned(client) then begin
                XResizeWindow(XPWindowManager.getDisplay,client.getwindow,nw-iBorder*2,nh-iBorder*2-iTitleHeight);
            end;
            width:=nw;
            height:=nh;
        end
        else begin
            if (ptInRect(Point(x,y),brRight)) then begin
                screen.cursor:=crSizeNWSE;
            end
            else begin
                XPAPI.setDefaultCursor;
            end;
        end;
    }
    end;
end;

procedure TWindowsClassic.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    moving:=false;
    SetCaptureControl(nil);    
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
            repaint;
            btnMaximize.glyph.Assign(restore.picture.graphic);
        end
        else begin
            client.restore;
            repaint;
            btnMaximize.glyph.Assign(maximize.picture.graphic);
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

procedure TWindowsClassic.setTitle(ATitle: string);
begin
    windowtitle:=ATitle;
    updatewindowtitle;
end;

function TWindowsClassic.getTitle: string;
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
            gradbmp.Canvas.Draw(0,0,imgIcon.picture.graphic);
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
    wc: string;
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

initialization
    XPWindowManager.Frame:=TWindowsClassic;

end.
