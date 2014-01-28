package;


import flash.display.Sprite;


class BasicGameStateManager implements IGameStateManager
{
  private var _current_game_state:IGameState;
  private var _display_object:Sprite;

  public function changeGameState(game_state:IGameState):Void
  {
    if (this._current_game_state != null) {
      this._display_object.removeChild(
          this._current_game_state.getDisplayObject());
    }
    this._current_game_state = game_state;
    this._current_game_state.registerManager(this);
    this._display_object.addChild(
        this._current_game_state.getDisplayObject());
  }

  public function getCurrentGameState():IGameState
  {
    return this._current_game_state;
  }

  public function getDisplayObject():Sprite
  {
    return this._display_object;
  }

  public function new() {
    this._display_object = new Sprite();
  }
}
