unit uTCPIPDNSServer;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls;

type
  TTCPIPDNSServerDlg = class(TForm)
        Button2:TButton;
        Button1:TButton;
        Label1:TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TCPIPDNSServerDlg: TTCPIPDNSServerDlg;

implementation

{$R *.xfm}

end.
