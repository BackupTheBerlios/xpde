unit uDeviceManager;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QMenus, QExtCtrls, SysProvider,uXPListview;

type
  TfrmSystem = class(TForm)
    Menu: TMainMenu;
    File1: TMenuItem;
    Options1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Action1: TMenuItem;
    Help1: TMenuItem;
    View1: TMenuItem;
    Devicesbytype1: TMenuItem;
    Devicesbyconnection1: TMenuItem;
    Resourcesbytype1: TMenuItem;
    Resourcesbyconnection1: TMenuItem;
    N2: TMenuItem;
    Showhiddendevices1: TMenuItem;
    N3: TMenuItem;
    Customize1: TMenuItem;
    Help2: TMenuItem;
    HelpTopics1: TMenuItem;
    N4: TMenuItem;
    AboutXPdeManagementConsole1: TMenuItem;
    AboutDeviceManager1: TMenuItem;
    PA1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSystem: TfrmSystem;
  var lv:TXPListview;

implementation

{$R *.xfm}

procedure TfrmSystem.FormShow(Sender: TObject);
var sp:TSysProvider;
    fi:PPci_Info;
    li:TXpListItem;
begin
        sp:=TSysProvider.Create;
        fi:=sp.ProvideRegistryAll;
        lv:=TXPListView.Create(self);
        lv.Parent:=PA1;
        lv.Align:=alClient;
        lv.Visible:=true;
        lv.Items.Add.Caption:=sp.HostName;

        lv.Items.Item[0].Subitems.Add('ONE');
        lv.Items.Item[0].Subitems.Add('TWO');
        lv.Items.Item[0].Subitems.Add('THREE');

        sp.Free;
end;

procedure TfrmSystem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        lv.Free;
end;

procedure TfrmSystem.Exit1Click(Sender: TObject);
begin
        Close;
end;

end.
