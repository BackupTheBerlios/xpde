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

unit uDisplay;

interface

uses
  Classes, Types, QGraphics, QDialogs, Qt, QForms, uSpecial,
  Sysutils, XLib, uGlobal, uXPAPI, uTitle;

const
   N_IGNORED_SERIALS=4;

type
    TWMWindow=class;
    TWMScreen=class;
    TWMFrame=class;

    TWMDisplay=class(TObject)
  private
    public
        window_ids: TStringList;
        name: string;
        xdisplay: PDisplay;
        leader_window: Window;

        atom_net_wm_name:                         Atom;
        atom_wm_protocols:                        Atom;
        atom_wm_take_focus:                       Atom;
        atom_wm_delete_window:                    Atom;
        atom_wm_state:                            Atom;
        atom_net_close_window:                    Atom;
        atom_net_wm_state:                        Atom;
        atom_motif_wm_hints:                      Atom;
        atom_net_wm_state_shaded:                 Atom;
        atom_net_wm_state_maximized_horz:         Atom;
        atom_net_wm_state_maximized_vert:         Atom;
        atom_net_wm_desktop:                      Atom;
        atom_net_number_of_desktops:              Atom;
        atom_wm_change_state:                     Atom;
        atom_sm_client_id:                        Atom;
        atom_wm_client_leader:                    Atom;
        atom_wm_window_role:                      Atom;
        atom_net_current_desktop:                 Atom;
        atom_net_supporting_wm_check:             Atom;
        atom_net_supported:                       Atom;
        atom_net_wm_window_type:                  Atom;
        atom_net_wm_window_type_desktop:          Atom;
        atom_net_wm_window_type_dock:             Atom;
        atom_net_wm_window_type_toolbar:          Atom;
        atom_net_wm_window_type_menu:             Atom;
        atom_net_wm_window_type_dialog:           Atom;
        atom_net_wm_window_type_normal:           Atom;
        atom_net_wm_state_modal:                  Atom;
        atom_net_client_list:                     Atom;
        atom_net_client_list_stacking:            Atom;
        atom_net_wm_state_skip_taskbar:           Atom;
        atom_net_wm_state_skip_pager:             Atom;
        atom_win_workspace:                       Atom;
        atom_win_layer:                           Atom;
        atom_win_protocols:                       Atom;
        atom_win_supporting_wm_check:             Atom;
        atom_net_wm_icon_name:                    Atom;
        atom_net_wm_icon:                         Atom;
        atom_net_wm_icon_geometry:                Atom;
        atom_utf8_string:                         Atom;
        atom_wm_icon_size:                        Atom;
        atom_kwm_win_icon:                        Atom;
        atom_net_wm_moveresize:                   Atom;
        atom_net_active_window:                   Atom;
        atom_metacity_restart_message:            Atom;
        atom_net_wm_strut:                        Atom;
        atom_win_hints:                           Atom;
        atom_metacity_reload_theme_message:       Atom;
        atom_metacity_set_keybindings_message:    Atom;
        atom_net_wm_state_hidden:                 Atom;
        atom_net_wm_window_type_utility:          Atom;
        atom_net_wm_window_type_splashscreen:     Atom;
        atom_net_wm_ping:                         Atom;
        atom_net_wm_pid:                          Atom;
        atom_wm_client_machine:                   Atom;
        atom_net_wm_state_fullscreen:             Atom;
        atom_net_workarea:                        Atom;
        atom_net_showing_desktop:                 Atom;
        atom_net_desktop_layout:                  Atom;
        atom_manager:                             Atom;
        atom_targets:                             Atom;
        atom_multiple:                            Atom;
        atom_timestamp:                           Atom;
        atom_version:                             Atom;
        atom_atom_pair:                           Atom;
        atom_net_desktop_names:                   Atom;
        atom_net_wm_allowed_actions:              Atom;
        atom_net_wm_action_move:                  Atom;
        atom_net_wm_action_resize:                Atom;
        atom_net_wm_action_shade:                 Atom;
        atom_net_wm_action_stick:                 Atom;
        atom_net_wm_action_maximize_horz:         Atom;
        atom_net_wm_action_maximize_vert:         Atom;
        atom_net_wm_action_change_desktop:        Atom;
        atom_net_wm_action_close:                 Atom;
        atom_net_wm_state_above:                  Atom;
        atom_net_wm_state_below:                  Atom;

  {* This is the actual window from focus events,
   * not the one we last set
   *}
  focus_window: TWMWindow;

  {* window we are expecting a FocusIn event for
   *}
  expected_focus_window: TWMWindow;

  {* Most recently focused list. Always contains all
   * live windows.
   *}
  mru_list: TList;

  static_gravity_works: boolean;

  //< private-ish >
  error_trap_synced_at_last_pop:boolean;
  {
  MetaEventQueue *events;
  GSList *screens;
  GHashTable *window_ids;
  }
  error_traps:integer;

  error_trap_handler: XErrorHandler;

  server_grab_count:integer;

  {* This window holds the focus when we don't want to focus
   * any actual clients
   *}
  no_focus_window: Window;

  // for double click
  double_click_time:integer;
  last_button_time: TTime;
  last_button_xwindow: Window;
  last_button_num:integer;
  is_double_click: boolean;

  {* serials of leave/unmap events that may
   * correspond to an enter event we should
   * ignore
   *}
   ignored_serials: array[0..N_IGNORED_SERIALS] of integer;
  ungrab_should_not_cause_focus_window: Window;

  current_time: extended;

  // Pings which we're waiting for a reply from
  pending_pings: TStringList;

  //Pending autoraise
  autoraise_timeout_id:boolean;

  // Alt+click button grabs
  window_grab_modifiers:integer;

  // current window operation
  grab_op: TGrabOp;
  grab_screen: TWMScreen;
  grab_window: TWMWindow;
  grab_xwindow: Window;
  grab_button: integer;
  grab_initial_root_x: integer;
  grab_initial_root_y: integer;
  grab_current_root_x: integer;
  grab_current_root_y: integer;
  grab_mask: integer;
  grab_have_pointer: boolean;
  grab_have_keyboard : boolean;
  grab_initial_window_pos: TRect;
  grab_current_window_pos: TRect;
  grab_last_moveresize_time: TTime;

(*
  /* Keybindings stuff */
  MetaKeyBinding *screen_bindings;
  int             n_screen_bindings;
  MetaKeyBinding *window_bindings;
  int             n_window_bindings;
  int min_keycode;
  int max_keycode;
  KeySym *keymap;
  int keysyms_per_keycode;
  XModifierKeymap *modmap;
  unsigned int ignored_modifier_mask;
  unsigned int num_lock_mask;
  unsigned int scroll_lock_mask;
  unsigned int hyper_mask;
  unsigned int super_mask;
  unsigned int meta_mask;
*)

  // Closing down the display
  closing: integer;
    procedure grab;
    procedure ungrab;
    function lookup_x_window(xwindow: Window): TWMWindow;
    procedure register_x_window(xwindowp: Window; window: TWMWindow);
    procedure unregister_x_window(xwindow: Window);
    constructor Create;
    destructor Destroy;override;
