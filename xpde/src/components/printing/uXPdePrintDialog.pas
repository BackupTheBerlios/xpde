{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2003 Theo Lustenberger                                        }
{                                                                             }
{ This program is free software; you can redistribute it and/or               }
{ modify it under the terms of the GNU General Public                         }
{ License as published by the Free Software Foundation; either                }
{ version 2 of the License, or (at your option) any later version.            }
{                                                                             }
{ This program is distributed in the hope that it will be useful,             }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of              }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU           }
{ General Public License for more details.                                    }
{                                                                             }
{ You should have received a copy of the GNU General Public License           }
{ along with this program; see the file COPYING.  If not, write to            }
{ the Free Software Foundation, Inc., 59 Temple Place - Suite 330,            }
{ Boston, MA 02111-1307, USA.                                                 }
{                                                                             }
{ *************************************************************************** }

unit uXPdePrintDialog;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QImgList, QComCtrls, QPrinters, QExtCtrls, Qt,
  uPrinterInfo, uRegistry;
type
//these must be handled by the application
  TCustomPrintOptions = (cpoPages, cpoSelection, cpoCopies, cpoMargins);
  TCustomPrintOptionsSet = set of TCustomPrintOptions;
  TPrintRange = (prAll, prPages, prSelection);
  TRange = record
    Start: integer;
    Ende: integer;
  end;
  TPrintForm = class(TForm)
    BtnPrint: TButton;
    BtnCancel: TButton;
    BtnApply: TButton;
    PrinterPageControl: TPageControl;
    TSGeneral: TTabSheet;
    GBSelectPrinter: TGroupBox;
    IconView1: TIconView;
    LNStatus: TLabel;
    LNName: TLabel;
    LNWhere: TLabel;
    LNAlias: TLabel;
    LVStatus: TLabel;
    LVType: TLabel;
    LVWhere: TLabel;
    LVAlias: TLabel;
    CBPrintToFile: TCheckBox;
    GBCopies: TGroupBox;
    ImNumCopies: TImage;
    SECopies: TSpinEdit;
    LNNumCopies: TLabel;
    TSLayout: TTabSheet;
    TSPaper: TTabSheet;
    GBRange: TGroupBox;
    RBAll: TRadioButton;
    RBPages: TRadioButton;
    RBSelection: TRadioButton;
    LNFrom: TLabel;
    LVFrom: TEdit;
    LNTo: TLabel;
    LVTo: TEdit;
    GBOrientation: TGroupBox;
    RBPortrait: TRadioButton;
    RBLandscape: TRadioButton;
    GBOrientationImg: TGroupBox;
    ImageList1: TImageList;
    ImLandscape: TImage;
    ImPortrait: TImage;
    GBPageOrder: TGroupBox;
    RBSortFirst: TRadioButton;
    RBSortLast: TRadioButton;
    GBColor: TGroupBox;
    ImGrayScale: TImage;
    ImColor: TImage;
    RBGrayscale: TRadioButton;
    RBColor: TRadioButton;
    GBPaperFormat: TGroupBox;
    CBPaperFormat: TComboBox;
    SaveDialog1: TSaveDialog;
    GBMargins: TGroupBox;
    SELeft: TSpinEdit;
    SERight: TSpinEdit;
    SETop: TSpinEdit;
    SEBottom: TSpinEdit;
    LLeft: TLabel;
    LRight: TLabel;
    LTop: TLabel;
    LBottom: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RBLandscapeClick(Sender: TObject);
    procedure RBPortraitClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure IconView1SelectItem(Sender: TObject; Item: TIconViewItem;
      Selected: Boolean);
    procedure IconView1Editing(Sender: TObject; Item: TIconViewItem;
      var AllowEdit: Boolean);
    procedure BtnPrintClick(Sender: TObject);
    procedure LVFromKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LVToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CBPrintToFileClick(Sender: TObject);
    procedure RBPagesClick(Sender: TObject);
  private
    { Private declarations }
    fCustomPrintOptions: TCustomPrintOptionsSet;
    fPrintRange: TPrintRange;
    fPages: TRange;
    fNumCopies: integer;
    function GetPrintRange: TPrintRange;
    function GetPages: TRange;
    function GetNumCopies: integer;
    function GetMargins: TRect;
    procedure ShowFromTo;
    procedure HideFromTo;
    procedure InitDialogs;
    procedure SetPrinter;
  public
    { Public declarations }
    function Execute: boolean;
    property CustomPrintOptions: TCustomPrintOptionsSet read fCustomPrintOptions write fCustomPrintOptions;
    property PrintRange: TPrintRange read GetPrintRange;
    property Pages: TRange read GetPages;
    property NumCopies: Integer read GetNumCopies;
    property Margins: TRect read GetMargins;
    procedure WriteToRegistry;
    procedure ReadFromRegistry;
  end;
