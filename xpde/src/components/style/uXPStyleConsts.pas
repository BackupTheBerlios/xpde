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
unit uXPStyleConsts;

interface

uses QForms,QGraphics,Types,Libc, Xlib, Qt;

const
    sDefaultFontName='tahoma';
    iDefaultFontSize=10;
    iDefaultFontHeight=11;
    dclBtnShadow=$848284;
    dclGray=$424142;
    dclHighLight=$6a2408;
    dclBtnFace=$cdd2d5;
    dclBtnHighlight=$FFFFFF;
    sTimeFormat='hh:mm';
    dclDesktopBackground=$A56D39;

    gDEFAULTCURSOR='defaultcursor.png';
    gNOICON='document.png';
    gNOICONSMALL='noiconsm.png';
    gSHORTCUT='shortcut.png';
    gFOLDER='folder.png';
    gMYDOCUMENTS='folder2.png';
    gMYCOMPUTER='mycomputer.png';
    gMYHOME='folder_home.png';
    gMYNETWORKPLACES='network.png';
    gRECYCLEBINEMPTY='trashcan_empty.png';
    gFOLDERSMALL='foldersmall.png';
    gSHORTCUTSMALL='shortcutsmall.png';
    gCREATESHORTCUTWIZARD='createshortcutwizard.png';
    gSTARTBUTTON='startbutton.png';
    gPROGRAMS='programs.png';
    gDOCUMENTS='documents.png';
    gSETTINGS='settings.png';
    gSEARCH='filefind.png';
    gHELPANDSUPPORT='helpandsupport.png';
    gRUN='run.png';
    gLOGOFF='logoff.png';
    gTURNOFF='turnoff.png';
    gPROGRAMFOLDER='programfolder.png';
    gSTARTMENU='startmenu.png';
    gDESKTOPPROPERTIESMONITOR='desktoppropertiesmonitor.png';
    gWAITCURSOR='waitcursor.png';
    gNONE='none.png';
    gBMP='bmp.png';
    gJPG='jpg.png';

type
    TWindowsGlyph=(wgRestore, wgMinimize, wgMaximize, wgClose);

procedure R3D(canvas:TCanvas;r:TRect;flat:boolean=false;raised:boolean=true;fill:boolean=true);
procedure drawButton(canvas:TCanvas;r:TRect;down:boolean=false;fill:boolean=true;isdefault:boolean=false);
procedure drawWindowsGlyph(canvas:TCanvas;x,y:integer;glyph:TWindowsGlyph;enabled:boolean;highlight:boolean);

implementation

procedure drawWindowsGlyph(canvas:TCanvas;x,y:integer;glyph:TWindowsGlyph;enabled:boolean;highlight:boolean);
    procedure drawGlyph;
    begin
        with canvas do begin
        case glyph of
            wgMinimize: begin

                moveto(x+2,y+7);
                lineto(x+8,y+7);

                moveto(x+2,y+8);
                lineto(x+8,y+8);
            end;
            wgClose: begin
                moveto(x+1,y+1);
                lineto(x+8,y+8);

                moveto(x+2,y+1);
                lineto(x+9,y+8);

                moveto(x+8,y+0);
                lineto(x+1,y+7);

                moveto(x+9,y+0);
                lineto(x+2,y+7);
            end;
            wgMaximize: begin

                Rectangle(x+1,y+0,x+10,y+9);

                moveto(x+1,y+1);
                lineto(x+9,y+1);
            end;
            wgRestore: begin

                Rectangle(x+3,y+0,x+9,y+6);

                moveto(x+3,y+1);
                lineto(x+9,y+1);


                Rectangle(x+1,y+3,x+7,y+9);

                moveto(x+1,y+4);
                lineto(x+7,y+4);
            end;
        end;
        end;
    end;
begin
    with canvas do begin
        if enabled then begin
            if highlight then begin
                pen.color:=clWhite;
                drawglyph;
            end
            else begin
                pen.color:=clBlack;
                drawglyph;
            end;
        end
        else begin
            if not highlight then begin
                pen.color:=clWhite;
                x:=x+1;
                y:=y+1;
                drawglyph;
                x:=x-1;
                y:=y-1;
            end;
            pen.color:=dclbtnShadow;
            drawglyph;            
        end;
    end;
end;