end;

    TXPWindowType=(wtNormal, wtDesktop, wtDock, wtDialog, wtModalDialog, wtToolbar, wtMenu, wtUtility, wtSplashScreen);


    TWMWindow=class(TObject)
    public
        display: TWMDisplay;
        screen: TWMScreen;
        xwindow: Window;
        frame: TWMFrame;
        depth: integer;
        xvisual: PVisual;
        colormap: Colormap;
        desc: string;
        title: string;
        icon_name: string;
        icon: TBitmap;
        mini_icon: TBitmap;
        wtype: TXPWindowType;

        //Pixmap wm_hints_pixmap;
        //Pixmap wm_hints_mask;
        type_atom: Atom;

        xtransient_for:Window;
        xgroup_leader:Window;
        xclient_leader:Window;

        minimized: boolean;
        maximized: boolean;
        shaded: boolean;
        fullscreen: boolean;
        mapped: boolean;
        iconic: boolean;
        initially_iconic:boolean;

        take_focus:boolean;
        delete_window:boolean;
        net_wm_ping:boolean;
        input: boolean;

        mwm_decorated : boolean;
        mwm_border_only : boolean;
        mwm_has_close_func : boolean;
        mwm_has_minimize_func : boolean;
        mwm_has_maximize_func : boolean;
        mwm_has_move_func : boolean;
        mwm_has_resize_func : boolean;

        decorated : boolean;
        border_only : boolean;
        always_sticky : boolean;
        has_close_func : boolean;
        has_minimize_func : boolean;
        has_maximize_func : boolean;
        has_shade_func : boolean;
        has_move_func : boolean;
        has_resize_func : boolean;
        has_fullscreen_func : boolean;

        wm_state_modal : boolean;

        wm_state_skip_taskbar : boolean;
        wm_state_skip_pager : boolean;

        // TRUE if client set these
        wm_state_above : boolean;
        wm_state_below : boolean;

        {* this flag tracks receipt of focus_in focus_out and
         * determines whether we draw the focus
         *}
        has_focus : boolean;

        {* Track whether the user has ever manually modified
         * the window; if so, we can use the saved user size/pos
         *}
        user_has_move_resized : boolean;

        // Have we placed this window?
        placed : boolean;

        // Are we in meta_window_free()?
        unmanaging : boolean;

        // Are we in the calc_showing queue?
        calc_showing_queued : boolean;

        // Are we in the move_resize queue?
        move_resize_queued : boolean;

        // Used by keybindings.c
        keys_grabbed : boolean;     // normal keybindings grabbed
        grab_on_frame : boolean;    // grabs are on the frame
        all_keys_grabbed : boolean; // AnyKey grabbed

        {* Set if the reason for unmanaging the window is that
         * it was withdrawn
         *}
        withdrawn : boolean;

        {* TRUE if constrain_position should calc placement.
         * only relevant if !window->placed
         *}
        calc_placement : boolean;

        // Has nonzero struts
        has_struts : boolean;
        // Struts are from the _WIN_HINTS do not cover deal
        do_not_cover : boolean;

        // Transient parent is a root window
        transient_parent_is_root_window : boolean;

        {* Number of UnmapNotify that are caused by us, if
         * we get UnmapNotify with none pending then the client
         * is withdrawing the window.
         *}
        unmaps_pending:integer;

       {* The size we set the window to last (i.e. what we believe
        * to be its actual size on the server). The x, y are
        * the actual server-side x,y so are relative to the frame
        * or the root window as appropriate.
        *}
       rect:TRect;

       {* The geometry to restore when we unmaximize.
        * The position is in root window coords, even if
        * there's a frame, which contrasts with window->rect
        * above.
        *}
       saved_rect:TRect;

       {* This is the geometry the window had after the last user-initiated
        * move/resize operations. We use this whenever we are moving the
        * implicitly (for example, if we move to avoid a panel, we
        * can snap back to this position if the panel moves again)
        *
        * Position valid if user_has_moved, size valid if user_has_resized
        *
        * Position always in root coords, unlike window->rect
        *}
       user_rect:TRect;

       // Requested geometry
       border_width:integer;

       // x/y/w/h here get filled with ConfigureRequest values
       size_hints:XSizeHints;

       // struts
       left_strut:integer;
       right_strut:integer;
       top_strut:integer;
       bottom_strut:integer;

       // Current dialog open for this window
       dialog_pid:integer;
       dialog_pipe:integer;
       function new(display:TWMDisplay;xwindow:Window;must_be_viewable:boolean):boolean;
       procedure update_size_hints;
       procedure update_title;
       procedure unminimize;
       procedure ensure_frame;
       constructor Create;
       destructor Destroy;override;
    end;

    TWMScreen=class(TObject)
    public
        display: TWMDisplay;
        number:integer;
        screen_name:string;
        xscreen: PScreen;
        xroot: Window;
        default_depth: integer;
        default_xvisual: PVisual;
        width: integer;
        height: integer;

        {
        MetaUI *ui;
        MetaTabPopup *tab_popup;
        MetaWorkspace *active_workspace;
        GList *workspaces;
        MetaStack *stack;
        MetaCursor current_cursor;
        }

        wm_sn_selection_window:Window;
        wm_sn_atom: Atom;
        wm_sn_timestamp: TTime;

        keys_grabbed : boolean;
        all_keys_grabbed : boolean;
        showing_desktop : boolean;

        closing: integer;

        procedure create_new(display:TWMDisplay;number:integer);
        function set_wm_icon_size_hint: integer;
        function set_supported_hint:integer;
        function set_wm_check_hint:integer;
        function create_offscreen_window(ADisplay: PDisplay; parent: Window):Window;
    end;

    TWMFrame=class(TObject)
    public
        // window we frame
        window: TWMWindow;
        // reparent window
        xwindow: Window;
        // title to move the window
        titleform: TTitleForm;


        //MetaCursor current_cursor;

        {* This rect is trusted info from where we put the
         * frame, not the result of ConfigureNotify
         *}
        rect: TRect;

        // position of client, size of frame
        child_x: integer;
        child_y: integer;
        right_width: integer;
        bottom_height: integer;

        mapped : boolean;
    end;


var
    sync_count: integer=0;

implementation

{ TWMScreen }

//Handles errors from X11
function handleXerror(var dpy:Display;var e:XErrorEvent):integer;
{
var
    c: TXClient;
}
begin
{
        c:=wm.findClient(e.resourceid);

        if (e.error_code=BadAccess) and (e.request_code=2) then begin
		    writeln('Another window manager seems to be running');
            result:=1;
		    exit;
    	end;
	    writeln(format('MISC: xerror %d...', [e.error_code]));

        if assigned(c) then begin
		    writeln('      (removing client)');
		    wm.removeClient(c, NOT_QUITTING);
    	end;
     	result:=0;
}        
end;

function TWMScreen.create_offscreen_window(ADisplay: PDisplay; parent: Window):Window;
var
    attrs: XSetWindowAttributes;
begin
  {* we want to be override redirect because sometimes we
   * create a window on a screen we aren't managing.
   * (but on a display we are managing at least one screen for)
   *}
  attrs.override_redirect := 1;

  result:=XCreateWindow (ADisplay,
                        parent,
                        -100, -100, 1, 1,
                        0,
                        CopyFromParent,
                        CopyFromParent,
                        nil,
                        CWOverrideRedirect,
                        @attrs);
end;

procedure error_trap_push_internal (display: TWMDisplay; need_sync:boolean);
var
    old_error_handler: XErrorHandler;
begin
  if (need_sync) then begin
    XSync (display.xdisplay, 0);
    dec(sync_count);
  end;

  {* old_error_handler will just be equal to x_error_handler
   * for nested traps
   *}
  old_error_handler := XSetErrorHandler (@handleXerror);

  // Replace GDK handler, but save it so we can chain up
  if not (assigned(display.error_trap_handler)) then begin
      display.error_trap_handler := old_error_handler;
  end;

  display.error_traps:=display.error_traps+1;
end;



procedure error_trap_push_with_return (display: TWMDisplay);
var
    need_sync: boolean;
begin
  {* We don't sync on push_with_return if there are no traps
   * currently, because we assume that any errors were either covered
   * by a previous pop, or were fatal.
   *
   * More generally, we don't sync if we were synchronized last time
   * we popped. This is known to be the case if there are no traps,
   * but we also keep a flag so we know whether it's the case otherwise.
   *}

  if not (display.error_trap_synced_at_last_pop) then need_sync := true
  else need_sync := false;

  {
  if (need_sync)
    meta_topic (META_DEBUG_SYNC, "%d: Syncing on error_trap_push_with_return, traps = %d\n",
                sync_count, display->error_traps);
  }

  error_trap_push_internal (display, FALSE);