function XPdePrintDialog: TPrintForm;
var
  PrintForm: TPrintForm;
  PRCI: TStrings;
implementation
{$R *.xfm}

function XPdePrintDialog: TPrintForm;
begin
  if not Assigned(PrintForm) then
    PrintForm := TPrintForm.Create(nil);
  Result := PrintForm;
end;

procedure TPrintForm.FormCreate(Sender: TObject);
begin
  PRCI := TStringList.Create;
  ReadPrintCap(PRCI);
end;

procedure TPrintForm.FormDestroy(Sender: TObject);
begin
  PRCI.free;
end;

function TPrintForm.GetPrintRange: TPrintRange;
begin
  if RBAll.Checked then Result := prAll else
    if RBPages.Checked then Result := prPages else
      if RBSelection.Checked then Result := prSelection;
end;

function TPrintForm.GetPages: TRange;
begin
  Result.Start := StrToIntDef(LVFrom.text, 1);
  Result.Ende := StrToIntDef(LVTo.text, 10000);
end;

function TPrintForm.GetNumCopies: integer;
begin
  Result := SECopies.Value;
end;

function TPrintForm.GetMargins: TRect;
begin
  Result.Left := SELeft.Value;
  Result.Right := SERight.Value;
  Result.Top := SETop.Value;
  Result.Bottom := SEBottom.Value;
end;

procedure TPrintForm.InitDialogs;
var Itm: TIconViewItem;
  i: integer;
  retval: WideString;
begin
  IconView1.Clear;
  for i := 0 to Printer.Printers.Count - 1 do
  begin
    Itm := IconView1.Items.Add;
    if i = 0 then Itm.ImageIndex := 1 else Itm.ImageIndex := 0;
    Itm.Caption := Printer.Printers[i];
  end;
  if Printer.OutputType = otPrinter then
  begin
    Qt.QPrinter_printerName(QPrinterH(Printer.Handle), @retval);
    if Printer.Printers.IndexOf(retval) > -1 then
      IconView1.Items[Printer.Printers.IndexOf(retval)].Selected := true else
      IconView1.Items[0].Selected := true;
  end else
    if Printer.OutputType = otFileName then CBPrintToFile.Checked := true;
  CBPaperFormat.Items.BeginUpdate;
  CBPaperFormat.Clear;
  CBPaperFormat.Items.add('A4 (210x297 mm, 8.26x11.7 inches)');
  CBPaperFormat.Items.add('B5 (182x257 mm, 7.17x10.13 inches)');
  CBPaperFormat.Items.add('Letter (8.5x11 inches, 216x279 mm)');
  CBPaperFormat.Items.add('Legal (8.5x14 inches, 216x356 mm)');
  CBPaperFormat.Items.add('Executive (7.5x10 inches, 191x254 mm)');
  CBPaperFormat.Items.add('A0 (841 x 1189 mm)');
  CBPaperFormat.Items.add('A1 (594 x 841 mm)');
  CBPaperFormat.Items.add('A2 (420 x 594 mm)');
  CBPaperFormat.Items.add('A3 (297 x 420 mm)');
  CBPaperFormat.Items.add('A5 (148 x 210 mm)');
  CBPaperFormat.Items.add('A6 (105 x 148 mm)');
  CBPaperFormat.Items.add('A7 (74 x 105 mm)');
  CBPaperFormat.Items.add('A8 (52 x 74 mm)');
  CBPaperFormat.Items.add('A9 (37 x 52 mm)');
  CBPaperFormat.Items.add('B0 (1030 x 1456 mm)');
  CBPaperFormat.Items.add('B1 (728 x 1030 mm)');
  CBPaperFormat.Items.add('B10 (32 x 45 mm)');
  CBPaperFormat.Items.add('B2 (515 x 728 mm)');
  CBPaperFormat.Items.add('B3 (364 x 515 mm)');
  CBPaperFormat.Items.add('B4 (257 x 364 mm)');
  CBPaperFormat.Items.add('B6 (128 x 182 mm)');
  CBPaperFormat.Items.add('B7 (91 x 128 mm)');
  CBPaperFormat.Items.add('B8 (64 x 91 mm)');
  CBPaperFormat.Items.add('B9 (45 x 64 mm)');
  CBPaperFormat.Items.add('C5E (163 x 229 mm)');
  CBPaperFormat.Items.add('US Common #10 Envelope (105 x 241 mm)');
  CBPaperFormat.Items.add('DLE (110 x 220 mm)');
  CBPaperFormat.Items.add('Folio (210 x 330 mm)');
  CBPaperFormat.Items.add('Ledger (432 x 279 mm)');
  CBPaperFormat.Items.add('Tabloid (279 x 432 mm)');
  CBPaperFormat.Items.EndUpdate;
  CBPaperFormat.ItemIndex := Ord(Printer.PrintAdapter.PageSize);
  if (Printer.PrintAdapter as TQPrintAdapter).ColorMode = QPrinterColorMode_GrayScale then
    RBGrayScale.Checked := true else RBColor.Checked := true;
  if (Printer.Orientation = poPortrait) then RBPortrait.Checked := true else RBLandscape.Checked := true;
  if (Printer.PrintAdapter as TQPrintAdapter).PageOrder = QPrinterPageOrder_FirstPageFirst then
    RBSortFirst.Checked := true else RBSortLast.Checked := true;
  SELeft.Min := Printer.Margins.cx;
  SELeft.Value := SELeft.Min + 6;
  SERight.Min := Printer.Margins.cx;
  SERight.Value := SERight.Min + 6;
  SETop.Min := Printer.Margins.cy;
  SETop.Value := SETop.Min + 6;
  SEBottom.Min := Printer.Margins.cy;
  SEBottom.Value := SEBottom.Min + 12;
  GBMargins.Caption := 'Margins (px)';
