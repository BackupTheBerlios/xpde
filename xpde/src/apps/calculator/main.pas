unit main;

// Bugs:
//  Standard:
//  -Length 32 number plus another number shouldn't go into scientific notation
//   until length is greater than 32.
//  Scientific:
//  -Converting between Hex, Dec, Oct, and Bin are wrong.

// Todo:
//  Scientific:
//  -Most advanced operations are not implimented.

interface

uses
  SysUtils, Types, Classes,
  Variants, QTypes, QGraphics,
  QControls, QForms, QDialogs,
  QStdCtrls, QMenus, QExtCtrls,
  FastStrings, uXPAPI;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    EditMNU: TMenuItem;
    CopyMNU: TMenuItem;
    PasteMNU: TMenuItem;
    ViewMNU: TMenuItem;
    ScientificMNU: TMenuItem;
    StandardMNU: TMenuItem;
    N1: TMenuItem;
    DigitGroupingMNU: TMenuItem;
    HelpMNU: TMenuItem;
    AboutCalculator1: TMenuItem;
    N2: TMenuItem;
    HelpTopics1: TMenuItem;
    HexMNU: TMenuItem;
    DecimalMNU: TMenuItem;
    OctalMNU: TMenuItem;
    BinaryMNU: TMenuItem;
    N3: TMenuItem;
    DegreesMNU: TMenuItem;
    RadiansMNU: TMenuItem;
    GradsMNU: TMenuItem;
    N4: TMenuItem;
    StandardPanel: TPanel;
    BackSpaceBTN: TButton;
    CBTN: TButton;
    CEBTN: TButton;
    MCBTN: TButton;
    MRBTN: TButton;
    MSBTN: TButton;
    MAddBTN: TButton;
    MemoryLBL: TLabel;
    SevenBTN: TButton;
    EightBTN: TButton;
    NineBTN: TButton;
    DivideBTN: TButton;
    SqrtBTN: TButton;
    FourBTN: TButton;
    FiveBTN: TButton;
    SixBTN: TButton;
    MultiplyBTN: TButton;
    PercentBTN: TButton;
    OneBTN: TButton;
    TwoBTN: TButton;
    ThreeBTN: TButton;
    MinusBTN: TButton;
    OneOverBTN: TButton;
    ZeroBTN: TButton;
    PlusMinusBTN: TButton;
    DecimalBTN: TButton;
    PlusBTN: TButton;
    EqualBTN: TButton;
    CalcEdit: TEdit;
    SciencePanel: TPanel;
    QwordMNU: TMenuItem;
    DwordMNU: TMenuItem;
    WordMNU: TMenuItem;
    ByteMNU: TMenuItem;
    N5: TMenuItem;
    SciCalcEdit: TEdit;
    NumeralGroup: TRadioGroup;
    ByteGroup: TRadioGroup;
    FloatGroup: TRadioGroup;
    SciMemoryLBL: TLabel;
    SciBackSpaceBTN: TButton;
    SciCEBTN: TButton;
    SciCBTN: TButton;
    SciMCBTN: TButton;
    SciSevenBTN: TButton;
    SciEightBTN: TButton;
    SciNineBTN: TButton;
    SciDivideBTN: TButton;
    SciMRBTN: TButton;
    SciFourBTN: TButton;
    SciFiveBTN: TButton;
    SciSixBTN: TButton;
    SciMultiplyBTN: TButton;
    SciMSBTN: TButton;
    SciOneBTN: TButton;
    SciTwoBTN: TButton;
    SciThreeBTN: TButton;
    SciMinusBTN: TButton;
    SciMBTN: TButton;
    SciZeroBTN: TButton;
    SciPlusMinusBTN: TButton;
    SciDecimalBTN: TButton;
    SciPlusBTN: TButton;
    SciEqualBTN: TButton;
    ModBTN: TButton;
    OrBTN: TButton;
    LshBTN: TButton;
    AndBTN: TButton;
    XorBTN: TButton;
    NotBTN: TButton;
    IntBTN: TButton;
    piBTN: TButton;
    HexABTN: TButton;
    HexBBTN: TButton;
    HexCBTN: TButton;
    HexDBTN: TButton;
    HexEBTN: TButton;
    HexFBTN: TButton;
    CheckGroup: TGroupBox;
    SciOtherLBL: TLabel;
    StaBTN: TButton;
    AveBTN: TButton;
    SumBTN: TButton;
    sBTN: TButton;
    DatBTN: TButton;
    FEBTN: TButton;
    OpenParBTN: TButton;
    CloseParBTN: TButton;
    dmsBTN: TButton;
    ExpBTN: TButton;
    lnBTN: TButton;
    sinBTN: TButton;
    xyBTN: TButton;
    logBTN: TButton;
    cosBTN: TButton;
    x3BTN: TButton;
    nBTN: TButton;
    tanBTN: TButton;
    x2BTN: TButton;
    SciOneOverBTN: TButton;
    InvCB: TCheckBox;
    HypCB: TCheckBox;
    procedure ViewMNUClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AboutCalculator1Click(Sender: TObject);
    procedure ZeroBTNClick(Sender: TObject);
    procedure DecimalBTNClick(Sender: TObject);
    procedure CEBTNClick(Sender: TObject);
    procedure CBTNClick(Sender: TObject);
    procedure CopyMNUClick(Sender: TObject);
    procedure PasteMNUClick(Sender: TObject);
    procedure EqualBTNClick(Sender: TObject);
    procedure DivideBTNClick(Sender: TObject);
    procedure PlusMinusBTNClick(Sender: TObject);
    procedure SqrtBTNClick(Sender: TObject);
    procedure OneOverBTNClick(Sender: TObject);
    procedure MCBTNClick(Sender: TObject);
    procedure MRBTNClick(Sender: TObject);
    procedure MSBTNClick(Sender: TObject);
    procedure MAddBTNClick(Sender: TObject);
    procedure PercentBTNClick(Sender: TObject);
    procedure BackSpaceBTNClick(Sender: TObject);
    procedure CalcEditChange(Sender: TObject);
    procedure StandardMNUClick(Sender: TObject);
    procedure ScientificMNUClick(Sender: TObject);
    procedure DigitGroupingMNUClick(Sender: TObject);
    procedure HexMNUClick(Sender: TObject);
    procedure DegreesMNUClick(Sender: TObject);
    procedure QwordMNUClick(Sender: TObject);
    procedure NumeralGroupClick(Sender: TObject);
    procedure piBTNClick(Sender: TObject);
    procedure SciZeroBTNClick(Sender: TObject);
    procedure SciCEBTNClick(Sender: TObject);
    procedure SciCBTNClick(Sender: TObject);
    procedure SciBackSpaceBTNClick(Sender: TObject);
    procedure SciMCBTNClick(Sender: TObject);
    procedure SciPlusMinusBTNClick(Sender: TObject);
    procedure SciDecimalBTNClick(Sender: TObject);
    procedure SciDivideBTNClick(Sender: TObject);
    procedure SciEqualBTNClick(Sender: TObject);
    procedure FEBTNClick(Sender: TObject);
    procedure StaBTNClick(Sender: TObject);
    procedure ByteGroupClick(Sender: TObject);
    procedure FloatGroupClick(Sender: TObject);
  private
    { Private declarations }
    IsDecimal: Boolean;
    CalcText: String;
    SciCalcText: String;
    CurrentNum: Extended;
    MemoryNum: Extended;
    Operation: Integer;
    CanBackSpace: Boolean;
    PreviousType: Integer;
    EmptyEdit: String;
    procedure SetCalcText(S: string);
    procedure SetSciCalcText(S: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.xfm}