end;

function  error_trap_pop_internal(display:TWMDisplay;need_sync:boolean):integer;
begin
  if (need_sync) then begin
      XSync (display.xdisplay, 0);
      inc(sync_count);
  end;
  result:=0;
end;


function error_trap_pop_with_return  (display:TWMDisplay;last_request_was_roundtrip:boolean):integer;
begin
  display.error_trap_synced_at_last_pop := true;

  result:=error_trap_pop_internal (display, not last_request_was_roundtrip);
end;

function TWMScreen.set_wm_icon_size_hint: integer;
const
    N_VALS=6;
var
    vals:array[0..N_VALS] of integer;
begin
  // min width, min height, max w, max h, width inc, height inc
  vals[0] := META_ICON_WIDTH;
  vals[1] := META_ICON_HEIGHT;
  vals[2] := META_ICON_WIDTH;
  vals[3] := META_ICON_HEIGHT;
  vals[4] := 0;
  vals[5] := 0;

  XChangeProperty (display.xdisplay, xroot,
                   display.atom_wm_icon_size,
                   XA_CARDINAL,
                   32, PropModeReplace, @vals, N_VALS);

  result:=Success;
end;

function TWMScreen.set_supported_hint:integer;
const
  N_SUPPORTED=44;
  N_WIN_SUPPORTED=1;
var
  atoms: array [0..N_SUPPORTED] of Atom;
begin
  atoms[0] := display.atom_net_wm_name;
  atoms[1] := display.atom_net_close_window;
  atoms[2] := display.atom_net_wm_state;
  atoms[3] := display.atom_net_wm_state_shaded;
  atoms[4] := display.atom_net_wm_state_maximized_vert;
  atoms[5] := display.atom_net_wm_state_maximized_horz;
  atoms[6] := display.atom_net_wm_desktop;
  atoms[7] := display.atom_net_number_of_desktops;
  atoms[8] := display.atom_net_current_desktop;
  atoms[9] := display.atom_net_wm_window_type;
  atoms[10] := display.atom_net_wm_window_type_desktop;
  atoms[11] := display.atom_net_wm_window_type_dock;
  atoms[12] := display.atom_net_wm_window_type_toolbar;
  atoms[13] := display.atom_net_wm_window_type_menu;
  atoms[14] := display.atom_net_wm_window_type_dialog;
  atoms[15] := display.atom_net_wm_window_type_normal;
  atoms[16] := display.atom_net_wm_state_modal;
  atoms[17] := display.atom_net_client_list;
  atoms[18] := display.atom_net_client_list_stacking;
  atoms[19] := display.atom_net_wm_state_skip_taskbar;
  atoms[20] := display.atom_net_wm_state_skip_pager;
  atoms[21] := display.atom_net_wm_icon;
  atoms[22] := display.atom_net_wm_moveresize;
  atoms[23] := display.atom_net_wm_state_hidden;
  atoms[24] := display.atom_net_wm_window_type_utility;
  atoms[25] := display.atom_net_wm_window_type_splashscreen;
  atoms[26] := display.atom_net_wm_state_fullscreen;
  atoms[27] := display.atom_net_wm_ping;
  atoms[28] := display.atom_net_active_window;
  atoms[29] := display.atom_net_workarea;
  atoms[30] := display.atom_net_showing_desktop;
  atoms[31] := display.atom_net_desktop_layout;
  atoms[32] := display.atom_net_desktop_names;
  atoms[33] := display.atom_net_wm_allowed_actions;
  atoms[34] := display.atom_net_wm_action_move;
  atoms[35] := display.atom_net_wm_action_resize;
  atoms[36] := display.atom_net_wm_action_shade;
  atoms[37] := display.atom_net_wm_action_stick;
  atoms[38] := display.atom_net_wm_action_maximize_horz;
  atoms[39] := display.atom_net_wm_action_maximize_vert;
  atoms[40] := display.atom_net_wm_action_change_desktop;
  atoms[41] := display.atom_net_wm_action_close;
  atoms[42] := display.atom_net_wm_state_above;
  atoms[43] := display.atom_net_wm_state_below;
  
  XChangeProperty (display.xdisplay, xroot,
                   display.atom_net_supported,
                   XA_ATOM,
                   32, PropModeReplace,@atoms, N_SUPPORTED);

  // Set legacy GNOME hints
  atoms[0] := display.atom_win_layer;

  XChangeProperty (display.xdisplay, xroot,
                   display.atom_win_protocols,
                   XA_ATOM,
                   32, PropModeReplace, @atoms, N_WIN_SUPPORTED);

  result:=Success;
end;

function TWMScreen.set_wm_check_hint:integer;
var
    data:array[0..1] of integer;
begin
    if display.leader_window=none then exit;

  data[0] := display.leader_window;

  XChangeProperty (display.xdisplay, xroot,
                   display.atom_net_supporting_wm_check,
                   XA_WINDOW,
                   32, PropModeReplace, @data, 1);

  // Legacy GNOME hint (uses cardinal, dunno why)

  {* do this after setting up window fully, to avoid races
   * with clients listening to property notify on root.
   *}
  XChangeProperty (display.xdisplay, xroot,
                   display.atom_win_supporting_wm_check,
                   XA_CARDINAL,
                   32, PropModeReplace, @data, 1);

  result:=Success;
end;


procedure TWMScreen.create_new(display: TWMDisplay; number:integer);
var
    xroot: Window;
    xdisplay: PDisplay;
    attr:XWindowAttributes;
    attrs: XSetWindowAttributes;
    event: XEvent;
    new_wm_sn_owner: Window;
    current_wm_sn_owner: Window;
    wm_sn_atom: Atom;
    buf: string;
    manager_timestamp: TTime;
    ev: XClientMessageEvent;
begin
  {* Only display.name, display.xdisplay, and display.error_traps
   * can really be used in this function, since normally screens are
   * created from the MetaDisplay constructor
   *}
  xdisplay := display.xdisplay;
  xroot := XRootWindow (xdisplay, number);

  buf:='WM_S'+inttostr(number);
  wm_sn_atom := XInternAtom (xdisplay, PChar(buf), 0);
  current_wm_sn_owner := XGetSelectionOwner (xdisplay, wm_sn_atom);

  if (current_wm_sn_owner <> None) then begin
    XPAPI.outputdebugstring('There is already a window manager active!!');
    exit;
  end;

//  new_wm_sn_owner := create_offscreen_window (xdisplay, xroot);
  new_wm_sn_owner := xroot;


    // Generate a timestamp
    attrs.event_mask := PropertyChangeMask;
    XChangeWindowAttributes (xdisplay, new_wm_sn_owner, CWEventMask, @attrs);

    XChangeProperty (xdisplay, new_wm_sn_owner, XA_WM_CLASS, XA_STRING, 8,
                     PropModeAppend, nil, 0);

    XWindowEvent (xdisplay, new_wm_sn_owner, PropertyChangeMask, @event);

    attrs.event_mask := NoEventMask;

    XChangeWindowAttributes (display.xdisplay, new_wm_sn_owner, CWEventMask, @attrs);

    manager_timestamp := event.xproperty.time;

  XSetSelectionOwner (xdisplay, wm_sn_atom, new_wm_sn_owner,
                      manager_timestamp);

  if (XGetSelectionOwner (xdisplay, wm_sn_atom) <> new_wm_sn_owner) then begin
      XPAPI.OutputDebugString('Could not acquire window manager selection');
      XDestroyWindow (xdisplay, new_wm_sn_owner);
      exit;
    end;


    // Send client message indicating that we are now the WM
    ev.xtype := ClientMessage;
    ev.xwindow := xroot;
    ev.message_type := display.atom_manager;
    ev.format := 32;
    ev.data.l[0] := manager_timestamp;
    ev.data.l[1] := wm_sn_atom;


    XSendEvent (xdisplay, xroot, 0, StructureNotifyMask, @ev);

    // select our root window events
    error_trap_push_with_return (display);

  {* We need to or with the existing event mask since
   * gtk+ may be interested in other events.
   *}
  XGetWindowAttributes (xdisplay, xroot, @attr);
  XSelectInput (xdisplay,
                xroot,
                SubstructureRedirectMask or SubstructureNotifyMask or
                ColormapChangeMask or PropertyChangeMask or
                LeaveWindowMask or EnterWindowMask or
                ButtonPressMask or ButtonReleaseMask or
                KeyPressMask or KeyReleaseMask or
                FocusChangeMask or StructureNotifyMask or attr.your_event_mask);


