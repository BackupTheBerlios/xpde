{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (C) 2001 Havoc Pennington                                         }
{                                                                             }
{ Kylix conversion and modifications are                                      }
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
unit uWindowManager;

interface

uses Classes, Sysutils, Types,
     Qt, QForms, uSpecial, uTitle,
     QGraphics, Libc, uGlobal,
     QDialogs, uXPAPI, uDisplay, XLib;

type
    TXPWindowManager=class(TInterfacedObject, IXPWindowManager)
    private
        display:TWMDisplay;
        screen: TWMScreen;
        atom_names: TStringList;
    public
        procedure create_new_client(w:Window);
        procedure setup;
        procedure add_atom_names;
        procedure display_open;
        constructor Create;
        destructor Destroy;override;
    end;

var
    wm: TXPWindowManager;

implementation

function event_get_time(display:TWMDisplay; var event:XEvent):cardinal;
begin
  case(event.xtype) of
    KeyPress,
    KeyRelease: result:=event.xkey.time;

    ButtonPress,
    ButtonRelease: result:=event.xbutton.time;

    MotionNotify: result:=event.xmotion.time;

    PropertyNotify: result:=event.xproperty.time;

    SelectionClear,
    SelectionRequest,
    SelectionNotify: result:=event.xselection.time;

    EnterNotify,
    LeaveNotify: result:=event.xcrossing.time;

    else result:=xlib.CurrentTime;
  end
end;

function event_get_modified_window(display:TWMDisplay; var event:XEvent): Window;
begin
  case(event.xtype) of
    KeyPress,
    KeyRelease,
    ButtonPress,
    ButtonRelease,
    MotionNotify,
    FocusIn,
    FocusOut,
    KeymapNotify,
    Expose,
    GraphicsExpose,
    NoExpose,
    VisibilityNotify,
    ResizeRequest,
    PropertyNotify,
    SelectionClear,
    SelectionRequest,
    SelectionNotify,
    ColormapNotify,
    ClientMessage,
    EnterNotify,
    LeaveNotify: result:=event.xany.xwindow;

    CreateNotify: result:=event.xcreatewindow.xwindow;

    DestroyNotify: result:=event.xdestroywindow.xwindow;

    UnmapNotify: result:=event.xunmap.xwindow;

    MapNotify: result:=event.xmap.xwindow;

    MapRequest: result:=event.xmaprequest.xwindow;

    ReparentNotify: result:=event.xreparent.xwindow;

    ConfigureNotify: result:=event.xconfigure.xwindow;

    ConfigureRequest: result:=event.xconfigurerequest.xwindow;

    GravityNotify: result:=event.xgravity.xwindow;

    CirculateNotify: result:=event.xcirculate.xwindow;

    CirculateRequest: result:=event.xcirculaterequest.xwindow;

    MappingNotify: result:=none;

    else result:=none;
  end;
end;


//Main function, it processes the X11 events and performs the creation/destruction tasks
function event_callback(var event: XEvent):integer;cdecl;
var
    window: TWMWindow;
    display: TWMDisplay;
    modified: XLib.Window;
    frame_was_receiver: boolean;
    filter_out_event: boolean;
begin
    result:=0;
  display:=wm.display;

//  if (dump_events)
//    meta_spew_event (display, event);

  filter_out_event := false;
  display.current_time := event_get_time (display, event);

  modified := event_get_modified_window (display, event);

  if (event.xtype = ButtonPress) then begin
//        XPAPI.OutputDebugString('ButtonPress');
        (*
            /* filter out scrollwheel */
            if (event.xbutton.button == 4 || event.xbutton.button == 5) return FALSE;

            /* mark double click events, kind of a hack, oh well. */
            if (((int)event.xbutton.button) ==  display.last_button_num && event.xbutton.window == display.last_button_xwindow && event.xbutton.time < (display.last_button_time + display.double_click_time))
            {
                display.is_double_click = TRUE;
                meta_topic (META_DEBUG_EVENTS, "This was the second click of a double click\n");
            }
            else
            {
                display.is_double_click = FALSE;
            }

            display.last_button_num = event.xbutton.button;
            display.last_button_xwindow = event.xbutton.window;
            display.last_button_time = event.xbutton.time;
        *)
  end
  else if (event.xtype = UnmapNotify) then begin
//        XPAPI.OutputDebugString('UnmapNotify');
    (*
      if (meta_ui_window_should_not_cause_focus (display.xdisplay, modified))
        {
          add_ignored_serial (display, event.xany.serial);
          meta_topic (META_DEBUG_FOCUS,
                      "Adding EnterNotify serial %lu to ignored focus serials\n",
                      event.xany.serial);
        }
    *)
  end
  else if (event.xtype = LeaveNotify) and (event.xcrossing.mode = NotifyUngrab) and (modified = display.ungrab_should_not_cause_focus_window) then begin
//        XPAPI.OutputDebugString('LeavNotify');
    (*
      add_ignored_serial (display, event.xany.serial);
      meta_topic (META_DEBUG_FOCUS,
                  "Adding LeaveNotify serial %lu to ignored focus serials\n",
                  event.xany.serial);
    *)
  end;

  if (modified<>None) then begin
    window := display.lookup_x_window (modified);
  end
  else window := nil;

  frame_was_receiver := false;
  if (assigned(window)) and (assigned(window.frame)) and (modified=window.frame.xwindow) then begin
    (*
      /* Note that if the frame and the client both have an
       * XGrabButton (as is normal with our setup), the event
       * goes to the frame.
       */
      frame_was_receiver = TRUE;
      meta_topic (META_DEBUG_EVENTS, "Frame was receiver of event\n");
    *)
  end;

  case(event.xtype) of
    KeyPress,
    KeyRelease: begin
