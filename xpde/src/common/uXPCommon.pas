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

uses QForms,QGraphics,Types,
     Libc, Xlib, Qt,
     Classes, SysUtils, QDialogs;

procedure MergeBitmaps(source1,source2,target:TBitmap;dens:longint);
procedure AlphaBitmap(source1,source2,target:TBitmap;dens:longint);
procedure SelectedBitmap(source1,source2,target:TBitmap;dens:longint);
procedure MaskedBitmap(orig:TBitmap;result:TBitmap);
procedure spawn(const cmd:string);
function CopyFile(const Source, Destination: string): Boolean;
function pixel(bmp: TBitmap;x,y:integer): integer;
procedure bitblt(source:TBitmap;target:TBitmap;const x,y,w,h:integer);
procedure bitblt2(source:TBitmap;target:TBitmap;const x,y,w,h:integer);

implementation

function pixel(bmp: TBitmap;x,y:integer): integer;
var
    points: pointer;
begin
    points:=bmp.ScanLine[y];
    inc(PChar(points),x*4);
    result:=integer(points^);
end;

procedure bitblt(source:TBitmap;target:TBitmap;const x,y,w,h:integer);
var
   spoints: pointer;
   tpoints: pointer;
   t,l: integer;
begin
    for t:=y to (y+h)-1 do begin
        spoints:=source.ScanLine[t];
        tpoints:=target.scanline[t-y];
        inc(PChar(spoints),x*4);
        for l:=x to (x+w)-1 do begin
            integer(tpoints^):=integer(spoints^);
            inc(PChar(tpoints),4);
            inc(PChar(spoints),4);
        end;
    end;
end;

procedure bitblt2(source:TBitmap;target:TBitmap;const x,y,w,h:integer);
var
   spoints: pointer;
   tpoints: pointer;
   t,l: integer;
begin
    for t:=0 to h-1 do begin
        spoints:=source.ScanLine[t];
        tpoints:=target.scanline[t+y];
        inc(PChar(tpoints),x*4);
        for l:=0 to w-1 do begin
            integer(tpoints^):=integer(spoints^);
            inc(PChar(tpoints),4);
            inc(PChar(spoints),4);
        end;
    end;
end;

procedure AlphaBitmap(source1,source2,target:TBitmap;dens:longint);
var
    aEBX, aESI, aEDI, aESP, aEDX, Dens1, Dens2: Longint;
    i: longint;
    ptz: pointer;
    ptt: pointer;
    ptf: pointer;
    w:longint;
    bmz:TBitmap;
    bmf:TBitmap;
    bmt:TBitmap;
    fina:integer;
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


    bmF.Assign(source1);
    bmt.assign(source2);
    bmZ.assign(bmf);

    w:=bmz.width;

    for i := 0 to bmz.height - 1 do begin
        Ptz := bmz.Scanline[i];
        Ptt := bmt.Scanline[i];
        Ptf := bmf.Scanline[i];
            asm
		        MOV aEBX, EBX
		        MOV aEDI, EDI
		        MOV aESI, ESI
		        MOV aESP, ESP
		        MOV aEDX, EDX

		        MOV EBX, Dens
		        MOV Dens1, EBX

		        NEG BL
		        ADD BL, $20
		        MOV Dens2, EBX
//		        CMP Dens1, 0
//		        JZ  @Final

		        MOV EDI, ptz
		        MOV ESI, ptt
		        MOV ECX, ptf

		        MOV EAX, w
		        lea EAX, [EAX+EAX*2+3]
		        ADD EAX,w
		        AND EAX, $FFFFFFFC
		        ADD EAX, EDI
		        MOV FinA, EAX

		        MOV EDX,EDI
		        MOV ESP,ESI
		        MOV ECX,ECX

            @LOOPA:
		        MOV  EAX, [EDX]
                SHR EAX, 24

		        MOV EBX, EAX
                ADD EBX, dens
                CMP EBX, $20
                JNG @p
                MOV EBX, $20
            @p:
		        MOV Dens1, EBX
		        NEG BL
		        ADD BL, $20
		        MOV Dens2, EBX
		        CMP Dens1, 0
		        JZ  @sig

		        MOV  EAX, [EDX]
		        MOV  EDI, [ESP]
                CMP EAX, $FFFFFFFF
                JZ @mask
             @again:
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
            @sig:
		        ADD  EDX, 4
		        ADD  ESP, 4
		        ADD  ECX, 4

		        CMP  EDX, FinA
		        JNE  @LOOPA
                JE  @final
            @mask:
		        MOV  EAX, EDI
		        MOV [ECX], EAX
                jmp  @sig
            @final:
		        MOV EBX, aEBX
		        MOV EDI, aEDI
		        MOV ESI, aESI
		        MOV ESP, aESP
		        MOV EDX, aEDX
            end;
        end;
        
        target.assign(bmf);
        bmz.free;
        bmf.free;
        bmt.free;
