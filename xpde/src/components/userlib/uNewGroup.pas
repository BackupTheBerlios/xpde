unit uNewGroup;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls;

type
  TNewGroups = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    btnCreate: TButton;
    btnClose: TButton;
    Panel2: TPanel;
    edName: TEdit;
    edDescrip: TEdit;
    Memo1: TMemo;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewGroups: TNewGroups;

implementation

uses uGroupPropeties;

{$R *.xfm}

procedure TNewGroups.btnCloseClick(Sender: TObject);
begin
  GrpPropeties.Show;
// Close;
end;

procedure TNewGroups.btnCreateClick(Sender: TObject);
begin
// AddNewUser();
// if cbSamba.Checked = true then AddNewSmbUser();
 Close;
end;

end.