//        XPAPI.OutputDebugString('KeyPress,KeyRelease');
        //meta_display_process_key_event (display, window, event);
    end;
    
    ButtonPress: begin
//        XPAPI.OutputDebugString('ButtonPress');
        (*
        if ((window && grab_op_is_mouse (display.grab_op) && display.grab_button != (int) event.xbutton.button && display.grab_window == window) || grab_op_is_keyboard (display.grab_op))
        {
          meta_verbose ("Ending grab op %d on window %s due to button press\n",
                        display.grab_op,
                        (display.grab_window ?
                         display.grab_window.desc :
                         "none"));
          meta_display_end_grab_op (display,
                                    event.xbutton.time);
        }
      else if (window && display.grab_op == META_GRAB_OP_NONE)
        {
          gboolean begin_move = FALSE;
          unsigned int grab_mask;
          gboolean unmodified;

          grab_mask = display.window_grab_modifiers;
          if (g_getenv ("METACITY_DEBUG_BUTTON_GRABS"))
            grab_mask |= ControlMask;

          /* Two possible sources of an unmodified event; one is a
           * client that's letting button presses pass through to the
           * frame, the other is our focus_window_grab on unmodified
           * button 1.  So for all such events we focus the window.
           */
          unmodified = (event.xbutton.state & grab_mask) == 0;

          if ((unmodified && event.xbutton.button != 2) ||
              event.xbutton.button == 1)
            {
              if (!frame_was_receiver)
                {
                  /* don't focus if frame received, will be
                   * done in frames.c if the click wasn't on
                   * the minimize/close button.
                   */
                  meta_window_raise (window);

                  meta_topic (META_DEBUG_FOCUS,
                              "Focusing %s due to unmodified button %d press (display.c)\n",
                              window.desc, event.xbutton.button);
                  meta_window_focus (window, event.xbutton.time);
                }

              /* you can move on alt-click but not on
               * the click-to-focus
               */
              if (!unmodified)
                begin_move = TRUE;
            }
          else if (!unmodified && event.xbutton.button == 2)
            {
              if (window.has_resize_func)
                {
                  gboolean north;
                  gboolean west;
                  int root_x, root_y;
                  MetaGrabOp op;

                  meta_window_get_position (window, &root_x, &root_y);

                  west = event.xbutton.x_root < (root_x + window.rect.width / 2);
                  north = event.xbutton.y_root < (root_y + window.rect.height / 2);

                  if (west && north)
                    op = META_GRAB_OP_RESIZING_NW;
                  else if (west)
                    op = META_GRAB_OP_RESIZING_SW;
                  else if (north)
                    op = META_GRAB_OP_RESIZING_NE;
                  else
                    op = META_GRAB_OP_RESIZING_SE;

                  meta_display_begin_grab_op (display,
                                              window.screen,
                                              window,
                                              op,
                                              TRUE,
                                              event.xbutton.button,
                                              0,
                                              event.xbutton.time,
                                              event.xbutton.x_root,
                                              event.xbutton.y_root);
                }
            }
          else if (event.xbutton.button == 3)
            {
              meta_window_show_menu (window,
                                     event.xbutton.x_root,
                                     event.xbutton.y_root,
                                     event.xbutton.button,
                                     event.xbutton.time);
            }

          if (!frame_was_receiver && unmodified)
            {
              /* This is from our synchronous grab since
               * it has no modifiers and was on the client window
               */
              int mode;
              
              /* When clicking a different app in click-to-focus
               * in application-based mode, and the different
               * app is not a dock or desktop, eat the focus click.
               */
              if (meta_prefs_get_focus_mode () == META_FOCUS_MODE_CLICK &&
                  meta_prefs_get_application_based () &&
                  !window.has_focus &&
                  window.type != META_WINDOW_DOCK &&
                  window.type != META_WINDOW_DESKTOP &&
                  (display.focus_window == NULL ||
                   !meta_window_same_application (window,
                                                  display.focus_window)))
                mode = AsyncPointer; /* eat focus click */
              else
                mode = ReplayPointer; /* give event back */
              
              XAllowEvents (display.xdisplay,
                            mode, event.xbutton.time);
            }
          
          if (begin_move && window.has_move_func)
            {
              meta_display_begin_grab_op (display,
                                          window.screen,
                                          window,
                                          META_GRAB_OP_MOVING,
                                          TRUE,
                                          event.xbutton.button,
                                          0,
                                          event.xbutton.time,
                                          event.xbutton.x_root,
                                          event.xbutton.y_root);
            }
        }
      break;
      *)
    end;
    ButtonRelease: begin
//        XPAPI.OutputDebugString('ButtonRelease');
      (*
      if (grab_op_is_mouse (display.grab_op) &&
          display.grab_window == window)
        meta_window_handle_mouse_grab_op_event (window, event);
      break;
      *)
    end;
    MotionNotify: begin
//        XPAPI.OutputDebugString('MotionNotify');
        (*
      if (grab_op_is_mouse (display.grab_op) &&
          display.grab_window == window)
        meta_window_handle_mouse_grab_op_event (window, event);
      break;
      *)
    end;
    EnterNotify: begin
