unit DmGraphics;

// Version 1.0.1
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The original code is DmGraphics.pas, released February 28, 2002.
//
// Written by Dmitri Dmitrienko <dd@cron.ru http://dd.cron.ru>
// (C) 2002-2003 Dmitri Dmitrienko . All Rights Reserved.
//----------------------------------------------------------------------------------------------------------------------
//
// FEB-2002 Initial release
// APR-2002 Minor fixes
//

interface

{$R-,I-,Q-}

{$I Compilers.inc}
{$WRITEABLECONST ON}

uses
  SysUtils, SyncObjs, Classes,
{$IFDEF QT_CLX}
  Qt, QTypes, Types, QGraphics, QImgList, QControls, QForms, QDialogs,
{$ELSE}
  ImgList, Controls, CommCtrl,  Windows, Graphics, Forms, Types,
{$ENDIF}
{$IFDEF LINUX}
  Libc, Xlib,
{$ELSE}
  MMSystem,
{$ENDIF}
  Math;

const
{$IFDEF QT_CLX}
  NULLHANDLE = nil;
{$ELSE}
  NULLHANDLE = 0;
{$ENDIF}
  
{$IFDEF QT_CLX}
type
  UINT = LongWord;
  BOOL = LongBool;
  PDWORD = ^DWORD;
  HRGN  = Qt.QRegionH;
  HDC = Qt.QPainterH;
  HFONT = Qt.QFontH;
  HBRUSH = Qt.QBrushH;
  HPEN = Qt.QPenH;
  COLORREF = DWORD;

const
  RT_BITMAP = PChar(2);

const
  NOERROR = 0;

const
  SRCCOPY = RasterOp_CopyROP;

const
  DT_LEFT = 0;
  DT_CENTER = 1;
  DT_RIGHT = 2;

  DT_TOP = 0;
  DT_VCENTER = 4;
  DT_BOTTOM = 8;

  DT_WORDBREAK = $10;
  DT_SINGLELINE = $20;
  DT_NOCLIP = $100;
  DT_CALCRECT = $400;
  DT_NOPREFIX = $800;
  DT_HIDEPREFIX = $100000;

  DT_PATH_ELLIPSIS = $4000;
  DT_END_ELLIPSIS = $8000;
  DT_MODIFYSTRING = $10000;
  DT_WORD_ELLIPSIS = $40000;

const
  RGN_AND = 1;
  RGN_OR = 2;
  RGN_XOR = 3;
  RGN_DIFF = 4;
  RGN_COPY = 5;

const
  PS_SOLID = 0;
  PS_DASH = 1;
  PS_DOT = 2;
  PS_DASHDOT = 3;
  PS_DASHDOTDOT = 4;
  PS_NULL = 5;

const
  BF_LEFT = 1;
  BF_TOP = 2;
  BF_RIGHT = 4;
  BF_BOTTOM = 8;

  BF_TOPLEFT = (BF_TOP or BF_LEFT);
  BF_TOPRIGHT = (BF_TOP or BF_RIGHT);
  BF_BOTTOMLEFT = (BF_BOTTOM or BF_LEFT);
  BF_BOTTOMRIGHT = (BF_BOTTOM or BF_RIGHT);
  BF_RECT = (BF_LEFT or BF_TOP or BF_RIGHT or BF_BOTTOM);

  BF_MIDDLE = $800;
  BF_SOFT = $1000;
  BF_ADJUST = $2000;
  BF_FLAT = $4000;
  BF_MONO = $8000;

const
  BDR_RAISEDOUTER = 1;
  BDR_SUNKENOUTER = 2;
  BDR_OUTER = 3;

  BDR_RAISEDINNER = 4;
  BDR_SUNKENINNER = 8;
  BDR_INNER = 12;

const
  VK_HOME = Key_Home;
  VK_END  = Key_End;
  VK_PRIOR = Key_Prior;
  VK_NEXT = Key_Next;
  VK_UP = Key_Up;
  VK_DOWN = Key_Down;
  VK_LEFT = Key_Left;
  VK_RIGHT = Key_Right;
  VK_BACK = Key_Backspace;
  VK_TAB = Key_Tab;
  VK_F1 = Key_F1;
  VK_F2 = Key_F2;
  VK_F3 = Key_F3;
  VK_F4 = Key_F4;
  VK_F5 = Key_F5;
  VK_F6 = Key_F6;
  VK_F7 = Key_F7;
  VK_F8 = Key_F8;
  VK_F9 = Key_F9;
  VK_F10 = Key_F10;
  VK_F11 = Key_F11;
  VK_F12 = Key_F12;
  VK_F13 = Key_F13;
  VK_F14 = Key_F14;
  VK_F15 = Key_F15;
  VK_F16 = Key_F16;
  VK_F17 = Key_F17;
  VK_F18 = Key_F18;
  VK_F19 = Key_F19;
  VK_F20 = Key_F20;
  VK_F21 = Key_F21;
  VK_F22 = Key_F22;
  VK_F23 = Key_F23;
  VK_F24 = Key_F24;
  VK_ADD = Key_plus;
  VK_SUBTRACT = Key_minus;
  VK_MULTIPLY = Key_Asterisk;
  VK_DIVIDE = Key_Slash;
  VK_ESCAPE = Key_Escape;
  VK_SPACE = Key_Space;
  VK_APPS = Key_Menu;
  VK_RETURN = Key_Return;
  VK_DELETE = Key_Delete;

const
  MK_LBUTTON = 1;
  MK_RBUTTON = 2;
  MK_SHIFT = 4;
  MK_CONTROL = 8;
  MK_MBUTTON = $10;

const
  WM_SETFOCUS  = $0007;
  WM_KILLFOCUS = $0008;
  WM_SETCURSOR = $0020;
  WM_TIMER = $0113;

  WM_MOUSEMOVE = $200;
  WM_LBUTTONDOWN = $201;
  WM_LBUTTONUP = $202;
  WM_LBUTTONDBLCLK = $203;
  WM_RBUTTONDOWN = $204;
  WM_RBUTTONUP = $205;
  WM_RBUTTONDBLCLK = $206;
  WM_MBUTTONDOWN = $207;
  WM_MBUTTONUP = $208;
  WM_MBUTTONDBLCLK = $209;
  WM_MOUSEWHEEL = $20A;

  WM_NCMOUSEMOVE      = $00A0;
  WM_NCLBUTTONDOWN    = $00A1;
  WM_NCLBUTTONUP      = $00A2;
  WM_NCLBUTTONDBLCLK  = $00A3;
  WM_NCRBUTTONDOWN    = $00A4;
  WM_NCRBUTTONUP      = $00A5;
  WM_NCRBUTTONDBLCLK  = $00A6;
  WM_NCMBUTTONDOWN    = $00A7;
  WM_NCMBUTTONUP      = $00A8;
  WM_NCMBUTTONDBLCLK  = $00A9;

const
  CM_DRAG = CM_BASE + 47;

const
  QEventType_CustomWindows = QEventType(Integer(QEventType_ClxUser) + $100);

const
  DROPEFFECT_NONE   = 0;
  DROPEFFECT_COPY   = 1;
  DROPEFFECT_MOVE   = 2;
  DROPEFFECT_LINK   = 4;
  DROPEFFECT_SCROLL = DWORD($80000000);

const
  DRAGDROP_S_DROP = $40100;
  DRAGDROP_S_CANCEL = $40101;
  DRAGDROP_S_USEDEFAULTCURSORS = $40102;

const
  TYMED_HGLOBAL = 1;
  TYMED_ISTREAM = 4;
  DVASPECT_CONTENT = 1;

type
  TFormatEtc = packed record
    cfFormat: Word;
    ptd: pointer;
    dwAspect: Longint;
    lindex: Longint;
    tymed: Longint;
  end;

  HBitmap=cardinal;

  TStgMedium = packed record
    tymed: Longint;
    case Integer of
      0: (hBitmap: HBitmap; unkForRelease: Pointer);
      3: (hGlobal: HGlobal);
  end;

const
  WHEEL_DELTA = 120;

const // bkMode
  TRANSPARENT = 1;
  OPAQUE = 2;

type
  TDragMessage = (dmDragEnter, dmDragLeave, dmDragMove, dmDragDrop, dmDragCancel, dmFindTarget);

type
  DRAWTEXTPARAMS = record
    cbSize: UINT ;
    iTabLength: integer;
    iLeftMargin: integer;
    iRightMargin: integer;
    uiLengthDrawn: UINT;
  end;
  PDRAWTEXTPARAMS = ^DRAWTEXTPARAMS;
  TDRAWTEXTPARAMS = DRAWTEXTPARAMS;

type
  PMessage = ^TMessage;
  TMessage = packed record
    Msg: Cardinal;
    case Integer of
      0: (
        WParam: Longint;
        LParam: Longint;
        Result: Longint);
      1: (
        WParamLo: Word;
        WParamHi: Word;
        LParamLo: Word;
        LParamHi: Word;
        ResultLo: Word;
        ResultHi: Word);
  end;

  TWMSetFocus = packed record
    Msg: Cardinal;
    FocusedWnd: QWidgetH;
    Unused: Longint;
    Result: Longint;
  end;

  TWMKillFocus = TWMSetFocus;

  TWMMouse = packed record
    Msg: Cardinal;
    Keys: Longint;
    case Integer of
      0: (
        XPos: Smallint;
        YPos: Smallint);
      1: (
        Pos: TSmallPoint;
        Result: Longint);
  end;
  TWMLButtonDblClk = TWMMouse;
  TWMLButtonDown   = TWMMouse;
  TWMLButtonUp     = TWMMouse;
  TWMMButtonDblClk = TWMMouse;
  TWMMButtonDown   = TWMMouse;
  TWMMButtonUp     = TWMMouse;
  TWMRButtonDblClk = TWMMouse;
  TWMRButtonDown = TWMMouse;
  TWMRButtonUp = TWMMouse;
  TWMMouseMove = TWMMouse;

  TWMTimer = packed record
    Msg: Cardinal;
    TimerID: Longint;
    TimerProc: pointer;
    Result: Longint;
  end;

  TWMNCHitMessage = packed record
    Msg: Cardinal;
    HitTest: Longint;
    XCursor: Smallint;
    YCursor: Smallint;
    Result: Longint;
  end;

  TWMNCMouseMove     = TWMNCHitMessage;
  TWMNCLButtonDown   = TWMNCHitMessage;
  TWMNCLButtonUp     = TWMNCHitMessage;
  TWMNCLButtonDblClk = TWMNCHitMessage;
  TWMNCMButtonDown   = TWMNCHitMessage;
  TWMNCMButtonUp     = TWMNCHitMessage;
  TWMNCMButtonDblClk = TWMNCHitMessage;
  TWMNCRButtonDown   = TWMNCHitMessage;
  TWMNCRButtonUp     = TWMNCHitMessage;
  TWMNCRButtonDblClk = TWMNCHitMessage;

  TWMSetCursor = packed record
    Msg: Cardinal;
    CursorWnd: QWidgetH;
    HitTest: Word;
    MouseMsg: Word;
    Result: Longint;
  end;

  PDragRec = ^TDragRec;
  TDragRec = record
    Pos: TPoint;
    Source: TDragObject;
    Target: Pointer;
    Docking: boolean;
  end;

  TCMDrag = packed record
    Msg: Cardinal;
    DragMessage: TDragMessage;
    Reserved1: Byte;
    Reserved2: Word;
    DragRec: PDragRec;
    Result: Longint;
  end;

{$ENDIF}

function WStrFromWCharLen(lpString: PWideChar; nCount: Integer): WideString;
procedure WStrAppendFromWCharLen(var WStr: WideString; lpString: PWideChar; nCount: Integer);
function WCharLen(lpString: PWideChar): integer; register;

// GDI function replacements
function DrawTextExW(Canvas: TCanvas; lpString: PWideChar; nCount: Integer;
  var lpRect: TRect; uFormat: Cardinal; params: PDrawTextParams): integer; overload;
function DrawTextExW(Canvas: TCanvas; lpString: WideString; nCount: Integer;
  var lpRect: TRect; uFormat: Cardinal; params: PDrawTextParams): integer; overload;
function GetTextExtentPoint32W(Canvas: TCanvas; Str: PWideChar; Count: Integer;
  var Size: TSize): BOOL; overload;
function GetTextExtentPoint32W(Canvas: TCanvas; const Str: WideString; Count: Integer;
  var Size: TSize): BOOL; overload;
function GetBkMode(Canvas: TCanvas): Integer;
function SetBkMode(Canvas: TCanvas; BkMode: Integer): Integer; {$IFDEF QT_CLX} overload; {$ENDIF}

function SelectFont(DC: HDC; Font: HFONT): HFONT;
function SelectPen(DC: HDC; Pen: HPEN): HPEN;
function SelectBrush(DC: HDC; Brush: HBRUSH): HBRUSH;
function GetCurrentFont(DC: HDC): HFONT;
function GetCurrentPen(DC: HDC): HPEN;
function GetCurrentBrush(DC: HDC): HBRUSH;
procedure DeleteFont(Font: HFONT);
procedure DeletePen(Pen: HPEN);
procedure DeleteBrush(Brush: HBRUSH);


{$IFDEF QT_CLX}
function GetTextExtentPoint32W(DC: QPainterH; Str: PWideChar; Count: Integer;
  var Size: TSize): BOOL; overload;
function SetBkMode(DC: QPainterH; BkMode: Integer): Integer; overload;
{$ENDIF}


{$IFDEF QT_CLX}
// Painter/Painter objects
function BitBlt(DestDC: QPainterH; XDest, YDest, Width, Height: Integer;
  SrcDC: QPainterH; XSrc, YSrc: Integer; Rop: Qt.RasterOp): BOOL;
function CombineRgn(hrgnDest, hrgnSrc1, hrgnSrc2: QRegionH; fnCombineMode: Integer): Integer;
function CreateRectRgn(L,T,R,B: integer): QRegionH;
function CreateRectRgnIndirect(const p1: TRect): QRegionH;
function CreatePatternBrush(PixMap: QPixMapH): QBrushH;
function CreateSolidBrush(crColor: DWORD): QBrushH;
function CreatePen(style: integer; width: integer; crColor: DWORD): QPenH;
function ExcludeClipRect(dc: QPainterH; Left, Top, Right, Bottom: integer): integer;
function FillRect(hDC: QPainterH; const lprc: TRect; hbr: QBrushH): Integer;
function FrameRect(hDC: QPainterH; const lprc: TRect; hbr: QBrushH): Integer;
function GetBkColor(hDC: QPainterH): DWORD;
function GetTextColor(hDC: QPainterH): DWORD;
function GetClipRgn(dc: QPainterH; RGN: QRegionH): integer;
function GetWindowOrgEx(dc: QPainterH; Point: PPoint): BOOL;
function IntersectClipRect(dc: QPainterH; Left, Top, Right, Bottom: integer): integer;
function LPtoDP(dc: QPainterH; var Points; Count: Integer): BOOL;
function OffsetRgn(RGN: QRegionH; XOffset, YOffset: Integer): integer;
procedure PixBlt(hDestDC: QPainterH; destX, destY, destW, destH: integer; SrcBm: TBitmap; srcX, srcY: integer);
function ScrollDC(hDC: QPainterH; DX, DY: Integer; var Scroll, Clip: TRect; hrgnUpdate: QRegionH;
  lprcUpdate: PRect): BOOL;
