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
unit uTaskBar;

interface

uses
  Xlib,SysUtils, Types,
  Classes, Variants, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QButtons, QMenus,
  QTypes, Libc, QExtCtrls,
  QComCtrls, QImgList, uXPIPC,
  uXPStyleConsts, Qt, QActnList,
  uQXPComCtrls, uXPCommon, 
  uXPPopupMenu,
  uXPAPI, uLNKFile, uXPStyle;

type
  TTaskBar = class(TForm)
    pnTimer: TPanel;
    Timer: TTimer;
    btnTimer: TTimer;
    tbTasks: TToolBar;
    Panel1: TPanel;
    btnStart: TBitBtn;
    topPanel: TPanel;
    pbLine: TPaintBox;
    startmenu: TXPPopupMenu;
    Programs1: TMenuItem;
    Documents1: TMenuItem;
    Settings1: TMenuItem;
    Search1: TMenuItem;
    HelpandSupport1: TMenuItem;
    Run1: TMenuItem;
    N7: TMenuItem;
    LogOffAdministrator1: TMenuItem;
    TurnOffComputer1: TMenuItem;
    imgProgramFolder: TImage;
    ImageList1: TImageList;
    propertiesmenu: TXPPopupMenu;
    Toolbars1: TMenuItem;
    N1: TMenuItem;
    CascadeWindows1: TMenuItem;
    TileWindowsHorizontally1: TMenuItem;
    TileWindowsVertically1: TMenuItem;
    ShowtheDesktop1: TMenuItem;
    N2: TMenuItem;
    TaskManager1: TMenuItem;
    N3: TMenuItem;
    LocktheTaskbar1: TMenuItem;
    Properties1: TMenuItem;
    emptytask: TImage;
    netpopup: TXPPopupMenu;
    Disable1: TMenuItem;
    Status1: TMenuItem;
    Repair1: TMenuItem;
    N4: TMenuItem;
    OpenNetworkConnections1: TMenuItem;
    pnTray: TPanel;
    lbTimer: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btnStartMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnTimerTimer(Sender: TObject);
    procedure pbLinePaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToolButton1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure startmenuHide(Sender: TObject);
    procedure LogOffAdministrator1Click(Sender: TObject);
    procedure Run1Click(Sender: TObject);
    procedure TaskManager1Click(Sender: TObject);
    procedure imNetDblClick(Sender: TObject);
    procedure TurnOffComputer1Click(Sender: TObject);
    procedure pnTimerDblClick(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    menupaths: TStringList;
    procedure OnMenuItemClick(Sender: TObject);
    procedure populateMenu(item: TMenuItem; dir: string);
    { Private declarations }
  public
    { Public declarations }
    activetasks:TList;                                                          //TToolButton list for active tasks
    //Menu related functions
    procedure releasebuttons;
    procedure IPCNotification(Sender:TObject; msg:integer; data: integer);
    procedure ShowMenu;
    procedure updatetaskswidth;
    procedure createTask(const client:IWMClient);
    procedure updatetask(const task:IWMClient);
    procedure activatetask(const task:IWMClient);
    procedure removeTask(const client:IWMClient);
    procedure updatetraysize;
    procedure addwindowtotray(const w: window);
    procedure removewindowfromtray(const w: window);
  end;

  TXPTaskBar=class(TInterfacedObject, IXPTaskBar)
        procedure addwindowtotray(const w: window);
        procedure removewindowfromtray(const w: window);         
        procedure addtask(const task:IWMClient);
        procedure updatetask(const task:IWMClient);
        procedure activatetask(const task:IWMClient);
        procedure removetask(const task:IWMClient);
        function getRect:TRect;
        procedure bringtofront;
  end;

var
  TaskBar: TTaskBar;
  lastevent: integer=0;
  lastw:TWindow=0;
  inupdate: boolean=false;

implementation

{$R *.xfm}

uses uWindowManager, uTurnOff;

function GetTickCount:integer;
var
  T: TTime_T;
  TV: TTimeVal;
  UT: TUnixTime;
begin
  gettimeofday(TV, nil);
  T := TV.tv_sec;
  localtime_r(@T, UT);
  Result := UT.tm_sec;
end;

procedure TTaskBar.FormCreate(Sender: TObject);
    procedure loadMenuBitmap(target:TBitmap;const img:string);
    var
        b:TBitmap;
        c:TBitmap;
    begin

        b:=TBitmap.create;
        c:=TBitmap.create;
        try
            target.width:=32;
            target.height:=32;
            c.width:=32;
            c.height:=32;
//            c.Canvas.Brush.color:=0;
//            c.Canvas.FillRect(rect(0,0,32,32));
            b.loadfromfile(XPAPI.getsysinfo(siMediumSystemDir)+img);
            bitblt2(b,c,4,4,22,22);
//            c.Canvas.Draw(4,4,b);
//            c.transparent:=true;
            bitblt2(c,target,0,0,32,32);
//            target.assign(c);
        finally
            c.free;
            b.free;
        end;

        target.loadfromfile(XPAPI.getsysinfo(siMiscDir)+img);
    end;
begin
    XPIPC.OnNotification:=IPCNotification;
    
    XPAPI.setdefaultcursor;

    //*****************************************************
    btnStart.Glyph.LoadFromFile(XPAPI.getsysinfo(siMiscDir)+gSTARTBUTTON);
    startmenu.backbitmap.loadfromfile(XPAPI.getsysinfo(siMiscDir)+gSTARTMENU);
    imgProgramFolder.picture.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'folder.png');
    //*****************************************************
    loadMenuBitmap(programs1.bitmap,'folder.png');
    loadMenuBitmap(documents1.bitmap,'contents.png');
    loadMenuBitmap(settings1.bitmap,'configure.png');
    loadMenuBitmap(search1.bitmap,gSearch);
    loadMenuBitmap(helpandsupport1.bitmap,'help.png');
    loadMenuBitmap(run1.bitmap,'run.png');
    loadMenuBitmap(logoffadministrator1.bitmap,'stop.png');
    loadMenuBitmap(turnoffcomputer1.bitmap,'exit.png');
    //*****************************************************


    menuPaths:=TStringList.create;
    LogOffAdministrator1.caption:=LogOffAdministrator1.caption+' '+XPAPI.getsysinfo(siUserName)+'...';

    populatemenu(programs1,XPAPI.getsysinfo(siUserDir)+'/.xpde/Start Menu/Programs');

    activetasks:=TList.create;
    tbTasks.buttonheight:=22;
    tbTasks.buttonwidth:=163;


    //Shows the current time
    TimerTimer(Timer);

    //Initial Taskbar Position
    left:=0;
    height:=28;
    top:=screen.Height-height;
    width:=screen.width;

    lbTimer.Font.Size:=5;
    lbTimer.Font.Assign(pnTimer.font);

