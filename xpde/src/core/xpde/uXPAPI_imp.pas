{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 Jos� Le�n Serna <ttm@xpde.com>                           }
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
unit uXPAPI_imp;

interface

uses Libc, uOpenWith, Classes, QExtCtrls, uXPAPI,
    QForms, SysUtils, QGraphics, Qt, uLNKFile, uXPStyleConsts,
    QControls, QDialogs, uRegistry, uQXPComCtrls;


type
    TXPAPI=class(TInterfacedObject, IXPAPI)
    private
        FUserDir: string;
        FUserName: string;
    function GetAppDir: string;
    function GetDesktopDir: string;
    function GetThemesDir: string;
    function GetCurrentThemeDir: string;
    function GetIconsDir: string;
    function GetBitmapsDir: string;
    function GetSystemDir: string;
    public
        timer: TTimer;
        defaultcursor: QCursorH;
        lastavg: integer;
        procedure checkcpuload;
        procedure ontimer(sender:TObject);
        procedure updateWidgets(aowner:TComponent);
        function setCursor(bmp:TBitmap):QCursorH;
        procedure setDefaultCursor;
        procedure setWaitCursor;
        function getExecutable(ext:string):string;
        procedure storeExecutable(ext:string;executable:string);
        function ShellExecute(const prog:string;waitfor:boolean):integer;
        procedure ShellDocument(const document:string);
        property UserDir:string read FUserDir;
        property Username:string read FUserName;
        property Appdir:string read GetAppDir;
        property Desktopdir:string read GetDesktopDir;
        property ThemesDir:string read GetThemesDir;
        property SystemDir:string read GetSystemDir;
        property CurrentThemeDir:string read GetCurrentThemeDir;
        property IconsDir:string read GetIconsDir;
        property BitmapsDir:string read GetBitmapsDir;
        constructor Create;
        destructor Destroy;override;
        function getSysInfo(const info: TSysInfo):string;
    end;

function StartApp(name: string; arguments: array of string;waitfor:boolean=false): Integer;

implementation

{ TXPAPI }

constructor TXPAPI.Create;
begin
    inherited;
    timer:=TTimer.create(nil);
    timer.enabled:=false;
    timer.interval:=500;
    timer.OnTimer:=ontimer;
    lastavg:=-1;
    FUserDir := getpwuid(getuid)^.pw_dir;
    FUserName:= getpwuid(getuid)^.pw_name;    
end;

destructor TXPAPI.Destroy;
begin
  timer.free;
  inherited;
end;

function StartApp(name: string; arguments: array of string;waitfor:boolean=false): Integer;
var
  pid: PID_T;
  Max: Integer;
  I: Integer;
  parg: PPCharArray;
  argnum: Integer;

begin
  Result := -1;

  pid := fork;

  if pid = 0 then
  begin
    Max := sysconf(_SC_OPEN_MAX);
    for i := (STDERR_FILENO+1) to Max do
    begin
      fcntl(i, F_SETFD, FD_CLOEXEC);
    end;

    argnum := High(Arguments) + 1;

    GetMem(parg,(2 + argnum) * sizeof(PChar));
    parg[0] := PChar(Name);

    i := 0;

    while i <= high(arguments) do
    begin
      inc(i);
      parg[i] := PChar(arguments[i-1]);
    end;

    parg[i+1] := nil;
    execvp(PChar(name),PPChar(@parg[0]));
    halt;
  end;

  if pid > 0 then
  begin
    if waitfor then begin
        result:=-1;
        while (result=-1)  do begin
            application.processmessages;
            waitpid(pid,@Result,wnohang);
        end;
    end;
  end;
end;


function S_ISEXEC(mode: __mode_t): Boolean;
begin
  Result := ((mode and __S_IEXEC)=__S_IEXEC);
end;

function TXPAPI.GetAppDir: string;
begin
    result:=extractfilepath(application.exename);
end;

function TXPAPI.GetBitmapsDir: string;
begin
    result:=CurrentThemeDir;
end;

function TXPAPI.GetCurrentThemeDir: string;
begin
    result:=ThemesDir+'default/32x32/';
end;

function TXPAPI.GetDesktopDir: string;
begin
    result:=userdir+'/.xpde/Desktop/';
end;

function TXPAPI.getExecutable(ext: string): string;
var
    reg: TRegistry;
    key: string;
begin
    result:='';

    reg:=TRegistry.create;
    try
        reg.RootKey:=HKEY_CLASSES_ROOT;
        if reg.OpenKey(ext,false) then begin
            key:=reg.ReadString('Default');
            if key<>'' then begin
                if reg.OpenKey(key+'/Shell/open/command',false) then begin
                    result:=trim(reg.ReadString('Default'));
                end;
            end;
        end;
    finally
        reg.free;
    end;
end;

function TXPAPI.GetIconsDir: string;
begin
    result:=CurrentThemeDir;
end;

function TXPAPI.GetSystemDir: string;
begin
    result:=Appdir+'system/';
end;

function TXPAPI.GetThemesDir: string;
begin
    result:=Appdir+'themes/';
end;

function TXPAPI.setCursor(bmp: TBitmap):QCursorH;
begin
    bmp.transparent:=true;
    result:=QCursor_create(bmp.handle,0,0);
    QForms.screen.cursors[crDefault]:=result;
    updateWidgets(application);
end;

