unit uDriverFileDetails;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QComCtrls, QExtCtrls, uQXPComCtrls;

type
  TDriverFileDetailsDlg = class(TForm)
        Button1:TButton;
        Label10:TLabel;
        Label9:TLabel;
        Label8:TLabel;
        Label7:TLabel;
        Label6:TLabel;
        Label5:TLabel;
        Label4:TLabel;
        Label3:TLabel;
        ListView1:TListView;
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
  DriverFileDetailsDlg: TDriverFileDetailsDlg;

implementation

{$R *.xfm}

end.