end;

procedure TTaskBar.FormPaint(Sender: TObject);
begin
    with canvas do begin
        //Taskbar's top line
        pen.color:=dclBtnHighlight;
        moveto(0,1);
        lineto(clientwidth,1);
    end;
end;

procedure TTaskBar.TimerTimer(Sender: TObject);
begin
    lbTimer.Caption:=formatdatetime(sTimeFormat,now);
end;

procedure TTaskBar.btnStartMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    releaseButtons;
    showmenu;
end;

procedure TTaskBar.ShowMenu;
var
    p: TPoint;
begin
        QPopupMenu_updateItem(startmenu.handle,0);
        p:=btnStart.BoundsRect.TopLeft;
        p:=btnStart.ClientToScreen(p);
        p.Y:=p.Y-QWidget_height(startmenu.handle);
        startmenu.popup(p.x-2,p.y-2);
end;


procedure TTaskBar.btnTimerTimer(Sender: TObject);
begin
    QButton_setDown(btnStart.handle,false);
    application.processmessages;
    btnTimer.enabled:=false;
end;

procedure TTaskBar.pbLinePaint(Sender: TObject);
begin
    with pbLine.canvas do begin
        //Taskbar's top line
        pen.color:=dclBtnHighlight;
        moveto(0,1);
        lineto(clientwidth,1);
    end;
end;

procedure TTaskbar.createTask(const client:IWMClient);
var
    t: TToolButton;
    found: boolean;
    i:integer;
    w: TWindow;
begin
    w:=client.getwindow;
    found:=false;
    for i := 0 to tbTasks.ControlCount - 1 do begin
        if (tbTasks.Controls[I] is TToolButton) then begin
            t:=(tbTasks.Controls[I] as TToolButton);
            if cardinal(t.tag)=w then begin
                t.caption:=client.gettitle;
                t.hint:=client.getTitle;
                t.PopupMenu:=client.getSystemMenu;
                activetasks.add(t);
                found:=true;
                break;
            end;
        end;
    end;
    if not found then begin
        t:=TToolButton.create(tbTasks);
        t.Caption:=client.gettitle;
        t.Hint:=client.gettitle;
        t.PopupMenu:=client.getSystemMenu;
        t.OnMouseUp:=toolbutton1mouseup;
        t.Bitmap.Assign(client.getbitmap);
        t.showhint:=false;
        t.Tag:=w;
        t.allowallup:=true;
        t.grouped:=true;
        t.style:=tbsCheck;
        activetasks.add(t);
        updatetaskswidth;
        t.Parent:=tbTasks;
    end;
