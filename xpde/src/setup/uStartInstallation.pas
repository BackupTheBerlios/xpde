unit uStartInstallation;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls, QComCtrls;

type
  TStartInstallationDlg = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Image2: TImage;
    Bevel1: TBevel;
    Panel2: TPanel;
    Button2: TButton;
    Panel3: TPanel;
    Bevel2: TBevel;
    Button1: TButton;
    TextViewer1: TTextViewer;
    CheckBox1: TCheckBox;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StartInstallationDlg: TStartInstallationDlg;

implementation

{$R *.xfm}

procedure TStartInstallationDlg.FormShow(Sender: TObject);
begin
    font.Name:='';
    font.Assign(application.font);
end;

procedure TStartInstallationDlg.FormCreate(Sender: TObject);
begin
    TextViewer1.LoadFromFile(extractfilepath(application.exename)+'usage.html');
end;

procedure TStartInstallationDlg.CheckBox1Click(Sender: TObject);
begin
    button2.Enabled:=checkbox1.Checked;
end;

end.
