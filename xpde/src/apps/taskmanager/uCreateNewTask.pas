unit uCreateNewTask;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CreateNewTaskDlg: TCreateNewTaskDlg;

implementation

{$R *.xfm}

end.
