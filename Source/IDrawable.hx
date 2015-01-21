// Copyright (C) 2013-2015 Damien Dart, <damiendart@pobox.com>.
// This file is distributed under the MIT licence. For more information,
// please refer to the accompanying "LICENCE" file.


package;


import flash.display.DisplayObject;


interface IDrawable
{
  function draw(alpha:Float):Void;
  function getDisplayObject():DisplayObject;
}
