unit uTCPIPWINSServer;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls;

type
  TTCPIPWINSServerDlg = class(TForm)
        Button2:TButton;
        Button1:TButton;
        Label1:TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TCPIPWINSServerDlg: TTCPIPWINSServerDlg;

implementation

{$R *.xfm}

end.