(*
   if (error_trap_pop_with_return (display, false) <> Success)
    {
      meta_warning (_("Screen %d on display \"%s\" already has a window manager\n"),
                    number, display.name);

      XDestroyWindow (xdisplay, new_wm_sn_owner);

      return NULL;
    }
*)
  self.closing := 0;

  self.display := display;
  self.number := number;
//  self.screen_name := get_screen_name (display, number);
  self.screen_name := '';
  self.xscreen := XScreenOfDisplay (xdisplay, number);
  self.xroot := xroot;
  self.width := XWidthOfScreen (self.xscreen);
  self.height := XHeightOfScreen (self.xscreen);
  self.default_xvisual := XDefaultVisualOfScreen (self.xscreen);
  self.default_depth := XDefaultDepthOfScreen (self.xscreen);

  self.wm_sn_selection_window := new_wm_sn_owner;
  self.wm_sn_atom := wm_sn_atom;
  self.wm_sn_timestamp := manager_timestamp;

  self.showing_desktop := false;

//  meta_screen_set_cursor (screen, META_CURSOR_DEFAULT);

  if (display.leader_window = None) then display.leader_window := create_offscreen_window (display.xdisplay, self.xroot);

  if (display.no_focus_window = None) then begin
      display.no_focus_window := create_offscreen_window (display.xdisplay, self.xroot);

      XSelectInput (display.xdisplay, display.no_focus_window, FocusChangeMask or KeyPressMask or KeyReleaseMask);
      XMapWindow (display.xdisplay, display.no_focus_window);
  end;

  set_wm_icon_size_hint;


  set_supported_hint;

  set_wm_check_hint;

  {
  self.all_keys_grabbed := FALSE;
  self.keys_grabbed := FALSE;
  meta_screen_grab_keys (screen);


  self.ui := meta_ui_new (self.display.xdisplay,
                            self.xscreen);

  self.tab_popup := NULL;

  self.stack := meta_stack_new (screen);
  }
end;

// Grab/ungrab routines taken from fvwm
procedure TWMDisplay.grab;
begin
  if (server_grab_count = 0) then begin
      XSync (xdisplay, 0);
      XGrabServer (xdisplay);
  end;
  XSync (xdisplay, 0);
  inc(server_grab_count);
end;

procedure TWMDisplay.ungrab;
begin
  if (server_grab_count = 0) then XPAPI.outputdebugstring('Ungrabbed non-grabbed server');

  dec(server_grab_count);
  if (server_grab_count = 0) then begin
      {* FIXME we want to purge all pending "queued" stuff
       * at this point, such as window hide/show
       *}
      XSync (xdisplay, 0);
      XUngrabServer (xdisplay);
  end;
  XSync (xdisplay, 0);
end;

function TWMDisplay.lookup_x_window(xwindow:Window):TWMWindow;
var
    i: integer;
begin
    i:=window_ids.IndexOf(inttostr(xwindow));
    if i<>-1 then result:=TWMWindow(window_ids.objects[i])
    else result:=nil;
end;

procedure TWMDisplay.register_x_window (xwindowp: Window; window:TWMWindow);
begin
    if (lookup_x_window(xwindowp)=nil) then begin
        window_ids.addobject(inttostr(xwindowp),window);
    end;
end;

procedure TWMdisplay.unregister_x_window(xwindow:Window);
var
    i:integer;
begin
    i:=window_ids.indexof(inttostr(xwindow));
    if i<>-1 then begin
        window_ids.delete(i);
    end;
    //remove_pending_pings_for_window (display, xwindow);
end;



constructor TWMDisplay.Create;
begin
    inherited;
    window_ids:=TStringList.create;
end;

destructor TWMDisplay.Destroy;
begin
  window_ids.free;
  inherited;
end;

{ TWMWindow }

constructor TWMWindow.Create;
begin
    inherited;
end;

destructor TWMWindow.Destroy;
begin
  inherited;
end;

type
    GetPropertyResults=record
        display: TWMDisplay;
        xwindow: Window;
        xatom: Atom;
        xtype: Atom;
        format:integer;
        n_items: integer;
        bytes_after: integer;
        prop: PChar;
    end;

function get_property(display: TWMDisplay;xwindow:Window;xatom:Atom;req_type:Atom;var results:GetPropertyResults):boolean;
begin
  results.display := display;
  results.xwindow := xwindow;
  results.xatom := xatom;
  results.prop := nil;
  results.n_items := 0;
  results.xtype := None;
  results.bytes_after := 0;
  results.format := 0;

//  meta_error_trap_push_with_return (display);
  if (XGetWindowProperty (display.xdisplay, xwindow, xatom,
                          0, MaxLongint,
                          0, req_type, @results.xtype, @results.format,
                          @results.n_items,
                          @results.bytes_after,
                          @results.prop) <> Success) or (results.xtype = None) then begin
      if (results.prop<>nil) then XFree(results.prop);
      //meta_error_trap_pop_with_return (display, TRUE);
      result:=false;
      exit;
    end;

(*
  if (meta_error_trap_pop_with_return (display, TRUE) != Success)
    {
      if (results.prop)
        XFree (results.prop);
      return FALSE;
    }
*)
    result:=true;
end;

function validate_or_free_results (var results: GetPropertyResults; expected_format: integer; expected_type: Atom; must_have_items:boolean):boolean;
var
    type_name:PChar;
    expected_name:PChar;
    prop_name: PChar;
begin
  if (expected_format = results.format) and (expected_type =results.xtype) and ((not must_have_items or (results.n_items > 0))) then begin
    result:=true;
    exit;
  end;

//  meta_error_trap_push (results.display);
  type_name := XGetAtomName (results.display.xdisplay, results.xtype);
  expected_name := XGetAtomName (results.display.xdisplay, expected_type);
  prop_name := XGetAtomName (results.display.xdisplay, results.xatom);
//  meta_error_trap_pop (results.display, TRUE);

{
  meta_warning (_("Window 0x%lx has property %s that was expected to have type %s format %d and actually has type %s format %d n_items %d\n"),
                results.xwindow,
                prop_name ? prop_name : "(bad atom)",
                expected_name ? expected_name : "(bad atom)",
                expected_format,
                type_name ? type_name : "(bad atom)",
                results.format, (int) results.n_items);
}
  if (type_name<>nil) then XFree (type_name);
  if (expected_name<>nil)  then XFree (expected_name);
  if (prop_name<>nil) then XFree (prop_name);

  result:=false;
end;

type
    xPropSizeHints=record
        flags:integer;
        x,y,width,height: integer;
        minWidth, minHeight: integer;
        maxWidth, maxHeight: integer;
        widthInc, heightInc: integer;
        minAspectX, minAspectY: integer;
        maxAspectX, maxAspectY: integer;
        baseWidth, baseHeight: integer;
        winGravity: integer;
    end;

const
   OldNumPropSizeElements=15;
   NumPropSizeElements=18;

function cvtInt32toInt(val:integer):integer;
begin
    if ((val and $80000000)=$80000000) then result:=(val or $FFFFFFFF00000000)
    else result:=val;
end;

function size_hints_from_results(var results:GetPropertyResults;var hints_p:PXSizeHints;var flags_p:integer):boolean;
var
    raw: XPropSizeHints;
    hints: XSizeHints;
