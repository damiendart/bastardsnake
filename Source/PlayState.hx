package;


import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.ui.Keyboard;


enum SnakeDirection { UP; RIGHT; DOWN; LEFT; }

typedef Grid = { height: Int, width: Int };
typedef Cell = { x:Int, y:Int };


class PlayState implements IDrawable implements IGameState
    implements IInteractable implements IUpdatable
{
  private var _arena:{ height: Int, width: Int };
  private var _background_manager:BasicGameStateManager;
  private var _fruit:Cell;
  private var _game_display_object:Sprite;
  private var _hud_text:TextField;
  private var _main_display_object:Sprite;
  private var _parent:IGameStateManager;
  private var _snake:{ accumulated_time:Int, is_alive:Bool,
    direction:SnakeDirection, parts:Array<Cell>, reversed_controls:Bool };

  public function draw(alpha:Float):Void
  {
    this._background_manager.draw(alpha);
    this._game_display_object.graphics.clear();
    for (part in this._snake.parts) {
      this._drawCell(part, this._snake.is_alive ? 0xffffff : 0xff0000);
    }
    this._drawCell(this._fruit, 0xffffff);
  }

  public function getDisplayObject():Sprite
  {
    return this._main_display_object;
  }

  public function new()
  {
    this._background_manager = new BasicGameStateManager();
    this._game_display_object = new Sprite();
    this._main_display_object = new Sprite();
    this._resetGame();
  }

  public function onKeyDown(event:KeyboardEvent):Void
  {
    this._background_manager.onKeyDown(event);
    switch (event.keyCode) {
      case Keyboard.UP:
        if (this._snake.reversed_controls) {
          // Prevent players from going back on themselves.
          if (this._snake.direction != SnakeDirection.UP) {
            this._snake.direction = SnakeDirection.DOWN;
          }
        } else {
          // Prevent players from going back on themselves.
          if (this._snake.direction != SnakeDirection.DOWN) {
            this._snake.direction = SnakeDirection.UP;
          }
        }
      case Keyboard.RIGHT:
        if (this._snake.reversed_controls) {
          // Prevent players from going back on themselves.
          if (this._snake.direction != SnakeDirection.RIGHT) {
            this._snake.direction = SnakeDirection.LEFT;
          }
        } else {
          // Prevent players from going back on themselves.
          if (this._snake.direction != SnakeDirection.LEFT) {
            this._snake.direction = SnakeDirection.RIGHT;
          }
        }
      case Keyboard.DOWN:
        if (this._snake.reversed_controls) {
          // Prevent players from going back on themselves.
          if (this._snake.direction != SnakeDirection.DOWN) {
            this._snake.direction = SnakeDirection.UP;
          }
        } else {
          // Prevent players from going back on themselves.
          if (this._snake.direction != SnakeDirection.UP) {
            this._snake.direction = SnakeDirection.DOWN;
          }
        }
      case Keyboard.LEFT:
        if (this._snake.reversed_controls) {
          // Prevent players from going back on themselves.
          if (this._snake.direction != SnakeDirection.LEFT) {
            this._snake.direction = SnakeDirection.RIGHT;
          }
        } else {
          // Prevent players from going back on themselves.
          if (this._snake.direction != SnakeDirection.RIGHT) {
            this._snake.direction = SnakeDirection.LEFT;
          }
        }
      case Keyboard.SPACE:
        if (this._snake.is_alive == false) {
          this._parent.changeGameState(new PlayState());
        }
    }
  }

  public function registerManager(manager:IGameStateManager):Void
  {
    this._parent = manager;
  }

  public function update(dt:Int):Void
  {
    this._background_manager.update(dt);
    if (this._snake.is_alive == true) {
      var next_move = (this._snake.parts.length < 12) ?
          (100 - this._snake.parts.length * 5) : 40;
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
        if ((snake_head.x >= this._arena.width) ||
            (snake_head.y >= this._arena.height) ||
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
          this._hud_text.text = "SCORE: " + (this._snake.parts.length - 2);
          if (Std.random(2) == 1) {
            this._snake.reversed_controls = !this._snake.reversed_controls;
          this._hud_text.text = "SCORE: " + (this._snake.parts.length - 2) +
              "\nControls: " + (this._snake.reversed_controls ? "REVERSED" : "NORMAL");
          }
          this._placeFruit();
        } else {
          if (this._snake.is_alive == true) {
            this._snake.parts.shift();
          }
        }
      }
    }
  }

  private function _drawCell(cell:Cell, colour:Int):Void
  {
    this._game_display_object.graphics.beginFill(colour);
    this._game_display_object.graphics.drawRect(
        // TODO: Replace magic values.
        cell.x * (800 / this._arena.width),
        cell.y * (600 / this._arena.height),
        800 / this._arena.width, 600 / this._arena.height);
  }

  private function _placeFruit():Void
  {
    this._fruit = { x: Math.floor(Math.random() *
        this._arena.width), y: Math.floor(Math.random() *
        this._arena.height) };
    for (part in this._snake.parts) {
      if ((this._fruit.x == part.x) && (this._fruit.y == part.y)) {
        this._placeFruit();
      }
    }
  }

  private function _resetGame():Void
  {
    this._arena = { height: 24, width: 32 };
    this._snake = { accumulated_time: 0, is_alive: true,
        direction: SnakeDirection.DOWN,
        parts: [{ x: 2, y: 2 }, { x: 2, y: 3 }],
        reversed_controls: false };
    this._background_manager.changeGameState(
        new BasicBackgroundState(0x0000ff));
    this._main_display_object.addChild(
        this._background_manager.getDisplayObject());
    this._main_display_object.addChild(this._game_display_object);
    this._hud_text = new TextField();
    this._hud_text.autoSize = TextFieldAutoSize.LEFT;
    this._hud_text.defaultTextFormat = new TextFormat("Courier", 18, 0xffffff);
    this._hud_text.selectable = false;
    this._hud_text.text = "SCORE: 0";
    this._hud_text.x = 10;
    this._hud_text.y = 10;
    this._main_display_object.addChild(this._hud_text);
    this._placeFruit();
  }
}
