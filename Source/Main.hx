package;


import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib.getTimer;


class Main extends Sprite
{
  private var _accumulated_time:Int;
  private var _game_state_manager:BasicGameStateManager;
  private var _current_time:Int;

  public function new()
  {
    super();
    this._accumulated_time = 0;
    this._game_state_manager = new BasicGameStateManager();
    this._current_time = getTimer();
    this.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
  }

  // In Flash, "DisplayObject"s use the "Event.ADDED_TO_STAGE" event to
  // ensure that the Stage object is accessible before using it.
  private function _onAddedToStage(event:Event):Void
  {
    // HACK: In ActionScript/Flash, the stage can be centered by setting
    // the "Stage.align" property to an empty string.
    #if flash
      untyped this.stage.align = "";
    #end
    this.addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
    this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this._onKeyDown);
    this._game_state_manager.changeGameState(new MenuState());
    this.addChild(this._game_state_manager.getDisplayObject());
  }

  private function _onEnterFrame(event:Event):Void
  {
    var new_time:Int = getTimer();
    var dt:Int = new_time - _current_time;
    this._current_time = new_time;
    // Clamp "dt" to prevent the spiral of death that may occur if
    // updating start taking too long. For more information, see
    // <http://gafferongames.com/game-physics/fix-your-timestep/>.
    this._accumulated_time += (dt > 100) ? 100 : dt;
    while (this._accumulated_time >= 10) {
      this._game_state_manager.update(10);
      this._accumulated_time -= 10;
    }
    this._game_state_manager.draw(_accumulated_time / 10);
  }

  private function _onKeyDown(event:KeyboardEvent):Void
  {
    this._game_state_manager.onKeyDown(event);
  }
}
