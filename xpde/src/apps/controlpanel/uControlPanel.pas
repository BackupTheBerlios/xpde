unit uControlPanel;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QComCtrls, QImgList, QMenus, QExtCtrls, uXPAPI;

type
  TControlFanelFrm = class(TForm)
    IconView1: TIconView;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    View1: TMenuItem;
    Favorites1: TMenuItem;
    Tools1: TMenuItem;
    Help1: TMenuItem;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    lbAddress: TLabel;
    cbAddress: TComboBox;
    StatusBar1: TStatusBar;
    procedure IconView1Editing(Sender: TObject; Item: TIconViewItem;
      var AllowEdit: Boolean);
    procedure FormShow(Sender: TObject);
    procedure IconView1ItemDoubleClick(Sender: TObject;
      Item: TIconViewItem);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure loaddatetimeapplet;
    procedure loadmouseapplet;
    procedure loadnetapplet;
    procedure loaddeskapplet;
  public
    { Public declarations }
  end;

var
  ControlFanelFrm: TControlFanelFrm;

implementation

{$R *.xfm}

procedure TControlFanelFrm.IconView1Editing(Sender: TObject;
  Item: TIconViewItem; var AllowEdit: Boolean);
begin
    allowedit:=false;
end;

procedure TControlFanelFrm.FormShow(Sender: TObject);
begin
   cbAddress.Align:=alClient;
end;

procedure TControlFanelFrm.IconView1ItemDoubleClick(Sender: TObject;
  Item: TIconViewItem);
begin
    case item.Index of
        0: loaddatetimeapplet;
        1: loaddeskapplet;
        2: loadmouseapplet;
        3: loadnetapplet;
    end;
end;

procedure TControlFanelFrm.loaddatetimeapplet;
var
    appletsdir: string;
    stub: string;
    applet: string;
    command: string;
begin
    appletsdir:=XPAPI.getsysinfo(siAppletsDir);

    stub:=XPAPI.getsysinfo(siAppDir)+'stub.sh';
    applet:=appletsdir+'DateTimeProps';

    command:=format('%s/xpsu root "%s %s"',[appletsdir, stub, applet]);

    XPAPI.ShellExecute(command,false);
end;

procedure TControlFanelFrm.loadmouseapplet;
begin
    XPAPI.ShellExecute(XPAPI.getsysinfo(siAppletsDir)+'mouse',false);
end;

procedure TControlFanelFrm.loaddeskapplet;
begin
    XPAPI.ShellExecute(XPAPI.getsysinfo(siAppletsDir)+'desk',false);
end;

procedure TControlFanelFrm.loadnetapplet;
begin
    XPAPI.ShellExecute(XPAPI.getsysinfo(siAppletsDir)+'networkstatus -i eth0',false);
end;

procedure TControlFanelFrm.FormCreate(Sender: TObject);
begin
    //These lines are here to set the font of the menubar
    font.name:='';
    parentfont:=true;
end;

end.