const
 EmptySciEdit = '0 ';

function IntToBin(Value: LongInt;
                  Digits: Integer): String;
var
 i: Integer;
begin
 Result:='';
 for i:=Digits downto 0 do
  if Value and (1 shl i)<>0 then
   Result:=Result + '1'
  else
   Result:=Result + '0';
end;

function BinToInt(Value: String): LongInt;
var
 i,Digits: Integer;
begin
 Result:=0;
 Digits:=Length(Value);
 while Copy(Value,1,1)='0' do
  Value:=Copy(Value,2,Length(Value)-1);
 for i:=Digits downto 1 do
  if Copy(Value,i,1)='1' then
   Result:=Result+(1 shl (i-1));
end;

function OctToInt(Value: string): Longint;
var
  i: Integer;
  int: Integer;
begin
  int := 0;
  for i := 1 to Length(Value) do
  begin
    int := int * 8 + StrToInt(Copy(Value, i, 1));
  end;
  Result := int;
end;

function IntToOct(Value: Longint; digits: Integer): string;
var
  rest: Longint;
  oct: string;
  i: Integer;
begin
  oct := '';
  while Value <> 0 do
  begin
    rest  := Value mod 8;
    Value := Value div 8;
    oct := IntToStr(rest) + oct;
  end;
  for i := Length(oct) + 1 to digits do
    oct := '0' + oct;
  Result := oct;
