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
unit uSpecial;

interface

uses
    Types,Xlib;

const
    QtShareName = '';

    X_ChangeWindowAttributes=2;

    ChildMask=(SubstructureRedirectMask or SubstructureNotifyMask);
    ButtonMask=(ButtonPressMask or ButtonReleaseMask);
    MouseMask=(ButtonMask or PointerMotionMask);

type
    TQX11EventFilter=function(var ev:XEvent):integer;cdecl;

function qt_set_x11_event_filter(filter:TQX11EventFilter):TQX11EventFilter; cdecl;

implementation

function qt_set_x11_event_filter; external QtShareName name 'qt_set_x11_event_filter__FPFP7_XEvent_i';

end.
