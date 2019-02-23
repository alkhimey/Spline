/** 
 * @author  Artium Nihamkin, artium@nihamkin.com
 * @date    02/2019
 * @version 1.0.0
 *  
 * @brief Spline drawing and spline based animation module  
 * @section LICENSE
 *
 * The MIT License (MIT)
 * Copyright © 2019 Artium Nihamkin, artium@nihamkin.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the “Software”), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * @section DESCRIPTION 
 *
 * This module provide two related functins
 * 1. The ability to draw splines.
 * 2. The ability to create a spline path that can be used for aimations.
 *
 * The splines that are used are Catmull Rom with tension equalt to 0.5 (will 
 * be configurable in future versions).
 *
 * To use it, one needs to create an Spline object, intialise it and the add waypoints.
 * A minimum of 4 waypoints should be provided. The module creates a spline that
 * pass through all the points except the first and the last and is tangent to the first
 * and last segments.
 *
 * The user can use the DrawSpline function and provide a sprite object on to of which the spline
 * will be drawn. This function as well as the DrawWaypoints function can be used for debugging
 *
 * To use spline for animations, the Increment and GetCurrPosX/Y functions should be used. Each incremention
 * advances the current position on the pline. This is a parametric piecewise curve and the parameter is running
 * betweeen 0.0 and the number of waypoints minus 4.
 * Future versions will have arc-length parametrization and move the position at constant speed, currently a 
 * trial an error must be used to achieve the desired speed.
 *
 * Usage example:
 *
 *  // room script file
 *
 *  Spline s;
 *  Overlay* overlay;
 *
 *  function room_AfterFadeIn()
 *  {
 *    s.Init();
 *    s.AddWaypoint(50,  50);
 *    s.AddWaypoint(70, 100);
 *    s.AddWaypoint(110, 120);
 *    s.AddWaypoint(120, 50);
 *    s.AddWaypoint(190, 120);
 *    s.AddWaypoint(230, 100);
 *    s.AddWaypoint(350, 50); 
 *  }
 *
 *  function room_RepExec()
 *  {
 *    s.SetWaypoint(3,  mouse.x,  mouse.y);
 *
 *    DynamicSprite* sprite = DynamicSprite.Create(System.ScreenWidth, System.ScreenHeight, true);
 *    s.DrawWaypoints(sprite,  Game.GetColorFromRGB(255, 90, 0), 3);
 *    s.DrawSpline(sprite,     Game.GetColorFromRGB(255, 0, 0), 1);
 *    overlay = Overlay.CreateGraphical(0, 0, sprite.Graphic, true);
 *
 *    oCoffeeMug.X = s.GetCurrPosX();
 *    oCoffeeMug.Y = s.GetCurrPosY();
 *    
 *    float dt = 1.0 / IntToFloat(GetGameSpeed());
 *    s.Increment(dt,  eWraparound);     
 *  }
 *
 */

/** 
 * Used to describe the cursor position on the curve.
 */
enum SplinePositionStatus {
  eEnd, 
  eNotEnd
};

/**
 * Used as parameter to decide if to wraparound movement on 
 * the curve.
 */
enum SplineWrapParam {
  eWraparound, 
  eNoWraparound
};

struct Spline {

  protected int waypoints_x[];
  protected int waypoints_y[];
  protected int num_waypoints;
  
  protected int curr_segment;
  protected float curr_pos;
  
  /**
   * Initialize the spline. Acts as a constructor.
   * You must call this function before doing anything else with the spline.
   * You may call this function again to reset the spline. 
   */
  import function Init();
  
  /**
   * Add a new waypoint to the end of the waypoints list.
   *
   * @param x,y The coordinates to set.
   */
  import function AddWaypoint(int x,  int y);
  
  /**
   * Set the values of already existing waypoint. This can be used to dynamically
   * control the spline shape.
   *
   * @param index The index of the waypoint to change. Indicies beging at 0
   *              Calling with index  that is out of bounds will abort the game.
   * @param x,y   The new coordinates to set.
   */
  import function SetWaypoint(int index,  int x,  int y);
  
  /** 
   * Return the number of aypoints.
   */
  import int NumWaypoints();
    
  /**
   * Draw the waypoints on the provided sprite using color and radius.
   * This function can be used for debugging.
   */
  import function DrawWaypoints(DynamicSprite* sprite, int color,  int radius);
  
  /**
   * Draw the spline on the provided sprite using color and line width.
   * This will approximate the spline using 10 lines for each segment. Each waypoint
   * adds a segment starting from the fourth one.
   * Making the number of lines per segment a configurable number is planned for 
   * future version.
   * If performance issues arise, for static splines, call this function once and
   * cache the resulting sprite.
   */
  import function DrawSpline(DynamicSprite* sprite, int color,  int line_width);

  /** 
   * Increment the position by an amount specified by dt parameter. The positon
   * can then be queried by GetCurrPosX/Y functions.
   * @dt The amout by wich to increase the position. This is the parameter of the curve
   *     and in this version it does not represent physical quantity.
   *     In future versions it will represent time and a speed parameter (pixels/sec) 
   *     will allow to move on the curve at contant speed. Currently, trial and error is
   *     required for controlling the speed.
   * @wraparound If eNotwraparound, the position will stop increasing upon reaching the end of
   *             the curve, otherwise the position will waraparound and continue from the 
   *             beginning.
   * @return     Returns eEnd if and only if eNotwraparound was selected and the position
   *             reached the end of the spline.
   */
  import SplinePositionStatus Increment(float dt, SplineWrapParam wraparound);
  
  /**
   * Get the X value of the current position
   */
  import int GetCurrPosX();
  
   /**
   * Get the Y value of the current position
   */
  import int GetCurrPosY();
  
};
