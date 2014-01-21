package;

import flash.events.Event;

class ChangeGameStateEvent extends Event {
  public inline static var CHANGE_GAME_STATE:String = "changeGameState";
  private var _game_state:IGameState;

  public override function clone():Event {
    return new ChangeGameStateEvent(type, _game_state, bubbles, cancelable);
  }

  public function getGameState():IGameState {
    return this._game_state;
  }

  public function new(type:String, game_state:IGameState, bubbles:Bool = true,
      cancelable:Bool = false):Void {
    super(type, bubbles, cancelable);
    this._game_state = game_state;
  }

  public override function toString():String {
    return this.formatToString("ChangeGameStateEvent", "type", "game_state",
        "bubbles", "cancelable", "eventPhase");
  }
}
