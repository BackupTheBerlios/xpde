unit uTCPIPGatewayAddress;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls;

type
  TTCPIPGatewayAddressDlg = class(TForm)
        Button2:TButton;
        Button1:TButton;
        Edit1:TEdit;
        Label2:TLabel;
        CheckBox1:TCheckBox;
        GroupBox1:TGroupBox;
        Label1:TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TCPIPGatewayAddressDlg: TTCPIPGatewayAddressDlg;

implementation

{$R *.xfm}

end.