//What a shame! ;-)
procedure TXPAPI.checkcpuload;
var
    f: string;
    h: integer;
    buf: array[0..50] of char;
    k: integer;
    avg: integer;
    savg: string;
    diff: integer;
begin
    timer.enabled:=true;
    f:='/proc/stat';
    h:=fileopen(f,fmOpenRead);
    try
        fileread(h,buf,50);
        savg:=buf;
        k:=pos(#10,savg);
        if k<>0 then begin
            savg:=copy(savg,1,k-1);
        end;
        for k:=length(savg) downto 1 do begin
            if savg[k]=' ' then begin
                savg:=copy(savg,k+1,length(savg));
                break;
            end;
        end;
        avg:=strtoint(savg);
        if lastavg=-1 then lastavg:=avg;
        diff:=avg-lastavg;
        lastavg:=avg;
        if diff>40 then begin
            setdefaultcursor;
            lastavg:=-1;
            timer.enabled:=false;
        end;
    finally
        fileclose(h);
    end;
end;

procedure TXPAPI.setDefaultCursor;
var
    bmp:TBitmap;
begin
    bmp:=TBitmap.create;
    try
        bmp.LoadFromFile(getSysInfo(siSystemDir)+sDEFAULTCURSOR);
        defaultcursor:=setcursor(bmp);
    finally
        bmp.free;
    end;
end;

procedure TXPAPI.setWaitCursor;
var
    bmp:TBitmap;
begin
    bmp:=TBitmap.create;
    try
        bmp.LoadFromFile(getSysInfo(siSystemDir)+sWAITCURSOR);
        defaultcursor:=setcursor(bmp);
    finally
        bmp.free;
    end;
end;

procedure TXPAPI.ShellDocument(const document: string);
var
    ext:string;
    sb: TStatBuf;
    executable: string;
    lnk:TLNKFile;
    lastdir: string;

begin
    libc.stat(PChar(document),sb);
    if s_isexec(sb.st_mode) then begin
        ShellExecute(document,false);
    end
    else begin
        executable:='';
        ext:=ansilowercase(extractfileext(document));
        if ext='.lnk' then begin
                    lnk:=TLNKFile.create(nil);
                    try
                        lnk.loadfromfile(document);
                        executable:=lnk.command;
                        if executable<>'' then begin
                            if lnk.Startin<>'' then begin
                                lastdir:=GetCurrentDir;
                                ChDir(lnk.Startin);
                            end;
                            ShellExecute(executable,false);

                            if lnk.Startin<>'' then begin
                                ChDir(lastdir);
                            end;
                        end;
                    finally
                        lnk.free;
                    end;
        end
        else begin
            executable:=getExecutable(ext);
            executable:=stringreplace(executable,'%1',document,[rfReplaceAll, rfIgnoreCase]);

            if executable='' then begin
                with TOpenWithDlg.create(application) do begin
                    filename:=document;
                    lbDocument.caption:=extractfilename(document);
                    show;
                end;
            end
            else ShellExecute(executable,false);
        end;
    end;
end;

function TXPAPI.ShellExecute(const prog: string;waitfor:boolean):integer;
var
    aprog:string;
begin
    aprog:=prog;
    if not waitfor then aprog:=aprog+' &';

    setwaitcursor;
    result:=Libc.system(PChar(aprog));
    if result = -1 then begin
        showmessage('Unnable to execute '+prog);
    end;
    checkcpuload;
end;

procedure TXPAPI.storeExecutable(ext, executable: string);
var
    reg: TRegistry;
    key:string;
begin
    reg:=TRegistry.create;
    try
        reg.RootKey:=HKEY_CLASSES_ROOT;
        if reg.OpenKey(ext,true) then begin
            key:=reg.ReadString('Default');
            if key='' then begin
                key:=ext+'.document.1';
                reg.WriteString('Default',key);
            end;
            if reg.OpenKey(key+'/Shell/open/command',true) then begin
                reg.WriteString('Default',executable);
            end;
        end;
    finally
        reg.free;
    end;
end;

procedure TXPAPI.updateWidgets(AOwner:TComponent);
var
    i:longint;
    c: TWidgetControl;
    procedure updateobject(aobject:TObject);
    begin
        if (aobject is TControl) then begin
            if (aobject as TControl).Cursor=crDefault then begin
                (aobject as TControl).Cursor:=crNone;
                (aobject as TControl).Cursor:=crDefault;
            end;
        end;
    end;
begin
    updateobject(aowner);
    for i:=0 to aowner.componentcount-1 do begin
        updatewidgets(aowner.components[i]);
    end;
    if aowner is TWidgetControl then begin
        c:=(aowner as TWidgetControl);
        for i:=0 to c.controlcount-1 do begin
            updatewidgets(c.controls[i]);
        end;
    end;
end;

procedure TXPAPI.ontimer(sender: TObject);
begin
    checkcpuload;
end;

function TXPAPI.getSysInfo(const info: TSysInfo): string;
begin
    case info of
        siUserDir: result:=UserDir;
        siUsername: result:=UserName;
        siAppDir: result:=AppDir;
        siDesktopDir: result:=DesktopDir;
        siThemesDir: result:=ThemesDir;
        siCurrentThemeDir: result:=CurrentThemeDir;
        siFileTypesDir: result:=CurrentThemeDir+'/filetypes/';
        siSystemDir: result:=CurrentThemeDir+'/system/';
        siApplicationsDir: result:=CurrentThemeDir+'/applications/';
    end;
end;

initialization
    XPAPI:=TXPAPI.create;

end.