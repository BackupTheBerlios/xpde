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

unit uGlobal;

interface

uses XLib;

type
   TGrabOp=(gbGRAB_OP_NONE,
  // Mouse ops
  gbGRAB_OP_MOVING,
  gbGRAB_OP_RESIZING_SE,
  gbGRAB_OP_RESIZING_S,
  gbGRAB_OP_RESIZING_SW,
  gbGRAB_OP_RESIZING_N,
  gbGRAB_OP_RESIZING_NE,
  gbGRAB_OP_RESIZING_NW,
  gbGRAB_OP_RESIZING_W,
  gbGRAB_OP_RESIZING_E,

  // Keyboard ops
  gbGRAB_OP_KEYBOARD_MOVING,
  gbGRAB_OP_KEYBOARD_RESIZING_UNKNOWN,
  gbGRAB_OP_KEYBOARD_RESIZING_S,
  gbGRAB_OP_KEYBOARD_RESIZING_N,
  gbGRAB_OP_KEYBOARD_RESIZING_W,
  gbGRAB_OP_KEYBOARD_RESIZING_E,
  gbGRAB_OP_KEYBOARD_RESIZING_SE,
  gbGRAB_OP_KEYBOARD_RESIZING_NE,
  gbGRAB_OP_KEYBOARD_RESIZING_SW,
  gbGRAB_OP_KEYBOARD_RESIZING_NW,

  // Alt+Tab
  gbGRAB_OP_KEYBOARD_TABBING_NORMAL,
  gbGRAB_OP_KEYBOARD_TABBING_DOCK,

  // Alt+Esc
  gbGRAB_OP_KEYBOARD_ESCAPING_NORMAL,
  gbGRAB_OP_KEYBOARD_ESCAPING_DOCK,

  gbGRAB_OP_KEYBOARD_WORKSPACE_SWITCHING,

  // Frame button ops
  gbGRAB_OP_CLICKING_MINIMIZE,
  gbGRAB_OP_CLICKING_MAXIMIZE,
  gbGRAB_OP_CLICKING_UNMAXIMIZE,
  gbGRAB_OP_CLICKING_DELETE,
  gbGRAB_OP_CLICKING_MENU
);

const 
  // should investigate changing these to whatever most apps use
  META_ICON_WIDTH=32;
  META_ICON_HEIGHT=32;
  META_MINI_ICON_WIDTH=16;
  META_MINI_ICON_HEIGHT=16;

const
EVENT_MASK=(SubstructureRedirectMask or
            StructureNotifyMask or
            SubstructureNotifyMask or
            ExposureMask or
            ButtonPressMask or
            ButtonReleaseMask or
            PointerMotionMask or
            PointerMotionHintMask or
            EnterWindowMask or
            LeaveWindowMask or
            FocusChangeMask or
            ColormapChangeMask);

implementation

end.
