unit xpnewuser;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QExtCtrls;

type
  TNew_User = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cbChange: TCheckBox;
    cbNotChange: TCheckBox;
    cbExpires: TCheckBox;
    cbDisable: TCheckBox;
    btnCreate: TButton;
    btnClose: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    edName: TEdit;
    edFullName: TEdit;
    edDescrip: TEdit;
    edPasswd: TEdit;
    edPasswd2: TEdit;
    cbSamba: TCheckBox;
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
