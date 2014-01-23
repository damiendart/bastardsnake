package;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class MenuState extends Sprite implements IGameState {
  public function draw(alpha:Float):Void {
    /* ... */
  }

  public function new() {
    super();
    this.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
  }

  public function onKeyDown(event:KeyboardEvent):Void {
    this.dispatchEvent(new ChangeGameStateEvent(
        ChangeGameStateEvent.CHANGE_GAME_STATE, new PlayState()));
  }

  public function update(dt:Int):Void {
    /* ... */
  }

  private function _onAddedToStage(event:Event):Void {
    var welcome_text:TextField = new TextField();
    welcome_text.autoSize = TextFieldAutoSize.LEFT;
    welcome_text.defaultTextFormat = new TextFormat("Courier", 18, 0xffffff);
    welcome_text.selectable = false;
    welcome_text.text = "Welcome to Bastard Snake.\nPress any key to play.";
    welcome_text.x = 10;
    welcome_text.y = 10;
    this.addChild(welcome_text);
  }
}
