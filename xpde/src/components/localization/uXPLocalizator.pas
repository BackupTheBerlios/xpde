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
unit uXPLocalizator;

interface

uses
  SysUtils, QForms, Types, uXPDictionary, 
  Classes, QControls,QDialogs, TypInfo;


type
    TPropertyFilterFunction=procedure(acomponent:TComponent;prop: PPropInfo) of object;

    TXPLocalizator=class(TComponent)
    private
        excluded:TStringList;
        FDictionary: TXPDictionary;
        FActive: boolean;
        procedure SetDictionary(const Value: TXPDictionary);
        procedure SetActive(const Value: boolean);
        procedure TranslateFilter(acomponent:TComponent;prop: PPropInfo);
        procedure EnumerateFilter(acomponent:TComponent;prop: PPropInfo);
    public
        strings:TStringList;
        hints: TStringList;    
        procedure TranslateForm;
        procedure EnumerateForm;
        procedure EnumerateProperties(AComponent:TComponent;filter:TPropertyFilterFunction);

        function Translate(const str:string):string;
        procedure Loaded;override;
        procedure Notification(AComponent:TComponent;operation:TOperation);override;
        constructor Create(AOwner:TComponent);override;
        destructor Destroy;override;
    published
        property Dictionary:TXPDictionary read FDictionary write SetDictionary;
        property Active:boolean read FActive write SetActive;
    end;

implementation

constructor TXPLocalizator.Create(AOwner: TComponent);
begin
  inherited;
  FActive:=false;
  FDictionary:=nil;
  excluded:=TStringList.create;
  excluded.add('Name');
  strings:=TStringList.create;
  hints:=TStringList.create;
end;

destructor TXPLocalizator.Destroy;
begin
  strings.free;
  hints.free;  
  excluded.free;
  inherited;
end;

procedure TXPLocalizator.EnumerateFilter(acomponent: TComponent;
  prop: PPropInfo);
var
    propname:string;
    propvalue:string;
    obj: TObject;
    k:integer;
    function GetNamePath(comp:TComponent):string;
    begin
        result:=comp.name;
        while comp.owner<>nil do begin
            if comp.owner is TApplication then break;
            result:=comp.owner.Name+'.'+result;
            comp:=comp.owner;
        end;
    end;
    procedure AddProperty(aname,avalue:string);
    var
        proppath:string;
    begin
        if (trim(avalue)<>'') then begin
            strings.add(avalue);
            proppath:=GetNamePath(AComponent)+'.'+aname;
            hints.add(proppath);
        end;
    end;    
begin
    propname:=prop^.Name;
    propvalue:='';
    if excluded.IndexOf(propname)=-1 then begin
        case prop^.PropType^.Kind of
            tkClass: begin
                obj:=GetObjectProp(AComponent,prop,TStrings);
                if (assigned(obj)) then begin
                    if obj is TStrings then begin
                        for k:=0 to (obj as TStrings).Count-1 do begin
                            propvalue:=(obj as TStrings)[k];
                            addproperty(propname+'['+inttostr(k)+']',propvalue);
                        end;
                    end;
                end;
            end
            else begin
                propvalue:=GetStrProp(AComponent,prop);
                addproperty(propname,propvalue);
            end;
        end;
    end;
end;

procedure TXPLocalizator.EnumerateForm;
begin
    if assigned(FDictionary) then begin
        EnumerateProperties(owner,enumeratefilter);
    end;
end;

procedure TXPLocalizator.EnumerateProperties(AComponent: TComponent; filter: TPropertyFilterFunction);
var
    info: PTypeInfo;
    data: PTypeData;
    proplist: PPropList;
    i, count:integer;
    function GetNamePath(comp:TComponent):string;
    begin
        result:=comp.name;
        while comp.owner<>nil do begin
            if comp.owner is TApplication then break;
            result:=comp.owner.Name+'.'+result;
            comp:=comp.owner;
        end;
    end;
    procedure AddProperty(aname,avalue:string);
    var
        proppath:string;
    begin
        if (trim(avalue)<>'') then begin
            strings.add(avalue);
            proppath:=GetNamePath(AComponent)+'.'+aname;
            hints.add(proppath);
        end;
    end;
begin
    info:=AComponent.ClassInfo;
    data:=GetTypeData(Info);
    GetMem(PropList, Data^.PropCount* SizeOf(PPropInfo));
    try
        count:=GetPropList(info,[tkClass,tkChar, tkString, tkWChar, tkLString, tkWString],PropList);
        for i:=0 to count-1 do begin
            filter(acomponent,proplist[i]);
        end;
    finally
        FreeMem(PropList, Data^.PropCount*SizeOf(PPropInfo));
    end;
    for i:=0 to AComponent.ComponentCount-1 do begin
        EnumerateProperties(AComponent.components[i],filter);
    end;
end;

procedure TXPLocalizator.Loaded;
begin
  inherited;
  if not (csDesigning in componentstate) then begin
      if (FActive) then begin
          TranslateForm;
      end;
  end;
end;

procedure TXPLocalizator.Notification(AComponent: TComponent;
  operation: TOperation);
begin
  inherited;
  if (Operation=opRemove) then begin
    if AComponent=FDictionary then FDictionary:=nil;
  end;
end;

procedure TXPLocalizator.SetActive(const Value: boolean);
begin
    if FActive<>Value then begin
          FActive := Value;
    end;
end;

procedure TXPLocalizator.SetDictionary(const Value: TXPDictionary);
begin
    if FDictionary<>Value then begin
        FDictionary := Value;
    end;
end;

function TXPLocalizator.Translate(const str: string): string;
begin
    if assigned(FDictionary) then result:=FDictionary.Translate(str)
    else result:=str;
end;

procedure TXPLocalizator.TranslateFilter(acomponent: TComponent;
  prop: PPropInfo);
var
    obj: TObject;
    k:integer;
begin
    if excluded.IndexOf(prop^.Name)=-1 then begin
        case prop^.PropType^.Kind of
            tkClass: begin
                obj:=GetObjectProp(AComponent,prop,TStrings);
                if (assigned(obj)) then begin
                    if obj is TStrings then begin
                        for k:=(obj as TStrings).Count-1 downto 0 do begin
                            (obj as TStrings)[k]:=FDictionary.Translate((obj as TStrings)[k]);
                        end;
                    end;
                end;
            end
            else begin
                SetStrProp(Acomponent,prop,FDictionary.Translate(GetStrProp(AComponent,prop)));
            end;
        end;
    end;
end;

procedure TXPLocalizator.TranslateForm;
begin
    if assigned(FDictionary) then begin
        EnumerateProperties(owner,translatefilter);
    end;
end;

end.
