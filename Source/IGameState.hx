package;

import flash.display.DisplayObject;
import flash.events.KeyboardEvent;

interface IGameState {
  function draw(alpha:Float):Void;
  function onKeyDown(event:KeyboardEvent):Void;
  function update(dt:Int):Void;
}
