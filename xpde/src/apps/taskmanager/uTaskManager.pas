unit uTaskManager;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QMenus, QTypes, QExtCtrls, QComCtrls,uQXPComCtrls;

type
  TWindowsTaskManagerDlg = class(TForm)
        Button7:TButton;
        CheckBox37:TCheckBox;
    LVNet: TListView;
        Button6:TButton;
        Button5:TButton;
        Button4:TButton;
    LUsers: TListView;
        Button3:TButton;
        Button2:TButton;
        Button1:TButton;
        ListView1:TListView;
        StatusBar1:TStatusBar;
        PageControl1:TPageControl;
        TabSheet5:TTabSheet;
        TabSheet4:TTabSheet;
        TabSheet3:TTabSheet;
        TabSheet2:TTabSheet;
        TabSheet1:TTabSheet;
        MainMenu: TMainMenu;
    ShutDown1: TMenuItem;
    View1: TMenuItem;
    LargeIcons1: TMenuItem;
    SmallIcons1: TMenuItem;
    UpdateSpeed1: TMenuItem;
    UpdSp1: TMenuItem;
    UpdSp3: TMenuItem;
    UpdSp4: TMenuItem;
    UpdSp2: TMenuItem;
    Details1: TMenuItem;
    File1: TMenuItem;
    ExitTaskManager1: TMenuItem;
    NewTaskRun1: TMenuItem;
    Timer1: TTimer;
    TreeView2: TTreeView;
    RefreshNow1: TMenuItem;
    Help1: TMenuItem;
    AboutTaskManager1: TMenuItem;
    GBox1: TGroupBox;
    Pan1: TPanel;
    PB1: TPaintBox;
    GBox2: TGroupBox;
    Pan2: TPanel;
    PB2: TPaintBox;
    GBox3: TGroupBox;
    GBox4: TGroupBox;
    GBox5: TGroupBox;
    GBox6: TGroupBox;
    GBox7: TGroupBox;
    GBox8: TGroupBox;
    Pan3: TPanel;
    PB3: TPaintBox;
    Pan4: TPanel;
    PB4: TPaintBox;
    Lab1: TLabel;
    Lab2: TLabel;
    Lab3: TLabel;
    Lab4: TLabel;
    Lab5: TLabel;
    Lab6: TLabel;
    Lab7: TLabel;
    Lab8: TLabel;
    Lab9: TLabel;
    Lab10: TLabel;
    Lab11: TLabel;
    Lab12: TLabel;
    Lab13: TLabel;
    Lab14: TLabel;
    Lab15: TLabel;
    Lab16: TLabel;
    Lab17: TLabel;
    Lab18: TLabel;
    Lab19: TLabel;
    Lab20: TLabel;
    Lab21: TLabel;
    Lab22: TLabel;
    Lab23: TLabel;
    Lab24: TLabel;
    Timer2: TTimer;
    Timer3: TTimer;
    GBox9: TGroupBox;
    Pan5: TPanel;
    PB5: TPaintBox;
    procedure ExitTaskManager1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UpdSp1Click(Sender: TObject);
    procedure CheckBox37Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RefreshNow1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure AboutTaskManager1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure NewTaskRun1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    Procedure Get_PIDS_Apps(cmdline:string);
    Procedure Read_stats(statsfile_:string);
    Procedure Read_Net(netfile:string);
    Procedure Paint_PB1;
    procedure Paint_PB2;
    procedure Paint_PB3;
    procedure Paint_PB4;
    procedure Paint_PB5;        
    Procedure MemInfo(kind_:integer; memfile_:string);
    Procedure AverageLoad(avg_file:string);
    Procedure Fill_Net_Devices;
    Procedure Find_Lusers; // ;)    
    { Private declarations }
  public
    Procedure Fill_Applications;
    Procedure Fill_Processes;
    { Public declarations }
  end;

var
  WindowsTaskManagerDlg: TWindowsTaskManagerDlg;

implementation
uses Libc, uAboutTaskManager, uCreateNewTask;

Const PRIO_NORMAL=10000;
      PRIO_HIGH=3000;
      PRIO_LOW=30000;
      PRIO_PAUSED=false;
      // Consts  for updating taskmanager ..
      // this is my test mode so we can change it later to anything
      // I will rewrite completely loading of procs and abandon
      // using of ps for such purpose.

var tmpstr,tmpstr_stat:TStrings;
    is_all:boolean; // Show all procs ? This is for checkbox37
    num_forks:string; // num of forks since boot
    CPUuser_, CPUsyst_:longint;
    diff_user,diff_syst:longint;
    swp_total,swp_used,swp_free:single;
    um_y:integer; // user_matrix position
    um_x:integer; // syst_matrix position
    du_y:integer; // devs_matrix position
    user_matrix:Array[0..228] of longint; // width points of PB2
    syst_matrix:Array[0..228] of longint; // width points of PB4
    devs_matrix:Array[0..20,0..351] of longint; // width points of PB5
        // FIXME now we have max 21 net device ;)
    dev_names:Array[0..20] of string;
    diff_net:Array[0..20,0..0] of double;
    //FIXME This values will be replaced to dynamic array PB*.Width
{$R *.xfm}
{$INCLUDE network.inc}


