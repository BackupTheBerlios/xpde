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
unit uXPImageList;

interface

uses
    Classes, QGraphics, uXPPNG;

type
    TXPImageState=(isNormal, isSelected, isTransparent);
    TXPImageStates=set of TXPImageState;

    //ImageList class
    TXPImageList=class(TComponent)
    private
        FImages:TList;
        FBackgroundColor: TColor;
        procedure SetBackgroundColor(const Value: TColor);
    public
        function AddImage(const Graphic:TGraphic):integer;                      //Adds a TGraphic to the list and return its position
        function GetImage(const ImageIndex:integer):TGraphic;                   //Gets a TGraphic by its position
        procedure DrawImage(const ACanvas:TCanvas;const x,y:integer;const ImageIndex:integer; state: TXPImageStates);
        constructor Create(AOwner:TComponent);override;
        destructor Destroy;override;
        property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
    end;

implementation

{ TXPImageList }

function TXPImageList.AddImage(const Graphic: TGraphic): integer;
var
    g: TXPPNG;
begin
    //Hold the images on TBitmaps
    { TODO : Bitblt instead of assign }
    g:=TXPPNG.create;
    g.assign(graphic);
    result:=FImages.add(g);
end;

constructor TXPImageList.Create(AOwner: TComponent);
begin
  inherited;
  //Creates the internal list
  FImages:=TList.create;
  FBackgroundColor:=clWindow;
end;

destructor TXPImageList.Destroy;
begin
  //Destroys the imagelist
  { TODO : Destroy the bitmaps stored }
  FImages.free;
  inherited;
end;

procedure TXPImageList.DrawImage(const ACanvas: TCanvas; const x,y:integer;
  const ImageIndex: integer; state: TXPImageStates);
var
    g: TXPPNG;
begin
    if (ImageIndex<FImages.Count) then begin
        { TODO : Draw the image in transparent state (selected or not) }
        g:=TXPPNG(GetImage(ImageIndex));
        g.UseBackground:=true;
        g.Selected:=(isSelected in State);
        g.BackgroundColor:=FBackgroundColor;
        g.paintToCanvas(ACanvas,x,y,0);
    end;
end;

function TXPImageList.GetImage(const ImageIndex: integer): TGraphic;
begin
    //Return the specified image
    result:=FImages[ImageIndex];
end;

procedure TXPImageList.SetBackgroundColor(const Value: TColor);
begin
    FBackgroundColor := Value;
end;

end.
