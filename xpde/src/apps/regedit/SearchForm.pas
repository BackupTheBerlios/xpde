unit SearchForm;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls;

type
  TFSearchForm = class(TForm)
    GroupBox1: TGroupBox;
    CBKeys: TCheckBox;
    CBValues: TCheckBox;
    CBData: TCheckBox;
    EdFind: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSearchForm: TFSearchForm;

implementation

{$R *.xfm}

procedure TFSearchForm.FormShow(Sender: TObject);
begin
EdFind.SetFocus;
end;

end.