end;


procedure SelectedBitmap(source1,source2,target:TBitmap;dens:longint);
var
    aEBX, aESI, aEDI, aESP, aEDX, Dens1, Dens2, Dens3: Longint;
    i: longint;
    ptz: pointer;
    ptt: pointer;
    ptf: pointer;
    w:longint;
    bmz:TBitmap;
    bmf:TBitmap;
    bmt:TBitmap;
    fina:integer;
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


    bmF.Assign(source1);
    bmt.assign(source2);
    bmZ.assign(bmf);

    w:=bmz.width;

    for i := 0 to bmz.height - 1 do begin
        Ptz := bmz.Scanline[i];
        Ptt := bmt.Scanline[i];
        Ptf := bmf.Scanline[i];
            asm
		        MOV aEBX, EBX
		        MOV aEDI, EDI
		        MOV aESI, ESI
		        MOV aESP, ESP
		        MOV aEDX, EDX

		        MOV EBX, Dens
		        MOV Dens1, EBX

		        NEG BL
		        ADD BL, $20
		        MOV Dens2, EBX
//		        CMP Dens1, 0
//		        JZ  @Final

		        MOV EDI, ptz
		        MOV ESI, ptt
		        MOV ECX, ptf

		        MOV EAX, w
		        lea EAX, [EAX+EAX*2+3]
		        ADD EAX,w
		        AND EAX, $FFFFFFFC
		        ADD EAX, EDI
		        MOV FinA, EAX

		        MOV EDX,EDI
		        MOV ESP,ESI
		        MOV ECX,ECX

            @LOOPA:
		        MOV  EAX, [EDX]
                SHR EAX, 24

		        MOV EBX, EAX
                ADD EBX, dens
                CMP EBX, $20
                JNG @p
                MOV EBX, $20
            @p:
		        MOV Dens1, EBX
		        NEG BL
		        ADD BL, $20
		        MOV Dens2, EBX
		        CMP Dens1, 0
		        JZ  @sig

		        MOV  EAX, [EDX]
                SHR EAX, 24
                SHL EAX, 24
                MOV Dens3, EAX

		        MOV  EAX, [EDX]
		        MOV  EDI, [ESP]
                CMP EAX, $FFFFFFFF
                JZ @mask
             @again:
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
                SHL EAX ,8
                SHR EAX ,8

                OR   EAX, Dens3
		        MOV [ECX], EAX
            @sig:
		        ADD  EDX, 4
		        ADD  ESP, 4
		        ADD  ECX, 4

		        CMP  EDX, FinA
		        JNE  @LOOPA
                JE  @final
            @mask:
//		        MOV  EAX, EDI
//		        MOV [ECX], EAX
                jmp  @sig
            @final:
		        MOV EBX, aEBX
		        MOV EDI, aEDI
		        MOV ESI, aESI
		        MOV ESP, aESP
		        MOV EDX, aEDX
            end;
        end;
        
        target.assign(bmf);
        bmz.free;
        bmf.free;
        bmt.free;
end;



procedure MergeBitmaps(source1,source2,target:TBitmap;dens:longint);
var
    aEBX, aESI, aEDI, aESP, aEDX, Dens1, Dens2: Longint;
    i: longint;
    ptz: pointer;
    ptt: pointer;
    ptf: pointer;
    w:longint;
    bmz:TBitmap;
    bmf:TBitmap;
    bmt:TBitmap;
    fina:integer;
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
		        MOV aEBX, EBX
		        MOV aEDI, EDI
		        MOV aESI, ESI
		        MOV aESP, ESP
		        MOV aEDX, EDX

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

		        MOV EDX,EDI
		        MOV ESP,ESI
		        MOV ECX,ECX

            @LOOPA:
		        MOV  EAX, [EDX]
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

		        ADD  EDX, 4
		        ADD  ESP, 4
		        ADD  ECX, 4

		        CMP  EDX, FinA
		        JNE  @LOOPA
            @final:
		        MOV EBX, aEBX
		        MOV EDI, aEDI
		        MOV ESI, aESI
		        MOV ESP, aESP
		        MOV EDX, aEDX
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

function CopyFile(const Source, Destination: string): Boolean;
var
    SourceStream: TFileStream;
begin
    Result := false;
    if not FileExists(Destination) then begin
        SourceStream := TFileStream.Create(Source, fmOpenRead);
        try
            with TFileStream.Create(Destination, fmCreate) do begin
                try
                    CopyFrom(SourceStream, 0);
                finally
                    Free;
                end;
            end;
        finally
            SourceStream.free;
        end;
        Result := true;
    end;
end;

end.
