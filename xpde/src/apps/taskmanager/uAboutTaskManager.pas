unit uAboutTaskManager;

interface

uses
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls;

type
  TAboutTaskManagerDlg = class(TForm)
        Button1:TButton;
        Label9:TLabel;
        Label8:TLabel;
        Label7:TLabel;
        Label6:TLabel;
        Label5:TLabel;
        Label3:TLabel;
        Label2:TLabel;
        Label1:TLabel;
        Image1:TImage;
        Panel1:TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutTaskManagerDlg: TAboutTaskManagerDlg;
  tm_version,tm_build:string;
implementation

{$R *.xfm}

procedure TAboutTaskManagerDlg.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TAboutTaskManagerDlg.FormShow(Sender: TObject);
begin
Label2.Caption:='Version '+tm_version+' (Build '+tm_build+')';
end;

procedure TAboutTaskManagerDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action:=caFree;
end;

end.
