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
unit UEasyPrint;

interface

uses QPrinters, Classes, Types, QDialogs, QGraphics, Qt, Math, Sysutils;
type

  TEasyPrint = class
  private
    fTextList: TStrings;
    fFont: TFont;
    fPageNum: integer;
    fDoPrint: Boolean;
    fFirstPage: integer;
    fLastPage: integer;
    fHeader: string;
    fFooter: string;
    fMargins: TRect;
    procedure SetText(Text: string);
    function GetText: string;
  protected

  public
    constructor Create;
    destructor Destroy; override;
    procedure Print;
    function GetNumPages: integer;

  published
    property Text: string read GetText write SetText;
    property Font: TFont read fFont write fFont;
    property LastPage: integer read fLastPage write fLastPage;
    property FirstPage: integer read fFirstPage write fFirstPage;
    property Margins: TRect read fMargins write fMargins;
  end;

type byteArr256 = array[0..255] of byte;

  TCachedFont = class(TFont) //(c)Theo Lustenberger 2002
  private
    fCharWidths: byteArr256;
    fLeftBearings: byteArr256;
    fRightBearings: byteArr256;
    fAscent: integer;
    fLineHeight: integer;
  public
    function GetStringWidth(S: string): integer;
    function GetLeftBearing(Ch: Char): integer;
    function GetRightBearing(Ch: Char): integer;
    procedure MakeMetrics;
    property Ascent: integer read fAscent;
    property LineHeight: integer read fLineHeight;
  end;

implementation

constructor TEasyPrint.Create;
begin
  fTextList := TStringList.create;
  fFont := TFont.create;
  fDoPrint := true;
  fFirstPage := 1;
  fLastPage := 10000; //not enough?
  fHeader := '- &p -';
  fFooter := 'Seite: &p ';
  //Give a little extra margins by default
  fMargins.Left := Printer.Margins.cx + 6;
  fMargins.Right := Printer.Margins.cx + 6;
  fMargins.Top := Printer.Margins.cy + 6;
  fMargins.Bottom := Printer.Margins.cy + 12;
end;

destructor TEasyPrint.Destroy;
begin
  fFont.free;
  fTextList.free;
  inherited;
end;


procedure TEasyPrint.SetText(Text: string);
begin
  fTextList.Text := Text;
end;

function TEasyPrint.GetText: string;
begin
  Result := fTextList.Text;
end;

procedure TEasyPrint.Print;
var
  Lineh, i, X, Y: integer;
  PageSize: TSize;
  CFont: TCachedFont;

  procedure PrintHeader;
  var prnHeader: string;
  begin
    if fHeader <> '' then
    begin
      if fDoPrint and (fPageNum >= fFirstPage) and (fPageNum <= fLastPage) then
      begin
        prnHeader := StringReplace(fHeader, '&p', inttostr(fPageNum), [rfReplaceAll, rfIgnoreCase]);
        Printer.Canvas.TextOut((PageSize.cx - CFont.GetStringWidth(prnHeader)) div 2, Y, prnHeader);
      end;
      Inc(Y, Lineh * 2);
    end;
  end;

  procedure PrintFooter;
  var prnFooter: string;
  begin
    if fFooter <> '' then
    begin
      if fDoPrint and (fPageNum >= fFirstPage) and (fPageNum <= fLastPage) then
      begin
        prnFooter := StringReplace(fFooter, '&p', inttostr(fPageNum), [rfReplaceAll, rfIgnoreCase]);
        Printer.Canvas.TextOut((PageSize.cx - CFont.GetStringWidth(prnFooter)) div 2, PageSize.cy - Margins.Bottom - Lineh, prnFooter);
      end;
    end;
  end;


  procedure PrintParagraph(lText: string);
  var Lines: TStrings;
    ui, charcnt, start: integer;
    LastPos: integer;

  begin
    Lines := TStringList.create;
    charcnt := 1;
    start := 1;
    LastPos := 0;
    while charcnt < Length(ltext) do
    begin
      if ltext[charcnt] in [' ', '-'] then
      begin
        if (CFont.GetStringWidth(Copy(lText, start, charcnt - start))) > (PageSize.cx - Margins.left) then //better result
        begin
          Lines.Add(Copy(lText, start, LastPos - start + 1));
          Start := Lastpos + 1;
        end;
        LastPos := charcnt;
      end;
      inc(charcnt);
    end;

    if start = 1 then Lines.add(Copy(lText, start, Length(lText))) else
    begin
  //there was text before so no empty lines
      if Copy(lText, start, Length(lText)) <> '' then Lines.add(Copy(lText, start, Length(lText)))
    end;

    for ui := 0 to Lines.count - 1 do
    begin
      if (Y < (PageSize.cy - Margins.top - Margins.bottom - Lineh)) then
      begin
        if fDoPrint and (fPageNum >= fFirstPage) and (fPageNum <= fLastPage) then
          Printer.Canvas.TextOut(X, Y, Lines[ui]);
        Inc(Y, Lineh);
      end else
      begin
        PrintFooter;
        if fDoPrint and (fPageNum >= fFirstPage) and (fPageNum <= fLastPage) then
          if (fPageNum <> fLastPage) then Printer.NewPage;
        inc(fPageNum);
        Y := Margins.Top;
        PrintHeader;
        if fDoPrint and (fPageNum >= fFirstPage) and (fPageNum <= fLastPage) then
          Printer.Canvas.TextOut(X, Y, Lines[ui]);
        Inc(Y, Lineh);
      end;
    end;
    Lines.free;
  end;

