package;


import flash.display.DisplayObject;


interface IDrawable
{
  function draw(alpha:Float):Void;
  function getDisplayObject():DisplayObject;
}
