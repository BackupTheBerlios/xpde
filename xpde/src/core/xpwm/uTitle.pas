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
unit uTitle;

interface

uses
  Xlib,SysUtils, Types,
  Classes, QGraphics,
  QControls, QForms, QDialogs,
  QButtons, QStdCtrls,uXPStyleConsts,
  QExtCtrls, uXPAPI;

type
    TTitleForm = class(TForm, IWMFrame)
        btnClose: TBitBtn;
        btnMaximize: TBitBtn;
        btnMinimize: TBitBtn;
        lbTitle: TLabel;
        procedure FormPaint(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormResize(Sender: TObject);
        procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
        procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure btnCloseClick(Sender: TObject);
    procedure btnMaximizeClick(Sender: TObject);
    private
        { Private declarations }
      public
        { Public declarations }
        {
        window: Window;
        client: IWMClient;
        }
        xdisplay: PDisplay;
        gradbmp: TBitmap;
        lastRect: TRect;                                                        //To hold the last rect drawn to prevent repaint the gradient
        brRight: TRect;
        moving: boolean;
        resform4: boolean;
        ox:longint;
        oy:longint;
        
  end;

var
  TitleForm: TTitleForm;

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

procedure TTitleForm.FormPaint(Sender: TObject);

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

        end;
        canvas.Draw(arect.Left,arect.top,gradbmp);
    end;
begin
    with canvas do begin

        //Top Left
        pen.color:=dclBtnFace;
        moveto(0,0);
        lineto(clientwidth-2,0);
        moveto(0,0);
        lineto(0,clientheight-2);

        //Bottom Right
        pen.color:=dclGray;
        moveto(clientwidth-1,0);
        lineto(clientwidth-1,clientheight-1);
        lineto(0,clientheight-1);

        //Top Left 2
        pen.color:=clWhite;
        moveto(1,1);
        lineto(clientwidth-2,1);
        moveto(1,1);
        lineto(1,clientheight-2);

        //Bottom Right 2
        pen.color:=dclBtnShadow;
        moveto(clientwidth-2,1);
        lineto(clientwidth-2,clientheight-2);
        lineto(1,clientheight-2);

        //TopFill
        pen.color:=dclBtnFace;
        moveto(2,2);
        lineto(clientwidth-3,2);
        moveto(2,3);
        lineto(clientwidth-3,3);

        //Bottom Fill
        pen.color:=dclBtnFace;
        moveto(2,22);
        lineto(clientwidth-3,22);
        moveto(2,23);
        lineto(clientwidth-3,23);
        moveto(2,24);
        lineto(clientwidth-3,24);

        //Left
        pen.color:=dclBtnFace;
        moveto(2,4);
        lineto(2,22);
        moveto(3,4);
        lineto(3,22);

        //Right
        pen.color:=dclBtnFace;
        moveto(clientwidth-3,4);
        lineto(clientwidth-3,22);
        moveto(clientwidth-4,4);
        lineto(clientwidth-4,22);

        brush.color:=dclBtnFace;
        rectangle(2,22,clientwidth-2,clientheight-2);

        gradient($6b2408,$f7cba5,Rect(4,4,clientWidth-4,22));
    end;
end;

procedure TTitleForm.FormCreate(Sender: TObject);
begin
    moving:=false;
    resform4:=false;
    gradbmp:=TBitmap.create;
    gradbmp.height:=22;
    gradbmp.Width:=2048;
    btnClose.Width:=16;
    btnClose.Height:=14;
    btnMaximize.Width:=16;
    btnMaximize.Height:=14;
    btnMinimize.Width:=16;
    btnMinimize.Height:=14;
    FormResize(self);
end;

procedure TTitleForm.FormResize(Sender: TObject);
begin
    btnClose.left:=clientwidth-22;
    btnMaximize.left:=btnClose.left-18;
    btnMinimize.left:=btnMaximize.left-16;

    brRight.left:=clientwidth-3;
    brRight.top:=clientheight-13;
    brRight.right:=clientwidth;
    brRight.bottom:=clientheight;
end;

procedure TTitleForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    bringtofront;
    if (ptInRect(Point(x,y),lastRect)) then begin
        moving:=true;
        ox:=x;
        oy:=y;
    end
    else begin
        if (ptInRect(Point(x,y),brRight)) then begin
            resform4:=true;
            ox:=x;
            oy:=y;
        end;
    end;
end;

procedure TTitleForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
    nw,nh:longint;
    r: TRect;
begin
    if moving then begin
        r:=boundsrect;
        r.left:=r.left+(x-ox);
        r.top:=r.top+(y-oy);
        r.Right:=r.left+width;
        r.Bottom:=r.top+height;
        boundsrect:=r;
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

procedure TTitleForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    moving:=false;
    resform4:=false;
end;

procedure TTitleForm.btnCloseClick(Sender: TObject);
begin
//    client.close;
end;


procedure TTitleForm.btnMaximizeClick(Sender: TObject);
begin
//    client.maximize;
end;

end.