begin
  (Printer.PrintAdapter as TQPrintAdapter).FullPage := true;
  fPageNum := 1;
  if fLastPage < fFirstPage then fLastPage := fFirstPage;
  if fDoPrint then Printer.BeginDoc;
  CFont := TCachedFont.create;
  CFont.Assign(fFont);
  Printer.Canvas.Font := CFont;
  CFont.MakeMetrics;
  Lineh := Printer.Canvas.TextHeight('ABC');

  PageSize.cx := Printer.PageWidth;
  PageSize.cy := Printer.PageHeight;
  X := Margins.Left;
  Y := Margins.Top;

  PrintHeader;

  for i := 0 to fTextList.count - 1 do
  begin
    if (Y < (PageSize.cy - Margins.Top - Margins.Bottom - Lineh)) then
      //I know, we could print up to PageSize.cy-fMargins.Bottom but let the footer have it.
    begin
      PrintParagraph(fTextList[i]);
    end else
    begin
      PrintFooter;
      if fDoPrint and (fPageNum >= fFirstPage) and (fPageNum <= fLastPage) then
        if (fPageNum <> fLastPage) then Printer.NewPage;
      inc(fPageNum);
      Y := Margins.Top;
      PrintHeader;
      PrintParagraph(fTextList[i]);
    end;
  end;
  PrintFooter;
  CFont.free;
  if fDoPrint then Printer.EndDoc;
  fFirstPage := 1;
  fLastPage := 10000;
end;

function TEasyPrint.GetNumPages: integer;
begin
  fDoPrint := false;
  Print;
  result := fPageNum;
  fDoPrint := true;
end;



//------------------------------------------------------------------------------


function TCachedFont.GetStringWidth(S: string): integer;
var i: integer;
begin
  result := 0;
  for i := 1 to length(S) do
    inc(result, fCharWidths[ord(S[i])]);
end;

function TCachedFont.GetLeftBearing(Ch: Char): integer;
begin
  result := fLeftBearings[ord(Ch)];
end;

function TCachedFont.GetRightBearing(Ch: Char): integer;
begin
  result := fRightBearings[ord(Ch)];
end;

function SwapWC(WC: WideChar): WideChar;
//Hint from Martin Waldenburg
asm
   xchg al, ah
end;

procedure TCachedFont.MakeMetrics;
var fm: QFontMetricsH;
  i: integer;
  wcr: Widechar;
var
  fi: QFontInfoH;
  family: WideString;
begin

  //Get the font that is actually used by the system (important for metrics)
  fi := QFontInfo_create(Printer.Canvas.Font.Handle);
  try
    if not QFontInfo_exactMatch(fi) then
    begin
      Size := QFontInfo_pointSize(fi);
      QFontInfo_family(fi, @family);
      Name := family;
    end;
  finally
    QFontInfo_destroy(fi);
  end;

  fm := QFontMetrics_create(Printer.Canvas.Font.Handle);
  try
    for i := 0 to 255 do
    begin
      fCharWidths[i] := QFontMetrics_width(fm, chr(i));
      wcr := WideChar(chr(i));
{$IFDEF Kylix1}
      wcr := SwapWC(wcr); //Kylix 2 also??
{$ENDIF}
      fLeftBearings[i] := Max(0, -QFontMetrics_leftBearing(fm, @wcr));
      fRightBearings[i] := Max(0, -QFontMetrics_rightBearing(fm, @wcr));
    end;

    fAscent := QFontMetrics_ascent(fm);
    fLineHeight := QFontMetrics_height(fm);
  finally
    QFontMetrics_destroy(fm);
  end;
end;
end.