//        XPAPI.OutputDebugString('EnterNotify');
        (*
      /* do this even if window.has_focus to avoid races */
      if (window && !serial_is_ignored (display, event.xany.serial) &&
	  event.xcrossing.detail != NotifyInferior)
        {
          switch (meta_prefs_get_focus_mode ())
            {
            case META_FOCUS_MODE_SLOPPY:
            case META_FOCUS_MODE_MOUSE:
              if (window.type != META_WINDOW_DOCK &&
                  window.type != META_WINDOW_DESKTOP)
                {
                  meta_topic (META_DEBUG_FOCUS,
                              "Focusing %s due to enter notify with serial %lu\n",
                              window.desc, event.xany.serial);

		  meta_window_focus (window, event.xcrossing.time);

		  /* stop ignoring stuff */
		  reset_ignores (display);
		  
		  if (meta_prefs_get_auto_raise ()) 
		    {
		      MetaAutoRaiseData *auto_raise_data;

		      meta_topic (META_DEBUG_FOCUS,
				  "Queuing an autoraise timeout for %s with delay %d\n",
				  window.desc, 
				  meta_prefs_get_auto_raise_delay ());
		      
		      auto_raise_data = g_new (MetaAutoRaiseData, 1);
		      auto_raise_data.display = window.display;
		      auto_raise_data.xwindow = window.xwindow;

		      if (display.autoraise_timeout_id != 0)
			g_source_remove (display.autoraise_timeout_id);

		      display.autoraise_timeout_id = 
			g_timeout_add_full (G_PRIORITY_DEFAULT,
					    meta_prefs_get_auto_raise_delay (),
					    window_raise_with_delay_callback,
					    auto_raise_data,
					    g_free);
		    }
		  else
		    {
		      meta_topic (META_DEBUG_FOCUS,
				  "Auto raise is disabled\n");		      
		    }
                }
              break;
            case META_FOCUS_MODE_CLICK:
              break;
            }
          
          if (window.type == META_WINDOW_DOCK)
            meta_window_raise (window);
        }
      break;
      *)
    end;
    LeaveNotify: begin
//        XPAPI.OutputDebugString('LeaveNotify');
      (*
      if (window)
        {
          switch (meta_prefs_get_focus_mode ())
            {
            case META_FOCUS_MODE_MOUSE:
              /* This is kind of questionable; but we normally
               * set focus to RevertToPointerRoot, so I guess
               * leaving it on PointerRoot when nothing is focused
               * is probably right. Anyway, unfocus the
               * focused window.
               */
              if (window.has_focus &&
		  event.xcrossing.mode != NotifyGrab && 
		  event.xcrossing.mode != NotifyUngrab &&
		  event.xcrossing.detail != NotifyInferior)
                {
                  meta_verbose ("Unsetting focus from %s due to LeaveNotify\n",
                                window.desc);
                  XSetInputFocus (display.xdisplay,
                                  display.no_focus_window,
                                  RevertToPointerRoot,
                                  event.xcrossing.time);
                }
              break;
            case META_FOCUS_MODE_SLOPPY:
            case META_FOCUS_MODE_CLICK:
              break;
            }
          
          if (window.type == META_WINDOW_DOCK &&
              event.xcrossing.mode != NotifyGrab &&
              event.xcrossing.mode != NotifyUngrab &&
              !window.has_focus)
            meta_window_lower (window);
        }
      break;
      *)
    end;
    FocusIn,
    FocusOut: begin
//        XPAPI.OutputDebugString('FocusIn,FocusOut');
        (*
      if (window)
        {
          meta_window_notify_focus (window, event);
        }
      else if (event.xany.window == display.no_focus_window)
        {
          meta_topic (META_DEBUG_FOCUS,
                      "Focus %s event received on no_focus_window 0x%lx "
                      "mode %s detail %s\n",
                      event.type == FocusIn ? "in" :
                      event.type == FocusOut ? "out" :
                      "???",
                      event.xany.window,
                      meta_event_mode_to_string (event.xfocus.mode),
                      meta_event_detail_to_string (event.xfocus.mode));
        }
      else if (meta_display_screen_for_root (display,
                                             event.xany.window) != NULL)
        {
          meta_topic (META_DEBUG_FOCUS,
                      "Focus %s event received on root window 0x%lx "
                      "mode %s detail %s\n",
                      event.type == FocusIn ? "in" :
                      event.type == FocusOut ? "out" :
                      "???",
                      event.xany.window,
                      meta_event_mode_to_string (event.xfocus.mode),
                      meta_event_detail_to_string (event.xfocus.mode));
        }
      break;
      *)
    end;
    KeymapNotify: begin
//        XPAPI.OutputDebugString('KeymapNotify');
      //break;
    end;
    Expose: begin
//        XPAPI.OutputDebugString('Expose');
      //break;
    end;
    GraphicsExpose:begin
//        XPAPI.OutputDebugString('GraphicsExpose');
      //break;
    end;
    NoExpose: begin
//        XPAPI.OutputDebugString('NoExpose');
      //break;
    end;
    VisibilityNotify: begin
//        XPAPI.OutputDebugString('VisibilityNotify');
      //break;
    end;
    CreateNotify: begin
//        XPAPI.OutputDebugString('CreateNotify');
      //break;
    end;
    DestroyNotify: begin
