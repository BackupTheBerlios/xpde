unit uSelectNetworkClient;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QComCtrls, uQXPComCtrls;

type
  TSelectNetworkClientDlg = class(TForm)
        Label2:TLabel;
        Label1:TLabel;
        Button4:TButton;
        Button3:TButton;
        Button2:TButton;
        Image1:TImage;
        Panel2:TPanel;
        Panel1:TPanel;
        ListView3:TListView;
        ListView2:TListView;
        ListView1:TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectNetworkClientDlg: TSelectNetworkClientDlg;

implementation

{$R *.xfm}

end.
