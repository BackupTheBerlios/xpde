unit DmHint;

// Version 1.2.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The original code is DmHint.pas, released February 28, 2002.
//
// Written by Dmitri Dmitrienko <dd@cron.ru http://dd.cron.ru>
// (C) 2002-2003 Dmitri Dmitrienko . All Rights Reserved.
//----------------------------------------------------------------------------------------------------------------------
//
// FEB-2002 Initial release
//

interface

{$I Compilers.inc}

uses
  SysUtils, Classes,
{$IFDEF QT_CLX}
  Qt, QTypes, Types, QGraphics, QControls, QForms, QExtCtrls,
{$ELSE}
  Messages, Controls, Windows, Graphics, Forms, Types,
{$ENDIF}
{$IFNDEF LINUX}
  MMSystem,
{$ENDIF}
  Math, DmGraphics;

type
  THintAnimationType = (
    hatNone,
    hatFade,
    hatSlide,
    hatSystemDefault
  );

type
{$IFDEF QT_CLX}
  HintStr = WideString;
{$ELSE}
  HintStr = string;
{$ENDIF}

  PDmHintData = ^TDmHintData;
  TDmHintData = record
    HintText: WideString;
    HintSize: TPoint;
    HintFont: TFont;
    TextMargin: integer;
    BidiMode: TBidiMode;
    Alignment: TAlignment;
  end;

  TDmHintWindow = class(THintWindow)
  private
    FHintData: TDmHintData;
    FBackBuffer,
    FFrontBuffer,
    FMixedBuffer: TBitmap;
    FInAnimation: boolean;
    FTrappedOverrun: boolean;
    FActivateAt: TPoint;
    FLastActive: Cardinal;
    FAnimationType: THintAnimationType;
    FAnimationEnabled: boolean;
    FStep: Integer;
    FStepSize: Integer;
    FXpShadowed: boolean;
    function AnimationCallback(Step, StepSize: Integer; Data: Pointer): Boolean;
    procedure DoActivate(Sender: TObject);
  protected

{$IFDEF QT_CLX}
{$IFDEF LINUX}
    FAppHook: QObject_hookH;
{$ENDIF}
    FShowing: boolean;
    FLastActiveWidget: QWidgetH;
    procedure InitWidget; override;
    procedure WidgetDestroyed; override;
    procedure TextChanged; override;
    function EventFilter(Sender: QObjectH; Event: QEventH): Boolean; override;
{$IFDEF LINUX}
    function AppEventFilter(Sender: QObjectH; Event: QEventH): Boolean; cdecl;
{$ENDIF}
    function WidgetFlags: Integer; override;
{$ELSE}
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMShowWindow(var Message: TMessage); message WM_SHOWWINDOW;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
{$ENDIF}
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ActivateHint(Rect: TRect; const AHint: HintStr); override;
    function CalcHintRect(MaxWidth: Integer; const AHint: HintStr; AData: Pointer): TRect; override;
{$IFNDEF QT_CLX}
    function IsHintMsg(var Msg: TMsg): Boolean; override;
{$ENDIF}
{$IFDEF QT_CLX}
    function CanFocus: Boolean; override;
{$ENDIF}
    property AnimationType: THintAnimationType read FAnimationType write FAnimationType;
  end;

function GetAnimationType: THintAnimationType;
procedure InstallDmHintWindow(AnAnimation: THintAnimationType = hatSystemDefault;
  HintShadow: boolean = true);
procedure UninstallDmHintWindow;

var
  HintWindowDestroyed: Boolean = true;

implementation

const
  SPI_GETTOOLTIPANIMATION = $1016;
  SPI_GETTOOLTIPFADE = $1018;
  ShadowSize = 4;
  HintAnimationDuration = 128;
  FadeAnimationStepCount = 16;
{$IF DEFINED(VER140) AND DEFINED(MSWINDOWS)}
  CS_DROPSHADOW = $20000;
{$IFEND}

var
  MakeHintShadow: boolean = false;
  Animation: THintAnimationType = hatSystemDefault;

