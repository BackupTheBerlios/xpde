unit uInternetProtocolTCPIPProperties;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, uQXPComCtrls;

type
  TInternetProtocolTCPIPPropertiesDlg = class(TForm)
        Button5:TButton;
        Label6:TLabel;
        Label5:TLabel;
        RadioButton4:TRadioButton;
        RadioButton3:TRadioButton;
        GroupBox2:TGroupBox;
        Label4:TLabel;
        Label3:TLabel;
        Label2:TLabel;
        RadioButton2:TRadioButton;
        RadioButton1:TRadioButton;
        GroupBox1:TGroupBox;
        Label1:TLabel;
        PageControl1:TPageControl;
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Button1:TButton;
        TabSheet1:TTabSheet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InternetProtocolTCPIPPropertiesDlg: TInternetProtocolTCPIPPropertiesDlg;

implementation

{$R *.xfm}

end.