begin
//  *hints_p = NULL;
  flags_p:= 0;

  if not (validate_or_free_results (results, 32, XA_WM_SIZE_HINTS, FALSE)) then begin
    result:=false;
    exit;
  end;

  if (results.n_items < OldNumPropSizeElements) then begin
    result:=false;
    exit;
  end;

//  raw := xPropSizeHints(results.prop^);

  // XSizeHints misdeclares these as int instead of long

  hints.flags := raw.flags;
  hints.x := cvtINT32toInt (raw.x);
  hints.y := cvtINT32toInt (raw.y);
  hints.width := cvtINT32toInt (raw.width);
  hints.height := cvtINT32toInt (raw.height);
  hints.min_width  := cvtINT32toInt (raw.minWidth);
  hints.min_height := cvtINT32toInt (raw.minHeight);
  hints.max_width  := cvtINT32toInt (raw.maxWidth);
  hints.max_height := cvtINT32toInt (raw.maxHeight);
  hints.width_inc  := cvtINT32toInt (raw.widthInc);
  hints.height_inc := cvtINT32toInt (raw.heightInc);
  hints.min_aspect.x := cvtINT32toInt (raw.minAspectX);
  hints.min_aspect.y := cvtINT32toInt (raw.minAspectY);
  hints.max_aspect.x := cvtINT32toInt (raw.maxAspectX);
  hints.max_aspect.y := cvtINT32toInt (raw.maxAspectY);


  flags_p := (USPosition or USSize or PAllHints);
  if (results.n_items >= NumPropSizeElements) then begin
      hints.base_width:= cvtINT32toInt (raw.baseWidth);
      hints.base_height:= cvtINT32toInt (raw.baseHeight);
      hints.win_gravity:= cvtINT32toInt (raw.winGravity);
      flags_p := (flags_p or (PBaseSize or PWinGravity));
  end;

  hints.flags := (hints.flags and flags_p);	// get rid of unwanted bits

  XFree (results.prop);
  results.prop := nil;

  hints_p^ := hints;

  result:=true;
end;

function prop_get_size_hints(display:TWMDisplay;xwindow:Window;xatom:Atom;var hints_p:PXSizeHints;var flags_p:integer):boolean;
var
    results: GetPropertyResults;
begin
//  hints_p^:=nil;
  flags_p:=0;

  if not (get_property (display, xwindow, xatom, XA_WM_SIZE_HINTS, results)) then begin
    result:=false;
  end
  else begin
    result:=size_hints_from_results (results, hints_p, flags_p);
  end;
end;

function utf8_string_from_results (var results: GetPropertyResults; var str_p:PChar):boolean;
begin
    str_p := nil;

    if not (validate_or_free_results (results, 8, results.display.atom_utf8_string, false)) then begin
        result:=false;
        exit;
    end;

    if (results.n_items > 0) then begin
//      !g_utf8_validate (results->prop, results->n_items, NULL))
//      char *name;

//      name = XGetAtomName (results->display->xdisplay, results->xatom);
//      meta_warning (_("Property %s on window 0x%lx contained invalid UTF-8\n"),
//                    name, results->xwindow);
//      meta_XFree (name);
        XFree (results.prop);
        results.prop := nil;

        result:=false;
        exit;
    end;

  str_p := results.prop;
  results.prop := nil;
    result:=true;
end;


function prop_get_utf8_string (display:TWMDisplay;xwindow:Window;xatom:Atom;var str_p:PChar):boolean;
var
  results:GetPropertyResults;
begin
  str_p:=nil;

  if not (get_property (display, xwindow, xatom, display.atom_utf8_string, results)) then begin
    result:=false;
    exit;
  end;

  result:=utf8_string_from_results (results, str_p);
end;

procedure TWMWindow.update_size_hints;
var
  x, y, w, h:integer;
  supplied: integer;
  old_hints: XSizeHints;
  new_hints: PXSizeHints;
begin
  old_hints:=self.size_hints;

  {* Save the last ConfigureRequest, which we put here.
   * Values here set in the hints are supposed to
   * be ignored.
   *}
  x := self.size_hints.x;
  y := self.size_hints.y;
  w := self.size_hints.width;
  h := self.size_hints.height;

  self.size_hints.flags := 0;
  supplied := 0;

  prop_get_size_hints (self.display,
                            self.xwindow,
                            XA_WM_NORMAL_HINTS,
                            new_hints,
                            supplied);

  {* as far as I can tell, "supplied" is just to check whether we had
   * old-style normal hints without gravity, base size as returned by
   * XGetNormalHints(), so we don't really use it as we fixup
   * self.size_hints to have those fields if they're missing.
   *}

  if (new_hints <>nil) then begin
      self.size_hints := new_hints^;
      XFree (new_hints);
      new_hints := nil;
  end;

  // Put back saved ConfigureRequest.
  self.size_hints.x := x;
  self.size_hints.y := y;
  self.size_hints.width := w;
  self.size_hints.height := h;

  if (self.size_hints.flags and PBaseSize)= PBaseSize then begin
    {
      meta_topic (META_DEBUG_GEOMETRY, "Window %s sets base size %d x %d\n",
                  self.desc,
                  self.size_hints.base_width,
                  self.size_hints.base_height);
                  }
  end
  else if (self.size_hints.flags and PMinSize)=PMinSize then begin
      self.size_hints.base_width := self.size_hints.min_width;
      self.size_hints.base_height := self.size_hints.min_height;
  end
  else begin
      self.size_hints.base_width := 0;
      self.size_hints.base_height := 0;
  end;

  self.size_hints.flags := self.size_hints.flags or PBaseSize;

  if (self.size_hints.flags and PMinSize)=PMinSize then begin
    {
      meta_topic (META_DEBUG_GEOMETRY, "Window %s sets min size %d x %d\n",
                  self.desc,
                  self.size_hints.min_width,
                  self.size_hints.min_height);
                  }
  end
  else if (self.size_hints.flags and PBaseSize)=PBaseSize then begin
      self.size_hints.min_width := self.size_hints.base_width;
      self.size_hints.min_height := self.size_hints.base_height;
  end
  else begin
      self.size_hints.min_width := 0;
      self.size_hints.min_height := 0;
  end;
  self.size_hints.flags := self.size_hints.flags or PMinSize;

  if (self.size_hints.flags and PMaxSize)=PMaxSize then begin
    {
      meta_topic (META_DEBUG_GEOMETRY, "Window %s sets max size %d x %d\n",
                  self.desc,
                  self.size_hints.max_width,
                  self.size_hints.max_height);
    }
  end
  else begin
      self.size_hints.max_width := MaxInt;
      self.size_hints.max_height := MaxInt;
      self.size_hints.flags := self.size_hints.flags or PMaxSize;
  end;

  if (self.size_hints.max_width < self.size_hints.min_width) then begin
      // someone is on crack */
      {
      meta_topic (META_DEBUG_GEOMETRY,
                  "Window %s sets max width %d less than min width %d, disabling resize\n",
                  self.desc,
                  self.size_hints.max_width,
                  self.size_hints.min_width);
      }
      self.size_hints.max_width := self.size_hints.min_width;
  end;

  if (self.size_hints.max_height < self.size_hints.min_height) then begin
      // another cracksmoker
      {
      meta_topic (META_DEBUG_GEOMETRY,
                  "Window %s sets max height %d less than min height %d, disabling resize\n",
                  self.desc,
                  self.size_hints.max_height,
                  self.size_hints.min_height);
      }
      self.size_hints.max_height := self.size_hints.min_height;
  end;

  if (self.size_hints.flags and PResizeInc)=PResizeInc then begin
      {
      meta_topic (META_DEBUG_GEOMETRY, "Window %s sets resize width inc: %d height inc: %d\n",
                  self.desc,
                  self.size_hints.width_inc,
                  self.size_hints.height_inc);
      }
      if (self.size_hints.width_inc = 0) then begin
          self.size_hints.width_inc := 1;
          //meta_topic (META_DEBUG_GEOMETRY, "Corrected 0 width_inc to 1\n");
      end;
      if (self.size_hints.height_inc = 0) then begin
          self.size_hints.height_inc := 1;
          //meta_topic (META_DEBUG_GEOMETRY, "Corrected 0 height_inc to 1\n");
      end;
  end
  else begin
      self.size_hints.width_inc := 1;
      self.size_hints.height_inc := 1;
      self.size_hints.flags := self.size_hints.flags or PResizeInc;
  end;
  
  if (self.size_hints.flags and PAspect)= PAspect then begin
    {
      meta_topic (META_DEBUG_GEOMETRY, "Window %s sets min_aspect: %d/%d max_aspect: %d/%d\n",
                  self.desc,
                  self.size_hints.min_aspect.x,
                  self.size_hints.min_aspect.y,
                  self.size_hints.max_aspect.x,
                  self.size_hints.max_aspect.y);
      }

      // don't divide by 0
      if (self.size_hints.min_aspect.y < 1) then self.size_hints.min_aspect.y := 1;
      if (self.size_hints.max_aspect.y < 1) then self.size_hints.max_aspect.y := 1;
  end
  else begin
      self.size_hints.min_aspect.x := 1;
      self.size_hints.min_aspect.y := maxint;
      self.size_hints.max_aspect.x := MAXINT;
      self.size_hints.max_aspect.y := 1;
      self.size_hints.flags := self.size_hints.flags or PAspect;
  end;

  if (self.size_hints.flags and PWinGravity)=PWinGravity then begin
    {
      meta_topic (META_DEBUG_GEOMETRY, "Window %s sets gravity %d\n",
                  self.desc,
                  self.size_hints.win_gravity);
    }
  end
  else begin
    {
      meta_topic (META_DEBUG_GEOMETRY, "Window %s doesn't set gravity, using NW\n",
                  self.desc);
      }
      self.size_hints.win_gravity := NorthWestGravity;
      self.size_hints.flags := self.size_hints.flags or PWinGravity;
  end;

