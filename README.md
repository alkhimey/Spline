Spline Module
======================

**Spline** is a module for AGS ([Advanture Game Studio](http://www.adventuregamestudio.co.uk/)) engine. 

This module provide two related functins:
1. The ability to draw splines.
2. The ability to create a spline path that can be used for aimations.


It splines used are Catmull Rom splines.

It can be used creatively for puzzles, complex movement animations, drawing ropes, drawing roller coaster rails etc.

### Example

Drawing a spline: 

<img src="screenshots/demo1.gif" width="635px" height="371px" />

Animating object movement using a spline: 

<img src="screenshots/demo2.gif" width="635px" height="371px" />


<sup> Game used for this demo is <i><a href="https://github.com/adventuregamestudio/ags-templates/blob/master/Templates/Sierra-style.agt">Sierra-style </a></i> template. All rights for the shown art are reserved for the respective artists. </sup>

### Importing the Module

Import an `.scm` file ("_Explore Project_ -> Right Click on _Scripts_ -> _Import Script..._. Get it from the [_Releases_](https://github.com/alkhimey/TBD/releases) section on Github.

### Usage

Create a spline object and initialize it:

    Spline s;
    ...
    s.Init();

Add at least 4 waypoints (trying to use module with less will abort your game - this is intentional):

    s.AddWaypoint(50,  50);
    s.AddWaypoint(70, 100);
    s.AddWaypoint(110, 120);
    s.AddWaypoint(120, 50);

Now it is possible to draw the spline on a provided sprite and overlay this sprite on the screen:

    Overlay* overlay;
    ...
    DynamicSprite* sprite = DynamicSprite.Create(System.ScreenWidth, System.ScreenHeight, true);
    s.DrawSpline(sprite,     Game.GetColorFromRGB(255, 30, 0), 2);
    overlay = Overlay.CreateGraphical(0, 0, sprite.Graphic, true);
    
Additionaly, it is possible to animate an object:

    function room_RepExec()
    {

      oCoffeeMug.X = s.GetCurrPosX();
      oCoffeeMug.Y = s.GetCurrPosY();
 
      float dt = 1.0 / IntToFloat(GetGameSpeed());
  
      s.Increment(dt,  eNoWraparound);
    }
    
### Future Plans

* Arc-length parametrization of the curse so that it will be able to animate.
* Allow to define the tension value of the Catmull Rom spline (currently it is 0.5 hardcoded)
* Allow to define number of lines per segment when drawing the spline.
