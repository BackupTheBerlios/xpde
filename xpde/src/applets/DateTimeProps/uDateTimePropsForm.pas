{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 Jens Kühner (jens@xpde.com)                              }
{                                                                             }
{ This software is provided "as-is".  This software comes without warranty    }
{ or garantee, explicit or implied.  Use this software at your own risk.      }
{ The author will not be liable for any damage to equipment, data, or         }
{ information that may result while using this software.                      }
{                                                                             }
{ By using this software, you agree to the conditions stated above.           }
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

unit uDateTimePropsForm;

interface

uses
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls, QGrids, QComCtrls, QMask, QExtCtrls, uQXPComCtrls;

type
  TDateTimePropsFm = class(TForm)
    PageControl1: TPageControl;
    sheetDateTime: TTabSheet;
    grpDate: TGroupBox;
    grpTime: TGroupBox;
    btnOK: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    comboMonth: TComboBox;
    spinYear: TSpinEdit;
    gridDate: TStringGrid;
    efTime: TMaskEdit;
    pbClock: TPaintBox;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure efTimeChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure comboMonthChange(Sender: TObject);
    procedure spinYearChanged(Sender: TObject; NewValue: Integer);
    procedure gridDateSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure pbClockPaint(Sender: TObject);
  private
    { Private-Deklarationen }
    m_bInitList : boolean;
    m_iDay, m_iHour, m_iMin, m_iSec : integer;
    m_bEditChangedLocked : boolean;
    procedure FillList;
    procedure DrawPointer( alpha : single; iXMid, iYMid, iLength, iWidth : integer);
  public
    { Public-Deklarationen }
  end;

var
  DateTimePropsFm: TDateTimePropsFm;

implementation

{$R *.xfm}

uses
  SysConst, DateUtils, Math, LibC;

const
  WeekDayChars : array[0..6] of string = ('M', 'T', 'W', 'T', 'F', 'S', 'S');

procedure TDateTimePropsFm.FormShow(Sender: TObject);
var
  i : integer;
begin
  m_bEditChangedLocked := true;

  for i := 0 to high(WeekdayChars) do
     gridDate.Rows[0][i] := '  '+WeekdayChars[i];
  Timer1Timer(nil);
  comboMonth.Items.add(SLongMonthNameJan);
  comboMonth.Items.add(SLongMonthNameFeb);
  comboMonth.Items.add(SLongMonthNameMar);
  comboMonth.Items.add(SLongMonthNameApr);
  comboMonth.Items.add(SLongMonthNameMay);
  comboMonth.Items.add(SLongMonthNameJun);
  comboMonth.Items.add(SLongMonthNameJul);
  comboMonth.Items.add(SLongMonthNameAug);
  comboMonth.Items.add(SLongMonthNameSep);
  comboMonth.Items.add(SLongMonthNameOct);
  comboMonth.Items.add(SLongMonthNameNov);
  comboMonth.Items.add(SLongMonthNameDec);
  comboMonth.ItemIndex := monthof(now)-1;
  spinYear.Value       := yearof(now);
  gridDate.DefaultColWidth  := gridDate.Width  div 7;
  gridDate.DefaultRowHeight := gridDate.Height div 7;
  m_bInitList := true;
  m_iDay  := dayOf(now);
  m_iHour := hourof(now);
  m_iMin  := minuteof(now);
  m_iSec  := secondof(now);

  efTime.Modified := false;
  Timer1Timer(nil);

  fillList;
end;

procedure TDateTimePropsFm.FillList;
var
  iYear, iMonth : integer;
  iStart : integer;
  i : integer;
  iCol, iRow : integer;
