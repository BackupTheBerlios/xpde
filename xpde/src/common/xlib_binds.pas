{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 Zeljan Rikalo <zeljko@xpde.com>                          }
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

unit xlib_binds;

interface
uses Xlib;

{$ALIGN 4}
{$MINENUMSIZE 4}

Const xpdexlib='libX11.so.6';
      xpbind=xpdexlib;

Const
       XkbKB_Permanent = $80;
       {$EXTERNALSYM XkbKB_Permanent}
       XkbKB_OpMask = $7f;
       {$EXTERNALSYM XkbKB_OpMask}
       XkbKB_Default = $00;
       {$EXTERNALSYM XkbKB_Default}
       XkbKB_Lock = $01;
       {$EXTERNALSYM XkbKB_Lock}
       XkbKB_RadioGroup = $02;
       {$EXTERNALSYM XkbKB_RadioGroup}
       XkbKB_Overlay1 = $03;
       {$EXTERNALSYM XkbKB_Overlay1}
       XkbKB_Overlay2 = $04;
       {$EXTERNALSYM XkbKB_Overlay2}
       XkbKB_RGAllowNone = $80;
       {$EXTERNALSYM XkbKB_RGAllowNone}       
    {
           Various macros which describe the range of legal keycodes.
          }
       XkbMinLegalKeyCode = 8;
       {$EXTERNALSYM XkbMinLegalKeyCode}
       XkbMaxLegalKeyCode = 255;
       {$EXTERNALSYM XkbMaxLegalKeyCode}
       XkbMaxKeyCount = (XkbMaxLegalKeyCode - XkbMinLegalKeyCode) + 1;
       {$EXTERNALSYM XkbMaxKeyCount}
       XkbPerKeyBitArraySize = (XkbMaxLegalKeyCode + 1) div 8;
       {$EXTERNALSYM XkbPerKeyBitArraySize}
    {
           Assorted constants and limits.
          }