end;

function HexToInt(HexStr: String): Int64;
var RetVar : Int64;
    i : byte;
begin
  HexStr := UpperCase(HexStr);
  if HexStr[length(HexStr)] = 'H' then
     Delete(HexStr,length(HexStr),1);
  RetVar := 0;

  for i := 1 to length(HexStr) do begin
      RetVar := RetVar shl 4;
      if HexStr[i] in ['0'..'9'] then
         RetVar := RetVar + (byte(HexStr[i]) - 48)
      else
         if HexStr[i] in ['A'..'F'] then
            RetVar := RetVar + (byte(HexStr[i]) - 55)
         else begin
            Retvar := 0;
            break;
         end;
  end;

  Result := RetVar;
end;

function AddThousandSeparator(S: string; Chr: Char): string;
var
  I: Integer;
  Decimal: String;
begin
  Decimal := Copy(S,SmartPos(DecimalSeparator,S),Length(S));
  if SmartPos('-',S) > 0 then
   Result := Copy(S,2,SmartPos(DecimalSeparator,S)-2)
  else
   Result := Copy(S,1,SmartPos(DecimalSeparator,S)-1);
  I := Length(Result) - 2;
  while I > 1 do
  begin
    Insert(Chr, Result, I);
    I := I - 3;
  end;
  if SmartPos('-',S) > 0 then
   Result := '-' + Result + Decimal
  else
   Result := Result + Decimal;
end;

function AddSciSeparator(S: string; Chr: Char): string;
var
  I: Integer;
begin
  if SmartPos('-',S) > 0 then
   Result := Copy(S,2,Length(S))
  else
   Result := Copy(S,1,Length(S));
  I := Length(Result) - 2;
  while I > 1 do
  begin
    Insert(Chr, Result, I);
    I := I - 4;
  end;
  if SmartPos('-',S) > 0 then
   Result := '-' + Result
  else
   Result := Result;
end;

procedure TMainForm.SetCalcText(S: string);
var
MaxLen: Integer;
begin
if SmartPos('-',S) = 0 then
 MaxLen := 35
else
 MaxLen := 36;
if Length(S) < MaxLen then
 begin
  CalcText := S;
  if DigitGroupingMNU.Checked then
   begin
    CalcEdit.Text := AddThousandSeparator(Trim(S),ThousandSeparator) + ' ';
   end
  else
   begin
    CalcEdit.Text := S;
   end;
 end;
end;

procedure TMainForm.SetSciCalcText(S: string);
var
MaxLen: Integer;
Negative: Integer;
Tmp: String;
begin
Tmp := S;
if SmartPos('-',Tmp) > 0 then
 Negative := 1
else
 Negative := 0;
if NumeralGroup.ItemIndex = 0 then
 begin
  case ByteGroup.ItemIndex of
   0: MaxLen := 17;
   1: MaxLen := 9;
   2: MaxLen := 5;
   3: MaxLen := 3;
  end;
 end
else
if NumeralGroup.ItemIndex = 1 then
 begin
  MaxLen := 35;
 end
else
if NumeralGroup.ItemIndex = 2 then
 begin
  case ByteGroup.ItemIndex of
   0: MaxLen := 22;
   1: MaxLen := 11;
   2: MaxLen := 6;
   3: MaxLen := 3;
  end;
 end
else
if NumeralGroup.ItemIndex = 3 then
 begin
  case ByteGroup.ItemIndex of
   0: MaxLen := 65;
   1: MaxLen := 33;
   2: MaxLen := 17;
   3: MaxLen := 9;
  end;
 end;

if (NumeralGroup.ItemIndex <> 1) and (SmartPos(DecimalSeparator,Tmp) > 0) then
 begin
  Tmp := FastReplace(Tmp,DecimalSeparator,'');
 end;

Tmp := Copy(Tmp,Length(Tmp)-(MaxLen+Negative)+1,Length(Tmp));

if Length(Tmp) <= (MaxLen+Negative) then
 begin
  SciCalcText := Tmp;
  if DigitGroupingMNU.Checked then
   begin
    if NumeralGroup.ItemIndex = 1 then
     begin
      SciCalcEdit.Text := AddThousandSeparator(Trim(Tmp),ThousandSeparator) + ' ';
     end
    else
     begin
      SciCalcEdit.Text := AddSciSeparator(Trim(Tmp),' ') + ' ';
     end;
   end
  else
   begin
    SciCalcEdit.Text := Tmp;
   end;
 end;