function GetAnimationType: THintAnimationType;
{$IFNDEF QT_CLX}
var
  BAnimation: BOOL;
{$ENDIF}
begin
  Result := Animation;
  if Result <> hatSystemDefault then exit;
  Result := hatNone;
{$IFDEF QT_CLX}
  if QApplication_isEffectEnabled(UIEffect_UI_FadeTooltip) then
    Result:=hatFade
  else if QApplication_isEffectEnabled(UIEffect_UI_AnimateTooltip) then
    Result:=hatSlide;
{$ELSE}
  SystemParametersInfo(SPI_GETTOOLTIPANIMATION, 0, @BAnimation, 0);
  if BAnimation then begin
    SystemParametersInfo(SPI_GETTOOLTIPFADE, 0, @BAnimation, 0);
    if BAnimation then
      Result := hatFade
    else
      Result := hatSlide;
  end;
{$ENDIF}
  if not MMXAvailable and (Result = hatFade) then
    Result := hatSlide;
end;


// TDmHintWindow

constructor TDmHintWindow.Create(AOwner: TComponent);
begin
  inherited;
  FBackBuffer := TBitmap.Create;
  FBackBuffer.PixelFormat := pf32Bit;
  FFrontBuffer := TBitmap.Create;
  FFrontBuffer.PixelFormat := pf32Bit;
  FMixedBuffer := TBitmap.Create;
  FMixedBuffer.PixelFormat := pf32Bit;
{$IFNDEF QT_CLX}
  DoubleBuffered := False;
{$ENDIF}
  HintWindowDestroyed := False;
  FAnimationEnabled := True;
end;

destructor TDmHintWindow.Destroy;
begin
  HintWindowDestroyed := True;
  FMixedBuffer.Free;
  FFrontBuffer.Free;
  FBackBuffer.Free;
  inherited;
end;

function TDmHintWindow.AnimationCallback(Step, StepSize: Integer; Data: Pointer): Boolean;
begin
  Result :=
    not FTrappedOverrun and
    not HintWindowDestroyed and
{$IFDEF QT_CLX}
    HandleAllocated and
    Visible;
{$ELSE}
    IsWindowVisible(Handle);
{$ENDIF}
  if Result then begin
    if FAnimationType<>hatNone then begin
      FStep:=Step;
      FStepSize:=StepSize;
    end else begin
      FStep:=0;
      FStepSize:=0;
    end;
    Repaint;
  end;
end;

procedure TDmHintWindow.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
// Do nothing
end;

procedure TDmHintWindow.Paint;
var
  R,R2: TRect;
  Y, W, H: Integer;
  DrawFormat: Cardinal;
  Shadow: Integer;
  HStep: Integer;
