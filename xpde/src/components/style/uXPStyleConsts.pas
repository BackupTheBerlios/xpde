{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 Jos� Le�n Serna <ttm@xpde.com>                           }
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
    iDefaultFontSize=9;
    iDefaultFontHeight=11;
    dclBtnShadow=$848284;
    dclGray=$424142;
    dclHighLight=$6a2408;
    dclBtnFace=$cdd2d5;
    dclBtnHighlight=$FFFFFF;
    sTimeFormat='hh:mm';
    dclDesktopBackground=$A56D39;

    sDEFAULTCURSOR='defaultcursor.png';
    sNOICON='noicon.png';
    sNOICONSMALL='noiconsm.png';
    sSHORTCUT='shortcut.png';
    sFOLDER='folder.png';
    sMYDOCUMENTS='mydocuments.png';
    sMYCOMPUTER='mycomputer.png';
    sMYHOME='myhome.png';
    sMYNETWORKPLACES='mynetworkplaces.png';
    sRECYCLEBINEMPTY='recyclebinempty.png';
    sFOLDERSMALL='foldersmall.png';
    sSHORTCUTSMALL='shortcutsmall.png';
    sCREATESHORTCUTWIZARD='createshortcutwizard.png';
    sSTARTBUTTON='startbutton.png';
    sPROGRAMS='programs.png';
    sDOCUMENTS='documents.png';
    sSETTINGS='settings.png';
    sSEARCH='search.png';
    sHELPANDSUPPORT='helpandsupport.png';
    sRUN='run.png';
    sLOGOFF='logoff.png';
    sTURNOFF='turnoff.png';
    sPROGRAMFOLDER='programfolder.png';
    sSTARTMENU='startmenu.png';
    sDESKTOPPROPERTIESMONITOR='desktoppropertiesmonitor.png';
    sWAITCURSOR='waitcursor.png';
    sNONE='none.png';
    sBMP='bmp.png';
    sJPG='jpg.png';

procedure R3D(canvas:TCanvas;r:TRect;flat:boolean=false;raised:boolean=true;fill:boolean=true);
procedure drawButton(canvas:TCanvas;r:TRect;down:boolean=false;fill:boolean=true;isdefault:boolean=false);

implementation

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
            brush.Style:=bsSolid;
            brush.color:=dclBtnFace;
            pen.color:=dclBtnShadow;
            rectangle(r);
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