end;

procedure TMainForm.ViewMNUClick(Sender: TObject);
begin
if StandardMNU.Checked then
 begin
  HexMNU.Visible := False;
  DecimalMNU.Visible := False;
  OctalMNU.Visible := False;
  BinaryMNU.Visible := False;
  N3.Visible := False;
  DegreesMNU.Visible := False;
  RadiansMNU.Visible := False;
  GradsMNU.Visible := False;
  N4.Visible := False;
  QWordMNU.Visible := False;
  DWordMNU.Visible := False;
  WordMNU.Visible := False;
  ByteMNU.Visible := False;
  N5.Visible := False;
 end
else
 begin
  HexMNU.Visible := True;
  DecimalMNU.Visible := True;
  OctalMNU.Visible := True;
  BinaryMNU.Visible := True;
  N3.Visible := True;
  if DecimalMNU.Checked then
   begin
    DegreesMNU.Visible := True;
    RadiansMNU.Visible := True;
    GradsMNU.Visible := True;
    N4.Visible := True;

    QWordMNU.Visible := False;
    DWordMNU.Visible := False;
    WordMNU.Visible := False;
    ByteMNU.Visible := False;
    N5.Visible := False;
   end
  else
   begin
    DegreesMNU.Visible := False;
    RadiansMNU.Visible := False;
    GradsMNU.Visible := False;
    N4.Visible := False;

    QWordMNU.Visible := True;
    DWordMNU.Visible := True;
    WordMNU.Visible := True;
    ByteMNU.Visible := True;
    N5.Visible := True;
   end;
 end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    //These lines are here to set the font of the menubar
    font.name:='';
    parentfont:=true;
Operation := 0;
CurrentNum := 0;
EmptyEdit := '0' + DecimalSeparator + ' ';
CalcText := EmptyEdit;
CalcEdit.Text := EmptyEdit;
SciCalcEdit.Text := EmptyEdit;
DecimalBTN.Caption := DecimalSeparator;
SciDecimalBTN.Caption := DecimalSeparator;
MCBTNClick(Self);
StandardMNUClick(Self);
ViewMNUClick(Self);
end;

procedure TMainForm.AboutCalculator1Click(Sender: TObject);
begin
    XPAPI.showAboutDlg('Calculator');
end;

procedure TMainForm.ZeroBTNClick(Sender: TObject);
var
Str: String;
begin
if not CanBackSpace then
 begin
  CEBTNClick(Self);
 end;
if IsDecimal then
 begin
  SetCalcText(Trim(CalcText) + IntToStr(TButton(Sender).Tag) + ' ');
 end
else
 begin
  Str := '';
  if CalcText <> EmptyEdit then
   begin
    Str := Copy(CalcText,1,Length(CalcText)-2);
   end;
  SetCalcText(Str + IntToStr(TButton(Sender).Tag) + DecimalSeparator + ' ');
 end;
end;

procedure TMainForm.DecimalBTNClick(Sender: TObject);
begin
IsDecimal := True;
end;

procedure TMainForm.CEBTNClick(Sender: TObject);
begin
IsDecimal := False;
SetCalcText(EmptyEdit);
end;

procedure TMainForm.CBTNClick(Sender: TObject);
begin
CEBTNClick(Self);
Operation := 0;
CurrentNum := 0;
end;

procedure TMainForm.CopyMNUClick(Sender: TObject);
begin
CalcEdit.CopyToClipboard;
end;

procedure TMainForm.PasteMNUClick(Sender: TObject);
begin
CalcEdit.PasteFromClipboard;
end;

procedure TMainForm.EqualBTNClick(Sender: TObject);
var
Str: String;
begin
case Operation of
 0: begin
     // do nothing
    end;
 1: begin
     CurrentNum := CurrentNum / StrToFloat(Trim(CalcText));
    end;
 2: begin
     CurrentNum := CurrentNum * StrToFloat(Trim(CalcText));
    end;
 3: begin
     CurrentNum := CurrentNum - StrToFloat(Trim(CalcText));
    end;
 4: begin
     CurrentNum := CurrentNum + StrToFloat(Trim(CalcText));
    end;
 end;