begin
{$IFDEF QT_CLX}
  Canvas.Start(); try
{$ENDIF}
  if MakeHintShadow and not FXpShadowed then
    Shadow := ShadowSize
  else
    Shadow := 0;

  if FStep = -1 then begin // restore
    R:=Rect(0, 0, Width, Height);
    Canvas.CopyRect(R, FBackBuffer.Canvas, R);
    exit;
  end;

  W:=Width;
  H:=Height;
  if FStep = 0 then begin
    with FHintData do begin
      R := Rect(0, 0, W, H);
      FFrontBuffer.Canvas.CopyRect(R, FBackBuffer.Canvas, R);

      if Assigned(HintFont) then
        FFrontBuffer.Canvas.Font:=HintFont
      else
        FFrontBuffer.Canvas.Font:=Screen.HintFont;
      Y := 2;
      R := Rect(0, 0, W - Shadow, H - Shadow);

      FFrontBuffer.Canvas.Brush.Color := clInfoBk;
      DrawEdge(FFrontBuffer.Canvas, R, BDR_RAISEDOUTER, BF_RECT or {BF_MIDDLE or }BF_ADJUST);
      FFrontBuffer.Canvas.FillRect(R);

      if TextMargin > 0 then
        InflateRect(R, -TextMargin, 0)
      else
        InflateRect(R, -4, 0);
      if BidiMode <> bdLeftToRight then
      begin
        DrawFormat := DT_TOP or DT_RIGHT or
{$IFNDEF QT_CLX}
          DT_RTLREADING or
{$ENDIF}
          DT_END_ELLIPSIS;
        Inc(R.Right);
      end
      else
        DrawFormat := DT_TOP or DT_LEFT or DT_END_ELLIPSIS;
{$IFDEF QT_CLX}
      SetBkMode(FFrontBuffer.Canvas, DmGraphics.TRANSPARENT);
{$ELSE}
      SetBkMode(FFrontBuffer.Canvas, Windows.TRANSPARENT);
{$ENDIF}
      R.Top := Y;
      DrawTextExW(FFrontBuffer.Canvas, HintText, Length(HintText), R, DrawFormat, nil{, False});
    end;
  end;

  R:=Rect(0, 0, W, H);
  FMixedBuffer.Canvas.CopyRect(R, FBackBuffer.Canvas, R);
  if (FStepSize > 0) and (FAnimationType<>hatNone) then begin
    if FAnimationType = hatFade then begin
      AlphaBlend(FFrontBuffer, FMixedBuffer,
        Rect(0, 0, W - Shadow, H - Shadow), Point(0, 0),
        bmConstantAlpha,  MulDiv(FStep, 256, FadeAnimationStepCount), 0);
      HStep:=H-Shadow;
    end
    else begin
      HStep:=Min(H - Shadow, FStep);
      R:=Rect(0, 0, W - Shadow, HStep);
      R2:=Rect(0, H  - Shadow - HStep, W - Shadow, H - Shadow);
      FMixedBuffer.Canvas.CopyRect(R, FFrontBuffer.Canvas, R2);
    end;
    R:=Rect(0, 0, W, HStep+Shadow);
    if (Shadow > 0) then
      DrawWindowShadow(FMixedBuffer, R, Shadow);
    Canvas.CopyMode:=cmSrcCopy;
    R:=Rect(0, 0, W, H);
    Canvas.CopyRect(R, FMixedBuffer.Canvas, R)
  end
  else begin // FStepSize=0 or FAnimationType==none
    if Shadow > 0 then begin
      R:=Rect(0, 0, W - Shadow, H - Shadow);
      FMixedBuffer.Canvas.CopyRect(R, FFrontBuffer.Canvas, R);
      DrawWindowShadow(FMixedBuffer, Rect(0, 0, W, H), Shadow);
      R:=Rect(0, 0, W, H);
      Canvas.CopyRect(R, FMixedBuffer.Canvas, R);
    end
    else begin
      R:=Rect(0, 0, W, H);
      Canvas.CopyRect(R, FFrontBuffer.Canvas, R);
    end;
  end;
{$IFDEF QT_CLX}
  finally
    QPainter_flush(Canvas.Handle);
    Canvas.Stop();
  end;
{$ENDIF}
end;

{$IFDEF QT_CLX}
function TDmHintWindow.WidgetFlags: Integer;
begin
  result:=inherited WidgetFlags() or
    integer(WidgetFlags_WResizeNoErase) or
    integer(WidgetFlags_WRepaintNoErase) or
    integer(WidgetFlags_WType_TopLevel) or
    integer(WidgetFlags_WStyle_Customize) or
    $8000000;
end;

function TDmHintWindow.EventFilter(Sender: QObjectH; Event: QEventH): Boolean;
const
  CM_PUTACTIVEBACK = ord(QEventType_ClxUser)+1;

  procedure BypassMouseEvent(Event: QMouseEventH);
  var
    ev: QMouseEventH;
    pt, gpt: TPoint;
    target: QWidgetH;
  begin
    pt := QMouseEvent_pos(Event)^;
    gpt := QMouseEvent_globalPos(Event)^;
    QWidget_mapToGlobal(FHandle, @pt, @pt); // converted to global pt may differ from gpt.
                                            // look at Qt sources
    Application.CancelHint;
    QWidget_hide(FHandle);
    target := QApplication_widgetAt(@gpt, True);
    if not Assigned(target) or (target = FHandle) then exit;
    QWidget_mapFromGlobal(target, @pt, @pt);
    ev:=QMouseEvent_create(QEvent_type(Event), @pt, @gpt,
      integer(QMouseEvent_button(Event)), integer(QMouseEvent_state(Event)));
    QApplication_postEvent(target,ev);
  end;
  procedure BypassWheelEvent(Event: QWheelEventH);
  var
    ev: QWheelEventH;
    pt, gpt: TPoint;
    target: QWidgetH;
  begin
    pt := QWheelEvent_pos(Event)^;
    gpt := QWheelEvent_globalPos(Event)^;

    Application.CancelHint;
    QWidget_hide(FHandle);
    target := QApplication_widgetAt(@gpt, True);
    QWheelEvent_accept(Event);
    if not Assigned(target) or (target = FHandle) then exit;
    ev := QWheelEvent_create(@pt, @gpt, QWheelEvent_delta(Event),
      integer(QWheelEvent_state(Event)));
    QApplication_postEvent(target,ev);
  end;