end;

procedure TTaskBar.FormDestroy(Sender: TObject);
begin
    activetasks.free;
    menuPaths.free;
end;

procedure TTaskBar.ToolButton1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    w: Window;
    c: TWMClient;
begin
    w:=(Sender as TToolButton).tag;
    c:=XPWindowManager.findClient(w);
    if assigned(c) then c.activate;
end;

procedure TTaskBar.startmenuHide(Sender: TObject);
begin
    btnStart.Toggle;
//    QButton_setDown(btnStart.handle,false);
//    application.processmessages;
end;

procedure TTaskBar.LogOffAdministrator1Click(Sender: TObject);
begin
    application.terminate;
end;

procedure TTaskBar.Run1Click(Sender: TObject);
begin
    XPAPI.ShellExecute(XPAPI.getSysInfo(siAppletsDir)+'appexec',false);
end;

procedure TTaskBar.OnMenuItemClick(Sender: TObject);
var
    path:string;
begin
    path:=menupaths[(sender as TMenuItem).tag];
    XPAPI.ShellDocument(path);
end;

procedure TTaskBar.populateMenu(item: TMenuItem; dir: string);
var
    sr:TSearchRec;
    d: TMenuItem;
    folders:TStringList;
    files:TStringList;
    i:integer;
    l: TLNKFile;
    iconfile:string;
    ext: string;
    f: TPicture;
begin
    item.Clear;
    folders:=TStringList.create;
    files:=TStringList.create;
    try
        files.sorted:=true;
        folders.sorted:=true;
    if findfirst(dir+'/*',faAnyFile,sr)=0 then begin
        repeat
            if (sr.Attr and faDirectory)=faDirectory then begin
                if (sr.name<>'.') and (sr.name<>'..') then begin
                    folders.add(sr.name);
                end;
            end
            else begin
                    files.add(sr.name);
            end;
        until findnext(sr)<>0;
    end;
    findclose(sr);
        for i:=0 to folders.count-1 do begin
            d:=TMenuItem.create(item);
            d.caption:=folders[i];
            d.Bitmap.loadfromfile(XPAPI.getsysinfo(siSmallSystemDir)+'folder.png');
            //d.Bitmap:=imgProgramFolder.picture.bitmap;
            item.add(d);
            d.Tag:=menupaths.add(dir+'/'+folders[i]);
            populateMenu(d,dir+'/'+folders[i]);
        end;
        for i:=0 to files.count-1 do begin
            d:=TMenuItem.create(item);
            ext:=ansilowercase(extractfileext(files[i]));
            if ext='.lnk' then begin
                l:=TLNKFile.create(nil);
                f:=TPicture.create;
                try
                    l.loadfromfile(dir+'/'+files[i]);
                    if trim(l.caption)<>'' then d.caption:=l.Caption
                    else d.caption:=changefileext(files[i],'');

                    iconfile:=XPAPI.getsysinfo(siSmallSystemDir)+gNOICON;
                    if trim(l.icon)<>'' then begin
                        if (fileexists(l.icon)) then iconfile:=l.icon
                        else begin
                            if (fileexists(XPAPI.getsysinfo(siSystemDir)+l.Icon)) then begin
                                iconfile:=XPAPI.getsysinfo(siSystemDir)+l.Icon;
                            end
                            else iconfile:=XPAPI.getsysinfo(siSmallSystemDir)+gNOICON;
                        end;
                    end
                    else begin
                        iconfile:=XPAPI.getsysinfo(siSystemDir)+changefileext(files[i],'.ico');
                        if not fileexists(iconfile) then begin
                            iconfile:=XPAPI.getsysinfo(siSmallSystemDir)+gNOICON;
                        end;
                    end;

                    try
                        f.LoadFromFile(iconfile);
                        f.graphic.width:=16;
                        f.graphic.height:=16;
                    except
                        iconfile:=XPAPI.getsysinfo(siSmallSystemDir)+gNOICON;
                        f.LoadFromFile(iconfile);
                        f.graphic.width:=16;
                        f.graphic.height:=16;
                    end;

                    d.bitmap.canvas.brush.color:=clFuchsia;
                    d.bitmap.canvas.pen.color:=clFuchsia;
                    d.Bitmap.width:=16;
                    d.Bitmap.height:=16;
                    if f.graphic.Width>16 then begin
                        d.bitmap.canvas.stretchdraw(rect(0,0,16,16),f.graphic);
                    end
                    else begin
                        d.bitmap.canvas.draw(0,0,f.graphic);
                    end;
                    d.bitmap.transparent:=true;
                    d.Bitmap.loadfromfile(iconfile);

                finally
                    f.free;
                    l.free;
                end;
            end
            else begin
                d.caption:=changefileext(files[i],'');
            end;
            d.Tag:=menupaths.add(dir+'/'+files[i]);
            d.onclick:=onmenuitemclick;
            item.add(d);
        end;
    finally
        files.free;
        folders.free;
    end;