//        XPAPI.OutputDebugString('DestroyNotify');
        (*
      if (window)
        {
          if (display.grab_op != META_GRAB_OP_NONE &&
              display.grab_window == window)
            meta_display_end_grab_op (display, CurrentTime);

          if (frame_was_receiver)
            {
              meta_warning ("Unexpected destruction of frame 0x%lx, not sure if this should silently fail or be considered a bug\n",
                            window.frame.xwindow);
              meta_error_trap_push (display);
              meta_window_destroy_frame (window.frame.window);
              meta_error_trap_pop (display, FALSE);
            }
          else
            {
              meta_window_free (window); /* Unmanage destroyed window */
            }
        }
      break;
      *)
    end;

    UnmapNotify: begin
        // XPAPI.OutputDebugString('UnmapNotify');
        (*
      if (window)
        {
          if (display.grab_op != META_GRAB_OP_NONE &&
              display.grab_window == window)
            meta_display_end_grab_op (display, CurrentTime);

          if (!frame_was_receiver)
            {
              if (window.unmaps_pending == 0)
                {
                  meta_topic (META_DEBUG_WINDOW_STATE,
                              "Window %s withdrawn\n",
                              window.desc);
                  window.withdrawn = TRUE;
                  meta_window_free (window); /* Unmanage withdrawn window */
                  window = NULL;
                }
              else
                {
                  window.unmaps_pending -= 1;
                  meta_topic (META_DEBUG_WINDOW_STATE,
                              "Received pending unmap, %d now pending\n",
                              window.unmaps_pending);
                }
            }

          /* Unfocus on UnmapNotify, do this after the possible
           * window_free above so that window_free can see if window.has_focus
           * and move focus to another window
           */
          if (window)
            meta_window_notify_focus (window, event);
        }
      break;
      *)
    end;
    MapNotify: begin
//        XPAPI.OutputDebugString('MapNotify');
      //break;
    end;
    MapRequest: begin
//        XPAPI.OutputDebugString('Maprequest');
//        wm.create_new_client(event.xmaprequest.xwindow);
        result:=1;

      if (window=nil) then begin
          if event.xmaprequest.xwindow<>display.no_focus_window then begin
              window:=TWMWindow.create;
              window.new(display,event.xmaprequest.xwindow,false);
          end;
      end
      // if frame was receiver it's some malicious send event or something
      else if (not (frame_was_receiver)) and assigned(window) then begin
          if (window.minimized) then window.unminimize;
      end;

    end;
    ReparentNotify: begin
//        XPAPI.OutputDebugString('ReparentNotify');
      //break;
    end;
    ConfigureNotify: begin
//        XPAPI.OutputDebugString('ConfigureNotify');
     (*
      /* Handle screen resize */
      {
	MetaScreen *screen;

        screen = meta_display_screen_for_root (display,
                                               event.xconfigure.window);

	if (screen != NULL)
          {
#ifdef HAVE_RANDR
            /* do the resize the official way */
            XRRUpdateConfiguration (event);
#else
            /* poke around in Xlib */
            screen.xscreen.width   = event.xconfigure.width;
            screen.xscreen.height  = event.xconfigure.height;
#endif

            meta_screen_resize (screen,
                                event.xconfigure.width,
                                event.xconfigure.height);
          }
      }
      break;
      *)
    end;
    ConfigureRequest: begin
//        XPAPI.OutputDebugString('ConfigureRequest');
        (*
      /* This comment and code is found in both twm and fvwm */
      /*
       * According to the July 27, 1988 ICCCM draft, we should ignore size and
       * position fields in the WM_NORMAL_HINTS property when we map a window.
       * Instead, we'll read the current geometry.  Therefore, we should respond
       * to configuration requests for windows which have never been mapped.
       */
      if (window == NULL)
        {
          unsigned int xwcm;
          XWindowChanges xwc;
          
          xwcm = event.xconfigurerequest.value_mask &
            (CWX | CWY | CWWidth | CWHeight | CWBorderWidth);

          xwc.x = event.xconfigurerequest.x;
          xwc.y = event.xconfigurerequest.y;
          xwc.width = event.xconfigurerequest.width;
          xwc.height = event.xconfigurerequest.height;
          xwc.border_width = event.xconfigurerequest.border_width;

          meta_verbose ("Configuring withdrawn window to %d,%d %dx%d border %d (some values may not be in mask)\n",
                        xwc.x, xwc.y, xwc.width, xwc.height, xwc.border_width);
          meta_error_trap_push (display);
          XConfigureWindow (display.xdisplay, event.xconfigurerequest.window,
                            xwcm, &xwc);
          meta_error_trap_pop (display, FALSE);
        }
      else
        {
          if (!frame_was_receiver)
            meta_window_configure_request (window, event);
        }
      break;
      *)
    end;
    GravityNotify: begin
//        XPAPI.OutputDebugString('GravityNotify');
      //break;
    end;
    ResizeRequest: begin
//        XPAPI.OutputDebugString('ResizeRequest');
      //break;
    end;
    CirculateNotify: begin
//        XPAPI.OutputDebugString('CirculateNotify');
      //break;
    end;
    CirculateRequest: begin
//        XPAPI.OutputDebugString('CirculateRequest');
      //break;
    end;
    PropertyNotify: begin
//        XPAPI.OutputDebugString('PropertyNotify');
        (*
      if (window && !frame_was_receiver)
        meta_window_property_notify (window, event);
      else
        {
          MetaScreen *screen;

          screen = meta_display_screen_for_root (display,
                                                 event.xproperty.window);

          if (screen)
            {
              if (event.xproperty.atom ==
                  display.atom_net_desktop_layout)
                meta_screen_update_workspace_layout (screen);
              else if (event.xproperty.atom ==
                       display.atom_net_desktop_names)
                meta_screen_update_workspace_names (screen);
            }
        }
      break;
      *)
    end;
    SelectionClear: begin