begin
  case QEvent_type(Event) of
    QEventType_Wheel: begin
      BypassWheelEvent(QWheelEventH(Event));
      result:=true;
      exit;
    end;
    QEventType_MouseButtonPress,
    QEventType_MouseButtonRelease,
    QEventType_MouseButtonDblClick: begin
      BypassMouseEvent(QMouseEventH(Event));
      result:=true;
      exit;
    end;
    QEventType_MouseMove: begin
      result:=true;
      exit;
    end;
{$IFNDEF LINUX}
    QEventType_FocusIn,
    QEventType_WindowActivate: begin
      QApplication_postEvent(FHandle, QEvent_create(CM_PUTACTIVEBACK));
    end;
    CM_PUTACTIVEBACK: begin
      Application.CancelHint;
      QWidget_hide(FHandle);
      if Assigned(FLastActiveWidget) and QObject_isWidgetType(FLastActiveWidget) then
        QWidget_setActiveWindow(FLastActiveWidget);
      FLastActiveWidget:=nil;
      result:=true;
      exit;
    end;
{$ENDIF}
    QEventType_Hide: begin
      FShowing:=false;
    end;
    QEventType_Show: begin
      FLastActiveWidget:=QApplication_activeWindow(Application.Handle);
      FShowing:=true;
    end;
  end;
  result := inherited EventFilter(Sender, Event);
  case QEvent_type(Event) of
    QEventType_Show,
    QEventType_Hide: begin
      FLastActive := timeGetTime;
      if QEvent_type(Event) = QEventType_Hide then // hide
        FAnimationEnabled := True;
    end;
  end;
end;

{$IFDEF LINUX}
function TDmHintWindow.AppEventFilter(Sender: QObjectH; Event: QEventH): Boolean;
var
  target: QWidgetH;
begin
  result:=false;
  if not FShowing then exit;
  case QEvent_type(Event) of
    QEventType_MouseMove: begin
      target:=QApplication_widgetAt(QMouseEvent_globalPos(QMouseEventH(Event)), True);
      if target = FHandle then
        result:=true;
    end;
    QEventType_FocusIn,
    QEventType_MouseButtonPress,
    QEventType_MouseButtonRelease,
    QEventType_MouseButtonDblClick: begin
      Application.CancelHint;
      QWidget_hide(FHandle);
    end;
  end;
end;
{$ENDIF}

{$ELSE}
procedure TDmHintWindow.WMShowWindow(var Message: TMessage);
begin
  inherited;
  FLastActive := GetTickCount;
  if Message.wParam=0 then // hide
    FAnimationEnabled := True;
end;

procedure TDmHintWindow.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TDmHintWindow.WMNCPaint(var Message: TMessage);
begin
  Message.Result := 0;
end;
{$ENDIF}

{$IFDEF QT_CLX}
procedure TDmHintWindow.InitWidget;
{$IFDEF LINUX}
var
  Method: TMethod;
{$ENDIF}
begin
  inherited;
  QWidget_setMouseTracking(FHandle, True);
  QWidget_setAcceptDrops(FHandle, False);
  QWidget_setBackgroundMode(FHandle, QWidgetBackgroundMode_NoBackground);
{$IFDEF LINUX}
  FAppHook := QObject_hook_create(Application.Handle);
  TEventFilterMethod(Method) := AppEventFilter;
  Qt_hook_hook_events(FAppHook, Method);
{$ENDIF}
end;


procedure TDmHintWindow.WidgetDestroyed;
begin
{$IFDEF LINUX}
  if Assigned(FAppHook) then
    QObject_hook_destroy(FAppHook);
{$ENDIF}
  inherited;
end;

{$ENDIF}

{$IFDEF QT_CLX}
function TDmHintWindow.CanFocus: Boolean;
begin
  Result:=false;
end;
{$ENDIF}