Const
       XkbNumModifiers = 8;
       {$EXTERNALSYM XkbNumModifiers}
       XkbNumVirtualMods = 16;
       {$EXTERNALSYM XkbNumVirtualMods}
       XkbNumIndicators = 32;
       {$EXTERNALSYM XkbNumIndicators}
       XkbAllIndicatorsMask = $ffffffff;
       {$EXTERNALSYM XkbAllIndicatorsMask}
       XkbMaxRadioGroups = 32;
       {$EXTERNALSYM XkbMaxRadioGroups}
       XkbAllRadioGroupsMask = $ffffffff;
       {$EXTERNALSYM XkbAllRadioGroupsMask}
       XkbMaxShiftLevel = 63;
       {$EXTERNALSYM XkbMaxShiftLevel}
       XkbNoModifier = $ff;
       {$EXTERNALSYM XkbNoModifier}
       XkbNoShiftLevel = $ff;
       {$EXTERNALSYM XkbNoShiftLevel}
       XkbNoShape = $ff;
       {$EXTERNALSYM XkbNoShape}
       XkbNoIndicator = $ff;
       {$EXTERNALSYM XkbNoIndicator}
       XkbNoModifierMask = 0;
       {$EXTERNALSYM XkbNoModifierMask}
       XkbAllModifiersMask = $ff;
       {$EXTERNALSYM XkbAllModifiersMask}
       XkbAllVirtualModsMask = $ffff;
       {$EXTERNALSYM XkbAllVirtualModsMask}
       XkbNumKbdGroups = 4;
       {$EXTERNALSYM XkbNumKbdGroups}
       XkbMaxKbdGroup = XkbNumKbdGroups - 1;
       {$EXTERNALSYM XkbMaxKbdGroup}
       XkbMaxMouseKeysBtn = 4;
       {$EXTERNALSYM XkbMaxMouseKeysBtn}
       XkbRGMaxMembers = 12;
       {$EXTERNALSYM XkbRGMaxMembers}
       XkbActionMessageLength = 6;
       {$EXTERNALSYM XkbActionMessageLength}
       XkbKeyNameLength = 4;
       {$EXTERNALSYM XkbKeyNameLength}
       XkbMaxRedirectCount = 8;
       {$EXTERNALSYM XkbMaxRedirectCount}
       XkbGeomPtsPerMM = 10;
       {$EXTERNALSYM XkbGeomPtsPerMM}
       XkbGeomMaxColors = 32;
       {$EXTERNALSYM XkbGeomMaxColors}
       XkbGeomMaxLabelColors = 3;
       {$EXTERNALSYM XkbGeomMaxLabelColors}
       XkbGeomMaxPriority = 255;
       {$EXTERNALSYM XkbGeomMaxPriority}

       // Key Type index and mask for the four standard key types.

       XkbOneLevelIndex = 0;
       {$EXTERNALSYM XkbOneLevelIndex}
       XkbTwoLevelIndex = 1;
       {$EXTERNALSYM XkbTwoLevelIndex}
       XkbAlphabeticIndex = 2;
       {$EXTERNALSYM XkbAlphabeticIndex}
       XkbKeypadIndex = 3;
       {$EXTERNALSYM XkbKeypadIndex}
       XkbLastRequiredType = XkbKeypadIndex;
       {$EXTERNALSYM XkbLastRequiredType}
       XkbNumRequiredTypes = XkbLastRequiredType + 1;
       {$EXTERNALSYM XkbNumRequiredTypes}
       XkbMaxKeyTypes = 255;
       {$EXTERNALSYM XkbMaxKeyTypes}
       XkbOneLevelMask = 1 shl 0;
       {$EXTERNALSYM XkbOneLevelMask}
       XkbTwoLevelMask = 1 shl 1;
       {$EXTERNALSYM XkbTwoLevelMask}
       XkbAlphabeticMask = 1 shl 2;
       {$EXTERNALSYM XkbAlphabeticMask}
       XkbKeypadMask = 1 shl 3;
       {$EXTERNALSYM XkbKeypadMask}
       XkbAllRequiredTypes = $f;
       {$EXTERNALSYM XkbAllRequiredTypes}       


type  _XkbStateRec = record
            group : byte;
            locked_group : byte;
            base_group : word;
            latched_group : word;
            mods : byte;
            base_mods : byte;
            latched_mods : byte;
            locked_mods : byte;
            compat_state : byte;
            grab_mods : byte;
            compat_grab_mods : byte;
            lookup_mods : byte;
            compat_lookup_mods : byte;
            ptr_buttons : word;
         end;
       XkbStateRec = _XkbStateRec;
       {$EXTERNALSYM XkbStateRec}
       XkbStatePtr = ^_XkbStateRec;
       {$EXTERNALSYM XkbStatePtr}


      _XkbMods = record
           mask : byte;
           real_mods : byte;
           vmods : word;
         end;
       XkbModsRec = _XkbMods;
       {$EXTERNALSYM XkbModsRec}
       XkbModsPtr = ^_XkbMods;
       {$EXTERNALSYM XkbModsPtr}

      _XkbKTMapEntry = record
            active : Bool;
            level : byte;
            mods : XkbModsRec;
         end;
       XkbKTMapEntryRec = _XkbKTMapEntry;
       XkbKTMapEntryPtr = ^_XkbKTMapEntry;

      _XkbKeyType = record
            mods : XkbModsRec;
            num_levels : byte;
            map_count : byte;
            map : XkbKTMapEntryPtr;
            preserve : XkbModsPtr;
            name : Atom;
            level_names : ^Atom;
         end;
       XkbKeyTypeRec = _XkbKeyType;
       {$EXTERNALSYM XkbKeyTypeRec}
       XkbKeyTypePtr = ^_XkbKeyType;
       {$EXTERNALSYM XkbKeyTypePtr}

      _XkbBehavior = record
            _type : byte;
            data : byte;
         end;
       XkbBehavior = _XkbBehavior;

