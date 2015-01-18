package;


import flash.display.Sprite;
import flash.events.KeyboardEvent;


class BasicGameStateManager implements IDrawable implements IGameStateManager
    implements IInteractable implements IUpdatable
{
  private var _current_game_state:IGameState;
  private var _display_object:Sprite;

  public function changeGameState(game_state:IGameState):Void
  {
    if (this._current_game_state != null &&
        Std.is(this._current_game_state, IDrawable)) {
      this._display_object.removeChild(
          cast(this._current_game_state, IDrawable).getDisplayObject());
    }
    this._current_game_state = game_state;
    this._current_game_state.registerManager(this);
    this._display_object.addChild(
        cast(this._current_game_state, IDrawable).getDisplayObject());
  }

  public function draw(alpha:Float):Void
  {
    if (Std.is(this._current_game_state, IDrawable)) {
      cast(this._current_game_state, IDrawable).draw(alpha);
    }
  }

  public function getCurrentGameState():IGameState
  {
    return this._current_game_state;
  }

  public function getDisplayObject():Sprite
  {
    return this._display_object;
  }

  public function new()
  {
    this._display_object = new Sprite();
  }

  public function onKeyDown(event:KeyboardEvent):Void
  {
    if (Std.is(this._current_game_state, IInteractable)) {
      cast(this._current_game_state, IInteractable).onKeyDown(event);
    }
  }

  public function update(dt:Int):Void
  {
    if (Std.is(this._current_game_state, IUpdatable)) {
      cast(this._current_game_state, IUpdatable).update(dt);
    }
  }
}
