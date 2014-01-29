package;


import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.ui.Keyboard;


enum SnakeDirection { UP; RIGHT; DOWN; LEFT; }

typedef Grid = { height: Int, width: Int };
typedef Cell = { x:Int, y:Int };
typedef Snake = { accumulated_time:Int, is_alive:Bool,
    direction:SnakeDirection, parts:Array<Cell> };


class PlayState implements IDrawable implements IGameState
    implements IInteractable implements IUpdatable
{
  private var _arena_dimensions:Grid;
  private var _display_object:Sprite;
  private var _fruit:Cell;
  private var _parent:IGameStateManager;
  private var _snake:Snake;

  public function draw(alpha:Float):Void
  {
    this._display_object.graphics.clear();
    this._display_object.graphics.beginFill(0x0000ff);
    this._display_object.graphics.drawRect(0, 0, 800, 600);
    for (part in this._snake.parts) {
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

  public function getDisplayObject():Sprite
  {
    return this._display_object;
  }

  public function new()
  {
    this._display_object = new Sprite();
    this._resetGame();
  }

  public function onKeyDown(event:KeyboardEvent):Void
  {
    switch (event.keyCode) {
      case Keyboard.UP:
        // Prevent players from going back on themselves.
        if (this._snake.direction != SnakeDirection.DOWN) {
          this._snake.direction = SnakeDirection.UP;
        }
      case Keyboard.RIGHT:
        // Prevent players from going back on themselves.
        if (this._snake.direction != SnakeDirection.LEFT) {
          this._snake.direction = SnakeDirection.RIGHT;
        }
      case Keyboard.DOWN:
        // Prevent players from going back on themselves.
        if (this._snake.direction != SnakeDirection.UP) {
          this._snake.direction = SnakeDirection.DOWN;
        }
      case Keyboard.LEFT:
        // Prevent players from going back on themselves.
        if (this._snake.direction != SnakeDirection.RIGHT) {
          this._snake.direction = SnakeDirection.LEFT;
        }
    }
  }

  public function registerManager(manager:IGameStateManager):Void
  {
    this._parent = manager;
  }

  public function update(dt:Int):Void
  {
    if (this._snake.is_alive == true) {
      var next_move = (this._snake.parts.length < 15) ?
          (100 - this._snake.parts.length * 5) : 20;
      this._snake.accumulated_time += dt;
      while (this._snake.accumulated_time >= next_move) {
        var snake_head = this._snake.parts[this._snake.parts.length - 1];
        this._snake.accumulated_time -= next_move;
        switch (this._snake.direction) {
          case SnakeDirection.UP:
            this._snake.parts.push({ x: snake_head.x, y: snake_head.y - 1 });
          case SnakeDirection.RIGHT:
            this._snake.parts.push({ x: snake_head.x + 1, y: snake_head.y });
          case SnakeDirection.DOWN:
            this._snake.parts.push({ x: snake_head.x, y: snake_head.y + 1 });
          case SnakeDirection.LEFT:
            this._snake.parts.push({ x: snake_head.x - 1, y: snake_head.y });
        }
        snake_head = this._snake.parts[this._snake.parts.length - 1];
        if ((snake_head.x >= this._arena_dimensions.width) ||
            (snake_head.y >= this._arena_dimensions.height) ||
            (snake_head.x < 0) || (snake_head.y < 0)) {
          this._snake.is_alive = false;
          this._snake.parts.pop();
          break;
        }
        for (i in 0...this._snake.parts.length - 2) {
          if ((snake_head.x == this._snake.parts[i].x) &&
              (snake_head.y == this._snake.parts[i].y)) {
            this._snake.is_alive = false;
            break;
          }
        }
        if ((snake_head.x == this._fruit.x) &&
            (snake_head.y == this._fruit.y)) {
          this._placeFruit();
        } else {
          if (this._snake.is_alive == true) {
            this._snake.parts.shift();
          }
        }
      }
    }
  }

  private function _placeFruit():Void
  {
    this._fruit = { x: Math.floor(Math.random() *
        this._arena_dimensions.width), y: Math.floor(Math.random() *
        this._arena_dimensions.height) };
    for (part in this._snake.parts) {
      if ((this._fruit.x == part.x) && (this._fruit.y == part.y)) {
        this._placeFruit();
      }
    }
  }

  private function _resetGame():Void
  {
    this._arena_dimensions = { height: 24, width: 32 };
    this._snake = { accumulated_time: 0, is_alive: true,
        direction: SnakeDirection.DOWN,
        parts: [{ x: 2, y: 2 }, { x: 2, y: 3 }] };
    this._placeFruit();
  }
}
