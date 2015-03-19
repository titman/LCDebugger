//
//
//      _|          _|_|_|
//      _|        _|
//      _|        _|
//      _|        _|
//      _|_|_|_|    _|_|_|
//
//
//  Copyright (c) 2014-2015, Licheng Guo. ( http://nsobject.me )
//  http://github.com/titman
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

attribute vec3      a_position;
attribute vec3      a_velocity;
attribute float     a_size;
attribute float     a_starttime;

uniform highp mat4  u_mvpMatrix;
uniform highp float u_elapsedTime;
uniform highp float u_maxRightPosition;
uniform sampler2D   u_samplers2D[1];

varying lowp float  v_visible;
varying lowp float  v_color;

void main()
{
    float xPos = (u_elapsedTime - a_starttime) * a_velocity.x;
    
    vec4 position = vec4(a_position, 1.0);
    position.x += xPos;

    if (position.x < u_maxRightPosition)
    {
        v_visible = 1.0;
    }
    else
    {
        v_visible = 0.0;
    }
    
    gl_Position = u_mvpMatrix * position;

    gl_PointSize = a_size;
}