//        XPAPI.OutputDebugString('SelectionClear');
        (*
      /* do this here instead of at end of function
       * so we can return
       */
      display.current_time = CurrentTime;
      process_selection_clear (display, event);
      /* Note that processing that may have resulted in
       * closing the display... so return right away.
       */
      return FALSE;
      break;
      *)
    end;
    SelectionRequest: begin
//        XPAPI.OutputDebugString('SelectionRequest');
      //process_selection_request (display, event);
      //break;
    end;
    SelectionNotify: begin
//        XPAPI.OutputDebugString('SelectionNotify');
      //break;
    end;
    ColormapNotify: begin
//        XPAPI.OutputDebugString('ColormapNotify');
        {
      if (window && !frame_was_receiver)
        window.colormap = event.xcolormap.colormap;
      break;
      }
    end;
    ClientMessage: begin
//        XPAPI.OutputDebugString('ClientMessage');
        (*
      if (window)
        {
          if (!frame_was_receiver)
            meta_window_client_message (window, event);
        }
      else
        {
          MetaScreen *screen;

          screen = meta_display_screen_for_root (display,
                                                 event.xclient.window);

          if (screen)
            {
              if (event.xclient.message_type ==
                  display.atom_net_current_desktop)
                {
                  int space;
                  MetaWorkspace *workspace;

                  space = event.xclient.data.l[0];

                  meta_verbose ("Request to change current workspace to %d\n",
                                space);

                  workspace =
                    meta_screen_get_workspace_by_index (screen,
                                                        space);

                  if (workspace)
                    meta_workspace_activate (workspace);
                  else
                    meta_verbose ("Don't know about workspace %d\n", space);
                }
              else if (event.xclient.message_type ==
                       display.atom_net_number_of_desktops)
                {
                  int num_spaces;

                  num_spaces = event.xclient.data.l[0];

                  meta_verbose ("Request to set number of workspaces to %d\n",
                                num_spaces);

                  meta_prefs_set_num_workspaces (num_spaces);
                }
	      else if (event.xclient.message_type ==
		       display.atom_net_showing_desktop)
		{
		  gboolean showing_desktop;

		  showing_desktop = event.xclient.data.l[0] != 0;
		  meta_verbose ("Request to %s desktop\n", showing_desktop ? "show" : "hide");

		  if (showing_desktop)
		    meta_screen_show_desktop (screen);
		  else
		    meta_screen_unshow_desktop (screen);
		}
              else if (event.xclient.message_type ==
                       display.atom_metacity_restart_message)
                {
                  meta_verbose ("Received restart request\n");
                  meta_restart ();
                }
              else if (event.xclient.message_type ==
                       display.atom_metacity_reload_theme_message)
                {
                  meta_verbose ("Received reload theme request\n");
                  meta_ui_set_current_theme (meta_prefs_get_theme (),
                                             TRUE);
                  meta_display_retheme_all ();
                }
              else if (event.xclient.message_type ==
                       display.atom_metacity_set_keybindings_message)
                {
                  meta_verbose ("Received set keybindings request = %d\n",
                                (int) event.xclient.data.l[0]);
                  meta_set_keybindings_disabled (!event.xclient.data.l[0]);
                }
	      else if (event.xclient.message_type ==
		       display.atom_wm_protocols) 
		{
                  meta_verbose ("Received WM_PROTOCOLS message\n");
                  
		  if ((Atom)event.xclient.data.l[0] == display.atom_net_wm_ping)
                    {
                      process_pong_message (display, event);

                      /* We don't want ping reply events going into
                       * the GTK+ event loop because gtk+ will treat
                       * them as ping requests and send more replies.
                       */
                      filter_out_event = TRUE;
                    }
		}
            }
        }
      break;
        *)
    end;
    MappingNotify: begin
//        XPAPI.OutputDebugString('MappingNotify');
        (*
      /* Let XLib know that there is a new keyboard mapping.
       */
      XRefreshKeyboardMapping (&event.xmapping);
      meta_display_process_mapping_event (display, event);
      break;
      *)
    end;
    end;
  display.current_time := XLib.CurrentTime;
end;

//******************************************************************************

{ TXPWindowManager }

constructor TXPWindowManager.Create;
begin
    inherited;
    display:=TWMDisplay.create;
    screen:=TWMScreen.create;
    atom_names:=TStringList.create;
    add_atom_names;
end;

destructor TXPWindowManager.Destroy;
begin
    atom_names.free;
    screen.free;
    display.free;
    inherited;
end;

