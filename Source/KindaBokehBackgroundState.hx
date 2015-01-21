// Copyright (C) 2013-2015 Damien Dart, <damiendart@pobox.com>.
// This file is distributed under the MIT licence. For more information,
// please refer to the accompanying "LICENCE" file.


package;


import flash.display.Sprite;
import flash.events.Event;


typedef Ball = { current_position:Point, dx:Float, dy:Float, opacity:Float,
    previous_position: Point, radius:Float };
typedef Point = { x:Float, y:Float };


class KindaBokehBackgroundState implements IDrawable implements IGameState implements IUpdatable
{
  private var _background_colour:Int;
  private var _balls:Array<Ball>;
  private var _display_object:Sprite;
  private var _foreground_colour:Int;
  private var _parent:IGameStateManager;

  public function draw(alpha:Float):Void
  {
    this._display_object.graphics.clear();
    this._display_object.graphics.beginFill(this._background_colour);
    this._display_object.graphics.drawRect(0, 0,
      this._display_object.stage.stageWidth, this._display_object.stage.stageHeight);
    for(ball in this._balls) {
      this._display_object.graphics.beginFill(_foreground_colour, ball.opacity);
      this._display_object.graphics.drawCircle((ball.current_position.x * alpha) +
          (ball.previous_position.x  * (1.0 - alpha)), (ball.current_position.y * alpha) +
          (ball.previous_position.y * (1.0 - alpha)), ball.radius);
    }
  }

  public function getDisplayObject():Sprite
  {
    return this._display_object;
  }

  public function new(background_colour:Int, foreground_colour:Int):Void
  {
    this._background_colour = background_colour;
    this._foreground_colour = foreground_colour;
    this._display_object = new Sprite();
    this._balls = new Array<Ball>();
    this._display_object.addEventListener(Event.ADDED_TO_STAGE, this._onAddedToStage);
  }

  public function registerManager(manager:IGameStateManager):Void
  {
    this._parent = manager;
  }

  public function update(dt:Int):Void
  {
    for(ball in this._balls) {
      ball.previous_position = ball.current_position;
      ball.current_position.x += ball.dx * (dt / 1000.0);
      if (ball.current_position.x > this._display_object.stage.stageWidth + ball.radius) {
        ball.current_position.x -= this._display_object.stage.stageWidth + (ball.radius * 2);
      }
      ball.current_position.y += ball.dy * (dt / 1000.0);
    }
  }

  private function _onAddedToStage(event:Event):Void
  {
    for(i in 1...220) {
      var x, y;
      x = Std.random(this._display_object.stage.stageWidth);
      y = Std.random(this._display_object.stage.stageHeight);
      this._balls.push({ current_position: { x: x, y: y }, dx: Std.random(300) + 600,
          dy: 0, opacity: Std.random(100) / 100, previous_position: { x: x, y: y },
          radius: Std.random(30) + 15});
    }
  }
}
