{ *********************************************************************** }
{                                                                         }
{  Borland Kylix Runtime Library                                          }
{  Linux API Interface Unit - XWindows library                            }
{                                                                         }
{  Copyright (C) 2001-2002 Borland Software Corporation                   }
{                                                                         }
{  Translator: Borland Software Corporation                               }
{                                                                         }
{  This file may be distributed and/or modified under the terms of the    }
{  GNU General Public License version 2 as published by the Free Software }
{  Foundation and appearing at http://www.borland.com/kylix/gpl.html.     }
{                                                                         }
{  Licensees holding a valid Borland No-Nonsense License for this         }
{  Software may use this file in accordance with such license, which      }
{  appears in the file license.txt that came with this software.          }
{                                                                         }
{ *********************************************************************** }

unit Xlib;
(*$HPPEMIT  '/*' *)
(*$HPPEMIT  ' * <X11/Xlib.h> from XFree86 version 3.x clashes with <QGraphics.hpp>' *)
(*$HPPEMIT  ' * and <QControls.hpp>, among others, and cannot be included by default' *)
(*$HPPEMIT  ' * in a CLX application. If you have the XF86 4.x headers, you can' *) 
(*$HPPEMIT  ' * safely include <X11/Xlib.h> after defining "XLIB4_INCLUDE"' *)
(*$HPPEMIT  '*/' *)
(*$HPPEMIT  '#if defined(XLIB4_INCLUDE)' *)
(*$HPPEMIT  '#include <X11/Xlib.h>'  *)
(*$HPPEMIT  '#undef KeyPress'  *)
(*$HPPEMIT  'int const KeyPress = 2;'  *)
(*$HPPEMIT  '#undef ButtonPress'  *)
(*$HPPEMIT  'int const ButtonPress = 4;'  *)
(*$HPPEMIT  '#undef Button1'  *)
(*$HPPEMIT  'int const Button1 = 1;'  *)
(*$HPPEMIT  '#undef Button2'  *)
(*$HPPEMIT  'int const Button2 = 2;'  *)
(*$HPPEMIT  '#undef Button3'  *)
(*$HPPEMIT  'int const Button3 = 3;'  *)
(*$HPPEMIT  '#undef Status'  *)
(*$HPPEMIT  '#endif'  *)

(*$HPPEMIT  '/*'  *)
(*$HPPEMIT  ' * Because of <X11/Xlib.h> name clashes, define here only what is'  *)
(*$HPPEMIT  ' * required by the CLX interface.'  *)
(*$HPPEMIT  ' */'  *)
(*$HPPEMIT  ''  *)
(*$HPPEMIT  '#if !defined(_XTYPEDEF_XID)'  *)
(*$HPPEMIT  '  #define _XTYPEDEF_XID'  *)
(*$HPPEMIT  '  typedef uint32_t XID;'  *)
(*$HPPEMIT  '#endif'  *)
(*$HPPEMIT  ''  *)
(*$HPPEMIT  '#if !defined(_XTYPEDEF_FONT)'  *)
(*$HPPEMIT  '  #define _XTYPEDEF_FONT'  *)
(*$HPPEMIT  '  typedef XID Font;'  *)
(*$HPPEMIT  '#endif'  *)
(*$HPPEMIT  ''  *)
(*$HPPEMIT  '#if !defined(_XTYPEDEF_PXEVENT)'  *)
(*$HPPEMIT  '  #define _XTYPEDEF_PXEVENT'  *)
(*$HPPEMIT  '#if !defined(XLIB4_INCLUDE)' *)
(*$HPPEMIT  '  struct XEvent;' *)
(*$HPPEMIT  '#endif' *)
(*$HPPEMIT  '  typedef XEvent *PXEvent;'  *)
(*$HPPEMIT  '#endif'  *)
(*$HPPEMIT  ''  *)
(*$HPPEMIT  '#if defined(XLIB_ILLEGAL_ACCESS)'  *)
(*$HPPEMIT  '  #error XLIB_ILLEGAL_ACCESS not supported'  *)
(*$HPPEMIT  '#else'  *)
(*$HPPEMIT  '  struct _XDisplay;'  *)
(*$HPPEMIT  '  typedef _XDisplay Display;'  *)
(*$HPPEMIT  '#endif'  *)
(*$HPPEMIT  ''  *)
{$WEAKPACKAGEUNIT}

{$ALIGN 4}
{$MINENUMSIZE 4}

interface

uses
  Libc;

  { Intrinsic.h }

type
  Pixel = type Cardinal;
  {$EXTERNALSYM Pixel}
  PPixel = ^Pixel;
  {$EXTERNALSYM PPixel}
  TPixel = Pixel;
  {$EXTERNALSYM TPixel}

  { X.h }

const
{ current protocol version  }
  X_PROTOCOL = 11;
  {$EXTERNALSYM X_PROTOCOL}
{ current minor version  }
  X_PROTOCOL_REVISION = 0;
  {$EXTERNALSYM X_PROTOCOL_REVISION}

{ Resources  }
type
  XID = type Cardinal;
  {$EXTERNALSYM XID}
  Mask = type Cardinal;
  {$EXTERNALSYM Mask}

  PAtom = ^TAtom;
  {$EXTERNALSYM PAtom}
  Atom = type Cardinal;
  {$EXTERNALSYM Atom}
  TAtom = Atom;
  {$EXTERNALSYM TAtom}
  PPAtom = ^PAtom;
  {$EXTERNALSYM PPAtom}

  VisualID = type Cardinal;
  {$EXTERNALSYM VisualID}
  TTime = Cardinal;
  {$EXTERNALSYM TTime}

  PWindow = ^TWindow;
  {$EXTERNALSYM PWindow}
  Window = XID;
  {$EXTERNALSYM Window}
  TWindow = Window;
  {$EXTERNALSYM TWindow}
  PPWindow = ^PWindow;
  {$EXTERNALSYM PPWindow}

  Drawable = XID;
  {$EXTERNALSYM Drawable}
  TDrawable = Drawable;
  {$EXTERNALSYM TDrawable}
  Font = XID;
  {$EXTERNALSYM Font}
  TFont = Font;

  PPixmap = ^TPixmap;
  {$EXTERNALSYM PPixmap}
  Pixmap = XID;
  {$EXTERNALSYM Pixmap}
  TPixmap = Pixmap;
  {$EXTERNALSYM TPixmap}

  PCursor = ^TCursor;
  {$EXTERNALSYM PCursor}
  Cursor = XID;
  {$EXTERNALSYM Cursor}
  TCursor = Cursor;
  {$EXTERNALSYM TCursor}

  PColormap = ^TColormap;
  {$EXTERNALSYM PColormap}
  Colormap = XID;
  {$EXTERNALSYM Colormap}
  TColorMap = ColorMap;
  {$EXTERNALSYM TColorMap}

  PGContext = ^TGContext;
  {$EXTERNALSYM PGContext}
  GContext = XID;
  {$EXTERNALSYM GContext}
  TGContext = GContext;
  {$EXTERNALSYM TGContext}

  PKeySym = ^TKeySym;
  {$EXTERNALSYM PKeySym}
  KeySym = XID;
  {$EXTERNALSYM KeySym}
  TKeySym = KeySym;
  {$EXTERNALSYM TKeySym}

  PKeycode = ^TKeyCode;
  {$EXTERNALSYM PKeycode}
  KeyCode = Byte;
  {$EXTERNALSYM KeyCode}
  TKeyCode = KeyCode;
  {$EXTERNALSYM TKeyCode}

{ RESERVED RESOURCE AND CONSTANT DEFINITIONS }

{ universal null resource or null atom  }
const
  None = 0;
  {$EXTERNALSYM None}

{ background pixmap in CreateWindow and ChangeWindowAttributes  }
  ParentRelative = 1;
  {$EXTERNALSYM ParentRelative}

{ border pixmap in CreateWindow and ChangeWindowAttributes,
  special VisualID and special window class passed to CreateWindow  }
  CopyFromParent = 0;
  {$EXTERNALSYM CopyFromParent}

{ destination window in SendEvent  }
  PointerWindow = 0;
  {$EXTERNALSYM PointerWindow}

{ destination window in SendEvent  }
   InputFocus = 1;
   {$EXTERNALSYM InputFocus}
{ focus window in SetInputFocus  }
   PointerRoot = 1;
   {$EXTERNALSYM PointerRoot}
{ special Atom, passed to GetProperty  }
   AnyPropertyType = 0;
   {$EXTERNALSYM AnyPropertyType}
{ special Key Code, passed to GrabKey  }
   AnyKey = 0;
   {$EXTERNALSYM AnyKey}
{ special Button Code, passed to GrabButton  }
   AnyButton = 0;
   {$EXTERNALSYM AnyButton}
{ special Resource ID passed to KillClient  }
   AllTemporary = 0;
   {$EXTERNALSYM AllTemporary}
{ special Time  }
   CurrentTime = 0;
   {$EXTERNALSYM CurrentTime}
{ special KeySym  }
   NoSymbol = 0;
   {$EXTERNALSYM NoSymbol}

{ EVENT DEFINITIONS }

{ Input Event Masks. Used as event-mask window attribute and as arguments
     to Grab requests.  Not to be confused with event names.   }
   NoEventMask = 0;
   {$EXTERNALSYM NoEventMask}
   KeyPressMask = 1 shl 0;
   {$EXTERNALSYM KeyPressMask}
   KeyReleaseMask = 1 shl 1;
   {$EXTERNALSYM KeyReleaseMask}
   ButtonPressMask = 1 shl 2;
   {$EXTERNALSYM ButtonPressMask}
   ButtonReleaseMask = 1 shl 3;
   {$EXTERNALSYM ButtonReleaseMask}
   EnterWindowMask = 1 shl 4;
   {$EXTERNALSYM EnterWindowMask}
   LeaveWindowMask = 1 shl 5;
   {$EXTERNALSYM LeaveWindowMask}
   PointerMotionMask = 1 shl 6;
   {$EXTERNALSYM PointerMotionMask}
   PointerMotionHintMask = 1 shl 7;
   {$EXTERNALSYM PointerMotionHintMask}
   Button1MotionMask = 1 shl 8;
   {$EXTERNALSYM Button1MotionMask}
   Button2MotionMask = 1 shl 9;
   {$EXTERNALSYM Button2MotionMask}
   Button3MotionMask = 1 shl 10;
   {$EXTERNALSYM Button3MotionMask}
   Button4MotionMask = 1 shl 11;
   {$EXTERNALSYM Button4MotionMask}
   Button5MotionMask = 1 shl 12;
   {$EXTERNALSYM Button5MotionMask}
   ButtonMotionMask = 1 shl 13;
   {$EXTERNALSYM ButtonMotionMask}
   KeymapStateMask = 1 shl 14;
   {$EXTERNALSYM KeymapStateMask}
   ExposureMask = 1 shl 15;
   {$EXTERNALSYM ExposureMask}
   VisibilityChangeMask = 1 shl 16;
   {$EXTERNALSYM VisibilityChangeMask}
   StructureNotifyMask = 1 shl 17;
   {$EXTERNALSYM StructureNotifyMask}
   ResizeRedirectMask = 1 shl 18;
   {$EXTERNALSYM ResizeRedirectMask}
   SubstructureNotifyMask = 1 shl 19;
   {$EXTERNALSYM SubstructureNotifyMask}
   SubstructureRedirectMask = 1 shl 20;
   {$EXTERNALSYM SubstructureRedirectMask}
   FocusChangeMask = 1 shl 21;
   {$EXTERNALSYM FocusChangeMask}
   PropertyChangeMask = 1 shl 22;
   {$EXTERNALSYM PropertyChangeMask}
   ColormapChangeMask = 1 shl 23;
   {$EXTERNALSYM ColormapChangeMask}
   OwnerGrabButtonMask = 1 shl 24;
   {$EXTERNALSYM OwnerGrabButtonMask}
 
{ Event names.  Used in "type" field in XEvent structures.  Not to be
  confused with event masks above.  They start from 2 because 0 and 1
  are reserved in the protocol for errors and replies.  }
   KeyPress = 2;
   {$EXTERNALSYM KeyPress}
   KeyRelease = 3;
   {$EXTERNALSYM KeyRelease}
   ButtonPress = 4;
   {$EXTERNALSYM ButtonPress}
   ButtonRelease = 5;
   {$EXTERNALSYM ButtonRelease}
   MotionNotify = 6;
   {$EXTERNALSYM MotionNotify}
   EnterNotify = 7;
   {$EXTERNALSYM EnterNotify}
   LeaveNotify = 8;
   {$EXTERNALSYM LeaveNotify}
   FocusIn = 9;
   {$EXTERNALSYM FocusIn}
   FocusOut = 10;
   {$EXTERNALSYM FocusOut}
   KeymapNotify = 11;
   {$EXTERNALSYM KeymapNotify}
   Expose = 12;
   {$EXTERNALSYM Expose}
   GraphicsExpose = 13;
   {$EXTERNALSYM GraphicsExpose}
   NoExpose = 14;
   {$EXTERNALSYM NoExpose}
   VisibilityNotify = 15;
   {$EXTERNALSYM VisibilityNotify}
   CreateNotify = 16;
   {$EXTERNALSYM CreateNotify}
   DestroyNotify = 17;
   {$EXTERNALSYM DestroyNotify}
   UnmapNotify = 18;
   {$EXTERNALSYM UnmapNotify}
   MapNotify = 19;
   {$EXTERNALSYM MapNotify}
   MapRequest = 20;
   {$EXTERNALSYM MapRequest}
   ReparentNotify = 21;
   {$EXTERNALSYM ReparentNotify}
   ConfigureNotify = 22;
   {$EXTERNALSYM ConfigureNotify}
   ConfigureRequest = 23;
   {$EXTERNALSYM ConfigureRequest}
   GravityNotify = 24;
   {$EXTERNALSYM GravityNotify}
   ResizeRequest = 25;
   {$EXTERNALSYM ResizeRequest}
   CirculateNotify = 26;
   {$EXTERNALSYM CirculateNotify}
   CirculateRequest = 27;
   {$EXTERNALSYM CirculateRequest}
   PropertyNotify = 28;
   {$EXTERNALSYM PropertyNotify}
   SelectionClear = 29;
   {$EXTERNALSYM SelectionClear}
   SelectionRequest = 30;
   {$EXTERNALSYM SelectionRequest}
   SelectionNotify = 31;
   {$EXTERNALSYM SelectionNotify}
   ColormapNotify = 32;
   {$EXTERNALSYM ColormapNotify}
   ClientMessage = 33;
   {$EXTERNALSYM ClientMessage}
   MappingNotify = 34;
   {$EXTERNALSYM MappingNotify}
 { must be bigger than any event #  }
   LASTEvent = 35;
   {$EXTERNALSYM LASTEvent}

{ Key masks. Used as modifiers to GrabButton and GrabKey, results of 
  QueryPointer, state in various key-, mouse-, and button-related events.  }
   ShiftMask = 1 shl 0;
   {$EXTERNALSYM ShiftMask}
   LockMask = 1 shl 1;
   {$EXTERNALSYM LockMask}
   ControlMask = 1 shl 2;
   {$EXTERNALSYM ControlMask}
   Mod1Mask = 1 shl 3;
   {$EXTERNALSYM Mod1Mask}
   Mod2Mask = 1 shl 4;
   {$EXTERNALSYM Mod2Mask}
   Mod3Mask = 1 shl 5;
   {$EXTERNALSYM Mod3Mask}
   Mod4Mask = 1 shl 6;
   {$EXTERNALSYM Mod4Mask}
   Mod5Mask = 1 shl 7;
   {$EXTERNALSYM Mod5Mask}

{ modifier names.  Used to build a SetModifierMapping request or
  to read a GetModifierMapping request.  These correspond to the
  masks defined above.  }
   ShiftMapIndex = 0;
   {$EXTERNALSYM ShiftMapIndex}
   LockMapIndex = 1;
   {$EXTERNALSYM LockMapIndex}
   ControlMapIndex = 2;
   {$EXTERNALSYM ControlMapIndex}
   Mod1MapIndex = 3;
   {$EXTERNALSYM Mod1MapIndex}
   Mod2MapIndex = 4;
   {$EXTERNALSYM Mod2MapIndex}
   Mod3MapIndex = 5;
   {$EXTERNALSYM Mod3MapIndex}
   Mod4MapIndex = 6;
   {$EXTERNALSYM Mod4MapIndex}
   Mod5MapIndex = 7;
   {$EXTERNALSYM Mod5MapIndex}

{ button masks.  Used in same manner as Key masks above. Not to be confused
  with button names below.  }
   Button1Mask = 1 shl 8;
   {$EXTERNALSYM Button1Mask}
   Button2Mask = 1 shl 9;
   {$EXTERNALSYM Button2Mask}
   Button3Mask = 1 shl 10;
   {$EXTERNALSYM Button3Mask}
   Button4Mask = 1 shl 11;
   {$EXTERNALSYM Button4Mask}
   Button5Mask = 1 shl 12;
   {$EXTERNALSYM Button5Mask}

{ used in GrabButton, GrabKey  }
   AnyModifier = 1 shl 15;
   {$EXTERNALSYM AnyModifier}

{ button names. Used as arguments to GrabButton and as detail in ButtonPress
  and ButtonRelease events.  Not to be confused with button masks above.
  Note that 0 is already defined above as "AnyButton".   }
   Button1 = 1;
   {$EXTERNALSYM Button1}
   Button2 = 2;
   {$EXTERNALSYM Button2}
   Button3 = 3;
   {$EXTERNALSYM Button3}
   Button4 = 4;
   {$EXTERNALSYM Button4}
   Button5 = 5;
   {$EXTERNALSYM Button5}

{ Notify modes  }
   NotifyNormal = 0;
   {$EXTERNALSYM NotifyNormal}
   NotifyGrab = 1;
   {$EXTERNALSYM NotifyGrab}
   NotifyUngrab = 2;
   {$EXTERNALSYM NotifyUngrab}
   NotifyWhileGrabbed = 3;
   {$EXTERNALSYM NotifyWhileGrabbed}

{ for MotionNotify events  }
   NotifyHint = 1;
   {$EXTERNALSYM NotifyHint}

{ Notify detail  }
   NotifyAncestor = 0;
   {$EXTERNALSYM NotifyAncestor}
   NotifyVirtual = 1;
   {$EXTERNALSYM NotifyVirtual}
   NotifyInferior = 2;
   {$EXTERNALSYM NotifyInferior}
   NotifyNonlinear = 3;
   {$EXTERNALSYM NotifyNonlinear}
   NotifyNonlinearVirtual = 4;
   {$EXTERNALSYM NotifyNonlinearVirtual}
   NotifyPointer = 5;
   {$EXTERNALSYM NotifyPointer}
   NotifyPointerRoot = 6;
   {$EXTERNALSYM NotifyPointerRoot}
   NotifyDetailNone = 7;
   {$EXTERNALSYM NotifyDetailNone}

{ Visibility notify  }
   VisibilityUnobscured = 0;
   {$EXTERNALSYM VisibilityUnobscured}
   VisibilityPartiallyObscured = 1;
   {$EXTERNALSYM VisibilityPartiallyObscured}
   VisibilityFullyObscured = 2;
   {$EXTERNALSYM VisibilityFullyObscured}

{ Circulation request  }
   PlaceOnTop = 0;
   {$EXTERNALSYM PlaceOnTop}
   PlaceOnBottom = 1;
   {$EXTERNALSYM PlaceOnBottom}

{ protocol families  }
   FamilyInternet = 0;
   {$EXTERNALSYM FamilyInternet}
   FamilyDECnet = 1;
   {$EXTERNALSYM FamilyDECnet}
   FamilyChaos = 2;
   {$EXTERNALSYM FamilyChaos}

{ Property notification  }
   PropertyNewValue = 0;
   {$EXTERNALSYM PropertyNewValue}
   PropertyDelete = 1;
   {$EXTERNALSYM PropertyDelete}

{ Color Map notification  }
   ColormapUninstalled = 0;
   {$EXTERNALSYM ColormapUninstalled}
   ColormapInstalled = 1;
   {$EXTERNALSYM ColormapInstalled}

{ GrabPointer, GrabButton, GrabKeyboard, GrabKey Modes  }
   GrabModeSync = 0;
   {$EXTERNALSYM GrabModeSync}
   GrabModeAsync = 1;
   {$EXTERNALSYM GrabModeAsync}

{ GrabPointer, GrabKeyboard reply status  }
   GrabSuccess = 0;
   {$EXTERNALSYM GrabSuccess}
   AlreadyGrabbed = 1;
   {$EXTERNALSYM AlreadyGrabbed}
   GrabInvalidTime = 2;
   {$EXTERNALSYM GrabInvalidTime}
   GrabNotViewable = 3;
   {$EXTERNALSYM GrabNotViewable}
   GrabFrozen = 4;
   {$EXTERNALSYM GrabFrozen}

{ AllowEvents modes  }
   AsyncPointer = 0;
   {$EXTERNALSYM AsyncPointer}
   SyncPointer = 1;
   {$EXTERNALSYM SyncPointer}
   ReplayPointer = 2;
   {$EXTERNALSYM ReplayPointer}
   AsyncKeyboard = 3;
   {$EXTERNALSYM AsyncKeyboard}
   SyncKeyboard = 4;
   {$EXTERNALSYM SyncKeyboard}
   ReplayKeyboard = 5;
   {$EXTERNALSYM ReplayKeyboard}
   AsyncBoth = 6;
   {$EXTERNALSYM AsyncBoth}
   SyncBoth = 7;
   {$EXTERNALSYM SyncBoth}

{ Used in SetInputFocus, GetInputFocus  }
function RevertToNone: Longint;
{$EXTERNALSYM RevertToNone}
function RevertToPointerRoot: Longint;
{$EXTERNALSYM RevertToPointerRoot}

const
  RevertToParent = 2;
  {$EXTERNALSYM RevertToParent}

{ ERROR CODES }
{ everything's okay  }
  Success = 0;
  {$EXTERNALSYM Success}
{ bad request code  }
  BadRequest = 1;
  {$EXTERNALSYM BadRequest}
{ int parameter out of range  }
  BadValue = 2;
  {$EXTERNALSYM BadValue}
{ parameter not a Window  }
  BadWindow = 3;
  {$EXTERNALSYM BadWindow}
{ parameter not a Pixmap  }
  BadPixmap = 4;
  {$EXTERNALSYM BadPixmap}
{ parameter not an Atom  }
  BadAtom = 5;
  {$EXTERNALSYM BadAtom}
{ parameter not a Cursor  }
  BadCursor = 6;
  {$EXTERNALSYM BadCursor}
{ parameter not a Font  }
  BadFont = 7;
  {$EXTERNALSYM BadFont}
{ parameter mismatch  }
  BadMatch = 8;
  {$EXTERNALSYM BadMatch}
{ parameter not a Pixmap or Window  }
  BadDrawable = 9;
  {$EXTERNALSYM BadDrawable}
{ depending on context:
  - key/button already grabbed
  - attempt to free an illegal 
    cmap entry 
  - attempt to store into a read-only 
    color map entry.
  - attempt to modify the access control
    list from other than the local host.
 }
  BadAccess = 10;
  {$EXTERNALSYM BadAccess}
{ insufficient resources  }
  BadAlloc = 11;
  {$EXTERNALSYM BadAlloc}
{ no such colormap  }
  BadColor = 12;
  {$EXTERNALSYM BadColor}
{ parameter not a GC  }
  BadGC = 13;
  {$EXTERNALSYM BadGC}
{ choice not in range or already used  }
  BadIDChoice = 14;
  {$EXTERNALSYM BadIDChoice}
{ font or color name doesn't exist  }
  BadName = 15;
  {$EXTERNALSYM BadName}
{ Request length incorrect  }
  BadLength = 16;
  {$EXTERNALSYM BadLength}
{ server is defective  }
  BadImplementation = 17;
  {$EXTERNALSYM BadImplementation}
  FirstExtensionError = 128;
  {$EXTERNALSYM FirstExtensionError}
  LastExtensionError = 255;
  {$EXTERNALSYM LastExtensionError}

{ WINDOW DEFINITIONS }

{ Window classes used by CreateWindow  }
{ Note that CopyFromParent is already defined as 0 above  }
  InputOutput = 1;
  {$EXTERNALSYM InputOutput}
  InputOnly = 2;
  {$EXTERNALSYM InputOnly}

{ Window attributes for CreateWindow and ChangeWindowAttributes  }
  CWBackPixmap = 1 shl 0;
  {$EXTERNALSYM CWBackPixmap}
  CWBackPixel = 1 shl 1;
  {$EXTERNALSYM CWBackPixel}
  CWBorderPixmap = 1 shl 2;
  {$EXTERNALSYM CWBorderPixmap}
  CWBorderPixel = 1 shl 3;
  {$EXTERNALSYM CWBorderPixel}
  CWBitGravity = 1 shl 4;
  {$EXTERNALSYM CWBitGravity}
  CWWinGravity = 1 shl 5;
  {$EXTERNALSYM CWWinGravity}
  CWBackingStore = 1 shl 6;
  {$EXTERNALSYM CWBackingStore}
  CWBackingPlanes = 1 shl 7;
  {$EXTERNALSYM CWBackingPlanes}
  CWBackingPixel = 1 shl 8;
  {$EXTERNALSYM CWBackingPixel}
  CWOverrideRedirect = 1 shl 9;
  {$EXTERNALSYM CWOverrideRedirect}
  CWSaveUnder = 1 shl 10;
  {$EXTERNALSYM CWSaveUnder}
  CWEventMask = 1 shl 11;
  {$EXTERNALSYM CWEventMask}
  CWDontPropagate = 1 shl 12;
  {$EXTERNALSYM CWDontPropagate}
  CWColormap = 1 shl 13;
  {$EXTERNALSYM CWColormap}
  CWCursor = 1 shl 14;
  {$EXTERNALSYM CWCursor}

{ ConfigureWindow structure  }
  CWX = 1 shl 0;
  {$EXTERNALSYM CWX}
  CWY = 1 shl 1;
  {$EXTERNALSYM CWY}
  CWWidth = 1 shl 2;
  {$EXTERNALSYM CWWidth}
  CWHeight = 1 shl 3;
  {$EXTERNALSYM CWHeight}
  CWBorderWidth = 1 shl 4;
  {$EXTERNALSYM CWBorderWidth}
  CWSibling = 1 shl 5;
  {$EXTERNALSYM CWSibling}
  CWStackMode = 1 shl 6;
  {$EXTERNALSYM CWStackMode}

{ Bit Gravity  }
  ForgetGravity = 0;
  {$EXTERNALSYM ForgetGravity}
  NorthWestGravity = 1;
  {$EXTERNALSYM NorthWestGravity}
  NorthGravity = 2;
  {$EXTERNALSYM NorthGravity}
  NorthEastGravity = 3;
  {$EXTERNALSYM NorthEastGravity}
  WestGravity = 4;
  {$EXTERNALSYM WestGravity}
  CenterGravity = 5;
  {$EXTERNALSYM CenterGravity}
  EastGravity = 6;
  {$EXTERNALSYM EastGravity}
  SouthWestGravity = 7;
  {$EXTERNALSYM SouthWestGravity}
  SouthGravity = 8;
  {$EXTERNALSYM SouthGravity}
  SouthEastGravity = 9;
  {$EXTERNALSYM SouthEastGravity}
  StaticGravity = 10;
  {$EXTERNALSYM StaticGravity}

{ Window gravity + bit gravity above  }
  UnmapGravity = 0;
  {$EXTERNALSYM UnmapGravity}

{ Used in CreateWindow for backing-store hint  }
  NotUseful = 0;
  {$EXTERNALSYM NotUseful}
  WhenMapped = 1;
  {$EXTERNALSYM WhenMapped}
  Always = 2;
  {$EXTERNALSYM Always}

{ Used in GetWindowAttributes reply  }
  IsUnmapped = 0;
  {$EXTERNALSYM IsUnmapped}
  IsUnviewable = 1;
  {$EXTERNALSYM IsUnviewable}
  IsViewable = 2;
  {$EXTERNALSYM IsViewable}

{ Used in ChangeSaveSet  }
  SetModeInsert = 0;
  {$EXTERNALSYM SetModeInsert}
  SetModeDelete = 1;
  {$EXTERNALSYM SetModeDelete}

{ Used in ChangeCloseDownMode  }
  DestroyAll = 0;
  {$EXTERNALSYM DestroyAll}
  RetainPermanent = 1;
  {$EXTERNALSYM RetainPermanent}
  RetainTemporary = 2;
  {$EXTERNALSYM RetainTemporary}

{ Window stacking method (in configureWindow)  }
  Above = 0;
  {$EXTERNALSYM Above}
  Below = 1;
  {$EXTERNALSYM Below}
  TopIf = 2;
  {$EXTERNALSYM TopIf}
  BottomIf = 3;
  {$EXTERNALSYM BottomIf}
  Opposite = 4;
  {$EXTERNALSYM Opposite}

{ Circulation direction  }
  RaiseLowest = 0;
  {$EXTERNALSYM RaiseLowest}
  LowerHighest = 1;
  {$EXTERNALSYM LowerHighest}

{ Property modes  }
  PropModeReplace = 0;
  {$EXTERNALSYM PropModeReplace}
  PropModePrepend = 1;
  {$EXTERNALSYM PropModePrepend}
  PropModeAppend = 2;
  {$EXTERNALSYM PropModeAppend}

{ GRAPHICS DEFINITIONS }
{ graphics functions, as in GC.alu  }
  GXclear = $0;
  {$EXTERNALSYM GXclear}
  GXand = $1;
  {$EXTERNALSYM GXand}
  GXandReverse = $2;
  {$EXTERNALSYM GXandReverse}
  GXcopy = $3;
  {$EXTERNALSYM GXcopy}
  GXandInverted = $4;
  {$EXTERNALSYM GXandInverted}
  GXnoop = $5;
  {$EXTERNALSYM GXnoop}
  GXxor = $6;
  {$EXTERNALSYM GXxor}
  GXor = $7;
  {$EXTERNALSYM GXor}
  GXnor = $8;
  {$EXTERNALSYM GXnor}
  GXequiv = $9;
  {$EXTERNALSYM GXequiv}
  GXinvert = $a;
  {$EXTERNALSYM GXinvert}
  GXorReverse = $b;
  {$EXTERNALSYM GXorReverse}
  GXcopyInverted = $c;
  {$EXTERNALSYM GXcopyInverted}
  GXorInverted = $d;
  {$EXTERNALSYM GXorInverted}
  GXnand = $e;
  {$EXTERNALSYM GXnand}
  GXset = $f;
  {$EXTERNALSYM GXset}

{ LineStyle  }
  LineSolid = 0;
  {$EXTERNALSYM LineSolid}
  LineOnOffDash = 1;
  {$EXTERNALSYM LineOnOffDash}
  LineDoubleDash = 2;
  {$EXTERNALSYM LineDoubleDash}

{ capStyle  }
  CapNotLast = 0;
  {$EXTERNALSYM CapNotLast}
  CapButt = 1;
  {$EXTERNALSYM CapButt}
  CapRound = 2;
  {$EXTERNALSYM CapRound}
  CapProjecting = 3;
  {$EXTERNALSYM CapProjecting}

{ joinStyle  }
  JoinMiter = 0;
  {$EXTERNALSYM JoinMiter}
  JoinRound = 1;
  {$EXTERNALSYM JoinRound}
  JoinBevel = 2;
  {$EXTERNALSYM JoinBevel}

{ fillStyle  }
  FillSolid = 0;
  {$EXTERNALSYM FillSolid}
  FillTiled = 1;
  {$EXTERNALSYM FillTiled}
  FillStippled = 2;
  {$EXTERNALSYM FillStippled}
  FillOpaqueStippled = 3;
  {$EXTERNALSYM FillOpaqueStippled}

{ fillRule  }
  EvenOddRule = 0;
  {$EXTERNALSYM EvenOddRule}
  WindingRule = 1;
  {$EXTERNALSYM WindingRule}

{ subwindow mode  }
  ClipByChildren = 0;
  {$EXTERNALSYM ClipByChildren}
  IncludeInferiors = 1;
  {$EXTERNALSYM IncludeInferiors}

{ SetClipRectangles ordering  }
  Unsorted = 0;
  {$EXTERNALSYM Unsorted}
  YSorted = 1;
  {$EXTERNALSYM YSorted}
  YXSorted = 2;
  {$EXTERNALSYM YXSorted}
  YXBanded = 3;
  {$EXTERNALSYM YXBanded}

{ CoordinateMode for drawing routines  }
{ relative to the origin  }
  CoordModeOrigin = 0;
  {$EXTERNALSYM CoordModeOrigin}
{ relative to previous point  }
  CoordModePrevious = 1;
  {$EXTERNALSYM CoordModePrevious}

{ Polygon shapes  }
{ paths may intersect  }
  Complex = 0;
  {$EXTERNALSYM Complex}
  { no paths intersect, but not convex  }
  Nonconvex = 1;
  {$EXTERNALSYM Nonconvex}
{ wholly convex  }
  Convex = 2;
  {$EXTERNALSYM Convex}

{ Arc modes for PolyFillArc  }
{ join endpoints of arc  }
  ArcChord = 0;
  {$EXTERNALSYM ArcChord}
{ join endpoints to center of arc  }
  ArcPieSlice = 1;
  {$EXTERNALSYM ArcPieSlice}

{ GC components: masks used in CreateGC, CopyGC, ChangeGC, OR'ed into
  GC.stateChanges  }
  GCFunction = 1 shl 0;
  {$EXTERNALSYM GCFunction}
  GCPlaneMask = 1 shl 1;
  {$EXTERNALSYM GCPlaneMask}
  GCForeground = 1 shl 2;
  {$EXTERNALSYM GCForeground}
  GCBackground = 1 shl 3;
  {$EXTERNALSYM GCBackground}
  GCLineWidth = 1 shl 4;
  {$EXTERNALSYM GCLineWidth}
  GCLineStyle = 1 shl 5;
  {$EXTERNALSYM GCLineStyle}
  GCCapStyle = 1 shl 6;
  {$EXTERNALSYM GCCapStyle}
  GCJoinStyle = 1 shl 7;
  {$EXTERNALSYM GCJoinStyle}
  GCFillStyle = 1 shl 8;
  {$EXTERNALSYM GCFillStyle}
  GCFillRule = 1 shl 9;
  {$EXTERNALSYM GCFillRule}
  GCTile = 1 shl 10;
  {$EXTERNALSYM GCTile}
  GCStipple = 1 shl 11;
  {$EXTERNALSYM GCStipple}
  GCTileStipXOrigin = 1 shl 12;
  {$EXTERNALSYM GCTileStipXOrigin}
  GCTileStipYOrigin = 1 shl 13;
  {$EXTERNALSYM GCTileStipYOrigin}
  GCFont = 1 shl 14;
  {$EXTERNALSYM GCFont}
  GCSubwindowMode = 1 shl 15;
  {$EXTERNALSYM GCSubwindowMode}
  GCGraphicsExposures = 1 shl 16;
  {$EXTERNALSYM GCGraphicsExposures}
  GCClipXOrigin = 1 shl 17;
  {$EXTERNALSYM GCClipXOrigin}
  GCClipYOrigin = 1 shl 18;
  {$EXTERNALSYM GCClipYOrigin}
  GCClipMask = 1 shl 19;
  {$EXTERNALSYM GCClipMask}
  GCDashOffset = 1 shl 20;
  {$EXTERNALSYM GCDashOffset}
  GCDashList = 1 shl 21;
  {$EXTERNALSYM GCDashList}
  GCArcMode = 1 shl 22;
  {$EXTERNALSYM GCArcMode}
  GCLastBit = 22;
  {$EXTERNALSYM GCLastBit}

{ FONTS }

{ used in QueryFont -- draw direction  }
  FontLeftToRight = 0;
  {$EXTERNALSYM FontLeftToRight}
  FontRightToLeft = 1;
  {$EXTERNALSYM FontRightToLeft}
  FontChange = 255;
  {$EXTERNALSYM FontChange}

{ IMAGING }

{ ImageFormat -- PutImage, GetImage  }
{ depth 1, XYFormat  }
  XYBitmap = 0;
  {$EXTERNALSYM XYBitmap}
{ depth == drawable depth  }
  XYPixmap = 1;
  {$EXTERNALSYM XYPixmap}
{ depth == drawable depth  }
  ZPixmap = 2;
  {$EXTERNALSYM ZPixmap}

{ COLOR MAP STUFF }

{ For CreateColormap  }
{ create map with no entries  }
  AllocNone = 0;
  {$EXTERNALSYM AllocNone}
{ allocate entire map writeable  }
  AllocAll = 1;
  {$EXTERNALSYM AllocAll}

{ Flags used in StoreNamedColor, StoreColors  }
  DoRed = 1 shl 0;
  {$EXTERNALSYM DoRed}
  DoGreen = 1 shl 1;
  {$EXTERNALSYM DoGreen}
  DoBlue = 1 shl 2;
  {$EXTERNALSYM DoBlue}

{ CURSOR STUFF }

{ QueryBestSize Class  }
{ largest size that can be displayed  }
  CursorShape = 0;
  {$EXTERNALSYM CursorShape}
{ size tiled fastest  }
  TileShape = 1;
  {$EXTERNALSYM TileShape}
{ size stippled fastest  }
  StippleShape = 2;
  {$EXTERNALSYM StippleShape}

{ KEYBOARD/POINTER STUFF }

  AutoRepeatModeOff = 0;
  {$EXTERNALSYM AutoRepeatModeOff}
  AutoRepeatModeOn = 1;
  {$EXTERNALSYM AutoRepeatModeOn}
  AutoRepeatModeDefault = 2;
  {$EXTERNALSYM AutoRepeatModeDefault}
  LedModeOff = 0;
  {$EXTERNALSYM LedModeOff}
  LedModeOn = 1;
  {$EXTERNALSYM LedModeOn}

{ masks for ChangeKeyboardControl  }
  KBKeyClickPercent = 1 shl 0;
  {$EXTERNALSYM KBKeyClickPercent}
  KBBellPercent = 1 shl 1;
  {$EXTERNALSYM KBBellPercent}
  KBBellPitch = 1 shl 2;
  {$EXTERNALSYM KBBellPitch}
  KBBellDuration = 1 shl 3;
  {$EXTERNALSYM KBBellDuration}
  KBLed = 1 shl 4;
  {$EXTERNALSYM KBLed}
  KBLedMode = 1 shl 5;
  {$EXTERNALSYM KBLedMode}
  KBKey = 1 shl 6;
  {$EXTERNALSYM KBKey}
  KBAutoRepeatMode = 1 shl 7;
  {$EXTERNALSYM KBAutoRepeatMode}
  MappingSuccess = 0;
  {$EXTERNALSYM MappingSuccess}
  MappingBusy = 1;
  {$EXTERNALSYM MappingBusy}
  MappingFailed = 2;
  {$EXTERNALSYM MappingFailed}
  MappingModifier = 0;
  {$EXTERNALSYM MappingModifier}
  MappingKeyboard = 1;
  {$EXTERNALSYM MappingKeyboard}
  MappingPointer = 2;
  {$EXTERNALSYM MappingPointer}

{ SCREEN SAVER STUFF }
  DontPreferBlanking = 0;
  {$EXTERNALSYM DontPreferBlanking}
  PreferBlanking = 1;
  {$EXTERNALSYM PreferBlanking}
  DefaultBlanking = 2;
  {$EXTERNALSYM DefaultBlanking}
  DisableScreenSaver = 0;
  {$EXTERNALSYM DisableScreenSaver}
  DisableScreenInterval = 0;
  {$EXTERNALSYM DisableScreenInterval}
  DontAllowExposures = 0;
  {$EXTERNALSYM DontAllowExposures}
  AllowExposures = 1;
  {$EXTERNALSYM AllowExposures}
  DefaultExposures = 2;
  {$EXTERNALSYM DefaultExposures}

{ for ForceScreenSaver  }
  ScreenSaverReset = 0;
  {$EXTERNALSYM ScreenSaverReset}
  ScreenSaverActive = 1;
  {$EXTERNALSYM ScreenSaverActive}

{ HOSTS AND CONNECTIONS }

{ for ChangeHosts  }
  HostInsert = 0;
  {$EXTERNALSYM HostInsert}
  HostDelete = 1;
  {$EXTERNALSYM HostDelete}

{ for ChangeAccessControl  }
  EnableAccess = 1;
  {$EXTERNALSYM EnableAccess}
  DisableAccess = 0;
  {$EXTERNALSYM DisableAccess}

{ Display classes  used in opening the connection
  Note that the statically allocated ones are even numbered and the
  dynamically changeable ones are odd numbered  }

  StaticGray = 0;
  {$EXTERNALSYM StaticGray}
  GrayScale = 1;
  {$EXTERNALSYM GrayScale}
  StaticColor = 2;
  {$EXTERNALSYM StaticColor}
  PseudoColor = 3;
  {$EXTERNALSYM PseudoColor}
  TrueColor = 4;
  {$EXTERNALSYM TrueColor}
  DirectColor = 5;
  {$EXTERNALSYM DirectColor}

{ Byte order  used in imageByteOrder and bitmapBitOrder  }
  LSBFirst = 0;
  {$EXTERNALSYM LSBFirst}
  MSBFirst = 1;
  {$EXTERNALSYM MSBFirst}

  { Xlib.h }

{
  Xlib.h - Header definition and support file for the C subroutine
  interface library (Xlib) to the X Window System Protocol (V11).
  Structures and symbols starting with "_" are private to the library.
}

const
  XlibSpecificationRelease = 6;
  {$EXTERNALSYM XlibSpecificationRelease}

type
  Pwchar_t = Libc.Pwchar_t;
  {$EXTERNALSYM Pwchar_t}
  wchar_t = Libc.wchar_t;
  {$EXTERNALSYM wchar_t}
  PPwchar_t = Libc.PPwchar_t;
  {$EXTERNALSYM PPwchar_t}
  PPPwchar_t = ^PPwchar_t;
  {$EXTERNALSYM PPPwchar_t}
  
type
  PXPointer = ^XPointer;
  {$EXTERNALSYM PXPointer}
  XPointer = PChar;
  {$EXTERNALSYM XPointer}

  Bool = Longint;
  {$EXTERNALSYM Bool}
  PBool = ^Bool;
  {$EXTERNALSYM PBool}
  PStatus = ^TStatus;
  {$EXTERNALSYM PStatus}
  TStatus = Integer;
  {$EXTERNALSYM TStatus}

  PPPChar = ^PPChar;
  {$EXTERNALSYM PPPChar}
  PPLongint = ^PLongint;
  {$EXTERNALSYM PPLongint}
  PPByte = ^PByte;
  {$EXTERNALSYM PPByte}

const
  XTrue              = 1;
  {$EXTERNALSYM XTrue}
  XFalse             = 0;
  {$EXTERNALSYM XFalse}
  QueuedAlready      = 0;
  {$EXTERNALSYM QueuedAlready}
  QueuedAfterReading = 1;
  {$EXTERNALSYM QueuedAfterReading}
  QueuedAfterFlush   = 2;
  {$EXTERNALSYM QueuedAfterFlush}

const
  AllPlanes: LongWord = 0;
  {$EXTERNALSYM AllPlanes}

{ Extensions need a way to hang private data on some structures. }

type
  PXExtData = ^XExtData;
  {$EXTERNALSYM PXExtData}
  TXExtDataProc = function (Extension: PXExtData): Longint; cdecl;
  {$EXTERNALSYM TXExtDataProc}
  XExtData = record
    number: Longint;             { number returned by XRegisterExtension  }
    next: PXExtData;             { next item on list of data for structure  }
    free_private: TXExtDataProc; { called to free private storage  }
    private_data: XPointer;      { data private to this extension.  }
  end;
  {$EXTERNALSYM XExtData}
  PPXExtData = ^PXExtData;
  {$EXTERNALSYM PPXExtData}

{ This file contains structures used by the extension mechanism. }
    { public to extension, cannot be changed  }
    { extension number  }
    { major op-code assigned by server  }
    { first event number for the extension  }
    { first error number for the extension  }

  PXExtCodes = ^XExtCodes;
  {$EXTERNALSYM PXExtCodes}
  XExtCodes = record
    extension: Longint;
    major_opcode: Longint;
    first_event: Longint;
    first_error: Longint;
  end;
  {$EXTERNALSYM XExtCodes}

{ Data structure for retrieving info about pixmap formats. }

  PXPixmapFormatValues = ^XPixmapFormatValues;
  {$EXTERNALSYM PXPixmapFormatValues}
  XPixmapFormatValues = record
    depth: Longint;
    bits_per_pixel: Longint;
    scanline_pad: Longint;
  end;
  {$EXTERNALSYM XPixmapFormatValues}

{ Data structure for setting graphics context. }

  PXGCValues = ^XGCValues;
  {$EXTERNALSYM PXGCValues}
  XGCValues = record
    xfunction: Longint;       { logical operation  }
    plane_mask: Cardinal;     { plane mask  }
    foreground: Cardinal;     { foreground pixel  }
    background: Cardinal;     { background pixel  }
    line_width: Longint;      { line width  }
    line_style: Longint;      { LineSolid, LineOnOffDash, LineDoubleDash  }
    cap_style: Longint;       { CapNotLast, CapButt, CapRound, CapProjecting  }
    join_style: Longint;      { JoinMiter, JoinRound, JoinBevel  }
    fill_style: Longint;      { FillSolid, FillTiled, FillStippled, FillOpaeueStippled  }
    fill_rule: Longint;       { EvenOddRule, WindingRule  }
    arc_mode: Longint;        { ArcChord, ArcPieSlice  }
    tile: TPixmap;            { tile pixmap for tiling operations  }
    stipple: TPixmap;         { stipple 1 plane pixmap for stipping  }
    ts_x_origin: Longint;     { offset for tile or stipple operations  }
    ts_y_origin:  Longint;
    font: TFont;              { default text font for text operations}
    subwindow_mode: Longint;  { ClipByChildren, IncludeInferiors  }
    graphics_exposures: Bool; { boolean, should exposures be generated  }
    clip_x_origin: Longint;   { origin for clipping  }
    clip_y_origin: Longint;
    clip_mask: TPixmap;       { bitmap clipping; other calls for rects  }
    dash_offset: Longint;     { patterned/dashed line information  }
    dashes: Char;
  end;
  {$EXTERNALSYM XGCValues}

{ Graphics context.  The contents of this structure are implementation
       dependent.  A GC should be treated as opaque by application code. }

type
  GC  = ^TGC;
  {$EXTERNALSYM GC}
  TGC = ^XGC;
  {$EXTERNALSYM TGC}
  XGC = record
    ext_data: PXExtData; { hook for extension to hang data  }
    gid: TGContext;  { protocol ID for graphics context  }
    { there is more to this structure, but it is private to Xlib  }
  end;
  {$EXTERNALSYM XGC}

{ Visual structure; contains information about colormapping possible. }

type
  PVisual = ^Visual;
  {$EXTERNALSYM PVisual}
  Visual = record
    ext_data: PXExtData;  { hook for extension to hang data  }
    visualid: VisualID;   { visual id of this visual  }
    c_class: Longint;
    xclass: Longint;
    red_mask: Cardinal;
    green_mask: Cardinal;
    blue_mask: Cardinal;
    bits_per_rgb: Longint;
    map_entries: Longint;
  end;
  {$EXTERNALSYM Visual}

{ Depth structure; contains information for each possible depth. }

  PDepth = ^Depth;
  {$EXTERNALSYM PDepth}
  Depth = record
    depth: Longint;    { this depth (Z) of the depth  }
    nvisuals: Longint; { number of Visual types at this depth  }
    visuals: PVisual;  { list of visuals possible at this depth  }
  end;
  {$EXTERNALSYM Depth}

{ Information about the screen.  The contents of this structure are
  implementation dependent.  A Screen should be treated as opaque
  by application code. }

  PXDisplay = ^XDisplay;
  {$EXTERNALSYM PXDisplay}
  XDisplay = record
  end;
  {$EXTERNALSYM XDisplay}  

  PScreen = ^Screen;
  {$EXTERNALSYM PScreen}
  Screen = record
    ext_data: PXExtData;      { hook for extension to hang data  }
    display: PXDisplay;       { back pointer to display structure  }
    root: TWindow;            { Root window id.  }
    width: Longint;           { width and height of screen  }
    height: Longint;
    mwidth: Longint;          { width and height of  in millimeters  }
    mheight: Longint;
    ndepths: Longint;         { number of depths possible  }
    depths: PDepth;           { list of allowable depths on the screen  }
    root_depth: Longint;      { bits per pixel  }
    root_visual: PVisual;     { root visual }
    default_gc: TGC;          { GC for the root root visual  }
    cmap: TColorMap;          { default color map  }
    white_pixel: Cardinal;    { White and Black pixel values  }
    black_pixel: Cardinal;    { max and min color maps  }
    max_maps: Longint;
    min_maps: Longint;
    backing_store: Longint;
    save_unders: Bool;        { Never, WhenMapped, Always  }
    root_input_mask: Longint; { initial root input mask  }
  end;
  {$EXTERNALSYM Screen}

{ Format structure; describes ZFormat data the screen will understand. }
    
  PScreenFormat = ^ScreenFormat;
  {$EXTERNALSYM PScreenFormat}
  ScreenFormat = record
    ext_data: PXExtData; { hook for extension to hang data  }
    depth: Longint;  { depth of this image format  }
    bits_per_pixel: Longint; { bits/pixel at this depth  }
    scanline_pad: Longint; { scanline must padded to this multiple }
  end;
  {$EXTERNALSYM ScreenFormat}

{ Data structure for setting window attributes. }

  PXSetWindowAttributes = ^XSetWindowAttributes;
  {$EXTERNALSYM PXSetWindowAttributes}
  XSetWindowAttributes = record
    background_pixmap: TPixmap;     { background or None or ParentRelative  }
    background_pixel: Cardinal;     { background pixel  }
    border_pixmap: TPixmap;         { border of the window  }
    border_pixel: Cardinal;         { border pixel value }
    bit_gravity: Longint;           { one of bit gravity values  }
    win_gravity: Longint;           { one of the window gravity values  }
    backing_store: Longint;         { NotUseful, WhenMapped, Always  }
    backing_planes: Cardinal;       { planes to be preseved if possible  }
    backing_pixel: Cardinal;        { value to use in restoring planes  }
    save_under: Bool;               { should bits under be saved? (popups)  }
    event_mask: Longint;            { set of events that should be saved  }
    do_not_propagate_mask: Longint; { set of events that should not propagate  }
    override_redirect: Bool;        { boolean value for override-redirect  }
    colormap: TColorMap;            { color map to be associated with window  }
    cursor: TCursor;                { cursor to be displayed (or None)  }
  end;
  {$EXTERNALSYM XSetWindowAttributes}

type
  PXWindowAttributes = ^XWindowAttributes;
  {$EXTERNALSYM PXWindowAttributes}
  XWindowAttributes = record
    x: Longint;                     { location of window  }
    y: Longint;
    width: Longint;                 { width and height of window  }
    height: Longint;
    border_width: Longint;          { border width of window  }
    depth: Longint;                 { depth of window  }
    visual: PVisual;                { the associated visual structure  }
    root: TWindow;                  { root of screen containing window  }
    xclass: Longint;                { InputOutput, InputOnly }
    bit_gravity: Longint;           { one of bit gravity values  }
    win_gravity: Longint;           { one of the window gravity values  }
    backing_store: Longint;         { NotUseful, WhenMapped, Always  }
    backing_planes: Cardinal;       { planes to be preserved if possible  }
    backing_pixel: Cardinal;        { value to be used when restoring planes  }
    save_under: Bool;               { boolean, should bits under be saved?  }
    colormap: TColormap;            { color map to be associated with window }
    map_installed: Bool;            { boolean, is color map currently installed}
    map_state: Longint;             { IsUnmapped, IsUnviewable, IsViewable  }
    all_event_masks: Longint;       { set of events all people have interest in }
    your_event_mask: Longint;       { my event mask  }
    do_not_propagate_mask: Longint; { set of events that should not propagate  }
    override_redirect: Bool;        { boolean value for override-redirect  }
    screen: PScreen;                { back pointer to correct screen  }
  end;
  {$EXTERNALSYM XWindowAttributes}

{ Data structure for host setting; getting routines. }

  PXHostAddress = ^XHostAddress;
  {$EXTERNALSYM PXHostAddress}
  XHostAddress = record
    family: Longint;  { for example FamilyInternet  }
    length: Longint;  { length of address, in bytes  }
    address: PChar;   { pointer to where to find the bytes  }
  end;
  {$EXTERNALSYM XHostAddress}

{ Data structure for "image" data, used by image manipulation routines. }

type
  PXImage = ^XImage;
  {$EXTERNALSYM PXImage}

  TXImageCreateImageProc = function (display: PXDisplay; visual: PVisual;
    depth: Cardinal; format: Longint; offset: Longint; data: PChar;
    width: Cardinal; height: Cardinal; bitmap_pad: Longint;
    bytes_per_line: Longint): PXImage; cdecl;
  {$EXTERNALSYM TXImageCreateImageProc}
  TXImageDestroyImageProc = function (XImage: PXImage): Longint; cdecl;
  {$EXTERNALSYM TXImageDestroyImageProc}
  TXImageGetPixelProc = function (XImage: PXImage; X: Longint; Y: Longint): Cardinal; cdecl;
  {$EXTERNALSYM TXImageGetPixelProc}
  TXImagePutPixelProc = function (XImage: PXImage; X: Longint; Y: Longint;
    Pixel: Cardinal): Longint; cdecl;
  {$EXTERNALSYM TXImagePutPixelProc}
  TXImageSubImageProc = function (XImage: PXImage; X: Longint; Y: Longint;
    SubImageWidth: Cardinal; SubImageHeight: Cardinal): PXImage; cdecl;
  {$EXTERNALSYM TXImageSubImageProc}
  TXImageAddPixelProc = function (XImage: PXImage; Value: Longint): Longint; cdecl;
  {$EXTERNALSYM TXImageAddPixelProc}

  XImage = record
    width: Longint;  { size of image  }
    height: Longint;
    xoffset: Longint; { number of pixels offset in X direction  }
    format: Longint;  { XYBitmap, XYPixmap, ZPixmap  }
    data: PChar;      { pointer to image data  }
    byte_order: Longint; { data byte order, LSBFirst, MSBFirst  }
    bitmap_unit: Longint;  { quant. of scanline 8, 16, 32  }
    bitmap_bit_order: Longint; { LSBFirst, MSBFirst  }
    bitmap_pad: Longint;       { 8, 16, 32 either XY or ZPixmap  }
    depth: Longint;            { depth of image  }
    bytes_per_line: Longint;   { accelarator to next line  }
    bits_per_pixel: Longint;   { bits per pixel (ZPixmap)  }
    red_mask: Cardinal;        { bits in z arrangment  }
    green_mask: Cardinal;
    blue_mask: Cardinal;
    obdata: XPointer;          { hook for the object routines to hang on  }
    f: record                  { image manipulation routines  }
         create_image: TXImageCreateImageProc;
         destroy_image: TXImageDestroyImageProc;
         get_pixel: TXImageGetPixelProc;
         put_pixel: TXImagePutPixelProc;
         sub_image: TXImageSubImageProc;
         add_pixel: TXImageAddPixelProc;
      end;
  end;
  {$EXTERNALSYM XImage}

{ Data structure for XReconfigureWindow }
  PXWindowChanges = ^XWindowChanges;
  {$EXTERNALSYM PXWindowChanges}
  XWindowChanges = record
    x: Longint;
    y: Longint;
    width: Longint;
    height: Longint;
    border_width: Longint;
    sibling: TWindow;
    stack_mode: Longint;
  end;
  {$EXTERNALSYM XWindowChanges}

{ Data structure used by color operations }
    
  PXColor = ^XColor;
  {$EXTERNALSYM PXColor}
  XColor = record
    pixel: Cardinal;
    red: Word;     
    green: Word;
    blue: Word;
    flags: Char; { do_red, do_green, do_blue  }
    pad: Char;
  end;
  {$EXTERNALSYM XColor}

{
  Data structures for graphics operations.  On most machines, these are
  congruent with the wire protocol structures, so reformatting the data
  can be avoided on these architectures.
}
  PXSegment = ^XSegment;
  {$EXTERNALSYM PXSegment}
  XSegment = record
    x1: SmallInt;
    y1: SmallInt;
    x2: SmallInt;
    y2: SmallInt;
  end;
  {$EXTERNALSYM XSegment}

  PXPoint = ^XPoint;
  {$EXTERNALSYM PXPoint}
  XPoint = record
    x: SmallInt;
    y: SmallInt;
  end;
  {$EXTERNALSYM XPoint}

  PXRectangle = ^XRectangle;
  {$EXTERNALSYM PXRectangle}
  XRectangle = record
    x: SmallInt;
    y: SmallInt;
    width: Word;
    height: Word;
  end;
  {$EXTERNALSYM XRectangle}

  PXArc = ^XArc;
  {$EXTERNALSYM PXArc}
  XArc = record
    x: SmallInt;
    y: SmallInt;
    width: Word;
    height: Word;
    angle1: SmallInt;
    angle2: SmallInt;
  end;
  {$EXTERNALSYM XArc}

{ Data structure for XChangeKeyboardControl  }
    
  PXKeyboardControl = ^XKeyboardControl;
  {$EXTERNALSYM PXKeyboardControl}
  XKeyboardControl = record
    key_click_percent: Longint;
    bell_percent: Longint;
    bell_pitch: Longint;
    bell_duration: Longint;
    led: Longint;
    led_mode: Longint;
    key: Longint;
    auto_repeat_mode: Longint; { On, Off, Default  }
  end;
  {$EXTERNALSYM XKeyboardControl}

{ Data structure for XGetKeyboardControl  }

  PXKeyboardState = ^XKeyboardState;
  {$EXTERNALSYM PXKeyboardState}
  XKeyboardState = record
    key_click_percent: Longint;
    bell_percent: Longint;
    bell_pitch: Cardinal;
    bell_duration: Cardinal;
    led_mask: Cardinal;
    global_auto_repeat: Longint;
    auto_repeats: array[0..31] of Char;
  end;
  {$EXTERNALSYM XKeyboardState}

{ Data structure for XGetMotionEvents.   }

  PXTimeCoord = ^XTimeCoord;
  {$EXTERNALSYM PXTimeCoord}
  XTimeCoord = record
    time: TTime;
    x: SmallInt;
    y: SmallInt;
  end;
  {$EXTERNALSYM XTimeCoord}

{ Data structure for X(Set,Get)ModifierMapping  }

  PXModifierKeymap = ^XModifierKeymap;
  {$EXTERNALSYM PXModifierKeymap}
  XModifierKeymap = record
    max_keypermod: Longint; { The server's max # of keys per modifier  }
    modifiermap: PKeyCode;  { An 8 by max_keypermod array of modifiers  }
  end;
  {$EXTERNALSYM XModifierKeymap}
  
{
  Display datatype maintaining display specific data.
  The contents of this structure are implementation dependent.
  A Display should be treated as opaque by application code.
}

type
  PXPrivate = ^XPrivate;
  {$EXTERNALSYM PXPrivate}
  XPrivate = record
  end;
  {$EXTERNALSYM XPrivate}

{ Forward declare before use for C++  }
  PXrmHashBucketRec = ^XrmHashBucketRec;
  {$EXTERNALSYM PXrmHashBucketRec}
  XrmHashBucketRec = record
  end;
  {$EXTERNALSYM XrmHashBucketRec}

type
  TDisplayResourceAllocProc = function (XDisplay: PXDisplay): XID; cdecl;
  {$EXTERNALSYM TDisplayResourceAllocProc}
  TDisplayPrivate15Proc = function (_para1: PXDisplay): Longint; cdecl;
  {$EXTERNALSYM TDisplayPrivate15Proc}

  PDisplay = ^Display;
  Display = record
    ext_data: PXExtData; { hook for extension to hang data  }
    private1: PXPrivate;
    fd: Longint;         { Network socket.  }
    private2: Longint;
    proto_major_version: Longint; { major version of server's X protocol  }
    proto_minor_version: Longint; { minor version of servers X protocol  }
    vendor: PChar;                { vendor of the server hardware  }
    private3: XID;
    private4: XID;
    private5: XID;
    private6: Longint;
    resource_alloc: TDisplayResourceAllocProc; { allocator function  }
    byte_order: Longint;     { screen byte order, LSBFirst, MSBFirst  }
    bitmap_unit: Longint;    { padding and data requirements  }
    bitmap_pad: Longint;     { padding requirements on bitmaps  }
    bitmap_bit_order: Longint; { LeastSignificant or MostSignificant  }
    nformats: Longint;         { number of pixmap formats in list  }
    pixmap_format: PScreenFormat;  { pixmap format list  }
    private8: Longint;
    release: Longint;              { release of the server  }
    private9: PXPrivate;
    private10: PXPrivate;
    qlen: Longint;                 { Length of input event queue  }
    last_request_read: Cardinal;   { seq number of last event read  }
    request: Cardinal;             { sequence number of last request.  }
    private11: XPointer;
    private12: XPointer;
    private13: XPointer;
    private14: XPointer;
    max_request_size: Cardinal;    { maximum number 32 bit words in request }
    db: PXrmHashBucketRec;
    private15: TDisplayPrivate15Proc;
    display_name: PChar; { "host:display" string used on this connect }
    default_screen: Longint; { default screen for operations  }
    nscreens: Longint;       { number of screens on this server }
    screens: PScreen;        { pointer to list of screens  }
    motion_buffer: Cardinal; { size of motion buffer  }
    private16: Cardinal;
    min_keycode: Longint;    { minimum defined keycode  }
    max_keycode: Longint;    { maximum defined keycode  }
    private17: XPointer;
    private18: XPointer;
    private19: Longint;
    xdefaults: PChar;        { contents of defaults from server  }
    { there is more to this structure, but it is private to Xlib  }
  end;
  {$EXTERNALSYM Display}

  _XPrivDisplay = PDisplay;
  {$EXTERNALSYM _XPrivDisplay}

  _XDisplay = Display;
  {$EXTERNALSYM _XDisplay}

{ Definitions of specific events. }

type
  PXKeyEvent = ^XKeyEvent;
  {$EXTERNALSYM PXKeyEvent}
  XKeyEvent = record
    xtype: Longint;   { of event  }
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool; { true if this came from a SendEvent request  }
    xdisplay: PDisplay;  { Display the event was read from  }
    xwindow: TWindow;      { "event" window it is reported relative to  }
    root: TWindow;         { root window that the event occurred on  }
    subwindow: TWindow;    { child window  }
    time: TTime;           { milliseconds  }
    x: Longint;           { pointer x, y coordinates in event window  }
    y: Longint;
    x_root: Longint;      { coordinates relative to root  }
    y_root: Longint;
    state: Cardinal;      { key or button mask  }
    keycode: Cardinal;    { detail  }
    same_screen: Bool;    { same screen flag  }
  end;
  {$EXTERNALSYM XKeyEvent}

  PXKeyPressedEvent = ^XKeyEvent;
  {$EXTERNALSYM PXKeyPressedEvent}
  XKeyPressedEvent = XKeyEvent;
  {$EXTERNALSYM XKeyPressedEvent}

  PXKeyReleasedEvent = ^XKeyEvent;
  {$EXTERNALSYM PXKeyReleasedEvent}
  XKeyReleasedEvent = XKeyEvent;
  {$EXTERNALSYM XKeyReleasedEvent}

  PXButtonEvent = ^XButtonEvent;
  {$EXTERNALSYM PXButtonEvent}
  XButtonEvent = record
    xtype: Longint;  { of event  }
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    xdisplay: PDisplay; { Display the event was read from  }
    xwindow: TWindow;    { "event" window it is reported relative to  }
    root: TWindow;       { root window that the event occurred on  }
    subwindow: TWindow;  { child window  }
    time: TTime;         { milliseconds  }
    x: Longint;         { pointer x, y coordinates in event window  }
    y: Longint;
    x_root: Longint;    { coordinates relative to root  }
    y_root: Longint;
    state: Cardinal;     { key or button mask  }
    button: Cardinal;   { detail  }
    same_screen: Bool;  { same screen flag  }
  end;
  {$EXTERNALSYM XButtonEvent}

  PXButtonPressedEvent = ^XButtonEvent;
  {$EXTERNALSYM PXButtonPressedEvent}
  XButtonPressedEvent = XButtonEvent;
  {$EXTERNALSYM XButtonPressedEvent}

  PXButtonReleasedEvent = ^XButtonReleasedEvent;
  {$EXTERNALSYM PXButtonReleasedEvent}
  XButtonReleasedEvent = XButtonEvent;
  {$EXTERNALSYM XButtonReleasedEvent}

  PXMotionEvent = ^XMotionEvent;
  {$EXTERNALSYM PXMotionEvent}
  XMotionEvent = record
    xtype: Longint;  { of event  }
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool; { true if this came from a SendEvent request  }
    xdisplay: PDisplay;  { Display the event was read from  }
    xwindow: TWindow;     { "event" window reported relative to  }
    root: TWindow;        { root window that the event occurred on  }
    subwindow: TWindow;   { child window  }
    time: TTime;          { milliseconds  }
    x: Longint;          { pointer x, y coordinates in event window }
    y: Longint;
    x_root: Longint;     { coordinates relative to root  }
    y_root: Longint;
    state: Cardinal;     { key or button mask  }
    is_hint: Char;       { detail  }
    same_screen: Bool;   { same screen flag  }
  end;
  {$EXTERNALSYM XMotionEvent}

  PXPointerMovedEvent = ^XPointerMovedEvent;
  {$EXTERNALSYM PXPointerMovedEvent}
  XPointerMovedEvent = XMotionEvent;
  {$EXTERNALSYM XPointerMovedEvent}

  PXCrossingEvent = ^XCrossingEvent;
  {$EXTERNALSYM PXCrossingEvent}
  XCrossingEvent = record
    xtype: Longint;   { of event  }
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool; { true if this came from a SendEvent request  }
    xdisplay: PDisplay; { Display the event was read from  }
    xwindow: TWindow;    { "event" window reported relative to  }
    root: TWindow;       { root window that the event occurred on  }
    subwindow: TWindow;  { child window  }
    time: TTime;         { milliseconds  }
    x: Longint;         { pointer x, y coordinates in event window  }
    y: Longint;
    x_root: Longint;    { coordinates relative to root  }
    y_root: Longint;
    mode: Longint;      { NotifyNormal, NotifyGrab, NotifyUngrab  }
    detail: Longint;    { NotifyAncestor, NotifyVirtual, NotifyInferior,
                          NotifyNonlinear, NotifyNonlinearVirtual }
    same_screen: Bool;  { same screen flag  }
    focus: Bool;        { boolean focus  }
    state: Cardinal;    { key or button mask  }
  end;
  {$EXTERNALSYM XCrossingEvent}

  PXEnterWindowEvent = ^XEnterWindowEvent;
  {$EXTERNALSYM PXEnterWindowEvent}
  XEnterWindowEvent = XCrossingEvent;
  {$EXTERNALSYM XEnterWindowEvent}

  PXLeaveWindowEvent = ^XLeaveWindowEvent;
  {$EXTERNALSYM PXLeaveWindowEvent}
  XLeaveWindowEvent = XCrossingEvent;
  {$EXTERNALSYM XLeaveWindowEvent}

  PXFocusChangeEvent = ^XFocusChangeEvent;
  {$EXTERNALSYM PXFocusChangeEvent}
  XFocusChangeEvent = record
    xtype: Longint;     { FocusIn or FocusOut  }
    serial: Cardinal;   { # of last request processed by server  }
    send_event: Bool;   { true if this came from a SendEvent request  }
    display: PDisplay;  { Display the event was read from  }
    window: TWindow;    { window of event  }
    mode: Longint;      { NotifyNormal, NotifyGrab, NotifyUngrab  }
    detail: Longint;    { NotifyAncestor, NotifyVirtual, NotifyInferior,
                          NotifyNonlinear, NotifyNonlinearVirtual,
                          NotifyPointer, NifyPointerRoot,
                          NotifyDetailNone}
  end;
  {$EXTERNALSYM XFocusChangeEvent}

  PXFocusInEvent = ^XFocusInEvent;
  {$EXTERNALSYM PXFocusInEvent}
  XFocusInEvent = XFocusChangeEvent;
  {$EXTERNALSYM XFocusInEvent}

  PXFocusOutEvent = ^XFocusOutEvent;
  {$EXTERNALSYM PXFocusOutEvent}
  XFocusOutEvent = XFocusChangeEvent;
  {$EXTERNALSYM XFocusOutEvent}

  PXKeymapEvent = ^XKeymapEvent;
  {$EXTERNALSYM PXKeymapEvent}
  XKeymapEvent = record
  { generated on EnterWindow and FocusIn  when KeyMapState selected }
    xtype: Longint;
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool; { true if this came from a SendEvent request }
    xdisplay: PDisplay; { Display the event was read from  }
    xwindow: TWindow;
    key_vector: array[0..31] of char;
  end;
  {$EXTERNALSYM XKeymapEvent}

  PXExposeEvent = ^XExposeEvent;
  {$EXTERNALSYM PXExposeEvent}
  XExposeEvent = record
    xtype: Longint;
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool; { true if this came from a SendEvent request  }
    xdisplay: PDisplay;  { Display the event was read from  }
    xwindow: TWindow;
    x: Longint;
    y: Longint;
    width: Longint;
    height: Longint;
    count: Longint;    { if non-zero, at least this many more  }
  end;
  {$EXTERNALSYM XExposeEvent}

  PXGraphicsExposeEvent = ^XGraphicsExposeEvent;
  {$EXTERNALSYM PXGraphicsExposeEvent}
  XGraphicsExposeEvent = record
    xtype: Longint;
    serial: Cardinal;  { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    xdisplay: PDisplay;  { Display the event was read from  }
    drawable: TDrawable;
    x: Longint;
    y: Longint;
    width: Longint;
    height: Longint;
    count: Longint;       { if non-zero, at least this many more  }
    major_code: Longint;  { core is CopyArea or CopyPlane  }
    minor_code: Longint;  { not defined in the core  }
  end;
  {$EXTERNALSYM XGraphicsExposeEvent}

  PXNoExposeEvent = ^XNoExposeEvent;
  {$EXTERNALSYM PXNoExposeEvent}
  XNoExposeEvent = record
    xtype: Longint;
    serial: Cardinal;  { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    xdisplay: PDisplay; { Display the event was read from  }
    drawable: TDrawable;
    major_code: Longint; { core is CopyArea or CopyPlane  }
    minor_code: Longint; { not defined in the core  }
  end;
  {$EXTERNALSYM XNoExposeEvent}

  PXVisibilityEvent = ^XVisibilityEvent;
  {$EXTERNALSYM PXVisibilityEvent}
  XVisibilityEvent = record
    xtype: Longint;
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool;   { true if this came from a SendEvent request  }
    xdisplay: PDisplay;  { Display the event was read from  }
    xwindow: TWindow;
    state: Longint;      { Visibility state  }
  end;
  {$EXTERNALSYM XVisibilityEvent}

  PXCreateWindowEvent = ^XCreateWindowEvent;
  {$EXTERNALSYM PXCreateWindowEvent}
  XCreateWindowEvent = record
    xtype: Longint;
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool; { true if this came from a SendEvent request  }
    xdisplay: PDisplay;  { Display the event was read from  }
    parent: TWindow;     { parent of the window  }
    xwindow: TWindow;    { window id of window created  }
    x: Longint;         { window location  }
    y: Longint;
    width: Longint;     { size of window  }
    height: Longint;
    border_width: Longint;    { border width  }
    override_redirect: Bool;  { creation should be overridden  }
  end;
  {$EXTERNALSYM XCreateWindowEvent}

  PXDestroyWindowEvent = ^XDestroyWindowEvent;
  {$EXTERNALSYM PXDestroyWindowEvent}
  XDestroyWindowEvent = record
    xtype: Longint;
    serial: Cardinal;  { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    xdisplay: PDisplay; { Display the event was read from  }
    event: TWindow;
    xwindow: TWindow;
  end;
  {$EXTERNALSYM XDestroyWindowEvent}

  PXunmapEvent = ^XUnmapEvent;
  {$EXTERNALSYM PXunmapEvent}
  XUnmapEvent = record
    xtype: Longint;
    serial: Cardinal;  { # of last request processed by server  }
    send_event: Bool; { true if this came from a SendEvent request  }
    display: PDisplay; { Display the event was read from  }
    event: TWindow;
    xwindow: TWindow;
    from_configure: Bool;
  end;
  {$EXTERNALSYM XUnmapEvent}

  PXMapEvent = ^XMapEvent;
  {$EXTERNALSYM PXMapEvent}
  XMapEvent = record
      xtype: Longint;
      serial: Cardinal;  { # of last request processed by server  }
      send_event: Bool;  { true if this came from a SendEvent request  }
      xdisplay: PDisplay;  { Display the event was read from  }
      event: TWindow;
      xwindow: TWindow;
      override_redirect: Bool; { boolean, is override set...  }
   end;
  {$EXTERNALSYM XMapEvent}

  PXMapRequestEvent = ^XMapRequestEvent;
  {$EXTERNALSYM PXMapRequestEvent}
  XMapRequestEvent = record
    xtype: Longint;
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool; { true if this came from a SendEvent request  }
    display: PDisplay; { Display the event was read from  }
    parent: TWindow;
    xwindow: TWindow;
  end;
  {$EXTERNALSYM XMapRequestEvent}

  PXReparentEvent = ^XReparentEvent;
  {$EXTERNALSYM PXReparentEvent}
  XReparentEvent = record
    xtype: Longint;   { # of last request processed by server  }
    serial: Cardinal;
    send_event: Bool; { true if this came from a SendEvent request  }
    display: PDisplay; { Display the event was read from  }
    event: TWindow;
    xwindow: TWindow;
    parent: TWindow;
    x: Longint;
    y: Longint;
    override_redirect: Bool;
  end;
  {$EXTERNALSYM XReparentEvent}

  PXConfigureEvent = ^XConfigureEvent;
  {$EXTERNALSYM PXConfigureEvent}
  XConfigureEvent = record
    xtype: Longint;
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool; { true if this came from a SendEvent request  }
    xdisplay: PDisplay; { Display the event was read from  }
    event: TWindow;
    xwindow: TWindow;
    x: Longint;
    y: Longint;
    width: Longint;
    height: Longint;
    border_width: Longint;
    above: TWindow;
    override_redirect: Bool;
  end;
  {$EXTERNALSYM XConfigureEvent}

  PXGravityEvent = ^XGravityEvent;
  {$EXTERNALSYM PXGravityEvent}
  XGravityEvent = record
    xtype: Longint;
    serial: Cardinal;  { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    display: PDisplay; { Display the event was read from  }
    event: TWindow;
    xwindow: TWindow;
    x: Longint;
    y: Longint;
  end;
  {$EXTERNALSYM XGravityEvent}

  PXResizeRequestEvent = ^XResizeRequestEvent;
  {$EXTERNALSYM PXResizeRequestEvent}
  XResizeRequestEvent = record
    xtype: Longint;
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    xdisplay: PDisplay; { Display the event was read from  }
    xwindow: TWindow;
    width: Longint;
    height: Longint;
  end;
  {$EXTERNALSYM XResizeRequestEvent}

  PXConfigureRequestEvent = ^XConfigureRequestEvent;
  {$EXTERNALSYM PXConfigureRequestEvent}
  XConfigureRequestEvent = record
    xtype: Longint;
    serial: Cardinal;  { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    xdisplay: PDisplay; { Display the event was read from  }
    parent: TWindow;
    xwindow: TWindow;
    x: Longint;
    y: Longint;
    width: Longint;
    height: Longint;
    border_width: Longint;
    above: TWindow;
    detail: Longint;      { Above, Below, TopIf, BottomIf, Opposite  }
    value_mask: Cardinal;
  end;
  {$EXTERNALSYM XConfigureRequestEvent}

  PXCirculateEvent = ^XCirculateEvent;
  {$EXTERNALSYM PXCirculateEvent}
  XCirculateEvent = record
    xtype: Longint;
    serial: Cardinal;  { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    display: PDisplay;  { Display the event was read from  }
    event: TWindow;
    xwindow: TWindow;
    place: Longint;   { PlaceOnTop, PlaceOnBottom  }
  end;
  {$EXTERNALSYM XCirculateEvent}

  PXCirculateRequestEvent = ^XCirculateRequestEvent;
  {$EXTERNALSYM PXCirculateRequestEvent}
  XCirculateRequestEvent = record
    xtype: Longint;
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool; { true if this came from a SendEvent request  }
    display: PDisplay;  { Display the event was read from  }
    parent: TWindow;
    xwindow: TWindow;
    place: Longint;    { PlaceOnTop, PlaceOnBottom  }
  end;
  {$EXTERNALSYM XCirculateRequestEvent}

  PXPropertyEvent = ^XPropertyEvent;
  {$EXTERNALSYM PXPropertyEvent}
  XPropertyEvent = record
    xtype: Longint;
    serial: Cardinal;  { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    xdisplay: PDisplay;
    xwindow: TWindow;     { Display the event was read from  }
    atom: TAtom;
    time: TTime;
    state: Longint;    { NewValue, Deleted  }
  end;
  {$EXTERNALSYM XPropertyEvent}

  PXSelectionClearEvent = ^XSelectionClearEvent;
  {$EXTERNALSYM PXSelectionClearEvent}
  XSelectionClearEvent = record
    xtype: Longint;
    serial: Cardinal;  { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    display: PDisplay; { Display the event was read from  }
    window: TWindow;
    selection: TAtom;
    time: TTime;
  end;
  {$EXTERNALSYM XSelectionClearEvent}

  XSelectionRequestEvent = record
    xtype: Longint;
    serial: Cardinal;    { # of last request processed by server  }
    send_event: Bool;   { true if this came from a SendEvent request  }
    display: PDisplay; { Display the event was read from  }
    owner: TWindow;
    requestor: TWindow;
    selection: TAtom;
    target: TAtom;
    xproperty: TAtom;
    time: TTime;
  end;
  {$EXTERNALSYM XSelectionRequestEvent}

  PXSelectionEvent = ^XSelectionEvent;
  {$EXTERNALSYM PXSelectionEvent}
  XSelectionEvent = record
    xtype: Longint;
    serial: Cardinal;  { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    display: PDisplay;  { Display the event was read from  }
    requestor: TWindow;
    selection: TAtom;
    target: TAtom;
    xproperty: TAtom;   { ATOM or None  }
    time: TTime;
  end;
  {$EXTERNALSYM XSelectionEvent}

  PXColormapEvent = ^XColormapEvent;
  {$EXTERNALSYM PXColormapEvent}
  XColormapEvent = record
    xtype: Longint;
    serial: Cardinal; { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    display: PDisplay;  { Display the event was read from  }
    xwindow: TWindow;
    colormap: TColorMap; { COLORMAP or None  }
    new: Bool;
    state: Longint;   { ColormapInstalled, ColormapUninstalled  }
  end;
  {$EXTERNALSYM XColormapEvent}

  PXClientMessageEvent = ^XClientMessageEvent;
  {$EXTERNALSYM PXClientMessageEvent}
  XClientMessageEvent = record
    xtype: Longint;
    serial: Cardinal;  { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    display: PDisplay;  { Display the event was read from  }
    xwindow: TWindow;
    message_type: TAtom;
    format: Longint;
    data: record
        case Longint of
           0: ( b: array[0..19] of Char );
           1: ( s: array[0..9] of SmallInt );
           2: ( l: array[0..4] of Longint );
        end;
  end;
  {$EXTERNALSYM XClientMessageEvent}

  PXMappingEvent = ^XMappingEvent;
  {$EXTERNALSYM PXMappingEvent}
  XMappingEvent = record
    xtype: Longint;
    serial: Cardinal;  { # of last request processed by server  }
    send_event: Bool;  { true if this came from a SendEvent request  }
    display: PDisplay;   { Display the event was read from  }
    xwindow: TWindow;      { unused  }
    request: Longint;     { one of MappingModifier, MappingKeyboard,
                           MappingPointer  }
    first_keycode: Longint;  { first keycode  }
    count: Longint;       { defines range of change w. first_keycode }
  end;
  {$EXTERNALSYM XMappingEvent}

  PXErrorEvent = ^XErrorEvent;
  {$EXTERNALSYM PXErrorEvent}
  XErrorEvent = record
    xtype: Longint;
    display: PDisplay; { Display the event was read from  }
    resourceid: XID;    { resource id  }
    serial: Cardinal;   { serial number of failed request  }
    error_code: byte;   { error code of failed request  }
    request_code: byte; { Major op-code of failed request  }
    minor_code: byte;   { Minor op-code of failed request  }
  end;
  {$EXTERNALSYM XErrorEvent}

  PXAnyEvent = ^XAnyEvent;
  {$EXTERNALSYM PXAnyEvent}
  XAnyEvent = record
    xtype: Longint;
    serial: Cardinal;   { # of last request processed by server  }
    send_event: Bool;   { true if this came from a SendEvent request  }
    display: PDisplay;  { Display the event was read from  }
    xwindow: TWindow;    { window on which event was requested in event mask  }
  end;
  {$EXTERNALSYM XAnyEvent}

{ this union is defined so Xlib can always use the same sized
  event structure internally, to avoid memory fragmentation.
}
    { must not be changed; first element  }

  PXEvent = ^XEvent;
  {$EXTERNALSYM PXEvent}
  XEvent = record
  case Longint of
    0: ( xtype: Longint );
    1: ( xany: XAnyEvent );
    2: ( xkey: XKeyEvent );
    3: ( xbutton: XButtonEvent );
    4: ( xmotion: XMotionEvent );
    5: ( xcrossing: XCrossingEvent );
    6: ( xfocus: XFocusChangeEvent );
    7: ( xexpose: XExposeEvent );
    8: ( xgraphicsexpose: XGraphicsExposeEvent );
    9: ( xnoexpose: XNoExposeEvent );
    10: ( xvisibility: XVisibilityEvent );
    11: ( xcreatewindow: XCreateWindowEvent );
    12: ( xdestroywindow: XDestroyWindowEvent );
    13: ( xunmap: XUnmapEvent );
    14: ( xmap: XMapEvent );
    15: ( xmaprequest: XMapRequestEvent );
    16: ( xreparent: XReparentEvent );
    17: ( xconfigure: XConfigureEvent );
    18: ( xgravity: XGravityEvent );
    19: ( xresizerequest: XResizeRequestEvent );
    20: ( xconfigurerequest: XConfigureRequestEvent );
    21: ( xcirculate: XCirculateEvent );
    22: ( xcirculaterequest: XCirculateRequestEvent );
    23: ( xproperty: XPropertyEvent );
    24: ( xselectionclear: XSelectionClearEvent );
    25: ( xselectionrequest: XSelectionRequestEvent );
    26: ( xselection: XSelectionEvent );
    27: ( xcolormap: XColormapEvent );
    28: ( xclient: XClientMessageEvent );
    29: ( xmapping: XMappingEvent );
    30: ( xerror: XErrorEvent );
    31: ( xkeymap: XKeymapEvent );
    32: ( pad: array[0..23] of Longint );
  end;
  {$EXTERNALSYM XEvent}

  _XEvent = XEvent;
  {$EXTERNALSYM _XEvent}

type
  PXCharStruct = ^XCharStruct;
  {$EXTERNALSYM PXCharStruct}
  XCharStruct = record  { per character font metric information. }
    lbearing: SmallInt; { origin to left edge of raster  }
    rbearing: SmallInt; { origin to right edge of raster  }
    width: SmallInt;    { advance to next char's origin  }
    ascent: SmallInt;   { baseline to top edge of raster  }
    descent: SmallInt;  { baseline to bottom edge of raster  }
    attributes: Word;  { per char flags (not predefined)  }
  end;
  {$EXTERNALSYM XCharStruct}

{ To allow arbitrary information with fonts, there are additional properties
  returned. }

  PXFontProp = ^XFontProp;
  {$EXTERNALSYM PXFontProp}
  XFontProp = record
    name: TAtom;
    card32: Cardinal;
  end;
  {$EXTERNALSYM XFontProp}

  PXFontStruct = ^XFontStruct;
  {$EXTERNALSYM PXFontStruct}
  XFontStruct = record
    ext_data: PXExtData;         { hook for extension to hang data  }
    fid: TFont;                   { Font id for this font  }
    direction: Cardinal;         { hint about direction the font is painted  }
    min_char_or_byte2: Cardinal; { first character  }
    max_char_or_byte2: Cardinal; { last character  }
    min_byte1: Cardinal;         { first row that exists  }
    max_byte1: Cardinal;         { last row that exists  }
    all_chars_exist: Bool;       { flag if all characters have non-zero size }
    default_char: Cardinal;      { char to print for undefined character  }
    n_properties: Longint;       { how many properties there are  }
    properties: PXFontProp;      { pointer to array of additional properties }
    min_bounds: XCharStruct;     { minimum bounds over all existing char }
    max_bounds: XCharStruct;     { maximum bounds over all existing char }
    per_char: PXCharStruct;      { first_char to last_char information  }
    ascent: Longint;             { log. extent above baseline for spacing  }
    descent: Longint;            { log. descent below baseline for spacing  }
  end;
  {$EXTERNALSYM XFontStruct}
  PPXFontStruct = ^PXFontStruct;
  {$EXTERNALSYM PPXFontStruct}
  PPPXFontStruct = ^PPXFontStruct;
  {$EXTERNALSYM PPPXFontStruct}
  
{ PolyText routines take these as arguments. }

  PXTextItem = ^XTextItem;
  {$EXTERNALSYM PXTextItem}
  XTextItem = record
    chars: PChar;     { pointer to string  }
    nchars: Longint;  { number of characters  }
    delta: Longint;   { delta between strings  }
    font: TFont;       { font to print it in, None don't change  }
  end;
  {$EXTERNALSYM XTextItem}

{ normal 16 bit characters are two bytes  }

  PXChar2b = ^XChar2b;
  {$EXTERNALSYM PXChar2b}
  XChar2b = record
    byte1: byte;
    byte2: byte;
  end;
  {$EXTERNALSYM XChar2b}

  PXTextItem16 = ^XTextItem16;
  {$EXTERNALSYM PXTextItem16}
  XTextItem16 = record
    chars: PXChar2b; { two byte characters  }
    nchars: Longint; { number of characters  }
    delta: Longint;  { delta between strings  }
    font: TFont;      { font to print it in, None don't change  }
  end;
  {$EXTERNALSYM XTextItem16}

  PXEDataObject = ^XEDataObject;
  {$EXTERNALSYM PXEDataObject}
  XEDataObject = record
  case Longint of
    0: ( display: PDisplay );
    1: ( gc: TGC );
    2: ( visual: PVisual );
    3: ( screen: PScreen );
    4: ( pixmap_format: PScreenFormat );
    5: ( font: PXFontStruct );
  end;
  {$EXTERNALSYM XEDataObject}

  PXFontSetExtents = ^XFontSetExtents;
  {$EXTERNALSYM PXFontSetExtents}
  XFontSetExtents = record
    max_ink_extent: XRectangle;
    max_logical_extent: XRectangle;
  end;
  {$EXTERNALSYM XFontSetExtents}

  PXOM = ^XOM;
  {$EXTERNALSYM PXOM}
  XOM = record
  end;
  {$EXTERNALSYM XOM}

  PXOC = ^XOC;
  {$EXTERNALSYM PXOC}
  XOC = record
  end;
  {$EXTERNALSYM XOC}

  PXFontSet = ^XFontSet;
  {$EXTERNALSYM PXFontSet}
  XFontSet = record
  end;
  {$EXTERNALSYM XFontSet}

  PXmbTextItem = ^XmbTextItem;
  {$EXTERNALSYM PXmbTextItem}
  XmbTextItem = record
    chars: PChar;
    nchars: Longint;
    delta: Longint;
    font_set: XFontSet;
  end;
  {$EXTERNALSYM XmbTextItem}

  PXwcTextItem = ^XwcTextItem;
  {$EXTERNALSYM PXwcTextItem}
  XwcTextItem = record
    chars: ^wchar_t;
    nchars: Longint;
    delta: Longint;
    font_set: XFontSet;
  end;
  {$EXTERNALSYM XwcTextItem}

const
  XNRequiredCharSet = 'requiredCharSet';
  {$EXTERNALSYM XNRequiredCharSet}
  XNQueryOrientation = 'queryOrientation';
  {$EXTERNALSYM XNQueryOrientation}
  XNBaseFontName = 'baseFontName';
  {$EXTERNALSYM XNBaseFontName}
  XNOMAutomatic = 'omAutomatic';
  {$EXTERNALSYM XNOMAutomatic}
  XNMissingCharSet = 'missingCharSet';
  {$EXTERNALSYM XNMissingCharSet}
  XNDefaultString = 'defaultString';
  {$EXTERNALSYM XNDefaultString}
  XNOrientation = 'orientation';
  {$EXTERNALSYM XNOrientation}
  XNDirectionalDependentDrawing = 'directionalDependentDrawing';
  {$EXTERNALSYM XNDirectionalDependentDrawing}
  XNContextualDrawing = 'contextualDrawing';
  {$EXTERNALSYM XNContextualDrawing}
  XNFontInfo = 'fontInfo';
  {$EXTERNALSYM XNFontInfo}

type
  PXOMCharSetList = ^XOMCharSetList;
  {$EXTERNALSYM PXOMCharSetList}
  XOMCharSetList = record
    charset_count: Longint;
    charset_list: PPChar;
  end;
  {$EXTERNALSYM XOMCharSetList}

  PXOrientation = ^XOrientation;
  {$EXTERNALSYM PXOrientation}
  XOrientation = (XOMOrientation_LTR_TTB,
                  XOMOrientation_RTL_TTB,
                  XOMOrientation_TTB_LTR,
                  XOMOrientation_TTB_RTL,
                  XOMOrientation_Context);
  {$EXTERNALSYM XOrientation}

    { Input Text description  }

  PXOMOrientation = ^XOMOrientation;
  {$EXTERNALSYM PXOMOrientation}
  XOMOrientation = record
    num_orientation: Longint;
    orientation: PXOrientation;
  end;
  {$EXTERNALSYM XOMOrientation}

  PXOMFontInfo = ^XOMFontInfo;
  {$EXTERNALSYM PXOMFontInfo}
  XOMFontInfo = record
    num_font: Longint;
    font_struct_list: ^PXFontStruct;
    font_name_list: PPChar;
  end;
  {$EXTERNALSYM XOMFontInfo}

  PXIM = ^XIM;
  {$EXTERNALSYM PXIM}
  XIM = record
  end;
  {$EXTERNALSYM XIM}

  PXIC = ^XIC;
  {$EXTERNALSYM PXIC}
  XIC = record
  end;
  {$EXTERNALSYM XIC}

  XIMProc = procedure (_para1: PXIM; _para2: XPointer; _para3: XPointer); cdecl;
  {$EXTERNALSYM XIMProc}

  XICProc = function (_para1: PXIC; _para2: XPointer; _para3: XPointer): Bool; cdecl;
  {$EXTERNALSYM XICProc}

  XIDProc = procedure (_para1: PDisplay; _para2: XPointer; _para3: XPointer); cdecl;
  {$EXTERNALSYM XIDProc}

  PXIMStyle = ^XIMStyle;
  {$EXTERNALSYM PXIMStyle}
  XIMStyle = Cardinal;
  {$EXTERNALSYM XIMStyle}

  XIMStyles = record
    count_styles: Word;
    supported_styles: PXIMStyle;
  end;
  {$EXTERNALSYM XIMStyles}

const
  XIMPreeditArea = $0001;
  {$EXTERNALSYM XIMPreeditArea}
  XIMPreeditCallbacks = $0002;
  {$EXTERNALSYM XIMPreeditCallbacks}
  XIMPreeditPosition = $0004;
  {$EXTERNALSYM XIMPreeditPosition}
  XIMPreeditNothing = $0008;
  {$EXTERNALSYM XIMPreeditNothing}
  XIMPreeditNone = $0010;
  {$EXTERNALSYM XIMPreeditNone}
  XIMStatusArea = $0100;
  {$EXTERNALSYM XIMStatusArea}
  XIMStatusCallbacks = $0200;
  {$EXTERNALSYM XIMStatusCallbacks}
  XIMStatusNothing = $0400;
  {$EXTERNALSYM XIMStatusNothing}
  XIMStatusNone = $0800;
  {$EXTERNALSYM XIMStatusNone}
  XNVaNestedList = 'XNVaNestedList';
  {$EXTERNALSYM XNVaNestedList}
  XNQueryInputStyle = 'queryInputStyle';
  {$EXTERNALSYM XNQueryInputStyle}
  XNClientWindow = 'clientWindow';
  {$EXTERNALSYM XNClientWindow}
  XNInputStyle = 'inputStyle';
  {$EXTERNALSYM XNInputStyle}
  XNFocusWindow = 'focusWindow';
  {$EXTERNALSYM XNFocusWindow}
  XNResourceName = 'resourceName';
  {$EXTERNALSYM XNResourceName}
  XNResourceClass = 'resourceClass';
  {$EXTERNALSYM XNResourceClass}
  XNGeometryCallback = 'geometryCallback';
  {$EXTERNALSYM XNGeometryCallback}
  XNDestroyCallback = 'destroyCallback';
  {$EXTERNALSYM XNDestroyCallback}
  XNFilterEvents = 'filterEvents';
  {$EXTERNALSYM XNFilterEvents}
  XNPreeditStartCallback = 'preeditStartCallback';
  {$EXTERNALSYM XNPreeditStartCallback}
  XNPreeditDoneCallback = 'preeditDoneCallback';
  {$EXTERNALSYM XNPreeditDoneCallback}
  XNPreeditDrawCallback = 'preeditDrawCallback';
  {$EXTERNALSYM XNPreeditDrawCallback}
  XNPreeditCaretCallback = 'preeditCaretCallback';
  {$EXTERNALSYM XNPreeditCaretCallback}
  XNPreeditStateNotifyCallback = 'preeditStateNotifyCallback';
  {$EXTERNALSYM XNPreeditStateNotifyCallback}
  XNPreeditAttributes = 'preeditAttributes';
  {$EXTERNALSYM XNPreeditAttributes}
  XNStatusStartCallback = 'statusStartCallback';
  {$EXTERNALSYM XNStatusStartCallback}
  XNStatusDoneCallback = 'statusDoneCallback';
  {$EXTERNALSYM XNStatusDoneCallback}
  XNStatusDrawCallback = 'statusDrawCallback';
  {$EXTERNALSYM XNStatusDrawCallback}
  XNStatusAttributes = 'statusAttributes';
  {$EXTERNALSYM XNStatusAttributes}
  XNArea = 'area';
  {$EXTERNALSYM XNArea}
  XNAreaNeeded = 'areaNeeded';
  {$EXTERNALSYM XNAreaNeeded}
  XNSpotLocation = 'spotLocation';
  {$EXTERNALSYM XNSpotLocation}
  XNColormap = 'colorMap';
  {$EXTERNALSYM XNColormap}
  XNStdColormap = 'stdColorMap';
  {$EXTERNALSYM XNStdColormap}
  XNForeground = 'foreground';
  {$EXTERNALSYM XNForeground}
  XNBackground = 'background';
  {$EXTERNALSYM XNBackground}
  XNBackgroundPixmap = 'backgroundPixmap';
  {$EXTERNALSYM XNBackgroundPixmap}
  XNFontSet = 'fontSet';
  {$EXTERNALSYM XNFontSet}
  XNLineSpace = 'lineSpace';
  {$EXTERNALSYM XNLineSpace}
  XNCursor = 'cursor';
  {$EXTERNALSYM XNCursor}
  XNQueryIMValuesList = 'queryIMValuesList';
  {$EXTERNALSYM XNQueryIMValuesList}
  XNQueryICValuesList = 'queryICValuesList';
  {$EXTERNALSYM XNQueryICValuesList}
  XNVisiblePosition = 'visiblePosition';
  {$EXTERNALSYM XNVisiblePosition}
  XNR6PreeditCallback = 'r6PreeditCallback';
  {$EXTERNALSYM XNR6PreeditCallback}
  XNStringConversionCallback = 'stringConversionCallback';
  {$EXTERNALSYM XNStringConversionCallback}
  XNStringConversion = 'stringConversion';
  {$EXTERNALSYM XNStringConversion}
  XNResetState = 'resetState';
  {$EXTERNALSYM XNResetState}
  XNHotKey = 'hotKey';
  {$EXTERNALSYM XNHotKey}
  XNHotKeyState = 'hotKeyState';
  {$EXTERNALSYM XNHotKeyState}
  XNPreeditState = 'preeditState';
  {$EXTERNALSYM XNPreeditState}
  XNSeparatorofNestedList = 'separatorofNestedList';
  {$EXTERNALSYM XNSeparatorofNestedList}
  XBufferOverflow = -(1);
  {$EXTERNALSYM XBufferOverflow}
  XLookupNone = 1;
  {$EXTERNALSYM XLookupNone}
  XLookupChars = 2;
  {$EXTERNALSYM XLookupChars}
  XLookupKeySym_ = 3;  { Originally XLookupKeySym }
  {$EXTERNALSYM XLookupKeySym_}
  XLookupBoth = 4;
  {$EXTERNALSYM XLookupBoth}

type
  XVaNestedList = XPointer;
  {$EXTERNALSYM XVaNestedList}
  
  PXIMCallback = ^XIMCallback;
  {$EXTERNALSYM PXIMCallback}
  XIMCallback = record
    client_data: XPointer;
    callback: XIMProc;
  end;
  {$EXTERNALSYM XIMCallback}

  PXICCallback = ^XICCallback;
  {$EXTERNALSYM PXICCallback}
  XICCallback = record
    client_data: XPointer;
    callback: XICProc;
  end;
  {$EXTERNALSYM XICCallback}

  PXIMFeedback = ^XIMFeedback;
  {$EXTERNALSYM PXIMFeedback}
  XIMFeedback = Cardinal;
  {$EXTERNALSYM XIMFeedback}

const
  XIMReverse = 1;
  {$EXTERNALSYM XIMReverse}
  XIMUnderline = 1 shl 1;
  {$EXTERNALSYM XIMUnderline}
  XIMHighlight = 1 shl 2;
  {$EXTERNALSYM XIMHighlight}
  XIMPrimary = 1 shl 5;
  {$EXTERNALSYM XIMPrimary}
  XIMSecondary = 1 shl 6;
  {$EXTERNALSYM XIMSecondary}
  XIMTertiary = 1 shl 7;
  {$EXTERNALSYM XIMTertiary}
  XIMVisibleToForward = 1 shl 8;
  {$EXTERNALSYM XIMVisibleToForward}
  XIMVisibleToBackword = 1 shl 9;
  {$EXTERNALSYM XIMVisibleToBackword}
  XIMVisibleToCenter = 1 shl 10;
  {$EXTERNALSYM XIMVisibleToCenter}

type
  PXIMText = ^XIMText;
  {$EXTERNALSYM PXIMText}
  XIMText = record
    length: word;
    feedback: PXIMFeedback;
    encoding_is_wchar: Bool;
    stringtype: record
      case Longint of
         0: ( multi_byte: PChar );
         1: ( wide_char: Pwchar_t );
      end;
  end;
  {$EXTERNALSYM XIMText}

  _XIMText = XIMText;
  {$EXTERNALSYM _XIMText}

  PXIMPreeditState = ^XIMPreeditState;
  {$EXTERNALSYM PXIMPreeditState}
  XIMPreeditState = Cardinal;
  {$EXTERNALSYM XIMPreeditState}

const
  XIMPreeditUnKnown = 0;
  {$EXTERNALSYM XIMPreeditUnknown}
  XIMPreeditEnable = 1;
  {$EXTERNALSYM XIMPReeditEnable}
  XIMPreeditDisable = 1 shl 1;
  {$EXTERNALSYM XIMPreeditDisable}

type
  XIMPreeditStateNotifyCallbackStruct = record
    state: XIMPreeditState;
  end;
  {$EXTERNALSYM XIMPreeditStateNotifyCallbackStruct}

  _XIMPreeditStateNotifyCallbackStruct = XIMPreeditStateNotifyCallbackStruct;
  {$EXTERNALSYM _XIMPReeditStateNotifyCallbackStruct}

  PXIMResetState = ^XIMResetState;
  {$EXTERNALSYM PXIMResetState}
  XIMResetState = Cardinal;
  {$EXTERNALSYM XIMResetState}

const
  XIMInitialState = 1;
  {$EXTERNALSYM XIMInitialState}
  XIMPreserveState = 1 shl 1;
  {$EXTERNALSYM XIMPreserveState}

type
  PXIMStringConversionFeedback = ^XIMStringConversionFeedback;
  {$EXTERNALSYM PXIMStringConversionFeedback}
  XIMStringConversionFeedback = Cardinal;
  {$EXTERNALSYM XIMStringConversionFeedback}

const
  XIMStringConversionLeftEdge = $00000001;
  {$EXTERNALSYM XIMStringConversionLeftEdge}
  XIMStringConversionRightEdge = $00000002;
  {$EXTERNALSYM XIMStringConversionRightEdge}
  XIMStringConversionTopEdge = $00000004;
  {$EXTERNALSYM XIMStringConversionTopEdge}
  XIMStringConversionBottomEdge = $00000008;
  {$EXTERNALSYM XIMStringConversionBottomEdge}
  XIMStringConversionConcealed = $00000010;
  {$EXTERNALSYM XIMStringConversionConcealed}
  XIMStringConversionWrapped = $00000020;
  {$EXTERNALSYM XIMStringConversionWrapped}

type
  PXIMStringConversionText = ^XIMStringConversionText;
  {$EXTERNALSYM PXIMStringConversionText}
  XIMStringConversionText = record
    length: word;
    feedback: PXIMStringConversionFeedback;
    encoding_is_wchar: Bool;
    stringtype: record
        case Longint of
           0: ( mbs: PChar );
           1: ( wcs: Pwchar_t );
        end;
  end;
  {$EXTERNALSYM XIMStringConversionText}

  _XIMStringConversionText = XIMStringConversionText;
  {$EXTERNALSYM _XIMStringConversionText}

  XIMStringConversionPosition = Word;
  {$EXTERNALSYM XIMStringConversionPosition}

  XIMStringConversionType = Word;
  {$EXTERNALSYM XIMStringConversionType}

const
  XIMStringConversionBuffer = $0001;
  {$EXTERNALSYM XIMStringConversionBuffer}
  XIMStringConversionLine = $0002;
  {$EXTERNALSYM XIMStringConversionLine}
  XIMStringConversionWord = $0003;
  {$EXTERNALSYM XIMStringConversionWord}
  XIMStringConversionChar = $0004;
  {$EXTERNALSYM XIMStringConversionChar}

type
  XIMStringConversionOperation = word;
  {$EXTERNALSYM XIMStringConversionOperation}

const
  XIMStringConversionSubstitution = $0001;
  {$EXTERNALSYM XIMStringConversionSubstitution}
  XIMStringConversionRetrieval = $0002;
  {$EXTERNALSYM XIMStringConversionRetrieval}
    {
       This typo was present in pre-R6.4 versions.  It is defined here for
       compatibility purposes only.  It should not be used, and may not be
       present in future releases.
      }
  XIMStringConversionRetrival = XIMStringConversionRetrieval;
  {$EXTERNALSYM XIMStringConversionRetrival}

type
  XIMCaretDirection = (XIMForwardChar,
                       XIMBackwardChar,
                       XIMForwardWord,
                       XIMBackwardWord,
                       XIMCaretUp,
                       XIMCaretDown,
                       XIMNextLine,
                       XIMPreviousLine,
                       XIMLineStart,
                       XIMLineEnd,
                       XIMAbsolutePosition,
                       XIMDontChange);
  {$EXTERNALSYM XIMCaretDirection}

  PXIMStringConversionCallbackStruct = ^XIMStringConversionCallbackStruct;
  {$EXTERNALSYM PXIMStringConversionCallbackStruct}
  XIMStringConversionCallbackStruct = record
    position: XIMStringConversionPosition;
    direction: XIMCaretDirection;
    operation: XIMStringConversionOperation;
    factor: Word;
    text: PXIMStringConversionText;
  end;
  {$EXTERNALSYM XIMStringConversionCallbackStruct}

  _XIMStringConversionCallbackStruct = XIMStringConversionCallbackStruct;
  {$EXTERNALSYM _XIMStringConversionCallbackStruct}

  PXIMPreeditDrawCallbackStruct = ^XIMPreeditDrawCallbackStruct;
  {$EXTERNALSYM PXIMPreeditDrawCallbackStruct}
  XIMPreeditDrawCallbackStruct = record
    caret: Longint;       { Cursor offset within pre-edit string  }
    chg_first: Longint;   { Starting change position  }
    chg_length: Longint;  { Length of the change in character count  }
    text: PXIMText;
  end;
  {$EXTERNALSYM XIMPreeditDrawCallbackStruct}

  _XIMPreeditDrawCallbackStruct = XIMPreeditDrawCallbackStruct;
  {$EXTERNALSYM _XIMPreeditDrawCallbackStruct}

  XIMCaretStyle = (XIMIsInvisible,
                   XIMIsPrimary,
                   XIMIsSecondary);
  {$EXTERNALSYM XIMCaretStyle}

  PXIMPreeditCaretCallbackStruct = ^XIMPreeditCaretCallbackStruct;
  {$EXTERNALSYM PXIMPreeditCaretCallbackStruct}
  XIMPreeditCaretCallbackStruct = record
    position: Longint;            { Caret offset within pre-edit string  }
    direction: XIMCaretDirection; { Caret moves direction  }
    style: XIMCaretStyle;         { Feedback of the caret  }
  end;
  {$EXTERNALSYM XIMPreeditCaretCallbackStruct}

  _XIMPreeditCaretCallbackStruct = XIMPreeditCaretCallbackStruct;
  {$EXTERNALSYM _XIMPreeditCaretCallbackStruct}

  XIMStatusDataType = (XIMTextType, XIMBitmapType);
  {$EXTERNALSYM XIMStatusDataType}

  PXIMStatusDrawCallbackStruct = ^XIMStatusDrawCallbackStruct;
  {$EXTERNALSYM PXIMStatusDrawCallbackStruct}
  XIMStatusDrawCallbackStruct = record
    DataType: XIMStatusDataType;
    data: record
        case Longint of
           0: ( text: PXIMText );
           1: ( bitmap: TPixmap );
        end;
  end;
  {$EXTERNALSYM XIMStatusDrawCallbackStruct}

  _XIMStatusDrawCallbackStruct = XIMStatusDrawCallbackStruct;
  {$EXTERNALSYM _XIMStatusDrawCallbackStruct}

  PXIMHotKeyTrigger = ^XIMHotKeyTrigger;
  {$EXTERNALSYM PXIMHotKeyTrigger}
  XIMHotKeyTrigger = record
    keysym: TKeySym;
    modifier: Longint;
    modifier_mask: Longint;
  end;
  {$EXTERNALSYM XIMHotKeyTrigger}

  _XIMHotKeyTrigger = XIMHotKeyTrigger;
  {$EXTERNALSYM _XIMHotKeyTrigger}

  PXIMHotKeyTriggers = ^XIMHotKeyTriggers;
  {$EXTERNALSYM PXIMHotKeyTriggers}
  XIMHotKeyTriggers = record
    num_hot_key: Longint;
    key: PXIMHotKeyTrigger;
  end;
  {$EXTERNALSYM XIMHotKeyTriggers}

  _XIMHotKeyTriggers = XIMHotKeyTriggers;
  {$EXTERNALSYM _XIMHotKeyTriggers}

  XIMHotKeyState = Cardinal;
  {$EXTERNALSYM XIMHotKeyState}

const
  XIMHotKeyStateON = $0001;
  {$EXTERNALSYM XIMHotKeyStateON}
  XIMHotKeyStateOFF = $0002;
  {$EXTERNALSYM XIMHotKeyStateOFF}

type
  PXIMValuesList = ^XIMValuesList;
  {$EXTERNALSYM PXIMValuesList}
  XIMValuesList = record
    count_values: Word;
    supported_values: PPChar;
  end;
  {$EXTERNALSYM XIMValuesList}

function XLoadQueryFont(Display: PDisplay; Name: PChar): PXFontStruct; cdecl;
{$EXTERNALSYM XLoadQueryFont}

function XQueryFont(Display: PDisplay; Font_ID: XID): PXFontStruct; cdecl;
{$EXTERNALSYM XQueryFont}

function XGetMotionEvents(Display: PDisplay; W: TWindow; Start: TTime; Stop: TTime;
  NEvents_Return: PLongint): PXTimeCoord; cdecl;
{$EXTERNALSYM XGetMotionEvents}

function XDeleteModifiermapEntry(ModMap: PXModifierKeymap; KeyCodeEntry: TKeyCode;
  Modifier: Longint): PXModifierKeymap; cdecl;
{$EXTERNALSYM XDeleteModifiermapEntry}

function XGetModifierMapping(Display: PDisplay): PXModifierKeymap; cdecl;
{$EXTERNALSYM XGetModifierMapping}

function XInsertModifiermapEntry(ModMap: pXModifierKeymap;
  KeyCodeEntry: TKeyCode; Modifier: Longint): PXModifierKeymap; cdecl;
{$EXTERNALSYM XInsertModifiermapEntry}

function XNewModifiermap(MaxKeysPerMod: Longint): PXModifierKeymap; cdecl;
{$EXTERNALSYM XNewModifiermap}

function XCreateImage(Display: PDisplay; Visual: PVisual; Depth: Cardinal;
  Format: Longint; Offset: Longint; Data: PChar; Width, Height: Cardinal;
  BitmapPad: Longint; BytesPerLine: Longint): PXImage; cdecl;
{$EXTERNALSYM XCreateImage}

function XInitImage(Image: pXImage): TStatus; cdecl;
{$EXTERNALSYM XInitImage}

function XGetPixel(Image: PXImage; X, Y: Longint): Cardinal;
{$EXTERNALSYM XGetPixel}
function XPutPixel(Image: PXImage; X, Y: Longint; Pixel: Cardinal): Longint;
{$EXTERNALSYM XPutPixel}
function XDestroyImage(Image: PXImage): Longint;
{$EXTERNALSYM XDestroyImage}
function XSubImage(Image: PXImage; X, Y: Longint; SubImageWidth: Cardinal;
  SubImageHeight: Cardinal): PXImage;
{$EXTERNALSYM XSubImage}
function XAddPixel(Image: PXImage; Value: Longint): Longint;
{$EXTERNALSYM XAddPixel}

function XGetImage(Display: PDisplay; D: TDrawable; X, Y: Longint;
  Width, Height: Cardinal; Plane_Mask: Cardinal; Format: Longint): PXImage;
  cdecl;
{$EXTERNALSYM XGetImage}

function XGetSubImage(Display: PDisplay; D: TDrawable; X, Y: Longint;
  Width, Height: Cardinal; PlaneMask: Cardinal; Format: Longint;
  DestImage: PXImage; DestX, DestY: Longint): PXImage; cdecl;
{$EXTERNALSYM XGetSubImage}

{ X function declarations. }

function XOpenDisplay(DisplayName: PChar): PDisplay; cdecl;
{$EXTERNALSYM XOpenDisplay}
   
procedure XrmInitialize; cdecl;
{$EXTERNALSYM XrmInitialize}

function XFetchBytes(Display: PDisplay; NBytesReturn: PLongint): PChar; cdecl;
{$EXTERNALSYM XFetchBytes}

function XFetchBuffer(Display: PDisplay; NBytesReturn: PLongint;
  Buffer: Longint): PChar; cdecl;
{$EXTERNALSYM XFetchBuffer}

function XGetAtomName(Display: PDisplay; Atom: TAtom): PChar; cdecl;
{$EXTERNALSYM XGetAtomName}

function XGetAtomNames(Dpy: PDisplay; Atoms: PAtom; Count: Longint;
  NamesReturn: PPChar): TStatus; cdecl;
{$EXTERNALSYM XGetAtomNames}

function XGetDefault(Display: PDisplay; ProgName: PChar; Option: PChar): PChar; cdecl;
{$EXTERNALSYM XGetDefault}

function XDisplayName(DisplayName: PChar): PChar; cdecl;
{$EXTERNALSYM XDisplayName}

function XKeysymToString(KeySym: TKeySym): PChar; cdecl;
{$EXTERNALSYM XKeysymToString}

type
  XSynchronizeProc = function (Display: PDisplay): Longint; cdecl;
  {$EXTERNALSYM XSynchronizeProc}

function XSynchronize(Display: PDisplay; OnOff: Bool): XSynchronizeProc; cdecl;
{$EXTERNALSYM XSynchronize}

type
  XSetAfterFunctionProc = function(Display: PDisplay): Longint; cdecl;
  {$EXTERNALSYM XSetAfterFunctionProc}

function XSetAfterFunction(Display: PDisplay; Proc: XSetAfterFunctionProc):
  Longint; cdecl;
{$EXTERNALSYM XSetAfterFunction}

function XInternAtom(Display: PDisplay; Name: PChar;
  OnlyIfExists: Bool): TAtom; cdecl;
{$EXTERNALSYM XInternAtom}

function XInternAtoms(Display: PDisplay; Names: PPChar; Count: Longint;
  OnlyIfExists: Bool; AtomsReturn: PAtom): TStatus; cdecl;
{$EXTERNALSYM XInternAtoms}

function XCopyColormapAndFree(Display: PDisplay; ColorMap: TColorMap):
  TColorMap; cdecl;
{$EXTERNALSYM XCopyColormapAndFree}

function XCreateColormap(Display: PDisplay; W: TWindow; Visual: PVisual;
  Alloc: Longint): TColorMap; cdecl;
{$EXTERNALSYM XCreateColormap}

function XCreatePixmapCursor(Display: PDisplay; Source: TPixmap; Mask: TPixmap;
  ForegroundColor: PXColor; BackgroundColor: PXColor; X, Y: Cardinal): TCursor; cdecl;
{$EXTERNALSYM XCreatePixmapCursor}

function XCreateGlyphCursor(Display: PDisplay; SourceFont: TFont;
  MaskFont: TFont; SourceChar, MaskChar: Cardinal;
  ForegroundColor, BackgroundColor: PXColor): TCursor; cdecl;
{$EXTERNALSYM XCreateGlyphCursor}

function XCreateFontCursor(Display: PDisplay; Shape: Cardinal): TCursor; cdecl;
{$EXTERNALSYM XCreateFontCursor}

function XLoadFont(Display: PDisplay; Name: PChar): TFont; cdecl;
{$EXTERNALSYM XLoadFont}

function XCreateGC(Display: PDisplay; D: TDrawable; ValueMask: Cardinal;
  Values: PXGCValues): TGC; cdecl;
{$EXTERNALSYM XCreateGC}

function XGContextFromGC(GC: TGC): TGContext; cdecl;
{$EXTERNALSYM XGContextFromGC}

procedure XFlushGC(Display: PDisplay; GC: TGC); cdecl;
{$EXTERNALSYM XFlushGC}

function XCreatePixmap(Display: PDisplay; D: TDrawable; Width, Height: Cardinal;
  Depth: Cardinal): TPixmap; cdecl;
{$EXTERNALSYM XCreatePixmap}

function XCreateBitmapFromData(Display: PDisplay; D: TDrawAble;
   Data: Pointer; Width: Cardinal; Height: Cardinal): TPixmap; cdecl;
{$EXTERNALSYM XCreateBitmapFromData}

function XCreatePixmapFromBitmapData(Display: PDisplay; D: TDrawable;
  Data: PChar; Width, Height: Cardinal; Fg, Bg: Cardinal; Depth: Cardinal):
  TPixmap; cdecl;
{$EXTERNALSYM XCreatePixmapFromBitmapData}

function XCreateSimpleWindow(Display: PDisplay;  Parent: TWindow; X, Y: Longint;
  Width, Height: Cardinal; BorderWidth: Cardinal; Border: Cardinal;
  Background: Cardinal): TWindow; cdecl;
{$EXTERNALSYM XCreateSimpleWindow}

function XGetSelectionOwner(Display: PDisplay; Selection: TAtom): TWindow; cdecl;
{$EXTERNALSYM XGetSelectionOwner}

function XCreateWindow(Display: PDisplay; Parent: TWindow; X, Y: Longint;
  Width, Height: Cardinal; BorderWidth: Cardinal; Depth: Longint;
  AClass: Cardinal; Visual: PVisual; ValueMask: Cardinal;
  Attributes: PXSetWindowAttributes): TWindow; cdecl;
{$EXTERNALSYM XCreateWindow}

function XListInstalledColormaps(Display: PDisplay; W: TWindow;
  NumReturn: PLongint): PColorMap; cdecl;
{$EXTERNALSYM XListInstalledColormaps}

function XGetFontPath(Display: PDisplay; NPathsReturn: PLongint): PPChar; cdecl;
{$EXTERNALSYM XGetFontPath}

function XListExtensions(Display: PDisplay; NExtensions: PLongint): PPChar; cdecl;
{$EXTERNALSYM XListExtensions}

function XListProperties(Display: PDisplay; W: TWindow;
  NumPropReturn: PLongint): PAtom; cdecl;
{$EXTERNALSYM XListProperties}

function XListHosts(Display: PDisplay; NHostsReturn: PLongint;
  StateReturn: PBool): PXHostAddress; cdecl;
{$EXTERNALSYM XListHosts}

function XKeycodeToKeysym(Display: PDisplay; KeyCode: TKeyCode; Index: Longint):
  TKeySym; cdecl;
{$EXTERNALSYM XKeycodeToKeysym}

function XLookupKeysym(KeyEvent: PXKeyEvent; Index: Longint): TKeySym; cdecl;
{$EXTERNALSYM XLookupKeysym}

function XGetKeyboardMapping(Display: PDisplay; FirstKeyCode: TKeyCode;
  KeyCount: Longint; KeySymsPerKeyCodeReturn: PLongint): PKeySym; cdecl;
{$EXTERNALSYM XGetKeyboardMapping}

function XStringToKeysym(S: PChar): TKeySym; cdecl;
{$EXTERNALSYM XStringToKeysym}

function XMaxRequestSize(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XMaxRequestSize}

function XExtendedMaxRequestSize(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XExtendedMaxRequestSize}

function XResourceManagerString(Display: PDisplay): PChar; cdecl;
{$EXTERNALSYM XResourceManagerString}

function XScreenResourceString(Screen: PScreen): PChar; cdecl;
{$EXTERNALSYM XScreenResourceString}

function XDisplayMotionBufferSize(Display: PDisplay): Cardinal; cdecl;
{$EXTERNALSYM XDisplayMotionBufferSize}

function XVisualIDFromVisual(Visual: PVisual): VisualID; cdecl;
{$EXTERNALSYM XVisualIDFromVisual}

    { multithread routines  }

function XInitThreads: TStatus; cdecl;
{$EXTERNALSYM XInitThreads}

procedure XLockDisplay(Display: PDisplay); cdecl;
{$EXTERNALSYM XLockDisplay}

procedure XUnlockDisplay(Display: PDisplay); cdecl;
{$EXTERNALSYM XUnlockDisplay}

function XAddExtension(Display: PDisplay): PXExtCodes; cdecl;
{$EXTERNALSYM XAddExtension}

function XFindOnExtensionList(_para1: PPXExtData; _para2: Longint): PXExtData; cdecl;
{$EXTERNALSYM XFindOnExtensionList}

function XEHeadOfExtensionList(AObject: XEDataObject): PPXExtData; cdecl;
{$EXTERNALSYM XEHeadOfExtensionList}

    { these are routines for which there are also macros  }

function XRootWindow(Display: PDisplay; ScreenNumber: Longint): TWindow; cdecl;
{$EXTERNALSYM XRootWindow}

function XDefaultRootWindow(Display: PDisplay): TWindow; cdecl;
{$EXTERNALSYM XDefaultRootWindow}

function XRootWindowOfScreen(Screen: PScreen): TWindow; cdecl;
{$EXTERNALSYM XRootWindowOfScreen}

function XDefaultVisual(Display: PDisplay; ScreenNumber: Longint): PVisual; cdecl;
{$EXTERNALSYM XDefaultVisual}

function XDefaultVisualOfScreen(Screen: PScreen): PVisual; cdecl;
{$EXTERNALSYM XDefaultVisualOfScreen}

function XDefaultGC(Display: PDisplay; ScreenNumber: Longint): TGC; cdecl;
{$EXTERNALSYM XDefaultGC}

function XDefaultGCOfScreen(Screen: PScreen): TGC; cdecl;
{$EXTERNALSYM XDefaultGCOfScreen}

function XBlackPixel(Display: PDisplay; ScreenNumber: Longint): Cardinal; cdecl;
{$EXTERNALSYM XBlackPixel}

function XWhitePixel(Display: PDisplay; ScreenNumber: Longint): Cardinal; cdecl;
{$EXTERNALSYM XWhitePixel}

function XAllPlanes: Cardinal; cdecl;
{$EXTERNALSYM XAllPlanes}

function XBlackPixelOfScreen(Screen: PScreen): Cardinal; cdecl;
{$EXTERNALSYM XBlackPixelOfScreen}

function XWhitePixelOfScreen(Screen: PScreen): Cardinal; cdecl;
{$EXTERNALSYM XWhitePixelOfScreen}

function XNextRequest(Display: PDisplay): Cardinal; cdecl;
{$EXTERNALSYM XNextRequest}

function XLastKnownRequestProcessed(Display: PDisplay): Cardinal; cdecl;
{$EXTERNALSYM XLastKnownRequestProcessed}

function XServerVendor(Display: PDisplay): PChar; cdecl;
{$EXTERNALSYM XServerVendor}

function XDisplayString(Display: PDisplay): PChar; cdecl;
{$EXTERNALSYM XDisplayString}

function XDefaultColormap(Display: PDisplay; ScreenNumber: Longint): TColorMap; cdecl;
{$EXTERNALSYM XDefaultColormap}

function XDefaultColormapOfScreen(Screen: PScreen): TColorMap; cdecl;
{$EXTERNALSYM XDefaultColormapOfScreen}

function XDisplayOfScreen(Screen: PScreen): PDisplay; cdecl;
{$EXTERNALSYM XDisplayOfScreen}

function XScreenOfDisplay(Display: PDisplay; ScreenNumber: Longint): PScreen; cdecl;
{$EXTERNALSYM XScreenOfDisplay}

function XDefaultScreenOfDisplay(Display: PDisplay): PScreen; cdecl;
{$EXTERNALSYM XDefaultScreenOfDisplay}

function XEventMaskOfScreen(Screen: PScreen): Longint; cdecl;
{$EXTERNALSYM XEventMaskOfScreen}

function XScreenNumberOfScreen(Screen: PScreen): Longint; cdecl;
{$EXTERNALSYM XScreenNumberOfScreen}

    { WARNING, this type not in Xlib spec  }
type
  XErrorHandler = function (Display: PDisplay; ErrorEvent: PXErrorEvent):
    Longint; cdecl;
  {$EXTERNALSYM XErrorHandler}

function XSetErrorHandler(Handler: XErrorHandler): XErrorHandler; cdecl;
{$EXTERNALSYM XSetErrorHandler}

    { WARNING, this type not in Xlib spec  }

type
  XIOErrorHandler = function (Display: PDisplay): Longint; cdecl;
  {$EXTERNALSYM XIOErrorHandler}

function XSetIOErrorHandler(Handler: XIOErrorHandler): XIOErrorHandler; cdecl;
{$EXTERNALSYM XSetIOErrorHandler}

function XListPixmapFormats(Display: PDisplay; CountReturn: PLongint):
  PXPixmapFormatValues; cdecl;
{$EXTERNALSYM XListPixmapFormats}

function XListDepths(Display: PDisplay; ScreenNumber: Longint;
  CountReturn: PLongint): PLongint; cdecl;
{$EXTERNALSYM XListDepths}

    { ICCCM routines for things that don't require special include files;  }
    { other declarations are given in Xutil.h                              }

function XReconfigureWMWindow(Display: PDisplay; W: TWindow;
  ScreenNumber: Longint; Mask: Cardinal; Changes: PXWindowChanges): TStatus;
  cdecl;
{$EXTERNALSYM XReconfigureWMWindow}

function XGetWMProtocols(Display: PDisplay; W: TWindow; ProtocolsReturn: PPAtom;
  CountReturn: PLongint): TStatus; cdecl;
{$EXTERNALSYM XGetWMProtocols}

function XSetWMProtocols(Display: PDisplay; W: TWindow; Protocols: PAtom;
  Count: Longint): TStatus; cdecl;
{$EXTERNALSYM XSetWMProtocols}

function XIconifyWindow(Display: PDisplay; W: TWindow; Screen_Number: Longint):
  TStatus; cdecl;
{$EXTERNALSYM XIconifyWindow}

function XWithdrawWindow(Display: PDisplay; W: TWindow;
  ScreenNumber: Longint): TStatus; cdecl;
{$EXTERNALSYM XWithdrawWindow}

function XGetCommand(Display: PDisplay; W: TWindow; ArgvReturn: PPPChar;
  ArgcReturn: PLongint): TStatus; cdecl;
{$EXTERNALSYM XGetCommand}

function XGetWMColormapWindows(Display: PDisplay; W: TWindow;
  WindowsReturn: PPWindow; CountReturn: PLongint): TStatus; cdecl;
{$EXTERNALSYM XGetWMColormapWindows}

function XSetWMColormapWindows(Display: PDisplay; W: TWindow;
  ColorMapWindows: PWindow; Count: Longint): TStatus; cdecl;
{$EXTERNALSYM XSetWMColormapWindows}

procedure XFreeStringList(List: PPChar); cdecl;
{$EXTERNALSYM XFreeStringList}

function XSetTransientForHint(Display: PDisplay; W: TWindow;
  PropWindow: TWindow): Longint; cdecl;
{$EXTERNALSYM XSetTransientForHint}

    { The following are given in alphabetical order  }

function XActivateScreenSaver(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XActivateScreenSaver}

function XAddHost(Display: PDisplay; Host: PXHostAddress): Longint; cdecl;
{$EXTERNALSYM XAddHost}

function XAddHosts(Display: PDisplay; Hosts: PXHostAddress;
  NumHosts: Longint): Longint; cdecl;
{$EXTERNALSYM XAddHosts}

function XAddToExtensionList(Structure: Pointer; ExtData: PXExtData): Longint; cdecl;
{$EXTERNALSYM XAddToExtensionList}

function XAddToSaveSet(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XAddToSaveSet}

function XAllocColor(Display: PDisplay; ColorMap: TColorMap;
  ScreenInOut: PXColor): TStatus; cdecl;
{$EXTERNALSYM XAllocColor}

function XAllocColorCells(Display: PDisplay; ColorMap: TColorMap; Contig: Bool;
  PlanesMasksReturn: PCardinal; NPlanes: Cardinal; PixelsReturn: PCardinal;
  NPixels: Cardinal): TStatus; cdecl;
{$EXTERNALSYM XAllocColorCells}

function XAllocColorPlanes(Display: PDisplay; ColorMap: TColorMap; Contig: Bool;
  PixelsReturn: PCardinal; NColors: Longint; NReds: Longint; NGreens: Longint;
  NBlues: Longint; RMaskReturn: PCardinal; GMaskReturn: PCardinal;
  BMaskReturn: PCardinal): TStatus; cdecl;
{$EXTERNALSYM XAllocColorPlanes}

function XAllowEvents(Display: PDisplay; EventMode: Longint; Time: TTime):
  Longint; cdecl;
{$EXTERNALSYM XAllowEvents}

function XAutoRepeatOff(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XAutoRepeatOff}

function XAutoRepeatOn(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XAutoRepeatOn}

function XBell(Display: PDisplay; Percent: Longint): Longint; cdecl;
{$EXTERNALSYM XBell}

function XBitmapBitOrder(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XBitmapBitOrder}

function XBitmapPad(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XBitmapPad}

function XBitmapUnit(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XBitmapUnit}

function XCellsOfScreen(Screen: PScreen): Longint; cdecl;
{$EXTERNALSYM XCellsOfScreen}

function XChangeActivePointerGrab(Display: PDisplay; EventMask: Cardinal;
  Cursor: TCursor; Time: TTime): Longint; cdecl;
{$EXTERNALSYM XChangeActivePointerGrab}

function XChangeGC(Display: PDisplay; GC: TGC; ValueMask: Cardinal;
  Values: PXGCValues): Longint; cdecl;
{$EXTERNALSYM XChangeGC}

function XChangeKeyboardControl(Display: PDisplay; ValueMask: Cardinal;
  Values: PXKeyboardControl): Longint; cdecl;
{$EXTERNALSYM XChangeKeyboardControl}

function XChangeKeyboardMapping(Display: PDisplay; FirstKeyCode: Longint;
  KeySymsPerKeyCode: Longint; KeySyms: PKeySym; NumCodes: Longint): Longint;
  cdecl;
{$EXTERNALSYM XChangeKeyboardMapping}

function XChangePointerControl(Display: PDisplay; DoAccel: Bool;
  DoThreshold: Bool; AccelNumerator: Longint; AccelDenominator: Longint;
  Threshold: Longint): Longint; cdecl;
{$EXTERNALSYM XChangePointerControl}

function XChangeSaveSet(Display: PDisplay; W: TWindow; ChangeMode: Longint):
  Longint; cdecl;
{$EXTERNALSYM XChangeSaveSet}

function XChangeWindowAttributes(Display: PDisplay; W: TWindow;
  ValueMask: Cardinal; Attributes: PXSetWindowAttributes): Longint; cdecl;
{$EXTERNALSYM XChangeWindowAttributes}

type
  XCheckIfEventProc = function (Display: PDisplay; Event: PXEvent;
    Arg: XPointer): Bool; cdecl;
  {$EXTERNALSYM XCheckIfEventProc}

function XCheckIfEvent(Display: PDisplay; EventReturn: PXEvent;
  Predicate: XCheckIfEventProc; Arg: XPointer): Bool; cdecl;
{$EXTERNALSYM XCheckIfEvent}

function XCheckMaskEvent(Display: PDisplay; EventMask: Longint;
  EventReturn: PXEvent): Bool; cdecl;
{$EXTERNALSYM XCheckMaskEvent}

function XCheckTypedEvent(Display: PDisplay;  EventType: Longint;
  EventReturn: PXEvent): Bool; cdecl;
{$EXTERNALSYM XCheckTypedEvent}

function XCheckTypedWindowEvent(Display: PDisplay; W: TWindow;
  EventType: Longint; EventReturn: PXEvent): Bool; cdecl;
{$EXTERNALSYM XCheckTypedWindowEvent}

function XCheckWindowEvent(Display: PDisplay; W: TWindow; EventMask: Longint;
  EventReturn: PXEvent): Bool; cdecl;
{$EXTERNALSYM XCheckWindowEvent}

function XCirculateSubwindows(Display: PDisplay; W: TWindow;
  Direction: Longint): Longint; cdecl;
{$EXTERNALSYM XCirculateSubwindows}

function XCirculateSubwindowsDown(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XCirculateSubwindowsDown}

function XCirculateSubwindowsUp(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XCirculateSubwindowsUp}

function XClearArea(Display: PDisplay; W: TWindow; X, Y: Longint;
  Width, Height: Cardinal; Exposures: Bool): Longint; cdecl;
{$EXTERNALSYM XClearArea}

function XClearWindow(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XClearWindow}

function XCloseDisplay(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XCloseDisplay}

function XConfigureWindow(Display: PDisplay; W: TWindow; ValueMask: Cardinal;
  Values: PXWindowChanges): Longint; cdecl;
{$EXTERNALSYM XConfigureWindow}

function XConnectionNumber(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XConnectionNumber}

function XConvertSelection(Display: PDisplay; Selection: TAtom; Target: TAtom;
  AProperty: TAtom; Requestor: TWindow; Time: TTime): Longint; cdecl;
{$EXTERNALSYM XConvertSelection}

function XCopyArea(Display: PDisplay; Src, Dest: TDrawable; GC: TGC;
  SrcX, SrcY: Longint; Width, Height: Cardinal; DestX, DestY: Longint): Longint;
  cdecl;
{$EXTERNALSYM XCopyArea}

function XCopyGC(Display: PDisplay; Src: TGC; ValueMask: Cardinal; Dest: TGC):
  Longint; cdecl;
{$EXTERNALSYM XCopyGC}

function XCopyPlane(Display: PDisplay; Src: TDrawable; Dest: TDrawable; GC: TGC;
  SrcX, SrcY: Longint; Width, Height: Cardinal; DestX, DestY: Longint;
  Plane: Cardinal): Longint; cdecl;
{$EXTERNALSYM XCopyPlane}

function XDefaultDepth(Display: PDisplay; ScreenNumber: Longint): Longint; cdecl;
{$EXTERNALSYM XDefaultDepth}

function XDefaultDepthOfScreen(Screen: PScreen): Longint; cdecl;
{$EXTERNALSYM XDefaultDepthOfScreen}

function XDefaultScreen(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XDefaultScreen}

function XDefineCursor(Display: PDisplay; W: TWindow; Cursor: TCursor): Longint; cdecl;
{$EXTERNALSYM XDefineCursor}

function XDeleteProperty(Display: PDisplay; W: TWindow; AProperty: TAtom):
  Longint; cdecl;
{$EXTERNALSYM XDeleteProperty}

function XDestroyWindow(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XDestroyWindow}

function XDestroySubwindows(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XDestroySubwindows}

function XDoesBackingStore(Screen: PScreen): Longint; cdecl;
{$EXTERNALSYM XDoesBackingStore}

function XDoesSaveUnders(Screen: PScreen): Bool; cdecl;
{$EXTERNALSYM XDoesSaveUnders}

function XDisableAccessControl(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XDisableAccessControl}

function XDisplayCells(Display: PDisplay; ScreenNumber: Longint): Longint; cdecl;
{$EXTERNALSYM XDisplayCells}

function XDisplayHeight(Display: PDisplay; ScreenNumber: Longint): Longint; cdecl;
{$EXTERNALSYM XDisplayHeight}

function XDisplayHeightMM(Display: PDisplay; ScreenNumber: Longint): Longint; cdecl;
{$EXTERNALSYM XDisplayHeightMM}

function XDisplayKeycodes(Display: PDisplay; MinKeyCodesReturn: PLongint;
  MaxKeyCodesReturn: PLongint): Longint; cdecl;
{$EXTERNALSYM XDisplayKeycodes}

function XDisplayPlanes(Display: PDisplay; ScreenNumber: Longint): Longint; cdecl;
{$EXTERNALSYM XDisplayPlanes}

function XDisplayWidth(Display: PDisplay; ScreenNumber: Longint): Longint; cdecl;
{$EXTERNALSYM XDisplayWidth}

function XDisplayWidthMM(Display: PDisplay; ScreenNumber: Longint): Longint; cdecl;
{$EXTERNALSYM XDisplayWidthMM}

function XDrawArc(Display: PDisplay; D: TDrawable; GC: TGC; X, Y: Longint;
  Width, Height: Cardinal; Angle1, Angle2: Longint): Longint; cdecl;
{$EXTERNALSYM XDrawArc}

function XDrawArcs(Display: PDisplay; D: TDrawable; GC: TGC; Arcs: PXArc;
  NArcs: Longint): Longint; cdecl;
{$EXTERNALSYM XDrawArcs}

function XDrawLine(Display: PDisplay; D: TDrawable; GC: TGC;
  X1, X2, Y1, Y2: Longint): Longint; cdecl;
{$EXTERNALSYM XDrawLine}

function XDrawLines(Display: PDisplay; D: TDrawable; GC: TGC; Points: PXPoint;
  NPoints: Longint; Mode: Longint): Longint; cdecl;
{$EXTERNALSYM XDrawLines}

function XDrawPoint(Display: PDisplay; D: TDrawable; GC: TGC; X, Y: Longint):
  Longint; cdecl;
{$EXTERNALSYM XDrawPoint}

function XDrawPoints(Display: PDisplay; D: TDrawable; GC: TGC; Points: PXPoint;
  NPoints: Longint; Mode: Longint): Longint; cdecl;
{$EXTERNALSYM XDrawPoints}

function XDrawRectangle(PDisplay: PDisplay; D: TDrawable; GC: TGC;
  X, Y: Longint; Width, Height: Cardinal): Longint; cdecl;
{$EXTERNALSYM XDrawRectangle}

function XDrawRectangles(Display: PDisplay; D: TDrawable; GC: TGC;
  Rectangles: PXRectangle; NRectangles: Longint): Longint; cdecl;
{$EXTERNALSYM XDrawRectangles}

function XDrawSegments(Display: PDisplay; D: TDrawable; GC: TGC;
  Segments: PXSegment; NSegments: Longint): Longint; cdecl;
{$EXTERNALSYM XDrawSegments}

procedure XDrawString(Display: PDisplay; D: TDrawable; GC: TGC;
  X, Y: Integer; S: PChar; Len: Integer); cdecl;
{$EXTERNALSYM XDrawString}

function XDrawText(Display: PDisplay; D: TDrawable; GC: TGC; X, Y: Longint;
  Items: PXTextItem; NItems: Longint): Longint; cdecl;
{$EXTERNALSYM XDrawText}

function XDrawText16(Display: PDisplay; D: TDrawable; GC: TGC; X, Y: Longint;
  Items: PXTextItem16; NItems: Longint): Longint; cdecl;
{$EXTERNALSYM XDrawText16}

function XEnableAccessControl(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XEnableAccessControl}

function XEventsQueued(Display: PDisplay; Mode: Longint): Longint; cdecl;
{$EXTERNALSYM XEventsQueued}

function XFetchName(Display: PDisplay; W: TWindow; WindowNameReturn: PPChar):
  TStatus; cdecl;
{$EXTERNALSYM XFetchName}

function XFillArc(Display: PDisplay; D: TDrawable; GC: TGC; X, Y: Longint;
  Width, Height: Cardinal; Angle1, Angle2: Longint): Longint; cdecl;
{$EXTERNALSYM XFillArc}

function XFillArcs(Display: PDisplay; D: TDrawable; GC: TGC; Arcs: PXArc;
  NArcs: Longint): Longint; cdecl;
{$EXTERNALSYM XFillArcs}

function XFillPolygon(Display: PDisplay; D: TDrawable; GC: TGC; Points: PXPoint;
  NPoints: Longint; Shape: Longint; Move: Longint): Longint; cdecl;
{$EXTERNALSYM XFillPolygon}

function XFillRectangle(Display: PDisplay; D: TDrawable; GC: TGC; X, Y: Longint;
  Width, Height: Cardinal): Longint; cdecl;
{$EXTERNALSYM XFillRectangle}

function XFillRectangles(Display: PDisplay; D: TDrawable; GC: TGC;
  Rectangles: PXRectangle; NRectangles: Longint): Longint; cdecl;
{$EXTERNALSYM XFillRectangles}

function XFlush(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XFlush}

function XForceScreenSaver(Display: PDisplay; Mode: Longint): Longint; cdecl;
{$EXTERNALSYM XForceScreenSaver}

function XFree(Data: Pointer): Longint; cdecl;
{$EXTERNALSYM XFree}

function XFreeColormap(Display: PDisplay; ColorMap: TColorMap): Longint; cdecl;
{$EXTERNALSYM XFreeColormap}

function XFreeColors(Display: PDisplay; ColorMap: TColorMap; Pixels: PCardinal;
  NPixels: Longint; Planes: Cardinal): Longint; cdecl;
{$EXTERNALSYM XFreeColors}

function XFreeCursor(Display: PDisplay; Cursor: TCursor): Longint; cdecl;
{$EXTERNALSYM XFreeCursor}

function XFreeExtensionList(List: PPChar): Longint; cdecl;
{$EXTERNALSYM XFreeExtensionList}

function XFreeFont(Display: PDisplay; FontStruct: PXFontStruct): Longint; cdecl;
{$EXTERNALSYM XFreeFont}

function XFreeFontInfo(Names: PPChar; FreeInfo: PXFontStruct;
  ActualCount: Longint): Longint; cdecl;
{$EXTERNALSYM XFreeFontInfo}

function XFreeFontNames(List: PPChar): Longint; cdecl;
{$EXTERNALSYM XFreeFontNames}

function XFreeFontPath(_para1: PPChar): Longint; cdecl;
{$EXTERNALSYM XFreeFontPath}

function XFreeGC(Display: PDisplay; GC: TGC): Longint; cdecl;
{$EXTERNALSYM XFreeGC}

function XFreeModifiermap(ModMap: PXModifierKeymap): Longint; cdecl;
{$EXTERNALSYM XFreeModifiermap}

function XFreePixmap(Display: PDisplay; PixMap: TPixmap): Longint; cdecl;
{$EXTERNALSYM XFreePixmap}

function XGetErrorText(Display: PDisplay; Code: Longint; BufferReturn: PChar;
  ALength: Longint): Longint; cdecl;
{$EXTERNALSYM XGetErrorText}

function XGetFontProperty(FontStruct: PXFontStruct; Atom: TAtom;
  ValueReturn: PCardinal): Bool; cdecl;
{$EXTERNALSYM XGetFontProperty}

function XGetGCValues(Display: PDisplay; GC: TGC; ValueMask: Cardinal;
  ValuesReturn: PXGCValues): TStatus; cdecl;
{$EXTERNALSYM XGetGCValues}

function XGetGeometry(Display: PDisplay; D: TDrawable; RootReturn: PWindow;
  XReturn, YReturn: PLongint; WidthReturn, HeightReturn: PCardinal;
  BorderWidthReturn: PCardinal; DepthReturn: PCardinal): TStatus; cdecl;
{$EXTERNALSYM XGetGeometry}

function XGetIconName(Display: PDisplay; W: TWindow; IconNameReturn: PPChar):
  TStatus; cdecl;
{$EXTERNALSYM XGetIconName}

function XGetInputFocus(Display: PDisplay; FocusReturn: PWindow;
  ReverttoReturn: PLongint): Longint; cdecl;
{$EXTERNALSYM XGetInputFocus}

function XGetKeyboardControl(Display: PDisplay; ValuesReturn: PXKeyboardState):
  Longint; cdecl;
{$EXTERNALSYM XGetKeyboardControl}

function XGetPointerControl(Display: PDisplay; AccelNumeratorReturn: PLongint;
  AccelDenominatorReturn: PLongint; ThresholdReturn: PLongint): Longint; cdecl;
{$EXTERNALSYM XGetPointerControl}

function XGetPointerMapping(Display: PDisplay; MapReturn: PByte; NMap: Longint): Longint; cdecl;
{$EXTERNALSYM XGetPointerMapping}

function XSetPointerMapping(Display: PDisplay; MapReturn: PByte; NMap: Longint): Longint; cdecl;
{$EXTERNALSYM XSetPointerMapping}

function XGetScreenSaver(Dispaly: PDisplay; TimeOutReturn: PLongint;
  IntervalReturn: PLongint; PreferBlankingReturn: PLongint;
  AllowExposuresReturn: PLongint): Longint; cdecl;
{$EXTERNALSYM XGetScreenSaver}

function XGetTransientForHint(Display: PDisplay; W: TWindow;
  PropWindowReturn: PWindow): TStatus; cdecl;
{$EXTERNALSYM XGetTransientForHint}

function XGetWindowProperty(Display: PDisplay; W: TWindow; AProperty: TAtom;
  LongOffset: Longint; LongLength: Longint; Delete: Bool; ReqType: TAtom;
  ActualTypeReturn: PAtom; ActualFormatReturn: PLongint;
  NItemsReturn: PCardinal; BytesAfterReturn: PCardinal; PropReturn: PPByte):
  Longint; cdecl;
{$EXTERNALSYM XGetWindowProperty}

function XChangeProperty(Display: PDisplay; W: TWindow;
   AProperty, AType: TAtom; Format, Mode: Longint; Data: PByte; 
   NElements: Longint): Longint; cdecl;
{$EXTERNALSYM XChangeProperty}

function XGetWindowAttributes(Display: PDisplay; W: TWindow;
  WindowAttributesReturn: PXWindowAttributes): TStatus; cdecl;
{$EXTERNALSYM XGetWindowAttributes}

function XGrabButton(Display: PDisplay; Button: Cardinal; Modifiers: Cardinal;
  GrabWindow: TWindow; OwnerEvents: Bool;  EventMask: Cardinal;
  PointerMode: Longint; KeyboardMode: Longint; ConfineTo: TWindow;
  Cursor: TCursor): Longint; cdecl;
{$EXTERNALSYM XGrabButton}

function XGrabKey(Display: PDisplay; Keycode: Longint; Modifer: Cardinal;
  GrabWindow: TWindow; OwnerEvents: Bool; PointerMode: Longint;
  KeyboardMode: Longint): Longint; cdecl;
{$EXTERNALSYM XGrabKey}

function XGrabKeyboard(Display: PDisplay; GrabWindow: TWindow;
  OwnerEvents: Bool; PointerMode: Longint; KeyboardMode: Longint;
  Time: TTime): Longint; cdecl;
{$EXTERNALSYM XGrabKeyboard}

function XGrabPointer(Display: PDisplay; GrabWindow: TWindow; OwnerEvents: Bool;
  EventMask: Cardinal; PointerMode: Longint; KeyboardMode: Longint;
  ConfineTo: TWindow; Cursor: TCursor; Time: TTime): Longint; cdecl;
{$EXTERNALSYM XGrabPointer}

function XGrabServer(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XGrabServer}

function XHeightMMOfScreen(Screen: PScreen): Longint; cdecl;
{$EXTERNALSYM XHeightMMOfScreen}

function XHeightOfScreen(Screen: PScreen): Longint; cdecl;
{$EXTERNALSYM XHeightOfScreen}

type
  XIfEventProc = function (Display: PDisplay; Event: PXEvent; Arg: XPointer):
  Bool; cdecl;
  {$EXTERNALSYM XIfEventProc}

function XIfEvent(Display: PDisplay; EventReturn: PXEvent;
  Predicate: XIfEventProc; Arg: XPointer): Longint; cdecl;
{$EXTERNALSYM XIfEvent}

function XImageByteOrder(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XImageByteOrder}

function XInstallColormap(Display: PDisplay; ColorMap: TColorMap): Longint; cdecl;
{$EXTERNALSYM XInstallColormap}

function XKeysymToKeycode(Display: PDisplay; KeySym: TKeySym): TKeyCode; cdecl;
{$EXTERNALSYM XKeysymToKeycode}

function XKillClient(Display: PDisplay; Resource: XID): Longint; cdecl;
{$EXTERNALSYM XKillClient}

function XLowerWindow(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XLowerWindow}

function XMapRaised(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XMapRaised}

function XMapSubwindows(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XMapSubwindows}

function XMapWindow(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XMapWindow}

function XMaskEvent(Display: PDisplay; EventMask: Longint;
  EventReturn: PXEvent): Longint; cdecl;
{$EXTERNALSYM XMaskEvent}

function XMaxCmapsOfScreen(Screen: PScreen): Longint; cdecl;
{$EXTERNALSYM XMaxCmapsOfScreen}

function XMinCmapsOfScreen(Screen: PScreen): Longint; cdecl;
{$EXTERNALSYM XMinCmapsOfScreen}

function XMoveResizeWindow(Display: PDisplay; W: TWindow; X, Y: Longint;
  Width, Height: Cardinal): Longint; cdecl;
{$EXTERNALSYM XMoveResizeWindow}

function XMoveWindow(Display: PDisplay; W: TWindow; X, Y: Longint):
  Longint; cdecl;
{$EXTERNALSYM XMoveWindow}

function XNextEvent(Display: PDisplay; EventReturn: PXEvent): Longint; cdecl;
{$EXTERNALSYM XNextEvent}

function XNoOp(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XNoOp}

function XParseColor(Display: PDisplay; ColorMap: TColorMap; Spec: PChar;
  Exact_Def_Return: PXColor): TStatus; cdecl;
{$EXTERNALSYM XParseColor}

function XPeekEvent(Display: PDisplay; EventReturn: PXEvent): Longint; cdecl;
{$EXTERNALSYM XPeekEvent}

type
  XPeekIfEventProc = function (Display: PDisplay; Event: PXEvent; Arg: XPointer): Bool; cdecl;
  {$EXTERNALSYM XPeekIfEventProc}

function XPeekIfEvent(Display: PDisplay; EventReturn: PXEvent;
  Predicate: XPeekIfEventProc; Arg: XPointer): Longint; cdecl;
{$EXTERNALSYM XPeekIfEvent}

function XPending(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XPending}

function XPlanesOfScreen(Screen: PScreen): Longint; cdecl;
{$EXTERNALSYM XPlanesOfScreen}

function XProtocolRevision(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XProtocolRevision}

function XProtocolVersion(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XProtocolVersion}

function XPutBackEvent(Display: PDisplay; Event: PXEvent): Longint; cdecl;
{$EXTERNALSYM XPutBackEvent}

function XPutImage(Display: PDisplay; D: TDrawable; GC: TGC; Image: PXImage;
  SrcX, SrcY: Longint; DestX, DestY: Longint; Width, Height: Cardinal): Longint;
  cdecl;
{$EXTERNALSYM XPutImage}

function XQLength(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XQLength}

function XQueryBestCursor(Display: PDisplay; D: TDrawable;
  Width, Height: Cardinal; WidthReturn, HeightReturn: PCardinal): TStatus;
  cdecl;
{$EXTERNALSYM XQueryBestCursor}

function XQueryBestSize(Display: PDisplay; AClass: Longint;
  WhichScreen: TDrawable; Width, Height: Cardinal;
  WidthReturn, HeightReturn: PCardinal): TStatus; cdecl;
{$EXTERNALSYM XQueryBestSize}

function XQueryBestStipple(Display: PDisplay; WhichScreen: TDrawable;
  Width, Height: Cardinal; WidthReturn, HeightReturn: PCardinal): TStatus;
  cdecl;
{$EXTERNALSYM XQueryBestStipple}

function XQueryBestTile(Display: PDisplay; WhichScreen: TDrawable;
  Width, Height: Cardinal; WidthReturn, HeightReturn: PCardinal): TStatus;
  cdecl;
{$EXTERNALSYM XQueryBestTile}

function XQueryColor(Display: PDisplay; ColorMap: TColorMap; DefInOut: PXColor):
  Longint; cdecl;
{$EXTERNALSYM XQueryColor}

function XQueryColors(Display: PDisplay; ColorMap: TColorMap;
  DefsInOut: PXColor; NColors: Longint): Longint; cdecl;
{$EXTERNALSYM XQueryColors}

type
  TXQueryKeymap = array[0..31] of Char;
  {$EXTERNALSYM TXQueryKeymap}

function XQueryKeymap(Display: PDisplay; KeyMap: TXQueryKeyMap): Longint; cdecl;
{$EXTERNALSYM XQueryKeymap}

function XQueryPointer(Display: PDisplay; W: TWindow; RootRetun: PWindow;
  ChildReturn: PWindow; RootXReturn, RootYReturn: PLongint;
  WinXReturn, WinYReturn: PLongint; MaskReturn: PCardinal): Bool; cdecl;
{$EXTERNALSYM XQueryPointer}

function XQueryTree(Display: PDisplay; W: TWindow; RootReturn: PWindow;
  ParentReturn: PWindow; _para5: PPWindow; NChildrenReturn: PCardinal): TStatus;
  cdecl;
{$EXTERNALSYM XQueryTree}

function XRaiseWindow(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XRaiseWindow}

function XRecolorCursor(Display: PDisplay; Cursor: TCursor;
  ForegroundColor, BackgroundColor: PXColor): Longint; cdecl;
{$EXTERNALSYM XRecolorCursor}

function XRefreshKeyboardMapping(EventMap: PXMappingEvent): Longint; cdecl;
{$EXTERNALSYM XRefreshKeyboardMapping}

function XRemoveFromSaveSet(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XRemoveFromSaveSet}

function XRemoveHost(Display: PDisplay; Host: PXHostAddress): Longint; cdecl;
{$EXTERNALSYM XRemoveHost}

function XRemoveHosts(Display: PDisplay; Hosts: PXHostAddress;
  NumHosts: Longint): Longint; cdecl;
{$EXTERNALSYM XRemoveHosts}

function XReparentWindow(Display: PDisplay; W: TWindow; Parent: TWindow;
  X, Y: Longint): Longint; cdecl;
{$EXTERNALSYM XReparentWindow}

function XResetScreenSaver(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XResetScreenSaver}

function XResizeWindow(Display: PDisplay; W: TWindow; Width, Height: Cardinal):
  Longint; cdecl;
{$EXTERNALSYM XResizeWindow}

function XRestackWindows(Display: PDisplay; Windows: PWindow; NWindows: Longint):
  Longint; cdecl;
{$EXTERNALSYM XRestackWindows}

function XRotateBuffers(Display: PDisplay; Rotate: Longint): Longint; cdecl;
{$EXTERNALSYM XRotateBuffers}

function XRotateWindowProperties(Display: PDisplay; W: TWindow;
  Properties: PAtom; NumProp: Longint; NPositions: Longint): Longint; cdecl;
{$EXTERNALSYM XRotateWindowProperties}

function XScreenCount(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XScreenCount}

function XSelectInput(Display: PDisplay; W: TWindow; EventMask: Longint):
  Longint; cdecl;
{$EXTERNALSYM XSelectInput}

function XSendEvent(Display: PDisplay; W: TWindow; Propagate: Bool;
  EventMask: Longint; EventSend: PXEvent): TStatus; cdecl;
{$EXTERNALSYM XSendEvent}

function XSetAccessControl(Display: PDisplay; Mode: Longint): Longint; cdecl;
{$EXTERNALSYM XSetAccessControl}

function XSetArcMode(Display: PDisplay; GC: TGC; ArcMode: Longint): Longint; cdecl;
{$EXTERNALSYM XSetArcMode}

function XSetBackground(Display: PDisplay; GC: TGC; Background: Cardinal):
  Longint; cdecl;
{$EXTERNALSYM XSetBackground}

function XSetClipMask(Display: PDisplay; GC: TGC; Pixmap: TPixmap): Longint; cdecl;
{$EXTERNALSYM XSetClipMask}

function XSetClipOrigin(Display: PDisplay; GC: TGC;
  ClipXOrigin, ClipYOrigin: Longint): Longint; cdecl;
{$EXTERNALSYM XSetClipOrigin}

function XSetClipRectangles(Display: PDisplay; GC: TGC;
  ClipXOrigin, ClipYOrigin: Longint; Rectangles: PXRectangle; N: Longint;
  Ordering: Longint): Longint; cdecl;
{$EXTERNALSYM XSetClipRectangles}

function XSetCloseDownMode(Display: PDisplay; CloseMode: Longint): Longint; cdecl;
{$EXTERNALSYM XSetCloseDownMode}

function XSetCommand(Display: PDisplay; W: TWindow; ArgV: PPChar;
  Argc: Longint): Longint; cdecl;
{$EXTERNALSYM XSetCommand}

procedure XSetDashes(Display: PDisplay; GC: TGC; DashOffset: Integer;
  DashList: Pointer; N: Integer); cdecl;
{$EXTERNALSYM XSetDashes}

function XSetFillRule(Display: PDisplay; GC: TGC; FillRule: Longint): Longint; cdecl;
{$EXTERNALSYM XSetFillRule}

function XSetFillStyle(Display: PDisplay; GC: TGC; FillStyle: Longint): Longint; cdecl;
{$EXTERNALSYM XSetFillStyle}

procedure XSetFont(Display: PDisplay; GC: TGC; Font: TFont); cdecl;
{$EXTERNALSYM XSetFont}

function XSetFontPath(Display: PDisplay; Directories: PPChar; NDirs: Longint):
  Longint; cdecl;
{$EXTERNALSYM XSetFontPath}

procedure XSetForeground(Display: PDisplay; GC: TGC; Foreground: Cardinal); cdecl;
{$EXTERNALSYM XSetForeground}

function XSetFunction(Display: PDisplay; GC: TGC; AFunction: Longint): Longint; cdecl;
{$EXTERNALSYM XSetFunction}

function XSetGraphicsExposures(Display: PDisplay; GC: TGC;
  GraphicsExposure: Bool): Longint; cdecl;
{$EXTERNALSYM XSetGraphicsExposures}

function XSetInputFocus(Display: PDisplay; Focus: TWindow; RevertTo: Longint;
  Time: TTime): Longint; cdecl;
{$EXTERNALSYM XSetInputFocus}

procedure XSetLineAttributes(Display: PDisplay; GC: TGC; LineWidth: Cardinal;
  LineStyle: Longint; CapStyle: Longint; JoinSytle: Longint); cdecl;
{$EXTERNALSYM XSetLineAttributes}

function XSetModifierMapping(Display: PDisplay; ModMap: PXModifierKeymap):
  Longint; cdecl;
{$EXTERNALSYM XSetModifierMapping}

function XSetPlaneMask(Display: PDisplay; GC: TGC; PlaneMask: Cardinal):
  Longint; cdecl;
{$EXTERNALSYM XSetPlaneMask}

function XSetScreenSaver(Display: PDisplay; TimeOut: Longint; Interval: Longint;
  PreferBlanking: Longint; AllowExposures: Longint): Longint; cdecl;
{$EXTERNALSYM XSetScreenSaver}

function XSetSelectionOwner(Display: PDisplay; Selection: TAtom; Owner: TWindow;
  Time: TTime): Longint; cdecl;
{$EXTERNALSYM XSetSelectionOwner}

function XSetState(Display: PDisplay; GC: TGC; Foreground: Cardinal;
  Background: Cardinal; AFunction: Longint; PlaneMask: Cardinal): Longint;
  cdecl;
{$EXTERNALSYM XSetState}

function XSetStipple(Display: PDisplay; GC: TGC; Stipple: TPixmap): Longint; cdecl;
{$EXTERNALSYM XSetStipple}

function XSetSubwindowMode(Display: PDisplay; GC: TGC; SubWindowMode: Longint):
  Longint; cdecl;
{$EXTERNALSYM XSetSubwindowMode}

function XSetTSOrigin(Display: PDisplay; GC: TGC; TsXOrigin: Longint;
  TsYOrigin: Longint): Longint; cdecl;
{$EXTERNALSYM XSetTSOrigin}

function XSetTile(Display: PDisplay; GC: TGC; Tile: TPixmap): Longint; cdecl;
{$EXTERNALSYM XSetTile}

function XSetWindowBackground(Display: PDisplay; W: TWindow;
  BackgroundPixel: Cardinal): Longint; cdecl;
{$EXTERNALSYM XSetWindowBackground}

function XSetWindowBackgroundPixmap(Display: PDisplay; W: TWindow;
  BackgroundPixmap: TPixmap): Longint; cdecl;
{$EXTERNALSYM XSetWindowBackgroundPixmap}

function XSetWindowBorder(Display: PDisplay; W: TWindow; BorderPixel: Cardinal):
  Longint; cdecl;
{$EXTERNALSYM XSetWindowBorder}

function XSetWindowBorderPixmap(Display: PDisplay; W: TWindow;
  BorderPixMap: TPixmap): Longint; cdecl;
{$EXTERNALSYM XSetWindowBorderPixmap}

function XSetWindowBorderWidth(Display: PDisplay; W: TWindow; Width: Cardinal):
  Longint; cdecl;
{$EXTERNALSYM XSetWindowBorderWidth}

function XSetWindowColormap(Display: PDisplay; W: TWindow; ColorMap: TColorMap):
  Longint; cdecl;
{$EXTERNALSYM XSetWindowColormap}

function XStoreColor(Display: PDisplay; ColorMap: TColorMap; Color: PXColor):
  Longint; cdecl;
{$EXTERNALSYM XStoreColor}

function XStoreColors(Display: PDisplay; ColorMap: TColorMap; Color: PXColor;
  NColors: Longint): Longint; cdecl;
{$EXTERNALSYM XStoreColors}

function XSync(Display: PDisplay; Discard: Bool): Longint; cdecl;
{$EXTERNALSYM XSync}

function XTextExtents(FontStruct: PXFontStruct; S: PChar; NChars: Integer;
  DirectionReturn, FontAscentReturn, FontDescentReturn: PInteger;
  Overall: PXCharStruct): Integer; cdecl;
{$EXTERNALSYM XTextExtents}

function XTextWidth(FontStruct: PXFontStruct; S: PChar; Count: Integer): Integer; cdecl;
{$EXTERNALSYM XTextWidth}

function XTranslateCoordinates(Display: PDisplay; SrcW: TWindow;
  DestW: TWindow; SrcX: Longint; SrcY: Longint; DestXReturn: PLongint;
  DestYReturn: PLongint; ChildReturn: PWindow): Bool; cdecl;
{$EXTERNALSYM XTranslateCoordinates}

function XUndefineCursor(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XUndefineCursor}

function XUngrabButton(Display: PDisplay; Button: Cardinal; Modifiers: Cardinal;
  GrabWindow: TWindow): Longint; cdecl;
{$EXTERNALSYM XUngrabButton}

function XUngrabKey(Display: PDisplay; KeyCode: Longint; Modifiers: Cardinal;
  GrabWindow: TWindow): Longint; cdecl;
{$EXTERNALSYM XUngrabKey}

function XUngrabKeyboard(Display: PDisplay; Time: TTime): Longint; cdecl;
{$EXTERNALSYM XUngrabKeyboard}

function XUngrabPointer(Display: PDisplay; Time: TTime): Longint; cdecl;
{$EXTERNALSYM XUngrabPointer}

function XUngrabServer(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XUngrabServer}

function XUninstallColormap(Display: PDisplay; ColorMap: TColorMap): Longint; cdecl;
{$EXTERNALSYM XUninstallColormap}

function XUnloadFont(Display: PDisplay; Font: TFont): Longint; cdecl;
{$EXTERNALSYM XUnloadFont}

function XUnmapSubwindows(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XUnmapSubwindows}

function XUnmapWindow(Display: PDisplay; W: TWindow): Longint; cdecl;
{$EXTERNALSYM XUnmapWindow}

function XVendorRelease(Display: PDisplay): Longint; cdecl;
{$EXTERNALSYM XVendorRelease}

function XWarpPointer(Display: PDisplay; SrcW: TWindow; DestW: TWindow;
  SrcX: Longint; SrcY: Longint; SrcWidth: Cardinal; SrcHeight: Cardinal;
  DestX: Longint; DestY: Longint): Longint; cdecl;
{$EXTERNALSYM XWarpPointer}

function XWidthMMOfScreen(Screen: PScreen): Longint; cdecl;
{$EXTERNALSYM XWidthMMOfScreen}

function XWidthOfScreen(Screen: PScreen): Longint; cdecl;
{$EXTERNALSYM XWidthOfScreen}

function XWindowEvent(Display: PDisplay; W: TWindow; EventMask: Longint;
  EventReturn: PXEvent): Longint; cdecl;
{$EXTERNALSYM XWindowEvent}

function XSupportsLocale: Bool; cdecl;
{$EXTERNALSYM XSupportsLocale}

function XCloseOM(OM: XOM): TStatus; cdecl;
{$EXTERNALSYM XCloseOM}

function XSetOMValues(OM: XOM): PChar; cdecl; varargs;
{$EXTERNALSYM XSetOMValues}

function XGetOMValues(OM: XOM): PChar; cdecl; varargs;
{$EXTERNALSYM XGetOMValues}

function XDisplayOfOM(OM: XOM): PDisplay; cdecl;
{$EXTERNALSYM XDisplayOfOM}

function XLocaleOfOM(OM: XOM): PChar; cdecl;
{$EXTERNALSYM XLocaleOfOM}

function XCreateOC(OM: XOM): XOC; cdecl; varargs;
{$EXTERNALSYM XCreateOC}

procedure XDestroyOC(OC: XOC); cdecl;
{$EXTERNALSYM XDestroyOC}

function XOMOfOC(OC: XOC): XOM; cdecl;
{$EXTERNALSYM XOMOfOC}

function XSetOCValues(OC: XOC): PChar; cdecl; varargs;
{$EXTERNALSYM XSetOCValues}

function XGetOCValues(OC: XOC): PChar; cdecl; varargs;
{$EXTERNALSYM XGetOCValues}

procedure XFreeFontSet(Display: PDisplay; FontSet: XFontSet); cdecl;
{$EXTERNALSYM XFreeFontSet}

function XFontsOfFontSet(FontSet: XFontSet; FontStructList: PPPXFontStruct;
  FontNameList: PPPChar): Longint; cdecl;
{$EXTERNALSYM XFontsOfFontSet}

function XBaseFontNameListOfFontSet(FontSet: XFontSet): PChar; cdecl;
{$EXTERNALSYM XBaseFontNameListOfFontSet}

function XLocaleOfFontSet(FontSet: XFontSet): PChar; cdecl;
{$EXTERNALSYM XLocaleOfFontSet}

function XContextDependentDrawing(FontSet: XFontSet): Bool; cdecl;
{$EXTERNALSYM XContextDependentDrawing}

function XDirectionalDependentDrawing(FontSet: XFontSet): Bool; cdecl;
{$EXTERNALSYM XDirectionalDependentDrawing}

function XContextualDrawing(FontSet: XFontSet): Bool; cdecl;
{$EXTERNALSYM XContextualDrawing}

function XExtentsOfFontSet(FontSet: XFontSet): PXFontSetExtents; cdecl;
{$EXTERNALSYM XExtentsOfFontSet}

procedure XmbDrawText(Display: PDisplay; D: TDrawable; GC: TGC; X: Longint;
  Y: Longint; TextItems: PXmbTextItem; NItems: Longint); cdecl;
{$EXTERNALSYM XmbDrawText}

procedure XwcDrawText(Display: PDisplay; D: TDrawable; GC: TGC; X: Longint;
  Y: Longint; TextItems: PXwcTextItem; NItems: Longint); cdecl;
{$EXTERNALSYM XwcDrawText}

function XCloseIM(IM: XIM): TStatus; cdecl;
{$EXTERNALSYM XCloseIM}

function XGetIMValues(IM: XIM): PChar; cdecl; varargs;
{$EXTERNALSYM XGetIMValues}

function XSetIMValues(IM: XIM): PChar; cdecl; varargs;
{$EXTERNALSYM XSetIMValues}

function XDisplayOfIM(IM: XIM): PDisplay; cdecl;
{$EXTERNALSYM XDisplayOfIM}

function XLocaleOfIM(IM: XIM): PChar; cdecl;
{$EXTERNALSYM XLocaleOfIM}

function XCreateIC(IM: XIM; Args: array of const): XIC; cdecl;
{$EXTERNALSYM XCreateIC}

procedure XDestroyIC(IC: XIC); cdecl;
{$EXTERNALSYM XDestroyIC}

procedure XSetICFocus(IC: XIC); cdecl;
{$EXTERNALSYM XSetICFocus}

procedure XUnsetICFocus(IC: XIC); cdecl;
{$EXTERNALSYM XUnsetICFocus}

function XwcResetIC(IC: XIC): Pwchar_t; cdecl;
{$EXTERNALSYM XwcResetIC}

function XmbResetIC(IC: XIC): PChar; cdecl;
{$EXTERNALSYM XmbResetIC}

function XSetICValues(IC: XIC): PChar; cdecl; varargs;
{$EXTERNALSYM XSetICValues}

function XGetICValues(IC: XIC): PChar; cdecl; varargs;
{$EXTERNALSYM XGetICValues}

function XIMOfIC(IC: XIC): XIM; cdecl;
{$EXTERNALSYM XIMOfIC}

function XFilterEvent(Event: PXEvent; Window: TWindow): Bool; cdecl;
{$EXTERNALSYM XFilterEvent}

function XmbLookupString(IC: XIC; Event: PXKeyPressedEvent;
  BufferReturn: PChar; BytesBuffer: Longint; KeySym: PKeySym;
  StatusReturn: PStatus): Longint; cdecl;
{$EXTERNALSYM XmbLookupString}

function XwcLookupString(IC: XIC; Event: PXKeyPressedEvent;
  BufferReturn: Pwchar_t; WCharsBuffer: Longint; KeySymReturn: PKeySym;
  StatusReturn: PStatus): Longint; cdecl;
{$EXTERNALSYM XwcLookupString}

    { internal connections for IMs  }

type
  XConnectionWatchProc = procedure (Dpy: PDisplay; ClientData: XPointer;
    Fd: Longint; Opening: Bool; WatchData: PXPointer); cdecl;
  {$EXTERNALSYM XConnectionWatchProc}

function XInternalConnectionNumbers(Dpy: PDisplay; FdReturn: PPLongint;
  CountReturn: PLongint): TStatus; cdecl;
{$EXTERNALSYM XInternalConnectionNumbers}

procedure XProcessInternalConnection(Dpy: PDisplay; Fd: Longint); cdecl;
{$EXTERNALSYM XProcessInternalConnection}

function XAddConnectionWatch(Dpy: PDisplay; Callback: XConnectionWatchProc;
  ClientData: XPointer): TStatus; cdecl;
{$EXTERNALSYM XAddConnectionWatch}

procedure XRemoveConnectionWatch(Dpy: PDisplay; Callback: XConnectionWatchProc;
  ClientData: XPointer); cdecl;
{$EXTERNALSYM XRemoveConnectionWatch}

  { ap_keysym.h }

const
  XK_VoidSymbol = $FFFFFF;
  {$EXTERNALSYM XK_VoidSymbol}
     
{
   TTY Functions, cleverly chosen to map to ascii, for convenience of
   programming, but could have been arbitrary (at the cost of lookup
   tables in client code.
  }
{ back space, back char  }

const
  XK_BackSpace = $FF08;
  {$EXTERNALSYM XK_BackSpace}
  XK_Tab = $FF09;
  {$EXTERNALSYM XK_Tab}
  XK_Linefeed = $FF0A; { Linefeed, LF  }
  {$EXTERNALSYM XK_Linefeed}
  XK_Clear = $FF0B;
  {$EXTERNALSYM XK_Clear}
  XK_Return = $FF0D; { Return, enter  }
  {$EXTERNALSYM XK_Return}
  XK_Pause = $FF13; { Pause, hold  }
  {$EXTERNALSYM XK_Pause}
  XK_Scroll_Lock = $FF14;
  {$EXTERNALSYM XK_Scroll_Lock}
  XK_Sys_Req = $FF15;
  {$EXTERNALSYM XK_Sys_Req}
  XK_Escape = $FF1B;
  {$EXTERNALSYM XK_Escape}
  XK_Delete = $FFFF; { Delete, rubout  }
  {$EXTERNALSYM XK_Delete}
{ International & multi-key character composition  }
{ Multi-key character compose  }
  XK_Multi_key = $FF20;
  {$EXTERNALSYM XK_Multi_key}
  XK_Codeinput = $FF37;
  {$EXTERNALSYM XK_Codeinput}
  XK_SingleCandidate = $FF3C;
  {$EXTERNALSYM XK_SingleCandidate}
  XK_MultipleCandidate = $FF3D;
  {$EXTERNALSYM XK_MultipleCandidate}
  XK_PreviousCandidate = $FF3E;
  {$EXTERNALSYM XK_PreviousCandidate}
{ Japanese keyboard support  }
  XK_Kanji = $FF21; { Kanji, Kanji convert  }
  {$EXTERNALSYM XK_Kanji}
{ Cancel Conversion  }
  XK_Muhenkan = $FF22;
  {$EXTERNALSYM XK_Muhenkan}
{ Start/Stop Conversion  }
  XK_Henkan_Mode = $FF23;
  {$EXTERNALSYM XK_Henkan_Mode}
{ Alias for Henkan_Mode  }
  XK_Henkan = $FF23;
  {$EXTERNALSYM XK_Henkan}
{ to Romaji  }
  XK_Romaji = $FF24;
  {$EXTERNALSYM XK_Romaji}
{ to Hiragana  }
  XK_Hiragana = $FF25;
  {$EXTERNALSYM XK_Hiragana}
{ to Katakana  }
  XK_Katakana = $FF26;
  {$EXTERNALSYM XK_Katakana}
{ Hiragana/Katakana toggle  }
  XK_Hiragana_Katakana = $FF27;
  {$EXTERNALSYM XK_Hiragana_Katakana}
{ to Zenkaku  }
  XK_Zenkaku = $FF28;
  {$EXTERNALSYM XK_Zenkaku}
{ to Hankaku  }
  XK_Hankaku = $FF29;
  {$EXTERNALSYM XK_Hankaku}
{ Zenkaku/Hankaku toggle  }
  XK_Zenkaku_Hankaku = $FF2A;
  {$EXTERNALSYM XK_Zenkaku_Hankaku}
{ Add to Dictionary  }
  XK_Touroku = $FF2B;
  {$EXTERNALSYM XK_Touroku}
{ Delete from Dictionary  }
  XK_Massyo = $FF2C;
  {$EXTERNALSYM XK_Massyo}
{ Kana Lock  }
  XK_Kana_Lock = $FF2D;
  {$EXTERNALSYM XK_Kana_Lock}
{ Kana Shift  }
  XK_Kana_Shift = $FF2E;
  {$EXTERNALSYM XK_Kana_Shift}
{ Alphanumeric Shift  }
  XK_Eisu_Shift = $FF2F;
  {$EXTERNALSYM XK_Eisu_Shift}
{ Alphanumeric toggle  }
  XK_Eisu_toggle = $FF30;
  {$EXTERNALSYM XK_Eisu_toggle}
{ Codeinput  }
  XK_Kanji_Bangou = $FF37;
  {$EXTERNALSYM XK_Kanji_Bangou}
{ Multiple/All Candidate(s)  }
  XK_Zen_Koho = $FF3D;
  {$EXTERNALSYM XK_Zen_Koho}
{ Previous Candidate  }
  XK_Mae_Koho = $FF3E;
  {$EXTERNALSYM XK_Mae_Koho}
{ 0xFF31 thru 0xFF3F are under XK_KOREAN  }
{ Cursor control & motion  }
  XK_Home = $FF50;
  {$EXTERNALSYM XK_Home}
{ Move left, left arrow  }
  XK_Left = $FF51;
  {$EXTERNALSYM XK_Left}
{ Move up, up arrow  }
  XK_Up = $FF52;
  {$EXTERNALSYM XK_Up}
{ Move right, right arrow  }
  XK_Right = $FF53;
  {$EXTERNALSYM XK_Right}
{ Move down, down arrow  }
  XK_Down = $FF54;
  {$EXTERNALSYM XK_Down}
{ Prior, previous  }
  XK_Prior = $FF55;
  {$EXTERNALSYM XK_Prior}
  XK_Page_Up = $FF55;
  {$EXTERNALSYM XK_Page_Up}
{ Next  }
  XK_Next = $FF56;
  {$EXTERNALSYM XK_Next}
  XK_Page_Down = $FF56;
  {$EXTERNALSYM XK_Page_Down}
{ EOL  }
  XK_End = $FF57;
  {$EXTERNALSYM XK_End}
{ BOL  }
  XK_Begin = $FF58;
  {$EXTERNALSYM XK_Begin}
{ Misc Functions  }
{ Select, mark  }
  XK_Select = $FF60;
  {$EXTERNALSYM XK_Select}
  XK_Print = $FF61;
  {$EXTERNALSYM XK_Print}
{ Execute, run, do  }
  XK_Execute = $FF62;
  {$EXTERNALSYM XK_Execute}
{ Insert, insert here  }
  XK_Insert = $FF63;
  {$EXTERNALSYM XK_Insert}
{ Undo, oops  }
  XK_Undo = $FF65;
  {$EXTERNALSYM XK_Undo}
{ redo, again  }
  XK_Redo = $FF66;
  {$EXTERNALSYM XK_Redo}
  XK_Menu = $FF67;
  {$EXTERNALSYM XK_Menu}
{ Find, search  }
  XK_Find = $FF68;
  {$EXTERNALSYM XK_Find}
{ Cancel, stop, abort, exit  }
  XK_Cancel = $FF69;
  {$EXTERNALSYM XK_Cancel}
{ Help  }
  XK_Help = $FF6A;
  {$EXTERNALSYM XK_Help}
  XK_Break = $FF6B;
  {$EXTERNALSYM XK_Break}
{ Character set switch  }
  XK_Mode_switch = $FF7E;
  {$EXTERNALSYM XK_Mode_switch}
{ Alias for mode_switch  }
  XK_script_switch = $FF7E;
  {$EXTERNALSYM XK_script_switch}
  XK_Num_Lock = $FF7F;
  {$EXTERNALSYM XK_Num_Lock}
{ Keypad Functions, keypad numbers cleverly chosen to map to ascii  }
{ space  }
  XK_KP_Space = $FF80;
  {$EXTERNALSYM XK_KP_Space}
  XK_KP_Tab = $FF89;
  {$EXTERNALSYM XK_KP_Tab}
{ enter  }
  XK_KP_Enter = $FF8D;
  {$EXTERNALSYM XK_KP_Enter}
{ PF1, KP_A, ...  }
  XK_KP_F1 = $FF91;
  {$EXTERNALSYM XK_KP_F1}
  XK_KP_F2 = $FF92;
  {$EXTERNALSYM XK_KP_F2}
  XK_KP_F3 = $FF93;
  {$EXTERNALSYM XK_KP_F3}
  XK_KP_F4 = $FF94;
  {$EXTERNALSYM XK_KP_F4}
  XK_KP_Home = $FF95;
  {$EXTERNALSYM XK_KP_Home}
  XK_KP_Left = $FF96;
  {$EXTERNALSYM XK_KP_Left}
  XK_KP_Up = $FF97;
  {$EXTERNALSYM XK_KP_Up}
  XK_KP_Right = $FF98;
  {$EXTERNALSYM XK_KP_Right}
  XK_KP_Down = $FF99;
  {$EXTERNALSYM XK_KP_Down}
  XK_KP_Prior = $FF9A;
  {$EXTERNALSYM XK_KP_Prior}
  XK_KP_Page_Up = $FF9A;
  {$EXTERNALSYM XK_KP_Page_Up}
  XK_KP_Next = $FF9B;
  {$EXTERNALSYM XK_KP_Next}
  XK_KP_Page_Down = $FF9B;
  {$EXTERNALSYM XK_KP_Page_Down}
  XK_KP_End = $FF9C;
  {$EXTERNALSYM XK_KP_End}
  XK_KP_Begin = $FF9D;
  {$EXTERNALSYM XK_KP_Begin}
  XK_KP_Insert = $FF9E;
  {$EXTERNALSYM XK_KP_Insert}
  XK_KP_Delete = $FF9F;
  {$EXTERNALSYM XK_KP_Delete}
{ equals  }
  XK_KP_Equal = $FFBD;
  {$EXTERNALSYM XK_KP_Equal}
  XK_KP_Multiply = $FFAA;
  {$EXTERNALSYM XK_KP_Multiply}
  XK_KP_Add = $FFAB;
  {$EXTERNALSYM XK_KP_Add}
{ separator, often comma  }
  XK_KP_Separator = $FFAC;
  {$EXTERNALSYM XK_KP_Separator}
  XK_KP_Subtract = $FFAD;
  {$EXTERNALSYM XK_KP_Subtract}
  XK_KP_Decimal = $FFAE;
  {$EXTERNALSYM XK_KP_Decimal}
  XK_KP_Divide = $FFAF;
  {$EXTERNALSYM XK_KP_Divide}
  XK_KP_0 = $FFB0;
  {$EXTERNALSYM XK_KP_0}
  XK_KP_1 = $FFB1;
  {$EXTERNALSYM XK_KP_1}
  XK_KP_2 = $FFB2;
  {$EXTERNALSYM XK_KP_2}
  XK_KP_3 = $FFB3;
  {$EXTERNALSYM XK_KP_3}
  XK_KP_4 = $FFB4;
  {$EXTERNALSYM XK_KP_4}
  XK_KP_5 = $FFB5;
  {$EXTERNALSYM XK_KP_5}
  XK_KP_6 = $FFB6;
  {$EXTERNALSYM XK_KP_6}
  XK_KP_7 = $FFB7;
  {$EXTERNALSYM XK_KP_7}
  XK_KP_8 = $FFB8;
  {$EXTERNALSYM XK_KP_8}
  XK_KP_9 = $FFB9;
  {$EXTERNALSYM XK_KP_9}
{
   Auxilliary Functions; note the duplicate definitions for left and right
   function keys;  Sun keyboards and a few other manufactures have such
   function key groups on the left and/or right sides of the keyboard.
   We've not found a keyboard with more than 35 function keys total.
  }
  XK_F1 = $FFBE;
  {$EXTERNALSYM XK_F1}
  XK_F2 = $FFBF;
  {$EXTERNALSYM XK_F2}
  XK_F3 = $FFC0;
  {$EXTERNALSYM XK_F3}
  XK_F4 = $FFC1;
  {$EXTERNALSYM XK_F4}
  XK_F5 = $FFC2;
  {$EXTERNALSYM XK_F5}
  XK_F6 = $FFC3;
  {$EXTERNALSYM XK_F6}
  XK_F7 = $FFC4;
  {$EXTERNALSYM XK_F7}
  XK_F8 = $FFC5;
  {$EXTERNALSYM XK_F8}
  XK_F9 = $FFC6;
  {$EXTERNALSYM XK_F9}
  XK_F10 = $FFC7;
  {$EXTERNALSYM XK_F10}
  XK_F11 = $FFC8;
  {$EXTERNALSYM XK_F11}
  XK_L1 = $FFC8;
  {$EXTERNALSYM XK_L1}
  XK_F12 = $FFC9;
  {$EXTERNALSYM XK_F12}
  XK_L2 = $FFC9;
  {$EXTERNALSYM XK_L2}
  XK_F13 = $FFCA;
  {$EXTERNALSYM XK_F13}
  XK_L3 = $FFCA;
  {$EXTERNALSYM XK_L3}
  XK_F14 = $FFCB;
  {$EXTERNALSYM XK_F14}
  XK_L4 = $FFCB;
  {$EXTERNALSYM XK_L4}
  XK_F15 = $FFCC;
  {$EXTERNALSYM XK_F15}
  XK_L5 = $FFCC;
  {$EXTERNALSYM XK_L5}
  XK_F16 = $FFCD;
  {$EXTERNALSYM XK_F16}
  XK_L6 = $FFCD;
  {$EXTERNALSYM XK_L6}
  XK_F17 = $FFCE;
  {$EXTERNALSYM XK_F17}
  XK_L7 = $FFCE;
  {$EXTERNALSYM XK_L7}
  XK_F18 = $FFCF;
  {$EXTERNALSYM XK_F18}
  XK_L8 = $FFCF;
  {$EXTERNALSYM XK_L8}
  XK_F19 = $FFD0;
  {$EXTERNALSYM XK_F19}
  XK_L9 = $FFD0;
  {$EXTERNALSYM XK_L9}
  XK_F20 = $FFD1;
  {$EXTERNALSYM XK_F20}
  XK_L10 = $FFD1;
  {$EXTERNALSYM XK_L10}
  XK_F21 = $FFD2;
  {$EXTERNALSYM XK_F21}
  XK_R1 = $FFD2;
  {$EXTERNALSYM XK_R1}
  XK_F22 = $FFD3;
  {$EXTERNALSYM XK_F22}
  XK_R2 = $FFD3;
  {$EXTERNALSYM XK_R2}
  XK_F23 = $FFD4;
  {$EXTERNALSYM XK_F23}
  XK_R3 = $FFD4;
  {$EXTERNALSYM XK_R3}
  XK_F24 = $FFD5;
  {$EXTERNALSYM XK_F24}
  XK_R4 = $FFD5;
  {$EXTERNALSYM XK_R4}
  XK_F25 = $FFD6;
  {$EXTERNALSYM XK_F25}
  XK_R5 = $FFD6;
  {$EXTERNALSYM XK_R5}
  XK_F26 = $FFD7;
  {$EXTERNALSYM XK_F26}
  XK_R6 = $FFD7;
  {$EXTERNALSYM XK_R6}
  XK_F27 = $FFD8;
  {$EXTERNALSYM XK_F27}
  XK_R7 = $FFD8;
  {$EXTERNALSYM XK_R7}
  XK_F28 = $FFD9;
  {$EXTERNALSYM XK_F28}
  XK_R8 = $FFD9;
  {$EXTERNALSYM XK_R8}
  XK_F29 = $FFDA;
  {$EXTERNALSYM XK_F29}
  XK_R9 = $FFDA;
  {$EXTERNALSYM XK_R9}
  XK_F30 = $FFDB;
  {$EXTERNALSYM XK_F30}
  XK_R10 = $FFDB;
  {$EXTERNALSYM XK_R10}
  XK_F31 = $FFDC;
  {$EXTERNALSYM XK_F31}
  XK_R11 = $FFDC;
  {$EXTERNALSYM XK_R11}
  XK_F32 = $FFDD;
  {$EXTERNALSYM XK_F32}
  XK_R12 = $FFDD;
  {$EXTERNALSYM XK_R12}
  XK_F33 = $FFDE;
  {$EXTERNALSYM XK_F33}
  XK_R13 = $FFDE;
  {$EXTERNALSYM XK_R13}
  XK_F34 = $FFDF;
  {$EXTERNALSYM XK_F34}
  XK_R14 = $FFDF;
  {$EXTERNALSYM XK_R14}
  XK_F35 = $FFE0;
  {$EXTERNALSYM XK_F35}
  XK_R15 = $FFE0;
  {$EXTERNALSYM XK_R15}
{ Modifiers  }
{ Left shift  }
  XK_Shift_L = $FFE1;
  {$EXTERNALSYM XK_Shift_L}
{ Right shift  }
  XK_Shift_R = $FFE2;
  {$EXTERNALSYM XK_Shift_R}
{ Left control  }
  XK_Control_L = $FFE3;
  {$EXTERNALSYM XK_Control_L}
{ Right control  }
  XK_Control_R = $FFE4;
  {$EXTERNALSYM XK_Control_R}
{ Caps lock  }
  XK_Caps_Lock = $FFE5;
  {$EXTERNALSYM XK_Caps_Lock}
{ Shift lock  }
  XK_Shift_Lock = $FFE6;
  {$EXTERNALSYM XK_Shift_Lock}
{ Left meta  }
  XK_Meta_L = $FFE7;
  {$EXTERNALSYM XK_Meta_L}
{ Right meta  }
  XK_Meta_R = $FFE8;
  {$EXTERNALSYM XK_Meta_R}
{ Left alt  }
  XK_Alt_L = $FFE9;
  {$EXTERNALSYM XK_Alt_L}
{ Right alt  }
  XK_Alt_R = $FFEA;
  {$EXTERNALSYM XK_Alt_R}
{ Left super  }
  XK_Super_L = $FFEB;
  {$EXTERNALSYM XK_Super_L}
{ Right super  }
  XK_Super_R = $FFEC;
  {$EXTERNALSYM XK_Super_R}
{ Left hyper  }
  XK_Hyper_L = $FFED;
  {$EXTERNALSYM XK_Hyper_L}
{ Right hyper  }
  XK_Hyper_R = $FFEE;
  {$EXTERNALSYM XK_Hyper_R}

  {
   ISO 9995 Function and Modifier Keys
   Byte 3 = 0xFE
  }

const
  XK_ISO_Lock = $FE01;
  {$EXTERNALSYM XK_ISO_Lock}
  XK_ISO_Level2_Latch = $FE02;
  {$EXTERNALSYM XK_ISO_Level2_Latch}
  XK_ISO_Level3_Shift = $FE03;
  {$EXTERNALSYM XK_ISO_Level3_Shift}
  XK_ISO_Level3_Latch = $FE04;
  {$EXTERNALSYM XK_ISO_Level3_Latch}
  XK_ISO_Level3_Lock = $FE05;
  {$EXTERNALSYM XK_ISO_Level3_Lock}
{ Alias for mode_switch  }
  XK_ISO_Group_Shift = $FF7E;
  {$EXTERNALSYM XK_ISO_Group_Shift}
  XK_ISO_Group_Latch = $FE06;
  {$EXTERNALSYM XK_ISO_Group_Latch}
  XK_ISO_Group_Lock = $FE07;
  {$EXTERNALSYM XK_ISO_Group_Lock}
  XK_ISO_Next_Group = $FE08;
  {$EXTERNALSYM XK_ISO_Next_Group}
  XK_ISO_Next_Group_Lock = $FE09;
  {$EXTERNALSYM XK_ISO_Next_Group_Lock}
  XK_ISO_Prev_Group = $FE0A;
  {$EXTERNALSYM XK_ISO_Prev_Group}
  XK_ISO_Prev_Group_Lock = $FE0B;
  {$EXTERNALSYM XK_ISO_Prev_Group_Lock}
  XK_ISO_First_Group = $FE0C;
  {$EXTERNALSYM XK_ISO_First_Group}
  XK_ISO_First_Group_Lock = $FE0D;
  {$EXTERNALSYM XK_ISO_First_Group_Lock}
  XK_ISO_Last_Group = $FE0E;
  {$EXTERNALSYM XK_ISO_Last_Group}
  XK_ISO_Last_Group_Lock = $FE0F;
  {$EXTERNALSYM XK_ISO_Last_Group_Lock}
  XK_ISO_Left_Tab = $FE20;
  {$EXTERNALSYM XK_ISO_Left_Tab}
  XK_ISO_Move_Line_Up = $FE21;
  {$EXTERNALSYM XK_ISO_Move_Line_Up}
  XK_ISO_Move_Line_Down = $FE22;
  {$EXTERNALSYM XK_ISO_Move_Line_Down}
  XK_ISO_Partial_Line_Up = $FE23;
  {$EXTERNALSYM XK_ISO_Partial_Line_Up}
  XK_ISO_Partial_Line_Down = $FE24;
  {$EXTERNALSYM XK_ISO_Partial_Line_Down}
  XK_ISO_Partial_Space_Left = $FE25;
  {$EXTERNALSYM XK_ISO_Partial_Space_Left}
  XK_ISO_Partial_Space_Right = $FE26;
  {$EXTERNALSYM XK_ISO_Partial_Space_Right}
  XK_ISO_Set_Margin_Left = $FE27;
  {$EXTERNALSYM XK_ISO_Set_Margin_Left}
  XK_ISO_Set_Margin_Right = $FE28;
  {$EXTERNALSYM XK_ISO_Set_Margin_Right}
  XK_ISO_Release_Margin_Left = $FE29;
  {$EXTERNALSYM XK_ISO_Release_Margin_Left}
  XK_ISO_Release_Margin_Right = $FE2A;
  {$EXTERNALSYM XK_ISO_Release_Margin_Right}
  XK_ISO_Release_Both_Margins = $FE2B;
  {$EXTERNALSYM XK_ISO_Release_Both_Margins}
  XK_ISO_Fast_Cursor_Left = $FE2C;
  {$EXTERNALSYM XK_ISO_Fast_Cursor_Left}
  XK_ISO_Fast_Cursor_Right = $FE2D;
  {$EXTERNALSYM XK_ISO_Fast_Cursor_Right}
  XK_ISO_Fast_Cursor_Up = $FE2E;
  {$EXTERNALSYM XK_ISO_Fast_Cursor_Up}
  XK_ISO_Fast_Cursor_Down = $FE2F;
  {$EXTERNALSYM XK_ISO_Fast_Cursor_Down}
  XK_ISO_Continuous_Underline = $FE30;
  {$EXTERNALSYM XK_ISO_Continuous_Underline}
  XK_ISO_Discontinuous_Underline = $FE31;
  {$EXTERNALSYM XK_ISO_Discontinuous_Underline}
  XK_ISO_Emphasize = $FE32;
  {$EXTERNALSYM XK_ISO_Emphasize}
  XK_ISO_Center_Object = $FE33;
  {$EXTERNALSYM XK_ISO_Center_Object}
  XK_ISO_Enter = $FE34;
  {$EXTERNALSYM XK_ISO_Enter}
  XK_dead_grave = $FE50;
  {$EXTERNALSYM XK_dead_grave}
  XK_dead_acute = $FE51;
  {$EXTERNALSYM XK_dead_acute}
  XK_dead_circumflex = $FE52;
  {$EXTERNALSYM XK_dead_circumflex}
  XK_dead_tilde = $FE53;
  {$EXTERNALSYM XK_dead_tilde}
  XK_dead_macron = $FE54;
  {$EXTERNALSYM XK_dead_macron}
  XK_dead_breve = $FE55;
  {$EXTERNALSYM XK_dead_breve}
  XK_dead_abovedot = $FE56;
  {$EXTERNALSYM XK_dead_abovedot}
  XK_dead_diaeresis = $FE57;
  {$EXTERNALSYM XK_dead_diaeresis}
  XK_dead_abovering = $FE58;
  {$EXTERNALSYM XK_dead_abovering}
  XK_dead_doubleacute = $FE59;
  {$EXTERNALSYM XK_dead_doubleacute}
  XK_dead_caron = $FE5A;
  {$EXTERNALSYM XK_dead_caron}
  XK_dead_cedilla = $FE5B;
  {$EXTERNALSYM XK_dead_cedilla}
  XK_dead_ogonek = $FE5C;
  {$EXTERNALSYM XK_dead_ogonek}
  XK_dead_iota = $FE5D;
  {$EXTERNALSYM XK_dead_iota}
  XK_dead_voiced_sound = $FE5E;
  {$EXTERNALSYM XK_dead_voiced_sound}
  XK_dead_semivoiced_sound = $FE5F;
  {$EXTERNALSYM XK_dead_semivoiced_sound}
  XK_dead_belowdot = $FE60;
  {$EXTERNALSYM XK_dead_belowdot}
  XK_First_Virtual_Screen = $FED0;
  {$EXTERNALSYM XK_First_Virtual_Screen}
  XK_Prev_Virtual_Screen = $FED1;
  {$EXTERNALSYM XK_Prev_Virtual_Screen}
  XK_Next_Virtual_Screen = $FED2;
  {$EXTERNALSYM XK_Next_Virtual_Screen}
  XK_Last_Virtual_Screen = $FED4;
  {$EXTERNALSYM XK_Last_Virtual_Screen}
  XK_Terminate_Server = $FED5;
  {$EXTERNALSYM XK_Terminate_Server}
  XK_AccessX_Enable = $FE70;
  {$EXTERNALSYM XK_AccessX_Enable}
  XK_AccessX_Feedback_Enable = $FE71;
  {$EXTERNALSYM XK_AccessX_Feedback_Enable}
  XK_RepeatKeys_Enable = $FE72;
  {$EXTERNALSYM XK_RepeatKeys_Enable}
  XK_SlowKeys_Enable = $FE73;
  {$EXTERNALSYM XK_SlowKeys_Enable}
  XK_BounceKeys_Enable = $FE74;
  {$EXTERNALSYM XK_BounceKeys_Enable}
  XK_StickyKeys_Enable = $FE75;
  {$EXTERNALSYM XK_StickyKeys_Enable}
  XK_MouseKeys_Enable = $FE76;
  {$EXTERNALSYM XK_MouseKeys_Enable}
  XK_MouseKeys_Accel_Enable = $FE77;
  {$EXTERNALSYM XK_MouseKeys_Accel_Enable}
  XK_Overlay1_Enable = $FE78;
  {$EXTERNALSYM XK_Overlay1_Enable}
  XK_Overlay2_Enable = $FE79;
  {$EXTERNALSYM XK_Overlay2_Enable}
  XK_AudibleBell_Enable = $FE7A;
  {$EXTERNALSYM XK_AudibleBell_Enable}
  XK_Pointer_Left = $FEE0;
  {$EXTERNALSYM XK_Pointer_Left}
  XK_Pointer_Right = $FEE1;
  {$EXTERNALSYM XK_Pointer_Right}
  XK_Pointer_Up = $FEE2;
  {$EXTERNALSYM XK_Pointer_Up}
  XK_Pointer_Down = $FEE3;
  {$EXTERNALSYM XK_Pointer_Down}
  XK_Pointer_UpLeft = $FEE4;
  {$EXTERNALSYM XK_Pointer_UpLeft}
  XK_Pointer_UpRight = $FEE5;
  {$EXTERNALSYM XK_Pointer_UpRight}
  XK_Pointer_DownLeft = $FEE6;
  {$EXTERNALSYM XK_Pointer_DownLeft}
  XK_Pointer_DownRight = $FEE7;
  {$EXTERNALSYM XK_Pointer_DownRight}
  XK_Pointer_Button_Dflt = $FEE8;
  {$EXTERNALSYM XK_Pointer_Button_Dflt}
  XK_Pointer_Button1 = $FEE9;
  {$EXTERNALSYM XK_Pointer_Button1}
  XK_Pointer_Button2 = $FEEA;
  {$EXTERNALSYM XK_Pointer_Button2}
  XK_Pointer_Button3 = $FEEB;
  {$EXTERNALSYM XK_Pointer_Button3}
  XK_Pointer_Button4 = $FEEC;
  {$EXTERNALSYM XK_Pointer_Button4}
  XK_Pointer_Button5 = $FEED;
  {$EXTERNALSYM XK_Pointer_Button5}
  XK_Pointer_DblClick_Dflt = $FEEE;
  {$EXTERNALSYM XK_Pointer_DblClick_Dflt}
  XK_Pointer_DblClick1 = $FEEF;
  {$EXTERNALSYM XK_Pointer_DblClick1}
  XK_Pointer_DblClick2 = $FEF0;
  {$EXTERNALSYM XK_Pointer_DblClick2}
  XK_Pointer_DblClick3 = $FEF1;
  {$EXTERNALSYM XK_Pointer_DblClick3}
  XK_Pointer_DblClick4 = $FEF2;
  {$EXTERNALSYM XK_Pointer_DblClick4}
  XK_Pointer_DblClick5 = $FEF3;
  {$EXTERNALSYM XK_Pointer_DblClick5}
  XK_Pointer_Drag_Dflt = $FEF4;
  {$EXTERNALSYM XK_Pointer_Drag_Dflt}
  XK_Pointer_Drag1 = $FEF5;
  {$EXTERNALSYM XK_Pointer_Drag1}
  XK_Pointer_Drag2 = $FEF6;
  {$EXTERNALSYM XK_Pointer_Drag2}
  XK_Pointer_Drag3 = $FEF7;
  {$EXTERNALSYM XK_Pointer_Drag3}
  XK_Pointer_Drag4 = $FEF8;
  {$EXTERNALSYM XK_Pointer_Drag4}
  XK_Pointer_Drag5 = $FEFD;
  {$EXTERNALSYM XK_Pointer_Drag5}
  XK_Pointer_EnableKeys = $FEF9;
  {$EXTERNALSYM XK_Pointer_EnableKeys}
  XK_Pointer_Accelerate = $FEFA;
  {$EXTERNALSYM XK_Pointer_Accelerate}
  XK_Pointer_DfltBtnNext = $FEFB;
  {$EXTERNALSYM XK_Pointer_DfltBtnNext}
  XK_Pointer_DfltBtnPrev = $FEFC;
  {$EXTERNALSYM XK_Pointer_DfltBtnPrev}
{
   3270 Terminal Keys
   Byte 3 = 0xFD
  }

const
  XK_3270_Duplicate = $FD01;
  {$EXTERNALSYM XK_3270_Duplicate}
  XK_3270_FieldMark = $FD02;
  {$EXTERNALSYM XK_3270_FieldMark}
  XK_3270_Right2 = $FD03;
  {$EXTERNALSYM XK_3270_Right2}
  XK_3270_Left2 = $FD04;
  {$EXTERNALSYM XK_3270_Left2}
  XK_3270_BackTab = $FD05;
  {$EXTERNALSYM XK_3270_BackTab}
  XK_3270_EraseEOF = $FD06;
  {$EXTERNALSYM XK_3270_EraseEOF}
  XK_3270_EraseInput = $FD07;
  {$EXTERNALSYM XK_3270_EraseInput}
  XK_3270_Reset = $FD08;
  {$EXTERNALSYM XK_3270_Reset}
  XK_3270_Quit = $FD09;
  {$EXTERNALSYM XK_3270_Quit}
  XK_3270_PA1 = $FD0A;
  {$EXTERNALSYM XK_3270_PA1}
  XK_3270_PA2 = $FD0B;
  {$EXTERNALSYM XK_3270_PA2}
  XK_3270_PA3 = $FD0C;
  {$EXTERNALSYM XK_3270_PA3}
  XK_3270_Test = $FD0D;
  {$EXTERNALSYM XK_3270_Test}
  XK_3270_Attn = $FD0E;
  {$EXTERNALSYM XK_3270_Attn}
  XK_3270_CursorBlink = $FD0F;
  {$EXTERNALSYM XK_3270_CursorBlink}
  XK_3270_AltCursor = $FD10;
  {$EXTERNALSYM XK_3270_AltCursor}
  XK_3270_KeyClick = $FD11;
  {$EXTERNALSYM XK_3270_KeyClick}
  XK_3270_Jump = $FD12;
  {$EXTERNALSYM XK_3270_Jump}
  XK_3270_Ident = $FD13;
  {$EXTERNALSYM XK_3270_Ident}
  XK_3270_Rule = $FD14;
  {$EXTERNALSYM XK_3270_Rule}
  XK_3270_Copy = $FD15;
  {$EXTERNALSYM XK_3270_Copy}
  XK_3270_Play = $FD16;
  {$EXTERNALSYM XK_3270_Play}
  XK_3270_Setup = $FD17;
  {$EXTERNALSYM XK_3270_Setup}
  XK_3270_Record = $FD18;
  {$EXTERNALSYM XK_3270_Record}
  XK_3270_ChangeScreen = $FD19;
  {$EXTERNALSYM XK_3270_ChangeScreen}
  XK_3270_DeleteWord = $FD1A;
  {$EXTERNALSYM XK_3270_DeleteWord}
  XK_3270_ExSelect = $FD1B;
  {$EXTERNALSYM XK_3270_ExSelect}
  XK_3270_CursorSelect = $FD1C;
  {$EXTERNALSYM XK_3270_CursorSelect}
  XK_3270_PrintScreen = $FD1D;
  {$EXTERNALSYM XK_3270_PrintScreen}
  XK_3270_Enter = $FD1E;
  {$EXTERNALSYM XK_3270_Enter}
{
    Latin 1
    Byte 3 = 0
  }

const
  XK_space = $020;
  {$EXTERNALSYM XK_space}
  XK_exclam = $021;
  {$EXTERNALSYM XK_exclam}
  XK_quotedbl = $022;
  {$EXTERNALSYM XK_quotedbl}
  XK_numbersign = $023;
  {$EXTERNALSYM XK_numbersign}
  XK_dollar = $024;
  {$EXTERNALSYM XK_dollar}
  XK_percent = $025;
  {$EXTERNALSYM XK_percent}
  XK_ampersand = $026;
  {$EXTERNALSYM XK_ampersand}
  XK_apostrophe = $027;
  {$EXTERNALSYM XK_apostrophe}
  XK_quoteright = $027; { deprecated }
  {$EXTERNALSYM XK_quoteright}
  XK_parenleft = $028;
  {$EXTERNALSYM XK_parenleft}
  XK_parenright = $029;
  {$EXTERNALSYM XK_parenright}
  XK_asterisk = $02a;
  {$EXTERNALSYM XK_asterisk}
  XK_plus = $02b;
  {$EXTERNALSYM XK_plus}
  XK_comma = $02c;
  {$EXTERNALSYM XK_comma}
  XK_minus = $02d;
  {$EXTERNALSYM XK_minus}
  XK_period = $02e;
  {$EXTERNALSYM XK_period}
  XK_slash = $02f;
  {$EXTERNALSYM XK_slash}
  XK_0 = $030;
  {$EXTERNALSYM XK_0}
  XK_1 = $031;
  {$EXTERNALSYM XK_1}
  XK_2 = $032;
  {$EXTERNALSYM XK_2}
  XK_3 = $033;
  {$EXTERNALSYM XK_3}
  XK_4 = $034;
  {$EXTERNALSYM XK_4}
  XK_5 = $035;
  {$EXTERNALSYM XK_5}
  XK_6 = $036;
  {$EXTERNALSYM XK_6}
  XK_7 = $037;
  {$EXTERNALSYM XK_7}
  XK_8 = $038;
  {$EXTERNALSYM XK_8}
  XK_9 = $039;
  {$EXTERNALSYM XK_9}
  XK_colon = $03a;
  {$EXTERNALSYM XK_colon}
  XK_semicolon = $03b;
  {$EXTERNALSYM XK_semicolon}
  XK_less = $03c;
  {$EXTERNALSYM XK_less}
  XK_equal = $03d;
  {$EXTERNALSYM XK_equal}
  XK_greater = $03e;
  {$EXTERNALSYM XK_greater}
  XK_question = $03f;
  {$EXTERNALSYM XK_question}
  XK_at = $040;
  {$EXTERNALSYM XK_at}
  XK_A = $041;
  {$EXTERNALSYM XK_A}
  XK_B = $042;
  {$EXTERNALSYM XK_B}
  XK_C = $043;
  {$EXTERNALSYM XK_C}
  XK_D = $044;
  {$EXTERNALSYM XK_D}
  XK_E = $045;
  {$EXTERNALSYM XK_E}
  XK_F = $046;
  {$EXTERNALSYM XK_F}
  XK_G = $047;
  {$EXTERNALSYM XK_G}
  XK_H = $048;
  {$EXTERNALSYM XK_H}
  XK_I = $049;
  {$EXTERNALSYM XK_I}
  XK_J = $04a;
  {$EXTERNALSYM XK_J}
  XK_K = $04b;
  {$EXTERNALSYM XK_K}
  XK_L = $04c;
  {$EXTERNALSYM XK_L}
  XK_M = $04d;
  {$EXTERNALSYM XK_M}
  XK_N = $04e;
  {$EXTERNALSYM XK_N}
  XK_O = $04f;
  {$EXTERNALSYM XK_O}
  XK_P = $050;
  {$EXTERNALSYM XK_P}
  XK_Q = $051;
  {$EXTERNALSYM XK_Q}
  XK_R = $052;
  {$EXTERNALSYM XK_R}
  XK_S = $053;
  {$EXTERNALSYM XK_S}
  XK_T = $054;
  {$EXTERNALSYM XK_T}
  XK_U = $055;
  {$EXTERNALSYM XK_U}
  XK_V = $056;
  {$EXTERNALSYM XK_V}
  XK_W = $057;
  {$EXTERNALSYM XK_W}
  XK_X = $058;
  {$EXTERNALSYM XK_X}
  XK_Y = $059;
  {$EXTERNALSYM XK_Y}
  XK_Z = $05a;
  {$EXTERNALSYM XK_Z}
  XK_bracketleft = $05b;
  {$EXTERNALSYM XK_bracketleft}
  XK_backslash = $05c;
  {$EXTERNALSYM XK_backslash}
  XK_bracketright = $05d;
  {$EXTERNALSYM XK_bracketright}
  XK_asciicircum = $05e;
  {$EXTERNALSYM XK_asciicircum}
  XK_underscore = $05f;
  {$EXTERNALSYM XK_underscore}
  XK_grave = $060;
  {$EXTERNALSYM XK_grave}
  XK_quoteleft = $060;    { deprecated }
  {$EXTERNALSYM XK_quoteleft}
  XK_la = $061;
  {$EXTERNALSYM XK_la}
  XK_lb = $062;
  {$EXTERNALSYM XK_lb}
  XK_lc = $063;
  {$EXTERNALSYM XK_lc}
  XK_ld = $064;
  {$EXTERNALSYM XK_ld}
  XK_le = $065;
  {$EXTERNALSYM XK_le}
  XK_lf = $066;
  {$EXTERNALSYM XK_lf}
  XK_lg = $067;
  {$EXTERNALSYM XK_lg}
  XK_lh = $068;
  {$EXTERNALSYM XK_lh}
  XK_li = $069;
  {$EXTERNALSYM XK_li}
  XK_lj = $06a;
  {$EXTERNALSYM XK_lj}
  XK_lk = $06b;
  {$EXTERNALSYM XK_lk}
  XK_ll = $06c;
  {$EXTERNALSYM XK_ll}
  XK_lm = $06d;
  {$EXTERNALSYM XK_lm}
  XK_ln = $06e;
  {$EXTERNALSYM XK_ln}
  XK_lo = $06f;
  {$EXTERNALSYM XK_lo}
  XK_lp = $070;
  {$EXTERNALSYM XK_lp}
  XK_lq = $071;
  {$EXTERNALSYM XK_lq}
  XK_lr = $072;
  {$EXTERNALSYM XK_lr}
  XK_ls = $073;
  {$EXTERNALSYM XK_ls}
  XK_lt = $074;
  {$EXTERNALSYM XK_lt}
  XK_lu = $075;
  {$EXTERNALSYM XK_lu}
  XK_lv = $076;
  {$EXTERNALSYM XK_lv}
  XK_lw = $077;
  {$EXTERNALSYM XK_lw}
  XK_lx = $078;
  {$EXTERNALSYM XK_lx}
  XK_ly = $079;
  {$EXTERNALSYM XK_ly}
  XK_lz = $07a;
  {$EXTERNALSYM XK_lz}
  XK_braceleft = $07b;
  {$EXTERNALSYM XK_braceleft}
  XK_bar = $07c;
  {$EXTERNALSYM XK_bar}
  XK_braceright = $07d;
  {$EXTERNALSYM XK_braceright}
  XK_asciitilde = $07e;
  {$EXTERNALSYM XK_asciitilde}
  XK_nobreakspace = $0a0;
  {$EXTERNALSYM XK_nobreakspace}
  XK_exclamdown = $0a1;
  {$EXTERNALSYM XK_exclamdown}
  XK_cent = $0a2;
  {$EXTERNALSYM XK_cent}
  XK_sterling = $0a3;
  {$EXTERNALSYM XK_sterling}
  XK_currency = $0a4;
  {$EXTERNALSYM XK_currency}
  XK_yen = $0a5;
  {$EXTERNALSYM XK_yen}
  XK_brokenbar = $0a6;
  {$EXTERNALSYM XK_brokenbar}
  XK_section = $0a7;
  {$EXTERNALSYM XK_section}
  XK_diaeresis = $0a8;
  {$EXTERNALSYM XK_diaeresis}
  XK_copyright = $0a9;
  {$EXTERNALSYM XK_copyright}
  XK_ordfeminine = $0aa;
  {$EXTERNALSYM XK_ordfeminine}
{ left angle quotation mark  }
  XK_guillemotleft = $0ab;
  {$EXTERNALSYM XK_guillemotleft}
  XK_notsign = $0ac;
  {$EXTERNALSYM XK_notsign}
  XK_hyphen = $0ad;
  {$EXTERNALSYM XK_hyphen}
  XK_registered = $0ae;
  {$EXTERNALSYM XK_registered}
  XK_macron = $0af;
  {$EXTERNALSYM XK_macron}
  XK_degree = $0b0;
  {$EXTERNALSYM XK_degree}
  XK_plusminus = $0b1;
  {$EXTERNALSYM XK_plusminus}
  XK_twosuperior = $0b2;
  {$EXTERNALSYM XK_twosuperior}
  XK_threesuperior = $0b3;
  {$EXTERNALSYM XK_threesuperior}
  XK_acute = $0b4;
  {$EXTERNALSYM XK_acute}
  XK_mu = $0b5;
  {$EXTERNALSYM XK_mu}
  XK_paragraph = $0b6;
  {$EXTERNALSYM XK_paragraph}
  XK_periodcentered = $0b7;
  {$EXTERNALSYM XK_periodcentered}
  XK_cedilla = $0b8;
  {$EXTERNALSYM XK_cedilla}
  XK_onesuperior = $0b9;
  {$EXTERNALSYM XK_onesuperior}
  XK_masculine = $0ba;
  {$EXTERNALSYM XK_masculine}
{ right angle quotation mark  }
  XK_guillemotright = $0bb;
  {$EXTERNALSYM XK_guillemotright}
  XK_onequarter = $0bc;
  {$EXTERNALSYM XK_onequarter}
  XK_onehalf = $0bd;
  {$EXTERNALSYM XK_onehalf}
  XK_threequarters = $0be;
  {$EXTERNALSYM XK_threequarters}
  XK_questiondown = $0bf;
  {$EXTERNALSYM XK_questiondown}
  XK_Agrave = $0c0;
  {$EXTERNALSYM XK_Agrave}
  XK_Aacute = $0c1;
  {$EXTERNALSYM XK_Aacute}
  XK_Acircumflex = $0c2;
  {$EXTERNALSYM XK_Acircumflex}
  XK_Atilde = $0c3;
  {$EXTERNALSYM XK_Atilde}
  XK_Adiaeresis = $0c4;
  {$EXTERNALSYM XK_Adiaeresis}
  XK_Aring = $0c5;
  {$EXTERNALSYM XK_Aring}
  XK_AE = $0c6;
  {$EXTERNALSYM XK_AE}
  XK_Ccedilla = $0c7;
  {$EXTERNALSYM XK_Ccedilla}
  XK_Egrave = $0c8;
  {$EXTERNALSYM XK_Egrave}
  XK_Eacute = $0c9;
  {$EXTERNALSYM XK_Eacute}
  XK_Ecircumflex = $0ca;
  {$EXTERNALSYM XK_Ecircumflex}
  XK_Ediaeresis = $0cb;
  {$EXTERNALSYM XK_Ediaeresis}
  XK_Igrave = $0cc;
  {$EXTERNALSYM XK_Igrave}
  XK_Iacute = $0cd;
  {$EXTERNALSYM XK_Iacute}
  XK_Icircumflex = $0ce;
  {$EXTERNALSYM XK_Icircumflex}
  XK_Idiaeresis = $0cf;
  {$EXTERNALSYM XK_Idiaeresis}
  XK_ETH = $0d0;
  {$EXTERNALSYM XK_ETH}
{ deprecated  }
  XK_Ntilde = $0d1;
  {$EXTERNALSYM XK_Ntilde}
  XK_Ograve = $0d2;
  {$EXTERNALSYM XK_Ograve}
  XK_Oacute = $0d3;
  {$EXTERNALSYM XK_Oacute}
  XK_Ocircumflex = $0d4;
  {$EXTERNALSYM XK_Ocircumflex}
  XK_Otilde = $0d5;
  {$EXTERNALSYM XK_Otilde}
  XK_Odiaeresis = $0d6;
  {$EXTERNALSYM XK_Odiaeresis}
  XK_multiply = $0d7;
  {$EXTERNALSYM XK_multiply}
  XK_Ooblique = $0d8;
  {$EXTERNALSYM XK_Ooblique}
  XK_Ugrave = $0d9;
  {$EXTERNALSYM XK_Ugrave}
  XK_Uacute = $0da;
  {$EXTERNALSYM XK_Uacute}
  XK_Ucircumflex = $0db;
  {$EXTERNALSYM XK_Ucircumflex}
  XK_Udiaeresis = $0dc;
  {$EXTERNALSYM XK_Udiaeresis}
  XK_Yacute = $0dd;
  {$EXTERNALSYM XK_Yacute}
  XK_THORN = $0de;
  {$EXTERNALSYM XK_THORN}
{ deprecated  }
  XK_ssharp = $0df;
  {$EXTERNALSYM XK_ssharp}
  XK_ydiaeresis = $0ff;
  {$EXTERNALSYM XK_ydiaeresis}

  {
    Arabic
    Byte 3 = 5
  }

const
  XK_Arabic_comma = $5ac;
  {$EXTERNALSYM XK_Arabic_comma}
  XK_Arabic_semicolon = $5bb;
  {$EXTERNALSYM XK_Arabic_semicolon}
  XK_Arabic_question_mark = $5bf;
  {$EXTERNALSYM XK_Arabic_question_mark}
  XK_Arabic_hamza = $5c1;
  {$EXTERNALSYM XK_Arabic_hamza}
  XK_Arabic_maddaonalef = $5c2;
  {$EXTERNALSYM XK_Arabic_maddaonalef}
  XK_Arabic_hamzaonalef = $5c3;
  {$EXTERNALSYM XK_Arabic_hamzaonalef}
  XK_Arabic_hamzaonwaw = $5c4;
  {$EXTERNALSYM XK_Arabic_hamzaonwaw}
  XK_Arabic_hamzaunderalef = $5c5;
  {$EXTERNALSYM XK_Arabic_hamzaunderalef}
  XK_Arabic_hamzaonyeh = $5c6;
  {$EXTERNALSYM XK_Arabic_hamzaonyeh}
  XK_Arabic_alef = $5c7;
  {$EXTERNALSYM XK_Arabic_alef}
  XK_Arabic_beh = $5c8;
  {$EXTERNALSYM XK_Arabic_beh}
  XK_Arabic_tehmarbuta = $5c9;
  {$EXTERNALSYM XK_Arabic_tehmarbuta}
  XK_Arabic_teh = $5ca;
  {$EXTERNALSYM XK_Arabic_teh}
  XK_Arabic_theh = $5cb;
  {$EXTERNALSYM XK_Arabic_theh}
  XK_Arabic_jeem = $5cc;
  {$EXTERNALSYM XK_Arabic_jeem}
  XK_Arabic_hah = $5cd;
  {$EXTERNALSYM XK_Arabic_hah}
  XK_Arabic_khah = $5ce;
  {$EXTERNALSYM XK_Arabic_khah}
  XK_Arabic_dal = $5cf;
  {$EXTERNALSYM XK_Arabic_dal}
  XK_Arabic_thal = $5d0;
  {$EXTERNALSYM XK_Arabic_thal}
  XK_Arabic_ra = $5d1;
  {$EXTERNALSYM XK_Arabic_ra}
  XK_Arabic_zain = $5d2;
  {$EXTERNALSYM XK_Arabic_zain}
  XK_Arabic_seen = $5d3;
  {$EXTERNALSYM XK_Arabic_seen}
  XK_Arabic_sheen = $5d4;
  {$EXTERNALSYM XK_Arabic_sheen}
  XK_Arabic_sad = $5d5;
  {$EXTERNALSYM XK_Arabic_sad}
  XK_Arabic_dad = $5d6;
  {$EXTERNALSYM XK_Arabic_dad}
  XK_Arabic_tah = $5d7;
  {$EXTERNALSYM XK_Arabic_tah}
  XK_Arabic_zah = $5d8;
  {$EXTERNALSYM XK_Arabic_zah}
  XK_Arabic_ain = $5d9;
  {$EXTERNALSYM XK_Arabic_ain}
  XK_Arabic_ghain = $5da;
  {$EXTERNALSYM XK_Arabic_ghain}
  XK_Arabic_tatweel = $5e0;
  {$EXTERNALSYM XK_Arabic_tatweel}
  XK_Arabic_feh = $5e1;
  {$EXTERNALSYM XK_Arabic_feh}
  XK_Arabic_qaf = $5e2;
  {$EXTERNALSYM XK_Arabic_qaf}
  XK_Arabic_kaf = $5e3;
  {$EXTERNALSYM XK_Arabic_kaf}
  XK_Arabic_lam = $5e4;
  {$EXTERNALSYM XK_Arabic_lam}
  XK_Arabic_meem = $5e5;
  {$EXTERNALSYM XK_Arabic_meem}
  XK_Arabic_noon = $5e6;
  {$EXTERNALSYM XK_Arabic_noon}
  XK_Arabic_ha = $5e7;
  {$EXTERNALSYM XK_Arabic_ha}
{ deprecated  }
  XK_Arabic_heh = $5e7;
  {$EXTERNALSYM XK_Arabic_heh}
  XK_Arabic_waw = $5e8;
  {$EXTERNALSYM XK_Arabic_waw}
  XK_Arabic_alefmaksura = $5e9;
  {$EXTERNALSYM XK_Arabic_alefmaksura}
  XK_Arabic_yeh = $5ea;
  {$EXTERNALSYM XK_Arabic_yeh}
  XK_Arabic_fathatan = $5eb;
  {$EXTERNALSYM XK_Arabic_fathatan}
  XK_Arabic_dammatan = $5ec;
  {$EXTERNALSYM XK_Arabic_dammatan}
  XK_Arabic_kasratan = $5ed;
  {$EXTERNALSYM XK_Arabic_kasratan}
  XK_Arabic_fatha = $5ee;
  {$EXTERNALSYM XK_Arabic_fatha}
  XK_Arabic_damma = $5ef;
  {$EXTERNALSYM XK_Arabic_damma}
  XK_Arabic_kasra = $5f0;
  {$EXTERNALSYM XK_Arabic_kasra}
  XK_Arabic_shadda = $5f1;
  {$EXTERNALSYM XK_Arabic_shadda}
  XK_Arabic_sukun = $5f2;
  {$EXTERNALSYM XK_Arabic_sukun}
{ Alias for mode_switch  }
  XK_Arabic_switch = $FF7E;
  {$EXTERNALSYM XK_Arabic_switch}

  {
   Technical
   Byte 3 = 8
  }

const
  XK_leftradical = $8a1;
  {$EXTERNALSYM XK_leftradical}
  XK_topleftradical = $8a2;
  {$EXTERNALSYM XK_topleftradical}
  XK_horizconnector = $8a3;
  {$EXTERNALSYM XK_horizconnector}
  XK_topintegral = $8a4;
  {$EXTERNALSYM XK_topintegral}
  XK_botintegral = $8a5;
  {$EXTERNALSYM XK_botintegral}
  XK_vertconnector = $8a6;
  {$EXTERNALSYM XK_vertconnector}
  XK_topleftsqbracket = $8a7;
  {$EXTERNALSYM XK_topleftsqbracket}
  XK_botleftsqbracket = $8a8;
  {$EXTERNALSYM XK_botleftsqbracket}
  XK_toprightsqbracket = $8a9;
  {$EXTERNALSYM XK_toprightsqbracket}
  XK_botrightsqbracket = $8aa;
  {$EXTERNALSYM XK_botrightsqbracket}
  XK_topleftparens = $8ab;
  {$EXTERNALSYM XK_topleftparens}
  XK_botleftparens = $8ac;
  {$EXTERNALSYM XK_botleftparens}
  XK_toprightparens = $8ad;
  {$EXTERNALSYM XK_toprightparens}
  XK_botrightparens = $8ae;
  {$EXTERNALSYM XK_botrightparens}
  XK_leftmiddlecurlybrace = $8af;
  {$EXTERNALSYM XK_leftmiddlecurlybrace}
  XK_rightmiddlecurlybrace = $8b0;
  {$EXTERNALSYM XK_rightmiddlecurlybrace}
  XK_topleftsummation = $8b1;
  {$EXTERNALSYM XK_topleftsummation}
  XK_botleftsummation = $8b2;
  {$EXTERNALSYM XK_botleftsummation}
  XK_topvertsummationconnector = $8b3;
  {$EXTERNALSYM XK_topvertsummationconnector}
  XK_botvertsummationconnector = $8b4;
  {$EXTERNALSYM XK_botvertsummationconnector}
  XK_toprightsummation = $8b5;
  {$EXTERNALSYM XK_toprightsummation}
  XK_botrightsummation = $8b6;
  {$EXTERNALSYM XK_botrightsummation}
  XK_rightmiddlesummation = $8b7;
  {$EXTERNALSYM XK_rightmiddlesummation}
  XK_lessthanequal = $8bc;
  {$EXTERNALSYM XK_lessthanequal}
  XK_notequal = $8bd;
  {$EXTERNALSYM XK_notequal}
  XK_greaterthanequal = $8be;
  {$EXTERNALSYM XK_greaterthanequal}
  XK_integral = $8bf;
  {$EXTERNALSYM XK_integral}
  XK_therefore = $8c0;
  {$EXTERNALSYM XK_therefore}
  XK_variation = $8c1;
  {$EXTERNALSYM XK_variation}
  XK_infinity = $8c2;
  {$EXTERNALSYM XK_infinity}
  XK_nabla = $8c5;
  {$EXTERNALSYM XK_nabla}
  XK_approximate = $8c8;
  {$EXTERNALSYM XK_approximate}
  XK_similarequal = $8c9;
  {$EXTERNALSYM XK_similarequal}
  XK_ifonlyif = $8cd;
  {$EXTERNALSYM XK_ifonlyif}
  XK_implies = $8ce;
  {$EXTERNALSYM XK_implies}
  XK_identical = $8cf;
  {$EXTERNALSYM XK_identical}
  XK_radical = $8d6;
  {$EXTERNALSYM XK_radical}
  XK_includedin = $8da;
  {$EXTERNALSYM XK_includedin}
  XK_includes = $8db;
  {$EXTERNALSYM XK_includes}
  XK_intersection = $8dc;
  {$EXTERNALSYM XK_intersection}
  XK_union = $8dd;
  {$EXTERNALSYM XK_union}
  XK_logicaland = $8de;
  {$EXTERNALSYM XK_logicaland}
  XK_logicalor = $8df;
  {$EXTERNALSYM XK_logicalor}
  XK_partialderivative = $8ef;
  {$EXTERNALSYM XK_partialderivative}
  XK_function = $8f6;
  {$EXTERNALSYM XK_function}
  XK_leftarrow = $8fb;
  {$EXTERNALSYM XK_leftarrow}
  XK_uparrow = $8fc;
  {$EXTERNALSYM XK_uparrow}
  XK_rightarrow = $8fd;
  {$EXTERNALSYM XK_rightarrow}
  XK_downarrow = $8fe;
  {$EXTERNALSYM XK_downarrow}

  {
    Special
    Byte 3 = 9
  }

const
  XK_blank = $9df;
  {$EXTERNALSYM XK_blank}
  XK_soliddiamond = $9e0;
  {$EXTERNALSYM XK_soliddiamond}
  XK_checkerboard = $9e1;
  {$EXTERNALSYM XK_checkerboard}
  XK_ht = $9e2;
  {$EXTERNALSYM XK_ht}
  XK_ff = $9e3;
  {$EXTERNALSYM XK_ff}
  XK_cr = $9e4;
  {$EXTERNALSYM XK_cr}
  // XK_lf = $9e5;
  // {$EXTERNALSYM XK_lf}
  XK_nl = $9e8;
  {$EXTERNALSYM XK_nl}
  XK_vt = $9e9;
  {$EXTERNALSYM XK_vt}
  XK_lowrightcorner = $9ea;
  {$EXTERNALSYM XK_lowrightcorner}
  XK_uprightcorner = $9eb;
  {$EXTERNALSYM XK_uprightcorner}
  XK_upleftcorner = $9ec;
  {$EXTERNALSYM XK_upleftcorner}
  XK_lowleftcorner = $9ed;
  {$EXTERNALSYM XK_lowleftcorner}
  XK_crossinglines = $9ee;
  {$EXTERNALSYM XK_crossinglines}
  XK_horizlinescan1 = $9ef;
  {$EXTERNALSYM XK_horizlinescan1}
  XK_horizlinescan3 = $9f0;
  {$EXTERNALSYM XK_horizlinescan3}
  XK_horizlinescan5 = $9f1;
  {$EXTERNALSYM XK_horizlinescan5}
  XK_horizlinescan7 = $9f2;
  {$EXTERNALSYM XK_horizlinescan7}
  XK_horizlinescan9 = $9f3;
  {$EXTERNALSYM XK_horizlinescan9}
  XK_leftt = $9f4;
  {$EXTERNALSYM XK_leftt}
  XK_rightt = $9f5;
  {$EXTERNALSYM XK_rightt}
  XK_bott = $9f6;
  {$EXTERNALSYM XK_bott}
  XK_topt = $9f7;
  {$EXTERNALSYM XK_topt}
  XK_vertbar = $9f8;
  {$EXTERNALSYM XK_vertbar}

  {
    Publishing
    Byte 3 = a
  }

const
  XK_emspace = $aa1;
  {$EXTERNALSYM XK_emspace}
  XK_enspace = $aa2;
  {$EXTERNALSYM XK_enspace}
  XK_em3space = $aa3;
  {$EXTERNALSYM XK_em3space}
  XK_em4space = $aa4;
  {$EXTERNALSYM XK_em4space}
  XK_digitspace = $aa5;
  {$EXTERNALSYM XK_digitspace}
  XK_punctspace = $aa6;
  {$EXTERNALSYM XK_punctspace}
  XK_thinspace = $aa7;
  {$EXTERNALSYM XK_thinspace}
  XK_hairspace = $aa8;
  {$EXTERNALSYM XK_hairspace}
  XK_emdash = $aa9;
  {$EXTERNALSYM XK_emdash}
  XK_endash = $aaa;
  {$EXTERNALSYM XK_endash}
  XK_signifblank = $aac;
  {$EXTERNALSYM XK_signifblank}
  XK_ellipsis = $aae;
  {$EXTERNALSYM XK_ellipsis}
  XK_doubbaselinedot = $aaf;
  {$EXTERNALSYM XK_doubbaselinedot}
  XK_onethird = $ab0;
  {$EXTERNALSYM XK_onethird}
  XK_twothirds = $ab1;
  {$EXTERNALSYM XK_twothirds}
  XK_onefifth = $ab2;
  {$EXTERNALSYM XK_onefifth}
  XK_twofifths = $ab3;
  {$EXTERNALSYM XK_twofifths}
  XK_threefifths = $ab4;
  {$EXTERNALSYM XK_threefifths}
  XK_fourfifths = $ab5;
  {$EXTERNALSYM XK_fourfifths}
  XK_onesixth = $ab6;
  {$EXTERNALSYM XK_onesixth}
  XK_fivesixths = $ab7;
  {$EXTERNALSYM XK_fivesixths}
  XK_careof = $ab8;
  {$EXTERNALSYM XK_careof}
  XK_figdash = $abb;
  {$EXTERNALSYM XK_figdash}
  XK_leftanglebracket = $abc;
  {$EXTERNALSYM XK_leftanglebracket}
  XK_decimalpoint = $abd;
  {$EXTERNALSYM XK_decimalpoint}
  XK_rightanglebracket = $abe;
  {$EXTERNALSYM XK_rightanglebracket}
  XK_marker = $abf;
  {$EXTERNALSYM XK_marker}
  XK_oneeighth = $ac3;
  {$EXTERNALSYM XK_oneeighth}
  XK_threeeighths = $ac4;
  {$EXTERNALSYM XK_threeeighths}
  XK_fiveeighths = $ac5;
  {$EXTERNALSYM XK_fiveeighths}
  XK_seveneighths = $ac6;
  {$EXTERNALSYM XK_seveneighths}
  XK_trademark = $ac9;
  {$EXTERNALSYM XK_trademark}
  XK_signaturemark = $aca;
  {$EXTERNALSYM XK_signaturemark}
  XK_trademarkincircle = $acb;
  {$EXTERNALSYM XK_trademarkincircle}
  XK_leftopentriangle = $acc;
  {$EXTERNALSYM XK_leftopentriangle}
  XK_rightopentriangle = $acd;
  {$EXTERNALSYM XK_rightopentriangle}
  XK_emopencircle = $ace;
  {$EXTERNALSYM XK_emopencircle}
  XK_emopenrectangle = $acf;
  {$EXTERNALSYM XK_emopenrectangle}
  XK_leftsinglequotemark = $ad0;
  {$EXTERNALSYM XK_leftsinglequotemark}
  XK_rightsinglequotemark = $ad1;
  {$EXTERNALSYM XK_rightsinglequotemark}
  XK_leftdoublequotemark = $ad2;
  {$EXTERNALSYM XK_leftdoublequotemark}
  XK_rightdoublequotemark = $ad3;
  {$EXTERNALSYM XK_rightdoublequotemark}
  XK_prescription = $ad4;
  {$EXTERNALSYM XK_prescription}
  XK_minutes = $ad6;
  {$EXTERNALSYM XK_minutes}
  XK_seconds = $ad7;
  {$EXTERNALSYM XK_seconds}
  XK_latincross = $ad9;
  {$EXTERNALSYM XK_latincross}
  XK_hexagram = $ada;
  {$EXTERNALSYM XK_hexagram}
  XK_filledrectbullet = $adb;
  {$EXTERNALSYM XK_filledrectbullet}
  XK_filledlefttribullet = $adc;
  {$EXTERNALSYM XK_filledlefttribullet}
  XK_filledrighttribullet = $add;
  {$EXTERNALSYM XK_filledrighttribullet}
  XK_emfilledcircle = $ade;
  {$EXTERNALSYM XK_emfilledcircle}
  XK_emfilledrect = $adf;
  {$EXTERNALSYM XK_emfilledrect}
  XK_enopencircbullet = $ae0;
  {$EXTERNALSYM XK_enopencircbullet}
  XK_enopensquarebullet = $ae1;
  {$EXTERNALSYM XK_enopensquarebullet}
  XK_openrectbullet = $ae2;
  {$EXTERNALSYM XK_openrectbullet}
  XK_opentribulletup = $ae3;
  {$EXTERNALSYM XK_opentribulletup}
  XK_opentribulletdown = $ae4;
  {$EXTERNALSYM XK_opentribulletdown}
  XK_openstar = $ae5;
  {$EXTERNALSYM XK_openstar}
  XK_enfilledcircbullet = $ae6;
  {$EXTERNALSYM XK_enfilledcircbullet}
  XK_enfilledsqbullet = $ae7;
  {$EXTERNALSYM XK_enfilledsqbullet}
  XK_filledtribulletup = $ae8;
  {$EXTERNALSYM XK_filledtribulletup}
  XK_filledtribulletdown = $ae9;
  {$EXTERNALSYM XK_filledtribulletdown}
  XK_leftpointer = $aea;
  {$EXTERNALSYM XK_leftpointer}
  XK_rightpointer = $aeb;
  {$EXTERNALSYM XK_rightpointer}
  XK_club = $aec;
  {$EXTERNALSYM XK_club}
  XK_diamond = $aed;
  {$EXTERNALSYM XK_diamond}
  XK_heart = $aee;
  {$EXTERNALSYM XK_heart}
  XK_maltesecross = $af0;
  {$EXTERNALSYM XK_maltesecross}
  XK_dagger = $af1;
  {$EXTERNALSYM XK_dagger}
  XK_doubledagger = $af2;
  {$EXTERNALSYM XK_doubledagger}
  XK_checkmark = $af3;
  {$EXTERNALSYM XK_checkmark}
  XK_ballotcross = $af4;
  {$EXTERNALSYM XK_ballotcross}
  XK_musicalsharp = $af5;
  {$EXTERNALSYM XK_musicalsharp}
  XK_musicalflat = $af6;
  {$EXTERNALSYM XK_musicalflat}
  XK_malesymbol = $af7;
  {$EXTERNALSYM XK_malesymbol}
  XK_femalesymbol = $af8;
  {$EXTERNALSYM XK_femalesymbol}
  XK_telephone = $af9;
  {$EXTERNALSYM XK_telephone}
  XK_telephonerecorder = $afa;
  {$EXTERNALSYM XK_telephonerecorder}
  XK_phonographcopyright = $afb;
  {$EXTERNALSYM XK_phonographcopyright}
  XK_caret = $afc;
  {$EXTERNALSYM XK_caret}
  XK_singlelowquotemark = $afd;
  {$EXTERNALSYM XK_singlelowquotemark}
  XK_doublelowquotemark = $afe;
  {$EXTERNALSYM XK_doublelowquotemark}
  XK_cursor = $aff;
  {$EXTERNALSYM XK_cursor}

  {
    APL
    Byte 3 = b
  }

const
  XK_leftcaret = $ba3;
  {$EXTERNALSYM XK_leftcaret}
  XK_rightcaret = $ba6;
  {$EXTERNALSYM XK_rightcaret}
  XK_downcaret = $ba8;
  {$EXTERNALSYM XK_downcaret}
  XK_upcaret = $ba9;
  {$EXTERNALSYM XK_upcaret}
  XK_overbar = $bc0;
  {$EXTERNALSYM XK_overbar}
  XK_downtack = $bc2;
  {$EXTERNALSYM XK_downtack}
  XK_upshoe = $bc3;
  {$EXTERNALSYM XK_upshoe}
  XK_downstile = $bc4;
  {$EXTERNALSYM XK_downstile}
  XK_underbar = $bc6;
  {$EXTERNALSYM XK_underbar}
  XK_jot = $bca;
  {$EXTERNALSYM XK_jot}
  XK_quad = $bcc;
  {$EXTERNALSYM XK_quad}
  XK_uptack = $bce;
  {$EXTERNALSYM XK_uptack}
  XK_circle = $bcf;
  {$EXTERNALSYM XK_circle}
  XK_upstile = $bd3;
  {$EXTERNALSYM XK_upstile}
  XK_downshoe = $bd6;
  {$EXTERNALSYM XK_downshoe}
  XK_rightshoe = $bd8;
  {$EXTERNALSYM XK_rightshoe}
  XK_leftshoe = $bda;
  {$EXTERNALSYM XK_leftshoe}
  XK_lefttack = $bdc;
  {$EXTERNALSYM XK_lefttack}
  XK_righttack = $bfc;
  {$EXTERNALSYM XK_righttack}

  {
   Hebrew
   Byte 3 = c
  }

const
  XK_hebrew_doublelowline = $cdf;
  {$EXTERNALSYM XK_hebrew_doublelowline}
  XK_hebrew_aleph = $ce0;
  {$EXTERNALSYM XK_hebrew_aleph}
  XK_hebrew_bet = $ce1;
  {$EXTERNALSYM XK_hebrew_bet}
{ deprecated  }
  XK_hebrew_beth = $ce1;
  {$EXTERNALSYM XK_hebrew_beth}
  XK_hebrew_gimel = $ce2;
  {$EXTERNALSYM XK_hebrew_gimel}
{ deprecated  }
  XK_hebrew_gimmel = $ce2;
  {$EXTERNALSYM XK_hebrew_gimmel}
  XK_hebrew_dalet = $ce3;
  {$EXTERNALSYM XK_hebrew_dalet}
{ deprecated  }
  XK_hebrew_daleth = $ce3;
  {$EXTERNALSYM XK_hebrew_daleth}
  XK_hebrew_he = $ce4;
  {$EXTERNALSYM XK_hebrew_he}
  XK_hebrew_waw = $ce5;
  {$EXTERNALSYM XK_hebrew_waw}
  XK_hebrew_zain = $ce6;
  {$EXTERNALSYM XK_hebrew_zain}
{ deprecated  }
  XK_hebrew_zayin = $ce6;
  {$EXTERNALSYM XK_hebrew_zayin}
  XK_hebrew_chet = $ce7;
  {$EXTERNALSYM XK_hebrew_chet}
{ deprecated  }
  XK_hebrew_het = $ce7;
  {$EXTERNALSYM XK_hebrew_het}
  XK_hebrew_tet = $ce8;
  {$EXTERNALSYM XK_hebrew_tet}
{ deprecated  }
  XK_hebrew_teth = $ce8;
  {$EXTERNALSYM XK_hebrew_teth}
  XK_hebrew_yod = $ce9;
  {$EXTERNALSYM XK_hebrew_yod}
  XK_hebrew_finalkaph = $cea;
  {$EXTERNALSYM XK_hebrew_finalkaph}
  XK_hebrew_kaph = $ceb;
  {$EXTERNALSYM XK_hebrew_kaph}
  XK_hebrew_lamed = $cec;
  {$EXTERNALSYM XK_hebrew_lamed}
  XK_hebrew_finalmem = $ced;
  {$EXTERNALSYM XK_hebrew_finalmem}
  XK_hebrew_mem = $cee;
  {$EXTERNALSYM XK_hebrew_mem}
  XK_hebrew_finalnun = $cef;
  {$EXTERNALSYM XK_hebrew_finalnun}
  XK_hebrew_nun = $cf0;
  {$EXTERNALSYM XK_hebrew_nun}
  XK_hebrew_samech = $cf1;
  {$EXTERNALSYM XK_hebrew_samech}
{ deprecated  }
  XK_hebrew_samekh = $cf1;
  {$EXTERNALSYM XK_hebrew_samekh}
  XK_hebrew_ayin = $cf2;
  {$EXTERNALSYM XK_hebrew_ayin}
  XK_hebrew_finalpe = $cf3;
  {$EXTERNALSYM XK_hebrew_finalpe}
  XK_hebrew_pe = $cf4;
  {$EXTERNALSYM XK_hebrew_pe}
  XK_hebrew_finalzade = $cf5;
  {$EXTERNALSYM XK_hebrew_finalzade}
{ deprecated  }
  XK_hebrew_finalzadi = $cf5;
  {$EXTERNALSYM XK_hebrew_finalzadi}
  XK_hebrew_zade = $cf6;
  {$EXTERNALSYM XK_hebrew_zade}
{ deprecated  }
  XK_hebrew_zadi = $cf6;
  {$EXTERNALSYM XK_hebrew_zadi}
  XK_hebrew_qoph = $cf7;
  {$EXTERNALSYM XK_hebrew_qoph}
{ deprecated  }
  XK_hebrew_kuf = $cf7;
  {$EXTERNALSYM XK_hebrew_kuf}
  XK_hebrew_resh = $cf8;
  {$EXTERNALSYM XK_hebrew_resh}
  XK_hebrew_shin = $cf9;
  {$EXTERNALSYM XK_hebrew_shin}
  XK_hebrew_taw = $cfa;
  {$EXTERNALSYM XK_hebrew_taw}
{ deprecated  }
  XK_hebrew_taf = $cfa;
  {$EXTERNALSYM XK_hebrew_taf}
{ Alias for mode_switch  }
  XK_Hebrew_switch = $FF7E;
  {$EXTERNALSYM XK_Hebrew_switch}

  {
   Thai
   Byte 3 = d
  }

const
  XK_Thai_kokai = $da1;
  {$EXTERNALSYM XK_Thai_kokai}
  XK_Thai_khokhai = $da2;
  {$EXTERNALSYM XK_Thai_khokhai}
  XK_Thai_khokhuat = $da3;
  {$EXTERNALSYM XK_Thai_khokhuat}
  XK_Thai_khokhwai = $da4;
  {$EXTERNALSYM XK_Thai_khokhwai}
  XK_Thai_khokhon = $da5;
  {$EXTERNALSYM XK_Thai_khokhon}
  XK_Thai_khorakhang = $da6;
  {$EXTERNALSYM XK_Thai_khorakhang}
  XK_Thai_ngongu = $da7;
  {$EXTERNALSYM XK_Thai_ngongu}
  XK_Thai_chochan = $da8;
  {$EXTERNALSYM XK_Thai_chochan}
  XK_Thai_choching = $da9;
  {$EXTERNALSYM XK_Thai_choching}
  XK_Thai_chochang = $daa;
  {$EXTERNALSYM XK_Thai_chochang}
  XK_Thai_soso = $dab;
  {$EXTERNALSYM XK_Thai_soso}
  XK_Thai_chochoe = $dac;
  {$EXTERNALSYM XK_Thai_chochoe}
  XK_Thai_yoying = $dad;
  {$EXTERNALSYM XK_Thai_yoying}
  XK_Thai_dochada = $dae;
  {$EXTERNALSYM XK_Thai_dochada}
  XK_Thai_topatak = $daf;
  {$EXTERNALSYM XK_Thai_topatak}
  XK_Thai_thothan = $db0;
  {$EXTERNALSYM XK_Thai_thothan}
  XK_Thai_thonangmontho = $db1;
  {$EXTERNALSYM XK_Thai_thonangmontho}
  XK_Thai_thophuthao = $db2;
  {$EXTERNALSYM XK_Thai_thophuthao}
  XK_Thai_nonen = $db3;
  {$EXTERNALSYM XK_Thai_nonen}
  XK_Thai_dodek = $db4;
  {$EXTERNALSYM XK_Thai_dodek}
  XK_Thai_totao = $db5;
  {$EXTERNALSYM XK_Thai_totao}
  XK_Thai_thothung = $db6;
  {$EXTERNALSYM XK_Thai_thothung}
  XK_Thai_thothahan = $db7;
  {$EXTERNALSYM XK_Thai_thothahan}
  XK_Thai_thothong = $db8;
  {$EXTERNALSYM XK_Thai_thothong}
  XK_Thai_nonu = $db9;
  {$EXTERNALSYM XK_Thai_nonu}
  XK_Thai_bobaimai = $dba;
  {$EXTERNALSYM XK_Thai_bobaimai}
  XK_Thai_popla = $dbb;
  {$EXTERNALSYM XK_Thai_popla}
  XK_Thai_phophung = $dbc;
  {$EXTERNALSYM XK_Thai_phophung}
  XK_Thai_fofa = $dbd;
  {$EXTERNALSYM XK_Thai_fofa}
  XK_Thai_phophan = $dbe;
  {$EXTERNALSYM XK_Thai_phophan}
  XK_Thai_fofan = $dbf;
  {$EXTERNALSYM XK_Thai_fofan}
  XK_Thai_phosamphao = $dc0;
  {$EXTERNALSYM XK_Thai_phosamphao}
  XK_Thai_moma = $dc1;
  {$EXTERNALSYM XK_Thai_moma}
  XK_Thai_yoyak = $dc2;
  {$EXTERNALSYM XK_Thai_yoyak}
  XK_Thai_rorua = $dc3;
  {$EXTERNALSYM XK_Thai_rorua}
  XK_Thai_ru = $dc4;
  {$EXTERNALSYM XK_Thai_ru}
  XK_Thai_loling = $dc5;
  {$EXTERNALSYM XK_Thai_loling}
  XK_Thai_lu = $dc6;
  {$EXTERNALSYM XK_Thai_lu}
  XK_Thai_wowaen = $dc7;
  {$EXTERNALSYM XK_Thai_wowaen}
  XK_Thai_sosala = $dc8;
  {$EXTERNALSYM XK_Thai_sosala}
  XK_Thai_sorusi = $dc9;
  {$EXTERNALSYM XK_Thai_sorusi}
  XK_Thai_sosua = $dca;
  {$EXTERNALSYM XK_Thai_sosua}
  XK_Thai_hohip = $dcb;
  {$EXTERNALSYM XK_Thai_hohip}
  XK_Thai_lochula = $dcc;
  {$EXTERNALSYM XK_Thai_lochula}
  XK_Thai_oang = $dcd;
  {$EXTERNALSYM XK_Thai_oang}
  XK_Thai_honokhuk = $dce;
  {$EXTERNALSYM XK_Thai_honokhuk}
  XK_Thai_paiyannoi = $dcf;
  {$EXTERNALSYM XK_Thai_paiyannoi}
  XK_Thai_saraa = $dd0;
  {$EXTERNALSYM XK_Thai_saraa}
  XK_Thai_maihanakat = $dd1;
  {$EXTERNALSYM XK_Thai_maihanakat}
  XK_Thai_saraaa = $dd2;
  {$EXTERNALSYM XK_Thai_saraaa}
  XK_Thai_saraam = $dd3;
  {$EXTERNALSYM XK_Thai_saraam}
  XK_Thai_sarai = $dd4;
  {$EXTERNALSYM XK_Thai_sarai}
  XK_Thai_saraii = $dd5;
  {$EXTERNALSYM XK_Thai_saraii}
  XK_Thai_saraue = $dd6;
  {$EXTERNALSYM XK_Thai_saraue}
  XK_Thai_sarauee = $dd7;
  {$EXTERNALSYM XK_Thai_sarauee}
  XK_Thai_sarau = $dd8;
  {$EXTERNALSYM XK_Thai_sarau}
  XK_Thai_sarauu = $dd9;
  {$EXTERNALSYM XK_Thai_sarauu}
  XK_Thai_phinthu = $dda;
  {$EXTERNALSYM XK_Thai_phinthu}
  XK_Thai_maihanakat_maitho = $dde;
  {$EXTERNALSYM XK_Thai_maihanakat_maitho}
  XK_Thai_baht = $ddf;
  {$EXTERNALSYM XK_Thai_baht}
  XK_Thai_sarae = $de0;
  {$EXTERNALSYM XK_Thai_sarae}
  XK_Thai_saraae = $de1;
  {$EXTERNALSYM XK_Thai_saraae}
  XK_Thai_sarao = $de2;
  {$EXTERNALSYM XK_Thai_sarao}
  XK_Thai_saraaimaimuan = $de3;
  {$EXTERNALSYM XK_Thai_saraaimaimuan}
  XK_Thai_saraaimaimalai = $de4;
  {$EXTERNALSYM XK_Thai_saraaimaimalai}
  XK_Thai_lakkhangyao = $de5;
  {$EXTERNALSYM XK_Thai_lakkhangyao}
  XK_Thai_maiyamok = $de6;
  {$EXTERNALSYM XK_Thai_maiyamok}
  XK_Thai_maitaikhu = $de7;
  {$EXTERNALSYM XK_Thai_maitaikhu}
  XK_Thai_maiek = $de8;
  {$EXTERNALSYM XK_Thai_maiek}
  XK_Thai_maitho = $de9;
  {$EXTERNALSYM XK_Thai_maitho}
  XK_Thai_maitri = $dea;
  {$EXTERNALSYM XK_Thai_maitri}
  XK_Thai_maichattawa = $deb;
  {$EXTERNALSYM XK_Thai_maichattawa}
  XK_Thai_thanthakhat = $dec;
  {$EXTERNALSYM XK_Thai_thanthakhat}
  XK_Thai_nikhahit = $ded;
  {$EXTERNALSYM XK_Thai_nikhahit}
  XK_Thai_leksun = $df0;
  {$EXTERNALSYM XK_Thai_leksun}
  XK_Thai_leknung = $df1;
  {$EXTERNALSYM XK_Thai_leknung}
  XK_Thai_leksong = $df2;
  {$EXTERNALSYM XK_Thai_leksong}
  XK_Thai_leksam = $df3;
  {$EXTERNALSYM XK_Thai_leksam}
  XK_Thai_leksi = $df4;
  {$EXTERNALSYM XK_Thai_leksi}
  XK_Thai_lekha = $df5;
  {$EXTERNALSYM XK_Thai_lekha}
  XK_Thai_lekhok = $df6;
  {$EXTERNALSYM XK_Thai_lekhok}
  XK_Thai_lekchet = $df7;
  {$EXTERNALSYM XK_Thai_lekchet}
  XK_Thai_lekpaet = $df8;
  {$EXTERNALSYM XK_Thai_lekpaet}
  XK_Thai_lekkao = $df9;
  {$EXTERNALSYM XK_Thai_lekkao}

  {
     Korean
     Byte 3 = e
  }
{ Hangul start/stop(toggle)  }

const
  XK_Hangul = $ff31;
  {$EXTERNALSYM XK_Hangul}
{ Hangul start  }
  XK_Hangul_Start = $ff32;
  {$EXTERNALSYM XK_Hangul_Start}
{ Hangul end, English start  }
  XK_Hangul_End = $ff33;
  {$EXTERNALSYM XK_Hangul_End}
{ Start Hangul->Hanja Conversion  }
  XK_Hangul_Hanja = $ff34;
  {$EXTERNALSYM XK_Hangul_Hanja}
{ Hangul Jamo mode  }
  XK_Hangul_Jamo = $ff35;
  {$EXTERNALSYM XK_Hangul_Jamo}
{ Hangul Romaja mode  }
  XK_Hangul_Romaja = $ff36;
  {$EXTERNALSYM XK_Hangul_Romaja}
{ Hangul code input mode  }
  XK_Hangul_Codeinput = $ff37;
  {$EXTERNALSYM XK_Hangul_Codeinput}
{ Jeonja mode  }
  XK_Hangul_Jeonja = $ff38;
  {$EXTERNALSYM XK_Hangul_Jeonja}
{ Banja mode  }
  XK_Hangul_Banja = $ff39;
  {$EXTERNALSYM XK_Hangul_Banja}
{ Pre Hanja conversion  }
  XK_Hangul_PreHanja = $ff3a;
  {$EXTERNALSYM XK_Hangul_PreHanja}
{ Post Hanja conversion  }
  XK_Hangul_PostHanja = $ff3b;
  {$EXTERNALSYM XK_Hangul_PostHanja}
{ Single candidate  }
  XK_Hangul_SingleCandidate = $ff3c;
  {$EXTERNALSYM XK_Hangul_SingleCandidate}
{ Multiple candidate  }
  XK_Hangul_MultipleCandidate = $ff3d;
  {$EXTERNALSYM XK_Hangul_MultipleCandidate}
{ Previous candidate  }
  XK_Hangul_PreviousCandidate = $ff3e;
  {$EXTERNALSYM XK_Hangul_PreviousCandidate}
{ Special symbols  }
  XK_Hangul_Special = $ff3f;
  {$EXTERNALSYM XK_Hangul_Special}
{ Alias for mode_switch  }
  XK_Hangul_switch = $FF7E;
  {$EXTERNALSYM XK_Hangul_switch}
{ Hangul Consonant Characters  }
  XK_Hangul_Kiyeog = $ea1;
  {$EXTERNALSYM XK_Hangul_Kiyeog}
  XK_Hangul_SsangKiyeog = $ea2;
  {$EXTERNALSYM XK_Hangul_SsangKiyeog}
  XK_Hangul_KiyeogSios = $ea3;
  {$EXTERNALSYM XK_Hangul_KiyeogSios}
  XK_Hangul_Nieun = $ea4;
  {$EXTERNALSYM XK_Hangul_Nieun}
  XK_Hangul_NieunJieuj = $ea5;
  {$EXTERNALSYM XK_Hangul_NieunJieuj}
  XK_Hangul_NieunHieuh = $ea6;
  {$EXTERNALSYM XK_Hangul_NieunHieuh}
  XK_Hangul_Dikeud = $ea7;
  {$EXTERNALSYM XK_Hangul_Dikeud}
  XK_Hangul_SsangDikeud = $ea8;
  {$EXTERNALSYM XK_Hangul_SsangDikeud}
  XK_Hangul_Rieul = $ea9;
  {$EXTERNALSYM XK_Hangul_Rieul}
  XK_Hangul_RieulKiyeog = $eaa;
  {$EXTERNALSYM XK_Hangul_RieulKiyeog}
  XK_Hangul_RieulMieum = $eab;
  {$EXTERNALSYM XK_Hangul_RieulMieum}
  XK_Hangul_RieulPieub = $eac;
  {$EXTERNALSYM XK_Hangul_RieulPieub}
  XK_Hangul_RieulSios = $ead;
  {$EXTERNALSYM XK_Hangul_RieulSios}
  XK_Hangul_RieulTieut = $eae;
  {$EXTERNALSYM XK_Hangul_RieulTieut}
  XK_Hangul_RieulPhieuf = $eaf;
  {$EXTERNALSYM XK_Hangul_RieulPhieuf}
  XK_Hangul_RieulHieuh = $eb0;
  {$EXTERNALSYM XK_Hangul_RieulHieuh}
  XK_Hangul_Mieum = $eb1;
  {$EXTERNALSYM XK_Hangul_Mieum}
  XK_Hangul_Pieub = $eb2;
  {$EXTERNALSYM XK_Hangul_Pieub}
  XK_Hangul_SsangPieub = $eb3;
  {$EXTERNALSYM XK_Hangul_SsangPieub}
  XK_Hangul_PieubSios = $eb4;
  {$EXTERNALSYM XK_Hangul_PieubSios}
  XK_Hangul_Sios = $eb5;
  {$EXTERNALSYM XK_Hangul_Sios}
  XK_Hangul_SsangSios = $eb6;
  {$EXTERNALSYM XK_Hangul_SsangSios}
  XK_Hangul_Ieung = $eb7;
  {$EXTERNALSYM XK_Hangul_Ieung}
  XK_Hangul_Jieuj = $eb8;
  {$EXTERNALSYM XK_Hangul_Jieuj}
  XK_Hangul_SsangJieuj = $eb9;
  {$EXTERNALSYM XK_Hangul_SsangJieuj}
  XK_Hangul_Cieuc = $eba;
  {$EXTERNALSYM XK_Hangul_Cieuc}
  XK_Hangul_Khieuq = $ebb;
  {$EXTERNALSYM XK_Hangul_Khieuq}
  XK_Hangul_Tieut = $ebc;
  {$EXTERNALSYM XK_Hangul_Tieut}
  XK_Hangul_Phieuf = $ebd;
  {$EXTERNALSYM XK_Hangul_Phieuf}
  XK_Hangul_Hieuh = $ebe;
  {$EXTERNALSYM XK_Hangul_Hieuh}
{ Hangul Vowel Characters  }
  XK_Hangul_A = $ebf;
  {$EXTERNALSYM XK_Hangul_A}
  XK_Hangul_AE = $ec0;
  {$EXTERNALSYM XK_Hangul_AE}
  XK_Hangul_YA = $ec1;
  {$EXTERNALSYM XK_Hangul_YA}
  XK_Hangul_YAE = $ec2;
  {$EXTERNALSYM XK_Hangul_YAE}
  XK_Hangul_EO = $ec3;
  {$EXTERNALSYM XK_Hangul_EO}
  XK_Hangul_E = $ec4;
  {$EXTERNALSYM XK_Hangul_E}
  XK_Hangul_YEO = $ec5;
  {$EXTERNALSYM XK_Hangul_YEO}
  XK_Hangul_YE = $ec6;
  {$EXTERNALSYM XK_Hangul_YE}
  XK_Hangul_O = $ec7;
  {$EXTERNALSYM XK_Hangul_O}
  XK_Hangul_WA = $ec8;
  {$EXTERNALSYM XK_Hangul_WA}
  XK_Hangul_WAE = $ec9;
  {$EXTERNALSYM XK_Hangul_WAE}
  XK_Hangul_OE = $eca;
  {$EXTERNALSYM XK_Hangul_OE}
  XK_Hangul_YO = $ecb;
  {$EXTERNALSYM XK_Hangul_YO}
  XK_Hangul_U = $ecc;
  {$EXTERNALSYM XK_Hangul_U}
  XK_Hangul_WEO = $ecd;
  {$EXTERNALSYM XK_Hangul_WEO}
  XK_Hangul_WE = $ece;
  {$EXTERNALSYM XK_Hangul_WE}
  XK_Hangul_WI = $ecf;
  {$EXTERNALSYM XK_Hangul_WI}
  XK_Hangul_YU = $ed0;
  {$EXTERNALSYM XK_Hangul_YU}
  XK_Hangul_EU = $ed1;
  {$EXTERNALSYM XK_Hangul_EU}
  XK_Hangul_YI = $ed2;
  {$EXTERNALSYM XK_Hangul_YI}
  XK_Hangul_I = $ed3;
  {$EXTERNALSYM XK_Hangul_I}
{ Hangul syllable-final (JongSeong) Characters  }
  XK_Hangul_J_Kiyeog = $ed4;
  {$EXTERNALSYM XK_Hangul_J_Kiyeog}
  XK_Hangul_J_SsangKiyeog = $ed5;
  {$EXTERNALSYM XK_Hangul_J_SsangKiyeog}
  XK_Hangul_J_KiyeogSios = $ed6;
  {$EXTERNALSYM XK_Hangul_J_KiyeogSios}
  XK_Hangul_J_Nieun = $ed7;
  {$EXTERNALSYM XK_Hangul_J_Nieun}
  XK_Hangul_J_NieunJieuj = $ed8;
  {$EXTERNALSYM XK_Hangul_J_NieunJieuj}
  XK_Hangul_J_NieunHieuh = $ed9;
  {$EXTERNALSYM XK_Hangul_J_NieunHieuh}
  XK_Hangul_J_Dikeud = $eda;
  {$EXTERNALSYM XK_Hangul_J_Dikeud}
  XK_Hangul_J_Rieul = $edb;
  {$EXTERNALSYM XK_Hangul_J_Rieul}
  XK_Hangul_J_RieulKiyeog = $edc;
  {$EXTERNALSYM XK_Hangul_J_RieulKiyeog}
  XK_Hangul_J_RieulMieum = $edd;
  {$EXTERNALSYM XK_Hangul_J_RieulMieum}
  XK_Hangul_J_RieulPieub = $ede;
  {$EXTERNALSYM XK_Hangul_J_RieulPieub}
  XK_Hangul_J_RieulSios = $edf;
  {$EXTERNALSYM XK_Hangul_J_RieulSios}
  XK_Hangul_J_RieulTieut = $ee0;
  {$EXTERNALSYM XK_Hangul_J_RieulTieut}
  XK_Hangul_J_RieulPhieuf = $ee1;
  {$EXTERNALSYM XK_Hangul_J_RieulPhieuf}
  XK_Hangul_J_RieulHieuh = $ee2;
  {$EXTERNALSYM XK_Hangul_J_RieulHieuh}
  XK_Hangul_J_Mieum = $ee3;
  {$EXTERNALSYM XK_Hangul_J_Mieum}
  XK_Hangul_J_Pieub = $ee4;
  {$EXTERNALSYM XK_Hangul_J_Pieub}
  XK_Hangul_J_PieubSios = $ee5;
  {$EXTERNALSYM XK_Hangul_J_PieubSios}
  XK_Hangul_J_Sios = $ee6;
  {$EXTERNALSYM XK_Hangul_J_Sios}
  XK_Hangul_J_SsangSios = $ee7;
  {$EXTERNALSYM XK_Hangul_J_SsangSios}
  XK_Hangul_J_Ieung = $ee8;
  {$EXTERNALSYM XK_Hangul_J_Ieung}
  XK_Hangul_J_Jieuj = $ee9;
  {$EXTERNALSYM XK_Hangul_J_Jieuj}
  XK_Hangul_J_Cieuc = $eea;
  {$EXTERNALSYM XK_Hangul_J_Cieuc}
  XK_Hangul_J_Khieuq = $eeb;
  {$EXTERNALSYM XK_Hangul_J_Khieuq}
  XK_Hangul_J_Tieut = $eec;
  {$EXTERNALSYM XK_Hangul_J_Tieut}
  XK_Hangul_J_Phieuf = $eed;
  {$EXTERNALSYM XK_Hangul_J_Phieuf}
  XK_Hangul_J_Hieuh = $eee;
  {$EXTERNALSYM XK_Hangul_J_Hieuh}
{ Ancient Hangul Consonant Characters  }
  XK_Hangul_RieulYeorinHieuh = $eef;
  {$EXTERNALSYM XK_Hangul_RieulYeorinHieuh}
  XK_Hangul_SunkyeongeumMieum = $ef0;
  {$EXTERNALSYM XK_Hangul_SunkyeongeumMieum}
  XK_Hangul_SunkyeongeumPieub = $ef1;
  {$EXTERNALSYM XK_Hangul_SunkyeongeumPieub}
  XK_Hangul_PanSios = $ef2;
  {$EXTERNALSYM XK_Hangul_PanSios}
  XK_Hangul_KkogjiDalrinIeung = $ef3;
  {$EXTERNALSYM XK_Hangul_KkogjiDalrinIeung}
  XK_Hangul_SunkyeongeumPhieuf = $ef4;
  {$EXTERNALSYM XK_Hangul_SunkyeongeumPhieuf}
  XK_Hangul_YeorinHieuh = $ef5;
  {$EXTERNALSYM XK_Hangul_YeorinHieuh}
{ Ancient Hangul Vowel Characters  }
  XK_Hangul_AraeA = $ef6;
  {$EXTERNALSYM XK_Hangul_AraeA}
  XK_Hangul_AraeAE = $ef7;
  {$EXTERNALSYM XK_Hangul_AraeAE}
{ Ancient Hangul syllable-final (JongSeong) Characters  }
  XK_Hangul_J_PanSios = $ef8;
  {$EXTERNALSYM XK_Hangul_J_PanSios}
  XK_Hangul_J_KkogjiDalrinIeung = $ef9;
  {$EXTERNALSYM XK_Hangul_J_KkogjiDalrinIeung}
  XK_Hangul_J_YeorinHieuh = $efa;
  {$EXTERNALSYM XK_Hangul_J_YeorinHieuh}
{ Korean currency symbol  }
  XK_Korean_Won = $eff;
  {$EXTERNALSYM XK_Korean_Won}

const
  XK_EcuSign = $20a0;
  {$EXTERNALSYM XK_EcuSign}
  XK_ColonSign = $20a1;
  {$EXTERNALSYM XK_ColonSign}
  XK_CruzeiroSign = $20a2;
  {$EXTERNALSYM XK_CruzeiroSign}
  XK_FFrancSign = $20a3;
  {$EXTERNALSYM XK_FFrancSign}
  XK_LiraSign = $20a4;
  {$EXTERNALSYM XK_LiraSign}
  XK_MillSign = $20a5;
  {$EXTERNALSYM XK_MillSign}
  XK_NairaSign = $20a6;
  {$EXTERNALSYM XK_NairaSign}
  XK_PesetaSign = $20a7;
  {$EXTERNALSYM XK_PesetaSign}
  XK_RupeeSign = $20a8;
  {$EXTERNALSYM XK_RupeeSign}
  XK_WonSign = $20a9;
  {$EXTERNALSYM XK_WonSign}
  XK_NewSheqelSign = $20aa;
  {$EXTERNALSYM XK_NewSheqelSign}
  XK_DongSign = $20ab;
  {$EXTERNALSYM XK_DongSign}
  XK_EuroSign = $20ac;
  {$EXTERNALSYM XK_EuroSign}

  { XUtil.h }

{ Bitmask returned by XParseGeometry().  Each bit tells if the corresponding
  value (x, y, width, height) was found in the parsed string. }

const
  NoValue = $0000;
  {$EXTERNALSYM NoValue}
  XValue = $0001;
  {$EXTERNALSYM XValue}
  YValue = $0002;
  {$EXTERNALSYM YValue}
  WidthValue = $0004;
  {$EXTERNALSYM WidthValue}
  HeightValue = $0008;
  {$EXTERNALSYM HeightValue}
  AllValues = $000F;
  {$EXTERNALSYM AllValues}
  XNegative = $0010;
  {$EXTERNALSYM XNegative}
  YNegative = $0020;
  {$EXTERNALSYM YNegative}

{ new version containing base_width, base_height, and win_gravity fields;
  used with WM_NORMAL_HINTS. }

type
  PXSizeHints = ^XSizeHints;
  {$EXTERNALSYM PXSizeHints}
  XSizeHints = record
    flags: Longint; { marks which fields in this structure are defined  }
    x: Longint;     { obsolete for new window mgrs, but clients  }
    y: Longint;     { should set so old wm's don't mess up  }
    width: Longint;
    height: Longint;
    min_width: Longint;
    min_height: Longint;
    max_width: Longint;
    max_height: Longint;
    width_inc: Longint;
    height_inc: Longint;
    min_aspect: record
         x: Longint;      { numerator  }
         y: Longint;     { denominator  }
      end;
    max_aspect: record
         x: Longint;
         y: Longint;
      end;
    base_width: Longint;   { added by ICCCM version 1  }
    base_height: Longint;
    win_gravity: Longint;  { added by ICCCM version 1  }
   end;
   {$EXTERNALSYM XSizeHints}

{ The next block of definitions are for window manager properties that
     clients and applications use for communication. }

{ flags argument in size hints  }
const
  { user specified x, y  }
  USPosition = 1 shl 0;
  {$EXTERNALSYM USPosition}
  { user specified width, height  }
  USSize = 1 shl 1;
  {$EXTERNALSYM USSize}
  { program specified position  }
  PPosition = 1 shl 2;
  {$EXTERNALSYM PPosition}
  { program specified size  }
  PSize = 1 shl 3;
  {$EXTERNALSYM PSize}
  { program specified minimum size  }
  PMinSize = 1 shl 4;
  {$EXTERNALSYM PMinSize}
  { program specified maximum size  }
  PMaxSize = 1 shl 5;
  {$EXTERNALSYM PMaxSize}
  { program specified resize increments  }
  PResizeInc = 1 shl 6;
  {$EXTERNALSYM PResizeInc}
  { program specified min and max aspect ratios  }
  PAspect = 1 shl 7;
  {$EXTERNALSYM PAspect}
  { program specified base for incrementing  }
  PBaseSize = 1 shl 8;
  {$EXTERNALSYM PBaseSize}
  { program specified window gravity  }
  PWinGravity = 1 shl 9;
  {$EXTERNALSYM PWinGravity}
  { obsolete  }
  PAllHints = ((((PPosition or PSize) or PMinSize) or PMaxSize) or PResizeInc) or PAspect;
  {$EXTERNALSYM PAllHints}

type
  PXWMHints = ^XWMHints;
  {$EXTERNALSYM PXWMHints}
  XWMHints = record
    flags: Longint;  { marks which fields in this structure are defined  }
    input: Bool;     { does this application rely on the window manager to get keyboard input?  }
    initial_state: Longint;  { see below  }
    icon_pixmap: TPixmap;     { pixmap to be used as icon  }
    icon_window: TWindow;     { window to be used as icon  }
    icon_x: Longint;         { initial position of icon  }
    icon_y: Longint;
    icon_mask: TPixmap;       { icon mask bitmap  }
    window_group: XID;       { id of related window group }
    { this structure may be extended in the future  }
  end;
  {$EXTERNALSYM XWMHints}

{ definition for flags of XWMHints  }
const
  InputHint = 1 shl 0;
  {$EXTERNALSYM InputHint}
  StateHint = 1 shl 1;
  {$EXTERNALSYM StateHint}
  IconPixmapHint = 1 shl 2;
  {$EXTERNALSYM IconPixmapHint}
  IconWindowHint = 1 shl 3;
  {$EXTERNALSYM IconWindowHint}
  IconPositionHint = 1 shl 4;
  {$EXTERNALSYM IconPositionHint}
  IconMaskHint = 1 shl 5;
  {$EXTERNALSYM IconMaskHint}
  WindowGroupHint = 1 shl 6;
  {$EXTERNALSYM WindowGroupHint}
  AllHints = (((((InputHint or StateHint) or IconPixmapHint) or IconWindowHint)
    or IconPositionHint) or IconMaskHint) or WindowGroupHint;
  {$EXTERNALSYM AllHints}
  XUrgencyHint = 1 shl 8;
  {$EXTERNALSYM XUrgencyHint}
{ definitions for initial window state  }
{ for windows that are not mapped  }
  WithdrawnState = 0;
  {$EXTERNALSYM WithdrawnState}
{ most applications want to start this way  }
  NormalState = 1;
  {$EXTERNALSYM NormalState}
{ application wants to start as an icon  }
  IconicState = 3;
  {$EXTERNALSYM IconicState}
{ Obsolete states no longer defined by ICCCM }
{ don't know or care  }
  DontCareState = 0;
  {$EXTERNALSYM DontCareState}
{ application wants to start zoomed  }
  ZoomState = 2;
  {$EXTERNALSYM ZoomState}
{ application believes it is seldom used;  }
  InactiveState = 4;
  {$EXTERNALSYM InactiveState}
{ some wm's may put it on inactive menu  }

{ New structure for manipulating TEXT properties; used with WM_NAME,
     WM_ICON_NAME, WM_CLIENT_MACHINE, and WM_COMMAND. }

type
  PXTextProperty = ^XTextProperty;
  {$EXTERNALSYM PXTextProperty}
  XTextProperty = record
    value: PByte;     { same as Property routines  }
    encoding: TAtom;   { prop type  }
    format: Longint;  { prop data format: 8, 16, or 32  }
    nitems: Cardinal; { number of data items in value  }
  end;
  {$EXTERNALSYM XTextProperty}

const
  XNoMemory = -(1);
  {$EXTERNALSYM XNoMemory}
  XLocaleNotSupported = -(2);
  {$EXTERNALSYM XLocaleNotSupported}
  XConverterNotFound = -(3);
  {$EXTERNALSYM XConverterNotFound}

type
  PXICCEncodingStyle = ^XICCEncodingStyle;
  {$EXTERNALSYM PXICCEncodingStyle}
  XICCEncodingStyle = (XStringStyle,  { STRING  }
    XCompoundTextStyle,               { COMPOUND_TEXT  }
    XTextStyle,       { text in owner's encoding (current locale) }
    XStdICCTextStyle);                { STRING, else COMPOUND_TEXT  }
  {$EXTERNALSYM XICCEncodingStyle}

  PXIconSize = ^XIconSize;
  {$EXTERNALSYM PXIconSize}
  XIconSize = record
    min_width: Longint;
    min_height: Longint;
    max_width: Longint;
    max_height: Longint;
    width_inc: Longint;
    height_inc: Longint;
  end;
  {$EXTERNALSYM XIconSize}
  PPXIconSize = ^PXIconSize;
  {$EXTERNALSYM PPXIconSize}
  
  PXClassHint = ^XClassHint;
  {$EXTERNALSYM PXClassHint}
  XClassHint = record
    res_name: PChar;
    res_class: PChar;
  end;
  {$EXTERNALSYM XClassHint}

  PXComposeStatus = ^XComposeStatus;
  {$EXTERNALSYM PXComposeStatus}
  XComposeStatus = record
    compose_ptr: XPointer;
    chars_matched: Longint;
  end;
  {$EXTERNALSYM XComposeStatus}

{ opaque reference to Region data type }
type
  Region = ^_XRegion;
  {$EXTERNALSYM Region}
  _XRegion = record
  end;
  {$EXTERNALSYM _XRegion}

  { Return values from XRectInRegion()  }

const
  RectangleOut = 0;
  {$EXTERNALSYM RectangleOut}
  RectangleIn = 1;
  {$EXTERNALSYM RectangleIn}
  RectanglePart = 2;
  {$EXTERNALSYM RectanglePart}

{ Information used by the visual utility routines to find desired visual
       type from the many visuals a display may support. }

type
  PXVisualInfo = ^XVisualInfo;
  {$EXTERNALSYM PXVisualInfo}
  XVisualInfo = record
    visual: PVisual;
    visualid: VisualID;
    screen: Longint;
    depth: Longint;
    c_class: Longint;
    red_mask: Cardinal;
    green_mask: Cardinal;
    blue_mask: Cardinal;
    colormap_size: Longint;
    bits_per_rgb: Longint;
  end;
  {$EXTERNALSYM XVisualInfo}

const
  VisualNoMask = $0;
  {$EXTERNALSYM VisualNoMask}
  VisualIDMask = $1;
  {$EXTERNALSYM VisualIDMask}
  VisualScreenMask = $2;
  {$EXTERNALSYM VisualScreenMask}
  VisualDepthMask = $4;
  {$EXTERNALSYM VisualDepthMask}
  VisualClassMask = $8;
  {$EXTERNALSYM VisualClassMask}
  VisualRedMaskMask = $10;
  {$EXTERNALSYM VisualRedMaskMask}
  VisualGreenMaskMask = $20;
  {$EXTERNALSYM VisualGreenMaskMask}
  VisualBlueMaskMask = $40;
  {$EXTERNALSYM VisualBlueMaskMask}
  VisualColormapSizeMask = $80;
  {$EXTERNALSYM VisualColormapSizeMask}
  VisualBitsPerRGBMask = $100;
  {$EXTERNALSYM VisualBitsPerRGBMask}
  VisualAllMask = $1FF;
  {$EXTERNALSYM VisualAllMask}

{ This defines a window manager property that clients may use to
       share standard color maps of type RGB_COLOR_MAP:}
    { added by ICCCM version 1  }
    { added by ICCCM version 1  }

type
  PXStandardColormap = ^XStandardColormap;
  {$EXTERNALSYM PXStandardColormap}
  XStandardColormap = record
    colormap: TColormap;
    red_max: Cardinal;
    red_mult: Cardinal;
    green_max: Cardinal;
    green_mult: Cardinal;
    blue_max: Cardinal;
    blue_mult: Cardinal;
    base_pixel: Cardinal;
    visualid: VisualID;
    killid: XID;
  end;
  PPXStandardColormap = ^PXStandardColormap;
  {$EXTERNALSYM PPXStandardColormap}
  {$EXTERNALSYM XStandardColormap}

{ return codes for XReadBitmapFile and XWriteBitmapFile }

const
  BitmapSuccess = 0;
  {$EXTERNALSYM BitmapSuccess}
  BitmapOpenFailed = 1;
  {$EXTERNALSYM BitmapOpenFailed}
  BitmapFileInvalid = 2;
  {$EXTERNALSYM BitmapFileInvalid}
  BitmapNoMemory = 3;
  {$EXTERNALSYM BitmapNoMemory}

{ Context Management }
  { Associative lookup table return codes  }
  { No error.  }
  XCSUCCESS = 0;
  {$EXTERNALSYM XCSUCCESS}
  { Out of memory  }
  XCNOMEM = 1;
  {$EXTERNALSYM XCNOMEM}
  { No entry in table  }
  XCNOENT = 2;
  {$EXTERNALSYM XCNOENT}

type
  XContext = Longint;
  {$EXTERNALSYM XContext}

{ The following declarations are alphabetized.  }


function XAllocClassHint: PXClassHint; cdecl;
{$EXTERNALSYM XAllocClassHint}
function XAllocIconSize: PXIconSize; cdecl;
{$EXTERNALSYM XAllocIconSize}
function XAllocSizeHints: PXSizeHints; cdecl;
{$EXTERNALSYM XAllocSizeHints}
function XAllocStandardColormap: PXStandardColormap; cdecl;
{$EXTERNALSYM XAllocStandardColormap}
function XAllocWMHints: PXWMHints; cdecl;
{$EXTERNALSYM XAllocWMHints}
function XClipBox(R: Region; RectReturn: PXRectangle): Longint; cdecl;
{$EXTERNALSYM XClipBox}
function XCreateRegion: Region; cdecl;
{$EXTERNALSYM XCreateRegion}
function XDefaultString: PChar; cdecl;
{$EXTERNALSYM XDefaultString}
function XDeleteContext(Display: PDisplay; Rid: XID; Context: XContext): Longint; cdecl;
{$EXTERNALSYM XDeleteContext}
function XDestroyRegion(R: Region): Longint; cdecl;
{$EXTERNALSYM XDestroyRegion}
function XEmptyRegion(R: Region): Longint; cdecl;
{$EXTERNALSYM XEmptyRegion}
function XEqualRegion(R1: Region; R2: Region): Longint; cdecl;
{$EXTERNALSYM XEqualRegion}
function XFindContext(Display: PDisplay; Rid: XID; Context: XContext; DataReturn: PXPointer): Longint; cdecl;
{$EXTERNALSYM XFindContext}
function XGetClassHint(Display: PDisplay; W: TWindow; ClassHintsReturn: PXClassHint): TStatus; cdecl;
{$EXTERNALSYM XGetClassHint}
function XGetIconSizes(Display: PDisplay; W: TWindow; SizeListReturn: PPXIconSize; CountReturn: PLongint): TStatus; cdecl;
{$EXTERNALSYM XGetIconSizes}
function XGetNormalHints(Display: PDisplay; W: TWindow; HintsReturn: PXSizeHints): TStatus; cdecl;
{$EXTERNALSYM XGetNormalHints}
function XGetRGBColormaps(Display: PDisplay; W: TWindow; StdCMapReturn: PPXStandardColormap; CountReturn: PLongint; AProperty: TAtom): TStatus; cdecl;
{$EXTERNALSYM XGetRGBColormaps}
function XGetSizeHints(Display: PDisplay; W: TWindow; HintsReturn: PXSizeHints; AProperty: TAtom): TStatus; cdecl;
{$EXTERNALSYM XGetSizeHints}
function XGetStandardColormap(Display: PDisplay; W: TWindow; ColorMapReturn: PXStandardColormap; AProperty: TAtom): TStatus; cdecl;
{$EXTERNALSYM XGetStandardColormap}
function XGetTextProperty(Display: PDisplay; W: TWindow; TextPropReturn: PXTextProperty; AProperty: TAtom): TStatus; cdecl;
{$EXTERNALSYM XGetTextProperty}
function XGetVisualInfo(Display: PDisplay; VInfoMask: Longint; VInfoTemplate: PXVisualInfo; NItemReturn: PLongint): PXVisualInfo; cdecl;
{$EXTERNALSYM XGetVisualInfo}
function XGetWMClientMachine(Display: PDisplay; W: TWindow; TextPropReturn: PXTextProperty): TStatus; cdecl;
{$EXTERNALSYM XGetWMClientMachine}
function XGetWMHints(Display: PDisplay; W: TWindow): PXWMHints; cdecl;
{$EXTERNALSYM XGetWMHints}
function XGetWMIconName(display: PDisplay; W: TWindow; TextPropReturn: PXTextProperty): TStatus; cdecl;
{$EXTERNALSYM XGetWMIconName}
function XGetWMName(Display: PDisplay; W: TWindow; TextPropReturn: PXTextProperty): TStatus; cdecl;
{$EXTERNALSYM XGetWMName}
function XGetWMNormalHints(Display: PDisplay; W: TWindow; HintsReturn: PXSizeHints; SuppliedReturn: PLongint): TStatus; cdecl;
{$EXTERNALSYM XGetWMNormalHints}
function XGetWMSizeHints(Display: PDisplay; W: TWindow; HintsReturn: PXSizeHints; SuppliedReturn: PLongint; AProperty: TAtom): TStatus; cdecl;
{$EXTERNALSYM XGetWMSizeHints}
function XGetZoomHints(Display: PDisplay; W: TWindow; ZHintsReturn: PXSizeHints): TStatus; cdecl;
{$EXTERNALSYM XGetZoomHints}
function XIntersectRegion(SRA: Region; SRB: Region; DRReturn: Region): Longint; cdecl;
{$EXTERNALSYM XIntersectRegion}
procedure XConvertCase(Sym: TKeySym; Lower: PKeySym; Upper: PKeySym); cdecl;
{$EXTERNALSYM XConvertCase}
function XLookupString(EventStruct: PXKeyEvent; BufferReturn: PChar; BytesBuffer: Longint; KeySymReturn: PKeySym; StatusInOut: PXComposeStatus): Longint; cdecl;
{$EXTERNALSYM XLookupString}
function XMatchVisualInfo(Display: PDisplay; Screen: Longint; Depth: Longint; AClass: Longint; VInfoReturn: PXVisualInfo): TStatus; cdecl;
{$EXTERNALSYM XMatchVisualInfo}
function XOffsetRegion(R: Region; DX: Longint; DY: Longint): Longint; cdecl;
{$EXTERNALSYM XOffsetRegion}
function XPointInRegion(R: Region; X: Longint; Y: Longint): Bool; cdecl;
{$EXTERNALSYM XPointInRegion}
function XPolygonRegion(Points: PXPoint; N: Longint; FillRule: Longint): Region; cdecl;
{$EXTERNALSYM XPolygonRegion}
function XRectInRegion(R: Region; X: Longint; Y: Longint; Width: Cardinal; Height: Cardinal): Longint; cdecl;
{$EXTERNALSYM XRectInRegion}
function XSetClassHint(Display: PDisplay; W: TWindow; ClassHints: PXClassHint): Longint; cdecl;
{$EXTERNALSYM XSetClassHint}
function XSetIconSizes(Display: PDisplay; W: TWindow; SizeList: PXIconSize; Count: Longint): Longint; cdecl;
{$EXTERNALSYM XSetIconSizes}
function XSetNormalHints(Display: PDisplay; W: TWindow; Hints: PXSizeHints): Longint; cdecl;
{$EXTERNALSYM XSetNormalHints}
procedure XSetRGBColormaps(Display: PDisplay; W: TWindow; StdCMaps: PXStandardColormap; Count: Longint; AProperty: TAtom); cdecl;
{$EXTERNALSYM XSetRGBColormaps}
function XSetSizeHints(Display: PDisplay; W: TWindow; Hints: PXSizeHints; AProperty: TAtom): Longint; cdecl;
{$EXTERNALSYM XSetSizeHints}
procedure XSetTextProperty(Display: PDisplay; W: TWindow; TextProp: PXTextProperty; AProperty: TAtom); cdecl;
{$EXTERNALSYM XSetTextProperty}
procedure XSetWMClientMachine(Display: PDisplay; W: TWindow; TextProp: PXTextProperty); cdecl;
{$EXTERNALSYM XSetWMClientMachine}
function XSetWMHints(Display: PDisplay; W: TWindow; WMHints: PXWMHints): Longint; cdecl;
{$EXTERNALSYM XSetWMHints}
procedure XSetWMIconName(Display: PDisplay; W: TWindow; TextProp: PXTextProperty); cdecl;
{$EXTERNALSYM XSetWMIconName}
procedure XSetWMName(Display: PDisplay; W: TWindow; TextProp: PXTextProperty); cdecl;
{$EXTERNALSYM XSetWMName}
procedure XSetWMNormalHints(Display: PDisplay; W: TWindow; Hints: PXSizeHints); cdecl;
{$EXTERNALSYM XSetWMNormalHints}
procedure XSetWMProperties(Display: PDisplay; W: TWindow; WindowName: PXTextProperty; IconName: PXTextProperty; ArgV: ppchar;
            ArgC: Longint; NormalHints: PXSizeHints; WMHints: PXWMHints; ClassHints: PXClassHint); cdecl;
{$EXTERNALSYM XSetWMProperties}
procedure XSetWMSizeHints(Display: PDisplay; W: TWindow; Hints: PXSizeHints; AProperty: TAtom); cdecl;
{$EXTERNALSYM XSetWMSizeHints}
function XSetRegion(Display: PDisplay; GC: TGC; R: Region): Longint; cdecl;
{$EXTERNALSYM XSetRegion}
procedure XSetStandardColormap(Display: PDisplay; W: TWindow; ColorMap: PXStandardColormap; AProperty: TAtom); cdecl;
{$EXTERNALSYM XSetStandardColormap}
function XSetZoomHints(Display: PDisplay; W: TWindow; ZHints: PXSizeHints): Longint; cdecl;
{$EXTERNALSYM XSetZoomHints}
function XShrinkRegion(R: Region; DX: Longint; DY: Longint): Longint; cdecl;
{$EXTERNALSYM XShrinkRegion}
function XStringListToTextProperty(List: ppchar; Count: Longint; TextPropertyReturn: PXTextProperty): TStatus; cdecl;
{$EXTERNALSYM XStringListToTextProperty}
function XSubtractRegion(SRA: Region; SRB: Region; DRReturn: Region): Longint; cdecl;
{$EXTERNALSYM XSubtractRegion}
function XmbTextListToTextProperty(Display: PDisplay; List: ppchar; Count: Longint; Style: XICCEncodingStyle; TextPropReturn: PXTextProperty): Longint; cdecl;
{$EXTERNALSYM XmbTextListToTextProperty}
function XwcTextListToTextProperty(Display: PDisplay; List: ppwchar_t; Count: Longint; Style: XICCEncodingStyle; TextPropReturn: PXTextProperty): Longint; cdecl;
{$EXTERNALSYM XwcTextListToTextProperty}
procedure XwcFreeStringList(List: ppwchar_t); cdecl;
{$EXTERNALSYM XwcFreeStringList}
function XTextPropertyToStringList(TextProp: PXTextProperty; ListReturn: pppchar; CountReturn: PLongint): TStatus; cdecl;
{$EXTERNALSYM XTextPropertyToStringList}
function XmbTextPropertyToTextList(Display: PDisplay; TextProp: PXTextProperty; ListReturn: pppchar; CountReturn: pLongint): Longint; cdecl;
{$EXTERNALSYM XmbTextPropertyToTextList}
function XwcTextPropertyToTextList(Display: PDisplay; TextProp: PXTextProperty; ListReturn: pppwchar_t; CountReturn: pLongint): Longint; cdecl;
{$EXTERNALSYM XwcTextPropertyToTextList}
function XUnionRectWithRegion(Rectangle: PXRectangle; SrcRegion: Region; DestRegionReturn: Region): Longint; cdecl;
{$EXTERNALSYM XUnionRectWithRegion}
function XUnionRegion(SRA: Region; SRB: Region; DRReturn: Region): Longint; cdecl;
{$EXTERNALSYM XUnionRegion}
function XXorRegion(SRA: Region; SRB: Region; DRReturn: Region): Longint; cdecl;
{$EXTERNALSYM XXorRegion}

{ Xatom.h }

const
  XA_PRIMARY = Atom(1);
  {$EXTERNALSYM XA_PRIMARY}
  XA_SECONDARY = Atom(2);
  {$EXTERNALSYM XA_SECONDARY}
  XA_ARC = Atom(3);
  {$EXTERNALSYM XA_ARC}
  XA_ATOM = Atom(4);
  {$EXTERNALSYM XA_ATOM}
  XA_BITMAP = Atom(5);
  {$EXTERNALSYM XA_BITMAP}
  XA_CARDINAL = Atom(6);
  {$EXTERNALSYM XA_CARDINAL}
  XA_COLORMAP = Atom(7);
  {$EXTERNALSYM XA_COLORMAP}
  XA_CURSOR = Atom(8);
  {$EXTERNALSYM XA_CURSOR}
  XA_CUT_BUFFER0 = Atom(9);
  {$EXTERNALSYM XA_CUT_BUFFER0}
  XA_CUT_BUFFER1 = Atom(10);
  {$EXTERNALSYM XA_CUT_BUFFER1}
  XA_CUT_BUFFER2 = Atom(11);
  {$EXTERNALSYM XA_CUT_BUFFER2}
  XA_CUT_BUFFER3 = Atom(12);
  {$EXTERNALSYM XA_CUT_BUFFER3}
  XA_CUT_BUFFER4 = Atom(13);
  {$EXTERNALSYM XA_CUT_BUFFER4}
  XA_CUT_BUFFER5 = Atom(14);
  {$EXTERNALSYM XA_CUT_BUFFER5}
  XA_CUT_BUFFER6 = Atom(15);
  {$EXTERNALSYM XA_CUT_BUFFER6}
  XA_CUT_BUFFER7 = Atom(16);
  {$EXTERNALSYM XA_CUT_BUFFER7}
  XA_DRAWABLE = Atom(17);
  {$EXTERNALSYM XA_DRAWABLE}
  XA_FONT = Atom(18);
  {$EXTERNALSYM XA_FONT}
  XA_INTEGER = Atom(19);
  {$EXTERNALSYM XA_INTEGER}
  XA_PIXMAP = Atom(20);
  {$EXTERNALSYM XA_PIXMAP}
  XA_POINT = Atom(21);
  {$EXTERNALSYM XA_POINT}
  XA_RECTANGLE = Atom(22);
  {$EXTERNALSYM XA_RECTANGLE}
  XA_RESOURCE_MANAGER = Atom(23);
  {$EXTERNALSYM XA_RESOURCE_MANAGER}
  XA_RGB_COLOR_MAP = Atom(24);
  {$EXTERNALSYM XA_RGB_COLOR_MAP}
  XA_RGB_BEST_MAP = Atom(25);
  {$EXTERNALSYM XA_RGB_BEST_MAP}
  XA_RGB_BLUE_MAP = Atom(26);
  {$EXTERNALSYM XA_RGB_BLUE_MAP}
  XA_RGB_DEFAULT_MAP = Atom(27);
  {$EXTERNALSYM XA_RGB_DEFAULT_MAP}
  XA_RGB_GRAY_MAP = Atom(28);
  {$EXTERNALSYM XA_RGB_GRAY_MAP}
  XA_RGB_GREEN_MAP = Atom(29);
  {$EXTERNALSYM XA_RGB_GREEN_MAP}
  XA_RGB_RED_MAP = Atom(30);
  {$EXTERNALSYM XA_RGB_RED_MAP}
  XA_STRING = Atom(31);
  {$EXTERNALSYM XA_STRING}
  XA_VISUALID = Atom(32);
  {$EXTERNALSYM XA_VISUALID}
  XA_WINDOW = Atom(33);
  {$EXTERNALSYM XA_WINDOW}
  XA_WM_COMMAND = Atom(34);
  {$EXTERNALSYM XA_WM_COMMAND}
  XA_WM_HINTS = Atom(35);
  {$EXTERNALSYM XA_WM_HINTS}
  XA_WM_CLIENT_MACHINE = Atom(36);
  {$EXTERNALSYM XA_WM_CLIENT_MACHINE}
  XA_WM_ICON_NAME = Atom(37);
  {$EXTERNALSYM XA_WM_ICON_NAME}
  XA_WM_ICON_SIZE = Atom(38);
  {$EXTERNALSYM XA_WM_ICON_SIZE}
  XA_WM_NAME = Atom(39);
  {$EXTERNALSYM XA_WM_NAME}
  XA_WM_NORMAL_HINTS = Atom(40);
  {$EXTERNALSYM XA_WM_NORMAL_HINTS}
  XA_WM_SIZE_HINTS = Atom(41);
  {$EXTERNALSYM XA_WM_SIZE_HINTS}
  XA_WM_ZOOM_HINTS = Atom(42);
  {$EXTERNALSYM XA_WM_ZOOM_HINTS}
  XA_MIN_SPACE = Atom(43);
  {$EXTERNALSYM XA_MIN_SPACE}
  XA_NORM_SPACE = Atom(44);
  {$EXTERNALSYM XA_NORM_SPACE}
  XA_MAX_SPACE = Atom(45);
  {$EXTERNALSYM XA_MAX_SPACE}
  XA_END_SPACE = Atom(46);
  {$EXTERNALSYM XA_END_SPACE}
  XA_SUPERSCRIPT_X = Atom(47);
  {$EXTERNALSYM XA_SUPERSCRIPT_X}
  XA_SUPERSCRIPT_Y = Atom(48);
  {$EXTERNALSYM XA_SUPERSCRIPT_Y}
  XA_SUBSCRIPT_X = Atom(49);
  {$EXTERNALSYM XA_SUBSCRIPT_X}
  XA_SUBSCRIPT_Y = Atom(50);
  {$EXTERNALSYM XA_SUBSCRIPT_Y}
  XA_UNDERLINE_POSITION = Atom(51);
  {$EXTERNALSYM XA_UNDERLINE_POSITION}
  XA_UNDERLINE_THICKNESS = Atom(52);
  {$EXTERNALSYM XA_UNDERLINE_THICKNESS}
  XA_STRIKEOUT_ASCENT = Atom(53);
  {$EXTERNALSYM XA_STRIKEOUT_ASCENT}
  XA_STRIKEOUT_DESCENT = Atom(54);
  {$EXTERNALSYM XA_STRIKEOUT_DESCENT}
  XA_ITALIC_ANGLE = Atom(55);
  {$EXTERNALSYM XA_ITALIC_ANGLE}
  XA_X_HEIGHT = Atom(56);
  {$EXTERNALSYM XA_X_HEIGHT}
  XA_QUAD_WIDTH = Atom(57);
  {$EXTERNALSYM XA_QUAD_WIDTH}
  XA_WEIGHT = Atom(58);
  {$EXTERNALSYM XA_WEIGHT}
  XA_POINT_SIZE = Atom(59);
  {$EXTERNALSYM XA_POINT_SIZE}
  XA_RESOLUTION = Atom(60);
  {$EXTERNALSYM XA_RESOLUTION}
  XA_COPYRIGHT = Atom(61);
  {$EXTERNALSYM XA_COPYRIGHT}
  XA_NOTICE = Atom(62);
  {$EXTERNALSYM XA_NOTICE}
  XA_FONT_NAME = Atom(63);
  {$EXTERNALSYM XA_FONT_NAME}
  XA_FAMILY_NAME = Atom(64);
  {$EXTERNALSYM XA_FAMILY_NAME}
  XA_FULL_NAME = Atom(65);
  {$EXTERNALSYM XA_FULL_NAME}
  XA_CAP_HEIGHT = Atom(66);
  {$EXTERNALSYM XA_CAP_HEIGHT}
  XA_WM_CLASS = Atom(67);
  {$EXTERNALSYM XA_WM_CLASS}
  XA_WM_TRANSIENT_FOR = Atom(68);
  {$EXTERNALSYM XA_WM_TRANSIENT_FOR}

  XA_LAST_PREDEFINED = Atom(68);
  {$EXTERNALSYM XA_LAST_PREDEFINED}

const
  Xlibmodulename = 'libX11.so.6';

implementation

const
  sXlib = Xlibmodulename;

  function XAllocClassHint; external sXlib name 'XAllocClassHint';
  function XAllocIconSize; external sXlib name 'XAllocIconSize';
  function XAllocSizeHints; external sXlib name 'XAllocSizeHints';
  function XAllocStandardColormap; external sXlib name 'XAllocStandardColormap';
  function XAllocWMHints; external sXlib name 'XAllocWMHints';
  function XClipBox; external sXlib name 'XClipBox';
  function XCreateRegion; external sXlib name 'XCreateRegion';
  function XDefaultString; external sXlib name 'XDefaultString';
  function XDeleteContext; external sXlib name 'XDeleteContext';
  function XDestroyRegion; external sXlib name 'XDestroyRegion';
  function XEmptyRegion; external sXlib name 'XEmptyRegion';
  function XEqualRegion; external sXlib name 'XEqualRegion';
  function XFindContext; external sXlib name 'XFindContext';
  function XGetClassHint; external sXlib name 'XGetClassHint';
  function XGetIconSizes; external sXlib name 'XGetIconSizes';
  function XGetNormalHints; external sXlib name 'XGetNormalHints';
  function XGetRGBColormaps; external sXlib name 'XGetRGBColormaps';
  function XGetSizeHints; external sXlib name 'XGetSizeHints';
  function XGetStandardColormap; external sXlib name 'XGetStandardColormap';
  function XGetTextProperty; external sXlib name 'XGetTextProperty';
  function XGetVisualInfo; external sXlib name 'XGetVisualInfo';
  function XGetWMClientMachine; external sXlib name 'XGetWMClientMachine';
  function XGetWMHints; external sXlib name 'XGetWMHints';
  function XGetWMIconName; external sXlib name 'XGetWMIconName';
  function XGetWMName; external sXlib name 'XGetWMName';
  function XGetWMNormalHints; external sXlib name 'XGetWMNormalHints';
  function XGetWMSizeHints; external sXlib name 'XGetWMSizeHints';
  function XGetZoomHints; external sXlib name 'XGetZoomHints';
  function XIntersectRegion; external sXlib name 'XIntersectRegion';
  procedure XConvertCase; external sXlib name 'XConvertCase';
  function XLookupString; external sXlib name 'XLookupString';
  function XMatchVisualInfo; external sXlib name 'XMatchVisualInfo';
  function XOffsetRegion; external sXlib name 'XOffsetRegion';
  function XPointInRegion; external sXlib name 'XPointInRegion';
  function XPolygonRegion; external sXlib name 'XPolygonRegion';
  function XRectInRegion; external sXlib name 'XRectInRegion';
  function XSetClassHint; external sXlib name 'XSetClassHint';
  function XSetIconSizes; external sXlib name 'XSetIconSizes';
  function XSetNormalHints; external sXlib name 'XSetNormalHints';
  procedure XSetRGBColormaps; external sXlib name 'XSetRGBColormaps';
  function XSetSizeHints; external sXlib name 'XSetSizeHints';
  procedure XSetTextProperty; external sXlib name 'XSetTextProperty';
  procedure XSetWMClientMachine; external sXlib name 'XSetWMClientMachine';
  function XSetWMHints; external sXlib name 'XSetWMHints';
  procedure XSetWMIconName; external sXlib name 'XSetWMIconName';
  procedure XSetWMName; external sXlib name 'XSetWMName';
  procedure XSetWMNormalHints; external sXlib name 'XSetWMNormalHints';
  procedure XSetWMProperties; external sXlib name 'XSetWMProperties';
  procedure XSetWMSizeHints; external sXlib name 'XSetWMSizeHints';
  function XSetRegion; external sXlib name 'XSetRegion';
  procedure XSetStandardColormap; external sXlib name 'XSetStandardColormap';
  function XSetZoomHints; external sXlib name 'XSetZoomHints';
  function XShrinkRegion; external sXlib name 'XShrinkRegion';
  function XStringListToTextProperty; external sXlib name 'XStringListToTextProperty';
  function XSubtractRegion; external sXlib name 'XSubtractRegion';
  function XmbTextListToTextProperty; external sXlib name 'XmbTextListToTextProperty';
  function XwcTextListToTextProperty; external sXlib name 'XwcTextListToTextProperty';
  procedure XwcFreeStringList; external sXlib name 'XwcFreeStringList';
  function XTextPropertyToStringList; external sXlib name 'XTextPropertyToStringList';
  function XmbTextPropertyToTextList; external sXlib name 'XmbTextPropertyToTextList';
  function XwcTextPropertyToTextList; external sXlib name 'XwcTextPropertyToTextList';
  function XUnionRectWithRegion; external sXlib name 'XUnionRectWithRegion';
  function XUnionRegion; external sXlib name 'XUnionRegion';
  function XXorRegion; external sXlib name 'XXorRegion';

  { Xlib.h }
  function XLoadQueryFont; external sXLib name 'XLoadQueryFont';
  function XQueryFont; external sXLib name 'XQueryFont';
  function XGetMotionEvents; external sXLib name 'XGetMotionEvents';
  function XDeleteModifiermapEntry; external sXLib name 'XDeleteModifiermapEntry';
  function XGetModifierMapping; external sXLib name 'XGetModifierMapping';
  function XInsertModifiermapEntry; external sXLib name 'XInsertModifiermapEntry';
  function XNewModifiermap; external sXLib name 'XNewModifiermap';
  function XCreateImage; external sXLib name 'XCreateImage';
  function XInitImage; external sXLib name 'XInitImage';
  function XGetImage; external sXLib name 'XGetImage';
  function XGetSubImage; external sXLib name 'XGetSubImage';
  function XOpenDisplay; external sXLib name 'XOpenDisplay';
  procedure XrmInitialize; cdecl; external sXLib name 'XrmInitialize';
  function XFetchBytes; external sXLib name 'XFetchBytes';
  function XFetchBuffer; external sXLib name 'XFetchBuffer';
  function XGetAtomName; external sXLib name 'XGetAtomName';
  function XGetAtomNames; external sXLib name 'XGetAtomNames';
  function XGetDefault; external sXLib name 'XGetDefault';
  function XDisplayName; external sXLib name 'XDisplayName';
  function XKeysymToString; external sXLib name 'XKeysymToString';
  function XSynchronize; external sXLib name 'XSynchronize';
  function XSetAfterFunction; external sXLib name 'XSetAfterFunction';
  function XInternAtom; external sXLib name 'XInternAtom';
  function XInternAtoms; external sXLib name 'XInternAtoms';
  function XCopyColormapAndFree; external sXLib name 'XCopyColormapAndFree';
  function XCreateColormap; external sXLib name 'XCreateColormap';
  function XCreatePixmapCursor; external sXLib name 'XCreatePixmapCursor';
  function XCreateGlyphCursor; external sXLib name 'XCreateGlyphCursor';
  function XCreateFontCursor; external sXLib name 'XCreateFontCursor';
  function XLoadFont; external sXLib name 'XLoadFont';
  function XCreateGC; external sXLib name 'XCreateGC';
  function XGContextFromGC; external sXLib name 'XGContextFromGC';
  procedure XFlushGC; external sXLib name 'XFlushGC';
  function XCreatePixmap; external sXLib name 'XCreatePixmap';
  function XCreateBitmapFromData; external sXLib name 'XCreateBitmapFromData';
  function XCreatePixmapFromBitmapData; external sXLib name 'XCreatePixmapFromBitmapData';
  function XCreateSimpleWindow; external sXLib name 'XCreateSimpleWindow';
  function XGetSelectionOwner; external sXLib name 'XGetSelectionOwner';
  function XCreateWindow; external sXLib name 'XCreateWindow';
  function XListInstalledColormaps; external sXLib name 'XListInstalledColormaps';
  function XGetFontPath; external sXLib name 'XGetFontPath';
  function XListExtensions; external sXLib name 'XListExtensions';
  function XListProperties; external sXLib name 'XListProperties';
  function XListHosts; external sXLib name 'XListHosts';
  function XKeycodeToKeysym; external sXLib name 'XKeycodeToKeysym';
  function XLookupKeysym; external sXLib name 'XLookupKeysym';
  function XGetKeyboardMapping; external sXLib name 'XGetKeyboardMapping';
  function XStringToKeysym; external sXLib name 'XStringToKeysym';
  function XMaxRequestSize; external sXLib name 'XMaxRequestSize';
  function XExtendedMaxRequestSize; external sXLib name 'XExtendedMaxRequestSize';
  function XResourceManagerString; external sXLib name 'XResourceManagerString';
  function XScreenResourceString; external sXLib name 'XScreenResourceString';
  function XDisplayMotionBufferSize; external sXLib name 'XDisplayMotionBufferSize';
  function XVisualIDFromVisual; external sXLib name 'XVisualIDFromVisual';
  function XInitThreads; external sXLib name 'XInitThreads';
  procedure XLockDisplay; external sXLib name 'XLockDisplay';
  procedure XUnlockDisplay; external sXLib name 'XUnlockDisplay';
  function XAddExtension; external sXLib name 'XAddExtension';
  function XFindOnExtensionList; external sXLib name 'XFindOnExtensionList';
  function XEHeadOfExtensionList; external sXLib name 'XEHeadOfExtensionList';
  function XRootWindow; external sXLib name 'XRootWindow';
  function XDefaultRootWindow; external sXLib name 'XDefaultRootWindow';
  function XRootWindowOfScreen; external sXLib name 'XRootWindowOfScreen';
  function XDefaultVisual; external sXLib name 'XDefaultVisual';
  function XDefaultVisualOfScreen; external sXLib name 'XDefaultVisualOfScreen';
  function XDefaultGC; external sXLib name 'XDefaultGC';
  function XDefaultGCOfScreen; external sXLib name 'XDefaultGCOfScreen';
  function XBlackPixel; external sXLib name 'XBlackPixel';
  function XWhitePixel; external sXLib name 'XWhitePixel';
  function XAllPlanes; external sXLib name 'XAllPlanes';
  function XBlackPixelOfScreen; external sXLib name 'XBlackPixelOfScreen';
  function XWhitePixelOfScreen; external sXLib name 'XWhitePixelOfScreen';
  function XNextRequest; external sXLib name 'XNextRequest';
  function XLastKnownRequestProcessed; external sXLib name 'XLastKnownRequestProcessed';
  function XServerVendor; external sXLib name 'XServerVendor';
  function XDisplayString; external sXLib name 'XDisplayString';
  function XDefaultColormap; external sXLib name 'XDefaultColormap';
  function XDefaultColormapOfScreen; external sXLib name 'XDefaultColormapOfScreen';
  function XDisplayOfScreen; external sXLib name 'XDisplayOfScreen';
  function XScreenOfDisplay; external sXLib name 'XScreenOfDisplay';
  function XDefaultScreenOfDisplay; external sXLib name 'XDefaultScreenOfDisplay';
  function XEventMaskOfScreen; external sXLib name 'XEventMaskOfScreen';
  function XScreenNumberOfScreen; external sXLib name 'XScreenNumberOfScreen';
  function XSetErrorHandler; external sXLib name 'XSetErrorHandler';
  function XSetIOErrorHandler; external sXLib name 'XSetIOErrorHandler';
  function XListPixmapFormats; external sXLib name 'XListPixmapFormats';
  function XListDepths; external sXLib name 'XListDepths';
  function XReconfigureWMWindow; external sXLib name 'XReconfigureWMWindow';
  function XGetWMProtocols; external sXLib name 'XGetWMProtocols';
  function XSetWMProtocols; external sXLib name 'XSetWMProtocols';
  function XIconifyWindow; external sXLib name 'XIconifyWindow';
  function XWithdrawWindow; external sXLib name 'XWithdrawWindow';
  function XGetCommand; external sXLib name 'XGetCommand';
  function XGetWMColormaPWindows; external sXLib name 'XGetWMColormaPWindows';
  function XSetWMColormaPWindows; external sXLib name 'XSetWMColormaPWindows';
  procedure XFreeStringList; external sXLib name 'XFreeStringList';
  function XSetTransientForHint; external sXLib name 'XSetTransientForHint';
  function XActivateScreenSaver; external sXLib name 'XActivateScreenSaver';
  function XAddHost; external sXLib name 'XAddHost';
  function XAddHosts; external sXLib name 'XAddHosts';
  function XAddToExtensionList; external sXLib name 'XAddToExtensionList';
  function XAddToSaveSet; external sXLib name 'XAddToSaveSet';
  function XAllocColor; external sXLib name 'XAllocColor';
  function XAllocColorCells; external sXLib name 'XAllocColorCells';
  function XAllocColorPlanes; external sXLib name 'XAllocColorPlanes';
  function XAllowEvents; external sXLib name 'XAllowEvents';
  function XAutoRepeatOff; external sXLib name 'XAutoRepeatOff';
  function XAutoRepeatOn; external sXLib name 'XAutoRepeatOn';
  function XBell; external sXLib name 'XBell';
  function XBitmapBitOrder; external sXLib name 'XBitmapBitOrder';
  function XBitmapPad; external sXLib name 'XBitmapPad';
  function XBitmapUnit; external sXLib name 'XBitmapUnit';
  function XCellsOfScreen; external sXLib name 'XCellsOfScreen';
  function XChangeActivePointerGrab; external sXLib name 'XChangeActivePointerGrab';
  function XChangeGC; external sXLib name 'XChangeGC';
  function XChangeKeyboardControl; external sXLib name 'XChangeKeyboardControl';
  function XChangeKeyboardMapping; external sXLib name 'XChangeKeyboardMapping';
  function XChangePointerControl; external sXLib name 'XChangePointerControl';
  function XChangeSaveSet; external sXLib name 'XChangeSaveSet';
  function XChangeWindowAttributes; external sXLib name 'XChangeWindowAttributes';
  function XCheckIfEvent; external sXLib name 'XCheckIfEvent';
  function XCheckMaskEvent; external sXLib name 'XCheckMaskEvent';
  function XCheckTypedEvent; external sXLib name 'XCheckTypedEvent';
  function XCheckTypedWindowEvent; external sXLib name 'XCheckTypedWindowEvent';
  function XCheckWindowEvent; external sXLib name 'XCheckWindowEvent';
  function XCirculateSubwindows; external sXLib name 'XCirculateSubwindows';
  function XCirculateSubwindowsDown; external sXLib name 'XCirculateSubwindowsDown';
  function XCirculateSubwindowsUp; external sXLib name 'XCirculateSubwindowsUp';
  function XClearArea; external sXLib name 'XClearArea';
  function XClearWindow; external sXLib name 'XClearWindow';
  function XCloseDisplay; external sXLib name 'XCloseDisplay';
  function XConfigureWindow; external sXLib name 'XConfigureWindow';
  function XConnectionNumber; external sXLib name 'XConnectionNumber';
  function XConvertSelection; external sXLib name 'XConvertSelection';
  function XCopyArea; external sXLib name 'XCopyArea';
  function XCopyGC; external sXLib name 'XCopyGC';
  function XCopyPlane; external sXLib name 'XCopyPlane';
  function XDefaultDepth; external sXLib name 'XDefaultDepth';
  function XDefaultDepthOfScreen; external sXLib name 'XDefaultDepthOfScreen';
  function XDefaultScreen; external sXLib name 'XDefaultScreen';
  function XDefineCursor; external sXLib name 'XDefineCursor';
  function XDeleteProperty; external sXLib name 'XDeleteProperty';
  function XDestroyWindow; external sXLib name 'XDestroyWindow';
  function XDestroySubwindows; external sXLib name 'XDestroySubwindows';
  function XDoesBackingStore; external sXLib name 'XDoesBackingStore';
  function XDoesSaveUnders; external sXLib name 'XDoesSaveUnders';
  function XDisableAccessControl; external sXLib name 'XDisableAccessControl';
  function XDisplayCells; external sXLib name 'XDisplayCells';
  function XDisplayHeight; external sXLib name 'XDisplayHeight';
  function XDisplayHeightMM; external sXLib name 'XDisplayHeightMM';
  function XDisplayKeycodes; external sXLib name 'XDisplayKeycodes';
  function XDisplayPlanes; external sXLib name 'XDisplayPlanes';
  function XDisplayWidth; external sXLib name 'XDisplayWidth';
  function XDisplayWidthMM; external sXLib name 'XDisplayWidthMM';
  function XDrawArc; external sXLib name 'XDrawArc';
  function XDrawArcs; external sXLib name 'XDrawArcs';
  function XDrawLine; external sXLib name 'XDrawLine';
  function XDrawLines; external sXLib name 'XDrawLines';
  function XDrawPoint; external sXLib name 'XDrawPoint';
  function XDrawPoints; external sXLib name 'XDrawPoints';
  function XDrawRectangle; external sXLib name 'XDrawRectangle';
  function XDrawRectangles; external sXLib name 'XDrawRectangles';
  function XDrawSegments; external sXLib name 'XDrawSegments';
  procedure XDrawString; external sXLib name 'XDrawString';
  function XDrawText; external sXLib name 'XDrawText';
  function XDrawText16; external sXLib name 'XDrawText16';
  function XEnableAccessControl; external sXLib name 'XEnableAccessControl';
  function XEventsQueued; external sXLib name 'XEventsQueued';
  function XFetchName; external sXLib name 'XFetchName';
  function XFillArc; external sXLib name 'XFillArc';
  function XFillArcs; external sXLib name 'XFillArcs';
  function XFillPolygon; external sXLib name 'XFillPolygon';
  function XFillRectangle; external sXLib name 'XFillRectangle';
  function XFillRectangles; external sXLib name 'XFillRectangles';
  function XFlush; external sXLib name 'XFlush';
  function XForceScreenSaver; external sXLib name 'XForceScreenSaver';
  function XFree; external sXLib name 'XFree';
  function XFreeColormap; external sXLib name 'XFreeColormap';
  function XFreeColors; external sXLib name 'XFreeColors';
  function XFreeCursor; external sXLib name 'XFreeCursor';
  function XFreeExtensionList; external sXLib name 'XFreeExtensionList';
  function XFreeFont; external sXLib name 'XFreeFont';
  function XFreeFontInfo; external sXLib name 'XFreeFontInfo';
  function XFreeFontNames; external sXLib name 'XFreeFontNames';
  function XFreeFontPath; external sXLib name 'XFreeFontPath';
  function XFreeGC; external sXLib name 'XFreeGC';
  function XFreeModifiermap; external sXLib name 'XFreeModifiermap';
  function XFreePixmap; external sXLib name 'XFreePixmap';
  function XGetErrorText; external sXLib name 'XGetErrorText';
  function XGetFontProperty; external sXLib name 'XGetFontProperty';
  function XGetGCValues; external sXLib name 'XGetGCValues';
  function XGetGeometry; external sXLib name 'XGetGeometry';
  function XGetIconName; external sXLib name 'XGetIconName';
  function XGetInputFocus; external sXLib name 'XGetInputFocus';
  function XGetKeyboardControl; external sXLib name 'XGetKeyboardControl';
  function XGetPointerControl; external sXLib name 'XGetPointerControl';
  function XChangeProperty; external sXLib name 'XChangeProperty';
  function XGetPointerMapping; external sXLib name 'XGetPointerMapping';
  function XSetPointerMapping; external sXLib name 'XSetPointerMapping';  
  function XGetScreenSaver; external sXLib name 'XGetScreenSaver';
  function XGetTransientForHint; external sXLib name 'XGetTransientForHint';
  function XGetWindowProperty; external sXLib name 'XGetWindowProperty';
  function XGetWindowAttributes; external sXLib name 'XGetWindowAttributes';
  function XGrabButton; external sXLib name 'XGrabButton';
  function XGrabKey; external sXLib name 'XGrabKey';
  function XGrabKeyboard; external sXLib name 'XGrabKeyboard';
  function XGrabPointer; external sXLib name 'XGrabPointer';
  function XGrabServer; external sXLib name 'XGrabServer';
  function XHeightMMOfScreen; external sXLib name 'XHeightMMOfScreen';
  function XHeightOfScreen; external sXLib name 'XHeightOfScreen';
  function XIfEvent; external sXLib name 'XIfEvent';
  function XImageByteOrder; external sXLib name 'XImageByteOrder';
  function XInstallColormap; external sXLib name 'XInstallColormap';
  function XKeysymToKeycode; external sXLib name 'XKeysymToKeycode';
  function XKillClient; external sXLib name 'XKillClient';
  function XLowerWindow; external sXLib name 'XLowerWindow';
  function XMapRaised; external sXLib name 'XMapRaised';
  function XMapSubwindows; external sXLib name 'XMapSubwindows';
  function XMapWindow; external sXLib name 'XMapWindow';
  function XMaskEvent; external sXLib name 'XMaskEvent';
  function XMaxCmapsOfScreen; external sXLib name 'XMaxCmapsOfScreen';
  function XMinCmapsOfScreen; external sXLib name 'XMinCmapsOfScreen';
  function XMoveResizeWindow; external sXLib name 'XMoveResizeWindow';
  function XMoveWindow; external sXLib name 'XMoveWindow';
  function XNextEvent; external sXLib name 'XNextEvent';
  function XNoOp; external sXLib name 'XNoOp';
  function XParseColor; external sXLib name 'XParseColor';
  function XPeekEvent; external sXLib name 'XPeekEvent';
  function XPeekIfEvent; external sXLib name 'XPeekIfEvent';
  function XPending; external sXLib name 'XPending';
  function XPlanesOfScreen; external sXLib name 'XPlanesOfScreen';
  function XProtocolRevision; external sXLib name 'XProtocolRevision';
  function XProtocolVersion; external sXLib name 'XProtocolVersion';
  function XPutBackEvent; external sXLib name 'XPutBackEvent';
  function XPutImage; external sXLib name 'XPutImage';
  function XQLength; external sXLib name 'XQLength';
  function XQueryBestCursor; external sXLib name 'XQueryBestCursor';
  function XQueryBestSize; external sXLib name 'XQueryBestSize';
  function XQueryBestStipple; external sXLib name 'XQueryBestStipple';
  function XQueryBestTile; external sXLib name 'XQueryBestTile';
  function XQueryColor; external sXLib name 'XQueryColor';
  function XQueryColors; external sXLib name 'XQueryColors';
  function XQueryKeymap; external sXLib name 'XQueryKeymap';
  function XQueryPointer; external sXLib name 'XQueryPointer';
  function XQueryTree; external sXLib name 'XQueryTree';
  function XRaiseWindow; external sXLib name 'XRaiseWindow';
  function XRecolorCursor; external sXLib name 'XRecolorCursor';
  function XRefreshKeyboardMapping; external sXLib name 'XRefreshKeyboardMapping';
  function XRemoveFromSaveSet; external sXLib name 'XRemoveFromSaveSet';
  function XRemoveHost; external sXLib name 'XRemoveHost';
  function XRemoveHosts; external sXLib name 'XRemoveHosts';
  function XReparentWindow; external sXLib name 'XReparentWindow';
  function XResetScreenSaver; external sXLib name 'XResetScreenSaver';
  function XResizeWindow; external sXLib name 'XResizeWindow';
  function XRestackWindows; external sXLib name 'XRestackWindows';
  function XRotateBuffers; external sXLib name 'XRotateBuffers';
  function XRotateWindowProperties; external sXLib name 'XRotateWindowProperties';
  function XScreenCount; external sXLib name 'XScreenCount';
  function XSelectInput; external sXLib name 'XSelectInput';
  function XSendEvent; external sXLib name 'XSendEvent';
  function XSetAccessControl; external sXLib name 'XSetAccessControl';
  function XSetArcMode; external sXLib name 'XSetArcMode';
  function XSetBackground; external sXLib name 'XSetBackground';
  function XSetClipMask; external sXLib name 'XSetClipMask';
  function XSetClipOrigin; external sXLib name 'XSetClipOrigin';
  function XSetClipRectangles; external sXLib name 'XSetClipRectangles';
  function XSetCloseDownMode; external sXLib name 'XSetCloseDownMode';
  function XSetCommand; external sXLib name 'XSetCommand';
  procedure XSetDashes; external sXLib name 'XSetDashes';
  function XSetFillRule; external sXLib name 'XSetFillRule';
  function XSetFillStyle; external sXLib name 'XSetFillStyle';
  procedure XSetFont; external sXLib name 'XSetFont';
  function XSetFontPath; external sXLib name 'XSetFontPath';
  procedure  XSetForeground; external sXLib name 'XSetForeground';
  function XSetFunction; external sXLib name 'XSetFunction';
  function XSetGraphicsExposures; external sXLib name 'XSetGraphicsExposures';
  function XSetInputFocus; external sXLib name 'XSetInputFocus';
  procedure XSetLineAttributes; external sXLib name 'XSetLineAttributes';
  function XSetModifierMapping; external sXLib name 'XSetModifierMapping';
  function XSetPlaneMask; external sXLib name 'XSetPlaneMask';
  function XSetScreenSaver; external sXLib name 'XSetScreenSaver';
  function XSetSelectionOwner; external sXLib name 'XSetSelectionOwner';
  function XSetState; external sXLib name 'XSetState';
  function XSetStipple; external sXLib name 'XSetStipple';
  function XSetSubwindowMode; external sXLib name 'XSetSubwindowMode';
  function XSetTSOrigin; external sXLib name 'XSetTSOrigin';
  function XSetTile; external sXLib name 'XSetTile';
  function XSetWindowBackground; external sXLib name 'XSetWindowBackground';
  function XSetWindowBackgroundPixmap; external sXLib name 'XSetWindowBackgroundPixmap';
  function XSetWindowBorder; external sXLib name 'XSetWindowBorder';
  function XSetWindowBorderPixmap; external sXLib name 'XSetWindowBorderPixmap';
  function XSetWindowBorderWidth; external sXLib name 'XSetWindowBorderWidth';
  function XSetWindowColormap; external sXLib name 'XSetWindowColormap';
  function XStoreColor; external sXLib name 'XStoreColor';
  function XStoreColors; external sXLib name 'XStoreColors';
  function XSync; external sXLib name 'XSync';
  function XTextExtents; external sXLib name 'XTextExtents';
  function XTextWidth; external sXLib name 'XTextWidth';
  function XTranslateCoordinates; external sXLib name 'XTranslateCoordinates';
  function XUndefineCursor; external sXLib name 'XUndefineCursor';
  function XUngrabButton; external sXLib name 'XUngrabButton';
  function XUngrabKey; external sXLib name 'XUngrabKey';
  function XUngrabKeyboard; external sXLib name 'XUngrabKeyboard';
  function XUngrabPointer; external sXLib name 'XUngrabPointer';
  function XUngrabServer; external sXLib name 'XUngrabServer';
  function XUninstallColormap; external sXLib name 'XUninstallColormap';
  function XUnloadFont; external sXLib name 'XUnloadFont';
  function XUnmapSubwindows; external sXLib name 'XUnmapSubwindows';
  function XUnmapWindow; external sXLib name 'XUnmapWindow';
  function XVendorRelease; external sXLib name 'XVendorRelease';
  function XWarpPointer; external sXLib name 'XWarpPointer';
  function XWidthMMOfScreen; external sXLib name 'XWidthMMOfScreen';
  function XWidthOfScreen; external sXLib name 'XWidthOfScreen';
  function XWindowEvent; external sXLib name 'XWindowEvent';
  function XSupportsLocale; external sXLib name 'XSupportsLocale';
  function XCloseOM; external sXLib name 'XCloseOM';
  function XSetOMValues; external sXLib name 'XSetOMValues';
  function XGetOMValues; external sXLib name 'XGetOMValues';
  function XDisplayOfOM; external sXLib name 'XDisplayOfOM';
  function XLocaleOfOM; external sXLib name 'XLocaleOfOM';
  function XCreateOC; external sXLib name 'XCreateOC';
  procedure XDestroyOC; external sXLib name 'XDestroyOC';
  function XOMOfOC; external sXLib name 'XOMOfOC';
  function XSetOCValues; external sXLib name 'XSetOCValues';
  function XGetOCValues; external sXLib name 'XGetOCValues';
  procedure XFreeFontSet; external sXLib name 'XFreeFontSet';
  function XFontsOfFontSet; external sXLib name 'XFontsOfFontSet';
  function XBaseFontNameListOfFontSet; external sXLib name 'XBaseFontNameListOfFontSet';
  function XLocaleOfFontSet; external sXLib name 'XLocaleOfFontSet';
  function XContextDependentDrawing; external sXLib name 'XContextDependentDrawing';
  function XDirectionalDependentDrawing; external sXLib name 'XDirectionalDependentDrawing';
  function XContextualDrawing; external sXLib name 'XContextualDrawing';
  function XExtentsOfFontSet; external sXLib name 'XExtentsOfFontSet';
  procedure XmbDrawText; external sXLib name 'XmbDrawText';
  procedure XwcDrawText; external sXLib name 'XwcDrawText';
  function XCloseIM; external sXLib name 'XCloseIM';
  function XGetIMValues; external sXLib name 'XGetIMValues';
  function XSetIMValues; external sXLib name 'XSetIMValues';
  function XDisplayOfIM; external sXLib name 'XDisplayOfIM';
  function XLocaleOfIM; external sXLib name 'XLocaleOfIM';
  function XCreateIC; external sXLib name 'XCreateIC';
  procedure XDestroyIC; external sXLib name 'XDestroyIC';
  procedure XSetICFocus; external sXLib name 'XSetICFocus';
  procedure XUnsetICFocus; external sXLib name 'XUnsetICFocus';
  function XwcResetIC; external sXLib name 'XwcResetIC';
  function XmbResetIC; external sXLib name 'XmbResetIC';
  function XSetICValues; external sXLib name 'XSetICValues';
  function XGetICValues; external sXLib name 'XGetICValues';
  function XIMOfIC; external sXLib name 'XIMOfIC';
  function XFilterEvent; external sXLib name 'XFilterEvent';
  function XmbLookupString; external sXLib name 'XmbLookupString';
  function XwcLookupString; external sXLib name 'XwcLookupString';
  function XInternalConnectionNumbers; external sXLib name 'XInternalConnectionNumbers';
  procedure XProcessInternalConnection; external sXLib name 'XProcessInternalConnection';
  function XAddConnectionWatch; external sXLib name 'XAddConnectionWatch';
  procedure XRemoveConnectionWatch; external sXLib name 'XRemoveConnectionWatch';
    
function RevertToNone: Longint;
begin
  Result := Longint(None);
end;

function RevertToPointerRoot: Longint;
begin
  Result := Longint(PointerRoot);
end;

function XGetPixel(Image: PXImage; X, Y: Longint): Cardinal;
begin
  Result := Image.f.get_pixel(Image, X, Y);
end;

function XPutPixel(Image: PXImage; X, Y: Longint; Pixel: Cardinal): Longint;
begin
  Result := Image.f.put_pixel(Image, X, Y, Pixel);
end;

function XDestroyImage(Image: PXImage): Longint;
begin
  Result := Image.f.destroy_image(Image);
end;

function XSubImage(Image: PXImage; X: Longint; Y: Longint; SubImageWidth: Cardinal;
  SubImageHeight: Cardinal): PXImage;
begin
  Result := Image.f.sub_image(Image, X, Y, SubImageWidth, SubImageHeight);
end;

function XAddPixel(Image: PXImage; Value: Longint): Longint;
begin
  Result := Image.f.add_pixel(Image, Value);
end;

end.