procedure TXPWindowManager.add_atom_names;
begin
    with atom_names do begin
        add('_NET_WM_NAME');
        add('WM_PROTOCOLS');
        add('WM_TAKE_FOCUS');
        add('WM_DELETE_WINDOW');
        add('WM_STATE');
        add('_NET_CLOSE_WINDOW');
        add('_NET_WM_STATE');
        add('_MOTIF_WM_HINTS');
        add('_NET_WM_STATE_SHADED');
        add('_NET_WM_STATE_MAXIMIZED_HORZ');
        add('_NET_WM_STATE_MAXIMIZED_VERT');
        add('_NET_WM_DESKTOP');
        add('_NET_NUMBER_OF_DESKTOPS');
        add('WM_CHANGE_STATE');
        add('SM_CLIENT_ID');
        add('WM_CLIENT_LEADER');
        add('WM_WINDOW_ROLE');
        add('_NET_CURRENT_DESKTOP');
        add('_NET_SUPPORTING_WM_CHECK');
        add('_NET_SUPPORTED');
        add('_NET_WM_WINDOW_TYPE');
        add('_NET_WM_WINDOW_TYPE_DESKTOP');
        add('_NET_WM_WINDOW_TYPE_DOCK');
        add('_NET_WM_WINDOW_TYPE_TOOLBAR');
        add('_NET_WM_WINDOW_TYPE_MENU');
        add('_NET_WM_WINDOW_TYPE_DIALOG');
        add('_NET_WM_WINDOW_TYPE_NORMAL');
        add('_NET_WM_STATE_MODAL');
        add('_NET_CLIENT_LIST');
        add('_NET_CLIENT_LIST_STACKING');
        add('_NET_WM_STATE_SKIP_TASKBAR');
        add('_NET_WM_STATE_SKIP_PAGER');
        add('_WIN_WORKSPACE');
        add('_WIN_LAYER');
        add('_WIN_PROTOCOLS');
        add('_WIN_SUPPORTING_WM_CHECK');
        add('_NET_WM_ICON_NAME');
        add('_NET_WM_ICON');
        add('_NET_WM_ICON_GEOMETRY');
        add('UTF8_STRING');
        add('WM_ICON_SIZE');
        add('_KWM_WIN_ICON');
        add('_NET_WM_MOVERESIZE');
        add('_NET_ACTIVE_WINDOW');
        add('_METACITY_RESTART_MESSAGE');
        add('_NET_WM_STRUT');
        add('_WIN_HINTS');
        add('_METACITY_RELOAD_THEME_MESSAGE');
        add('_METACITY_SET_KEYBINDINGS_MESSAGE');
        add('_NET_WM_STATE_HIDDEN');
        add('_NET_WM_WINDOW_TYPE_UTILITY');
        add('_NET_WM_WINDOW_TYPE_SPLASHSCREEN');
        add('_NET_WM_STATE_FULLSCREEN');
        add('_NET_WM_PING');
        add('_NET_WM_PID');
        add('WM_CLIENT_MACHINE');
        add('_NET_WORKAREA');
        add('_NET_SHOWING_DESKTOP');
        add('_NET_DESKTOP_LAYOUT');
        add('MANAGER');
        add('TARGETS');
        add('MULTIPLE');
        add('TIMESTAMP');
        add('VERSION');
        add('ATOM_PAIR');
        add('_NET_DESKTOP_NAMES');
        add('_NET_WM_ALLOWED_ACTIONS');
        add('_NET_WM_ACTION_MOVE');
        add('_NET_WM_ACTION_RESIZE');
        add('_NET_WM_ACTION_SHADE');
        add('_NET_WM_ACTION_STICK');
        add('_NET_WM_ACTION_MAXIMIZE_HORZ');
        add('_NET_WM_ACTION_MAXIMIZE_VERT');
        add('_NET_WM_ACTION_CHANGE_DESKTOP');
        add('_NET_WM_ACTION_CLOSE');
        add('_NET_WM_STATE_ABOVE');
        add('_NET_WM_STATE_BELOW');
    end;
end;

procedure TXPWindowManager.display_open;
var
    xdisplay: PDisplay;
    i: integer;
    atomn: array[0..76] of PChar;
    atoms: array[0..76] of Atom;
    data: array[0..1] of integer;
begin
    for i:=0 to atom_names.count-1 do begin
        atomn[i]:=stralloc(length(atom_names[i])+1);
        strpcopy(atomn[i],atom_names[i]);
    end;
//  Atom atoms[G_N_ELEMENTS(atom_names)];
    xdisplay := application.Display;

    if not (assigned(xdisplay)) then XPAPI.OutputDebugString('Failed to open X Window System display');

    XSynchronize (xdisplay, 1);

    display.closing:= 0;


  {* here we use XDisplayName which is what the user
   * probably put in, vs. DisplayString(display) which is
   * canonicalized by XOpenDisplay()
   *}
   display.name := '';
   display.xdisplay := xdisplay;
   display.error_trap_synced_at_last_pop := true;
   display.error_traps := 0;
   display.error_trap_handler := nil;
   display.server_grab_count := 0;

   display.pending_pings := nil;
   display.autoraise_timeout_id := false;
   display.focus_window := nil;
   display.expected_focus_window := nil;
   display.mru_list := nil;

   display.static_gravity_works:=false;

   // display_init_keys (display);

   //update_window_grab_modifiers (display);
