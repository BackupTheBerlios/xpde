unit uMouseAPI;

interface

uses QForms, Qt, uRegistry, XLib;

Const
      key                ='Control Panel/';
      Mouse_Settings_Key = 'Mouse';
      Mouse_Acceleration = 'Acceleration';
      Mouse_EnhancePrecision = 'Enhance_Precision';
      Mouse_Threshold = 'Threshold';
      Mouse_DblClickTime = 'Double_Click_Time';
      Mouse_LeftHanded = 'Left_Handed';
      Mouse_ClickLock = 'Click_Lock';
      Mouse_DefButton = 'Default_Button';
      Mouse_DisplayTrails='Display_Trails';
      Mouse_NumOfTrails='Num_Trails';
      Mouse_HidePointer='Hide_Pointer';
      Mouse_ShowLocation='Show_Location';
      Mouse_NotchToScroll='Notch_To_Scroll';
      Mouse_WheelNumLines='Wheel_Num_Lines';

var
  accel_:integer=2;
  pointer_precision:boolean=false;
  threshold_:integer=2;
  dblclick_:integer=400;
  dragstarttime:integer=500;
  dragdist:integer=4;
  wheelscroll_lines:integer=3;
  left_handed:boolean=false;
  click_lock:boolean=false;
  def_button:boolean=false;
  display_trails:boolean=false;
  num_trails:integer=0;
  hide_pointer:boolean=false;
  show_location:boolean=false;
  notch_to_scroll:integer=0;
  num_lines:integer=3;
  middle_button:integer;
  num_buttons:integer;
  map:Array [0..5] of byte;


procedure setButtonMapping(lefthand:boolean);
procedure setDoubleClickInterval(interval:integer);
procedure setMouseAccel(accel, threshold:integer);
procedure setWheelScrollLines(notch:boolean; lines:integer);

procedure readMousePropertiesFromRegistry;
procedure saveMousePropertiesToRegistry;
procedure applyMouseProperties;

//This binding is missing from the Borland's XLib unit
function XSetPointerMapping(Display: PDisplay; MapReturn: PByte; NMap: Longint): Longint; cdecl; external xlibmodulename name 'XSetPointerMapping';

implementation

function WriteCount_Msecs_DblClick(value:integer):integer;
begin
        case value of
                0:result:=900;
                1:result:=800;
                2:result:=700;
                3:result:=600;
                4:result:=500;
                5:result:=400;
                6:result:=300;
                7:result:=200;
                8:result:=100;
                else Result:=400;
        end;
end;

function ReadCount_Msecs_DblClick(value:integer):integer;
begin
        case value of
                100:result:=8;
                200:result:=7;
                300:result:=6;
                400:result:=5;
                500:result:=4;
                600:result:=3;
                700:result:=2;
                800:result:=1;
                900:result:=0;
                else Result:=4;
        end;
end;

procedure setWheelScrollLines(notch:boolean; lines:integer);
begin
        if notch then QApplication_setWheelScrollLines(lines)
        else QApplication_setWheelScrollLines(20); // UGLY ;)
end;

procedure setDoubleClickInterval(interval:integer);
begin
    QApplication_setDoubleClickInterval(WriteCount_Msecs_DblClick(interval));
end;

procedure setMouseAccel(accel, threshold:integer);
var
    acc_,acc_n,thr:integer;
begin
    XGetPointerControl(application.display,@acc_,@acc_n,@thr);
    XChangePointerControl(application.display,1, 1, accel, 1, threshold);
end;

procedure setButtonMapping(lefthand:boolean);
var
    remap:boolean;
    retval:integer;
begin
    remap:=true;

    num_buttons := XGetPointerMapping(application.display, @map, 5);

    case num_buttons of
        3,5:middle_button:=map[1];
    end;

    case num_buttons of
        1:map[0]:=1;
        2:begin
            if not lefthand then begin
              map[0] := 1;
              map[1] := 3;
            end
            else begin
              map[0] := 3;
              map[1] := 1;
            end;
          end;
        3:begin
            if not lefthand then begin
                map[0] := 1;
                map[1] := middle_button;
                map[2] := 3;
            end
            else begin
              map[0] := 3;
              map[1] := middle_button;
              map[2] := 1;
            end;
          end;
        5:begin
              // Intellimouse case, where buttons 1-3 are left, middle, and
              // right, and 4-5 are up/down
              if not lefthand then begin
                  map[0] := 1;
                  map[1] := 2;
                  map[2] := 3;
                  map[3] := 4;
                  map[4] := 5;
              end
              else begin
                  map[0] := 3;
                  map[1] := 2;
                  map[2] := 1;
                  map[3] := 4;
                  map[4] := 5;
              end;
          end;

          else begin
            remap:=false; // Don't do anything since we don't know what to do... ;)
          end;
    end;


    if remap then begin
        repeat
            retval:=XSetPointerMapping(application.display, @map,num_buttons);
            Application.ProcessMessages;
        until retval<>MappingBusy;
    end;

