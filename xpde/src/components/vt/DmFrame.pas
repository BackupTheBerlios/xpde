unit DmFrame;

// Version 1.0.2
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The original code is DmFrame.pas, released February 28, 2002.
//
// Written by Dmitri Dmitrienko <dd@cron.ru http://dd.cron.ru>
// (C) 2002-2003 Dmitri Dmitrienko . All Rights Reserved.
//----------------------------------------------------------------------------------------------------------------------
//
// FEB-2002 1.0.0 Initial release
// APR-2002 1.0.1 Drag-n-drop support added
// JUN-2002 1.0.2 Design-time changing of bevel's properties doesn't refresh. Fixed.


interface
{$I Compilers.inc}

uses
  Qt, QControls, QForms, QGraphics, QStdCtrls, DmGraphics, Classes, Types, Math;

{$IFNDEF QT_CLX}
{$MESSAGE FATAL 'THIS UNIT CAN BE USED WITH CLX/Qt library only.'}
{$ENDIF}

type
  TBevelCut = (bvNone, bvLowered, bvRaised, bvSpace);
  TBevelEdge = (beLeft, beTop, beRight, beBottom);
  TBevelEdges = set of TBevelEdge;
  TBevelKind = (bkNone, bkTile, bkSoft, bkFlat);

  TCustomDmControl = class(TWidgetControl)
  private
    FCanvas: TCanvas;
    FBevelEdges: TBevelEdges;
    FBevelInner: TBevelCut;
    FBevelOuter: TBevelCut;
    FBevelKind: TBevelKind;
    FCtl3D: boolean;
    FLeftMargin: integer;
    FTopMargin: integer;
    FRightMargin: integer;
    FBottomMargin: integer;

    FNCPainting: boolean;
    FReturnNCHandler: boolean;

    FClientHandle: QWidgetH;
    FClientHook: QWidget_HookH;

    procedure SetBevelEdges(const Value: TBevelEdges);
    procedure SetBevelKind(const Value: TBevelKind);
    procedure SetBevelInner(Value: TBevelCut);
    procedure SetBevelOuter(Value: TBevelCut);
    procedure SetCtl3D(Value: boolean);
    procedure UpdateClientBounds(NewSize: TPoint);
    function ClientEventFilter(Sender: QObjectH; Event: QEventH): Boolean; cdecl;
    function ContentRect: TRect;
  protected
    procedure CreateWidget; override;
    procedure InitWidget; override;
    procedure WidgetDestroyed; override;
    procedure HookEvents; override;
    function GetPaintDevice: QPaintDeviceH; override;
    function GetChildHandle: QWidgetH; override;
    procedure BorderChanged; virtual;
    procedure ClientResized; virtual;
    procedure ColorChanged; override;
    procedure DragCanceled; override;
    procedure DragOver(Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean); override;
    procedure GetClientMargins(var Left,Top,Right,Bottom: integer); virtual;
    procedure SetClientMargins(Left,Top,Right,Bottom: integer); virtual;
    procedure BorderMargins(var L,T,R,B: integer);
    function EventFilter(Sender: QObjectH; Event: QEventH): Boolean; override;

    function WidgetFlags: Integer; override;
    procedure AdjustPainter(Painter: QPainterH); override;
    procedure Painting(Sender: QObjectH; EventRegion: QRegionH); override;


    function IsControlMouseMsg(var Message: TWMMouse): Boolean;
    procedure WndProc(var Message: TMessage); virtual;
    procedure CMDrag(var Message: TCMDrag);  message CM_DRAG;

    procedure NCPaint; dynamic;
    procedure Paint; dynamic;
    procedure PaintBorder(erase: boolean); virtual;

    function GetClientOrigin: TPoint; override;
    function GetClientRect: TRect; override;
    function CalcContentRect(NewSize: TPoint): TRect; virtual;
    property Canvas: TCanvas read FCanvas;
    property ClientHandle: QWidgetH read FClientHandle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DragDrop(Source: TObject; X, Y: Integer); override;

    procedure InvalidateRect(Rect: TRect; EraseBackground: Boolean); reintroduce;
    procedure InvalidateNCRect(Rect: TRect; EraseBackground: Boolean);
    procedure Invalidate; override; //reintroduce;
    procedure Update; override;
    
    function Focused: Boolean; override;
    procedure LockUpdates(doLock: boolean);
    property BevelEdges: TBevelEdges read FBevelEdges write SetBevelEdges default [beLeft, beTop, beRight, beBottom];
    property BevelInner: TBevelCut read FBevelInner write SetBevelInner default bvNone;
    property BevelOuter: TBevelCut read FBevelOuter write SetBevelOuter default bvLowered;
    property BevelKind: TBevelKind read FBevelKind write SetBevelKind default bkTile;
    property Ctl3D: boolean read FCtl3D write SetCtl3D default true;
  end;

  TDmControl = class(TCustomDmControl)
  public
    property Canvas;
  published
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property Ctl3D;
    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property DragMode;
    property Enabled;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property TabOrder;
    property TabStop default true;
    property Visible;

    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;

    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyString;
    property OnKeyUp;
  end;

  TDmFrameScrollBar = class(TScrollBar)
  private
    function GetVisible: boolean;
    procedure SetVisible(Value: boolean);
  protected
    procedure InitWidget; override;
    function EventFilter(Sender: QObjectH; Event: QEventH): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CanFocus: Boolean; override;
    property Visible: boolean read GetVisible write SetVisible;
  end;

  TCustomDmScrollView = class(TCustomDmControl)
  private
    FSbUpdateCnt: integer;
    FLastBorder: TRect;
    FScrollStyle: TScrollStyle;
    FHScrollBar,
    FVScrollBar: TDmFrameScrollBar;
    procedure SetScrollStyle(Value: TScrollStyle);
    procedure ScrollEvent(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
  protected
    procedure InitWidget; override;
    procedure Loaded; override;
    procedure BorderChanged; override;
    procedure ClientResized; override;
    procedure UpdateScrollBarsVisibility; virtual;
    procedure ScrollContent(What: TScrollBarKind; ScrollCode: TScrollCode; Pos: Cardinal); virtual;
    procedure SetScrollInfo(What: TScrollBarKind; aMin,aMax,aLine,aPage,aPos: integer);
    function GetScrollPos(What: TScrollBarKind): integer;
    procedure SetScrollPos(What: TScrollBarKind; Pos: integer);
  public
    constructor Create(AOwner: TComponent); override;
    property ScrollStyle: TScrollStyle read FScrollStyle write SetScrollStyle default ssBoth;
  end;

  TDmScrollView = class(TCustomDmScrollView)
  published
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property Ctl3D;
    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property DragMode;
    property Enabled;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ScrollStyle;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDrag;

    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyString;
    property OnKeyUp;
  end;


implementation

{ TCustomDmScrollView }

constructor TCustomDmControl.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Width:=180;
  Height:=120;
  FBevelEdges:=[beLeft, beTop, beRight, beBottom];
  FBevelInner:=bvNone;
  FBevelOuter:=bvLowered;
  FBevelKind:=bkTile;
  FCtl3D:=true;

  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;

  Palette.ColorRole := crBackground;
  Palette.TextColorRole := crForeground;

  TabStop:=true;

  FLeftMargin:=0;
  FTopMargin:=0;
  FRightMargin:=0;
  FBottomMargin:=0;

  Palette.ColorRole := crBase;
  Palette.TextColorRole := crText;
end;

destructor TCustomDmControl.Destroy;
begin
  inherited;
  // This is freed after calling inherited because the inherited destructor
  // can force a paint operation
  FCanvas.Free;
end;

function TCustomDmControl.Focused: Boolean;
begin
  Result:=HandleAllocated and QWidget_hasFocus(FHandle) and inherited Focused;
end;

procedure TCustomDmControl.Update;
begin
  inherited;
end;

procedure TCustomDmControl.LockUpdates(doLock: boolean);
begin
  assert(Assigned(FHandle));
  if doLock then
    QOpenWidget_setWState(QOpenWidgetH(FHandle), cardinal(WidgetState_WState_BlockUpdates))
  else
    QOpenWidget_clearWState(QOpenWidgetH(FHandle), cardinal(WidgetState_WState_BlockUpdates));
end;

function TCustomDmControl.ClientEventFilter(Sender: QObjectH; Event: QEventH): Boolean;
var
  Form: TCustomForm;
begin
  try
    if csDesigning in ComponentState then
    begin
      Form := GetParentForm(Self);
      if (Form <> nil) and (Form.DesignerHook <> nil) and
        Form.DesignerHook.IsDesignEvent(Self, Sender, Event) then
      begin
        Result := True;
        Exit;
      end;
    end;
    Result := EventFilter(Sender, Event);
  except
    Application.HandleException(Self);
    Result := False;
  end;
end;

procedure TCustomDmControl.CreateWidget;
var
  QC: QColorH;
begin
  inherited;
  FClientHandle:=QWidget_create(FHandle, nil, WidgetFlags);
  QClxObjectMap_add(FClientHandle, Integer(Self));
  QC:=QColor(Color);
  QWidget_setBackgroundColor(FClientHandle, QC);
  QColor_destroy(QC);
  UpdateClientBounds(Point(Width,Height));
end;

procedure TCustomDmControl.InitWidget;
const
  FocusPolicy: array[Boolean] of QWidgetFocusPolicy =
    (QWidgetFocusPolicy_ClickFocus, QWidgetFocusPolicy_NoFocus);
begin
  inherited;
  QWidget_setMouseTracking(FClientHandle, True);
  QWidget_setAcceptDrops(FClientHandle, True);
{  QWidget_setFocusPolicy(FClientHandle, FocusPolicy[csNoFocus in ControlStyle]);}
end;

procedure TCustomDmControl.WidgetDestroyed;
begin
  QClxObjectMap_remove(FClientHandle);
  if assigned(FClientHook) then begin
    QWidget_hook_destroy(FClientHook);
    FClientHook:=nil;
  end;
  if assigned(FClientHandle) then begin
    QWidget_destroy(FClientHandle);
    FClientHandle:=nil;
  end;
  inherited;
end;

procedure TCustomDmControl.HookEvents;
var
  Method: TMethod;
begin
  FClientHook := QWidget_hook_create(FClientHandle);
  TEventFilterMethod(Method) := ClientEventFilter;
  Qt_hook_hook_events(FClientHook, Method);
  inherited;
end;

function TCustomDmControl.WidgetFlags: Integer;
begin
  result:=(inherited WidgetFlags() or
    integer(WidgetFlags_WResizeNoErase) or
    integer(WidgetFlags_WRepaintNoErase)) and not
    integer(WidgetFlags_WPaintClever);
end;

function TCustomDmControl.GetPaintDevice: QPaintDeviceH;
begin
  if FNCPainting then
    Result := QWidget_to_QPaintDevice(FHandle)
  else
    Result := QWidget_to_QPaintDevice(FClientHandle);
end;

function TCustomDmControl.GetChildHandle: QWidgetH;
begin
  if FReturnNCHandler then
    Result := FHandle
  else
    Result := FClientHandle;
end;

procedure TCustomDmControl.UpdateClientBounds(NewSize: TPoint);
var
  r: TRect;
begin
  if not assigned(FClientHandle) then exit;
  R:=CalcContentRect(NewSize);
  QWidget_setGeometry(FClientHandle,@r);
  ClientResized;
end;

procedure TCustomDmControl.BorderChanged;
begin
  UpdateClientBounds(Point(Width,Height));
  InvalidateNCRect(Rect(0,0,Width,Height), false);
end;

procedure TCustomDmControl.ClientResized;
begin
end;

procedure TCustomDmControl.ColorChanged;
begin
  inherited;
end;

type
  TDndControl = class(TControl);

procedure TCustomDmControl.DragDrop(Source: TObject; X, Y: Integer);
var
  msg: TCMDrag;
  DragRec: TDragRec;
begin
  FillChar(DragRec, Sizeof(DragRec), 0);
  DragRec.Pos.X:=X;
  DragRec.Pos.Y:=Y;
  DragRec.Pos:=ClientToScreen(DragRec.Pos);
  if (Source <> nil) and (Source is TControl) then
    DragRec.Source:=TDndControl(Source as TControl).DragObject
  else
    DragRec.Source:=nil;
  DragRec.Target:=Self;
  DragRec.Docking:=false;
  FillChar(msg, SizeOf(msg), 0);
  msg.Msg := CM_DRAG;
  msg.DragMessage := dmDragDrop;
  msg.DragRec := @DragRec;
  WndProc(TMessage(msg));
end;

procedure TCustomDmControl.DragCanceled;
var
  msg: TCMDrag;
  DragRec: TDragRec;
  P: TPoint;
begin
  GetCursorPos(P);
  FillChar(DragRec, Sizeof(DragRec), 0);
  DragRec.Pos.X:=P.X;
  DragRec.Pos.Y:=P.Y;
  DragRec.Source:=DragObject;
  DragRec.Target:=Self;
  DragRec.Docking:=false;
  FillChar(msg, SizeOf(msg), 0);
  msg.Msg := CM_DRAG;
  msg.DragMessage := dmDragCancel;
  msg.DragRec := @DragRec;
  WndProc(TMessage(msg));
end;

procedure TCustomDmControl.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  msg: TCMDrag;
  DragRec: TDragRec;
begin
  FillChar(DragRec, Sizeof(DragRec), 0);
  DragRec.Pos.X:=X;
  DragRec.Pos.Y:=Y;
  DragRec.Pos:=ClientToScreen(DragRec.Pos);
  if (Source <> nil) and (Source is TControl) then
    DragRec.Source:=TDndControl(Source as TControl).DragObject
  else
    DragRec.Source:=nil;
  DragRec.Target:=Self;
  DragRec.Docking:=false;
  FillChar(msg, SizeOf(msg), 0);
  msg.Msg := CM_DRAG;
  case State of
    dsDragEnter: msg.DragMessage := dmDragEnter;
    dsDragLeave: msg.DragMessage := dmDragLeave;
    dsDragMove: msg.DragMessage := dmDragMove;
  end;
  msg.DragRec := @DragRec;
  WndProc(TMessage(msg));
  Accept := msg.Result <> DROPEFFECT_NONE;
end;

procedure TCustomDmControl.GetClientMargins(var Left,Top,Right,Bottom: integer);
begin
  Left:=FLeftMargin;
  Top:=FTopMargin;
  Right:=FRightMargin;
  Bottom:=FBottomMargin;
end;

procedure TCustomDmControl.SetClientMargins(Left,Top,Right,Bottom: integer);
var
  Changed: Boolean;
begin
  Changed:=
    (FLeftMargin<>Left) or
    (FTopMargin<>Top) or
    (FRightMargin<>Right) or
    (FBottomMargin<>Bottom);
  if not Changed then exit;
  FLeftMargin:=Left;
  FTopMargin:=Top;
  FRightMargin:=Right;
  FBottomMargin:=Bottom;
  UpdateClientBounds(Point(Width,Height));
end;

procedure TCustomDmControl.InvalidateRect(Rect: TRect; EraseBackground: Boolean);
begin
  if not Assigned(FClientHandle) then exit;
  if EraseBackground then
    QWidget_erase(FClientHandle, @Rect);
  QWidget_update(FClientHandle, @Rect);
end;

procedure TCustomDmControl.InvalidateNCRect(Rect: TRect; EraseBackground: Boolean);
begin
  if not HandleAllocated then exit;
  if EraseBackground then
    QWidget_erase(FHandle, @Rect);
  QWidget_update(FHandle, @Rect);
end;

procedure TCustomDmControl.Invalidate;
begin
  if HandleAllocated then begin
    QWidget_update(FClientHandle);
    QWidget_update(FHandle);
  end;
end;

function TCustomDmControl.IsControlMouseMsg(var Message: TWMMouse): Boolean;
var
  Control: TControl;
  P: TPoint;
  AMessage: TWMMouse;
begin
  if GetCapture = Handle then
  begin
    Control := nil;
    if (GetCaptureControl <> nil) and (GetCaptureControl.Parent = Self) then
      Control := GetCaptureControl;
  end else
    Control := ControlAtPos(SmallPointToPoint(Message.Pos), False);
  Result := False;
  if Control <> nil then
  begin
    P.X := Message.XPos - Control.Left;
    P.Y := Message.YPos - Control.Top;
    AMessage:=Message;
    AMessage.Pos:=PointToSmallPoint(P);
    Control.Dispatch(AMessage);
    Message.Result := AMessage.Result;
    Result := True;
  end;
end;

procedure TCustomDmControl.WndProc(var Message: TMessage);
begin
  Dispatch(Message);
end;

procedure TCustomDmControl.CMDrag(var Message: TCMDrag);
var
  Accepts: boolean;
  S: TObject;
begin
  with Message, DragRec^, ScreenToClient(Pos) do
  begin
    S := Source;
    if S is TDragControlObject then S := TDragControlObject(S).Control;
    case DragMessage of
      dmDragEnter,
      dmDragLeave,
      dmDragMove: begin
        inherited DragOver(S, X, Y, TDragState(DragMessage), Accepts);
        Result := Ord(Accepts);
      end;
      dmDragDrop:
        inherited DragDrop(S, X, Y);
    end;
  end;
end;

function TCustomDmControl.EventFilter(Sender: QObjectH; Event: QEventH): Boolean;
  procedure MouseEvent(IsClientMessage: boolean; Event: QMouseEventH);
  var
    Message: TWMMouse;
    pt, gpt: TPoint;
    SetCurMsg: TWMSetCursor;
  begin
    pt:=QMouseEvent_Pos(QMouseEventH(Event))^;
    Message.Msg:=QEventType_Msg(IsClientMessage, Event);
    Message.Keys:=QEventType_Keys(Event);
    QWidget_mapToGlobal(QWidgetH(Sender), @gpt, @pt);
    if not IsClientMessage then
      pt := gpt;
    Message.Pos:=PointToSmallPoint(pt);
    if Message.Msg<>0 then begin
      WndProc(TMessage(Message));
    end;

    if (QEvent_type(Event) = QEventType_MouseMove) or
      (QEvent_type(Event) = QEventType_MouseButtonRelease)
    then begin
      SetCurMsg.Msg:=WM_SETCURSOR;
      SetCurMsg.CursorWnd:=FHandle;
      SetCurMsg.MouseMsg:=Message.Msg;
      SetCurMsg.HitTest:=0;
      SetCurMsg.Result:=0;
      if not IsClientMessage then
        SetCurMsg.HitTest:=18; // HTBORDER
      WndProc(TMessage(SetCurMsg));
    end;

  end;

  procedure FocusChanging;
  var
    Message: TWMSetFocus;
  begin
    if QEvent_type(Event) = QEventType_FocusIn then begin
      Message.Msg:=WM_SETFOCUS;
      Message.FocusedWnd:=Handle;
    end
    else begin
      Message.Msg:=WM_KILLFOCUS;
      Message.FocusedWnd:=nil;
    end;
    Message.Unused:=0;
    Message.Result:=0;
    WndProc(TMessage(Message));
  end;

begin
  Result:=false;
  if (Sender = FHandle) and (QEvent_type(Event) = QEventType_Resize)
  then begin
    Result := inherited EventFilter(Sender, Event);
    UpdateClientBounds(Point(Width,Height));
    exit;
  end;
  if (Sender = FHandle) then begin //\2
    case QEvent_type(Event) of
      QEventType_MouseMove,
      QEventType_MouseButtonPress,
      QEventType_MouseButtonRelease,
      QEventType_MouseButtonDblClick: begin
        MouseEvent(False, QMouseEventH(Event));
        if QWidget_mouseGrabber <> FClientHandle then exit;
      end;
    end;
  end;

  case QEvent_type(Event) of
    QEventType_FocusIn,
    QEventType_FocusOut:
      FocusChanging;
    QEventType_MouseMove,
    QEventType_MouseButtonPress,
    QEventType_MouseButtonRelease,
    QEventType_MouseButtonDblClick:
      MouseEvent(Sender=ChildHandle, QMouseEventH(Event));
  end;
  Result := inherited EventFilter(Sender, Event);
end;

procedure TCustomDmControl.SetBevelEdges(const Value: TBevelEdges);
begin
  if FBevelEdges = Value then exit;
  FBevelEdges := Value;
  BorderChanged;
end;

procedure TCustomDmControl.SetBevelKind(const Value: TBevelKind);
begin
  if FBevelKind = Value then exit;
  FBevelKind := Value;
  BorderChanged;
end;

procedure TCustomDmControl.SetBevelInner(Value: TBevelCut);
begin
  if FBevelInner = Value then exit;
  FBevelInner := Value;
  BorderChanged;
end;

procedure TCustomDmControl.SetBevelOuter(Value: TBevelCut);
begin
  if FBevelOuter = Value then exit;
  FBevelOuter := Value;
  BorderChanged;
end;

procedure TCustomDmControl.SetCtl3D(Value: boolean);
begin
  if FCtl3D = Value then exit;
  FCtl3D := Value;
  BorderChanged;
end;

procedure TCustomDmControl.BorderMargins(var L,T,R,B: integer);
var
  EdgeSize: integer;
begin
  L:=0;
  T:=0;
  R:=0;
  B:=0;
  if FBevelKind <> bkNone then begin
    EdgeSize := 0;
    if BevelInner <> bvNone then Inc(EdgeSize, 1);
    if BevelOuter <> bvNone then Inc(EdgeSize, 1);
    if beLeft in FBevelEdges then Inc(L, EdgeSize);
    if beTop in FBevelEdges then Inc(T, EdgeSize);
    if beRight in FBevelEdges then Inc(R, EdgeSize);
    if beBottom in FBevelEdges then Inc(B, EdgeSize);
  end;
end;

function TCustomDmControl.CalcContentRect(NewSize: TPoint): TRect;
var
  L,T,R,B: integer;
begin
  Result:=Rect(0,0,NewSize.X,NewSize.Y);

  BorderMargins(L,T,R,B);

  inc(Result.Left, FLeftMargin + L);
  dec(Result.Right, FRightMargin + R);
  inc(Result.Top, FTopMargin + T);
  dec(Result.Bottom, FBottomMargin + B);
  if Result.Right<Result.Left then Result.Right:=Result.Left;
  if Result.Bottom<Result.Top then Result.Bottom:=Result.Top;
end;

function TCustomDmControl.ContentRect: TRect;
begin
  Result:=CalcContentRect(Point(Width,Height));
end;

function TCustomDmControl.GetClientOrigin: TPoint;
var
  R: TRect;
begin
  R:=ContentRect;
  result:=R.TopLeft;
  QWidget_mapToGlobal(Handle, @Result, @Result);
end;

function TCustomDmControl.GetClientRect: TRect;
begin
  result:=ContentRect;
  OffsetRect(Result,-Result.Left,-Result.Top);
end;

procedure TCustomDmControl.AdjustPainter(Painter: QPainterH);
begin
  inherited;
end;

procedure TCustomDmControl.Painting(Sender: QObjectH; EventRegion: QRegionH);
begin
  if Sender = FHandle then begin
    FNCPainting:=true;
    try
      TControlCanvas(FCanvas).StartPaint;
      try
        QPainter_setClipRegion(FCanvas.Handle, EventRegion);
        NCPaint;
        QPainter_setClipRegion(FCanvas.Handle, EventRegion);
      finally
        TControlCanvas(FCanvas).StopPaint;
      end;
    finally
      FNCPainting:=false;
    end;
    exit;
  end;

  TControlCanvas(FCanvas).StartPaint;
  try
    QPainter_setClipRegion(FCanvas.Handle, EventRegion);
    Paint;
    QPainter_setClipRegion(FCanvas.Handle, EventRegion);
  finally
    TControlCanvas(FCanvas).StopPaint;
  end;
end;

procedure TCustomDmControl.Paint;
var
  R: TRect;
begin
  Canvas.Brush.Color:=Color;
  R:=ClientRect;
  Canvas.Brush.Color:=clRed;
end;

procedure TCustomDmControl.NCPaint;
begin
  PaintBorder(true);
end;

procedure TCustomDmControl.PaintBorder(erase: boolean);
const
  InnerStyles: array[TBevelCut] of Integer = (0, BDR_SUNKENINNER, BDR_RAISEDINNER, 0);
  OuterStyles: array[TBevelCut] of Integer = (0, BDR_SUNKENOUTER, BDR_RAISEDOUTER, 0);
  EdgeStyles: array[TBevelKind] of Integer = (0, 0, BF_SOFT, BF_FLAT);
  Ctl3DStyles: array[Boolean] of Integer = (BF_MONO, 0);
  Middle: array[Boolean] of Integer = (0, BF_MIDDLE);
var
  R: TRect;
begin
  R:=Rect(0,0,Width,Height);
  if FBevelKind <> bkNone then
    DrawEdge(Canvas, R,
      InnerStyles[BevelInner] or
      OuterStyles[BevelOuter],
      Byte(BevelEdges) or
      EdgeStyles[BevelKind] or
      Ctl3DStyles[Ctl3D] or
      Middle[erase]
    )
  else if erase then begin
    if not Ctl3D then
      Canvas.Brush.Color:=clWindow
    else
      Canvas.Brush.Color:=clBtnFace;
    Canvas.FillRect(R);
  end;
end;


{ TDmFrameScrollBar }

constructor TDmFrameScrollBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Track := False;
  Color := clScrollBar;
end;

function TDmFrameScrollBar.GetVisible: boolean;
begin
  result:=inherited Visible;
end;

procedure TDmFrameScrollBar.SetVisible(Value: boolean);
begin
  inherited Visible := Value;
  if csDesigning in ComponentState then
    if Value then
      QWidget_show(Handle)
    else
      QWidget_hide(Handle);
end;

procedure TDmFrameScrollBar.InitWidget;
begin
  inherited InitWidget;
  QWidget_setFocusPolicy(Handle, QWidgetFocusPolicy_NoFocus);
  Visible := False;
end;

function TDmFrameScrollBar.EventFilter(Sender: QObjectH; Event: QEventH): Boolean;
begin
  if QEvent_type(Event) = QEventType_FocusIn then begin
    if Assigned(ParentWidget) and
      QWidget_isFocusEnabled(ParentWidget) and
      not QWidget_hasFocus(ParentWidget)
    then
      QWidget_setFocus(ParentWidget);
    Result:=true;
    exit;
  end;
  Result:=inherited EventFilter(Sender, Event);
end;

function TDmFrameScrollBar.CanFocus: Boolean;
begin
  Result := False;
end;

{ TCustomDmScrollView }

constructor TCustomDmScrollView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderMargins(FLastBorder.Left, FLastBorder.Top, FLastBorder.Right, FLastBorder.Bottom);
  FHScrollBar:=TDmFrameScrollBar.Create(Self);
  FVScrollBar:=TDmFrameScrollBar.Create(Self);

  with FHScrollBar do begin
    Kind := sbHorizontal;
    Height:=16;
    OnScroll := ScrollEvent;
    Left:=FLastBorder.Left;
    Max:=0;
    LargeChange:=30;
    SmallChange:=1;
    Track:=true;
    ParentColor:=false;
  end;

  with FVScrollBar do begin
    Kind := sbVertical;
    Width:=16;
    OnScroll := ScrollEvent;
    Top:=FLastBorder.Top;
    Max:=0;
    LargeChange:=30;
    SmallChange:=1;
    Track:=true;
    ParentColor:=false;
  end;
  FScrollStyle:=ssBoth;
end;

procedure TCustomDmScrollView.InitWidget;
begin
  inherited InitWidget;
  QWidget_setBackgroundMode(FClientHandle, QWidgetBackgroundMode_NoBackground);
  QWidget_setBackgroundMode(FHandle, QWidgetBackgroundMode_NoBackground);

//  HandleNeeded;
  FReturnNCHandler:=true;
  try
    FHScrollBar.ParentWidget:=Self.FHandle;
    FVScrollBar.ParentWidget:=Self.FHandle;
    FHScrollBar.ReSubmitFlags;
    FVScrollBar.ReSubmitFlags;
  finally
    FReturnNCHandler:=false;
  end;
  FVScrollBar.Visible:=true;
  FHScrollBar.Visible:=true;
  SetClientMargins(FLeftMargin, FTopMargin, FVScrollBar.Width, FHScrollBar.Height);
end;

procedure TCustomDmScrollView.Loaded;
begin
  inherited;
end;

procedure TCustomDmScrollView.BorderChanged;
var
  R: TRect;
  x,y: integer;
begin
  BorderMargins(R.Left, R.Top, R.Right, R.Bottom);
  x:=R.Left-FLastBorder.Left;
  y:=R.Top-FLastBorder.Top;
  if x <> 0 then FHScrollBar.Left:=FHScrollBar.Left+x;
  if y <> 0 then FVScrollBar.Top:=FVScrollBar.Top+y;
  FLastBorder:=R;
  inherited;
end;

procedure TCustomDmScrollView.ClientResized;
var
  Cont, RV, RH: TRect;

begin
  if assigned(FVScrollBar) and assigned(FHScrollBar) and HandleAllocated then begin
    Cont:=ContentRect;

    RV:=Cont;
    RV.Left:=Cont.Right;
    RV.Right:=RV.Left + FVScrollBar.Width;

    RH:=Cont;
    RH.Top:=Cont.Bottom;
    RH.Bottom:=RH.Top + FHScrollBar.Height;

    FVScrollBar.BoundsRect:=RV;
    FHScrollBar.BoundsRect:=RH;
    UpdateScrollBarsVisibility;
  end;
  inherited;
end;

procedure TCustomDmScrollView.SetScrollStyle(Value: TScrollStyle);
begin
  if Value = FScrollStyle then exit;
  FScrollStyle:=Value;
  UpdateScrollBarsVisibility;
end;

procedure TCustomDmScrollView.UpdateScrollBarsVisibility;
var
  vEn, hEn: boolean;
  Marg: TRect;
begin
  if not HandleAllocated then exit;

  hEn:=(FScrollStyle in [ssHorizontal, ssBoth]) or
    ((FScrollStyle in [ssAutoHorizontal, ssAutoBoth]) and (FHScrollBar.Max <> FHScrollBar.Min));
  vEn:=(FScrollStyle in [ssVertical, ssBoth]) or
    ((FScrollStyle in [ssAutoVertical, ssAutoBoth]) and (FVScrollBar.Max <> FVScrollBar.Min));
  if (hEn = FHScrollBar.Visible) and (vEn = FVScrollBar.Visible) then exit;

// possible recursion
  inc(FSbUpdateCnt);
  try
    if FSbUpdateCnt > 2 then exit; // no more than two
    Marg:=Rect(FLeftMargin, FTopMargin, FRightMargin, FBottomMargin);
    if hEn <> FHScrollBar.Visible then begin
      if hEn then
        inc(Marg.Bottom, FHScrollBar.Height)
      else
        dec(Marg.Bottom, FHScrollBar.Height);
      FHScrollBar.Visible:=hEn;
    end;
    if vEn <> FVScrollBar.Visible then begin
      if vEn then
        inc(Marg.Right, FVScrollBar.Width)
      else
        dec(Marg.Right, FVScrollBar.Width);
      FVScrollBar.Visible:=vEn;
    end;
    SetClientMargins(Marg.Left, Marg.Top, Marg.Right, Marg.Bottom); // POSSIBLE RECURSION
  finally
    dec(FSbUpdateCnt);
  end;
end;

procedure TCustomDmScrollView.SetScrollInfo(What: TScrollBarKind; aMin,aMax,aLine,aPage,aPos: integer);
var
  sb: TDmFrameScrollBar;
begin
  if What = sbHorizontal then
    sb:=FHScrollBar
  else
    sb:=FVScrollBar;

  aMax:=Max(aMin, aMax);
  sb.SetParams(aPos, aMin, aMax);
  sb.LargeChange:=max(1,aPage);
  sb.SmallChange:=max(1,aLine);
  UpdateScrollBarsVisibility;
end;

function TCustomDmScrollView.GetScrollPos(What: TScrollBarKind): integer;
begin
  if What = sbHorizontal then
    Result:=FHScrollBar.Position
  else
    Result:=FVScrollBar.Position;
end;

procedure TCustomDmScrollView.SetScrollPos(What: TScrollBarKind; Pos: integer);
begin
  if What = sbHorizontal then
    FHScrollBar.Position := Pos
  else
    FVScrollBar.Position := Pos;
end;

procedure TCustomDmScrollView.ScrollContent(What: TScrollBarKind; ScrollCode: TScrollCode; Pos: Cardinal);
begin
end;

procedure TCustomDmScrollView.ScrollEvent(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if (Sender = FVScrollBar) and ((ScrollCode in [scEndScroll, scTrack]))
  then begin
    ScrollContent(sbVertical, ScrollCode, ScrollPos);
  end;
  if (Sender = FHScrollBar) and ((ScrollCode in [scEndScroll, scTrack]))
  then begin
    ScrollContent(sbHorizontal, ScrollCode, ScrollPos);
  end;
end;

end.
