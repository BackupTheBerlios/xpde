unit numlock;
// {$DEFINE DEBUG_NUMLOCK}
interface 
uses Libc,SysUtils,Classes,QForms,Xlib,xlib_binds;

Function NumLock_Change_Numlock_State(numlockstate_:boolean):boolean;

implementation
var xkb__:XkbDescPtr;

Function xkb_mask_modifier(xkb:XkbDescPtr; Const name:PChar=Nil):integer;
var i,mask:integer;
    modStr:PChar;
Begin
        if (xkb=Nil) or (xkb.names=Nil) then begin
        Result:=-1;
       {$IFDEF DEBUG_NUMLOCK}
        writeln('EXITERD ABNORMALLY -> xkb is Nil !');
       {$ENDIF}
        exit;
        End;

        for i:=0 to XkbNumVirtualMods-1 do begin

                modStr:=xlib.XGetAtomName(Application.Display,xkb.names.vmods[i]);
                {$IFDEF DEBUG_NUMLOCK}
                writeln('MODSTR ',string(modStr),' i= ',i);
                {$ENDIF}
                        if (modStr<>Nil) and (Libc.strcmp(name,modstr)=0) then begin
                                XkbVirtualModsToReal(xkb,1 shl i,@mask);
                                Result:=mask;                                exit;
                        End;
        End;

        Result:=-1;
End;

Function xkb_numlock_mask:integer;
var mask:longint;
Begin
        xkb__:=XkbAllocKeyboard;
        xkb__:=XkbGetKeyboard(Application.Display,XkbAllComponentsMask, XkbUseCoreKbd);
        if xkb__<>Nil then begin
                mask:=xkb_mask_modifier( xkb__, 'NumLock' );
                {$IFDEF DEBUG_NUMLOCK}
                writeln('MASK ',mask);
                {$ENDIF}
                XkbFreeKeyBoard(xkb__,1,1);
                Result:=mask;
                Exit;
        End;
        Result:=-1;
                {$IFDEF DEBUG_NUMLOCK}
                writeln('XKB__ = NIL !');
                {$ENDIF}

End;

Function xkb_Set_on:boolean;
var mask:longint;
Begin
        mask:=xkb_numlock_mask;
        if mask=-1 then begin
        Result:=false;
        exit;
        End;
        XkbLockModifiers(Application.Display,XkbUseCoreKbd,mask,mask);
        Result:=true;
End;

Function xkb_set_off:boolean;
var mask:longint;
Begin
        mask:=xkb_numlock_mask;
        if mask=-1 then begin
        Result:=false;
        exit;
        End;
        XkbLockModifiers (Application.Display, XkbUseCoreKbd, mask, 0);
        Result:=true;
End;


Function Numlock_Set_on:boolean;
Begin
        Result:=xkb_set_on;
End;

Function Numlock_Set_off:boolean;
Begin
        Result:=xkb_set_off;
End;

Function NumLock_Change_Numlock_State(numlockstate_:boolean):boolean;
Begin
        if numlockstate_ then
                Result:=numlock_set_on
        else
                Result:=numlock_set_off;
End;

End.