unit uCreateNewTask;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls;
type TProcessHandle = THandle;
type
  TCreateNewTaskDlg = class(TForm)
        Button3:TButton;
        Button2:TButton;
        Button1:TButton;
        CheckBox1:TCheckBox;
        ComboBox1:TComboBox;
        Label2:TLabel;
        Label1:TLabel;
        Image1:TImage;
        Panel1:TPanel;
    OpenDialog1: TOpenDialog;
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CreateNewTaskDlg: TCreateNewTaskDlg;

implementation
uses Libc,uTaskManager;
{$R *.xfm}

procedure TCreateNewTaskDlg.Button2Click(Sender: TObject);
begin
Close;
end;

procedure TCreateNewTaskDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action:=caFree;
end;

function _get_tmp_fname:String;
begin
  Result:='/tmp/'+FormatDateTime('XPdeTM_NewTask.hh.mm.ss.ms',Now)+
    Format('.%d.%d.%d',[Random($FFFF),Random($FFFF),Random($FFFF)]);
end;

procedure TCreateNewTaskDlg.Button1Click(Sender: TObject);
var ss,ssi,cmnd,err_cmd:string;
    i:integer;
    fcmnd_tstr:TStrings;
begin
ss:=ComboBox1.Text;
ss:=trimleft(ss);
if ss='' then begin
raise Exception.Create('You must specify command !')
end else begin
cmnd:=_get_tmp_fname;

ss:=ComboBox1.Text;
ssi:=ss+' 2> '+cmnd+' &'; // We check just for errors !
i:=Libc.system(PChar(ssi));
sleep(50);
// SET HOURGLASS CURSOR -> XpWM
fcmnd_tstr:=TStringList.Create;
try
fcmnd_tstr.LoadFromFile(cmnd);
except
fcmnd_tstr.Free;
raise
Exception.Create('TaskManager error : TM01001 !'+#13#10+'Please report bug at http://bugs.xpde.com .');
exit;
End;

try
err_cmd:=fcmnd_tstr.Strings[0];
except
err_cmd:='';
End;
if i<>0 then err_cmd:='Error !';
if (err_cmd<>'') or (i<>0) then
raise
Exception.Create(err_cmd);

fcmnd_tstr.Free;
DeleteFile(cmnd);
WindowsTaskManagerDlg.Fill_Processes;
WindowsTaskManagerDlg.Fill_Applications;
Close;

End;
End;

procedure TCreateNewTaskDlg.Button3Click(Sender: TObject);
begin
OpenDialog1.Execute;
ComboBox1.Text:=OpenDialog1.FileName;
end;

procedure TCreateNewTaskDlg.ComboBox1KeyPress(Sender: TObject;
  var Key: Char);
begin
Case Key of
        #13:Button1Click(Sender);
        End;
end;

end.
