unit GroupPropeties;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls, QComCtrls;

type
  TGrpPropeties = class(TForm)
    lbGroupName: TLabel;
    Label3: TLabel;
    btnCreate: TButton;
    btnClose: TButton;
    Panel2: TPanel;
    Memo1: TMemo;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    edDescrip: TEdit;
    TabSheet1: TTabSheet;
    Image1: TImage;
    btnApply: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GrpPropeties: TGrpPropeties;

implementation

uses uUserPropeties;

{$R *.xfm}

procedure TGrpPropeties.btnCloseClick(Sender: TObject);
begin
  Properties.Show;
// Close;
end;

procedure TGrpPropeties.btnCreateClick(Sender: TObject);
begin
// AddNewUser();
// if cbSamba.Checked = true then AddNewSmbUser();
 Close;
end;

end.
