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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutTaskManagerDlg: TAboutTaskManagerDlg;

implementation

{$R *.xfm}

end.