function _get_tmp_fname:String;
begin
        Result:='/tmp/'+FormatDateTime('XPdeTaskManager.hh.mm.ss.ms',Now)+
        Format('.%d.%d.%d',[Random($FFFF),Random($FFFF),Random($FFFF)]);
end;

function _cut_left(const SUBSTR, FROMSTR:string):string;
begin
  Result:=Copy(FROMSTR,Pos(SUBSTR,FROMSTR)+Length(SUBSTR),$FFFFFFF);
end;

function _cut_right(const SUBSTR, FROMSTR:string):string;
begin
  Result:=FROMSTR;
  Delete(Result,Pos(SUBSTR,Result),$FFFFFFF);
end;

function _cut_token(const SUBSTR_LEFT, SUBSTR_RIGHT, FROMSTR:string):string;
begin
  Result:=_cut_right(SUBSTR_RIGHT,_cut_left(SUBSTR_LEFT,FROMSTR));
end;


procedure TWindowsTaskManagerDlg.ExitTaskManager1Click(Sender: TObject);
begin
        Close;
end;

procedure TWindowsTaskManagerDlg.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
        CanClose:=false;
        if MessageDlg('Close Task Manager ?',mtConfirmation,[mbYes,mbNo],0,mbYes)=mrYes
        then
        CanClose:=true;
end;

procedure TWindowsTaskManagerDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        Action:=caFree;
end;

Procedure TWindowsTaskManagerDlg.Get_PIDS_Apps(cmdline:string);
var cmdline__,tmpfile__:string;
Begin
        tmpfile__:=_get_tmp_fname;
        cmdline__:=cmdline+' > '+tmpfile__;
// FIRST TAB WILL CONTAIN LIST OF APPS (PARENT PROCESSES)
// SECOND TAB WILL CONTAIN TREE OF PROCESSESS
// NAME         %CPU    %MEM    USER    PID
//    \_NAME    %CPU    %MEM    USER    PID
//    \_NAME    %CPU    %MEM    USER    PID
        Libc.System(PChar(cmdline__));
        if not FileExists(tmpfile__) then
                raise Exception.Create(
                'Error : Could not execute ps !'+#13#10+
                'Check your writing rights in the current directory.');
        tmpstr.LoadFromFile(tmpfile__);
        DeleteFile(tmpfile__);
End;

Procedure TWindowsTaskManagerDlg.Fill_Applications;
// FILL TAB -> APPLICATIONS
var i,j,x:integer;
    ss,pidcmd:string;
    ssa:Array[0..2] of string; // pid , command , flags (won't be shown)
    procs:Array[0..1024,0..1] of string; // FIXME
Begin
        ListView1.Items.Clear;
        tmpstr:=TStringList.Create;
        try
        pidcmd:='ps -xo pid,ucomm,flags --sort pid | grep 000';
        Get_PIDS_Apps(pidcmd);
        except
        tmpstr.Free;
        exit;
        End;
        ListView1.Items.BeginUpdate;
        for i:=0 to tmpstr.Count-1 do begin
        ss:='';
        ss:=tmpstr.Strings[i];
        ss:=trimleft(ss);
                for x:=0 to 2 do begin
                j:=pos(' ',ss);
                ssa[x]:=copy(ss,1,j-1);
                ss:=copy(ss,j,length(ss)-j);
                ss:=trimleft(ss);
                End;
        procs[i][0]:=ssa[0];
        procs[i][1]:=ssa[1];
        ListView1.Items.Add.Subitems.Add(procs[i][1]);
        ListView1.Items.Item[i].Caption:=procs[i][0];
        End;
        ListView1.Items.EndUpdate;
        tmpstr.Free;
End;

Procedure TWindowsTaskManagerDlg.Fill_Processes;
var i,j,x,jj:integer;
    ss,pidcmd:string;
    ssa:Array[0..4] of string; // pid , %cpu , %mem, user, ucomm
    procs:Array[0..1024,0..4] of string; // FIXME
    tnode:TTreeNode;
