unit uInstallFromDisk;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, uQXPComCtrls;

type
  TInstallFromDiskDlg = class(TForm)
        Label3:TLabel;
        Label2:TLabel;
        Image1:TImage;
        Panel1:TPanel;
        Button3:TButton;
        ComboBox2:TComboBox;
        ComboBox1:TComboBox;
        Label1:TLabel;
        Button2:TButton;
        Button1:TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InstallFromDiskDlg: TInstallFromDiskDlg;

implementation

{$R *.xfm}

end.
