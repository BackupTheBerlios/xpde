{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 Zeljan Rikalo <zeljko@xpde.com>                          }
{                                                                             }
{ This program is free software; you can redistribute it and/or               }
{ modify it under the terms of the GNU General Public                         }
{ License as published by the Free Software Foundation; either                }
{ version 2 of the License, or (at your option) any later version.            }
{                                                                             }
{ This program is distributed in the hope that it will be useful,             }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of              }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU           }
{ General Public License for more details.                                    }
{                                                                             }
{ You should have received a copy of the GNU General Public License           }
{ along with this program; see the file COPYING.  If not, write to            }
{ the Free Software Foundation, Inc., 59 Temple Place - Suite 330,            }
{ Boston, MA 02111-1307, USA.                                                 }
{                                                                             }
{ *************************************************************************** }
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
