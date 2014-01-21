package;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib.getTimer;

class Main extends Sprite {
  private var _accumulated_time:Int;
  private var _current_game_state:IGameState;
  private var _current_time:Int;

  public function new() {
    super();
    this.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
  }

  private function _onAddedToStage(event:Event):Void {
    this._accumulated_time = 0;
    this._current_time = getTimer();
    stage.addEventListener(KeyboardEvent.KEY_DOWN, this._onKeyDown);
    this.addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
    this.addEventListener(ChangeGameStateEvent.CHANGE_GAME_STATE,
        this._onGameStateChange);
    _current_game_state = new TestState();
    this.addChild(cast(_current_game_state, Sprite));
  }

  private function _onGameStateChange(event:ChangeGameStateEvent):Void {
    this.removeChild(cast(this._current_game_state, Sprite));
    this._current_game_state = event.getGameState();
    this.addChild(cast(this._current_game_state, Sprite));
  }

  private function _onEnterFrame(event:Event):Void {
    var new_time:Int = getTimer();
    var dt:Int = new_time - _current_time;
    this._current_time = new_time;
    this._accumulated_time += (dt > 100) ? 100 : dt;
    while (this._accumulated_time >= 10) {
      _current_game_state.update(10);
      this._accumulated_time -= 10;
    }
    _current_game_state.draw(_accumulated_time / 10);
  }

  private function _onKeyDown(event:KeyboardEvent):Void {
    _current_game_state.onKeyDown(event);
  }
}
