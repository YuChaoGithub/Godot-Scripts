# =============================
# Copyright (C) 2017 Yu Chao
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# =============================
# To understand the code, please read the article on my blog:
# http://shinerightstudio.com/customized-2d-following-camera-in-godot/
# =============================

extends Node2D

# Scroll the screen (aka. move the camera) when the character reaches the margins.
var drag_margin_left = 0
var drag_margin_right = 0.4

# The left/right most edge of the scene. (The camera couldn't move past these limits.)
var right_limit = 1000000
var left_limit = -1000000

# Screen size.
var screen_size

# Being called when loaded.
func _ready():
    screen_size = self.get_viewport_rect().size

# Actually scroll the screen (update the viewport according to the position of the camera).
func update_viewport():
    var canvas_transform = self.get_viewport().get_canvas_transform()
    canvas_transform.o = -self.get_global_pos() + screen_size / 2.0
    self.get_viewport().set_canvas_transform(canvas_transform)

# This function should be called whenever the character moves.
func update_camera(character_pos):
    var new_camera_pos = self.get_global_pos()

    # Check if the character reaches the right margin.
    if character_pos.x > self.get_global_pos().x + screen_size.width * (drag_margin_right - 0.5):
        new_camera_pos.x = character_pos.x - screen_size.width * (drag_margin_right - 0.5)
    
    # Check if the character reaches the left margin.
    elif character_pos.x < self.get_global_pos().x + screen_size.width * (drag_margin_left - 0.5):
		# Character reaches the left drag margin.
        new_camera_pos.x = character_pos.x + screen_size.width * (0.5 - drag_margin_left)

    # Clamp the new camera position within the limits.
	new_camera_pos.x = clamp(new_camera_pos.x, left_limit + screen_size.width * 0.5, right_limit - screen_size.width * 0.5)
    new_camera_pos.y = clamp(new_camera_pos.y, top_limit + screen_size.height * 0.5, bottom_limit - screen_size.height * 0.5)
    
    # Actually update the position of the camera.
    self.set_global_pos(new_camera_pos)
    update_viewport()