Str := FloatToStr(CurrentNum);
if SmartPos(DecimalSeparator,Str) = 0 then Str := Str + DecimalSeparator;
SetCalcText(Str + ' ');
Operation := 0;
IsDecimal := False;
CurrentNum := 0;
CanBackSpace := False;
end;

procedure TMainForm.DivideBTNClick(Sender: TObject);
begin
 if Operation > 0 then
  begin
   EqualBTNClick(Self);
   Operation := TButton(Sender).Tag;
   CurrentNum := StrToFloat(Trim(CalcText));
  end
 else
  begin
   Operation := TButton(Sender).Tag;
   CurrentNum := StrToFloat(Trim(CalcText));
   CanBackSpace := False;
  end;
end;

procedure TMainForm.PlusMinusBTNClick(Sender: TObject);
begin
if SmartPos('-',CalcText) > 0 then
 begin
  SetCalcText(Copy(CalcText,2,Length(CalcText)));
 end
else
 begin
  if CalcText <> EmptyEdit then
   SetCalcText('-' + CalcText);
 end;
end;

procedure TMainForm.SqrtBTNClick(Sender: TObject);
begin
 CurrentNum := Sqrt(StrToFloat(Trim(CalcText)));
 Operation := 0;
 EqualBTNClick(Self);
end;

procedure TMainForm.OneOverBTNClick(Sender: TObject);
begin
 CurrentNum := 1 / StrToFloat(Trim(CalcText));
 Operation := 0;
 EqualBTNClick(Self);
end;

procedure TMainForm.MCBTNClick(Sender: TObject);
begin
MemoryNum := 0;
MemoryLBL.Caption := '';
end;

procedure TMainForm.MRBTNClick(Sender: TObject);
begin
SetCalcText(FloatToStr(MemoryNum) + ' ');
end;

procedure TMainForm.MSBTNClick(Sender: TObject);
begin
MemoryNum := StrToFloat(Trim(CalcText));
MemoryLBL.Caption := 'M';
end;

procedure TMainForm.MAddBTNClick(Sender: TObject);
begin
MemoryNum := MemoryNum + StrToFloat(Trim(CalcText));
MemoryLBL.Caption := 'M';
CanBackSpace := False;
end;

procedure TMainForm.PercentBTNClick(Sender: TObject);
begin
SetCalcText(FloatToStr(CurrentNum * (StrToFloat(Trim(CalcText)) / 100)));
CurrentNum := 0;
end;

procedure TMainForm.BackSpaceBTNClick(Sender: TObject);
begin
if CanBackSpace then
 begin
  if IsDecimal and (SmartPos(DecimalSeparator + ' ',CalcText) > 0) then
   begin
    IsDecimal := False;
   end
  else
   begin
    SetCalcText(Copy(Trim(CalcText),1,Length(CalcText)-2) + DecimalSeparator + ' ');
   end;
 end;
end;

procedure TMainForm.CalcEditChange(Sender: TObject);
begin
 CanBackSpace := True;
end;

procedure TMainForm.StandardMNUClick(Sender: TObject);
begin
StandardMNU.Checked := True;
SciencePanel.Visible := False;
MainForm.ClientHeight := 206;
MainForm.ClientWidth := 252;
StandardPanel.Visible := True;
end;

procedure TMainForm.ScientificMNUClick(Sender: TObject);
begin
ScientificMNU.Checked := True;
PreviousType := 1;
DecimalMNU.Checked := True;
DegreesMNU.Checked := True;
SciCalcEdit.Text := EmptyEdit;
SciCalcText := EmptyEdit;
StandardPanel.Visible := False;
MainForm.ClientHeight := 265;
MainForm.ClientWidth := 474;
SciencePanel.Visible := True;
end;

procedure TMainForm.DigitGroupingMNUClick(Sender: TObject);
begin
if DigitGroupingMNU.Checked then
 begin
  DigitGroupingMNU.Checked := False;
  if StandardMNU.Checked then
   begin
    SetCalcText(CalcText);
   end
  else
   begin
    SetSciCalcText(SciCalcText);
   end;
 end
else
 begin
  DigitGroupingMNU.Checked := True;
  if StandardMNU.Checked then
   begin
    SetCalcText(CalcText);
   end
  else
   begin
    SetSciCalcText(SciCalcText);
   end;
 end;
end;

procedure TMainForm.HexMNUClick(Sender: TObject);
begin
 NumeralGroup.ItemIndex := TMenuItem(Sender).Tag;
end;

