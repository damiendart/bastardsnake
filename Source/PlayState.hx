package;

import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.ui.Keyboard;

enum SnakeDirection { UP; RIGHT; DOWN; LEFT; }

class PlayState implements IGameState {
  private var _arena_dimensions:{ height: Int, width: Int };
  private var _display_object:Sprite;
  private var _fruit:{ x: Int, y: Int };
  private var _is_snake_alive:Bool;
  private var _game_state_manager:IGameStateManager;
  private var _snake_accumulated_time:Int;
  private var _snake_direction:SnakeDirection;
  private var _snake_parts:Array<{ x: Int, y: Int }>;

  public function draw(alpha:Float):Void {
    this._display_object.graphics.clear();
    this._display_object.graphics.beginFill(0x0000ff);
    this._display_object.graphics.drawRect(0, 0, 800, 600);
    for (part in this._snake_parts) {
      this._display_object.graphics.beginFill(0xffffff);
      this._display_object.graphics.drawRect(
          part.x * (800 / this._arena_dimensions.width),
          part.y * (600 / this._arena_dimensions.height),
          (800 / this._arena_dimensions.width),
          (600 / this._arena_dimensions.height));
    }
    this._display_object.graphics.beginFill(0xff0000);
    this._display_object.graphics.drawRect(
        this._fruit.x * (800 / this._arena_dimensions.width),
        this._fruit.y * (600 / this._arena_dimensions.height),
        (800 / this._arena_dimensions.width),
        (600 / this._arena_dimensions.height));
  }

  public function getDisplayObject():Sprite {
    return this._display_object;
  }

  public function new() {
    this._display_object = new Sprite();
    this._resetGame();
  }

  public function onKeyDown(event:KeyboardEvent):Void {
    switch (event.keyCode) {
      case Keyboard.UP:
        // Prevent players from going back on themselves.
        if (this._snake_direction != SnakeDirection.DOWN) {
          this._snake_direction = SnakeDirection.UP;
        }
      case Keyboard.RIGHT:
        // Prevent players from going back on themselves.
        if (this._snake_direction != SnakeDirection.LEFT) {
          this._snake_direction = SnakeDirection.RIGHT;
        }
      case Keyboard.DOWN:
        // Prevent players from going back on themselves.
        if (this._snake_direction != SnakeDirection.UP) {
          this._snake_direction = SnakeDirection.DOWN;
        }
      case Keyboard.LEFT:
        // Prevent players from going back on themselves.
        if (this._snake_direction != SnakeDirection.RIGHT) {
          this._snake_direction = SnakeDirection.LEFT;
        }
    }
  }

  public function registerManager(manager:IGameStateManager):Void {
    this._game_state_manager = manager;
  }

  public function update(dt:Int):Void {
    if (this._is_snake_alive == true) {
      var next_move = (this._snake_parts.length < 15) ?
          (100 - this._snake_parts.length * 5) : 20;
      this._snake_accumulated_time += dt;
      while (this._snake_accumulated_time >= next_move) {
        var snake_head = this._snake_parts[this._snake_parts.length - 1];
        this._snake_accumulated_time -= next_move;
        switch (this._snake_direction) {
          case SnakeDirection.UP:
            this._snake_parts.push({ x: snake_head.x, y: snake_head.y - 1 });
          case SnakeDirection.RIGHT:
            this._snake_parts.push({ x: snake_head.x + 1, y: snake_head.y });
          case SnakeDirection.DOWN:
            this._snake_parts.push({ x: snake_head.x, y: snake_head.y + 1 });
          case SnakeDirection.LEFT:
            this._snake_parts.push({ x: snake_head.x - 1, y: snake_head.y });
        }
        snake_head = this._snake_parts[this._snake_parts.length - 1];
        if ((snake_head.x >= this._arena_dimensions.width) ||
            (snake_head.y >= this._arena_dimensions.height) ||
            (snake_head.x < 0) || (snake_head.y < 0)) {
          this._is_snake_alive = false;
          this._snake_parts.pop();
          break;
        }
        for (i in 0...this._snake_parts.length - 2) {
          if ((snake_head.x == this._snake_parts[i].x) &&
              (snake_head.y == this._snake_parts[i].y)) {
            this._is_snake_alive = false;
            break;
          }
        }
        if ((snake_head.x == this._fruit.x) &&
            (snake_head.y == this._fruit.y)) {
          this._placeFruit();
        } else {
          if (this._is_snake_alive == true) {
            this._snake_parts.shift();
          }
        }
      }
    }
  }

  private function _placeFruit():Void {
    this._fruit = { x: Math.floor(Math.random() *
        this._arena_dimensions.width), y: Math.floor(Math.random() *
        this._arena_dimensions.height) };
    for (part in this._snake_parts) {
      if ((this._fruit.x == part.x) && (this._fruit.y == part.y)) {
        this._placeFruit();
      }
    }
  }

  private function _resetGame():Void {
    this._arena_dimensions = { height: 24, width: 32 };
    this._is_snake_alive = true;
    this._snake_direction = SnakeDirection.DOWN;
    this._snake_parts = [{ x: 2, y: 2 }, { x: 2, y: 3 }];
    this._placeFruit();
  }
}