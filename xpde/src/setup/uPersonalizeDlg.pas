unit uPersonalizeDlg;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls;

type
  TPersonalizeDlg = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Image2: TImage;
    Bevel1: TBevel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel3: TPanel;
    Label3: TLabel;
    Image3: TImage;
    Label4: TLabel;
    edName: TEdit;
    edOrganization: TEdit;
    Label5: TLabel;
    Bevel2: TBevel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PersonalizeDlg: TPersonalizeDlg;

implementation

{$R *.xfm}

procedure TPersonalizeDlg.FormShow(Sender: TObject);
begin
    font.Name:='';
    font.Assign(application.font);
end;

end.