{$IFDEF QT_CLX}
procedure TDmHintWindow.TextChanged;
begin
end;
{$ELSE}
procedure TDmHintWindow.CMTextChanged(var Message: TMessage);
begin
end;
{$ENDIF}

{$IFNDEF QT_CLX}
procedure TDmHintWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP;
    ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    if IsWinXP then begin
      WindowClass.Style := WindowClass.style or CS_DROPSHADOW;
      FXpShadowed:=true;
    end;
  end;
end;
{$ENDIF}

procedure TDmHintWindow.ActivateHint(Rect: TRect; const AHint: HintStr);
var
{$IFNDEF QT_CLX}
  DC: HDC;
{$ENDIF}
  W,H: integer;
  R: TRect;
begin
{$IFDEF QT_CLX}
  FShowing:=true;
{$ENDIF}
  if FAnimationType = hatSystemDefault then
    FAnimationType:=GetAnimationType;

  if not FAnimationEnabled or
    FInAnimation or
    (timeGetTime - FLastActive < 500) or
    ((Rect.Right - Rect.Left)*(Rect.Bottom - Rect.Top) > 12000)
  then begin
    FAnimationType:=hatNone;
  end;

  FAnimationEnabled := False;

{$IFDEF QT_CLX}
  R:=Types.Rect(0, 0, Screen.Width, Screen.Height);
{$ELSE}
  R:=Screen.DesktopRect;
{$ENDIF}

  if (Rect.Right - Rect.Left) > (R.Right - R.Left - 50) then
    Rect.Right:=Rect.Left + (R.Right - R.Left - 50);
  if (Rect.Bottom - Rect.Top) > (R.Bottom - R.Top - 50) then
    Rect.Bottom:=Rect.Top + (R.Bottom - R.Top - 50);

  if Rect.Bottom > R.Bottom then
    OffsetRect(Rect, 0, -(Rect.Bottom - R.Bottom));
  if Rect.Top < R.Top then
    OffsetRect(Rect, 0, (R.Top - Rect.Top));

  if Rect.Right > R.Right then
    OffsetRect(Rect, -(Rect.Right - R.Right), 0);
  if Rect.Left < R.Left then
    OffsetRect(Rect, (R.Left - Rect.Left), 0);

  R:=BoundsRect;

  W:=Rect.Right - Rect.Left;
  H:=Rect.Bottom - Rect.Top;


// In order to get right animation/fading/shading etc., we've to get underneath surface updated
  if (FBackBuffer.Width = Width) and (FBackBuffer.Height = Height) then begin
    FStep:=-1;
    Repaint;
  end;
{$IFDEF QT_CLX}
  QWidget_hide(Handle);
  SetBounds(Rect.Left, Rect.Top, W, H);
{$ELSE}
  SetWindowPos(Handle, 0, Rect.Left, Rect.Top, W, H, SWP_HIDEWINDOW or SWP_NOACTIVATE or SWP_NOZORDER);
  DC:=GetDC(0);
  UpdateWindow(WindowFromDC(DC));
  ReleaseDC(0, DC);
{$ENDIF}
  if Assigned(Screen.ActiveForm) then Screen.ActiveForm.Update;

  FBackBuffer.Width := W;
  FBackBuffer.Height := H;

// Grab underlying picture
{$IFDEF QT_CLX}
  FBackBuffer.FreeImage;
  FBackBuffer.FreePixmap;
//  FBackBuffer.Canvas.FillRect(Types.Rect(0,0,Width,Height));
  QPixmap_grabWindow(FBackBuffer.Handle, QWidget_winID(QApplication_desktop()), Rect.Left, Rect.Top, Width, Height);
{$ELSE}
  DC := GetDC(0);
  try
    BitBlt(FBackBuffer.Canvas.Handle, 0, 0, Width, Height, DC, Left, Top, SRCCOPY);
  finally
    ReleaseDC(0, DC);
  end;
{$ENDIF}

  FActivateAt:=Rect.TopLeft;

  if not FInAnimation then begin
    DoActivate(nil);
  end
  else begin
    FTrappedOverrun:=true;
  end;
end;

procedure TDmHintWindow.DoActivate(Sender: TObject);
  procedure ResizeBm(Bm: TBitmap; newW,newH: integer);
  begin
    if (Bm.Width <> newW) or (Bm.Height <> newH) then begin
      Bm.FreeImage;
{$IFDEF QT_CLX}
      Bm.FreePixmap;
{$ENDIF}
      Bm.Width:=newW;
      Bm.Height:=newH;
    end;
  end;