//   GBMargins.Caption:='Margins (@'+inttostr(Printer.XDPI)+'dpi)';

  if cpoPages in fCustomPrintOptions then
  begin
    RBPages.Enabled := true;
  end;
  if cpoSelection in fCustomPrintOptions then
  begin
    RBSelection.Enabled := true;
  end;
  if cpoCopies in fCustomPrintOptions then
  begin
    SECopies.Enabled := true;
  end;
  if cpoMargins in fCustomPrintOptions then
  begin
    GBMargins.Enabled := true;
  end;
  ReadFromRegistry;
end;

procedure TPrintForm.WriteToRegistry;
var Reg: TRegistry;
  mrgns: TRect;
begin
  Reg := TRegistry.create;
  if Reg.OpenKey('Software/XPde/PrintSettings', true) then
  begin
    Reg.Writestring('PrinterName', LVType.Caption);
    Reg.WriteInteger('PageSize', CBPaperFormat.ItemIndex);
    Reg.Writebool('OrientationPortrait', RBPortrait.Checked);
    Reg.Writebool('ColorGrayScale', RBGrayScale.Checked);
    Reg.Writebool('SortOrderFirst', RBSortFirst.Checked);
    Mrgns := GetMargins;
    Reg.Writebinarydata('Margins', Mrgns, SizeOf(TRect));
  end;
  Reg.free;
end;

procedure TPrintForm.ReadFromRegistry;
var Reg: TRegistry;
  mrgns: TRect;
begin
  Reg := TRegistry.create;
  if Reg.OpenKey('Software/XPde/PrintSettings', false) then
  begin
    Reg.Readbinarydata('Margins', mrgns, SizeOf(TRect));
    SELeft.Value := mrgns.Left;
    SERight.Value := mrgns.Right;
    SETop.Value := mrgns.Top;
    SEBottom.Value := mrgns.Bottom;

    LVType.Caption := Reg.Readstring('PrinterName');
    if Printer.Printers.IndexOf(LVType.Caption) > -1 then
      IconView1.Items[Printer.Printers.IndexOf(LVType.Caption)].Selected := true;
    CBPaperFormat.ItemIndex := Reg.Readinteger('PageSize');
    if Reg.Readbool('OrientationPortrait') then RBPortrait.Checked := true else RBLandscape.checked := true;
    if Reg.Readbool('ColorGrayScale') then RBGrayScale.Checked := true else RBColor.checked := true;
    if Reg.Readbool('SortOrderFirst') then RBSortFirst.Checked := true else RBSortLast.Checked := true;
  end;
  Reg.free;
