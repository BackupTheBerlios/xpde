{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003 Theo Lustenberger                                        }
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

unit HexEd;

interface

uses Classes, Types, Sysutils, QControls, QGraphics,
  QStdCtrls, QForms, Qt, QDialogs;
type
  THexEd = class(TCustomControl)
  private
    fData: TMemoryStream;
 //fScrollPos:integer;
    fBuffer: TBitmap;
    fScrollBar: TScrollBar;
    fLineHeight: integer;
  protected
    procedure BoundsChanged; override;
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    function DoMouseWheelDown(Shift: TShiftState; const MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; const MousePos: TPoint): Boolean; override;
    procedure setFocus; override;
  public
    fScrollPos: integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Paintit;
    procedure AdjustPainter(Painter: QPainterH); override;
  published
    property Data: TMemoryStream read fData write fData;
  end;

implementation

constructor THexEd.Create(AOwner: TComponent);
begin
  inherited;
  fData := TMemoryStream.create;
  fBuffer := TBitmap.Create;
  fScrollBar := TScrollBar.Create(self);
  fScrollBar.Parent := self;
  fScrollBar.Kind := sbVertical;
  fScrollBar.OnScroll := ScrollBar1Scroll;
  QWidget_setBackgroundMode(Handle, QWidgetBackgroundMode_NoBackground);
end;

destructor THexEd.Destroy;
begin
  fScrollBar.free;
  fBuffer.Free;
  fData.free;
  inherited;
end;

procedure THexEd.setFocus;
begin
  inherited;
  fScrollBar.SetFocus;
end;

procedure THexEd.BoundsChanged;
begin
  inherited;
  fScrollBar.SetBounds(Width - fScrollBar.Width - 2, 2, fScrollBar.Width, Height - 4);
  fScrollBar.LargeChange := Height;
  fScrollBar.SetFocus;
end;

procedure THexEd.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
  fScrollPos := -ScrollPos;
  Repaint;
end;

function THexEd.DoMouseWheelDown(Shift: TShiftState; const MousePos: TPoint): Boolean;
begin
  if Shift = [ssctrl] then
    fScrollBar.Position := fScrollBar.Position + (fScrollBar.LargeChange div 2)
  else
    fScrollBar.Position := fScrollBar.Position + fScrollBar.SmallChange;
  result := inherited DoMouseWheelDown(Shift, MousePos);

  fScrollPos := -fScrollBar.Position;
  Repaint;
end;

function THexEd.DoMouseWheelUp(Shift: TShiftState; const MousePos: TPoint): Boolean;
begin
  if Shift = [ssctrl] then
    fScrollBar.Position := fScrollBar.Position - (fScrollBar.LargeChange div 2)
  else
    fScrollBar.Position := fScrollBar.Position - fScrollBar.SmallChange;
  result := inherited DoMouseWheelUp(Shift, MousePos);

  fScrollPos := -fScrollBar.Position;
  Repaint;
end;

procedure THexEd.AdjustPainter(Painter: QPainterH);
begin
  fBuffer.Width := Width;
  fBuffer.Height := Height;
  fBuffer.Canvas.Font.Name := 'Courier';
  fBuffer.Canvas.Font.Size:=12;
  fLineHeight := fBuffer.Canvas.TextHeight('123456789');
  fScrollBar.SmallChange := fLineHeight;
  inherited;
end;

procedure THexEd.Paint;
begin
  inherited;
  Paintit;
end;

procedure THexEd.Paintit;
var buf: Byte;
  ASCII, HEX: string;
  i, Line, indent, DataSize, CurrentVPos, SheetHeight: integer;
begin
  DataSize := fData.Size;

  fBuffer.Canvas.Brush.Color := clWhite;
  fBuffer.Canvas.FillRect(Rect(0, 0, Width, Height));

  begin
    SheetHeight := ((fData.Size div 8) + 1) * fLineHeight;
    fScrollBar.Visible := SheetHeight > Height;
    if fScrollBar.Visible then fScrollbar.Max := SheetHeight - Height + fLineHeight;

    indent := 2;


    fData.Position := 0;
    Line := 0;
    repeat
      ASCII := '';
      HEX := '';
      for i := 0 to 7 do
      begin
        if fData.Position < DataSize then
        begin
          fData.ReadBuffer(buf, 1);
          if buf in [32..126, 160..255] then
            ASCII := ASCII + Char(buf) else
            ASCII := ASCII + '.';
          HEX := HEX + InttoHex(buf, 2) + ' ';
        end;
      end;
      CurrentVPos := indent + fScrollPos + Line * fLineHeight;
      if (CurrentVPos > -fLineHeight) and (CurrentVPos < Height) then
      begin

        fBuffer.Canvas.TextOut(0 + indent, indent + fScrollPos + Line * fLineHeight, InttoHex(Line * 8, 4));
        fBuffer.Canvas.TextOut(45 + indent, indent + fScrollPos + Line * fLineHeight, HEX);
        fBuffer.Canvas.TextOut(230 + indent, indent + fScrollPos + Line * fLineHeight, ASCII);
      end;

      if CurrentVPos > Height then fData.Position := DataSize;
      if CurrentVPos < 0 then
      begin
        repeat
          inc(Line);
          fData.Position := fData.Position + 8;
        until (indent + fScrollPos + (Line + 1) * fLineHeight) >= 0;
        dec(Line);
      end;
      inc(Line);
    until fData.Position >= DataSize;

    fBuffer.Canvas.Pen.Color := clgray;
    fBuffer.Canvas.MoveTo(0, 0);
    fBuffer.Canvas.LineTo(width, 0);
    fBuffer.Canvas.MoveTo(0, 0);
    fBuffer.Canvas.LineTo(0, Height);
    fBuffer.Canvas.Pen.Color := clsilver;
    fBuffer.Canvas.MoveTo(0, Height - 2);
    fBuffer.Canvas.LineTo(width - 2, height - 2);
    fBuffer.Canvas.LineTo(Width - 2, 0);
    fBuffer.Canvas.Pen.Color := clwhite;
    fBuffer.Canvas.MoveTo(0, Height - 1);
    fBuffer.Canvas.LineTo(width - 1, height - 1);
    fBuffer.Canvas.LineTo(Width - 1, 0);

    fBuffer.Canvas.Pen.Color := clblack;
    fBuffer.Canvas.MoveTo(1, 1);
    fBuffer.Canvas.LineTo(width - 1, 1);
    fBuffer.Canvas.MoveTo(1, 1);
    fBuffer.Canvas.LineTo(1, Height - 1);
  end;
  Canvas.Draw(0, 0, fBuffer);
end;
end.