function SelectClipRgn(dc: QPainterH; RGN: QRegionH): integer;
function SetBkColor(hDC: QPainterH; Color: DWORD): DWORD;
function SetTextColor(hDC: QPainterH; Color: DWORD): DWORD;
function SetBrushColor(br: QBrushH; Color: DWORD): DWORD;
function SetBrushOrgEx(hDC: QPainterH; nXOrg, nYOrg: integer; ppt: PPoint): BOOL;
function SetWindowOrgEx(dc: QPainterH; X, Y: Integer; Point: PPoint): BOOL;
function SubtractRect(var lprcDst: TRect; const lprcSrc1, lprcSrc2: TRect): BOOL;
function MoveToEx(DC: HDC; X, Y: integer; pOldPos: PPoint): BOOL;
function LineTo(DC: HDC; X, Y: integer): BOOL;

function ImageFromResource(Instance: Cardinal;
  const ResName: string; ResType: PChar = RT_BITMAP): QImageH;
function BitmapFromImage(FImage: QImageH): TBitmap;

// Widget related
procedure ForcePaints(Widget: QWidgetH);
function GetCapture: QWidgetH;
function GetWindowRect(hWnd: QWidgetH; var lpRect: TRect): BOOL;
function InvalidateRect(hWnd: QWidgetH; lpRect: PRect; bErase: BOOL): BOOL;
function MapWindowPoints(hWndFrom, hWndTo: QWidgetH; var lpPoints; cPoints: UInt): integer;
function ScrollWindow(hWnd: QWidgetH; XAmount, YAmount: Integer; Rect, ClipRect: PRect): BOOL;
procedure PostMessagePtr(hWnd: QObjectH; Msg: UINT; Ptr: Pointer);

// MISC
function GetShiftState: TShiftState;
procedure GetFontList(L: TStrings; withSizes: boolean);
function FontIsMonospaced(FontFamily: string; Sz: integer): boolean;
function KeysToShiftState(Keys: Word): TShiftState;
procedure LoadBitmap(Bitmap: TBitmap; Instance: Cardinal; const ResName: PChar);
function PointToSmallPoint(const P: TPoint): TSmallPoint;
function QEventType_Keys(Event: QEventH): integer;
function QEventType_Msg(IsInClient: boolean; Event: QEventH): integer;
function SmallPointToPoint(const P: TSmallPoint): TPoint;
procedure ZeroMemory(Destination: Pointer; Length: DWORD);
{$ENDIF}

{$IFDEF LINUX} // replacement for MMSystem::timeGetTime
function timeGetTime: DWORD;
{$ENDIF}

type
  TBlendMode = (
    bmConstantAlpha,
    bmPerPixelAlpha,
    bmMasterAlpha,
    bmConstantAlphaAndColor
  );

  TAlphaTransparency = 0..255;
  TAlphaBias = -128..127;


function GetRGBColor(Value: TColor): DWORD;
function MixColors(clr1, clr2: DWORD; Weight: Byte): DWORD;
function CanvasBpp(Canvas: TCanvas): integer;

procedure AlphaBlend(Source, Dest: TBitmap; R: TRect; Target: TPoint;
  Mode: TBlendMode; ConstantAlpha: TAlphaTransparency; Bias: integer);
procedure DrawWindowShadow(Dest: TBitmap; const Bounds: TRect;
  ShadowSize: Integer);

procedure ConvertImageList(IL: TImageList; const ImageName: string;
  ColorRemapping: Boolean = True);
procedure ConvertImageListBm(IL: TImageList; Images: TBitmap; Count: integer = -1);

procedure DrawXPHover(Canvas: TCanvas; ButtonR: TRect; HoverOnTop: boolean);
procedure DrawXPButton(Canvas: TCanvas; ButtonR: TRect; DrawSplitter, Down, Hover, HoverOnTop: Boolean);
function CreateMappedRes(Instance: THandle; ResName: PChar;
  const OldColors, NewColors: array of TColor): TBitmap;

type
  TDmtAnimationCallback = function(Step, StepSize: Integer; Data: Pointer): Boolean of object;
procedure Animate(Steps, Duration: Integer; Callback: TDmtAnimationCallback; Data: Pointer);

type
  TDmGradType = (GT_VERT, GT_HORIZ);
procedure DmGradientFill(Canvas: TCanvas; c1,c2: TColor; DestRect: TRect; GradType: TDmGradType);

function DrawEdge(Canvas: TCanvas; var qrc: TRect; edge: UINT; grfFlags: UINT): BOOL;

function CodeInArray(Code: Word; Codes: array of Word): boolean;

var
  MMXAvailable: Boolean;
  IsWin2K: Boolean = false;
  IsWinXP: Boolean = false;

  //Changed Theo
  XPMainHeaderColorUp: TColor =  $DBEAEB;
  XPMainHeaderColorDown: TColor =  $D8DFDE;
  XPMainHeaderColorHover: TColor =  $F3F8FA;
  XPDarkSplitBarColor: TColor =  $B2C5C7;
  XPLightSplitBarColor: TColor =  $FFFFFF;
  XPDarkGradientColor: TColor =  $B8C7CB;
  XPDownOuterLineColor: TColor =  $97A5A5;
  XPDownMiddleLineColor: TColor =  $B8C2C1;
  XPDownInnerLineColor: TColor =  $C9D1D0;

implementation

{$R DmGraphics.dcr}

type
{$IFDEF QT_CLX}
  PRGBQuadArray = ^TRGBQuadArray;
  TRGBQuadArray = array [0..MaxInt div sizeof(QRgb) - 1] of QRgb;
{$ELSE}
  PRGBQuadArray = ^TRGBQuadArray;
  TRGBQuadArray = array [Byte] of TRGBQuad; // lo=BLUE, then GREEN, then RED
{$ENDIF}