Const
       XkbAnyActionDataSize = 7;
       {$EXTERNALSYM XkbAnyActionDataSize}

type  _XkbAnyAction = record
            _type : byte;
            data : array[0..(XkbAnyActionDataSize)-1] of byte;
         end;
       XkbAnyAction = _XkbAnyAction;
       {$EXTERNALSYM XkbAnyAction}

       _XkbModAction = record
            _type : byte;
            flags : byte;
            mask : byte;
            real_mods : byte;
            vmods1 : byte;
            vmods2 : byte;
         end;
       XkbModAction = _XkbModAction;
       {$EXTERNALSYM XkbModAction}


        _XkbControls = record
            mk_dflt_btn : byte;
            num_groups : byte;
            groups_wrap : byte;
            internal : XkbModsRec;
            ignore_lock : XkbModsRec;
            enabled_ctrls : longword;
            repeat_delay : word;
            repeat_interval : word;
            slow_keys_delay : word;
            debounce_delay : word;
            mk_delay : word;
            mk_interval : word;
            mk_time_to_max : word;
            mk_max_speed : word;
            mk_curve : smallint;
            ax_options : word;
            ax_timeout : word;
            axt_opts_mask : word;
            axt_opts_values : word;
            axt_ctrls_mask : longword;
            axt_ctrls_values : longword;
            per_key_repeat : array[0..(XkbPerKeyBitArraySize)-1] of byte;
         end;
       XkbControlsRec = _XkbControls;
       {$EXTERNALSYM XkbControlsRec}       
       XkbControlsPtr = ^_XkbControls;
       {$EXTERNALSYM XkbControlsPtr}

      _XkbGroupAction = record
                _type:byte;
                flags:byte;
                group_XXX:char;
        End;
        XkbGroupAction = _XkbGroupAction;
        {$EXTERNALSYM XkbGroupAction}


      _XkbISOAction = record
            _type : byte;
            flags : byte;
            mask : byte;
            real_mods : byte;
            group_XXX : char;
            affect : byte;
            vmods1 : byte;
            vmods2 : byte;
         end;
       XkbISOAction = _XkbISOAction;
        {$EXTERNALSYM XkbISOAction}

       _XkbPtrAction = record
            _type : byte;
            flags : byte;
            high_XXX : byte;
            low_XXX : byte;
            high_YYY : byte;
            low_YYY : byte;
         end;
       XkbPtrAction = _XkbPtrAction;
        {$EXTERNALSYM XkbPtrAction}

       _XkbPtrBtnAction = record
            _type : byte;
            flags : byte;
            count : byte;
            button : byte;
         end;
       XkbPtrBtnAction = _XkbPtrBtnAction;
       {$EXTERNALSYM XkbPtrBtnAction}

       _XkbPtrDfltAction = record
            _type : byte;
            flags : byte;
            affect : byte;
            valueXXX : char;
         end;
       XkbPtrDfltAction = _XkbPtrDfltAction;
       {$EXTERNALSYM XkbPtrDfltAction}

       _XkbSwitchScreenAction = record
            _type : byte;
            flags : byte;
            screenXXX : char;
         end;
       XkbSwitchScreenAction = _XkbSwitchScreenAction;
       {$EXTERNALSYM XkbSwitchScreenAction}

       _XkbCtrlsAction = record
            _type : byte;
            flags : byte;
            ctrls3 : byte;
            ctrls2 : byte;
            ctrls1 : byte;
            ctrls0 : byte;
         end;
       XkbCtrlsAction = _XkbCtrlsAction;
       {$EXTERNALSYM XkbCtrlsAction}


        _XkbMessageAction = record
                _type : byte;
                flags : byte;
                message_:Array [0..5] of char;
        End;
         XkbMessageAction = _XkbMessageAction;
         {$EXTERNALSYM XkbMessageAction}

       _XkbRedirectKeyAction = record
            _type : byte;
            new_key : byte;
            mods_mask : byte;
            mods : byte;
            vmods_mask0 : byte;
            vmods_mask1 : byte;
            vmods0 : byte;
            vmods1 : byte;
         end;
       XkbRedirectKeyAction = _XkbRedirectKeyAction;
       {$EXTERNALSYM XkbRedirectKeyAction}

        _XkbDeviceBtnAction = record
                _type:byte;
                flags:byte;
                _count:byte;
                _button:byte;
                _device:byte;
        End;
       XkbDeviceBtnAction = _XkbDeviceBtnAction;
       {$EXTERNALSYM XkbDeviceBtnAction}

       _XkbDeviceValuatorAction = record
            _type : byte;
            device : byte;
            v1_what : byte;
            v1_ndx : byte;
            v1_value : byte;
            v2_what : byte;
            v2_ndx : byte;
            v2_value : byte;
         end;
       XkbDeviceValuatorAction = _XkbDeviceValuatorAction;
       {$EXTERNALSYM XkbDeviceValuatorAction}