begin
  if not m_bInitList then exit;
  iYear  := spinYear.Value;
  iMonth := comboMonth.itemindex+1;
  iStart := dayOfTheWeek(StartOfTheMonth(encodedate(iYear, iMonth, 1)))-1;
  //clear
  for i := 0 to 7*6-1 do begin
     iCol := i mod 7;
     iRow := i div 7;
     gridDate.Cells[iCol,iRow+1] := '';
  end;
  //fill
  for i := 0 to MonthDays[IsLeapYear(iYear),iMonth]-1 do begin
     iCol := (i + iStart) mod 7;
     iRow := (i + iStart) div 7;
     gridDate.Cells[iCol,iRow+1] := format(' %2d', [i+1]);
  end;
  m_iDay := ensureRange(m_iDay, 1, MonthDays[IsLeapYear(iYear),iMonth]);
  griddate.Row := (m_iDay-1 + iStart) div 7 + 1;
  griddate.col := (m_iDay-1 + iStart) mod 7;
end;

procedure TDateTimePropsFm.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TDateTimePropsFm.btnOKClick(Sender: TObject);
begin
  btnApplyClick(nil);
  close;
end;

procedure TDateTimePropsFm.btnApplyClick(Sender: TObject);
var
  ut : TUnixTime;
  tt : Time_t;
  fd : TFiledescriptor;
const
  RTC_SET_TIME = $4024700A;
begin
  fillchar(ut, sizeof(ut), 0);
  ut.tm_mday := m_iDay;
  ut.tm_mon  := comboMonth.itemindex;
  ut.tm_year := spinYear.Value - 1900;

  ut.tm_hour := m_iHour;
  ut.tm_min  := m_iMin;
  ut.tm_sec  := m_iSec;

  tt := mktime(ut);
  if stime( @tt ) <> 0 then
     raise Exception.Create('Cannot set time!');

  fd := open('/dev/rtc', O_RDWR);
  if fd <= 0 then
     raise Exception.Create('Cannot open /dev/rtc!');
  try
   if ioctl(fd, RTC_SET_TIME, @ut)<> 0 then
      raise Exception.Create('Cannot access /dev/rtc!');
  finally
   __close(fd);
  end;
end;

procedure TDateTimePropsFm.efTimeChange(Sender: TObject);
var
  iHour, iMin, iSec : integer;
  strHour, strMin, strSec : string;
begin
  if m_bEditChangedLocked then exit;
{  str   := efTime.text;
  str2 := trim(copy(str, 1, pos(':', str)-1));
  if str = '' then exit;
  iHour := strToInt(str2);
  str   := copy( str, pos(':', str)+1, length(str) );
  if str = '' then exit;
  iMin  := strToInt(trim(copy(str, 1, pos(':', str)-1)));
  str   := copy( str, pos(':', str)+1, length(str) );
  if str = '' then exit;
  iSec  := strToInt(trim(str));}
  strHour := trim(copy(efTime.Text, 1,2));
  strMin  := trim(copy(efTime.Text, 4,2));
  strSec  := trim(copy(efTime.Text, 7,2));
  iHour := 0;
  iMin  := 0;
  iSec  := 0;
  if (strHour<>'') then
    iHour := strtoint(strHour);
  if (strMin<>'') then
    iMin  := strtoint(strMin);
  if (strSec<>'') then
    iSec  := strtoint(strSec);
  if IsvalidTime(iHour, iMin, iSec, 0) then begin
      m_iHour := iHour;
      m_iMin  := iMin;
      m_iSec  := iSec;
      efTime.Text := format('%2d:%2d:%2d', [m_iHour, m_iMin, m_iSec]);;
      pbClock.Repaint;
  end;
end;

procedure TDateTimePropsFm.Timer1Timer(Sender: TObject);
var
  iSelStart, iSelLength : integer;
begin
  if efTime.Modified then exit;

  m_bEditChangedLocked := true;

  iSelStart  := efTime.SelStart;
  iSelLength := efTime.SelLength;
  inc(m_iSec);
  if m_iSec = 60 then inc(m_iMin);
  if m_iMin = 60 then inc(m_iHour);
  m_iSec  := m_iSec mod 60;
  m_iMin  := m_iMin mod 60;
  m_iHour := m_iHour mod 24;

  efTime.Text      := format('%2d:%2d:%2d', [m_iHour, m_iMin, m_iSec]);;
  efTime.SelStart  := iSelStart;
  efTime.SelLength := iSelLength;
  pbClock.Repaint;

  m_bEditChangedLocked := false;

  efTime.Modified := false;