//   XInternAtoms (display.xdisplay, atom_names, G_N_ELEMENTS (atom_names), False, atoms);
   XInternAtoms (display.xdisplay, @atomn, atom_names.count, 0, @atoms);

    for i:=0 to atom_names.count-1 do begin
        strdispose(atomn[i]);
    end;

  display.atom_net_wm_name := atoms[0];
  display.atom_wm_protocols := atoms[1];
  display.atom_wm_take_focus := atoms[2];
  display.atom_wm_delete_window := atoms[3];
  display.atom_wm_state := atoms[4];
  display.atom_net_close_window := atoms[5];
  display.atom_net_wm_state := atoms[6];
  display.atom_motif_wm_hints := atoms[7];
  display.atom_net_wm_state_shaded := atoms[8];
  display.atom_net_wm_state_maximized_horz := atoms[9];
  display.atom_net_wm_state_maximized_vert := atoms[10];
  display.atom_net_wm_desktop := atoms[11];
  display.atom_net_number_of_desktops := atoms[12];
  display.atom_wm_change_state := atoms[13];
  display.atom_sm_client_id := atoms[14];
  display.atom_wm_client_leader := atoms[15];
  display.atom_wm_window_role := atoms[16];
  display.atom_net_current_desktop := atoms[17];
  display.atom_net_supporting_wm_check := atoms[18];
  display.atom_net_supported := atoms[19];
  display.atom_net_wm_window_type := atoms[20];
  display.atom_net_wm_window_type_desktop := atoms[21];
  display.atom_net_wm_window_type_dock := atoms[22];
  display.atom_net_wm_window_type_toolbar := atoms[23];
  display.atom_net_wm_window_type_menu := atoms[24];
  display.atom_net_wm_window_type_dialog := atoms[25];
  display.atom_net_wm_window_type_normal := atoms[26];
  display.atom_net_wm_state_modal := atoms[27];
  display.atom_net_client_list := atoms[28];
  display.atom_net_client_list_stacking := atoms[29];
  display.atom_net_wm_state_skip_taskbar := atoms[30];
  display.atom_net_wm_state_skip_pager := atoms[31];
  display.atom_win_workspace := atoms[32];
  display.atom_win_layer := atoms[33];
  display.atom_win_protocols := atoms[34];
  display.atom_win_supporting_wm_check := atoms[35];
  display.atom_net_wm_icon_name := atoms[36];
  display.atom_net_wm_icon := atoms[37];
  display.atom_net_wm_icon_geometry := atoms[38];
  display.atom_utf8_string := atoms[39];
  display.atom_wm_icon_size := atoms[40];
  display.atom_kwm_win_icon := atoms[41];
  display.atom_net_wm_moveresize := atoms[42];
  display.atom_net_active_window := atoms[43];
  display.atom_metacity_restart_message := atoms[44];
  display.atom_net_wm_strut := atoms[45];
  display.atom_win_hints := atoms[46];
  display.atom_metacity_reload_theme_message := atoms[47];
  display.atom_metacity_set_keybindings_message := atoms[48];
  display.atom_net_wm_state_hidden := atoms[49];
  display.atom_net_wm_window_type_utility := atoms[50];
  display.atom_net_wm_window_type_splashscreen := atoms[51];
  display.atom_net_wm_state_fullscreen := atoms[52];
  display.atom_net_wm_ping := atoms[53];
  display.atom_net_wm_pid := atoms[54];
  display.atom_wm_client_machine := atoms[55];
  display.atom_net_workarea := atoms[56];
  display.atom_net_showing_desktop := atoms[57];
  display.atom_net_desktop_layout := atoms[58];
  display.atom_manager := atoms[59];
  display.atom_targets := atoms[60];
  display.atom_multiple := atoms[61];
  display.atom_timestamp := atoms[62];
  display.atom_version := atoms[63];
  display.atom_atom_pair := atoms[64];
  display.atom_net_desktop_names := atoms[65];
  display.atom_net_wm_allowed_actions := atoms[66];
  display.atom_net_wm_action_move := atoms[67];
  display.atom_net_wm_action_resize := atoms[68];
  display.atom_net_wm_action_shade := atoms[69];
  display.atom_net_wm_action_stick := atoms[70];
  display.atom_net_wm_action_maximize_horz := atoms[71];
  display.atom_net_wm_action_maximize_vert := atoms[72];
  display.atom_net_wm_action_change_desktop := atoms[73];
  display.atom_net_wm_action_close := atoms[74];
  display.atom_net_wm_state_above := atoms[75];
  display.atom_net_wm_state_below := atoms[76];

  {* Offscreen unmapped window used for _NET_SUPPORTING_WM_CHECK,
   * created in screen_new
   *}
  display.leader_window := none;
  display.no_focus_window := none;
  qt_set_x11_event_filter(@event_callback);


  display.double_click_time := 250;
  display.last_button_time := 0;
  display.last_button_xwindow := None;
  display.last_button_num := 0;
  display.is_double_click := FALSE;

  i := 0;
  while (i < N_IGNORED_SERIALS) do begin
      display.ignored_serials[i] := 0;
      inc(i);
  end;
  display.ungrab_should_not_cause_focus_window := None;

  display.current_time := CurrentTime;

  display.grab_op := gbGRAB_OP_NONE;
  display.grab_window := nil;
  display.grab_screen := nil;

  screen.create_new(display, XDefaultScreen (xdisplay));



  (* display.leader_window was created as a side effect of
   * initializing the screens
   *)
  {
  set_utf8_string_hint (display,
                        display.leader_window,
                        display.atom_net_wm_name,
                        "XPwm");
  }


    {* The legacy GNOME hint is to set a cardinal which is the window
     * id of the supporting_wm_check window on the supporting_wm_check
     * window itself
     *}

    data[0] := display.leader_window;
    XChangeProperty (display.xdisplay,
                     display.leader_window,
                     display.atom_win_supporting_wm_check,
                     XA_CARDINAL,
                     32, PropModeReplace, @data, 1);

    XChangeProperty (display.xdisplay,
                     display.leader_window,
                     display.atom_net_supporting_wm_check,
                     XA_WINDOW,
                     32, PropModeReplace, @data, 1);


    display.grab;

(*
  /* Now manage all existing windows */
  tmp := display.screens;
  while (tmp != NULL)
    {
      meta_screen_manage_all_windows (tmp.data);
      tmp := tmp.next;
    }

  {
    Window focus;
    int ret_to;

    /* kinda bogus because GetInputFocus has no possible errors */
    meta_error_trap_push (display);

    focus := None;
    ret_to := RevertToNone;
    XGetInputFocus (display.xdisplay, &focus, &ret_to);

    /* Force a new FocusIn (does this work?) */
    XSetInputFocus (display.xdisplay, focus, ret_to, CurrentTime);

    meta_error_trap_pop (display, FALSE);
  }
*)

  display.ungrab;
