program networkproperties;

uses
  QForms,
  uXPStyle,
  uEthernetAdapterProperties in 'uEthernetAdapterProperties.pas' {EthernetAdapterPropertiesDlg},
  uConnectionProperties in 'uConnectionProperties.pas' {ConnectionPropertiesDlg},
  uAdvancedSettings in 'uAdvancedSettings.pas' {AdvancedSettingsDlg},
  uAdvancedTCPIPSettings in 'uAdvancedTCPIPSettings.pas' {AdvancedTCPIPSettingsDlg},
  uClientforMicrosoftNetworksProperties in 'uClientforMicrosoftNetworksProperties.pas' {ClientforMicrosoftNetworksPropertiesDlg},
  uDriverFileDetails in 'uDriverFileDetails.pas' {DriverFileDetailsDlg},
  uInstallFromDisk in 'uInstallFromDisk.pas' {InstallFromDiskDlg},
  uInternetProtocolTCPIPProperties in 'uInternetProtocolTCPIPProperties.pas' {InternetProtocolTCPIPPropertiesDlg},
  uSelectNetworkClient in 'uSelectNetworkClient.pas' {SelectNetworkClientDlg},
  uSelectNetworkComponentType in 'uSelectNetworkComponentType.pas' {SelectNetworkComponentTypeDlg},
  uSelectNetworkProtocol in 'uSelectNetworkProtocol.pas' {SelectNetworkProtocolDlg},
  uSelectNetworkService in 'uSelectNetworkService.pas' {SelectNetworkServiceDlg},
  uServiceSettings in 'uServiceSettings.pas' {ServiceSettingsDlg},
  uSmartCardorotherCertificateProperties in 'uSmartCardorotherCertificateProperties.pas' {SmartCardorotherCertificatePropertiesDlg},
  uTCPIPAddress in 'uTCPIPAddress.pas' {TCPIPAddressDlg},
  uTCPIPDNSServer in 'uTCPIPDNSServer.pas' {TCPIPDNSServerDlg},
  uTCPIPFiltering in 'uTCPIPFiltering.pas' {TCPIPFilteringDlg},
  uTCPIPGatewayAddress in 'uTCPIPGatewayAddress.pas' {TCPIPGatewayAddressDlg},
  uTCPIPWINSServer in 'uTCPIPWINSServer.pas' {TCPIPWINSServerDlg};

{$R *.res}

begin
  Application.Initialize;
  setXPStyle(application);
  application.font.Name:='Microsoft sans serif';
  Application.CreateForm(TConnectionPropertiesDlg, ConnectionPropertiesDlg);
  Application.Run;
end.