procedure TMainForm.DegreesMNUClick(Sender: TObject);
begin
 TMenuItem(Sender).Checked := True;
 FloatGroup.ItemIndex := TMenuItem(Sender).Tag;
end;

procedure TMainForm.QwordMNUClick(Sender: TObject);
begin
 TMenuItem(Sender).Checked := True;
 ByteGroup.ItemIndex := TMenuItem(Sender).Tag;
end;

procedure TMainForm.NumeralGroupClick(Sender: TObject);
begin
 case NumeralGroup.ItemIndex of
  0: HexMNU.Checked := True;
  1: DecimalMNU.Checked := True;
  2: OctalMNU.Checked := True;
  3: BinaryMNU.Checked := True;
 end;

 if NumeralGroup.ItemIndex <> 1 then
  begin
   DecimalMNU.Checked := False;
   FloatGroup.Visible := False;
   ByteGroup.Visible := True;

   FEBTN.Enabled := False;
   dmsBTN.Enabled := False;
   sinBTN.Enabled := False;
   cosBTN.Enabled := False;
   tanBTN.Enabled := False;
   ExpBTN.Enabled := False;
   piBTN.Enabled := False;
  end
 else
  begin
   FEBTN.Enabled := True;
   dmsBTN.Enabled := True;
   sinBTN.Enabled := True;
   cosBTN.Enabled := True;
   tanBTN.Enabled := True;
   ExpBTN.Enabled := True;
   piBTN.Enabled := True;
  end;

 if NumeralGroup.ItemIndex <> 0 then
  begin
   HexABTN.Enabled := False;
   HexBBTN.Enabled := False;
   HexCBTN.Enabled := False;
   HexDBTN.Enabled := False;
   HexEBTN.Enabled := False;
   HexFBTN.Enabled := False;
  end
 else
  begin
   HexABTN.Enabled := True;
   HexBBTN.Enabled := True;
   HexCBTN.Enabled := True;
   HexDBTN.Enabled := True;
   HexEBTN.Enabled := True;
   HexFBTN.Enabled := True;
  end;

 if NumeralGroup.ItemIndex = 1 then
  begin
   FloatGroup.Visible := True;
   ByteGroup.Visible := False;

   SciTwoBTN.Enabled := True;
   SciThreeBTN.Enabled := True;
   SciFourBTN.Enabled := True;
   SciFiveBTN.Enabled := True;
   SciSixBTN.Enabled := True;
   SciSevenBTN.Enabled := True;
   SciEightBTN.Enabled := True;
   SciNineBTN.Enabled := True;
  end
 else
 if NumeralGroup.ItemIndex = 0 then
  begin
   SciTwoBTN.Enabled := True;
   SciThreeBTN.Enabled := True;
   SciFourBTN.Enabled := True;
   SciFiveBTN.Enabled := True;
   SciSixBTN.Enabled := True;
   SciSevenBTN.Enabled := True;
   SciEightBTN.Enabled := True;
   SciNineBTN.Enabled := True;
  end
 else
 if NumeralGroup.ItemIndex = 2 then
  begin

   SciTwoBTN.Enabled := True;
   SciThreeBTN.Enabled := True;
   SciFourBTN.Enabled := True;
   SciFiveBTN.Enabled := True;
   SciSixBTN.Enabled := True;
   SciSevenBTN.Enabled := True;

   SciEightBTN.Enabled := False;
   SciNineBTN.Enabled := False;
  end
 else
 if NumeralGroup.ItemIndex = 3 then
  begin

   SciTwoBTN.Enabled := False;
   SciThreeBTN.Enabled := False;
   SciFourBTN.Enabled := False;
   SciFiveBTN.Enabled := False;
   SciSixBTN.Enabled := False;
   SciSevenBTN.Enabled := False;
   SciEightBTN.Enabled := False;
   SciNineBTN.Enabled := False;
  end;

  AveBTN.Enabled := False;
  SumBTN.Enabled := False;
  sBTN.Enabled := False;
  DatBTN.Enabled := False;

  // All of the conversions are bugged and have to do with the 32
  if (PreviousType = 1) and (NumeralGroup.ItemIndex = 0) then
   begin
    // convert float to hex
    SetSciCalcText(IntToHex(Trunc(StrToFloat(Trim(SciCalcText))),32) + ' ');
   end
  else
  if (PreviousType = 1) and (NumeralGroup.ItemIndex = 2) then
   begin
    // convert float to octal
    SetSciCalcText(IntToOct(Trunc(StrToFloat(Trim(SciCalcText))),32) + ' ');
   end
  else
  if (PreviousType = 1) and (NumeralGroup.ItemIndex = 3) then
   begin
    // convert float to bin
    SetSciCalcText(IntToBin(Trunc(StrToFloat(Trim(SciCalcText))),32) + ' ');
   end
  else
  if (PreviousType = 0) and (NumeralGroup.ItemIndex = 1) then
   begin
    // convert hex to int
    SetSciCalcText(IntToStr(HexToInt(Trim(SciCalcText))) + '. ');
   end
  else
  if (PreviousType = 0) and (NumeralGroup.ItemIndex = 2) then
   begin
    // convert hex to octal
    SetSciCalcText(IntToOct(HexToInt(Trim(SciCalcText)),32) + '. ');
   end
  else
  if (PreviousType = 0) and (NumeralGroup.ItemIndex = 3) then
   begin
    // convert hex to bin
    SetSciCalcText(IntToBin(HexToInt(Trim(SciCalcText)),32) + ' ');
   end
  else
  if (PreviousType = 3) and (NumeralGroup.ItemIndex = 0) then
   begin
    // convert bin to hex
    SetSciCalcText(IntToHex(BinToInt(Trim(SciCalcText)),32) + ' ');
   end
  else
  if (PreviousType = 3) and (NumeralGroup.ItemIndex = 1) then
   begin
    // convert bin to int
    SetSciCalcText(IntToStr(BinToInt(Trim(SciCalcText))) + '. ');
   end
  else
  if (PreviousType = 3) and (NumeralGroup.ItemIndex = 2) then
   begin
    // convert bin to octal
    SetSciCalcText(IntToOct(BinToInt(Trim(SciCalcText)),32) + '. ');
   end
  else
  if (PreviousType = 2) and (NumeralGroup.ItemIndex = 0) then
   begin
    // convert octal to hex
    SetSciCalcText(IntToHex(OctToInt(Trim(SciCalcText)),32) + ' ');
   end
  else
  if (PreviousType = 2) and (NumeralGroup.ItemIndex = 1) then
   begin
    // convert octal to int
    SetSciCalcText(IntToStr(OctToInt(Trim(SciCalcText))) + '. ');
   end
  else
  if (PreviousType = 2) and (NumeralGroup.ItemIndex = 3) then
   begin
    // convert octal to bin
    SetSciCalcText(IntToOct(OctToInt(Trim(SciCalcText)),32) + '. ');
   end;
  PreviousType := NumeralGroup.ItemIndex;
