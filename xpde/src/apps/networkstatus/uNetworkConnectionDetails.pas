unit uNetworkConnectionDetails;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QComCtrls;

type
  TNetworkConnectionDetailsDlg = class(TForm)
    btnClose: TButton;
        Panel1:TPanel;
    lvSettings: TListView;
        Label1:TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NetworkConnectionDetailsDlg: TNetworkConnectionDetailsDlg;

implementation

{$R *.xfm}

end.