const
  WideNull = WideChar(#0);
  WideCR = WideChar(#13);
  WideLF = WideChar(#10);
  WideLineSeparator = WideChar(#2028);
  WideTAB = WideChar(#9);
  WideSPACE = WideChar(' ');

var
  Watcher: TCriticalSection;
  InAnimation: boolean;
  GradBuffer : TBitmap;
  EdgSavBrush: TBrush;
  HoverImg: TImageList;

{$IFDEF LINUX}
function timeGetTime: DWORD;
var
  TV: TTimeVal;
begin
  gettimeofday(TV, nil);
  result := (TV.tv_usec div 1000) + (TV.tv_sec * 1000);
end;
{$ENDIF}

function WStrFromWCharLen(lpString: PWideChar; nCount: Integer): WideString;
begin
  SetLength(Result, nCount);
  Move(lpString^, Result[1], nCount * sizeof(WideChar));
end;

procedure WStrAppendFromWCharLen(var WStr: WideString; lpString: PWideChar; nCount: Integer);
var
  len: integer;
begin
  len:=Length(WStr);
  SetLength(WStr, len + nCount);
  Move(lpString^, WStr[len + 1], nCount * sizeof(WideChar));
end;

function WCharLen(lpString: PWideChar): integer; register;
asm
        push    edi
        mov     edi,eax
        xor     eax,eax
        or      edi,edi
        jz      @@1
        cld
        mov     ecx,-1
        repne   scasw
        not     ecx
        dec     ecx
        mov     eax,ecx
@@1:
        pop     edi
end;

type
  TOverHookCanvas = class(TCanvas)
  end;


// GetTextExtentPoint32W

{$IFDEF QT_CLX}
function GetTextExtentPoint32W(DC: QPainterH; Str: PWideChar; Count: Integer;
  var Size: TSize): BOOL;
var
  R: TRect;
begin
  assert(QPainter_isActive(DC),'Canvas drawing is not started');
  QPainter_boundingRect(DC, @R, 0, 0, MaxInt, MaxInt, integer(AlignmentFlags_SingleLine),
    @Str, Count, nil);
  Size.cx:=R.Right-R.Left;
  Size.cy:=R.Bottom-R.Top;
  result:=true;
end;

function GetTextExtentPoint32W(Canvas: TCanvas; Str: PWideChar; Count: Integer;
  var Size: TSize): BOOL;
var
  S: WideString;
begin
  S:=Str;
  result:=GetTextExtentPoint32W(Canvas, S, Count, Size);
end;

function GetTextExtentPoint32W(Canvas: TCanvas; const Str: WideString; Count: Integer;
  var Size: TSize): BOOL;
var
  R: TRect;
begin
  Canvas.Start;
  try
    TOverHookCanvas(Canvas).RequiredState([csHandleValid, csFontValid]);
    QPainter_boundingRect(Canvas.Handle, @R, 0, 0, MaxInt, MaxInt, integer(AlignmentFlags_SingleLine),
      @Str, Count, nil);
  finally
    Canvas.Stop;
  end;
  Size.cx:=R.Right-R.Left;
  Size.cy:=R.Bottom-R.Top;
  result:=true;
end;
{$ELSE}
function GetTextExtentPoint32W(Canvas: TCanvas; Str: PWideChar; Count: Integer;
  var Size: TSize): BOOL;
begin
  TOverHookCanvas(Canvas).RequiredState([csHandleValid,csFontValid]);
  result:=Windows.GetTextExtentPoint32W(Canvas.Handle, Str, Count, Size);
end;

function GetTextExtentPoint32W(Canvas: TCanvas; const Str: WideString; Count: Integer;
  var Size: TSize): BOOL;
begin
  TOverHookCanvas(Canvas).RequiredState([csHandleValid,csFontValid]);
  result:=Windows.GetTextExtentPoint32W(Canvas.Handle, @Str[1], Count, Size);
end;
{$ENDIF}


// GetBkMode

{$IFDEF QT_CLX}
function GetBkMode(Canvas: TCanvas): Integer;
begin
  TOverHookCanvas(Canvas).Start;
  try
    result:=integer(QPainter_backgroundMode(Canvas.Handle))+1;
  finally
    TOverHookCanvas(Canvas).Stop;
  end;
end;
{$ELSE}
function GetBkMode(Canvas: TCanvas): Integer;
begin
  result:=Windows.GetBkMode(Canvas.Handle);
end;
{$ENDIF}


// SetBkMode

{$IFDEF QT_CLX}
function SetBkMode(DC: QPainterH; BkMode: Integer): Integer;
begin
  assert(QPainter_isActive(DC),'Canvas drawing is not started');
  result:=integer(QPainter_backgroundMode(DC))+1;
  QPainter_setBackgroundMode(DC, BGMode(BkMode-1));
end;

function SetBkMode(Canvas: TCanvas; BkMode: Integer): Integer;
begin
  TOverHookCanvas(Canvas).RequiredState([csHandleValid]);
  result:=integer(QPainter_backgroundMode(Canvas.Handle))+1;
  QPainter_setBackgroundMode(Canvas.Handle, BGMode(BkMode-1));
end;
{$ELSE}
function SetBkMode(Canvas: TCanvas; BkMode: Integer): Integer;
begin
  result:=Windows.SetBkMode(Canvas.Handle, BkMode);
end;
{$ENDIF}

procedure DeleteBrush(Brush: HBRUSH);
begin
{$IFDEF MSWINDOWS}
  DeleteObject(Brush);
{$ELSE}
  QBrush_destroy(Brush);
{$ENDIF}
end;

procedure DeleteFont(Font: HFONT);
begin
{$IFDEF MSWINDOWS}
  DeleteObject(Font);
{$ELSE}
  QFont_destroy(Font);
{$ENDIF}
end;

procedure DeletePen(Pen: HPEN);
begin
{$IFDEF MSWINDOWS}
  DeleteObject(Pen);
{$ELSE}
  QPen_destroy(Pen);
{$ENDIF}
end;

function GetCurrentFont(DC: HDC): HFONT;
begin
{$IFDEF MSWINDOWS}
  Result := GetCurrentObject(DC, OBJ_FONT);
{$ELSE}
  Result := QPainter_font(DC);
{$ENDIF}
end;

function GetCurrentPen(DC: HDC): HPEN;
begin
{$IFDEF MSWINDOWS}
  Result := GetCurrentObject(DC, OBJ_PEN);
{$ELSE}
  Result := QPainter_Pen(DC);
{$ENDIF}
end;

function GetCurrentBrush(DC: HDC): HBRUSH;
begin
{$IFDEF MSWINDOWS}
  Result := GetCurrentObject(DC, OBJ_BRUSH);
{$ELSE}
  Result := QPainter_Brush(DC);
{$ENDIF}
end;

function SelectFont(DC: HDC; Font: HFONT): HFONT;
begin
{$IFDEF MSWINDOWS}
  Result := SelectObject(DC, Font);
{$ELSE}
  Result := QPainter_Font(DC);
  QPainter_setFont(DC, Font);
{$ENDIF}
end;

function SelectPen(DC: HDC; Pen: HPEN): HPEN;
begin
{$IFDEF MSWINDOWS}
  Result := SelectObject(DC, Pen);
{$ELSE}
  Result := QPainter_Pen(DC);
  QPainter_setPen(DC, Pen);
{$ENDIF}
end;

function SelectBrush(DC: HDC; Brush: HBRUSH): HBRUSH;
begin
{$IFDEF MSWINDOWS}
  Result := SelectObject(DC, Brush);
{$ELSE}
  Result := QPainter_Brush(DC);
  QPainter_setBrush(DC, Brush);
{$ENDIF}
end;


// DRAW TEXT

type
  TPrefixes = array of boolean;

  TDT_CBLineFunc = procedure (Canvas: TCanvas; lpString: PWideChar; nCount: Integer;
                          const lpRect: TRect; uFormat: Cardinal; Data: pointer;
                          const Prefixes: TPrefixes; nStartPrefix: integer);

procedure DT_VAlignRect(var lpRect: TRect; const BaseRect: TRect; uFormat: Cardinal);
var
  dy: integer;
begin
  if uFormat and DT_BOTTOM <> 0 then
    dy:=BaseRect.Bottom - lpRect.Bottom
  else if uFormat and DT_VCENTER <> 0 then
    dy:=(BaseRect.Bottom + BaseRect.Top - lpRect.Bottom - lpRect.Top) div 2
  else
    dy:=BaseRect.Top - lpRect.Top;
  OffsetRect(lpRect, 0, dy);
end;

procedure DT_HAlignRect(var lpRect: TRect; const BaseRect: TRect; uFormat: Cardinal);
var
  dx: integer;
begin
  if uFormat and DT_RIGHT <> 0 then
    dx:=BaseRect.Right - lpRect.Right
  else if uFormat and DT_CENTER <> 0 then
    dx:=(BaseRect.Right + BaseRect.Left - 1 - lpRect.Right - lpRect.Left) div 2
  else
    dx:=BaseRect.Left - lpRect.Left;
  OffsetRect(lpRect, dx, 0);
end;

procedure FitString(Canvas: TCanvas; lpString: PWideChar; nCount: Integer;
  NeedWidth: integer; uFormat: Cardinal; IsLastStr: boolean;
  var Prefixes: TPrefixes; nStartPrefix: integer;
  var outnCount: integer; var RemainCount: integer;
  var ResultWidth: integer; var modified: boolean; var modifiedResult: WideString);
var
  Sz,SzR,SzL: TSize;
  wEllipsis, WSz, WCnt,
  L, H, I,
  cntR,cntL,lastcntR: integer;
  lpC: PWideChar;
begin
  RemainCount:=0;
  outnCount:=nCount;
  GetTextExtentPoint32W(Canvas, lpString, nCount, Sz);
  if (Sz.cx <= NeedWidth) or
     (
       (uFormat and DT_SINGLELINE <> 0) and
       (uFormat and (DT_RIGHT or DT_CENTER) <> 0)
     )
  then begin
    ResultWidth:=Sz.cx;
    modified:=false;
    exit;
  end;
// misfits

  if (uFormat and (DT_WORDBREAK or DT_SINGLELINE)) = DT_WORDBREAK
  then begin
// attempt to apply BREAK between WORDS
    lpC:=lpString + nCount - 1;
    cntL:=nCount;
    lastcntR:=nCount;
    repeat
      while (cntL > 0) and not (lpC^ in [WideSPACE,WideTAB]) do begin
        dec(lpC);
        dec(cntL);
      end;
      cntR:=cntL;
      while (cntL > 0) and (lpC^ in [WideSPACE,WideTAB]) do begin
        dec(lpC);
        dec(cntL);
      end;
      if cntR > cntL then begin
        lastcntR:=cntR;
        GetTextExtentPoint32W(Canvas, lpString, cntL, SzL);
        GetTextExtentPoint32W(Canvas, lpString, cntR, SzR);
        if SzL.cx <= NeedWidth then begin
          if SzL.cx = NeedWidth then break;
          L:=cntL;
          H:=cntR;
          WSz := 0;
          WCnt := 0;
          while L <= H do begin
            I:=(L + H) div 2;
            GetTextExtentPoint32W(Canvas, lpString, I, Sz);
            if (Sz.cx <= NeedWidth) then begin
              L:=I + 1;
              WSz:=Sz.cx;
              WCnt:=I;
              if Sz.cx = NeedWidth then break;
            end else if (Sz.cx > NeedWidth) then begin
              H := I - 1;
            end;
          end;
          Sz.cx:=WSz;
          cntR:=WCnt;
          cntL:=cntR;
        end;
      end;
    until (cntL = 0) or (Sz.cx <= NeedWidth);
    // So We CAN APPLY WORD BREAK
    if cntL = 0 then begin
      cntR:=lastcntR;
    end;
      RemainCount:=nCount - cntR;
      nCount:=cntR;
      if IsLastStr then IsLastStr:=RemainCount = 0;
    if (nCount = 0) and (RemainCount > 0) then begin
      nCount:=1;
      dec(RemainCount);
    end;
  end;

  if Sz.cx <= NeedWidth then begin
    ResultWidth:=Sz.cx;
    outnCount:=nCount;
    modified:=false;
    exit;
  end;


  modified:=(IsLastStr and (uFormat and DT_END_ELLIPSIS <> 0)) or
    (uFormat and DT_WORD_ELLIPSIS <> 0);
  if not modified and (uFormat and DT_NOCLIP <> 0)
  then begin
    ResultWidth:=Sz.cx;
    outnCount:=nCount;
    exit;
  end;
  if modified then begin
    GetTextExtentPoint32W(Canvas, '...',  3, Sz);
    wEllipsis:=Sz.cx;
  end
  else
    wEllipsis:=0;
  dec(NeedWidth, wEllipsis);
  if NeedWidth < 0 then begin
    outnCount:=3;
    modified:=true;
    ResultWidth:=wEllipsis;
    modifiedResult:='...';
    for i:=nStartPrefix to nStartPrefix + 3 do Prefixes[i]:=false;
    exit;
  end;
  L:=0;
  H:=nCount;
  WSz := 0;
  WCnt := 0;
  while L <= H do begin
    I:=(L + H) div 2;
    GetTextExtentPoint32W(Canvas, lpString, I, Sz);
    if (Sz.cx <= NeedWidth) then begin
      L:=I + 1;
      WSz:=Sz.cx;
      WCnt:=I;
      if Sz.cx = NeedWidth then break;
    end else if (Sz.cx > NeedWidth) then begin
      H := I - 1;
    end;
  end;
  outnCount:=WCnt;
  ResultWidth:=WSz;
  if modified then begin
    modifiedResult:=WStrFromWCharLen(lpString, WCnt)+'...';
    for i:=nStartPrefix+outnCount to nStartPrefix+outnCount + 3 do Prefixes[i]:=false;
    inc(outnCount,3);
    inc(ResultWidth, wEllipsis);
  end;
end;

procedure DT_LoopLine(Canvas: TCanvas; lpString: PWideChar; nCount: Integer;
  lpRect: TRect; uFormat: Cardinal; params: PDrawTextParams;
  var Prefixes: TPrefixes; Data: pointer; CBFunc: TDT_CBLineFunc;
  var ModifiedResult: WideString);
var
  TextHeight: integer;
  Head, Tail: PWideChar;
  WChar: WideChar;
  RText: TRect;
  nText, outnCount, nRemain, wText: integer;
  isModified: boolean;
  modifiedSubStr: WideString;
  Y: integer;
  iPrefix: integer;
begin
  ModifiedResult:='';
  iPrefix:=0;
  TextHeight := Canvas.TextHeight('X');
  if params<>nil then begin
    inc(lpRect.Left, params^.iLeftMargin);
    dec(lpRect.Right, params^.iRightMargin);
  end;
  if uFormat and DT_SINGLELINE <> 0 then begin
    nText:=nCount;
    FitString(Canvas, lpString, nCount, lpRect.Right-lpRect.Left, uFormat, true,
              Prefixes, iPrefix, nText, nRemain, wText, isModified, modifiedSubStr);
    if isModified then begin
      lpString := @modifiedSubStr[1];
      if uFormat and DT_MODIFYSTRING <> 0 then ModifiedResult:=modifiedSubStr;
    end
    else
      if uFormat and DT_MODIFYSTRING <> 0 then ModifiedResult:=WStrFromWCharLen(lpString, nText);
    RText:=Rect(0, 0, wText, TextHeight);
    DT_VAlignRect(RText, lpRect, uFormat);
    DT_HAlignRect(RText, lpRect, uFormat);
    CBFunc(Canvas, lpString, nText, RText, uFormat, Data, Prefixes, 0);
    exit;
  end;
  Head := lpString;
  Y := lpRect.Top;
  while nCount > 0 do begin
    Tail:=Head;
    nText:=0;
    while (nCount > 0) and not ((Head^ in [WideCR, WideLF]) or (Head^ = WideLineSeparator)) do begin
      Inc(Head);
      Dec(nCount);
      Inc(nText);
    end;
    FitString(Canvas, Tail, nText, lpRect.Right-lpRect.Left, uFormat, nCount = 0,
              Prefixes, iPrefix, outnCount, nRemain, wText, isModified, modifiedSubStr);
    if isModified then begin
      Tail := @modifiedSubStr[1];
      if uFormat and DT_MODIFYSTRING <> 0 then begin
        WStrAppendFromWCharLen(ModifiedResult, @modifiedSubStr[1], length(modifiedSubStr));
        WStrAppendFromWCharLen(ModifiedResult, #0, 1);
      end;
    end
    else
      if uFormat and DT_MODIFYSTRING <> 0 then begin
        WStrAppendFromWCharLen(ModifiedResult, Tail, nText);
        WStrAppendFromWCharLen(ModifiedResult, #0, 1);
      end;
    RText:=Rect(0, 0, wText, TextHeight);
    OffsetRect(RText, 0, Y);
    DT_HAlignRect(RText, lpRect, uFormat);
    CBFunc(Canvas, Tail, outnCount, RText, uFormat, Data, Prefixes, iPrefix);
    inc(Y, TextHeight);
    inc(iPrefix, nText);

    if nRemain > 0 then begin
      inc(nCount, nRemain);
      dec(Head, nRemain);
      dec(iPrefix, nRemain);
    end
    else begin
      if (nCount > 0) then begin
        if ((Head^ in [WideCR, WideLF]) or (Head^ = WideLineSeparator)) then begin
          dec(nCount);
          WChar := Head^;
          if uFormat and DT_MODIFYSTRING <> 0 then
            WStrAppendFromWCharLen(ModifiedResult, @WChar, 1);
          inc(Head);
          inc(iPrefix);
          if (nCount > 0) and
            (((WChar = WideCR) and (Head^ = WideLF)) or ((WChar = WideLF) and (Head^ = WideCR)))
          then begin
            dec(nCount);
            WChar := Head^;
            if uFormat and DT_MODIFYSTRING <> 0 then
              WStrAppendFromWCharLen(ModifiedResult, @WChar, 1);
            inc(Head);
            inc(iPrefix);
          end;
        end;
      end;
    end;
  end;
end;

procedure DT_CalcRect_CB(Canvas: TCanvas; lpString: PWideChar; nCount: Integer;
                          const lpRect: TRect; uFormat: Cardinal; Data: pointer;
                          const Prefixes: TPrefixes; nStartPrefix: integer);
const
  EmptyRect: Types.TRect = (Left: 0; Top: 0; Right: 0; Bottom:0);
begin
  if IsRectEmpty(Types.PRect(Data)^) then
    PRect(Data)^:=lpRect
  else
    UnionRect(PRect(Data)^, PRect(Data)^, lpRect);
end;

procedure DT_OutStr_CB(Canvas: TCanvas; lpString: PWideChar; nCount: Integer;
                          const lpRect: TRect; uFormat: Cardinal; Data: pointer;
                          const Prefixes: TPrefixes; nStartPrefix: integer);
var
{$IFDEF QT_CLX}
  s, subs: WideString;
  st: integer;
{$ELSE}
  pWC: PWideChar;
{$ENDIF}
  flags: integer;
  i,endi, cnt: integer;
  b: boolean;
  Sz: TSize;
  RTx: TRect;
begin
  flags:=0;
{$IFDEF QT_CLX}
  s:=WStrFromWCharLen(lpString, nCount);

  if uFormat and DT_SINGLELINE <> 0 then flags:= flags or integer(AlignmentFlags_SingleLine);
  if uFormat and DT_NOCLIP <> 0 then flags:= flags or integer(AlignmentFlags_DontClip);
{$ELSE}
  if uFormat and DT_NOCLIP = 0 then flags := flags or ETO_CLIPPED;
{$ENDIF}

  if (uFormat and (DT_NOPREFIX or DT_HIDEPREFIX) <> 0) then begin
{$IFDEF QT_CLX}
    QPainter_drawText(Canvas.Handle, @lpRect, flags, @s, nCount, nil, nil);
{$ELSE}
    ExtTextOutW(Canvas.Handle, lpRect.Left, lpRect.Top,  flags, @lpRect, lpString, nCount, nil);
{$ENDIF}
    exit;
  end;
  endi:=nStartPrefix+nCount-1;
  i:=nStartPrefix;
{$IFDEF QT_CLX}
  st:=1;
{$ENDIF}
  RTx:=lpRect;
  while i <= endi do begin
    b:=Prefixes[i];
    cnt:=1;
    inc(i);
    while (i <= endi) and (Prefixes[i] = b) do begin
      inc(cnt);
      inc(i);
    end;
    if b then
      Canvas.Font.Style:=Canvas.Font.Style + [fsUnderline]
    else
      Canvas.Font.Style:=Canvas.Font.Style - [fsUnderline];
    TOverHookCanvas(Canvas).RequiredState([csFontValid]);
{$IFDEF QT_CLX}
    subs:=copy(s, st, cnt);
    inc(st, cnt);
    GetTextExtentPoint32W(Canvas, subs, cnt, Sz);
    RTx.Right:=RTx.Left + Sz.cx;
    QPainter_drawText(Canvas.Handle, @RTx, flags, @subs, cnt, nil, nil);
{$ELSE}
    pWC:=lpString;
    inc(pWC, cnt);
    GetTextExtentPoint32W(Canvas, lpString, cnt, Sz);
    RTx.Right:=RTx.Left + Sz.cx;
    ExtTextOutW(Canvas.Handle, RTx.Left, RTx.Top,  flags, @RTx, lpString, cnt, nil);
    lpString:=pWC;
{$ENDIF}
    RTx.Left:=RTx.Right;
  end;
end;

function DrawTextExW(Canvas: TCanvas; lpString: PWideChar; nCount: Integer;
  var lpRect: TRect; uFormat: Cardinal; params: PDrawTextParams): integer;
var
  RText: TRect;
  RsltStr: WideString;
{$IFDEF QT_CLX}
  QC: QColorH;
  SavTA: TTextAlign;
  SavHasClip: boolean;
{$ENDIF}
  OldClipRgn: HRGN;
  BufStr: WideString;
  Prefixes: TPrefixes;
  i: integer;
begin
  RText:=lpRect;
  RsltStr:='';
{$IFDEF QT_CLX}
  OldClipRgn:=nil;
{$ELSE}
  OldClipRgn:=0;
{$ENDIF}
  if nCount < 0 then nCount:=WCharLen(lpString);

  SetLength(Prefixes, nCount+16);
  if uFormat and DT_NOPREFIX = 0 then begin // Remove prefixes '&'
    BufStr:=WStrFromWCharLen(lpString, nCount);
    i:=1;
    while i < Length(BufStr) do begin
      if (BufStr[i] = '&') then begin
        delete(BufStr, i, 1);
        dec(nCount);
        if (BufStr[i] <> '&') then begin
          Prefixes[i-1]:=true;
        end;
      end;
      inc(i);
    end;
    lpString:=@BufStr[1];
  end;

//  TOverHookCanvas(Canvas).RequiredState([csHandleValid, csFontValid]);

  if uFormat and DT_CALCRECT <> 0 then
    uFormat:=uFormat and not (DT_CENTER or DT_RIGHT or DT_VCENTER or DT_BOTTOM);

  if uFormat and (DT_BOTTOM or DT_VCENTER or DT_CALCRECT) <> 0
  then begin
    RText:=Rect(0, 0, 0, 0);
    DT_LoopLine(Canvas, lpString, nCount, lpRect, uFormat , params, Prefixes, @RText, DT_CalcRect_CB, RsltStr);
  end;

  if uFormat and DT_CALCRECT <> 0
  then begin
    lpRect:=RText;
    result:=RText.Bottom - RText.Top;
    exit;
  end;

  if uFormat and (DT_BOTTOM or DT_VCENTER) <> 0
  then begin
    DT_VAlignRect(RText, lpRect, uFormat);
  end;

// We'll have to draw

  TOverHookCanvas(Canvas).RequiredState([csBrushValid]);
{$IFDEF QT_CLX}
  Canvas.Start(); try
  SavTA:=Canvas.TextAlign;
  Canvas.TextAlign:=taTop;
  QC:=QColor(Canvas.Brush.Color);
  QPainter_setBackgroundColor(Canvas.Handle, QC);
  QColor_destroy(QC);
  SavHasClip:=QPainter_hasClipping(Canvas.Handle);
{$ENDIF}
  if uFormat and DT_NOCLIP = 0 then begin
    OldClipRgn := CreateRectRgn(0, 0, 0, 0);
    GetClipRgn(Canvas.Handle, OldClipRgn);
    IntersectClipRect(Canvas.Handle, lpRect.Left, lpRect.Top, lpRect.Right, lpRect.Bottom);
  end;

  DT_LoopLine(Canvas, lpString, nCount, RText, uFormat , params, Prefixes, nil, DT_OutStr_CB, RsltStr);

  if uFormat and DT_MODIFYSTRING <> 0 then
    Move(RsltStr[1], lpString^, Length(RsltStr)*sizeof(WideChar));

  if uFormat and DT_NOCLIP = 0 then begin
    SelectClipRgn(Canvas.Handle, OldClipRgn);
{$IFDEF QT_CLX}
    QRegion_destroy(OldClipRgn);
    QPainter_setClipping(Canvas.Handle,SavHasClip);
{$ELSE}
    DeleteObject(OldClipRgn);
{$ENDIF}
  end;
  result:=RText.Bottom - lpRect.Top;

{$IFDEF QT_CLX}
  Canvas.TextAlign:=SavTA;
  finally Canvas.Stop(); end;
{$ENDIF}
end;

function DrawTextExW(Canvas: TCanvas; lpString: WideString; nCount: Integer;
  var lpRect: TRect; uFormat: Cardinal; params: PDrawTextParams): integer;
begin
  result:=DrawTextExW(Canvas, @lpString[1], nCount, lpRect, uFormat, params);
end;


// AlphaBlend

procedure AlphaBlendLineConstant(Source, Destination: Pointer; Count: Integer; ConstantAlpha, Bias: Integer);
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI, EAX
        MOV     EDI, EDX
        MOV     EAX, [ConstantAlpha]
        DB      $0F, $6E, $F0
        DB      $0F, $61, $F6
        DB      $0F, $62, $F6
        MOV     EAX, [Bias]
        DB      $0F, $6E, $E8
        DB      $0F, $61, $ED
        DB      $0F, $62, $ED
        MOV     EAX, 128
        DB      $0F, $6E, $E0
        DB      $0F, $61, $E4
        DB      $0F, $62, $E4
@1:
        DB      $0F, $EF, $C0
        DB      $0F, $60, $06
        DB      $0F, $71, $D0, $08
        DB      $0F, $EF, $C9
        DB      $0F, $60, $0F
        DB      $0F, $6F, $D1
        DB      $0F, $71, $D1, $08
        DB      $0F, $F9, $C1
        DB      $0F, $D5, $C6
        DB      $0F, $FD, $C2
        DB      $0F, $71, $D0, $08
        DB      $0F, $F9, $C4
        DB      $0F, $ED, $C5
        DB      $0F, $FD, $C4
        DB      $0F, $67, $C0
        DB      $0F, $7E, $07
@3:
        ADD     ESI, 4
        ADD     EDI, 4
        DEC     ECX
        JNZ     @1
        POP     EDI
        POP     ESI
end;

procedure AlphaBlendLinePerPixel(Source, Destination: Pointer; Count, Bias: Integer);
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI, EAX
        MOV     EDI, EDX
        MOV     EAX, [Bias]
        DB      $0F, $6E, $E8
        DB      $0F, $61, $ED
        DB      $0F, $62, $ED
        MOV     EAX, 128
        DB      $0F, $6E, $E0
        DB      $0F, $61, $E4
        DB      $0F, $62, $E4

@1:
        DB      $0F, $EF, $C0
        DB      $0F, $60, $06
        DB      $0F, $71, $D0, $08
        DB      $0F, $EF, $C9
        DB      $0F, $60, $0F
        DB      $0F, $6F, $D1
        DB      $0F, $71, $D1, $08
        DB      $0F, $6F, $F0
        DB      $0F, $69, $F6
        DB      $0F, $6A, $F6
        DB      $0F, $F9, $C1
        DB      $0F, $D5, $C6
        DB      $0F, $FD, $C2
        DB      $0F, $71, $D0, $08
        DB      $0F, $F9, $C4
        DB      $0F, $ED, $C5
        DB      $0F, $FD, $C4
        DB      $0F, $67, $C0
        DB      $0F, $7E, $07
@3:
        ADD     ESI, 4
        ADD     EDI, 4
        DEC     ECX
        JNZ     @1
        POP     EDI
        POP     ESI
end;

procedure AlphaBlendLineMaster(Source, Destination: Pointer; Count: Integer; ConstantAlpha, Bias: Integer);
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI, EAX
        MOV     EDI, EDX
        MOV     EAX, [ConstantAlpha]
        DB      $0F, $6E, $F0
        DB      $0F, $61, $F6
        DB      $0F, $62, $F6
        MOV     EAX, [Bias]
        DB      $0F, $6E, $E8
        DB      $0F, $61, $ED
        DB      $0F, $62, $ED
        MOV     EAX, 128
        DB      $0F, $6E, $E0
        DB      $0F, $61, $E4
        DB      $0F, $62, $E4
@1:
        DB      $0F, $EF, $C0
        DB      $0F, $60, $06
        DB      $0F, $71, $D0, $08
        DB      $0F, $EF, $C9
        DB      $0F, $60, $0F
        DB      $0F, $6F, $D1
        DB      $0F, $71, $D1, $08
        DB      $0F, $6F, $F8
        DB      $0F, $69, $FF
        DB      $0F, $6A, $FF
        DB      $0F, $D5, $FE
        DB      $0F, $71, $D7, $08
        DB      $0F, $F9, $C1
        DB      $0F, $D5, $C7
        DB      $0F, $FD, $C2
        DB      $0F, $71, $D0, $08
        DB      $0F, $F9, $C4
        DB      $0F, $ED, $C5
        DB      $0F, $FD, $C4
        DB      $0F, $67, $C0
        DB      $0F, $7E, $07
@3:
        ADD     ESI, 4
        ADD     EDI, 4
        DEC     ECX
        JNZ     @1
        POP     EDI
        POP     ESI
end;

procedure AlphaBlendLineMasterAndColor(Destination: Pointer; Count: Integer; ConstantAlpha, Color: Integer);
asm
        DB      $0F, $6E, $D9
        DB      $0F, $61, $DB
        DB      $0F, $62, $DB
        MOV     ECX, $100
        DB      $0F, $6E, $D1
        DB      $0F, $61, $D2
        DB      $0F, $62, $D2
        DB      $0F, $F9, $D3
        MOV     ECX, [Color]
        BSWAP   ECX
        ROR     ECX, 8
        DB      $0F, $6E, $C9
        DB      $0F, $EF, $E4
        DB      $0F, $60, $CC
        DB      $0F, $D5, $CB
@1:
        DB      $0F, $6E, $00
        DB      $0F, $60, $C4
        DB      $0F, $D5, $C2
        DB      $0F, $FD, $C1
        DB      $0F, $71, $D0, $08
        DB      $0F, $67, $C0
        DB      $0F, $7E, $00
        ADD     EAX, 4
        DEC     EDX
        JNZ     @1
end;

procedure EMMS;
asm
        DB      $0F, $77
end;

{$IFDEF QT_CLX}
function CanvasBpp(Canvas: TCanvas): integer;
var
  dev: QPaintDeviceH;
  dev_m: QPaintDeviceMetricsH;
begin
  dev:=QPainter_device(Canvas.Handle);
  dev_m:=QPaintDeviceMetrics_create(dev);
  result:=QPaintDeviceMetrics_depth(dev_m);
  QPaintDeviceMetrics_destroy(dev_m);
end;
{$ELSE}
function CanvasBpp(Canvas: TCanvas): integer;
begin
  result:=GetDeviceCaps(Canvas.Handle, BITSPIXEL) * GetDeviceCaps(Canvas.Handle, PLANES);
end;
{$ENDIF}

function CalcBmScans(Bm: TBitmap; var ScanWidth: integer; var Bits: pointer): boolean;
begin
  Result:=false;
  ScanWidth:=0;
  if Bm.Height < 1 then exit;
  Result:=true;
  Bits:=Bm.ScanLine[0];
  if Bm.Height < 2 then begin
    exit; // scanwidth shouln't be matter in this case (only one scan there is)
  end;
  ScanWidth:=integer(Bm.ScanLine[1]) - integer(Bits);
end;

function CalcScanline(Bits: Pointer; ScanWidth, Row: Integer): Pointer;
begin
  Integer(Result) := Integer(Bits) + Row * ScanWidth;
end;

procedure AlphaBlend(Source, Dest: TBitmap; R: TRect; Target: TPoint;
  Mode: TBlendMode; ConstantAlpha: TAlphaTransparency; Bias: integer);
var
  Y: Integer;
  SourceRun,
  TargetRun: PByte;
  SourceBits,
  DestBits: Pointer;
  SourceScanWidth,
  DestScanWidth: Integer;
{$IFDEF QT_CLX}
  i, DestStartCnt, SrcStartCnt: integer;
{$ENDIF}
begin
  if IsRectEmpty(R) then exit;
{$IFDEF QT_CLX}
  SrcStartCnt:=0;
  DestStartCnt:=0;
{$ENDIF}
  if Assigned(Source) and (Source.Height > 0) then begin
{$IFDEF QT_CLX}
    SrcStartCnt:=Source.Canvas.StartCount;
    for i:=0 to SrcStartCnt-1 do Source.Canvas.Stop;
    Assert(not QPainter_isActive(Source.Canvas.Handle),'Canvas should not be under painting.');
{$ENDIF}
    CalcBmScans(Source, SourceScanWidth, SourceBits);
  end
  else begin
    SourceBits := nil;
    SourceScanWidth:=0;
  end;
  if Assigned(Dest) and (Dest.Height > 0) then begin
{$IFDEF QT_CLX}
    DestStartCnt:=Dest.Canvas.StartCount;
    for i:=0 to DestStartCnt-1 do Dest.Canvas.Stop;
    Assert(not QPainter_isActive(Dest.Canvas.Handle),'Canvas should not be under painting.');
{$ENDIF}
    CalcBmScans(Dest, DestScanWidth, DestBits);
  end
  else begin
    DestBits := nil;
    DestScanWidth:=0;
  end;
{$IFDEF QT_CLX}
  try
{$ENDIF}
  case Mode of
    bmConstantAlpha:
      begin
        if Assigned(SourceBits) and Assigned(DestBits) then begin
          for Y := 0 to R.Bottom - R.Top - 1 do begin
            SourceRun := CalcScanline(SourceBits, SourceScanWidth, Y + R.Top);
            Inc(SourceRun, 4 * R.Left);
            TargetRun := CalcScanline(DestBits, DestScanWidth, Y + Target.Y);
            Inc(TargetRun, 4 * Target.X);
            AlphaBlendLineConstant(SourceRun, TargetRun, R.Right - R.Left, ConstantAlpha, Bias);
          end;
        end;
        EMMS;
      end;
    bmPerPixelAlpha:
      begin
        if Assigned(SourceBits) and Assigned(DestBits) then  begin
          for Y := 0 to R.Bottom - R.Top - 1 do begin
            SourceRun := CalcScanline(SourceBits, SourceScanWidth, Y + R.Top);
            Inc(SourceRun, 4 * R.Left);
            TargetRun := CalcScanline(DestBits, DestScanWidth, Y + Target.Y);
            Inc(TargetRun, 4 * Target.X);
            AlphaBlendLinePerPixel(SourceRun, TargetRun, R.Right - R.Left, Bias);
          end;
        end;
        EMMS;
      end;
    bmMasterAlpha:
      begin
        if Assigned(SourceBits) and Assigned(DestBits) then begin
          for Y := 0 to R.Bottom - R.Top - 1 do begin
            SourceRun := CalcScanline(SourceBits, SourceScanWidth, Y + R.Top);
            Inc(SourceRun, 4 * Target.X);
            TargetRun := CalcScanline(DestBits, DestScanWidth, Y + Target.Y);
            AlphaBlendLineMaster(SourceRun, TargetRun, R.Right - R.Left, ConstantAlpha, Bias);
          end;
        end;
        EMMS;
      end;
    bmConstantAlphaAndColor:
      begin
        if Assigned(DestBits) then begin
          for Y := 0 to R.Bottom - R.Top - 1 do  begin
            TargetRun := CalcScanline(DestBits, DestScanWidth, Y + R.Top);
            Inc(TargetRun, 4 * R.Left);
            AlphaBlendLineMasterAndColor(TargetRun, R.Right - R.Left, ConstantAlpha, Bias);
          end;
        end;
        EMMS;
      end;
  end;
{$IFDEF QT_CLX}
  finally
    for i:=0 to SrcStartCnt-1 do Source.Canvas.Start(True);
    for i:=0 to DestStartCnt-1 do Dest.Canvas.Start(True);
  end;
{$ENDIF}
end;

procedure DrawWindowShadow(Dest: TBitmap; const Bounds: TRect; ShadowSize: Integer);
var
  R, RBm: TRect;
  i,n: integer;
const
  citems = 4;
  alphas: array[0..citems-1] of TAlphaTransparency = (16,16,16,16);
begin
  if ShadowSize = 0 then exit;
  RBm := Rect(0,0,Dest.Width,Dest.Height);
  R := Rect(
    Min(Bounds.Left + ShadowSize - 1, Bounds.Right),
    Max(0,Bounds.Bottom - ShadowSize),
    Max(0, Bounds.Right),
    Max(0, Bounds.Bottom));
  IntersectRect(R, R, RBm);
  n:=Min(R.Bottom - R.Top, Min(ShadowSize, citems));
  for i:=0 to n-1 do begin
    AlphaBlend(nil, Dest, R, Point(0, 0), bmConstantAlphaAndColor,  alphas[i], clBlack);
    Inc(R.Left);
    Dec(R.Right);
    Dec(R.Bottom);
    if (R.Bottom <= R.Top) or (R.Right <= R.Left) then break;
  end;
  R := Rect(
    Max(0,Bounds.Right - ShadowSize),
    Min(Bounds.Top + ShadowSize - 1, Bounds.Bottom),
    Max(0, Bounds.Right),
    Max(0, Bounds.Bottom - ShadowSize));
  IntersectRect(R, R, RBm);
  n:=Min(R.Right - R.Left, Min(ShadowSize, citems));
  for i:=0 to n-1 do begin
    AlphaBlend(nil, Dest, R, Point(0, 0), bmConstantAlphaAndColor,  alphas[i], clBlack);
    Inc(R.Top);
    Dec(R.Right);
    if (R.Bottom <= R.Top) or (R.Right <= R.Left) then break;
  end;
end;


function GetRGBColor(Value: TColor): DWORD;
begin
  Result := ColorToRGB(Value);
{$IFNDEF QT_CLX}
  case Result of
    clNone:
      Result := CLR_NONE;
    clDefault:
      Result := CLR_DEFAULT;
  end;
{$ENDIF}
end;

{
const
  XPMainHeaderColorUp =  $DBEAEB;
  XPMainHeaderColorDown = $D8DFDE;
  XPMainHeaderColorHover = $F3F8FA;
  XPDarkSplitBarColor = $B2C5C7;
  XPLightSplitBarColor = $FFFFFF;
  XPDarkGradientColor = $B8C7CB;
  XPDownOuterLineColor = $97A5A5;
  XPDownMiddleLineColor = $B8C2C1;
  XPDownInnerLineColor = $C9D1D0; }

procedure DrawXPHover(Canvas: TCanvas; ButtonR: TRect; HoverOnTop: boolean);
var
  Width, ImgW, Y, Idx,
  XPos: Integer;
begin
  Width := ButtonR.Right - ButtonR.Left;
  ImgW:=HoverImg.Width;
  if HoverOnTop then begin
    Y:=ButtonR.Top;
    Idx:=3;
  end
  else begin
    Y:=ButtonR.Bottom - HoverImg.Height;
    Idx:=0;
  end;
  if Width <= (ImgW * 2) then begin
    HoverImg.Draw(Canvas, ButtonR.Right - ImgW, Y, Idx + 2);
    HoverImg.Draw(Canvas, ButtonR.Left, Y, Idx);
  end
  else begin
    HoverImg.Draw(Canvas, ButtonR.Left, Y, Idx);
    XPos := ButtonR.Left + ImgW;
    repeat
      HoverImg.Draw(Canvas, XPos, Y, Idx + 1);
      Inc(XPos, ImgW);
    until XPos + ImgW >= ButtonR.Right;
    HoverImg.Draw(Canvas, ButtonR.Right - ImgW, Y, Idx + 2);
  end;
end;

procedure DrawXPButton(Canvas: TCanvas; ButtonR: TRect; DrawSplitter, Down, Hover, HoverOnTop: Boolean);
var
  SavBrColor, SavPnColor, PenColor: TColor;
  dRed, dGreen, dBlue: integer;
  Y, dY: integer;
begin
{$IFDEF QT_CLX}
  Canvas.Start; try
{$ENDIF}
  SavBrColor:=Canvas.Brush.Color;
  SavPnColor:=Canvas.Pen.Color;
  if Down then
    Canvas.Brush.Color := XPMainHeaderColorDown
  else if Hover then
    Canvas.Brush.Color := XPMainHeaderColorHover
  else
    Canvas.Brush.Color := XPMainHeaderColorUp;
  Canvas.FillRect(ButtonR);
  Canvas.Brush.Color:=SavBrColor;

  if DrawSplitter and not (Down or Hover) then
  begin
    Canvas.Pen.Color:=XPDarkSplitBarColor;
    Canvas.MoveTo(ButtonR.Right - 2, ButtonR.Top + 3);
    Canvas.LineTo(ButtonR.Right - 2, ButtonR.Bottom - 5);
    Canvas.Pen.Color:=XPLightSplitBarColor;
    Canvas.MoveTo(ButtonR.Right - 1, ButtonR.Top + 3);
    Canvas.LineTo(ButtonR.Right - 1, ButtonR.Bottom - 5);
  end;

  if Down then begin
    Canvas.Pen.Color:=XPDownOuterLineColor;
    Canvas.MoveTo(ButtonR.Left, ButtonR.Top);
    Canvas.LineTo(ButtonR.Left, ButtonR.Bottom - 1);
    Canvas.LineTo(ButtonR.Right - 1, ButtonR.Bottom - 1);
    Canvas.LineTo(ButtonR.Right - 1, ButtonR.Top - 1);

    Canvas.Pen.Color:=XPDownMiddleLineColor;
    Canvas.MoveTo(ButtonR.Left + 1, ButtonR.Bottom - 2);
    Canvas.LineTo(ButtonR.Left + 1, ButtonR.Top);
    Canvas.LineTo(ButtonR.Right - 1, ButtonR.Top);

    Canvas.Pen.Color:=XPDownInnerLineColor;
    Canvas.MoveTo(ButtonR.Left + 2, ButtonR.Bottom - 2);
    Canvas.LineTo(ButtonR.Left + 2, ButtonR.Top + 1);
    Canvas.LineTo(ButtonR.Right - 1, ButtonR.Top + 1);
  end
  else if Hover then begin
    DrawXPHover(Canvas,  ButtonR, HoverOnTop);
  end
  else begin
    if HoverOnTop then begin
      Y:=ButtonR.Top;
      dY:=1;
    end
    else begin
      Y:=ButtonR.Bottom-1;
      dY:=-1;
    end;
    PenColor := XPMainHeaderColorUp;
    dRed := ((PenColor and $FF) - (XPDarkGradientColor and $FF)) div 3;
    dGreen := (((PenColor shr 8) and $FF) - ((XPDarkGradientColor shr 8) and $FF)) div 3;
    dBlue := (((PenColor shr 16) and $FF) - ((XPDarkGradientColor shr 16) and $FF)) div 3;

    PenColor := PenColor - Lo(dRed) - Lo(dGreen) shl 8 - Lo(dBlue) shl 16;
    Canvas.Pen.Color:=PenColor;
    Canvas.MoveTo(ButtonR.Left, Y + 2*dY);
    Canvas.LineTo(ButtonR.Right, Y + 2*dY);

    Canvas.Pen.Color := PenColor - Lo(dRed) - Lo(dGreen) shl 8 - Lo(dBlue) shl 16;
    Canvas.MoveTo(ButtonR.Left, Y + dY);
    Canvas.LineTo(ButtonR.Right, Y + dY);

    Canvas.Pen.Color := XPDarkGradientColor;
    Canvas.MoveTo(ButtonR.Left, Y);
    Canvas.LineTo(ButtonR.Right, Y);
  end;
  Canvas.Pen.Color:=SavPnColor;
{$IFDEF QT_CLX}
  finally Canvas.Stop(); end;
{$ENDIF}
end;

function MixColors(clr1, clr2: DWORD; Weight: Byte): DWORD; register; assembler;
asm
// CL  = Weight
// EAX = clr1
// EDX = clr2
        PUSH    ESI
        PUSH    EBP
        PUSH    EBX
        MOV     ESI,3
        MOV     EBP, EAX
        MOV     EBX, EDX
        MOVZX   ECX, CL
@@1:
        AND     EAX, 0FFh
        AND     EDX, 0FFh
        IMUL    EAX, ECX
        NOT     CL
        IMUL    EDX, ECX
        NOT     CL
        ADD     EAX, EDX
        MOV     BL, AH
        ROR     EBX, 8
        ROR     EBP, 8
        MOV     EAX, EBP
        MOV     EDX, EBX
        DEC     ESI
        JNZ     @@1
        MOV     EAX, EBX
        ROR     EAX, 8
        AND     EAX, 0FFFFFFh
        POP     EBX
        POP     EBP
        POP     ESI
end;

function BSwapRGB(clr: DWORD) : DWORD; register; assembler;
asm
        BSWAP   EAX
        ROR     EAX, 8
end;

procedure BSwapRGBs(var Colors; Count: Integer); register; assembler;
asm
        PUSH  EBX
        MOV   ECX, EDX // Count
        MOV   EBX, EAX // Colors
        JECXZ @@END
@@1:
        MOV   EAX, [EBX]
        BSWAP EAX
        SHR   EAX,8
        MOV   [EBX],EAX
        ADD   EBX,4
        LOOP  @@1
        JMP   @@END
@@END:
        POP   EBX
end;

// CreateMappedRes

procedure ConvertColors(Colors: PRGBQuadArray; ColorCount: integer;
  DoSwap: boolean; const OldColors, NewColors: array of TColor);
var
  I, J: Integer;
  C: TColorRef;
  _OldColors, _NewColors: array of TColor;
  L: Integer;
begin
  L:=High(OldColors)-Low(OldColors)+1;
  SetLength(_OldColors, L);
  SetLength(_NewColors, L);
  for I:=0 to L-1 do begin
    _NewColors[I]:=ColorToRGB(NewColors[I]);
    _OldColors[I]:=ColorToRGB(OldColors[I]);
  end;
  if DoSwap then BSwapRGBs(Colors^, ColorCount);
  for I := 0 to ColorCount - 1 do begin
    C:=TColorRef(Colors[I]);
    for J := 0 to L-1 do
      if C = TColorRef(_OldColors[J]) then
        Integer(Colors[I]) := _NewColors[J];
  end;
  if DoSwap then BSwapRGBs(Colors^, ColorCount);
end;

{$IFDEF QT_CLX}

type
  THACKBitmap = class(TGraphic)
  public
    FImage: QImageH;
  end;

function ImageFromStream(Stream: TStream): QImageH;
var
  IO: QImageIOH;
  Device: QIODeviceH;
  Format: string;
begin
  Result:=nil;
  Device := IODeviceFromStream(Stream);
  try
    Format := QImageIO_imageFormat(Device);
    IO := QImageIO_create(Device, PChar(Format));
    try
      if not QImageIO_read(IO) then exit;
      Result := QImage_create(QImageIO_image(IO));
    finally
      QImageIO_destroy(IO);
    end;
  finally
    QClxIODevice_destroy(QClxIODeviceH(Device));
  end;
end;

function ImageFromResource(Instance: Cardinal;
  const ResName: string; ResType: PChar = RT_BITMAP): QImageH;
var
  Stream: TResourceStream;
  TmpStream: TMemoryStream;
  Header: TBitmapFileHeader;
  BmpHeader: TBitMapInfoHeader;
begin
  Stream := TResourceStream.Create(Instance, ResName, ResType);
  try
    TmpStream := TMemoryStream.Create;
    try
      // Reads bitmap header
      Stream.ReadBuffer(BmpHeader, SizeOf(BmpHeader));
      Stream.Seek(0, soBeginning);

      // Builds file header
      FillChar(Header, SizeOf(Header), 0);
      Header.bfType := $4D42;
      Header.bfSize := Stream.Size;
      Header.bfReserved1 := 0;
      Header.bfReserved2 := 0;

      if BmpHeader.biBitCount > 8 then
        Header.bfOffBits := sizeof(Header) + sizeof(BmpHeader)
      else
        if BmpHeader.biClrUsed = 0 then
          Header.bfOffBits := sizeof(Header) + sizeof(BmpHeader) +
            (1 shl BmpHeader.biBitCount) * 4
        else
          Header.bfOffBits := sizeof(Header) + sizeof(BmpHeader) +
            BmpHeader.biClrUsed * 4;

      // Concatenates both in TmpStream
      TmpStream.WriteBuffer(Header, SizeOf(Header));
      TmpStream.CopyFrom(Stream, Stream.Size);
      TmpStream.Position := 0;
      Result:=ImageFromStream(TmpStream);
    finally
      TmpStream.Free;
    end;
  finally
    Stream.Free;
  end;
end;

function BitmapFromImage(FImage: QImageH): TBitmap;
begin
  Result:=TBitmap.Create;
  THACKBitmap(Result).FImage:=FImage;
end;

function CreateMappedRes(Instance: THandle; ResName: PChar;
  const OldColors, NewColors: array of TColor): TBitmap;
var
  p: pointer;
  cnt,i: integer;
  FImage: QImageH;
  pColors: PRGBQuadArray;
begin
  Result:=TBitmap.Create;
  try
    FImage:=ImageFromResource(Instance, ResName);
  except
    exit;
  end;
  if not Assigned(FImage) then exit;
  try
    p:=QImage_colorTable(FImage);
    if Assigned(p) then begin
      cnt:=QImage_numColors(FImage);
      GetMem(pColors, cnt * sizeof(QRgb));
      try
        Move(p^, pColors^, cnt*sizeof(QRgb));
        ConvertColors(pColors, cnt, true, OldColors, NewColors);
        for i:=0 to cnt-1 do begin
          QImage_setColor(FImage, i, @pColors^[i]);
        end;
      finally
        FreeMem(pColors);
      end;
    end;
  // Convert
    Result:=BitmapFromImage(FImage);
    FImage:=nil;
  finally
    if Assigned(FImage) then QImage_destroy(FImage);
  end;
end;
{$ELSE}
function CreateMappedRes(Instance: THandle; ResName: PChar;
  const OldColors, NewColors: array of TColor): TBitmap;
var
  Rsrc: HRSRC;
  Res: THandle;
  ColorCount: DWORD;
  BitmapInfoSize: Integer;
  Bitmap: PBitmapInfoHeader;
  BitmapInfo: PBitmapInfoHeader;
  Bits: Pointer;
  ScreenDC, DC: HDC;
  Save, HBm: HBITMAP;
begin
  Result := TBitmap.Create;
  Rsrc := FindResource(Instance, ResName, RT_BITMAP);
  if Rsrc = 0 then Exit;
  Res := LoadResource(Instance, Rsrc);
  try
    { Lock the bitmap and get a pointer to the color table. }
    Bitmap := LockResource(Res);
    if Bitmap <> nil then
    try
      if (Bitmap^.biBitCount * Bitmap^.biPlanes) <= 8 then
      begin
        ColorCount := 1 shl (Bitmap^.biBitCount);
        BitmapInfoSize := Bitmap^.biSize + ColorCount * SizeOf(TRGBQuad);
        GetMem(BitmapInfo, BitmapInfoSize);
        try
          Move(Bitmap^, BitmapInfo^, BitmapInfoSize);
          if Bitmap^.biBitCount <= 8 then
            ConvertColors(Pointer(DWORD(BitmapInfo) + BitmapInfo^.biSize), ColorCount, true, OldColors, NewColors);
          { First skip over the header structure and color table entries, if any. }
          Bits := Pointer(Longint(Bitmap) + BitmapInfoSize);
          { Create a color bitmap compatible with the display device. }
          ScreenDC := GetDC(0);
          try
            DC := CreateCompatibleDC(ScreenDC);
            if DC <> 0 then begin
              with BitmapInfo^ do begin
                HBm := CreateCompatibleBitmap(ScreenDC, biWidth, biHeight);
                if HBm <> 0 then begin
                  Save := SelectObject(DC, HBm);
                  StretchDIBits(DC, 0, 0, biWidth, biHeight, 0, 0, biWidth, biHeight,
                    Bits, PBitmapInfo(BitmapInfo)^, DIB_RGB_COLORS, SrcCopy);
                  SelectObject(DC, Save);
                  Result.Handle := HBm;
                end;
              end;
              DeleteDC(DC);
            end;
          finally
            ReleaseDC(0, ScreenDC);
          end;
        finally
          FreeMem(BitmapInfo, BitmapInfoSize);
        end;
      end
      else begin
        Result.LoadFromResourceID(Instance, Integer(ResName));
      end;
    finally
      UnlockResource(Res);
    end;
  finally
    FreeResource(Res);
  end;
end;
{$ENDIF}

const
  Grays: array[0..4] of TColor = (clYellow, clWhite, clSilver, clGray, clBlack);
  SysGrays: array[0..4] of TColor = (clWindow, clBtnHighLight, clBtnFace, clBtnShadow, clWindowFrame);

procedure ConvertImageListBm(IL: TImageList; Images: TBitmap; Count: integer = -1);
var
  OneImage: TBitmap;
  i, j, cw, ch, nx, ny: Integer;
  MaskColor: TColor;
  Source, Dest: TRect;

{  stm: TStream;}
begin
  OneImage := TBitmap.Create;
  try
    IL.Clear;
{$IFDEF QT_CLX}
    if QPixmap_IsNull(Images.Handle) then exit;
{$ENDIF}
    cw := IL.Width;
    ch := IL.Height;
    OneImage.Width := cw;
    OneImage.Height := ch;
    if (cw > 0) and (ch > 0) then begin
      nx := max(1, Images.Width div cw);
      ny := max(1, Images.Height div ch);
      if Count < 0 then
        Count := nx * ny
      else
        Count := min(Count, nx * ny);
      MaskColor := clNone;

      Dest := Rect(0, 0, cw, ch);
{$IFDEF QT_CLX}
      OneImage.Canvas.Start();
      Images.Canvas.Start();
{$ENDIF}
      try
        for i := 0 to ny - 1 do begin
          if Count <= 0 then break;
          Source := Dest;
          OffsetRect(Source, 0, i * ch);
          for j := 0 to nx - 1 do begin
            if Count <= 0 then break;
            OneImage.Canvas.CopyRect(Dest, Images.Canvas, Source);
            if (i = 0) and (j = 0) then
              MaskColor := OneImage.TransparentColor; // Ask the first image ONLY and apply for others
            IL.AddMasked(OneImage, MaskColor);
            OffsetRect(Source, cw, 0);
            dec(Count);
          end;
        end;
      finally
{$IFDEF QT_CLX}
        Images.Canvas.Stop;
        OneImage.Canvas.Stop();
{$ENDIF}
      end;
    end;
  {      stm := TFileStream.Create('/root/1.bmp', fmCreate);
    IL.WriteData(stm);
    IL.Clear;
    stm.Seek(0, soFromBeginning);
    IL.ReadData(stm);
    stm.Free;
    stm := TFileStream.Create('/root/2.bmp', fmCreate);
    IL.WriteData(stm);
    stm.Free;}
  finally
    OneImage.Free;
  end;
end;

procedure ConvertImageList(IL: TImageList; const ImageName: string; ColorRemapping: Boolean = True);
var
  Images: TBitmap;
begin
{$IFNDEF QT_CLX}
  with IL do
    Handle := ImageList_Create(Width, Height, ILC_COLOR16 or ILC_MASK, 0, AllocBy);
{$ENDIF}
  Watcher.Enter;
  try
    if ColorRemapping then begin
      Images := CreateMappedRes(FindHInstance(@ConvertImageList), PChar(ImageName), Grays, SysGrays);
    end
    else begin
      Images := TBitmap.Create;
      try
        Images.LoadFromResourceName(FindHInstance(@ConvertImageList), PChar(ImageName));
      except
      end;
    end;
    try
      ConvertImageListBm(IL, Images);
    finally
      Images.Free;
    end;
  finally
    Watcher.Leave;
  end;
end;

procedure Animate(Steps, Duration: Integer; Callback: TDmtAnimationCallback; Data: Pointer);
const
  pnil: pointer = nil;
var
  StepSize,
  RemainingTime,
  RemainingSteps,
  NextTimeStep,
  CurrentStep,
  StartTime,
  CurrentTime: Integer;

begin
  if not (InAnimation) and (Duration > 0) then
  begin
    InAnimation:=true;
    try
      RemainingTime := Duration;
      RemainingSteps := Steps;

      StepSize := Round(Max(1, RemainingSteps / Duration));
      RemainingSteps := RemainingSteps div StepSize;
      CurrentStep := 0;

      while (RemainingSteps > 0) and (RemainingTime > 0) and not Application.Terminated do
      begin
        StartTime := timeGetTime;
        NextTimeStep := StartTime + RemainingTime div RemainingSteps;
        if not Callback(CurrentStep, StepSize, Data) then
          Break;

        CurrentTime := timeGetTime;
        while CurrentTime < NextTimeStep do begin
{$IFDEF QT_CLX}
          Sleep(2);
{$ELSE}
          MsgWaitForMultipleObjects(0, pnil, false, 2, QS_ALLINPUT); // this avoids 100% CPU utilization.
{$ENDIF}
          CurrentTime := timeGetTime;
        end;

        Dec(RemainingTime, CurrentTime - StartTime);
        Dec(RemainingSteps);
        if (RemainingSteps > 0) and ((RemainingTime div RemainingSteps) < 1) then
        begin
          repeat
            Inc(StepSize);
            RemainingSteps := RemainingTime div StepSize;
          until (RemainingSteps <= 0) or ((RemainingTime div RemainingSteps) >= 1);
        end;
        CurrentStep := Steps - RemainingSteps;
      end;

      if not Application.Terminated then
        Callback(0, 0, Data);
    finally
      InAnimation:=false;
    end;
  end;
end;

procedure Bresenham(c1,c2: Byte; Len: integer; Rslt: pDWord); register;
var
  YIncr, Corr,c2Sav: integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOVZX   EAX,AL     // eax=c1
        MOVZX   EDX,DL     // edx=c2
        MOV     [c2Sav],EDX
                           // ecx=len
        SUB     ECX,1
        JL      @Done
        MOV     ESI,1
        MOV     EBX,EDX
        SUB     EBX,EAX
        JG      @1
        NEG     ESI
        NEG     EBX
@1:
        MOV     YIncr,ESI
// EBX=dY
// ECX=dX

        CMP     EBX,ECX    // Slope
        JG      @VSlope

// HSlope:
        MOV     ESI,ECX    // ESI <- dX
        SHL     ESI,1      // 2 * dX
        NEG     ESI
        MOV     EDX,ESI    // ABIncr = AIncr - BIncr = - 2 * dx
        SHL     EBX,1      // BIncr = dY * 2
        MOV     ESI,EBX
        SUB     ESI,ECX    // d = 2 * dy - dx
        MOV     EDI,[Rslt] // edi=>Result array
        MOV     [EDI],AL
        ADD     EDI,4
        JECXZ   @Done
        PUSH    EBP
        MOV     EBP,YIncr
@LHSlope:
        OR      ESI,ESI
        JL      @5
        ADD     EAX,EBP  // YIncr
        ADD     ESI,EDX  // AIncr-BIncr
@5:
        ADD     ESI,EBX  // BIncr
        MOV     [EDI],AL
        ADD     EDI,4
        LOOP    @LHSlope
        POP     EBP
        JMP     @Done

@VSlope:
// EBX = dY
// ECX = dX
        MOV     ESI,EBX    // ESI <- dy
        SHL     ESI,1      // 2 * dY
        NEG     ESI
        MOV     EDX,ESI    // ABIncr = AIncr - BIncr = - 2 * dY

        MOV     ESI,ECX
        SHL     ESI,1      // BIncr = dx * 2
        XCHG    EBX,ESI
        NEG     ESI
        ADD     ESI,EBX    // d = 2 * dx - dy

        MOV     EDI,[Rslt] // edi=>Result array
        MOV     [EDI],AL
        ADD     EDI,4
        JECXZ   @Done
// EAX = y1
// EBX = BIncr
// ECX = dX
// EDX = ABIncr
// ESI = d
// EDI -> Result
        PUSH    EBP
        PUSH    0
        PUSH    [YIncr]
        CMP     [YIncr],0
        JG      @7
        MOV     [ESP+4],1
@7:
        XOR     EBP,EBP
@LVSlope:
        ADD     EAX,[ESP]
        ADD     EBP,[ESP]
        OR      ESI,ESI
        JL      @10
        ADD     EBP,[ESP+4]
        SAR     EBP,1
        ADD     EAX,EBP
        MOV     [EDI],AL
        ADD     EDI,4
        SUB     EAX,EBP
        XOR     EBP,EBP
        DEC     ECX
        JZ      @LVDone
        ADD     ESI,EDX  // AIncr-BIncr
@10:
        ADD     ESI,EBX  // BIncr
        JMP     @LVSlope
@LVDone:
        POP     EBP
        POP     EBP
        POP     EBP
        MOV     EAX,[c2Sav]
        MOV     [EDI-4],AL

@Done:
        POP     EBX
        POP     EDI
        POP     ESI
end;

procedure DmGradientFill(Canvas: TCanvas; c1,c2: TColor; DestRect: TRect; GradType: TDmGradType);
type
  TClrComponent = packed array[0..3] of byte;
var
  srcRect: TRect;
  clr1, clr2: DWORD;
  citems: packed array of TClrComponent;
  Bits: Pointer;
  x2,icomp: integer;
{$IFNDEF QT_CLX}
  W,
{$ENDIF}
  H, i: integer;
  ScanWidth: integer;
begin
{$IFDEF QT_CLX}
  Canvas.Start; try
{$ENDIF}
  case GradType of
    GT_VERT: begin
      x2:=DestRect.Bottom - DestRect.Top;
      GradBuffer.Width:=1;
      GradBuffer.Height:=x2;
      CalcBmScans(GradBuffer, ScanWidth, Bits);
    end;
    GT_HORIZ: begin
      x2:=DestRect.Right - DestRect.Left;
{$IFDEF QT_CLX}
      GradBuffer.Height:=1;
{$ELSE}
      if (Win32Platform and VER_PLATFORM_WIN32_NT) <> 0 then
        GradBuffer.Height:=1
      else
        GradBuffer.Height:=5;// Win98 BUG. We must set at least 5 scans to achieve right StretchBlt
{$ENDIF}
      GradBuffer.Width:=x2;
      CalcBmScans(GradBuffer, ScanWidth, Bits);
      ScanWidth:=sizeof(DWORD);
    end;
    else
      exit;
  end;
  if x2<=0 then exit;
  clr1:=BSwapRGB(GetRGBColor(c1));
  clr2:=BSwapRGB(GetRGBColor(c2));

  SetLength(citems,x2);
  for icomp:=0 to 2 do
    Bresenham(tclrcomponent(clr1)[icomp], tclrcomponent(clr2)[icomp], x2, @citems[0][icomp]);

{$IFNDEF QT_CLX}
  W:=GradBuffer.Width;
{$ENDIF}
  H:=GradBuffer.Height;

  for i:=0 to x2-1 do begin
    DWORD(Bits^):=DWORD(citems[i]);
    inc(integer(Bits),ScanWidth);
  end;
  case GradType of
    GT_VERT: begin
      srcRect:=Rect(0, 0, 1, x2);
    end;
    GT_HORIZ: begin
{$IFNDEF QT_CLX}
      if H > 1 then begin
        GradBuffer.Canvas.CopyMode:=cmSrcCopy;
        GradBuffer.Canvas.CopyRect(Rect(0,0,W,H), GradBuffer.Canvas, Rect(0, 0, W, 1));
      end;
{$ENDIF}
      srcRect:=Rect(0, 0, x2, H);
    end;
    else
      srcRect:=Rect(0, 0, 0, 0);
  end;
{$IFDEF QT_CLX}
  Canvas.StretchDraw(DestRect, GradBuffer);
{$ELSE}
  Canvas.CopyMode:=cmSrcCopy;
  Canvas.CopyRect(DestRect, GradBuffer.Canvas, srcRect)
{$ENDIF}
{$IFDEF QT_CLX}
  finally Canvas.Stop; end;
{$ENDIF}
end;

{$IFDEF QT_CLX}
{$IFDEF LINUX}
const
  clBtnHighLight = clLight;
  cl3dLight = clButton;
  clBtnFace  = clButton;
  clBtnShadow  = clMid;
  cl3dDkShadow = clShadow;
  clWindowFrame = clShadow;
{$ELSE}
const
  clBtnHighLight = clLight;
  cl3dLight = clBackground;
  clBtnFace  = clButton;
  clBtnShadow  = clMid;
  cl3dDkShadow = clShadow;
  clWindowFrame = clShadow;
{$ENDIF}

//              Linux/Qt       Win/Qt            Win32
// clLight      $FFFFFF        $FFFFFF
// clMidlight   $F6F2F6        $D3D3D3
// clButton     $E6E6E6        $C0C0C0
// clBackground $DEDEDE        $C0C0C0
// clMid        $B4B4B4        $808080
// clDark       $525252        $808080
// clShadow     $000000        $000000

// clBtnHighLight $FFFFFF      $FFFFFF           $FFFFFF
// cl3dLight      $F6F2F6      $D3D3D3           $C0C0C0
// clBtnFace      $E6E6E6      $C0C0C0           $C0C0C0
// clBtnShadow    $525652      $808080           $808080
// cl3dDkShadow   $B4B6B4      $808080           $000000
// clWindowFrame  $085D8B      $000080           $000000
{$ENDIF}

type
  TEdgeColors = record
    TLC, BRC: TColor;
  end;

var
  EdgeColorsArray: array[0..7,0..3] of TEdgeColors =
  (((TLC:cl3dLight;BRC:cl3dDkShadow),(TLC:clBtnShadow;BRC:clBtnHighLight),(TLC:clBtnHighLight;BRC:clBtnShadow),(TLC:cl3dDkShadow;BRC:cl3dLight)),
   ((TLC:clBtnHighLight;BRC:cl3dDkShadow),(TLC:cl3dDkShadow;BRC:clBtnHighLight),(TLC:cl3dLight;BRC:clBtnShadow),(TLC:clBtnShadow;BRC:cl3dLight)),

   ((TLC:clBtnShadow;BRC:clBtnShadow),(TLC:clBtnShadow;BRC:clBtnShadow),(TLC:clBtnFace;BRC:clBtnFace),(TLC:clBtnFace;BRC:clBtnFace)),
   ((TLC:clBtnShadow;BRC:clBtnShadow),(TLC:clBtnShadow;BRC:clBtnShadow),(TLC:clBtnFace;BRC:clBtnFace),(TLC:clBtnFace;BRC:clBtnFace)),

   ((TLC:clWindowFrame;BRC:clWindowFrame),(TLC:clWindowFrame;BRC:clWindowFrame),(TLC:clWindow;BRC:clWindow),(TLC:clWindow;BRC:clWindow)),
   ((TLC:clWindowFrame;BRC:clWindowFrame),(TLC:clWindowFrame;BRC:clWindowFrame),(TLC:clWindow;BRC:clWindow),(TLC:clWindow;BRC:clWindow)),

   ((TLC:clWindowFrame;BRC:clWindowFrame),(TLC:clWindowFrame;BRC:clWindowFrame),(TLC:clWindow;BRC:clWindow),(TLC:clWindow;BRC:clWindow)),
   ((TLC:clWindowFrame;BRC:clWindowFrame),(TLC:clWindowFrame;BRC:clWindowFrame),(TLC:clWindow;BRC:clWindow),(TLC:clWindow;BRC:clWindow)));

function DoDrawEdge(Canvas: TCanvas; var r: TRect; idx, grfFlags: integer): bool;
var
  ec: TEdgeColors;
  idx0: integer;
  r1,rRslt: TRect;
begin
  Result:=false;
  rRslt:=r;
  if (idx < 0) or (idx > 3) then exit;
  idx0:=0;
  if grfFlags and BF_SOFT <> 0 then idx0:=idx0 or 1;
  if grfFlags and BF_FLAT <> 0 then idx0:=idx0 or 2;
  if grfFlags and BF_MONO <> 0 then idx0:=idx0 or 4;
  ec:=EdgeColorsArray[idx0,idx];
  Canvas.Brush.Color:=ec.TLC;
  if grfFlags and BF_LEFT <> 0 then begin
    r1:=r;
    r1.Right:=r1.Left+1;
    if grfFlags and BF_BOTTOM <> 0 then dec(r1.Bottom);
    Canvas.FillRect(r1);
    Result:=true;
    inc(rRslt.Left);
  end;
  if grfFlags and BF_TOP <> 0 then begin
    r1:=r;
    r1.Bottom:=r1.Top+1;
    if grfFlags and BF_RIGHT <> 0 then dec(r1.Right);
    Canvas.FillRect(r1);
    Result:=true;
    inc(rRslt.Top);
  end;
  Canvas.Brush.Color:=ec.BRC;
  if grfFlags and BF_RIGHT <> 0 then begin
    r1:=r;
    r1.Left:=r1.Right-1;
    if grfFlags and BF_BOTTOM <> 0 then dec(r1.Bottom);
    Canvas.FillRect(r1);
    Result:=true;
    dec(rRslt.Right);
  end;
  if grfFlags and BF_BOTTOM <> 0 then begin
    r1:=r;
    r1.Top:=r1.Bottom-1;
    Canvas.FillRect(r1);
    Result:=true;
    dec(rRslt.Bottom);
  end;
  r:=rRslt;
end;

function DrawEdge(Canvas: TCanvas; var qrc: TRect; edge: UINT; grfFlags: UINT): BOOL;
var
  idx: integer;
  r: TRect;
begin
  result:=false;
  if IsRectEmpty(qrc) then exit;
  r:=qrc;
  EdgSavBrush.Assign(Canvas.Brush);
  try
// Draw Outer
    idx:=-1;
    case (edge and BDR_OUTER) of
      BDR_RAISEDOUTER: idx:=0;
      BDR_SUNKENOUTER: idx:=1;
    end;
    if idx >=0 then Result:=DoDrawEdge(Canvas, r, idx, grfFlags);
// Draw Inner
    idx:=-1;
    case (edge and BDR_INNER) of
      BDR_RAISEDINNER: idx:=2;
      BDR_SUNKENINNER: idx:=3;
    end;
    if idx >=0 then Result:=DoDrawEdge(Canvas, r, idx, grfFlags) or Result;
// Draw Middle
    if grfFlags and BF_MIDDLE <> 0 then begin
      if grfFlags and BF_MONO <> 0 then
        Canvas.Brush.Color:=clWindow
      else
        Canvas.Brush.Color:=clBtnFace;
      Canvas.FillRect(r);
      Result:=Result or not IsRectEmpty(r);
    end;
// Ret result
    if grfFlags and BF_ADJUST <> 0 then qrc:=r;
  finally
    Canvas.Brush:=EdgSavBrush;
  end;
end;

{$IFDEF QT_CLX}

// Painter/Painter objects

function BitBlt(DestDC: QPainterH; XDest, YDest, Width, Height: Integer;
  SrcDC: QPainterH; XSrc, YSrc: Integer; Rop: Qt.RasterOp): BOOL;
var
  DestDev, SrcDev: QPaintDeviceH;
  DestOrg, SrcOrg: TPoint;
begin
  GetWindowOrgEx(DestDC, @DestOrg);
  GetWindowOrgEx(SrcDC, @SrcOrg);
  DestDev:=QPainter_device(DestDC);
  SrcDev:=QPainter_device(SrcDC);
  Qt.bitBlt(DestDev, XDest - DestOrg.X, YDest - DestOrg.Y,
    SrcDev, XSrc - SrcOrg.X, YSrc - SrcOrg.Y, Width, Height, Rop, True);
  Result:=TRUE;
end;

function CombineRgn(hrgnDest, hrgnSrc1, hrgnSrc2: QRegionH; fnCombineMode: Integer): Integer;
begin
  Result:=3;
  case fnCombineMode of
    RGN_AND:
      QRegion_intersect(hrgnSrc1, hrgnDest, hrgnSrc2);
    RGN_OR:
      QRegion_unite(hrgnSrc1, hrgnDest, hrgnSrc2);
    RGN_XOR:
      QRegion_eor(hrgnSrc1, hrgnDest, hrgnSrc2);
    RGN_DIFF:
      QRegion_subtract(hrgnSrc1, hrgnDest, hrgnSrc2);
    RGN_COPY: begin // not very effectively since there is no QRegion_copy
      QRegion_subtract(hrgnDest, hrgnDest, hrgnDest); // should clear
      QRegion_unite(hrgnSrc1, hrgnDest, hrgnSrc2);
    end;
  else
    Result:=0;
  end;
end;

function CreateRectRgn(L,T,R,B: integer): QRegionH;
begin
  result:=QRegion_create(l, t, r-l, b-t, QRegionRegionType_Rectangle);
end;

function CreateRectRgnIndirect(const p1: TRect): QRegionH;
begin
  result:=QRegion_create(@p1, QRegionRegionType_Rectangle);
end;

function CreatePatternBrush(PixMap: QPixMapH): QBrushH;
begin
  result:=QBrush_create(BrushStyle_CustomPattern);
  QBrush_setPixmap(result, PixMap);
end;

function CreateSolidBrush(crColor: DWORD): QBrushH;
var
  QC: QColorH;
begin
  QC := QColor(crColor );
  result:=QBrush_create(QC, BrushStyle_SolidPattern);
  if Assigned(QC) then
    QColor_destroy(QC);
end;

function CreatePen(style: integer; width: integer; crColor: DWORD): QPenH;
var
  QC: QColorH;
const
  MAXSTYLE = 5;
  QtPenStyles: array[0..MAXSTYLE] of PenStyle = (
    PenStyle_SolidLine,
    PenStyle_DashLine,
    PenStyle_DotLine,
    PenStyle_DashDotLine,
    PenStyle_DashDotDotLine,
    PenStyle_NoPen);
begin
  QC := QColor(crColor );
  if not (style in [0..MAXSTYLE]) then style := 0;
  result:=QPen_create(QC, width, QtPenStyles[style]);
  if Assigned(QC) then
    QColor_destroy(QC);
end;

function ExcludeClipRect(dc: QPainterH; Left, Top, Right, Bottom: integer): integer;
var
  tmpRgn, rgn: QRegionH;
  r: TRect;
  org: TPoint;
begin
  assert(QPainter_isActive(dc),'Canvas drawing is not started');
  result:=1;
  r:=Rect(Left, Top, Right, Bottom);

  GetWindowOrgEx(dc, @org);
  if (org.X <> 0) or (org.Y <> 0) then
    OffsetRect(r, -org.X, -org.Y);

  tmpRgn:=QRegion_create(@r, QRegionRegionType_Rectangle);
  if QPainter_hasClipping(dc) then begin
    rgn:=QPainter_clipRegion(dc);
//    if not (QRegion_isEmpty(rgn)) then
      QRegion_subtract(rgn, tmpRgn, tmpRgn)
//    else
//      QRegion_
  end
  else begin
    QPainter_Window(dc, @r);
    rgn := QRegion_create(@r, QRegionRegionType_Rectangle);
    QRegion_subtract(rgn, tmpRgn, tmpRgn);
    QRegion_destroy(rgn);
  end;
  QPainter_setClipRegion(dc, tmpRgn);
  QRegion_destroy(tmpRgn);
end;

function FillRect(hDC: QPainterH; const lprc: TRect; hbr: QBrushH): Integer;
begin
  assert(QPainter_isActive(hDC),'Canvas drawing is not started');
  QPainter_fillRect(hDC, @lprc, hbr);
  result:=1;
end;

function FrameRect(hDC: QPainterH; const lprc: TRect; hbr: QBrushH): Integer;
var
  r: TRect;
begin
  assert(QPainter_isActive(hDC),'Canvas drawing is not started');
  r:=lprc;
  r.Right:=r.Left+1;
  QPainter_fillRect(hDC, @lprc, hbr);
  r:=lprc;
  r.Left:=r.Right-1;
  QPainter_fillRect(hDC, @lprc, hbr);
  r:=lprc;
  r.Bottom:=r.Top+1;
  inc(r.Left);
  dec(r.Right);
  QPainter_fillRect(hDC, @lprc, hbr);
  r:=lprc;
  r.Top:=r.Bottom-1;
  inc(r.Left);
  dec(r.Right);
  QPainter_fillRect(hDC, @lprc, hbr);
  result:=1;
end;

function GetBkColor(hDC: QPainterH): DWORD;
begin
  assert(QPainter_isActive(hDC),'Canvas drawing is not started');
  Result:=QColorColor(QPainter_backgroundColor(hDC));
end;

function GetTextColor(hDC: QPainterH): DWORD;
begin
  assert(QPainter_isActive(hDC),'Canvas drawing is not started');
  Result:=QColorColor(QPen_color(QPainter_pen(hDC)));
end;


function GetClipRgn(dc: QPainterH; RGN: QRegionH): integer;
var
  tmp: QRegionH;
begin
  tmp:=QPainter_clipRegion(dc);
  QRegion_subtract(RGN,RGN,RGN);
  QRegion_unite(tmp, RGN, RGN);
  Result:=1;
end;

function GetWindowOrgEx(dc: QPainterH; Point: PPoint): BOOL;
var
  R: TRect;
begin
  if Point <> nil then begin
    if QPainter_isActive(dc) then
      QPainter_Window(dc, @R)
    else
      FillChar(R, Sizeof(R), 0);
    Point^:=R.TopLeft;
  end;
  Result:=true;
end;

function IntersectClipRect(dc: QPainterH; Left, Top, Right, Bottom: integer): integer;
var
  tmpRgn, rgn: QRegionH;
  r: TRect;
  org: TPoint;
begin
  assert(QPainter_isActive(dc),'Canvas drawing is not started');
  result:=1;
  r:=Rect(Left, Top, Right, Bottom);

  GetWindowOrgEx(dc, @org);
  if (org.X <> 0) or (org.Y <> 0) then
    OffsetRect(r, -org.X, -org.Y);

  tmpRgn:=QRegion_create(@r, QRegionRegionType_Rectangle);
  if QPainter_hasClipping(dc) then begin
    rgn:=QPainter_clipRegion(dc);
    if not (QRegion_isEmpty(rgn)) then
      QRegion_intersect(rgn, tmpRgn, tmpRgn);
  end;
  QPainter_setClipRegion(dc, tmpRgn);
  QRegion_destroy(tmpRgn);
end;

function LPtoDP(dc: QPainterH; var Points; Count: Integer): BOOL;
var
  ppt: PPoint;
  org: TPoint;
  i: integer;
begin
  Result:=true;
  GetWindowOrgEx(dc, @org);
  if (org.X = 0) and (org.Y = 0) then exit;
  ppt:=@Points;
  for i:=0 to Count - 1 do begin
    dec(ppt^.X, org.X);
    dec(ppt^.Y, org.Y);
    inc(integer(ppt), sizeof(TPoint));
  end;
end;

function OffsetRgn(RGN: QRegionH; XOffset, YOffset: Integer): integer;
begin
  QRegion_translate(RGN, XOffset, YOffset);
  Result:=1;
end;

procedure PixBlt(hDestDC: QPainterH; destX, destY, destW, destH: integer; SrcBm: TBitmap; srcX, srcY: integer);
var
  org: TPoint;
begin
  assert(QPainter_isActive(hDestDC),'Canvas drawing is not started');
  GetWindowOrgEx(SrcBm.Canvas.Handle, @org);
  QPainter_drawPixmap(hDestDC, destX, destY,
    SrcBm.Handle, srcX - org.X, srcY - org.Y,  destW, destH);
end;

function ScrollDC(hDC: QPainterH; DX, DY: Integer; var Scroll, Clip: TRect; hrgnUpdate: QRegionH;
  lprcUpdate: PRect): BOOL;
var
  rScroll, rClip, rWnd: TRect;
  Dev: QPaintDeviceH;
  org: TPoint;
  pt: TPoint;
begin
  assert(QPainter_isActive(hDC),'Canvas drawing is not started');
  GetWindowOrgEx(hDC, @org);
  QPainter_Window(hDC, @rWnd);
  if @Scroll = nil then
    rScroll := rWnd
  else begin
    rScroll := Scroll;
    IntersectRect(rScroll, rScroll, rWnd);
  end;
  if @Clip = nil then
    rClip := rWnd
  else begin
    rClip := Clip;
    IntersectRect(rClip, rClip, rWnd);
  end;

  OffsetRect(rScroll, DX, DY);
  IntersectRect(rScroll, rScroll, rClip);
  pt := rScroll.TopLeft;
  OffsetRect(rScroll, -DX, -DY);

  OffsetRect(rScroll, -org.X, -org.Y);
  dec(pt.X, org.X);
  dec(pt.Y, org.Y);

  dec(rScroll.Bottom);
  dec(rScroll.Right);
  if not IsRectEmpty(rSCroll) then begin
    Dev:=QPainter_device(hDC);
    Qt.BitBlt(Dev, @pt, Dev, @rScroll, RasterOp_CopyROP);
  end;
  result:=true;
end;

function SelectClipRgn(dc: QPainterH; RGN: QRegionH): integer;
var
  tmprgn: QRegionH;
  r: TRect;
begin
  if Rgn <> nil then
    QPainter_setClipRegion(dc, Rgn)
  else begin
    if QPainter_hasClipping(dc) then begin
      QPainter_Window(dc, @r);
      tmpRgn:=QRegion_create(@r, QRegionRegionType_Rectangle);
      QPainter_setClipRegion(dc, tmpRgn);
      QRegion_destroy(tmpRgn);
    end;
    QPainter_setClipping(dc, false);
  end;
  Result:=1;
end;

function SetTextColor(hDC: QPainterH; Color: DWORD): DWORD;
var
  QC: QColorH;
begin
  assert(QPainter_isActive(hDC),'Canvas drawing is not started');
  result:=GetTextColor(hDC);
  QC:=QColor(Color);
  QPainter_setPen(hDC, QC);
  QColor_destroy(QC);
end;

function SetBkColor(hDC: QPainterH; Color: DWORD): DWORD;
var
  QC: QColorH;
begin
  assert(QPainter_isActive(hDC),'Canvas drawing is not started');
  result:=GetBkColor(hDC);
  QC:=QColor(Color);
  QPainter_setBackgroundColor(hDC, QC);
  QColor_destroy(QC);
end;

function SetBrushColor(br: QBrushH; Color: DWORD): DWORD;
var
  QC: QColorH;
  rgb: QRgb;
begin
  QC:=QBrush_color(br);
  QColor_rgb(QC, @rgb);
  Result:=Cardinal(rgb);
  QC:=QColor(Color);
  QBrush_setColor(br, QC);
  QColor_destroy(QC);
end;

function SetBrushOrgEx(hDC: QPainterH; nXOrg, nYOrg: integer; ppt: PPoint): BOOL;
begin
  assert(QPainter_isActive(hDC),'Canvas drawing is not started');
  if ppt<>nil then ppt^:=QPainter_BrushOrigin(hDC)^;
  QPainter_setBrushOrigin(hDC, nXOrg, nYOrg);
  result:=true;
end;

function SetWindowOrgEx(dc: QPainterH; X, Y: Integer; Point: PPoint): BOOL;
var
  R: TRect;
begin
  assert(QPainter_isActive(DC),'Canvas drawing is not started');
  QPainter_Window(dc, @R);
  QPainter_setWindow(dc, X, Y, R.Right-R.Left, r.Bottom-r.Top);
  if Point <> nil then Point^:=R.TopLeft;
  Result:=true;
end;

function SubtractRect(var lprcDst: TRect; const lprcSrc1, lprcSrc2: TRect): BOOL;
var
  r, rSrc: TRect;
begin
  Result:=true;
  rSrc:=lprcSrc1;
  lprcDst:=rSrc;
  IntersectRect(r, rSrc, lprcSrc2);
  if (r.Top = rSrc.Top) and (r.Bottom = rSrc.Bottom) then begin
    if r.Right = rSrc.Right then begin
      lprcDst.Right:=r.Left;
      exit;
    end;
    if r.Left = rSrc.Left then begin
      lprcDst.Left:=r.Right;
      exit;
    end;
  end;
  if (r.Left = rSrc.Left) and (r.Right = rSrc.Right) then begin
    if r.Top = rSrc.Top then begin
      lprcDst.Top := r.Bottom;
      exit;
    end;
    if r.Bottom = rSrc.Bottom then begin
      lprcDst.Bottom:=r.Top;
      exit;
    end;
  end;
end;

function MoveToEx(DC: HDC; X, Y: integer; pOldPos: PPoint): BOOL;
begin
  if pOldPos <> nil then
    QPainter_pos(DC, pOldPos);
  QPainter_moveTo(DC, X, Y);
  Result := true;
end;

function LineTo(DC: HDC; X, Y: integer): BOOL;
begin
  QPainter_lineTo(DC, X, Y);
  Result := true;
end;

// Widget related

{$IFDEF LINUX}
function IsPaintOnHandle(display: Xlib.PDisplay; event: PXEvent;
  arg: XPointer): Integer; cdecl;
begin
  Result := Integer(((event^.xtype = Expose) or (event^.xtype = GraphicsExpose))
    and (event^.xexpose.xwindow = Window(arg)));
end;

procedure ForcePaints(Widget: QWidgetH);

  procedure ForcePaintsOn(Display: Xlib.PDisplay; W: Window);
  var
    Event: XEvent;
  begin
    while XCheckIfEvent(Display, @Event, IsPaintOnHandle, XPointer(W)) = XTrue do
      // Have Qt handle the event
      QApplication_x11ProcessEvent(Application.Handle, @Event);
  end;

  procedure ForcePaintsOnWidget(Display: Xlib.PDisplay; W: Window);
  type
    PWindows = ^TWindows;
    TWindows = array[0..255] of Window;
  var
    RootWindow: Window;
    ParentWindow: Window;
    NChildren: Cardinal;
    Children: PWindows;
    I: Integer;
  begin
    ForcePaintsOn(Display, W);
    XQueryTree(Display, W, @RootWindow, @ParentWindow, @Children, @NChildren);
    try
      if NChildren > 0 then
        for I := 0 to NChildren - 1 do
          ForcePaintsOnWidget(Display, Children^[I]);
    finally
      if Children <> nil then
        XFree(Children);
    end;
  end;

begin
  // Extract and send all Expose and GraphicsExpose events in the X queue
  ForcePaintsOnWidget(Xlib.PDisplay(QtDisplay), QWidget_winId(Widget));
  // Tell Qt to send all pending Paint events.
  QApplication_sendPostedEvents(nil, Integer(QEventType_Paint));
end;
{$ELSE}
function UpdateWindow(hWnd: Cardinal): BOOL; stdcall; external 'user32.dll' name 'UpdateWindow';

procedure ForcePaints(Widget: QWidgetH);
begin
  UpdateWindow(QWidget_winId(Widget));
end;
{$ENDIF}

function GetCapture: QWidgetH;
begin
  result:=QWidget_mouseGrabber;
end;

function GetWindowRect(hWnd: QWidgetH; var lpRect: TRect): BOOL;
var
  sz: TSize;
begin
  QWidget_size(hWnd, @sz);
  lpRect:=Rect(0,0,sz.cx,sz.cy);
  QWidget_mapToGlobal(hWnd, @lpRect.TopLeft, @lpRect.TopLeft);
  QWidget_mapToGlobal(hWnd, @lpRect.BottomRight, @lpRect.BottomRight);
  Result:=TRUE;
end;

function InvalidateRect(hWnd: QWidgetH; lpRect: PRect; bErase: BOOL): BOOL;
begin
  if bErase then QWidget_erase(hWnd, lpRect);
  QWidget_update(hWnd, lpRect);
  result:=true;
end;

function MapWindowPoints(hWndFrom, hWndTo: QWidgetH; var lpPoints; cPoints: UInt): integer;
var
  p: PPoint;
  i: integer;
begin
  Result:=cPoints or (cPoints SHL 16);
  if (hWndFrom=nil) and (hWndTo=nil) then exit;
  p:=@lpPoints;
  for i:=0 to cPoints-1 do begin
    if (hWndFrom<>nil) then begin
      QWidget_mapToGlobal(hWndFrom, p, p);
      inc(integer(p), sizeof(TPoint));
    end;
    if (hWndTo<>nil) then begin
      QWidget_mapFromGlobal(hWndTo, p, p);
      inc(integer(p), sizeof(TPoint));
    end;
  end;
end;

function ScrollWindow(hWnd: QWidgetH; XAmount, YAmount: Integer; Rect, ClipRect: PRect): BOOL;
var
  rWnd: TRect;
  rScroll, rClip: TRect;
begin
  Result:=true;
  if (ClipRect = nil) and (Rect = nil) then begin
    QWidget_scroll(hWnd, XAmount, YAmount);
    exit;
  end;

  QWidget_geometry(hWnd, @rWnd);
  OffsetRect(rWnd, -rWnd.Left, -rWnd.Top);

  if Rect = nil then
    rScroll:=rWnd
  else begin
    rScroll:=Rect^;
    IntersectRect(rScroll, rScroll, rWnd);
  end;

  if ClipRect = nil then
    rClip:=rWnd
  else begin
    rClip:=ClipRect^;
    IntersectRect(rClip, rClip, rWnd);
  end;

  IntersectRect(rScroll, rScroll, rClip);

  if not IsRectEmpty(rScroll) then
    QWidget_scroll(hWnd, XAmount, YAmount, @rScroll);
end;

procedure PostMessagePtr(hWnd: QObjectH; Msg: UINT; Ptr: Pointer);
begin
  QApplication_postEvent(hWnd, QCustomEvent_create(QEventType(Msg), Ptr));
end;

// MISC
function GetShiftState: TShiftState;
begin
  if Application<>nil then
    Result:=Application.KeyState
  else
    Result:=[];
end;

procedure GetFontList(L: TStrings; withSizes: boolean);
var
  FontFamilies: QStringListH;
  FontDatabase: QFontDatabaseH;
  FFonts: TStringList;
  i: Integer;
  FontFamily: WideString;
  FontSizes: array[0..30] of Integer;

  function ArrToString: string;
  var
    i: Integer;
  begin
    i:= 0;
    Result := '';
    for i := 0 to 30 do begin
      if FontSizes[i] in [7..30] then begin
        if Result <>'' then
          Result := Result + ',';
        Result := Result + IntToStr(FontSizes[i]);
      end;
    end;
  end;

begin
  FFonts := TStringList.Create;
  try
    FontFamilies := QStringList_create();
    try
      FontDatabase := QFontDatabase_create();
      try
        QFontDatabase_families(FontDatabase, FontFamilies, True);
        FFonts := QStringListToTStringList(FontFamilies);
        for i:= 0 to FFonts.Count -1 do begin
          FontFamily := FFonts[i];
          if
          {$IFDEF KYLIX_2} //Not available in K3 and K1:
          QFontDatabase_isFixedPitch(FontDatabase, @FontFamily, nil, nil) and
          {$ENDIF}
            not QFontDatabase_italic(FontDatabase, @FontFamily, nil, nil) and
            not QFontDatabase_bold(FontDatabase, @FontFamily, nil, nil)
          then begin
            if (FontFamily <> 'clean') and (pos('alias-', FontFamily) <> 1) then begin
              if withSizes then begin
                FillChar(FontSizes, sizeof(FontSizes), #0);
                if QFontDatabase_isBitmapScalable(FontDatabase, @FontFamily, nil, nil) then begin
                  QFontDatabase_smoothSizes(FontDatabase, @FontSizes, @FontFamily, nil, nil);
                  if ArrToString = '' then
                    QFontDatabase_pointSizes(FontDatabase, @FontSizes, @FontFamily, nil, nil);
                end
                else if QFontDatabase_isSmoothlyScalable(FontDatabase, @FontFamily, nil, nil) then begin
                  QFontDatabase_pointSizes(FontDatabase, @FontSizes, @FontFamily, nil, nil);
                end
                else begin
                  QFontDatabase_smoothSizes(FontDatabase, @FontSizes, @FontFamily, nil, nil);
                  if ArrToString = '' then
                    QFontDatabase_pointSizes(FontDatabase, @FontSizes, @FontFamily, nil, nil);
                end;
                L.Add(FontFamily + '=' + ArrToString);
              end
              else begin
                L.Add(FontFamily);
              end;
            end;
          end;
        end;
      finally
        QFontDatabase_destroy(FontDatabase);
      end;
    finally
      QStringList_destroy(FontFamilies);
    end;
  finally
    FFonts.Free;
  end;
end;

function FontIsMonospaced(FontFamily: string; Sz: integer): boolean;
var
  WFontFamily: WideString;

  function MetricsOf(st: integer; var s1, s2, s3: integer): boolean;
  var
    Font: HFont;
    Metrics: QFontMetricsH;
    WS: WideString;
  begin
    Font := QFont_create();
    try
      QFont_setFamily(Font, @WFontFamily);
      QFont_setPointSize(Font, Sz);
      QFont_setBold(Font, (st and 1) <> 0);
      QFont_setItalic(Font, (st and 2) <> 0);
      QFont_setfixedPitch(Font, true);

      Result := QFont_fixedPitch(Font);
      if not Result then begin
        Result := Result;
        exit;
      end;

      Metrics := QFontMetrics_create(Font);
      try
        WS := 'X';
        s1 := QFontMetrics_width(Metrics, @WS, Length(WS));
        WS := 'XX';
        s2 := QFontMetrics_width(Metrics, @WS, Length(WS));
        WS := 'XXX';
        s3 := QFontMetrics_width(Metrics, @WS, Length(WS));
      finally
        QFontMetrics_destroy(Metrics);
      end;
    finally
      QFont_destroy(Font);
    end;
  end;
var
  Metrics: QFontMetricsH;
  norm1, norm2, norm3,
  st1, st2, st3,
  st: integer;
begin
  WFontFamily := FontFamily;
  Result := false;
  if not MetricsOf(0, norm1, norm2, norm3) then exit;
  if (norm3 - norm2) <> (norm2 - norm1) then exit;
  for st := 1 to 3 do begin
    if not MetricsOf(0, st1, st2, st3) then exit;
    if (st1 <> norm1) or (st2 <> norm2) or (st3 <> norm3) then exit;
  end;
  Result := true;
end;

function KeysToShiftState(Keys: Word): TShiftState;
begin
  Result := [];
  if Keys and MK_SHIFT <> 0 then Include(Result, ssShift);
  if Keys and MK_CONTROL <> 0 then Include(Result, ssCtrl);
  if Keys and MK_LBUTTON <> 0 then Include(Result, ssLeft);
  if Keys and MK_RBUTTON <> 0 then Include(Result, ssRight);
  if Keys and MK_MBUTTON <> 0 then Include(Result, ssMiddle);
  if ssAlt in Application.KeyState  then Include(Result, ssAlt);
end;

procedure LoadBitmap(Bitmap: TBitmap; Instance: Cardinal; const ResName: PChar);
begin
  Bitmap.FreeImage;
  Bitmap.FreePixmap;
{$IFDEF KYLIX_3_UP}    //theo
  Bitmap.LoadFromResourceName(Instance, ResName);
{$ELSE}
  THACKBitmap(Bitmap).FImage:=ImageFromResource(Instance, ResName);
{$ENDIF}
end;

function PointToSmallPoint(const P: TPoint): TSmallPoint;
begin
  Result.X:=P.x;
  Result.Y:=P.y;
end;

function QEventType_Keys(Event: QEventH): integer;
var
  state: QT.ButtonState;
begin
  Result:=0;
  case QEvent_type(Event) of
    QEventType_MouseButtonPress, QEventType_MouseButtonRelease,
    QEventType_MouseButtonDblClick, QEventType_MouseMove:
      state:=QMouseEvent_state(QMouseEventH(Event));
    QEventType_Wheel:
      state:=QWheelEvent_state(QWheelEventH(Event));
  else
    exit;
  end;
  if (integer(state) and integer(ButtonState_LeftButton)) <> 0 then
    Result:=Result or MK_LBUTTON;
  if (integer(state) and integer(ButtonState_RightButton)) <> 0 then
    Result:=Result or MK_RBUTTON;
  if (integer(state) and integer(ButtonState_MidButton)) <> 0 then
    Result:=Result or MK_MBUTTON;
  if (integer(state) and integer(ButtonState_ShiftButton)) <> 0 then
    Result:=Result or MK_SHIFT;
  if (integer(state) and integer(ButtonState_ControlButton)) <> 0 then
    Result:=Result or MK_CONTROL;
end;

function QEventType_Msg(IsInClient: boolean; Event: QEventH): integer;
var
  button: QT.ButtonState;
begin
  Result:=0;
  case QEvent_type(Event) of
    QEventType_MouseButtonPress,
    QEventType_MouseButtonRelease,
    QEventType_MouseButtonDblClick:;

    QEventType_MouseMove: begin
      if IsInClient then
        Result:=WM_MOUSEMOVE
      else
        Result:=WM_NCMOUSEMOVE;
      exit;
    end;
    QEventType_Wheel: begin
      if IsInClient then
        Result:=WM_MOUSEWHEEL;
      exit;
    end;
  else
    exit;
  end;
  button:=QMouseEvent_button(QMouseEventH(Event));
  case button of
    ButtonState_LeftButton:
      Result:=WM_LBUTTONDOWN;
    ButtonState_RightButton:
      Result:=WM_RBUTTONDOWN;
    ButtonState_MidButton:
      Result:=WM_MBUTTONDOWN;
  else
    exit;
  end;
  if not IsInClient then
    inc(Result, WM_NCMOUSEMOVE - WM_MOUSEMOVE);
  case (QEvent_type(Event)) of
    QEventType_MouseButtonRelease:
      inc(Result);
    QEventType_MouseButtonDblClick:
      inc(Result,2);
  else
    exit;
  end;
end;

function SmallPointToPoint(const P: TSmallPoint): TPoint;
begin
  Result.X:=P.x;
  Result.Y:=P.y;
end;

procedure ZeroMemory(Destination: Pointer; Length: DWORD);
begin
  FillChar(Destination^, Length, 0);
end;

{$ENDIF}

function CodeInArray(Code: Word; Codes: array of Word): boolean;
var
  i: integer;
begin
  Result:=true;
  for i:=Low(Codes) to High(Codes) do if Code = Codes[i] then exit;
  Result:=false;
end;

function HasMMX: Boolean;
asm
        PUSH    EBX
        XOR     EAX, EAX
        PUSHFD
        POP     EDX
        MOV     ECX, EDX
        XOR     EDX, $200000
        PUSH    EDX
        POPFD
        PUSHFD
        POP     EDX
        XOR     ECX, EDX
        JZ      @1
        PUSH    EDX
        POPFD

        MOV     EAX, 1
        DW      $A20F
        MOV     EBX, EAX
        XOR     EAX, EAX
        CMP     EBX, $50
        JB      @1
        TEST    EDX, $800000
        JZ      @1
        INC     EAX
@1:
        POP     EBX
end;

procedure InitGlobals;
begin
{$IFNDEF QT_CLX}
  IsWin2K := ((Win32Platform and VER_PLATFORM_WIN32_NT) <> 0) and
              (Win32MajorVersion > 4);
  IsWinXP := ((Win32Platform and VER_PLATFORM_WIN32_NT) <> 0) and
              (Win32MajorVersion >= 5) and
              (Win32MinorVersion >= 1);
{$ENDIF}
  MMXAvailable := HasMMX;
  Watcher := TCriticalSection.Create;
  GradBuffer := TBitmap.Create;
  GradBuffer.PixelFormat:=pf32bit;
  EdgSavBrush:=TBrush.Create;
  HoverImg:=TImageList.CreateSize(16, 3);
  ConvertImageList(HoverImg, 'DM_HOVER');
end;

procedure FinalizeGlobals;
begin
  HoverImg.Free;
  EdgSavBrush.Free;
  GradBuffer.Free;
  Watcher.Free;
end;

initialization
  InitGlobals;
finalization
  FinalizeGlobals;
end.