end;

procedure TMainForm.piBTNClick(Sender: TObject);
begin
SetSciCalcText('3' + DecimalSeparator + '1415926535897932384626433832795' + ' ');
end;

procedure TMainForm.SciZeroBTNClick(Sender: TObject);
var
Str, Dot: String;
begin
if NumeralGroup.ItemIndex = 1 then Dot := DecimalSeparator else Dot := '';
if not CanBackSpace then
 begin
  SciCEBTNClick(Self);
 end;
if IsDecimal then
 begin
  SetSciCalcText(Trim(SciCalcText) + IntToStr(TButton(Sender).Tag) + ' ');
 end
else
 begin
  Str := '';
  if (SciCalcText <> ('0' + Dot + ' ')) then
   begin
    Str := Copy(SciCalcText,1,Length(SciCalcText)-2);
   end;
  SetSciCalcText(Str + IntToStr(TButton(Sender).Tag) + Dot + ' ');
 end;
end;

procedure TMainForm.SciCEBTNClick(Sender: TObject);
begin
IsDecimal := False;
if NumeralGroup.ItemIndex = 1 then
 SetSciCalcText(EmptyEdit)
else
 SetSciCalcText(EmptySciEdit);
end;

procedure TMainForm.SciCBTNClick(Sender: TObject);
begin
SciCEBTNClick(Self);
Operation := 0;
CurrentNum := 0;
end;

procedure TMainForm.SciBackSpaceBTNClick(Sender: TObject);
var
Dot: String;
begin
if CanBackSpace then
 begin
  if IsDecimal and (SmartPos('. ',SciCalcText) > 0) then
   begin
    IsDecimal := False;
   end
  else
   begin
    if NumeralGroup.ItemIndex = 1 then Dot := DecimalSeparator else Dot := '';
    SetSciCalcText(Copy(Trim(SciCalcText),1,Length(SciCalcText)-2) + Dot + ' ');
   end;
 end;
end;