end;

procedure TDateTimePropsFm.comboMonthChange(Sender: TObject);
begin
   FillList;
end;

procedure TDateTimePropsFm.spinYearChanged(Sender: TObject;
  NewValue: Integer);
begin
  FillList;
end;

procedure TDateTimePropsFm.gridDateSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    CanSelect := gridDate.Cells[ACol, ARow] <> '';
    if CanSelect then
        m_iDay := strToint( trim(gridDate.Cells[ACol, ARow]) );
end;

procedure GetVectors(alpha : single; out vxTop, vyTop, vxLeft, vyLeft, vxRight, vyRight, vxBack, vyBack : single );
begin
  vxTop    :=  cos(alpha);
  vyTop    := -sin(alpha);
  vxLeft   :=  cos(alpha-pi/2);
  vyLeft   := -sin(alpha-pi/2);
  vxRight  :=  cos(alpha+pi/2);
  vyRight  := -sin(alpha+pi/2);
  vxBack   :=  cos(alpha+pi);
  vyBack   := -sin(alpha+pi);
end;

procedure TDateTimePropsFm.DrawPointer( alpha : single; iXMid, iYMid, iLength, iWidth : integer);
var
 vxTop, vyTop, vxLeft, vyLeft, vxRight, vyRight, vxBack, vyBack : single;
begin
 GetVectors(alpha, vxTop, vyTop, vxLeft, vyLeft, vxRight, vyRight, vxBack, vyBack);
 pbClock.Canvas.polygon([
                         Point(round(iXMid+vxTop*iLength), round(iYMid+vyTop*iLength)),
                         Point(round(iXMid+vxLeft*iWidth), round(iYMid+vyLeft*iWidth)),
                         Point(round(iXMid+vxBack*iWidth*2), round(iYMid+vyBack*iWidth*2)),
                         point(round(iXMid+vxRight*iWidth), round(iYMid+vyRight*iWidth))
                        ]);
end;

procedure TDateTimePropsFm.pbClockPaint(Sender: TObject);
var
 iXMid, iYMid : integer;
 iRadius : integer;
 alpha : single;
 ix, iy : integer;
 i, iOfs : integer;
begin
 pbClock.Canvas.brush.Color := clTeal;
 iXMid := pbClock.clientWidth div 2;
 iYMid := pbClock.clientHeight div 2;
 iRadius := min(iXMid, iYMid) - 3;
 for i := 0 to 59 do begin
    alpha := i/60 * 2 * pi;
    iX := round(iXMid+cos(alpha)*iRadius);
    iY := round(iYMid-sin(alpha)*iRadius);
    pbClock.Canvas.pixels[iX, iY] := clGray;
    if i mod 5 = 0 then begin
      pbClock.Canvas.FillRect( rect(iX-1, iY-1, iX+2, iY+2) );
    end;
 end;

 for i := 0 to 1 do begin
 if i = 0 then begin
  pbClock.Canvas.pen.Color   := clGray;
  iOfs := 1;
 end else begin
  pbClock.Canvas.pen.Color   := clTeal;
  iOfs := 0;
 end;
 pbClock.Canvas.brush.Color := pbClock.Canvas.pen.Color;

 //hour
 alpha := - ((m_iHour mod 12) / 12 * 2 * pi - pi / 2);
 DrawPointer( alpha, iXMid+iOfs*2, iYMid+iOfs*2, iRadius-28, 4);

 //min
 alpha := - (m_iMin / 60 * 2 * pi - pi / 2);
 DrawPointer( alpha, iXMid+iOfs*3, iYMid+iOfs*3, iRadius-12, 2);

 if i = 0 then begin
  pbClock.Canvas.pen.Color   := clGray;
 end else begin
  pbClock.Canvas.pen.Color   := clBlack;
 end;
 pbClock.Canvas.brush.Color := pbClock.Canvas.pen.Color;
 //sec
 alpha := - (m_iSec / 60 * 2 * pi - pi / 2);
 DrawPointer( alpha, iXMid+iOfs*4, iYMid+iOfs*4, iRadius-8, 0);
 end;
end;

end.
