unit uConnectionStatus;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QComCtrls, uQXPComCtrls, uNetworkConnectionDetails;

type
  TConnectionStatusDlg = class(TForm)
    btnRepair: TButton;
    btnDetails: TButton;
    lbGateway: TLabel;
        Label26:TLabel;
    lbMask: TLabel;
        Label24:TLabel;
    lbIP: TLabel;
        Label22:TLabel;
    lbType: TLabel;
        Label20:TLabel;
        GroupBox3:TGroupBox;
    btnDisable: TButton;
    btnProperties: TButton;
    lbReceive: TLabel;
    lbSent: TLabel;
        Label12:TLabel;
        Label11:TLabel;
        Image2:TImage;
        Panel2:TPanel;
        Label8:TLabel;
        GroupBox2:TGroupBox;
    lbSpeed: TLabel;
        Label5:TLabel;
    lbDuration: TLabel;
        Label3:TLabel;
    lbStatus: TLabel;
        Label1:TLabel;
        GroupBox1:TGroupBox;
    tsSupport: TTabSheet;
    pcConnection: TPageControl;
        Button4:TButton;
        Button3:TButton;
    btnClose: TButton;
    btnOk: TButton;
    tsGeneral: TTabSheet;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    procedure btnDetailsClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConnectionStatusDlg: TConnectionStatusDlg;

implementation

{$R *.xfm}

procedure TConnectionStatusDlg.btnDetailsClick(Sender: TObject);
begin
    with TNetworkConnectionDetailsDlg.create(application) do begin
        try
            showmodal;
        finally
            free;
        end;
    end;
end;

procedure TConnectionStatusDlg.btnCloseClick(Sender: TObject);
begin
    close;
end;

procedure TConnectionStatusDlg.FormCreate(Sender: TObject);
begin
    pcConnection.activepage:=tsGeneral;
end;

end.