begin
  FStep:=0;
  FStepSize:=0;

  ResizeBm(FFrontBuffer, Width, Height);
  ResizeBm(FMixedBuffer, Width, Height);

{$IFDEF QT_CLX}
  QWidget_setBackgroundMode(Handle, QWidgetBackgroundMode_NoBackground);
  QWidget_show(Handle);
  QWidget_raise(Handle);
{$ELSE}
  SetWindowPos(Handle, HWND_TOPMOST, FActivateAt.X, FActivateAt.Y, Width, Height, SWP_SHOWWINDOW or SWP_NOACTIVATE);
{$ENDIF}
  FInAnimation:=true;
  try
    if not FTrappedOverrun
    then begin
      case FAnimationType of
        hatFade: begin
          Animate(FadeAnimationStepCount, 2 * HintAnimationDuration, AnimationCallback, nil);
        end;
        hatSlide: begin
          Animate(Self.Height, HintAnimationDuration, AnimationCallback, nil);
        end;
      end;
    end
    else begin
      FAnimationType:=hatNone;
      Update;
    end;
    if FTrappedOverrun then begin
      FTrappedOverrun:=false;
      DoActivate(nil);
    end;
  finally
    FInAnimation:=false;
    FLastActive := timeGetTime;
  end;
end;

function TDmHintWindow.CalcHintRect(MaxWidth: Integer; const AHint: HintStr; AData: Pointer): TRect;
var
  TextHeight: Integer;
begin
  if Assigned(AData) then begin
{$IFNDEF QT_CLX}
    BidiMode := bdLeftToRight;
{$ENDIF}
    FHintData := PDmHintData(AData)^
  end
  else with FHintData do begin
    HintText:= AHint;
    HintSize:=Point(0,0);
    HintFont:=nil;
    TextMargin:=4;
{$IFNDEF QT_CLX}
    BidiMode:=Self.BiDiMode;
{$ENDIF}
    Alignment:=taLeftJustify;
  end;

  with FHintData do begin
{$IFNDEF QT_CLX}
    if BidiMode <> bdLeftToRight then
      ChangeBidiModeAlignment(Alignment);
{$ENDIF}

    if Assigned(HintFont) then
      Canvas.Font:=HintFont
    else
      Canvas.Font:=Screen.HintFont;

    TextHeight := Canvas.TextHeight('X');

    if HintText = '' then
      Result := Rect(0, 0, 0, 0)
    else if (HintSize.X > 0) and (HintSize.Y > 0)
    then begin
      Result:=Rect(0,0,HintSize.X, HintSize.Y)
    end
    else begin
      Result := Rect(0, 0, MaxWidth, TextHeight);
      DrawTextExW(Canvas, PWideChar(HintText), Length(HintText), Result, DT_CALCRECT{, True},nil);
      if TextMargin > 0 then
        InflateRect(Result, TextMargin + 1, 2)
      else
        InflateRect(Result, 4 + 1, 2);
      OffsetRect(Result, -Result.Left, -Result.Top);
    end;
  end;
  if (Result.Right > Result.Left) and (Result.Bottom > Result.Top) and MakeHintShadow and not FXpShadowed then
  begin
    Inc(Result.Right, ShadowSize);
    Inc(Result.Bottom, ShadowSize);
  end;
end;

{$IFNDEF QT_CLX}
function TDmHintWindow.IsHintMsg(var Msg: TMsg): Boolean;
begin
  Result := inherited IsHintMsg(Msg) and HandleAllocated and IsWindowVisible(Handle);
  if Result and (Msg.Message = WM_NCMOUSEMOVE) then
    Result := False;
end;
{$ENDIF}

procedure InstallDmHintWindow(AnAnimation: THintAnimationType = hatSystemDefault;
  HintShadow: boolean = true);
begin
  HintWindowClass:=TDmHintWindow;
  Animation:=AnAnimation;
  MakeHintShadow := HintShadow and MMXAvailable;
end;

procedure UninstallDmHintWindow;
begin
  HintWindowClass:=THintWindow;
end;

initialization
  MakeHintShadow := MMXAvailable;
finalization
end.

