// Copyright (C) 2013-2017 Damien Dart, <damiendart@pobox.com>.
// This file is distributed under the MIT licence. For more information,
// please refer to the accompanying "LICENCE" file.


package;


import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


class MenuState implements IDrawable implements IGameState
    implements IInteractable implements IUpdatable
{
  private var _display_object:Sprite;
  private var _game_state_manager:IGameStateManager;

  public function draw(alpha:Float):Void
  {
    /* ... */
  }

  public function getDisplayObject():Sprite
  {
    return this._display_object;
  }

  public function new()
  {
    this._display_object = new Sprite();
    this._resetState();
  }

  public function onKeyDown(event:KeyboardEvent):Void
  {
    this._game_state_manager.changeGameState(new PlayState());
  }

  public function registerManager(manager:IGameStateManager):Void
  {
    this._game_state_manager = manager;
  }

  public function update(dt:Int):Void
  {
    /* ... */
  }

  private function _resetState():Void
  {
    var welcome_text:TextField = new TextField();
    welcome_text.autoSize = TextFieldAutoSize.LEFT;
    welcome_text.defaultTextFormat = new TextFormat("Courier", 18, 0xffffff);
    welcome_text.selectable = false;
    welcome_text.text = "Welcome to Bastard Snake (ALPHA).\nPress any key to play.";
    welcome_text.x = 10;
    welcome_text.y = 10;
    this._display_object.addChild(welcome_text);
  }
}
