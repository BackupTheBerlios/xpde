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
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NetworkConnectionDetailsDlg: TNetworkConnectionDetailsDlg;

implementation
uses UConnectionStatus;
{$R *.xfm}

procedure TNetworkConnectionDetailsDlg.FormShow(Sender: TObject);
begin
lvSettings.Items.Add.Caption:='Physical Address';
lvSettings.Items.Item[0].SubItems.Add(net_info[device_number].hw_addr);
lvSettings.Items.Add.Caption:='IP Address';
lvSettings.Items.Item[1].SubItems.Add(net_info[device_number].ip_addr);
lvSettings.Items.Add.Caption:='Subnet Mask';
lvSettings.Items.Item[2].SubItems.Add(net_info[device_number].mask);
lvSettings.Items.Add.Caption:='Default Gateway';
lvSettings.Items.Item[3].SubItems.Add(net_info[device_number].gw);
lvSettings.Items.Add.Caption:='DNS Servers';
lvSettings.Items.Add.Caption:='WINS Server';
end;

procedure TNetworkConnectionDetailsDlg.btnCloseClick(Sender: TObject);
begin
Close;
end;

end.
