unit uTCPIPAddress;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls;

type
  TTCPIPAddressDlg = class(TForm)
        Button2:TButton;
        Button1:TButton;
        Label2:TLabel;
        Label1:TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TCPIPAddressDlg: TTCPIPAddressDlg;

implementation

{$R *.xfm}

end.