procedure TMainForm.SciMCBTNClick(Sender: TObject);
begin
case TButton(Sender).Tag of
0: begin
    MemoryNum := 0;
    SciMemoryLBL.Caption := '';
   end;
1: begin
    SetSciCalcText(FloatToStr(MemoryNum) + ' ');
   end;
2: begin
    MemoryNum := StrToFloat(Trim(SciCalcText));
    SciMemoryLBL.Caption := 'M';
   end;
3: begin
    MemoryNum := MemoryNum + StrToFloat(Trim(SciCalcText));
    SciMemoryLBL.Caption := 'M';
    CanBackSpace := False;
   end;
end;
end;

procedure TMainForm.SciPlusMinusBTNClick(Sender: TObject);
begin
if NumeralGroup.ItemIndex = 1 then
 begin
  if SmartPos('-',SciCalcText) > 0 then
   begin
    SetSciCalcText(Copy(SciCalcText,2,Length(SciCalcText)));
   end
  else
   begin
    if SciCalcText <> EmptyEdit then
     SetSciCalcText('-' + SciCalcText);
   end;
 end;
end;

procedure TMainForm.SciDecimalBTNClick(Sender: TObject);
begin
if NumeralGroup.ItemIndex = 1 then
 IsDecimal := True;
end;

procedure TMainForm.SciDivideBTNClick(Sender: TObject);
begin
 if Operation > 0 then
  begin
   SciEqualBTNClick(Self);
   Operation := TButton(Sender).Tag;
   CurrentNum := StrToFloat(Trim(SciCalcText));
  end
 else
  begin
   Operation := TButton(Sender).Tag;
   CurrentNum := StrToFloat(Trim(SciCalcText));
   CanBackSpace := False;
  end;
end;

procedure TMainForm.SciEqualBTNClick(Sender: TObject);
var
Str: String;
begin
case Operation of
 0: begin
     // do nothing
    end;
 1: begin
     CurrentNum := CurrentNum / StrToFloat(Trim(SciCalcText));
    end;
 2: begin
     CurrentNum := CurrentNum * StrToFloat(Trim(SciCalcText));
    end;
 3: begin
     CurrentNum := CurrentNum - StrToFloat(Trim(SciCalcText));
    end;
 4: begin
     CurrentNum := CurrentNum + StrToFloat(Trim(SciCalcText));
    end;
 5: begin
     // do Mod
    end;
 6: begin
     // do Or
    end;
 7: begin
     // do Lsh
    end;
 8: begin
     // do And
    end;
 9: begin
     // do Xor
    end;
 10: begin
     // do Not
    end;
 11: begin
     // do Int
    end;
 end;
Str := FloatToStr(CurrentNum);
if (SmartPos(DecimalSeparator,Str) = 0) and (NumeralGroup.ItemIndex = 1) then Str := Str + DecimalSeparator;
SetSciCalcText(Str + ' ');
Operation := 0;
IsDecimal := False;
CurrentNum := 0;
CanBackSpace := False;
end;

procedure TMainForm.FEBTNClick(Sender: TObject);
begin
case TButton(Sender).Tag of
 0: begin
     // Do nothing
    end;
 1: begin
     // Do F-E
    end;
 2: begin
     // Do dms
    end;
 3: begin
     // Do sin
    end;
 4: begin
     // Do cos
    end;
 5: begin
     // Do tan
    end;
 6: begin
     // Do (
    end;
 7: begin
     // Do Exp
    end;
 8: begin
     // Do x^y
    end;
 9: begin
     // Do x^3
    end;
 10: begin
     // Do x^2
    end;
 11: begin
     // Do )
    end;
 12: begin
     // Do ln
    end;
 13: begin
     // Do log
    end;
 14: begin
     // Do n!
    end;
 15: begin
     // Do 1/x
    end;
end;
end;

procedure TMainForm.StaBTNClick(Sender: TObject);
begin
case TButton(Sender).Tag of
 0: begin
     // Do nothing
    end;
 1: begin
     // Do Sta
    end;
 2: begin
     // Do Ave
    end;
 3: begin
     // Do Sum
    end;
 4: begin
     // Do s
    end;
 5: begin
     // Do Dat
    end;
end;
end;

procedure TMainForm.ByteGroupClick(Sender: TObject);
begin
  SetSciCalcText(SciCalcText);
end;

procedure TMainForm.FloatGroupClick(Sender: TObject);
begin
  SetSciCalcText(SciCalcText);
end;

end.
