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
unit uResourceAPI;

interface

uses uResources,Classes;

type
    TResourceEditor=class
    private
        FOnDestroy: TNotifyEvent;
        procedure SetOnDestroy(const Value: TNotifyEvent);
    public
       entry: TResourceEntry;
       procedure loadeditor; virtual; abstract;
       procedure savefromeditor; virtual; abstract;
       procedure edit(const anentry:TResourceEntry);virtual;abstract;
       destructor Destroy;override;
       property OnDestroy: TNotifyEvent read FOnDestroy write SetOnDestroy;
    end;

    TResourceEditorClass=class of TResourceEditor;

    IResourceAPI=interface
    ['{BCD34FC3-4F16-D711-857C-0002443C1C5D}']
        procedure registerEditor(const resourcetype:string;const editorclass:TResourceEditorClass);
        function callEditor(const entry:TResourceEntry): TResourceEditor;

    end;

var
    ResourceAPI: IResourceAPI=nil;

implementation

{ TResourceEditor }

destructor TResourceEditor.Destroy;
begin
  if assigned(FOnDestroy) then FOnDestroy(self);
  inherited;
end;

procedure TResourceEditor.SetOnDestroy(const Value: TNotifyEvent);
begin
    FOnDestroy := Value;
end;

end.