end;

procedure TTaskBar.TaskManager1Click(Sender: TObject);
begin
    XPAPI.ShellExecute(XPAPI.getsysinfo(siAppsdir)+'taskmanager',false);
end;


{ TXPTaskBar }

procedure TXPTaskBar.activatetask(const task: IWMClient);
begin
    taskbar.activatetask(task);
end;

procedure TXPTaskBar.addtask(const task: IWMClient);
begin
    taskbar.createTask(task);
end;

procedure TXPTaskBar.addwindowtotray(const w: window);
begin
    taskbar.addwindowtotray(w);
end;

procedure TXPTaskBar.bringtofront;
begin
    taskbar.BringToFront;
end;

function TXPTaskBar.getRect: TRect;
begin
    result:=taskbar.BoundsRect;
end;

procedure TXPTaskBar.removetask(const task: IWMClient);
begin
    {$ifdef DEBUG}
    xlibinterface.outputDebugString(iMETHOD,'TXPTaskbar.removetask');
    {$endif}
    taskbar.removeTask(task);
end;

procedure TTaskBar.removeTask(const client: IWMClient);
var
    t: TToolButton;
    i:integer;
    w: TWindow;
begin
    {$ifdef DEBUG}
    xlibinterface.outputDebugString(iMETHOD,'TTaskBar.RemoveTask');
    {$endif}
    w:=client.getwindow;
    for i := 0 to tbTasks.ControlCount - 1 do begin
        if (tbTasks.Controls[I] is TToolButton) then begin
            t:=(tbTasks.Controls[I] as TToolButton);
            if cardinal(t.tag)=w then begin
                {$ifdef DEBUG}
                xlibinterface.outputDebugString(iMETHOD,'ActiveTasks.remove');
                {$endif}
                activetasks.remove(t);
                {$ifdef DEBUG}
                xlibinterface.outputDebugString(iMETHOD,'ToolButton.free');
                {$endif}
                t.free;
                {$ifdef DEBUG}
                xlibinterface.outputDebugString(iMETHOD,'updatetaskswidth');
                {$endif}
                updatetaskswidth;
                break;
            end;
        end;
    end;
    {$ifdef DEBUG}
    xlibinterface.outputDebugString(iMETHOD,'TTaskBar.RemoveTask, end');
    {$endif}
end;

procedure TTaskBar.updatetaskswidth;
var
    bw: integer;
begin
        if activetasks.count>0 then begin
            bw:=trunc((tbtasks.clientWidth-2) / activetasks.count);
            if bw>163 then bw:=163;
            if bw<>tbtasks.buttonwidth then tbTasks.ButtonWidth:=bw;
        end;
        tbTasks.ButtonHeight:=22;
        tbTasks.Invalidate;
end;

procedure TTaskBar.activatetask(const task: IWMClient);
var
    t: TToolButton;
    i:integer;
    w: TWindow;
    k: integer;
begin
    {$ifdef DEBUG}
    xlibinterface.outputDebugString(iMETHOD,'TTaskBar.activatetask');
    {$endif}
    if assigned(task) then begin
        w:=task.getwindow;
        for i := 0 to tbTasks.ControlCount - 1 do begin
            if (tbTasks.Controls[I] is TToolButton) then begin
                t:=(tbTasks.Controls[I] as TToolButton);
                if cardinal(t.tag)=w then begin
                    {$ifdef DEBUG}
                    xlibinterface.outputDebugString(iINFO,'new activetask found');
                    {$endif}
                    for k := 0 to tbTasks.ControlCount - 1 do begin
                        if (tbTasks.Controls[k] is TToolButton) then begin
                            (tbTasks.Controls[k] as TToolButton).Down:=false;
                        end;
                    end;
                    t.Down:=true;
                    break;
                end;
            end;
        end;
    end
    else begin
        releaseButtons;
    end;
end;

procedure TTaskBar.imNetDblClick(Sender: TObject);
begin
    XPAPI.ShellExecute(XPAPI.getsysinfo(siAppletsDir)+'networkstatus -i eth0',false);
