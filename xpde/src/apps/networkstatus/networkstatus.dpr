program networkstatus;

uses
  QForms,
  uXPStyle,
  uConnectionStatus in 'uConnectionStatus.pas' {ConnectionStatusDlg},
  uNetworkConnectionDetails in 'uNetworkConnectionDetails.pas' {NetworkConnectionDetailsDlg};

{$R *.res}

begin
  Application.Initialize;
  SetXPStyle(application);
  Application.CreateForm(TConnectionStatusDlg, ConnectionStatusDlg);
  Application.Run;
end.
