unit uTCPIPFiltering;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, uQXPComCtrls;

type
  TTCPIPFilteringDlg = class(TForm)
        Button8:TButton;
        Button7:TButton;
        Button6:TButton;
        Button5:TButton;
        ListView3:TListView;
        Label3:TLabel;
        RadioButton6:TRadioButton;
        RadioButton5:TRadioButton;
        GroupBox3:TGroupBox;
        Button4:TButton;
        Button3:TButton;
        ListView2:TListView;
        Label2:TLabel;
        RadioButton4:TRadioButton;
        RadioButton3:TRadioButton;
        GroupBox2:TGroupBox;
        Button2:TButton;
        Button1:TButton;
        ListView1:TListView;
        Label1:TLabel;
        RadioButton2:TRadioButton;
        RadioButton1:TRadioButton;
        GroupBox1:TGroupBox;
        CheckBox1:TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TCPIPFilteringDlg: TTCPIPFilteringDlg;

implementation

{$R *.xfm}

end.
