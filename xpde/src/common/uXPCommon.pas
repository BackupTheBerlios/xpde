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
unit uXPCommon;

interface

uses QForms,QGraphics,Types,Libc, Xlib, Qt;

procedure MergeBitmaps(source1,source2,target:TBitmap;dens:longint);
procedure MaskedBitmap(orig:TBitmap;result:TBitmap);
procedure spawn(const cmd:string);

implementation

var
    fina:integer;
    aEBX, aESI, aEDI, aESP, aEBP, Dens1, Dens2: Longint;

procedure MergeBitmaps(source1,source2,target:TBitmap;dens:longint);
var
    i: longint;
    ptz: pointer;
    ptt: pointer;
    ptf: pointer;
    w:longint;
    bmz:TBitmap;
    bmf:TBitmap;
    bmt:TBitmap;
const
    Maxize = (1294967280 Div SizeOf(TPoint));
    MaxPixelCount = 32768;
    Mask0101 = $00FF00FF;
    Mask1010 = $FF00FF00;
begin
    bmz:=TBitmap.create;
    bmf:=TBitmap.create;
    bmt:=TBitmap.create;

    bmz.PixelFormat:=pf32bit;
    bmf.PixelFormat:=pf32bit;
    bmt.PixelFormat:=pf32bit;

    bmz.width:=source1.width;
    bmz.height:=source1.height;

    bmf.width:=source1.width;
    bmf.height:=source1.height;

    bmt.width:=source1.width;
    bmt.height:=source1.height;


    bmF.Canvas.brush.color:=clFuchsia;    
    bmF.Canvas.Draw(0, 0, source1);
    bmT.Canvas.Draw(0, 0, source2);
    bmZ.Canvas.Draw(0, 0, bmF);

    w:=bmz.width;
    for i := 0 to bmz.height - 1 do begin
        Ptz := bmz.Scanline[i];
        Ptt := bmt.Scanline[i];
        Ptf := bmf.Scanline[i];
            asm
		        MOV &aEBX, EBX
		        MOV &aEDI, EDI
		        MOV &aESI, ESI
		        MOV &aESP, ESP
		        MOV &aEBP, EBP

		        MOV EBX, Dens
		        MOV Dens1, EBX

		        NEG BL
		        ADD BL, $20
		        MOV Dens2, EBX
		        CMP Dens1, 0
		        JZ  @Final

		        MOV EDI, ptz
		        MOV ESI, ptt
		        MOV ECX, ptf

		        MOV EAX, w
		        lea EAX, [EAX+EAX*2+3]
		        ADD EAX,w
		        AND EAX, $FFFFFFFC
		        ADD EAX, EDI
		        MOV FinA, EAX

		        MOV EBP,EDI
		        MOV ESP,ESI
		        MOV ECX,ECX

            @LOOPA:
		        MOV  EAX, [EBP]
		        MOV  EDI, [ESP]
		        MOV  EBX, EAX
		        AND  EAX, Mask1010
		        AND  EBX, Mask0101
		        SHR  EAX, 5
		        IMUL EAX, Dens2
		        IMUL EBX, Dens2
		        MOV  ESI, EDI
		        AND  EDI, Mask1010
		        AND  ESI, Mask0101
		        SHR  EDI, 5
		        IMUL EDI, Dens1
		        IMUL ESI, Dens1
		        ADD  EAX, EDI
		        ADD  EBX, ESI
		        AND  EAX, Mask1010
		        SHR  EBX, 5
		        AND  EBX, Mask0101
		        OR   EAX, EBX
		        MOV [ECX], EAX

		        ADD  EBP, 4
		        ADD  ESP, 4
		        ADD  ECX, 4

		        CMP  EBP, FinA
		        JNE  @LOOPA
            @final:
		        MOV EBX, &aEBX
		        MOV EDI, &aEDI
		        MOV ESI, &aESI
		        MOV ESP, &aESP
		        MOV EBP, &aEBP
            end;
        end;
        target.assign(bmf);
        bmz.free;
        bmf.free;
        bmt.free;
end;


procedure MaskedBitmap(orig:TBitmap;result:TBitmap);
var
    mask:TBitmap;
    source: TBitmap;
begin
    mask:=TBitmap.create;
    source:=TBitmap.create;
    try
        source.width:=orig.width;
        source.height:=orig.height;

        result.width:=orig.width;
        result.height:=orig.height;

        source.Canvas.brush.color:=clFuchsia;
        source.Canvas.draw(0,0,orig);
        source.transparent:=true;

        mask.width:=source.width;
        mask.height:=source.height;

        mask.Canvas.brush.color:=clHighLight;
        mask.Canvas.pen.color:=clHighLight;
        mask.Canvas.fillrect(rect(0,0,source.width,source.height));

        MergeBitmaps(source,mask,result,14);
    finally
        source.free;
        mask.free;
    end;
end;

procedure spawn(const cmd:string);
begin
    if (fork = 0) then begin
	    execlp(PChar(cmd), PChar(cmd), nil, 0);
    end;
end;

end.