procedure R3D(canvas:TCanvas;r:TRect;flat:boolean=false;raised:boolean=true;fill:boolean=true);
begin
    with canvas do begin
        if not flat then begin
            pen.mode:=pmCopy; 
            if raised then begin
                //Top Left
                pen.color:=dclBtnFace;
                moveto(r.left,r.top);
                lineto(r.right-2,r.top);
                moveto(r.left,r.top);
                lineto(r.left,r.bottom-2);
                //Bottom Right
                pen.color:=dclGray;
                moveto(r.right-1,r.top);
                lineto(r.right-1,r.bottom);
                moveto(r.left,r.bottom-1);
                lineto(r.right,r.bottom-1);
                //Top Left 2
                pen.color:=clWhite;
                moveto(r.left+1,r.top+1);
                lineto(r.right-2,r.top+1);
                moveto(r.left+1,r.top+1);
                lineto(r.Left+1,r.bottom-2);
                //Bottom Right 2
                pen.color:=dclBtnShadow;
                moveto(r.right-2,r.top+1);
                lineto(r.right-2,r.bottom-1);
                moveto(r.left+1,r.bottom-2);
                lineto(r.right-1,r.bottom-2);
            end
            else begin
                //Top Left
                pen.color:=dclBtnShadow;
                moveto(r.left,r.top);
                lineto(r.right-1,r.top);
                moveto(r.left,r.top);
                lineto(r.left,r.bottom-1);
                //Bottom Right
                pen.color:=clWhite;
                moveto(r.right-1,r.top+1);
                lineto(r.right-1,r.bottom);
                moveto(r.left+1,r.bottom-1);
                lineto(r.right,r.bottom-1);
                //Top Left 2
                pen.color:=dclGray;
                moveto(r.left+1,r.top+1);
                lineto(r.right-2,r.top+1);
                moveto(r.left+1,r.top+1);
                lineto(r.Left+1,r.bottom-2);
                //Bottom Right 2
                pen.color:=dclBtnFace;
                moveto(r.right-2,r.top+1);
                lineto(r.right-2,r.bottom-1);
                moveto(r.left+1,r.bottom-2);
                lineto(r.right-1,r.bottom-2);
            end;
            if fill then begin
                brush.Style:=bsSolid;
                inflaterect(r,-2,-2);
                fillrect(r);
            end;
        end
        else begin
            pen.mode:=pmCopy; 
            if raised then begin
                //Top Left
                pen.color:=clWhite;
                moveto(r.left,r.top);
                lineto(r.right-1,r.top);
                moveto(r.left,r.top);
                lineto(r.left,r.bottom-1);
                //Bottom Right
                pen.color:=dclBtnShadow;
                moveto(r.right-1,r.top);
                lineto(r.right-1,r.bottom);
                moveto(r.left,r.bottom-1);
                lineto(r.right,r.bottom-1);
            end
            else begin
                //Top Left
                pen.color:=dclBtnShadow;
                moveto(r.left,r.top);
                lineto(r.right-1,r.top);
                moveto(r.left,r.top);
                lineto(r.left,r.bottom-1);
                //Bottom Right
                pen.color:=clWhite;
                moveto(r.right-1,r.top);
                lineto(r.right-1,r.bottom);
                moveto(r.left,r.bottom-1);
                lineto(r.right,r.bottom-1);
            end;
            if fill then begin
                brush.Style:=bsSolid;
                inflaterect(r,-1,-1);
                fillrect(r);
            end;
        end;
    end;
end;

procedure drawButton(canvas:TCanvas;r:TRect;down:boolean=false;fill:boolean=true;isdefault:boolean=false);
begin
    with canvas do begin
        if isdefault then begin
            pen.color:=clBlack;
            brush.color:=dclBtnFace;
            rectangle(r);
            inflaterect(r,-1,-1);
        end;
            if not down then begin
                //Top Left
                pen.color:=clWhite;
                moveto(r.left,r.top);
                lineto(r.right-2,r.top);
                moveto(r.left,r.top);
                lineto(r.left,r.bottom-2);
                //Bottom Right
                pen.color:=dclGray;
                moveto(r.right-1,r.top);
                lineto(r.right-1,r.bottom);
                moveto(r.left,r.bottom-1);
                lineto(r.right,r.bottom-1);
                //Bottom Right 2
                pen.color:=dclBtnShadow;
                moveto(r.right-2,r.top+1);
                lineto(r.right-2,r.bottom-1);
                moveto(r.left+1,r.bottom-2);
                lineto(r.right-1,r.bottom-2);
            end
            else begin
                //Top Left
                pen.color:=dclGray;
                moveto(r.left,r.top);
                lineto(r.right-1,r.top);
                moveto(r.left,r.top);
                lineto(r.left,r.bottom-1);
                //Bottom Right
                pen.color:=clWhite;
                moveto(r.right-1,r.top);
                lineto(r.right-1,r.bottom);
                moveto(r.left,r.bottom-1);
                lineto(r.right,r.bottom-1);
                //Top Left 2
                pen.color:=dclBtnShadow;
                moveto(r.left+1,r.top+1);
                lineto(r.right-2,r.top+1);
                moveto(r.left+1,r.top+1);
                lineto(r.Left+1,r.bottom-2);
                //Bottom Right 2
                pen.color:=dclBtnFace;
                moveto(r.right-2,r.top+1);
                lineto(r.right-2,r.bottom-1);
                moveto(r.left+1,r.bottom-2);
                lineto(r.right-1,r.bottom-2);
            end;
            if fill then begin
                brush.color:=dclBtnFace;
                brush.Style:=bsSolid;
                inflaterect(r,-2,-2);
                fillrect(r);
            end;
    end;
end;

end.
