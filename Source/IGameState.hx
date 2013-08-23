package;

import flash.events.KeyboardEvent;

interface IGameState {
  function onKeyDown(event:KeyboardEvent):Void;
  function update(dt:Int):Void;
  function draw(alpha:Float):Void;
}