end;

procedure TTaskBar.TurnOffComputer1Click(Sender: TObject);
begin
    turnoff.showmodal;
end;

procedure TTaskBar.pnTimerDblClick(Sender: TObject);
var
    appletsdir: string;
    stub: string;
    applet: string;
    command: string;
begin
    appletsdir:=XPAPI.getsysinfo(siAppletsDir);

    stub:=XPAPI.getsysinfo(siAppDir)+'stub.sh';
    applet:=appletsdir+'DateTimeProps';

    command:=format('%s/xpsu root "%s %s"',[appletsdir, stub, applet]);

    XPAPI.ShellExecute(command,false);
end;

procedure TTaskBar.Settings1Click(Sender: TObject);
begin
    XPAPI.ShellExecute(XPAPI.getsysinfo(siAppsdir)+'fileexplorer -f %CONTROLPANEL%',false);
end;

procedure TTaskBar.IPCNotification(Sender: TObject; msg, data: integer);
begin
    case msg of
        XPDE_ADDTRAYICON: begin
            addwindowtotray(data);
        end;
        XPDE_REMOVETRAYICON: begin
            removewindowfromtray(data);
        end;
    end;
end;

procedure TTaskBar.addwindowtotray(const w: window);
var
    p: TPanel;
    p_attr:XSetWindowAttributes;
    parent: window;
begin
    p:=TPanel.create(self);
    p.Width:=18;
    p.height:=16;
    p.BevelOuter:=bvNone;
    p.Parent:=pnTray;
    p.align:=alRight;
    p.tag:=w;

	XSelectInput(application.display, w, ColormapChangeMask or EnterWindowMask or PropertyChangeMask);

	p_attr.override_redirect := 1;
	p_attr.event_mask := ChildMask or ButtonPressMask or ExposureMask or EnterWindowMask;

    parent:=QWidget_winID(p.Handle);

	XAddToSaveSet(application.display, w);
	XSetWindowBorderWidth(application.display, w, 0);
    XChangeWindowAttributes(application.display,parent,CWOverrideRedirect or CWEventMask, @p_attr);

    XReparentWindow(application.display,w,parent,1,0);

    XResizeWindow(application.display,w,16,16);
    XMapWindow(application.display,w);

    updatetraysize;
end;

procedure TTaskBar.removewindowfromtray(const w: window);
var
    i:longint;
    p: TPanel;
begin
    for i:=pnTray.ControlCount-1 downto 0 do begin
        p:=pnTray.controls[i] as TPanel;
        if p.tag=w then begin
            p.free;
            break;
        end;
    end;
    updatetraysize;
end;

procedure TTaskBar.updatetraysize;
var
    wi: integer;
begin
    if pnTray.controlcount=0 then begin
        pnTimer.width:=50;
        pnTray.width:=0;
        pnTimer.invalidate;
        pnTimer.update;
    end
    else begin
        wi:=(pnTray.ControlCount*18);
        pnTimer.width:=wi+45;
        pnTray.width:=wi+2;
        pnTimer.invalidate;
        pnTimer.update;
    end;
end;

procedure TTaskBar.FormShow(Sender: TObject);
begin
    updatetraysize;
end;

procedure TXPTaskBar.removewindowfromtray(const w: window);
begin
    taskbar.removewindowfromtray(w);
end;

procedure TXPTaskBar.updatetask(const task: IWMClient);
begin
    taskbar.updatetask(task);
end;

procedure TTaskBar.updatetask(const task: IWMClient);
var
    t: TToolButton;
    i:integer;
    w: TWindow;
    k: integer;
begin
    {$ifdef DEBUG}
    xlibinterface.outputDebugString(iMETHOD,'TTaskBar.updatetask');
    {$endif}
    w:=task.getwindow;
    for i := 0 to tbTasks.ControlCount - 1 do begin
        if (tbTasks.Controls[I] is TToolButton) then begin
            t:=(tbTasks.Controls[I] as TToolButton);
            if cardinal(t.tag)=w then begin
                {$ifdef DEBUG}
                xlibinterface.outputDebugString(iINFO,'updatetask found');
                {$endif}
                t.Caption:=task.getTitle;
                break;
            end;
        end;
    end;
end;

procedure TTaskBar.releasebuttons;
var
    i:integer;
begin
    for I := 0 to tbTasks.ControlCount - 1 do begin
        if (tbTasks.Controls[I] is TToolButton) then begin
            (tbTasks.Controls[I] as TToolButton).Down:=false;
        end;
    end;
end;

initialization
  XPTaskBar:=TXPTaskbar.create;



end.