//  recalc_window_features (window);
//  spew_size_hints_differences (&old_hints, &self.size_hints);
end;

function TWMWindow.new(display: TWMDisplay; xwindow: Window; must_be_viewable: boolean):boolean;
var
  attrs:XWindowAttributes;
  existing_wm_state: integer;
  state: integer;
  p_attr:XSetWindowAttributes;  
  set_attrs: XSetWindowAttributes;  
//  initial_props: array[0..1] of integer;
//  MetaPropValue initial_props[N_INITIAL_PROPS];

begin
{
#define INITIAL_PROP_WM_CLIENT_MACHINE 0
  initial_props[0].type := META_PROP_VALUE_STRING;
  initial_props[0].atom := display.atom_wm_client_machine;

#define INITIAL_PROP_NET_WM_PID 1
  initial_props[1].type := META_PROP_VALUE_CARDINAL;
  initial_props[1].atom := display.atom_net_wm_pid;

  meta_verbose ("Attempting to manage 0x%lx\n", xwindow);
}

  // Grab server
  display.grab;
  {
  meta_error_trap_push (display); /* Push a trap over all of window
                                   * creation, to reduce XSync() calls
                                   */

  meta_error_trap_push_with_return (display);
  }

  XGetWindowAttributes (display.xdisplay, xwindow, @attrs);

  (*
  if (meta_error_trap_pop_with_return (display, TRUE) != Success)
    {
      meta_verbose ("Failed to get attributes for window 0x%lx\n",
                    xwindow);
      meta_error_trap_pop (display, TRUE);
      meta_display_ungrab (display);
      return NULL;
    }
  *)

  if (attrs.override_redirect<>0) then begin
      //meta_verbose ("Deciding not to manage override_redirect window 0x%lx\n", xwindow);
      //meta_error_trap_pop (display, TRUE);
      display.ungrab;
      result:=false;
      exit;
  end;


  (*
  meta_verbose ("must_be_viewable := %d attrs.map_state := %d (%s)\n",
                must_be_viewable,
                attrs.map_state,
                (attrs.map_state == IsUnmapped) ?
                "IsUnmapped" :
                (attrs.map_state == IsViewable) ?
                "IsViewable" :
                (attrs.map_state == IsUnviewable) ?
                "IsUnviewable" :
                "(unknown)");
  *)


  existing_wm_state := WithdrawnState;
  if (must_be_viewable) and  (attrs.map_state <> IsViewable) then begin
      // Only manage if WM_STATE is IconicState or NormalState

      // WM_STATE isn't a cardinal, it's type WM_STATE, but is an int
      {
      if (!(meta_prop_get_cardinal_with_atom_type (display, xwindow,
                                                   display.atom_wm_state,
                                                   display.atom_wm_state,
                                                   &state) && (state == IconicState || state == NormalState))) then begin
          meta_verbose ("Deciding not to manage unmapped or unviewable window 0x%lx\n", xwindow);
          meta_error_trap_pop (display, TRUE);
          meta_display_ungrab (display);
          return NULL;
      end;
      }

      existing_wm_state := state;
//      meta_verbose ("WM_STATE of %lx := %s\n", xwindow, wm_state_to_string (existing_wm_state));
    end;


//  meta_error_trap_push_with_return (display);
  XSelectInput (display.xdisplay, xwindow,
                PropertyChangeMask or
                EnterWindowMask or  LeaveWindowMask or
                FocusChangeMask);

  XAddToSaveSet (display.xdisplay, xwindow);

  //  Get rid of any borders
  if (attrs.border_width <>0) then XSetWindowBorderWidth (display.xdisplay, xwindow, 0);

  // Get rid of weird gravities

  if (attrs.win_gravity <> NorthWestGravity) then begin

      set_attrs.win_gravity := NorthWestGravity;

      XChangeWindowAttributes (display.xdisplay,
                               xwindow,
                               CWWinGravity,
                               @set_attrs);
  end;


(*
  if (meta_error_trap_pop_with_return (display, FALSE) != Success)
    {
      meta_verbose ("Window 0x%lx disappeared just as we tried to manage it\n",
                    xwindow);
      meta_error_trap_pop (display, FALSE);
      meta_display_ungrab (display);
      return NULL;
    }
*)

//  g_assert (!attrs.override_redirect);

  self.dialog_pid := -1;
  self.dialog_pipe := -1;

  self.xwindow:= xwindow;

  {* this is in window.screen.display, but that's too annoying to
   * type
   *}
  self.display := display;

  self.screen := nil;
  (*
  tmp := display.screens;
  while (tmp != NULL)
    {
      MetaScreen *scr := tmp.data;

      if (scr.xroot == attrs.root)
        {
          window.screen := tmp.data;
          break;
        }

      tmp := tmp.next;
    }

  g_assert (window.screen);



  /* avoid tons of stack updates */
  meta_stack_freeze (window.screen.stack);
  *)

  // Remember this rect is the actual window size

  self.rect.left := attrs.x;
  self.rect.top := attrs.y;
  self.rect.right:= attrs.x+attrs.width;
  self.rect.bottom:= attrs.y+attrs.height;

  self.size_hints.flags := 0;

  // And border width, size_hints are the "request"
  self.border_width := attrs.border_width;
  self.size_hints.x := attrs.x;
  self.size_hints.y := attrs.y;
  self.size_hints.width := attrs.width;
  self.size_hints.height := attrs.height;

  // And this is our unmaximized size
  self.saved_rect := self.rect;
  self.user_rect := self.rect;

  self.depth := attrs.depth;
  self.xvisual := attrs.visual;
  self.colormap := attrs.colormap;

  self.title := '';
  self.icon_name := '';
  self.icon := nil;
  self.mini_icon := nil;