type   _XkbAction = record
           case longint of
              0 : ( any : XkbAnyAction );
              1 : ( mods : XkbModAction );
              2 : ( group : XkbGroupAction );
              3 : ( iso : XkbISOAction );
              4 : ( ptr : XkbPtrAction );
              5 : ( btn : XkbPtrBtnAction );
              6 : ( dflt : XkbPtrDfltAction );
              7 : ( screen : XkbSwitchScreenAction );
              8 : ( ctrls : XkbCtrlsAction );
              9 : ( msg : XkbMessageAction );
              10 : ( redirect : XkbRedirectKeyAction );
              11 : ( devbtn : XkbDeviceBtnAction );
              12 : ( devval : XkbDeviceValuatorAction );
              13 : ( _type : byte );
           end;
       XkbAction = _XkbAction;
       {$EXTERNALSYM XkbAction}



type  _XkbServerMapRec = record
            num_acts : word;
            size_acts : word;
            acts : ^XkbAction;
            behaviors : ^XkbBehavior;
            key_acts : ^word;
            c_explicit : ^byte;
            explicit : ^byte;
            vmods : array[0..(XkbNumVirtualMods)-1] of byte;
            vmodmap : ^word;
         end;
       XkbServerMapRec = _XkbServerMapRec;
       {$EXTERNALSYM XkbServerMapRec}       
       XkbServerMapPtr = ^_XkbServerMapRec;
       {$EXTERNALSYM XkbServerMapPtr}

      _XkbSymMapRec = record
            kt_index : array[0..(XkbNumKbdGroups)-1] of byte;
            group_info : byte;
            width : byte;
            offset : word;
         end;
       XkbSymMapRec = _XkbSymMapRec;
       {$EXTERNALSYM XkbSymMapRec}
       XkbSymMapPtr = ^_XkbSymMapRec;
       {$EXTERNALSYM XkbSymMapPtr}

       _XkbClientMapRec = record
            size_types : byte;
            num_types : byte;
            types : XkbKeyTypePtr;
            size_syms : word;
            num_syms : word;
            syms : ^KeySym;
            key_sym_map : XkbSymMapPtr;
            modmap : ^byte;
         end;
       XkbClientMapRec = _XkbClientMapRec;
       {$EXTERNALSYM XkbClientMapRec}
       XkbClientMapPtr = ^_XkbClientMapRec;
       {$EXTERNALSYM XkbClientMapPtr}

       _XkbIndicatorMapRec = record
            flags : byte;
            which_groups : byte;
            groups : byte;
            which_mods : byte;
            mods : XkbModsRec;
            ctrls : longword;
         end;
       XkbIndicatorMapRec = _XkbIndicatorMapRec;
      {$EXTERNALSYM XkbIndicatorMapRec}
       XkbIndicatorMapPtr = ^_XkbIndicatorMapRec;
      {$EXTERNALSYM XkbIndicatorMapPtr}


      _XkbIndicatorRec = record
		phys_indicators:longint;
		maps : Array [0..XkbNumIndicators-1] of XkbIndicatorMapRec;
      End;          
     XkbIndicatorRec = _XkbIndicatorRec;
     {$EXTERNALSYM XkbIndicatorRec}
     XkbIndicatorPtr = ^XkbIndicatorRec;
     {$EXTERNALSYM XkbIndicatorPtr}


       _XkbKeyNameRec = record
            name : array[0..(XkbKeyNameLength)-1] of char;
         end;
       XkbKeyNameRec = _XkbKeyNameRec;
       {$EXTERNALSYM XkbKeyNameRec}
       XkbKeyNamePtr = ^_XkbKeyNameRec;
       {$EXTERNALSYM XkbKeyNamePtr}

       _XkbKeyAliasRec = record
            real : array[0..(XkbKeyNameLength)-1] of char;
            alias : array[0..(XkbKeyNameLength)-1] of char;
         end;
       XkbKeyAliasRec = _XkbKeyAliasRec;
       {$EXTERNALSYM XkbKeyAliasRec}
       XkbKeyAliasPtr = ^_XkbKeyAliasRec;
       {$EXTERNALSYM XkbKeyAliasPtr}


       _XkbNamesRec = record
            keycodes : Atom;
            geometry : Atom;
            symbols : Atom;
            types : Atom;
            compat : Atom;
            vmods : array[0..(XkbNumVirtualMods)-1] of Atom;
            indicators : array[0..(XkbNumIndicators)-1] of Atom;
            groups : array[0..(XkbNumKbdGroups)-1] of Atom;
            keys : XkbKeyNamePtr;
            key_aliases : XkbKeyAliasPtr;
            radio_groups : ^Atom;
            phys_symbols : Atom;
            num_keys : byte;
            num_key_aliases : byte;
            num_rg : word;
         end;
       XkbNamesRec = _XkbNamesRec;
       {$EXTERNALSYM XkbNamesRec}
       XkbNamesPtr = ^_XkbNamesRec;
       {$EXTERNALSYM XkbNamesPtr}

       _XkbSymInterpretRec = record
            sym : KeySym;
            flags : byte;
            match : byte;
            mods : byte;
            virtual_mod : byte;
            act : XkbAnyAction;
         end;
       XkbSymInterpretRec = _XkbSymInterpretRec;
       {$EXTERNALSYM XkbSymInterpretRec}
       XkbSymInterpretPtr = ^_XkbSymInterpretRec;
       {$EXTERNALSYM XkbSymInterpretPtr}

       _XkbCompatMapRec = record
            sym_interpret : XkbSymInterpretPtr;
            groups : array[0..(XkbNumKbdGroups)-1] of XkbModsRec;
            num_si : word;
            size_si : word;
         end;
       XkbCompatMapRec = _XkbCompatMapRec;
       {$EXTERNALSYM XkbCompatMapRec}
       XkbCompatMapPtr = ^_XkbCompatMapRec;
       {$EXTERNALSYM XkbCompatMapPtr}

         _XkbGeometry = record
         End;
         XkbGeometryPtr=^_XkbGeometry;
        {$EXTERNALSYM XkbGeometryPtr}

