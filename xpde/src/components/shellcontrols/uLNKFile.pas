{ *************************************************************************** }
{                                                                             }
{ This file is part of the XPde project                                       }
{                                                                             }
{ Copyright (c) 2002 José León Serna <ttm@xpde.com>                           }
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
unit uLNKFile;

interface

uses Classes, Inifiles;

type
    TLNKFile=class(TComponent)
    private
    FCaption: string;
    FCommand: string;
    FIcon: string;
    FStartin: string;
    FComment: string;
    procedure SetCaption(const Value: string);
    procedure SetCommand(const Value: string);
    procedure SetIcon(const Value: string);
    procedure SetStartin(const Value: string);
    procedure SetComment(const Value: string);
    public
        procedure loadfromfile(const filename:string);
        procedure savetofile(const filename:string);
        constructor Create(AOwner:TComponent);override;
    published
        property Caption:string read FCaption write SetCaption;
        property Icon:string read FIcon write SetIcon;
        property Command: string read FCommand write SetCommand;
        property Startin:string read FStartin write SetStartin;
        property Comment:string read FComment write SetComment;
    end;

implementation

{ TLNKFile }

constructor TLNKFile.Create(AOwner: TComponent);
begin
  inherited;
    FCaption:='';
    FCommand:='';
    FIcon:='';
    FStartin:='';
    FComment:='';
end;

procedure TLNKFile.loadfromfile(const filename: string);
var
    ini:TIniFile;
begin
    ini:=TIniFile.create(filename);
    try
        FCaption:=ini.ReadString('Shortcut','Caption','');
        FIcon:=ini.ReadString('Shortcut','Icon','');
        FCommand:=ini.ReadString('Shortcut','Command','');
        FStartin:=ini.ReadString('Shortcut','Startin','');
        FComment:=ini.ReadString('Shortcut','Comments','');
    finally
        ini.free;
    end;
end;

procedure TLNKFile.savetofile(const filename: string);
var
    ini:TIniFile;
begin
    ini:=TIniFile.create(filename);
    try
        ini.WriteString('Shortcut','Caption',FCaption);
        ini.WriteString('Shortcut','Icon',FIcon);
        ini.WriteString('Shortcut','Command',FCommand);
        ini.WriteString('Shortcut','Startin',FStartin);
        ini.WriteString('Shortcut','Comments',FComment);
        ini.UpdateFile;
    finally
        ini.free;
    end;
end;

procedure TLNKFile.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TLNKFile.SetCommand(const Value: string);
begin
  FCommand := Value;
end;

procedure TLNKFile.SetComment(const Value: string);
begin
  FComment := Value;
end;

procedure TLNKFile.SetIcon(const Value: string);
begin
  FIcon := Value;
end;

procedure TLNKFile.SetStartin(const Value: string);
begin
  FStartin := Value;
end;

end.
