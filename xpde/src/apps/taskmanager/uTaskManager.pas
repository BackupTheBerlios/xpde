unit uTaskManager;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QMenus, QTypes, QExtCtrls, QComCtrls,uQXPComCtrls;

type
  TWindowsTaskManagerDlg = class(TForm)
        Button7:TButton;
        CheckBox37:TCheckBox;
        CheckBox36:TCheckBox;
        CheckBox35:TCheckBox;
        CheckBox34:TCheckBox;
        CheckBox33:TCheckBox;
        CheckBox32:TCheckBox;
        CheckBox31:TCheckBox;
        CheckBox30:TCheckBox;
        TreeView1:TTreeView;
        ListBox1:TListBox;
        ComboBox1:TComboBox;
        Edit12:TEdit;
        Label13:TLabel;
        Edit11:TEdit;
        Label12:TLabel;
        Edit10:TEdit;
        Label11:TLabel;
        Edit9:TEdit;
        Label10:TLabel;
        Edit8:TEdit;
        Label9:TLabel;
        Edit7:TEdit;
        Label8:TLabel;
        Edit6:TEdit;
        Label7:TLabel;
        Edit5:TEdit;
        Label6:TLabel;
        Edit4:TEdit;
        Label5:TLabel;
        Edit3:TEdit;
        Label4:TLabel;
        Edit2:TEdit;
        Label3:TLabel;
        Edit1:TEdit;
        Label2:TLabel;
        CheckBox5:TCheckBox;
        CheckBox4:TCheckBox;
        ListView3:TListView;
        Button6:TButton;
        Button5:TButton;
        Button4:TButton;
        ListView2:TListView;
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
  private
    Procedure Get_PIDS_Apps(cmdline:string);
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
      PRIO_HIGH=5000;
      PRIO_LOW=30000;
      PRIO_PAUSED=false;
      // Consts  for updating taskmanager ..
      // this is my test mode so we can change it later to anything

var tmpstr:TStrings;
    is_all:boolean; // Show all procs ? This is for checkbox37
{$R *.xfm}

function _get_tmp_fname:String;
begin
  Result:='/tmp/'+FormatDateTime('XPdeTaskManager.hh.mm.ss.ms',Now)+
    Format('.%d.%d.%d',[Random($FFFF),Random($FFFF),Random($FFFF)]);
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
tmpstr.Free;
End;

procedure TWindowsTaskManagerDlg.Timer1Timer(Sender: TObject);
begin
Application.ProcessMessages;
Fill_Applications;
Fill_Processes;
end;

procedure TWindowsTaskManagerDlg.FormShow(Sender: TObject);
begin
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
StatusBar1.SimpleText:='Normal priority';
Fill_Processes;
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
          StatusBar1.SimpleText:='High priority';
          End;
        2:Begin
          Timer1.Enabled:=true;
          Timer1.Interval:=PRIO_NORMAL;
          StatusBar1.SimpleText:='Normal priority';
          End;
        3:Begin
          Timer1.Enabled:=true;
          Timer1.Interval:=PRIO_LOW;
          StatusBar1.SimpleText:='Low priority';
          End;
        4:Begin
          Timer1.Enabled:=false;
          StatusBar1.SimpleText:='Paused';
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

end.
