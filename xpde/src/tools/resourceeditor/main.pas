unit main;

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, 
  QDialogs, QStdCtrls, QMenus;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    OpenDialog: TOpenDialog;
    procedure Open1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OpenFile(const filename:string);
  end;

var
  MainForm: TMainForm;

implementation

uses uResourceFileFrm;

{$R *.xfm}

procedure TMainForm.Open1Click(Sender: TObject);
begin
    if OpenDialog.execute then begin
        OpenFile(OpenDialog.filename);
   end;
end;

procedure TMainForm.OpenFile(const filename: string);
begin
    with TResourceFileFrm.create(application) do begin
        loadfromfile(filename);
    end;
end;

end.
