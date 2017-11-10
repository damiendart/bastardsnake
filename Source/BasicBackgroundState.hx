// Copyright (C) 2013-2017 Damien Dart, <damiendart@pobox.com>.
// This file is distributed under the MIT licence. For more information,
// please refer to the accompanying "LICENCE" file.


package;


import flash.display.Sprite;


class BasicBackgroundState implements IDrawable implements IGameState
{
  private var _background_colour:Int;
  private var _display_object:Sprite;
  private var _parent:IGameStateManager;

  public function draw(alpha:Float):Void
  {
    this._display_object.graphics.clear();
    this._display_object.graphics.beginFill(this._background_colour);
    this._display_object.graphics.drawRect(0, 0, 800, 600);
  }

  public function getDisplayObject():Sprite
  {
    return this._display_object;
  }

  public function new(background_colour:Int):Void
  {
    this._background_colour = background_colour;
    this._display_object = new Sprite();
  }

  public function registerManager(manager:IGameStateManager):Void
  {
    this._parent = manager;
  }
}