end;

procedure TPrintForm.ShowFromTo;
begin
  LNFrom.Enabled := true;
  LNTo.Enabled := true;
  LVFrom.Enabled := true;
  LVTo.Enabled := true;
end;

procedure TPrintForm.HideFromTo;
begin
  LNFrom.Enabled := false;
  LNTo.Enabled := false;
  LVFrom.Enabled := false;
  LVTo.Enabled := false;
end;

procedure TPrintForm.FormShow(Sender: TObject);
begin
  InitDialogs;
end;

function TPrintForm.Execute: boolean;
begin
  result := (ShowModal = mrOK);
  WriteToRegistry;
end;

procedure TPrintForm.SetPrinter;
begin
  if self.CBPrintToFile.Checked then
  begin
    if SaveDialog1.Execute then
      Printer.SetOutputFileName(SaveDialog1.Filename);
  end else
    Printer.SetPrinter(LVType.Caption);
  Printer.PrintAdapter.PageSize := TPageSize(CBPaperFormat.ItemIndex);
  if RBPortrait.Checked then Printer.Orientation := poPortrait else
    Printer.Orientation := poLandscape;
  if RBGrayScale.Checked then
    (Printer.PrintAdapter as TQPrintAdapter).ColorMode := QPrinterColorMode_GrayScale else
    (Printer.PrintAdapter as TQPrintAdapter).ColorMode := QPrinterColorMode_Color;
  if RBSortFirst.Checked then
    (Printer.PrintAdapter as TQPrintAdapter).PageOrder := QPrinterPageOrder_FirstPageFirst else
    (Printer.PrintAdapter as TQPrintAdapter).PageOrder := QPrinterPageOrder_LastPageFirst;

end;

procedure TPrintForm.RBLandscapeClick(Sender: TObject);
begin
  ImPortrait.Visible := false;
  ImLandscape.Visible := true;
end;

procedure TPrintForm.RBPortraitClick(Sender: TObject);
begin
  ImLandscape.Visible := false;
  ImPortrait.Visible := true;
end;

procedure TPrintForm.BtnApplyClick(Sender: TObject);
begin
  SetPrinter;
end;

procedure TPrintForm.IconView1SelectItem(Sender: TObject; Item: TIconViewItem;
  Selected: Boolean);
var index: integer;
begin
  if uPrinterInfo.GetLPCStatus(Item.Caption, LPC_PRINTING) then
    LVStatus.Caption := 'Ready' else LVStatus.Caption := 'Disabled';
  LVType.Caption := Item.Caption;
  index := PRCI.IndexOf(Item.Caption);
  if index > -1 then
  begin
    LVAlias.Caption := TPrinterInfo(PRCI.Objects[index]).Alias;
    LVWhere.Caption := TPrinterInfo(PRCI.Objects[index]).LP;
  end;
end;

procedure TPrintForm.IconView1Editing(Sender: TObject; Item: TIconViewItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := false;
end;

procedure TPrintForm.BtnPrintClick(Sender: TObject);
begin
  SetPrinter;
end;

procedure TPrintForm.LVFromKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not ((Key = Key_Backspace) or (Key = Key_Left) or
    (Key = Key_Right) or (Key = Key_Delete)) then
    if not (Key in [48..57]) then Key := 0;
end;

procedure TPrintForm.LVToKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not ((Key = Key_Backspace) or (Key = Key_Left) or
    (Key = Key_Right) or (Key = Key_Delete)) then
    if not (Key in [48..57]) then Key := 0;
end;

procedure TPrintForm.CBPrintToFileClick(Sender: TObject);
begin
  if CBPrintToFile.Checked then
    IconView1.Selected.Selected := false else
    IconView1.Items[0].Selected := true;
end;

procedure TPrintForm.RBPagesClick(Sender: TObject);
begin
  if (Sender as TRadioButton).Tag = 1 then
    ShowFromTo else HideFromTo;
end;
initialization
finalization
  if Assigned(PrintForm) then FreeAndNil(PrintForm);
end.


