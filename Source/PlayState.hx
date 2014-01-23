package;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.ui.Keyboard;

enum SnakeDirection { UP; RIGHT; DOWN; LEFT; }

class PlayState extends Sprite implements IGameState {
  private var _arena_dimensions:{ height: Int, width: Int };
  private var _fruit:{ x: Int, y: Int };
  private var _is_snake_alive:Bool;
  private var _snake_accumulated_time:Int;
  private var _snake_direction:SnakeDirection;
  private var _snake_parts:Array<{ x: Int, y: Int }>;

  public function draw(alpha:Float):Void {
    this.graphics.clear();
    this.graphics.beginFill(0x0000ff);
    this.graphics.drawRect(0, 0, 800, 600);
    for (part in this._snake_parts) {
      this.graphics.beginFill(0xffffff);
      this.graphics.drawRect(part.x * (800 / this._arena_dimensions.width),
          part.y * (600 / this._arena_dimensions.height),
          (800 / this._arena_dimensions.width),
          (600 / this._arena_dimensions.height));
    }
    this.graphics.beginFill(0xff0000);
    this.graphics.drawRect(this._fruit.x *
        (800 / this._arena_dimensions.width),
        this._fruit.y * (600 / this._arena_dimensions.height),
        (800 / this._arena_dimensions.width),
        (600 / this._arena_dimensions.height));
  }

  public function new() {
    super();
    this.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
  }

  public function onKeyDown(event:KeyboardEvent):Void {
    switch (event.keyCode) {
      case Keyboard.UP: this._snake_direction = SnakeDirection.UP;
      case Keyboard.RIGHT: this._snake_direction = SnakeDirection.RIGHT;
      case Keyboard.DOWN: this._snake_direction = SnakeDirection.DOWN;
      case Keyboard.LEFT: this._snake_direction = SnakeDirection.LEFT;
    }
  }

  public function update(dt:Int):Void {
    if (_is_snake_alive == true) {
      this._snake_accumulated_time += dt;
      while (this._snake_accumulated_time >= 100) {
        this._snake_accumulated_time -= 100;
        var snake_head = this._snake_parts[this._snake_parts.length - 1];
        switch (_snake_direction) {
          case SnakeDirection.UP:
            this._snake_parts.push({ x: snake_head.x, y: snake_head.y - 1 });
          case SnakeDirection.RIGHT:
            this._snake_parts.push({ x: snake_head.x + 1, y: snake_head.y });
          case SnakeDirection.DOWN:
            this._snake_parts.push({ x: snake_head.x, y: snake_head.y + 1 });
          case SnakeDirection.LEFT:
            this._snake_parts.push({ x: snake_head.x - 1, y: snake_head.y });
        }
        var snake_head = this._snake_parts[this._snake_parts.length - 1];
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

  private function _onAddedToStage(event:Event):Void {
    this._arena_dimensions = { height: 24, width: 32 };
    this._is_snake_alive = true;
    this._snake_direction = SnakeDirection.DOWN;
    this._snake_parts = [{ x: 2, y: 2 }, { x: 2, y: 3 }];
    this._placeFruit();
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
}
