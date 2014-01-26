package;

import flash.display.DisplayObject;
import flash.events.KeyboardEvent;

interface IGameState {
  function draw(alpha:Float):Void;
  function getDisplayObject():DisplayObject;
  function onKeyDown(event:KeyboardEvent):Void;
  function registerManager(manager:IGameStateManager):Void;
  function update(dt:Int):Void;
}
