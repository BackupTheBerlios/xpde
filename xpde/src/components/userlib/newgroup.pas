unit newgroup;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls;

type
  TNew_User = class(TForm)
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
  New_User: TNew_User;

implementation

uses uUserPropeties;

{$R *.xfm}

procedure TNew_User.btnCloseClick(Sender: TObject);
begin
  Properties.Show;
// Close;
end;

procedure TNew_User.btnCreateClick(Sender: TObject);
begin
// AddNewUser();
// if cbSamba.Checked = true then AddNewSmbUser();
 Close;
end;

end.
