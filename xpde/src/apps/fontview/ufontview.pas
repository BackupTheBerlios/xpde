unit ufontview;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms, 
  QDialogs, QStdCtrls, QComCtrls, QExtCtrls, ttfinfo;

type
  TMainForm = class(TForm)
    ScrollBox: TScrollBox;
    FontNameLBL: TLabel;
    TypeFaceLBL: TLabel;
    FileSizeLBL: TLabel;
    VersionLBL: TLabel;
    CopyrightLBL: TLabel;
    LCaseLBL: TLabel;
    UCaseLBL: TLabel;
    OtherCharsLBL: TLabel;
    Pt12LBL: TLabel;
    Pt18LBL: TLabel;
    Pt24LBL: TLabel;
    Pt36LBL: TLabel;
    Pt48LBL: TLabel;
    Pt60LBL: TLabel;
    Pt72LBL: TLabel;
    TopPanel: TPanel;
    DoneBTN: TButton;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel1: TBevel;
    Pt12CapLBL: TLabel;
    Pt18CapLBL: TLabel;
    Pt24CapLBL: TLabel;
    Pt36CapLBL: TLabel;
    Pt48CapLBL: TLabel;
    Pt60CapLBL: TLabel;
    Pt72CapLBL: TLabel;
    DumbyLBL: TLabel;
    PrintPanel: TPanel;
    PrintBTN: TButton;
    procedure FormCreate(Sender: TObject);
    procedure DoneBTNClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.xfm}

procedure TMainForm.FormCreate(Sender: TObject);
var
FontFile: String;
FontInfo: TTTFInfoList;
F: file of byte;
TrueType: String;
FSize: String;
begin
  FontFile := ParamStr(1);
  if ExtractFileExt(FontFile) = '.ttf' then TrueType := ' (TrueType)';
  try
  GetFontInfo(FontFile,@FontInfo);
  except
  end;
  MainForm.Caption := FontInfo.FontName + TrueType;
  FontNameLBL.Caption := FontInfo.FontName + TrueType;

  TypeFaceLBL.Caption := 'Typeface name: ' + FontInfo.FontName;
  if FileExists(FontFile) then
  begin
   AssignFile(F, FontFile);
   FileMode:=0;
   Reset(F);
   try
    FSize := IntToStr(FileSize(F));
    FileSizeLBL.Caption := 'File size: ' + Copy(FSize,1,Length(FSize)-3) + ' KB';;
   finally
    CloseFile(F);
   end;
  end;
  VersionLBL.Caption := FontInfo.Version;
  CopyrightLBL.Caption := FontInfo.Copyright;
  LCaseLBL.Font.Name := FontInfo.FontName;
  UCaseLBL.Font.Name := FontInfo.FontName;
  OtherCharsLBL.Font.Name := FontInfo.FontName;

  Pt12LBL.Font.Name := FontInfo.FontName;
  Pt12LBL.Top := Bevel3.Top+Bevel3.Height+1;
  Pt12CapLBL.Top := Pt12LBL.Top+Pt12LBL.Height-Pt12CapLBL.Height;
  Pt18LBL.Font.Name := FontInfo.FontName;
  Pt18LBL.Top := Pt12LBL.Top+Pt12LBL.Height+1;
  Pt18CapLBL.Top := Pt18LBL.Top+Pt18LBL.Height-Pt18CapLBL.Height;
  Pt24LBL.Font.Name := FontInfo.FontName;
  Pt24LBL.Top := Pt18LBL.Top+Pt18LBL.Height+1;
  Pt24CapLBL.Top := Pt24LBL.Top+Pt24LBL.Height-Pt24CapLBL.Height;
  Pt36LBL.Font.Name := FontInfo.FontName;
  Pt36LBL.Top := Pt24LBL.Top+Pt24LBL.Height+1;
  Pt36CapLBL.Top := Pt36LBL.Top+Pt36LBL.Height-Pt36CapLBL.Height;
  Pt48LBL.Font.Name := FontInfo.FontName;
  Pt48LBL.Top := Pt36LBL.Top+Pt36LBL.Height+1;
  Pt48CapLBL.Top := Pt48LBL.Top+Pt48LBL.Height-Pt48CapLBL.Height;
  Pt60LBL.Font.Name := FontInfo.FontName;
  Pt60LBL.Top := Pt48LBL.Top+Pt48LBL.Height+1;
  Pt60CapLBL.Top := Pt60LBL.Top+Pt60LBL.Height-Pt60CapLBL.Height;
  Pt72LBL.Font.Name := FontInfo.FontName;
  Pt72LBL.Top := Pt60LBL.Top+Pt60LBL.Height+1;
  Pt72CapLBL.Top := Pt72LBL.Top+Pt72LBL.Height-Pt72CapLBL.Height;
  DumbyLBL.Top := Pt72LBL.Top+Pt72LBL.Height+1;
end;

procedure TMainForm.DoneBTNClick(Sender: TObject);
begin
Close;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
ScrollBox.AutoScroll := True;
end;

end.
