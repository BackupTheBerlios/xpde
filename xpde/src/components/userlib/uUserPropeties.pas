unit uUserPropeties;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QComCtrls, QExtCtrls;

type
  TProperties = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    lbUserName: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbChange: TCheckBox;
    cbNotChange: TCheckBox;
    cbExpires: TCheckBox;
    cbDisable: TCheckBox;
    Panel1: TPanel;
    edFullName: TEdit;
    edDescrip: TEdit;
    cbSamba: TCheckBox;
    cbLocked: TCheckBox;
    ListView1: TListView;
    btnAdd: TButton;
    btnRemove: TButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Properties: TProperties;

implementation

{$R *.xfm}

procedure TProperties.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TProperties.btnCancelClick(Sender: TObject);
begin
   Close;
end;

procedure TProperties.btnApplyClick(Sender: TObject);
begin
  Close;
end;

end.