//  meta_icon_cache_init (&self.icon_cache);
//  self.wm_hints_pixmap := None;
//  self.wm_hints_mask := None;

  self.desc:='0x'+inttostr(self.xwindow);

  self.frame := nil;

  self.has_focus := false;

  self.user_has_move_resized := false;

  self.maximized := FALSE;
  self.fullscreen := FALSE;
  self.shaded := FALSE;
  self.initially_iconic := FALSE;
  self.minimized := FALSE;
  self.iconic := FALSE;
  self.mapped := (attrs.map_state <> IsUnmapped);
  // if already mapped we don't want to do the placement thing
  self.placed := self.mapped;
  self.unmanaging := FALSE;
  self.calc_showing_queued := FALSE;
  self.move_resize_queued := FALSE;
  self.keys_grabbed := FALSE;
  self.grab_on_frame := FALSE;
  self.all_keys_grabbed := FALSE;
  self.withdrawn := FALSE;
  self.calc_placement := FALSE;

  self.unmaps_pending := 0;

  self.mwm_decorated := TRUE;
  self.mwm_border_only := FALSE;
  self.mwm_has_close_func := TRUE;
  self.mwm_has_minimize_func := TRUE;
  self.mwm_has_maximize_func := TRUE;
  self.mwm_has_move_func := TRUE;
  self.mwm_has_resize_func := TRUE;

  self.decorated := TRUE;
  self.has_close_func := TRUE;
  self.has_minimize_func := TRUE;
  self.has_maximize_func := TRUE;
  self.has_move_func := TRUE;
  self.has_resize_func := TRUE;

  self.has_shade_func := TRUE;

  self.has_fullscreen_func := TRUE;

  self.wm_state_modal := FALSE;

  //self.skip_taskbar := FALSE;
  //self.skip_pager := FALSE;

  self.wm_state_skip_taskbar := FALSE;
  self.wm_state_skip_pager := FALSE;
  self.wm_state_above := FALSE;
  self.wm_state_below := FALSE;


  //self.res_class := NULL;
  //self.res_name := NULL;
  //self.role := NULL;
  //self.sm_client_id := NULL;
  //self.wm_client_machine := NULL;


  //self.net_wm_pid := -1;

  self.xtransient_for := None;
  self.xgroup_leader := None;
  self.xclient_leader := None;
  self.transient_parent_is_root_window := FALSE;

  self.wtype := wtNormal;
  self.type_atom := None;

  self.has_struts := FALSE;
  self.do_not_cover := FALSE;
  self.left_strut := 0;
  self.right_strut := 0;
  self.top_strut := 0;
  self.bottom_strut := 0;



  //self.layer := META_LAYER_LAST; // invalid value
  //self.stack_position := -1;
  //self.initial_workspace := 0; /* not used */

  display.register_x_window(self.xwindow,self);
(*
  meta_prop_get_values (display, self.xwindow,
                        initial_props, N_INITIAL_PROPS);

  if (initial_props[INITIAL_PROP_WM_CLIENT_MACHINE].type !=
      META_PROP_VALUE_INVALID)

      self.wm_client_machine =
        g_strdup (initial_props[INITIAL_PROP_WM_CLIENT_MACHINE].v.str);

      meta_XFree (initial_props[INITIAL_PROP_WM_CLIENT_MACHINE].v.str);

      meta_verbose ("Window has client machine \"%s\"\n",
                    self.wm_client_machine);


  if (initial_props[INITIAL_PROP_NET_WM_PID].type !=
      META_PROP_VALUE_INVALID)

      gulong cardinal := (int) initial_props[INITIAL_PROP_NET_WM_PID].v.cardinal;

      if (cardinal <= 0)
        meta_warning (_("Application set a bogus _NET_WM_PID %ld\n"),
                      cardinal);
      else
        {
          self.net_wm_pid := cardinal;
          meta_verbose ("Window has _NET_WM_PID %d\n",
                        self.net_wm_pid);
        }
    }
  *)

//  update_size_hints;
//  update_title;
(*
  update_title (window);
  update_protocols (window);
  update_wm_hints (window);
  update_struts (window);

  update_net_wm_state (window);

  update_mwm_hints (window);
  update_wm_class (window);
  update_transient_for (window);
  update_sm_hints (window); /* must come after transient_for */
  update_role (window);
  update_net_wm_type (window);
  update_initial_workspace (window);
  update_icon_name (window);
  update_icon (window);

  if (self.initially_iconic)
    {
      /* WM_HINTS said minimized */
      self.minimized := TRUE;
      meta_verbose ("Window %s asked to start out minimized\n", self.desc);
    }

  if (existing_wm_state == IconicState)
    {
      /* WM_STATE said minimized */
      self.minimized := TRUE;
      meta_verbose ("Window %s had preexisting WM_STATE := IconicState, minimizing\n",
                    self.desc);

      /* Assume window was previously placed, though perhaps it's
       * been iconic its whole life, we have no way of knowing.
       */
      self.placed := TRUE;
    }

  /* FIXME we have a tendency to set this then immediately
   * change it again.
   */
  set_wm_state (window, self.iconic ? IconicState : NormalState);
  set_net_wm_state (window);
*)
  if (self.decorated) then self.ensure_frame;

(*
  meta_window_grab_keys (window);
  meta_display_grab_window_buttons (self.display, self.xwindow);
  meta_display_grab_focus_window_button (self.display, self.xwindow);

  /* For the workspace, first honor hints,
   * if that fails put transients with parents,
   * otherwise put window on active space
   */

  if (self.initial_workspace_set)
    {
      if (self.initial_workspace == (int) 0xFFFFFFFF)
        {
          meta_topic (META_DEBUG_PLACEMENT,
                      "Window %s is initially on all spaces\n",
                      self.desc);

          meta_workspace_add_window (self.screen.active_workspace, window);
          self.on_all_workspaces := TRUE;
        }
      else
        {
          meta_topic (META_DEBUG_PLACEMENT,
                      "Window %s is initially on space %d\n",
                      self.desc, self.initial_workspace);

          space =
            meta_screen_get_workspace_by_index (self.screen,
                                                self.initial_workspace);
          
          if (space)
            meta_workspace_add_window (space, window);
        }
    }
  
  if (self.workspaces == NULL && 
      self.xtransient_for != None)
    {
      /* Try putting dialog on parent's workspace */
      MetaWindow *parent;

      parent := meta_display_lookup_x_window (self.display,
                                             self.xtransient_for);

      if (parent)
        {
          GList *tmp_list;

          meta_topic (META_DEBUG_PLACEMENT,
                      "Putting window %s on some workspaces as parent %s\n",
                      self.desc, parent.desc);
          
          if (parent.on_all_workspaces)
            self.on_all_workspaces := TRUE;
          
          tmp_list := parent.workspaces;
          while (tmp_list != NULL)
            {
              meta_workspace_add_window (tmp_list.data, window);
              
              tmp_list := tmp_list.next;
            }
        }
    }
  
  if (self.workspaces == NULL)
    {
      meta_topic (META_DEBUG_PLACEMENT,
                  "Putting window %s on active workspace\n",
                  self.desc);
      
      space := self.screen.active_workspace;

      meta_workspace_add_window (space, window);
    }
  
  if (self.type == META_WINDOW_DESKTOP ||
      self.type == META_WINDOW_DOCK)
    {
      /* Change the default, but don't enforce this if
       * the user focuses the dock/desktop and unsticks it
       * using key shortcuts
       */
      self.on_all_workspaces := TRUE;
    }

  /* for the various on_all_workspaces := TRUE possible above */
  meta_window_set_current_workspace_hint (window);

  /* Put our state back where it should be,
   * passing TRUE for is_configure_request, ICCCM says
   * initial map is handled same as configure request
   */
  meta_window_move_resize_internal (window,
                                    META_IS_CONFIGURE_REQUEST,
                                    NorthWestGravity,
                                    self.size_hints.x,
                                    self.size_hints.y,
                                    self.size_hints.width,
                                    self.size_hints.height);

  /* add to MRU list */
  self.display.mru_list =
    g_list_append (self.display.mru_list, window);
  
  meta_stack_add (self.screen.stack, 
                  window);

  /* Now try applying saved stuff from the session */
  {
    const MetaWindowSessionInfo *info;

    info := meta_window_lookup_saved_state (window);

    if (info)
      {
        meta_window_apply_session_info (window, info);
        meta_window_release_saved_state (info);
      }
  }
  
  /* Maximize windows if they are too big for their work
   * area (bit of a hack here). Assume undecorated windows
   * probably don't intend to be maximized.
   */
  if (self.has_maximize_func && self.decorated &&
      !self.fullscreen)
    {
      MetaRectangle workarea;
      MetaRectangle outer;
      
      meta_window_get_work_area (window, TRUE, &workarea);      

      meta_window_get_outer_rect (window, &outer);
      
      if (outer.width >= workarea.width &&
          outer.height >= workarea.height)
        meta_window_maximize (window);
    }
  
  /* Sync stack changes */
  meta_stack_thaw (self.screen.stack);

  /* disable show desktop mode unless we're a desktop component */
  if (self.screen.showing_desktop &&
      self.type != META_WINDOW_DESKTOP &&
      self.type != META_WINDOW_DOCK)
    meta_screen_unshow_desktop (self.screen);
  
  meta_window_queue_calc_showing (window);

  meta_error_trap_pop (display, FALSE); /* pop the XSync()-reducing trap */
*)
    display.ungrab;