type  _XkbDesc = record
            dpy : ^_XDisplay;
            flags : word;
            device_spec : word;
            min_key_code : KeyCode;
            max_key_code : KeyCode;
            ctrls : XkbControlsPtr;
            server : XkbServerMapPtr;
            map : XkbClientMapPtr;
            indicators : XkbIndicatorPtr;
            names : XkbNamesPtr;
            compat : XkbCompatMapPtr;
            geom : XkbGeometryPtr;
         end;
       XkbDescRec = _XkbDesc;
       {$EXTERNALSYM XkbDescRec}       
       XkbDescPtr = ^_XkbDesc;
       {$EXTERNALSYM XkbDescPtr}


function XSetPointerMapping(Display: PDisplay; MapReturn: PByte; NMap: Longint): Longint; cdecl;
{$EXTERNALSYM XSetPointerMapping}

Function XkbAllocKeyboard:XkbDescPtr; cdecl; varargs;
{$EXTERNALSYM XkbAllocKeyboard}
Procedure XkbFreeKeyboard(xkbpointer:XkbDescPtr; which_:longint; rtrnstatus:bool); cdecl;
{$EXTERNALSYM XkbFreeKeyboard}

Function XkbGetState(Display:PDisplay; i:plongint; xkbstat_:XkbStatePtr):PStatus; cdecl;
{$EXTERNALSYM XkbGetState}
Function XkbSetDetectableAutoRepeat(Display:PDisplay; detectable:bool; supported:bool):bool; cdecl;
{$EXTERNALSYM XkbSetDetectableAutoRepeat}
Function XkbGetDetectableAutoRepeat(Display:PDisplay; supported:bool):bool; cdecl;
{$EXTERNALSYM XkbGetDetectableAutoRepeat}
Function XkbSetAutoRepeatRate(display:PDisplay; deviceSpec:plongint; delay__:plongint; interval:plongint):bool; cdecl;
{$EXTERNALSYM XkbSetAutoRepeatRate}
Function XkbGetAutoRepeatRate(display:PDisplay; deviceSpec:plongint; rtrn_delay__:plongint; rtrn_interval:plongint):bool; cdecl;
{$EXTERNALSYM XkbGetAutoRepeatRate}
Function XkbAllocControls(xkbpointer:XkbDescPtr; which_:longint):PStatus; cdecl; varargs;
{$EXTERNALSYM XkbAllocControls}
Procedure XkbFreeControls(xkbpointer:XkbDescPtr; which_:longint; FreeMap:bool) cdecl; varargs;
{$EXTERNALSYM XkbFreeControls}
Function XkbGetControls(Display:PDisplay; which_:longint; desc:XkbDescPtr):PStatus; cdecl;
{$EXTERNALSYM XkbGetControls}
Function XkbSetControls(Display:PDisplay; which_:longint; desc:XkbDescPtr):bool; cdecl;
{$EXTERNALSYM XkbSetControls}
Function XkbAllocIndicatorMaps(desc:XkbDescPtr):PStatus; cdecl; varargs;
{$EXTERNALSYM XkbAllocIndicatorMaps}
Procedure XkbFreeIndicatorMaps(desc:XkbDescPtr); cdecl; varargs;
{$EXTERNALSYM XkbFreeIndicatorMaps}


implementation
function XSetPointerMapping; external xpbind name 'XSetPointerMapping';

Function XkbAllocKeyboard; external xpbind name 'XkbAllocKeyboard';
Procedure XkbFreeKeyboard; external xpbind name 'XkbFreeKeyboard';
Function XkbGetState; external xpbind name 'XkbGetState';
Function XkbSetDetectableAutoRepeat; external xpbind name 'XkbSetDetectableAutoRepeat';
Function XkbGetDetectableAutoRepeat; external xpbind name 'XkbGetDetectableAutoRepeat';
Function XkbSetAutoRepeatRate; external xpbind name 'XkbSetAutoRepeatRate';
Function XkbGetAutoRepeatRate; external xpbind name 'XkbGetAutoRepeatRate';
Function XkbAllocControls; external xpbind name 'XkbAllocControls';
Procedure XkbFreeControls; external xpbind name 'XkbFreeControls';
Function XkbGetControls; external xpbind name 'XkbGetControls';
Function XkbSetControls; external xpbind name 'XkbSetControls';
Function XkbAllocIndicatorMaps; external xpbind name 'XkbAllocIndicatorMaps';
Procedure XkbFreeIndicatorMaps; external xpbind name 'XkbFreeIndicatorMaps';

end.