end;

procedure readMousePropertiesFromRegistry;
var
    reg:TRegistry;
begin
        reg:=TRegistry.Create;
        try
            reg.RootKey:=HKEY_CURRENT_USER;
            if reg.OpenKey(key+Mouse_Settings_Key,false) then begin
                threshold_:=reg.Readinteger(Mouse_Threshold);
                accel_:=reg.Readinteger(Mouse_Acceleration);
                pointer_precision:=reg.Readbool(Mouse_EnhancePrecision);
                dblclick_:=reg.Readinteger(Mouse_DblClickTime);
                left_handed:=reg.Readbool(Mouse_LeftHanded);
                click_lock:=reg.Readbool(Mouse_ClickLock);
                def_button:=reg.Readbool(Mouse_DefButton);
                display_trails:=reg.Readbool(Mouse_DisplayTrails);
                num_trails:=reg.Readinteger(Mouse_NumOfTrails);
                hide_pointer:=reg.Readbool(Mouse_HidePointer);
                show_location:=reg.Readbool(Mouse_ShowLocation);
                notch_to_scroll:=reg.Readinteger(Mouse_NotchToScroll);
                num_lines:=reg.Readinteger(Mouse_WheelNumLines);
            end
            else begin
                reg.OpenKey(key+Mouse_Settings_Key,true);
                reg.Writeinteger(Mouse_Threshold,2);
                reg.Writeinteger(Mouse_Acceleration,2);
                reg.Writebool(Mouse_EnhancePrecision,false);
                reg.Writeinteger(Mouse_DblClickTime,400);
                reg.Writebool(Mouse_LeftHanded,false);
                reg.Writebool(Mouse_ClickLock,false);
                reg.Writebool(Mouse_DefButton,false);
                reg.Writebool(Mouse_DisplayTrails,false);
                reg.Writeinteger(Mouse_NumOfTrails,0);
                reg.Writebool(Mouse_HidePointer,false);
                reg.Writebool(Mouse_ShowLocation,false);
                reg.Writeinteger(Mouse_NotchToScroll,0);
                reg.Writeinteger(Mouse_WheelNumLines,3);
            end;
        finally
            reg.Free;
        end;
end;

procedure saveMousePropertiesToRegistry;
var
    reg:TRegistry;
begin
    reg:=TRegistry.Create;
    try
        reg.RootKey:=HKEY_CURRENT_USER;

        if reg.OpenKey(key+Mouse_Settings_Key,true) then begin
            reg.Writeinteger(Mouse_Acceleration,accel_);
            reg.Writebool(Mouse_EnhancePrecision,pointer_precision);

            if pointer_precision then threshold_:=4
            else threshold_:=2;

            reg.Writeinteger(Mouse_Threshold,threshold_);
            reg.Writeinteger(Mouse_DblClickTime,dblclick_);
            reg.Writebool(Mouse_LeftHanded,left_handed);
            reg.Writebool(Mouse_ClickLock,click_lock);
            reg.Writebool(Mouse_DefButton,def_button);
            reg.Writebool(Mouse_DisplayTrails,display_trails);
            reg.Writeinteger(Mouse_NumOfTrails,num_trails);
            reg.Writebool(Mouse_HidePointer,hide_pointer);
            reg.Writebool(Mouse_ShowLocation,show_location);
            reg.Writeinteger(Mouse_NotchToScroll,notch_to_scroll);
            reg.Writeinteger(Mouse_WheelNumLines,num_lines);
        end;
    finally
        reg.Free;
    end;
end;

procedure applyMouseProperties;
begin
    setButtonMapping(left_handed);
    setDoubleClickInterval(dblclick_);
    setMouseAccel(accel_, threshold_);
    setWheelScrollLines(notch_to_scroll=0, num_lines);
end;

end.
