package;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class TestState extends Sprite implements IGameState {
  public function draw(alpha:Float):Void {
    /* ... */
  }

  public function new() {
    super();
    this.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
  }

  public function onKeyDown(event:KeyboardEvent):Void {
    /* ... */
  }

  public function update(dt:Int):Void {
    /* ... */
  }

  private function _onAddedToStage(event:Event):Void {
    var hello_world:TextField = new TextField();
    hello_world.autoSize = TextFieldAutoSize.LEFT;
    hello_world.selectable = false;
    hello_world.text = "Hello, World!";
    this.addChild(hello_world);
  }
}