end;

//Functions that must not own to any object
//It handles the registered signals
procedure handleSignal(signo:integer);
begin
(*
	if (signo = SIGCHLD) then begin
		wait(nil);
		exit;
	end;

    { TODO : Handle the exit command from a console that stops the wm }
    //Maybe it's due to this lines, I have to test it
    wm.free;
	XSetInputFocus(wm.dpy, PointerRoot, RevertToPointerRoot, CurrentTime);
	XInstallColormap(wm.dpy, XDefaultColormap(wm.dpy, wm.screen));
	XCloseDisplay(wm.dpy);
*)    
end;

procedure TXPWindowManager.setup;
var
    act: TSigaction;
    empty_mask: sigset_t;
    i:integer;
begin
  sigemptyset (empty_mask);
  act.__sigaction_handler := @handlesignal;
  act.sa_mask    := empty_mask;
  act.sa_flags   := 0;
  if (sigaction (SIGPIPE,  @act, nil) < 0) then XPAPI.OutputDebugString('Failed to register SIGPIPE handler');
  if (sigaction (SIGXFSZ,  @act, nil) < 0) then XPAPI.OutputDebugString('Failed to register SIGXFSZ handler');

  display_open;
end;

procedure TXPWindowManager.create_new_client(w: Window);
var
//    c: TXClient;
    p_attr:XSetWindowAttributes;
	attr:XWindowAttributes;
	dummy:longint;
	hints: PXWMHints;
	name:XTextProperty;
    nw,nh: longint;
    title: TTitleForm;
    dpy: PDisplay;
    parent: Window;
	ce:XConfigureEvent;
    data:array[0..1] of longint;
begin
    dpy:=display.xdisplay;
	hints := XGetWMHints(dpy, w);

	XGrabServer(dpy);

//    c:=TXClient.create(self);
//    clients.add(c);

//	c.window := w;
//	c.unmapCounter:= 0;

	XGetWindowAttributes(dpy, w, @attr);

    title:=TTitleForm.create(application);

    {
    title.left:=x;
    title.Top:=y;
    title.width:=width+(border*2)+1;
    title.height:=height+26+border;
    }
	title.left := attr.x;
	title.top := attr.y;
	title.width := attr.width;
	title.height := attr.height;
//	c.border := opt_bw;
    showmessage('ok0');
    title.show;
    showmessage('ok1');

    XGetWMName(dpy, w, @name);
    showmessage('ok2');
//    title.lbTitle.caption:=PChar(name.value);
    showmessage('ok3');

//	c.size := XAllocSizeHints();
//	XGetWMNormalHints(dpy, c.window, c.size, @dummy);

    {
	if (attr.map_state = IsViewable) then inc(c.unmapCounter,1)
    else begin
//		c.initPosition;
		if (assigned(hints)) and  ((hints.flags and StateHint)<>0) then c.setWindowState(hints.initial_state);
	end;
    }

	//if assigned(hints) then XFree(hints);

//	c.gravitate;
//	c.reparent;
//********************************
	XSelectInput(dpy, w, ColormapChangeMask or EnterWindowMask or PropertyChangeMask);
    showmessage('ok4');

	p_attr.override_redirect := 1;
//	p_attr.background_pixel := wm.bg.pixel;
	p_attr.event_mask := ChildMask or ButtonPressMask or ExposureMask or EnterWindowMask;


    parent:=QWidget_winID(title.Handle);
(*
    title.left:=x;
    title.Top:=y;
    title.width:=width+(border*2)+1;
    title.height:=height+26+border;
//    title.height:=26;
*)
    showmessage('ok5');
	XAddToSaveSet(dpy, w);
	XSetWindowBorderWidth(dpy, w, 0);
    showmessage('ok6');
    {
	c->parent = XCreateWindow(dpy, root, c->x-c->border, c->y-c->border,
		c->width+(c->border*2), c->height + (c->border*2), 0,
		DefaultDepth(dpy, screen), CopyFromParent,
		DefaultVisual(dpy, screen),
		CWOverrideRedirect | CWBackPixel | CWEventMask, &p_attr);
    }
    XChangeWindowAttributes(dpy,parent,CWOverrideRedirect or CWBackPixel or CWEventMask, @p_attr);

    showmessage('ok7');
	// Hmm, why resize this?
	// XResizeWindow(dpy, c.window, c.width, c.height);
	XReparentWindow(dpy, w, parent, 2, 22);
    showmessage('ok7.1');
	ce.xtype := ConfigureNotify;
	ce.event := w;
	ce.xwindow := w;
	ce.x := title.left;
	ce.y := title.top;
	ce.width := title.width;
	ce.height := title.height;
	ce.border_width := 0;
	ce.above := None;
	ce.override_redirect := 0;
    showmessage('ok8');

	XSendEvent(dpy, w, 0, StructureNotifyMask, @ce);
//***************************

    nw:=title.width;
    nh:=title.height;
    XResizeWindow(dpy,w,nw,nh);

    showmessage('ok9');


//    w2kTaskbar.addTask(c);

	XMapWindow(dpy, w);
	title.BringToFront;

	data[0] := normalstate;
	data[1] := None; // icon window

	XChangeProperty(dpy, w, display.atom_wm_state, display.atom_wm_state, 32, PropModeReplace, @data, 2);

	XSync(dpy, 0);
	XUngrabServer(dpy);
    showmessage('ok10');    
end;

initialization
  wm:=TXPWindowManager.create;
  XPWindowManager:=wm;


end.