end;

function text_property_from_results (var results: GetPropertyResults; var utf8_str_p:PChar):boolean;
var
    tp: XTextProperty;
begin
  utf8_str_p := nil;

  tp.value := PByte(results.prop);
  results.prop := nil;
  tp.encoding := results.xtype;
  tp.format := results.format;
  tp.nitems := results.n_items;

//  utf8_str_p := text_property_to_utf8 (results->display->xdisplay, &tp);

  if (tp.value <>nil) then XFree (tp.value);

  result:=(utf8_str_p<>nil);
end;

function prop_get_text_property (display: TWMDisplay;xwindow:Window;xatom:Atom;var utf8_str_p:PChar):boolean;
var
    results:GetPropertyResults;
begin
  if not (get_property (display, xwindow, xatom, AnyPropertyType, results)) then begin
    result:=false;
    exit;
  end;
  result:=text_property_from_results (results, utf8_str_p);
end;

procedure TWMWindow.update_title;
var
    str: PChar;
begin
  str := nil;
  prop_get_utf8_string (self.display,
                             self.xwindow,
                             self.display.atom_net_wm_name,
                             str);
  self.title:=str;

//  meta_XFree (str);

  if (self.title='') then begin
      prop_get_text_property (self.display,
                                   self.xwindow,
                                   XA_WM_NAME,
                                   str);
      self.title:=str;
  end;

  (*
  if (self.title='')
    self.title := g_strdup ("");


  /* strndup is a hack since GNU libc has broken %.10s */
  str := g_strndup (self.title, 10);
  g_free (self.desc);
  self.desc := g_strdup_printf ("0x%lx (%s)", self.xwindow, str);
  g_free (str);

  {
  if (self.frame)
    meta_ui_set_frame_title (self.screen.ui,
                             self.frame.xwindow,
                             self.title);
    *)
end;

procedure TWMWindow.unminimize;
begin
    showmessage('restore');
end;

procedure TWMWindow.ensure_frame;
var
  attrs:XSetWindowAttributes;
	ce:XConfigureEvent;
    data:array[0..1] of longint;
    p_attr:XSetWindowAttributes;
begin
  if assigned(frame) then exit;

  // See comment below for why this is required.
  display.grab;

  frame:=TWMFrame.create;
  frame.window:=self;
  frame.xwindow:=none;

  frame.rect := rect;
  frame.child_x := 0;
  frame.child_y := 0;
  frame.bottom_height := 0;
  frame.right_width := 0;
//  frame.current_cursor := 0;


  frame.mapped := FALSE;

  attrs.event_mask := EVENT_MASK;

  {* Default depth/visual handles clients with weird visuals; they can
   * always be children of the root depth/visual obviously, but
   * e.g. DRI games can't be children of a parent that has the same
   * visual as the client.
   *}

   frame.titleform:=TTitleForm.create(application);
   frame.xwindow:=QWidget_winID(frame.titleform.handle);
   frame.titleform.xdisplay:=display.xdisplay;

   (*
  //********************************
	p_attr.override_redirect := 1;
	p_attr.event_mask := ChildMask or ButtonPressMask or ExposureMask or EnterWindowMask;
    XChangeWindowAttributes(display.xdisplay,frame.xwindow,CWOverrideRedirect or CWBackPixel or CWEventMask, @p_attr);
  //********************************
  *)

  (*
  frame.xwindow := XCreateWindow (window.display.xdisplay,
                                  window.screen.xroot,
                                  frame.rect.x,
                                  frame.rect.y,
                                  frame.rect.width,
                                  frame.rect.height,
                                  0,
                                  window.screen.default_depth,
                                  CopyFromParent,
                                  window.screen.default_xvisual,
                                  CWEventMask,
                                  &attrs);

  /* So our UI can find the window ID */
  XFlush (window.display.xdisplay);

  meta_verbose ("Frame for %s is 0x%lx\n", frame.window.desc, frame.xwindow);

  meta_display_register_x_window (window.display, &frame.xwindow, window);

  /* Reparent the client window; it may be destroyed,
   * thus the error trap. We'll get a destroy notify later
   * and free everything. Comment in FVWM source code says
   * we need a server grab or the child can get its MapNotify
   * before we've finished reparenting and getting the decoration
   * window onscreen, so ensure_frame must be called with
   * a grab.
   */
  meta_error_trap_push (window.display);
  *)
  if (mapped) then begin
    mapped:=false;
    dec(unmaps_pending);
  end;

  // window was reparented to this position
  frame.titleform.BoundsRect:=frame.rect;
  if frame.titleform.width<5 then frame.titleform.width:=300;
  if frame.titleform.height<5 then frame.titleform.height:=300;
//  rect.left := 2;
//  rect.top:= 22;


  frame.titleform.show;

  XReparentWindow (display.xdisplay,
                   xwindow,
                   frame.xwindow,
                   2,
                   22);
  {
//*******************************************************************
	ce.xtype := ConfigureNotify;
	ce.event := xwindow;
	ce.xwindow := xwindow;
	ce.x := rect.left;
	ce.y := rect.top;
	ce.width := frame.titleform.width;
	ce.height := frame.titleform.height;
	ce.border_width := 0;
	ce.above := None;
	ce.override_redirect := 0;

	XSendEvent(display.xdisplay, xwindow, 0, StructureNotifyMask, @ce);
//********************************************************************
  }
  XResizeWindow(display.xdisplay,xwindow,frame.titleform.Width-4,frame.titleform.height-24);
  XMapWindow(display.xdisplay, xwindow);
  frame.titleform.bringtofront;
{
  data[0] := normalstate;
  data[1] := None; // icon window

  XChangeProperty(display.xdisplay, xwindow, display.atom_wm_state, display.atom_wm_state, 32, PropModeReplace, @data, 2);

  // FIXME handle this error
  //meta_error_trap_pop (window.display, FALSE);

  // meta_ui_add_frame (window.screen.ui, frame.xwindow);
}
  (*
  if (window.title)
    meta_ui_set_frame_title (window.screen.ui,
                             window.frame.xwindow,
                             window.title);

  /* Move keybindings to frame instead of window */
  meta_window_grab_keys (window);

  /* Shape mask */
  meta_ui_apply_frame_shape (frame.window.screen.ui,
                             frame.xwindow,
                             frame.rect.width,
                             frame.rect.height);

  meta_display_ungrab (window.display);
    *)
	XSync(display.xdisplay, 0);
    display.ungrab;
end;

end.