Begin
        tnode:=Nil;
        TreeView2.Items.Clear;
        tmpstr:=TStringList.Create;
        TreeView2.Items.BeginUpdate;
        try
        if is_all then
        pidcmd:='ps -axfo pid,%cpu,%mem,user,ucomm --sort pid'
        else
        pidcmd:='ps -xfo pid,%cpu,%mem,user,ucomm --sort pid';
        Get_PIDS_Apps(pidcmd);
        except
        tmpstr.Free;
        exit;
        End;

                for i:=1 to tmpstr.Count-1 do begin
                ss:='';
                ss:=tmpstr.Strings[i];
                ss:=trimleft(ss);

                        for x:=0 to 4 do begin

                                case x of
                                0..3:Begin
                                     j:=pos(' ',ss);
                                     ssa[x]:=copy(ss,1,j-1);
                                     ss:=copy(ss,j,length(ss)-(j-1));
                                     ss:=trimleft(ss);
                                     End;
                                   4:Begin
                                     ssa[4]:=ss;
                                     End;
                                 End;
                        End;

        procs[i][0]:=ssa[0];
        procs[i][1]:=ssa[1];
        procs[i][2]:=ssa[2];
        procs[i][3]:=ssa[3];
        procs[i][4]:=ssa[4];

        jj:=Pos('\',procs[i][4]);

                if jj<>0 then begin
                // WE FOUND A CHILD PROCESS
                procs[i][4]:=copy(procs[i][4],jj+2,length(procs[i][4])-(jj+1));
                procs[i][4]:=trimleft(procs[i][4]);
                TreeView2.Items.AddChild(tnode,procs[i][4]);
                TreeView2.Items.Item[i-1].SubItems.Add(procs[i][1]);
                TreeView2.Items.Item[i-1].SubItems.Add(procs[i][2]);
                TreeView2.Items.Item[i-1].SubItems.Add(procs[i][3]);
                TreeView2.Items.Item[i-1].SubItems.Add(procs[i][0]);
                end else begin
                tnode:=TreeView2.Items.Add(Nil,procs[i][4]);
                TreeView2.Items.Item[i-1].SubItems.Add(procs[i][1]);
                TreeView2.Items.Item[i-1].SubItems.Add(procs[i][2]);
                TreeView2.Items.Item[i-1].SubItems.Add(procs[i][3]);
                TreeView2.Items.Item[i-1].SubItems.Add(procs[i][0]);
                End;
                End;
                TreeView2.Items.EndUpdate;
        tmpstr.Free;
End;

procedure TWindowsTaskManagerDlg.Timer1Timer(Sender: TObject);
begin
        // Application.ProcessMessages;
        if PageControl1.ActivePage=TabSheet1 then
        Fill_Applications else
        if PageControl1.ActivePage=TabSheet5 then
        Fill_Processes;

        Fill_Net_Devices; // FILL it always, since we have history graph per device
        Find_Lusers;
end;

procedure TWindowsTaskManagerDlg.FormShow(Sender: TObject);
var j,jj:integer;
begin
        for j:=0 to PB2.Width do
        user_matrix [j]:=PB2.Height;

        for j:=0 to PB4.Width do
        syst_matrix [j]:=PB4.Height;

        for jj:=0 to 20 do
        for j:=0 to PB5.Width do
        devs_matrix [jj,j]:=PB5.Height;

        for jj:=0 to 20 do
        diff_net[jj,0]:=0;

        CPUUser_:=1;
        CPUSyst_:=1;
        um_y:=0;
        um_x:=0;
        du_y:=0;

        Timer3.Enabled:=false;
        ListView1.Columns[0].Width:=ListView1.Width div 4;
        ListView1.Columns[1].Width:=(ListView1.Width div 2)+(ListView1.Width div 8);
        TreeView2.Columns[0].Width:=(TreeView2.Width div 3)+(TreeView2.Width div 9);
        TreeView2.Columns[1].Width:=TreeView2.Width div 8;
        TreeView2.Columns[2].Width:=TreeView2.Width div 8;
        TreeView2.Columns[3].Width:=TreeView2.Width div 8;
        TreeView2.Columns[4].Width:=TreeView2.Width div 8;
        is_all:=Checkbox37.Checked;
        Fill_Applications;
        Timer1.Interval:=PRIO_NORMAL;
        Fill_Processes;
        MemInfo(1,'/proc/meminfo');
        MemInfo(2,'/proc/meminfo');
        AverageLoad('/proc/loadavg');
        Read_Net('/proc/net/dev');
        Fill_Net_Devices;
        Find_Lusers;
end;

procedure TWindowsTaskManagerDlg.UpdSp1Click(Sender: TObject);
var menit:TMenuItem;
    ss:string;
    i:integer;
begin
menit:=Sender As TMenuItem;
ss:=copy(menit.Name,6,1);
i:=StrToInt(ss);
case i of
        1:Begin
          Timer1.Enabled:=true;
          Timer1.Interval:=PRIO_HIGH;
          End;
        2:Begin
          Timer1.Enabled:=true;
          Timer1.Interval:=PRIO_NORMAL;
          End;
        3:Begin
          Timer1.Enabled:=true;
          Timer1.Interval:=PRIO_LOW;
          End;
        4:Begin
          Timer1.Enabled:=false;
          End;
        else
        Timer1.Enabled:=false;
        End;
end;

procedure TWindowsTaskManagerDlg.CheckBox37Click(Sender: TObject);
begin
        is_all:=CheckBox37.Checked;
        Fill_Processes;
end;


procedure TWindowsTaskManagerDlg.RefreshNow1Click(Sender: TObject);
begin
        Fill_Processes;
        Fill_Applications;
end;


procedure TWindowsTaskManagerDlg.Button1Click(Sender: TObject);
var i:integer;
    ss,cmd:string;
begin
        Timer1.Enabled:=false;
        // WE STOP TIMER SINCE WE DON'T WANT CLEARED ListView in a moment ;)
        if MessageDlg('Kill selected tasks ?',mtConfirmation,[mbYes,mbNo],0,mbNo)=mrYes
        then begin
        for i:=0 to ListView1.Items.Count-1 do begin
        if ListView1.Items.Item[i].Checked then begin
        ss:=ListView1.Items.Item[i].Caption;
        cmd:='kill -SIGTERM '+ss; // ANY BETTER IDEA ?
        if Libc.system(PChar(cmd))<>0 then
        raise Exception.Create('Cannot kill process PID '+ss+' !');
        End;
        End;
        End;
        // Refill ListView .. we should do this anyway because if we select
        // a lot of tasks to kill it will be executed every time in the above loop
        // so we spare some CPU time here.
        Fill_Applications;
        // Enable timer
        Timer1.Enabled:=true;
end;


procedure TWindowsTaskManagerDlg.Button7Click(Sender: TObject);
var i:integer;
    ss,cmd:string;
begin
        Timer1.Enabled:=false;
        // WE STOP TIMER SINCE WE DON'T WANT CLEARED TreeView in a moment ;)
        if MessageDlg('Kill selected tasks ?',mtConfirmation,[mbYes,mbNo],0,mbNo)=mrYes
        then begin
        i:=treeview2.Selected.AbsoluteIndex;
        try
        ss:=TreeView2.Items.Item[i].SubItems.Strings[3];
        cmd:='kill -SIGTERM '+ss; // ANY BETTER IDEA ?
        // yes , I'll rewrite this part soon and use libc.kill
        if Libc.system(PChar(cmd))<>0 then
        raise Exception.Create('Cannot kill process PID '+ss+' !');
        except
        raise Exception.Create('You must select process !');
        End;
        end;
        Fill_Processes;
        // Back timer
        Timer1.Enabled:=true;
End;

procedure TWindowsTaskManagerDlg.AboutTaskManager1Click(Sender: TObject);
begin
        AboutTaskManagerDlg:=TAboutTaskManagerDlg.Create(self);
        AboutTaskManagerDlg.ShowModal;
end;

procedure TWindowsTaskManagerDlg.Button3Click(Sender: TObject);
begin
        CreateNewTaskDlg:=TCreateNewTaskDlg.Create(Application);
        CreateNewTaskDlg.Show;
end;

procedure TWindowsTaskManagerDlg.NewTaskRun1Click(Sender: TObject);
begin
        Button3Click(Sender);
end;

Procedure TWindowsTaskManagerDlg.Read_stats(statsfile_:string);
var i,j:integer;
    sbuf,ss:string;
    fi:Textfile;
    CPUuser, CPUnice, CPUsyst, CPUidle:longint;
Begin
    CPUuser:=0;
    CPUSyst:=0;

 (* /proc/stat   kernel/system statistics
       cpu  3357 0 4313 1362393
       The number of jiffies (1/100ths of a second)
       that the system spent in user mode, user
       mode with low priority (nice), system mode,
       and the idle task, respectively.  The last
       value should be 100 times the second entry
       in the uptime pseudo-file. *)

        tmpstr_stat:=TStringList.Create;

        try
        AssignFile(fi,statsfile_);
        Reset(fi);
        while not eof(fi) do begin
        readln(fi,sbuf);
        tmpstr_stat.Add(sbuf);
        End;
        CloseFile(fi);

        sbuf:=tmpstr_stat.Strings[0];
        num_forks:=tmpstr_stat.Strings[tmpstr_stat.Count-1];
        j:=pos(' ',num_forks);
        num_forks:=copy(num_forks,j+1,length(num_forks));

        for i:=0 to 4 do begin
        j:=pos(' ',sbuf);
        if j<>0 then begin
        ss:=copy(sbuf,1,j-1);
        ss:=trim(ss);
        case i of
          1:CPUuser:=StrToInt(ss);
          2:CPUnice:=StrToInt(ss);
          3:CPUSyst:=StrToInt(ss);
          4:CPUIdle:=StrToInt(ss);
        End;
        sbuf:=copy(sbuf,j,length(sbuf)-(j-1));
        sbuf:=trimleft(sbuf);
        End;
        End;

        finally
        diff_user:=(CPUUser - CPUUser_)*2;
        diff_syst:=(CPUSyst-CPUSyst_)*2;
        CPUUser_:=CPUUser;
        CPUSyst_:=CPUSyst;
        if not Timer3.Enabled then begin
        diff_user:=0;
        Timer3.Enabled:=true;
        End;
        user_matrix[um_y]:=diff_user div 2;
        user_matrix[um_y]:=PB2.Height - user_matrix[um_y];

        syst_matrix[um_y]:=diff_syst div 2;
        syst_matrix[um_y]:=PB4.Height - syst_matrix[um_y];


                inc(um_y);
                if um_y>PB2.Width then
                um_y:=0;

        tmpstr_stat.Free;
        End;
End;

procedure TWindowsTaskManagerDlg.Timer2Timer(Sender: TObject);
begin
Read_Stats('/proc/stat');
MemInfo(1,'/proc/meminfo');
MemInfo(2,'/proc/meminfo');
AverageLoad('/proc/loadavg');
Read_Net('/proc/net/dev');
end;

Procedure TWindowsTaskManagerDlg.Paint_PB1;
var value_:string;
     x,i,j:integer;

Function fill_text(s:string):string;
var ss:string;
Begin
        ss:=copy('     ',1,5-length(s))+s;
        Result:=ss;
End;

Begin
        PB1.Canvas.Start;

                with PB1.Canvas do begin
                Brush.Color:=clBlack;
                Brush.Style:=bsSolid;
                Pen.Color:=clGreen;
                Pen.Style:=psDot;
                End;

                // DRAW LINES
                PB1.Canvas.FillRect(ClientRect);


                j:=4;
                for x:=1 to 10 do begin
                inc(j,3);
                for i:=16 to 33 do begin
                PB1.Canvas.DrawPoint(i,j);
                PB1.Canvas.DrawPoint(i,j+1);
                End;
                End;

                j:=4;
                for x:=1 to 10 do begin
                inc(j,3);
                for i:=35 to 52 do begin
                PB1.Canvas.DrawPoint(i,j);
                PB1.Canvas.DrawPoint(i,j+1);
                End;
                End;

                with PB1.Canvas do begin
                Pen.Color:=clLime;
                Pen.Style:=psSolid;
                End;

                case diff_user of
                        1..10:Begin
                              for j:=100 downto 1 do begin
                              case j of
                              34,35:Begin
                                    for i:=16 to 33 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                       11..20:Begin
                              for j:=100 downto 1 do begin
                              case j of
                              31,32,34,35:Begin
                                    for i:=16 to 33 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                       21..30:Begin
                              for j:=100 downto 1 do begin
                              case j of
                              28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                       31..40:Begin
                              for j:=100 downto 1 do begin
                              case j of
                              25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;

                              End;
                       41..50:Begin
                              for j:=100 downto 1 do begin
                              case j of
                              22,23,25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;

                              End;
                       51..60:Begin
                              for j:=100 downto 1 do begin
                              case j of
                             19,20,22,23,25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;

                              End;
                       61..70:Begin
                              for j:=100 downto 1 do begin
                              case j of
                             16,17,19,20,22,23,25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                       71..80:Begin
                              for j:=100 downto 1 do begin
                              case j of
                             13,14,16,17,19,20,22,23,25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                       81..90:Begin
                              for j:=100 downto 1 do begin
                              case j of
                             10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                      91..120:Begin
                              for j:=100 downto 1 do begin
                              case j of
                             7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB1.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                      End;
                //

                with PB1.Canvas do begin
                Brush.Color:=clBlack;
                Brush.Style:=bsSolid;
                Pen.Color:=clBlack;
                Pen.Style:=psSolid;
                Font.Size:= 12;
                Font.Color:=clLime;
                End;


        value_:=IntToStr(diff_user)+' %';
        StatusBar1.Panels[1].Text:='CPU Usage: '+value_;

        PB1.Canvas.TextOut((PB1.Width div 2)-14 ,PB1.Height - 22,fill_text(value_));
        PB1.Canvas.Stop;
End;

procedure TWindowsTaskManagerDlg.Paint_PB2;
var i,xx:integer;
Begin
        PB2.Repaint;
        PB2.Canvas.Start(true);


                with PB2.Canvas do begin
                Brush.Color:=clBlack;
                Brush.Style:=bsCross;
                Pen.Color:=clGreen;
                Pen.Style:=psSolid;
                End;
                // DRAW LINES
                PB2.Canvas.FillRect(ClientRect);

        i:=48;
        repeat
        PB2.Canvas.MoveTo(0,i);
        PB2.Canvas.LineTo(PB2.Width-2,i);
        dec(i,12);
        until i<=2;

        i:=12;
        repeat
        PB2.Canvas.MoveTo(i,0);
        PB2.Canvas.LineTo(i,PB2.Height);
        inc(i,12);
        until i>=PB2.Width-10;

                with PB2.Canvas do begin
                Brush.Color:=clBlack;
                Brush.Style:=bsCross;
                Pen.Color:=clLime;
                Pen.Style:=psSolid;
                End;

        PB2.Canvas.MoveTo(0,PB2.Height);
        for i:=0 to PB2.Width do begin
        xx:= um_y - i;
        if (xx < 0) then xx := xx + PB2.Width;
        if xx >= 0 then begin
        PB2.Canvas.LineTo(i,user_matrix[xx]);
        End;
        End;


        PB2.Canvas.Stop;

End;

procedure TWindowsTaskManagerDlg.Paint_PB3;
var value_:string;
     x,i,j:integer;
     diff_swap:integer;

// We will put here usefull information
// For now , let it be swap using /proc/meminfo
// What is pagefile at win XP ?

Function fill_text(s:string):string;
var ss:string;
Begin
        ss:=copy('     ',1,5-length(s))+s;
        Result:=ss;
End;

Begin

        PB3.Canvas.Start;

                with PB3.Canvas do begin
                Brush.Color:=clBlack;
                Brush.Style:=bsSolid;
                Pen.Color:=clGreen;
                Pen.Style:=psDot;
                End;

                // DRAW LINES
                PB3.Canvas.FillRect(ClientRect);


                j:=4;
                for x:=1 to 10 do begin
                inc(j,3);
                for i:=16 to 33 do begin
                PB3.Canvas.DrawPoint(i,j);
                PB3.Canvas.DrawPoint(i,j+1);
                End;
                End;

                j:=4;
                for x:=1 to 10 do begin
                inc(j,3);
                for i:=35 to 52 do begin
                PB3.Canvas.DrawPoint(i,j);
                PB3.Canvas.DrawPoint(i,j+1);
                End;
                End;

                with PB3.Canvas do begin
                Pen.Color:=clLime;
                Pen.Style:=psSolid;
                End;

                case diff_syst of
                        1..10:Begin
                              for j:=100 downto 1 do begin
                              case j of
                              34,35:Begin
                                    for i:=16 to 33 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                       11..20:Begin
                              for j:=100 downto 1 do begin
                              case j of
                              31,32,34,35:Begin
                                    for i:=16 to 33 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                       21..30:Begin
                              for j:=100 downto 1 do begin
                              case j of
                              28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                       31..40:Begin
                              for j:=100 downto 1 do begin
                              case j of
                              25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;

                              End;
                       41..50:Begin
                              for j:=100 downto 1 do begin
                              case j of
                              22,23,25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;

                              End;
                       51..60:Begin
                              for j:=100 downto 1 do begin
                              case j of
                             19,20,22,23,25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;

                              End;
                       61..70:Begin
                              for j:=100 downto 1 do begin
                              case j of
                             16,17,19,20,22,23,25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                       71..80:Begin
                              for j:=100 downto 1 do begin
                              case j of
                             13,14,16,17,19,20,22,23,25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                       81..90:Begin
                              for j:=100 downto 1 do begin
                              case j of
                             10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                      91..120:Begin
                              for j:=100 downto 1 do begin
                              case j of
                             7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,29,31,32,34,35:
                                    Begin
                                    for i:=16 to 33 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    for i:=35 to 52 do
                                    PB3.Canvas.DrawPoint(i,j);
                                    End;
                                    End; // CASE
                              End;
                              End;
                      End;


                with PB3.Canvas do begin
                Brush.Color:=clBlack;
                Brush.Style:=bsSolid;
                Pen.Color:=clBlack;
                Pen.Style:=psSolid;
                Font.Size:= 12;
                Font.Color:=clLime;
                End;

        value_:=IntToStr(diff_syst)+' %';
        PB3.Canvas.TextOut((PB3.Width div 2)-14 ,PB3.Height - 22,fill_text(value_));
        PB3.Canvas.Stop;
End;

procedure TWindowsTaskManagerDlg.Paint_PB4;
var i,xx:integer;
Begin
        PB4.Repaint;
        PB4.Canvas.Start(true);


                with PB4.Canvas do begin
                Brush.Color:=clBlack;
                Brush.Style:=bsCross;
                Pen.Color:=clGreen;
                Pen.Style:=psSolid;
                End;
                // DRAW LINES
                PB4.Canvas.FillRect(ClientRect);

        i:=48;
        repeat
        PB4.Canvas.MoveTo(0,i);
        PB4.Canvas.LineTo(PB4.Width-2,i);
        dec(i,12);
        until i<=2;

        i:=12;
        repeat
        PB4.Canvas.MoveTo(i,0);
        PB4.Canvas.LineTo(i,PB4.Height);
        inc(i,12);
        until i>=PB4.Width-10;

                with PB4.Canvas do begin
                Brush.Color:=clBlack;
                Brush.Style:=bsCross;
                Pen.Color:=clYellow;
                Pen.Style:=psSolid;
                End;

        PB4.Canvas.MoveTo(0,PB4.Height);
        for i:=0 to PB4.Width do begin
        xx:= um_y - i;
        if (xx < 0) then xx := xx + PB4.Width;
        if xx >= 0 then begin
        if syst_matrix[xx]>0 then
        PB4.Canvas.LineTo(i,syst_matrix[xx]);
        End;
        End;


        PB4.Canvas.Stop;

End;


procedure TWindowsTaskManagerDlg.Paint_PB5;
var i,xx:integer;
Begin
        PB5.Repaint;
        PB5.Canvas.Start(true);


                with PB5.Canvas do begin
                Brush.Color:=clBlack;
                Brush.Style:=bsCross;
                Pen.Color:=clGreen;
                Pen.Style:=psSolid;
                End;
                // DRAW LINES
                PB5.Canvas.FillRect(ClientRect);

        i:=PB5.Height; // 48
        repeat
        PB5.Canvas.MoveTo(40,i);
        PB5.Canvas.LineTo(PB5.Width-2,i);
        dec(i,24);
        until i<=2;

        i:=12; // 12
        repeat
        PB5.Canvas.MoveTo(i+40,0);
        PB5.Canvas.LineTo(i+40,PB5.Height);
        inc(i,12);
        until i>=PB5.Width-10;

                with PB5.Canvas do begin
                Brush.Color:=clBlack;
                Brush.Style:=bsCross;
                Pen.Color:=clYellow;
                Pen.Style:=psSolid;
                End;



        PB5.Canvas.MoveTo(0,PB5.Height);
        for i:=0 to PB5.Width do begin
        xx:= du_y - i;
        if (xx < 0) then xx := xx + PB5.Width;
        if xx >= 0 then begin
        if devs_matrix[1,xx]>0 then
        PB5.Canvas.LineTo(i,devs_matrix[1,xx]);
        End;
        End;

        PB5.Canvas.Pen.Color:=clYellow;
        PB5.Canvas.MoveTo(40,0);
        PB5.Canvas.LineTo(40,PB5.Height);

        PB5.Canvas.Font.Size:=10;
        PB5.Canvas.Font.Color:=clYellow;
        PB5.Canvas.TextOut(PB5.Left+10,PB5.Top+10,'  1 %');
        PB5.Canvas.TextOut(PB5.Left+10,PB5.Height div 2,'0.5 %');
        PB5.Canvas.TextOut(PB5.Left+10,PB5.Height - 20,'  0 %');

        PB5.Canvas.Stop;

End;


procedure TWindowsTaskManagerDlg.Timer3Timer(Sender: TObject);
begin
Paint_PB1;
Paint_PB2;
Paint_PB3;
Paint_PB4;
Paint_PB5;
end;

Procedure TWindowsTaskManagerDlg.MemInfo(kind_:integer; memfile_:string);
var tmpstr_mem:TStrings;
    fi:TextFile;
    sbuf,ss:string;
    i,j,x:integer;
    results:Array[1..7] of string;
    swp_,memo_:single;
Begin
// kind_ -> 1=Physical memory ; 2=swap
        tmpstr_mem:=TStringList.Create;
        try
        AssignFile(fi,memfile_);
        Reset(fi);
        while not eof(fi) do begin
        readln(fi,sbuf);
        tmpstr_mem.Add(sbuf);
        End;
        CloseFile(fi);
        // PARSE STRINGS, OUR RESULT IS AT LINE kind_ so
        sbuf:=tmpstr_mem.Strings[kind_];
        x:=0;

        for i:=0 to length(sbuf) do begin

        j:=pos(':',sbuf);
        // CUTOFF "Mem:"
        if j<>0 then begin
        sbuf:=copy(sbuf,j+1,length(sbuf)-(j-1));
        ss:=sbuf+' ';
        ss:=trimleft(ss);
        End;

        j:=pos(' ',ss);
        if j<>0 then begin
        inc(x);
        results[x]:=copy(ss,1,j-1);
        ss:=copy(ss,j,length(ss)-(j-1));
        ss:=trimleft(ss);
        case kind_ of
               1: case x of
                      1:Begin
                        results[x]:=trim(results[x]);
                        try
                        memo_:=StrToFloat(results[x]);
                        except
                        memo_:=0;
                        end;
                        Lab10.Caption:=FloatToStrF(memo_ / 1024,ffFixed,12,1);
                        End;
                        3:Begin
                        results[x]:=trim(results[x]);
                        try
                        memo_:=StrToFloat(results[x]);
                        except
                        memo_:=0;
                        end;
                        Lab11.Caption:=FloatToStrF(memo_ / 1024,ffFixed,12,1);
                        StatusBar1.Panels[2].Text:='Free Memory (K): '+FloatToStrF(memo_ / 1024,ffFixed,12,1);
                        End;
                      6:Begin
                        results[x]:=trim(results[x]);
                        try
                        memo_:=StrToFloat(results[x]);
                        except
                        memo_:=0;
                        end;
                        Lab12.Caption:=FloatToStrF(memo_ / 1024,ffFixed,12,1);
                        End;
                End; // CASE x

              2:case x of
                        1:Begin
                          results[x]:=trim(results[x]);
                          try
                          swp_:=StrToFloat(results[x]);
                          swp_:=swp_ / 1024; // give kb
                          except
                          swp_:=0;
                          End;
                          swp_total:=swp_;
                          Lab4.Caption:=FloatToStrF(swp_total,ffFixed,12,1);                          
                          // SWAP total
                          End;
                        2:Begin
                          results[x]:=trim(results[x]);
                          try
                          swp_:=StrToFloat(results[x]);
                          swp_:=swp_ / 1024; // give kb
                          except
                          swp_:=0;
                          End;
                          swp_used:=swp_;
                          Lab6.Caption:=FloatToStrF(swp_used,ffFixed,12,1);
                          End;
                        3:Begin
                          results[x]:=trim(results[x]);
                          try
                          swp_:=StrToFloat(results[x]);
                          swp_:=swp_ / 1024; // give kb
                          except
                          swp_:=0;
                          End;
                          swp_free:=swp_;
                          Lab5.Caption:=FloatToStrF(swp_free,ffFixed,12,1);
                          End;
                        End; // CASE x
        End; // CASE kind_
        End;
        End;

        finally


        tmpstr_mem.Free;
        End;
End;

procedure TWindowsTaskManagerDlg.FormResize(Sender: TObject);
begin
Height:=421;
Width:=398;
end;

procedure TWindowsTaskManagerDlg.AverageLoad(avg_file:string);
var tmpstr_avg:TStrings;
    fi:TextFile;
    sbuf,ss:string;
    i,j,x:integer;
    results:Array[1..7] of string;
Begin
        tmpstr_avg:=TStringList.Create;
        try
        AssignFile(fi,avg_file);
        Reset(fi);
        while not eof(fi) do begin
        readln(fi,sbuf);
        tmpstr_avg.Add(sbuf);
        End;
        CloseFile(fi);
        sbuf:=tmpstr_avg.Strings[0]+' ';
        x:=0;
        for i:=0 to length(sbuf) do begin
        j:=pos(' ',sbuf);
        if j<>0 then begin
        inc(x);
        ss:=copy(sbuf,1,j-1);
        results[x]:=ss;
        sbuf:=copy(sbuf,j+1,length(sbuf));
        End;
        End;
        Lab16.Caption:=results[1];
        Lab17.Caption:=results[2];
        Lab18.Caption:=results[3];


        j:=pos('/',results[4]);
        ss:=copy(results[4],1,j-1);
        sbuf:=copy(results[4],j+1,length(results[4]));
        StatusBar1.Panels[0].Text:='Processes: '+sbuf;
        Lab22.Caption:=ss;
        Lab23.Caption:=sbuf;
        Lab24.Caption:=num_forks;

        finally
        tmpstr_avg.Free;
        End;

End;

Procedure TWindowsTaskManagerDlg.Fill_Net_Devices;
var i:integer;
    res:TStrings;
    fi:TextFile;

Function Sign_Device(device:string):string;
var ss:string;
Begin
        device:=trim(device);
        if device='lo' then Result:='Loopback'
        else begin
        ss:=copy(device,1,3);
        if ss='eth' then Result:='Local Area Network'
        else
        if ss='ppp' then Result:='Modem Connection'
        else
        if ss='ipp' then Result:='ISDN Connection'
        else
        Result:='Unknown Interface';
        End;
End;

Function Give_Device_Arp(device:string):TStrings;
var sbuf,s:String;
    y,x:integer;
Begin
        device:=trim(device);
        if device<>'lo' then begin
        AssignFile(fi,'/proc/net/arp');
        Reset(fi);
        while not eof(fi) do begin
        readln(fi,sbuf);
        s:=copy(sbuf,length(sbuf)-length(device),length(device));
        if s=device then
        break;
        End;
        CloseFile(fi);

        // HOPE THAT WE FOUND DEVICE :)
        // parse sbuf and each result add to TStringList
        sbuf:=sbuf+' ';
        for y:=1 to length(sbuf) do begin
        x:=pos(' ',sbuf);
        if x<>0 then begin
        s:=copy(sbuf,1,x-1);
        res.Add(s);
        sbuf:=copy(sbuf,x+1,length(sbuf));
        sbuf:=trimleft(sbuf);
        End;
End;

        end else begin
                res.Add('127.0.0.1');
                res.Add('0');
                res.Add('0');
                res.Add('0');
                res.Add(device);
        End;
Result:=res;
End;

// HERE WE START
Begin
        LVNet.Items.Clear;
        // Clear list ,in feature we will better handle this,
        // look for changes, and just on changes refill list.
        LVNet.Items.BeginUpdate;
                for i:=0 to 20 do
                        if dev_names[i]<>'' then begin

                        res:=TStringList.Create;
                        LVNet.Items.Add.Caption:=Sign_Device(dev_names[i]);
                        res:=Give_Device_Arp(dev_names[i]);
                        LVNet.Items.Item[i].SubItems.AddStrings(res);

                        res.Free;
                        // now we parse /proc/dev/arp for ip,hw adress
                        End;
                LVNet.Items.EndUpdate;
                End;


Procedure TWindowsTaskManagerDlg.Find_Lusers; // ;)
var i,x,jj:integer;
    fi:TextFile;
    tmp_users:TStrings;
    tmpfile_,sbuf,ss:string;
    lusers_:Array[0..100] of String;
    username_,us_id,us_cli,us_idle:string;
    neki:Double;
    uzer:rusage;
    luzer:rlimit;
Begin
        Lusers.Items.Clear;
        tmp_users:=TStringList.Create;
        tmpfile_:=_get_tmp_fname;
        try
        ss:='who -i > '+tmpfile_;
        Libc.System(PChar(ss));
        AssignFile(fi,tmpfile_);
        Reset(fi);
        i:=0;
        jj:=0;
        while not eof(fi) do begin
        ReadLn(fi,sbuf);
        try
        username_:=_cut_right(' ',sbuf);
        us_id:=IntToStr(getpwnam(PChar(username_))^.pw_uid);
        except
        username_:='unknown';
        End;
        // NOW WE WILL CHECK FOR DUPLICATE USERNAMES
        // WHICH WILL NOT BE SHOWN

        if username_<>'unknown' then begin

                        for x:=0 to 100 do begin
                        if username_=lusers_[x] then inc(jj);
                        End;
                        if jj=0 then begin

                        lusers_[i]:=username_;

                                try
                                us_cli:=Trim(_cut_left(_cut_right(' ',sbuf),sbuf));
                                us_cli:=_cut_right(' ',us_cli);
                                except
                                us_cli:='unknown';
                                End;
                                try
                                us_idle:=Trim(Copy(sbuf,Length(sbuf)-5,$FFFFF));
                                if Pos(':',us_idle)<=0 then us_idle:='Active';
                                except
                                us_idle:='Active';
                                End;
                                if us_idle<>'Active' then us_idle:='Idle';
                                sbuf:=trim(us_id+' '+us_idle+' '+us_cli);
                                Lusers.Items.Add.Caption:=username_;
                                tmp_users.Add(sbuf);
                                Lusers.Items.Item[i].SubItems.Add(us_id);
                                Lusers.Items.Item[i].SubItems.Add(us_idle);
                                Lusers.Items.Item[i].SubItems.Add(us_cli);
                                inc(i);
                        End;
                        jj:=0;
                        End;


        End;
        CloseFile(fi);
        finally
        DeleteFile(tmpfile_);
        tmp_users.Free;
        End;

End;

end.
