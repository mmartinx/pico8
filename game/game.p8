pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function _init()
  paddle = {
    x = 64,
    y = 120,
    w = 30,
    h = 5,
    c = 1,
    dx = 1.5
  }

  ball = {
    x = 50,
    y = 50,
    r = 3,
    c = 3
  }

	last = time()
	
	brick_w = 16
	brick_h = 3
	i = 0

  collision_direction = {
    none = 0,
    top = 1,
    bottom = 2,
    left = 3,
    right = 4
  }

  collision = collision_direction.none

	bricks = {}

	for x = 0, 7 do
		for y = 0, 4 do
			add(bricks, {
				x = x,
				y = y,
				v = true
			})
		end
	end
end

-- ------------------------------------------------- --
--                  UPDATE                           --
-- ------------------------------------------------- --

function _update60()
	last = time()

	if btn(0) then paddle.x -= paddle.dx
	elseif btn(1) then paddle.x += paddle.dx
	end
	
	ball.x += 1;
	ball.y += 1;

  ball_rect = {
    x = ball.x - ball.r,
    y = ball.y - ball.r,
    w = ball.r * 2,
    h = ball.r * 2
  }

  collision = check_collision(paddle, ball_rect)
end

function check_collision(a, b)
  local a_bottom = a.y + a.h
  local b_bottom = b.y + b.h
  local a_right = a.x + a.w
  local b_right = b.x + b.w
  local b_collision = b_bottom - a.y
  local t_collision = a_bottom - b.y
  local l_collision = a_right - b.x
  local r_collision = b_right - a.x

  local collision

  if (t_collision < b_collision and t_collision < l_collision and t_collision < r_collision) then collision = collision_direction.top
  elseif (b_collision < t_collision and b_collision < l_collision and b_collision < r_collision) then collision = collision_direction.bottom
  elseif (l_collision < r_collision and l_collision < t_collision and l_collision < b_collision) then collision = collision_direction.left
  elseif (r_collision < l_collision and r_collision < t_collision and r_collision < b_collision)  then collision = collision_direction.right
  else collision = collision_direction.none 
  end

  return collision
end

-- ------------------------------------------------- --
--                  DRAW                             --
-- ------------------------------------------------- --


function _draw()
	cls(2)

	draw_paddle()
	draw_bricks()
	draw_ball()

  print(collision)
end

function draw_paddle()
	draw_rect(paddle)
end

function draw_ball()
	circfill(ball.x, ball.y, ball.r, ball.c)
end

function draw_rect(rectangle)
	rectfill(
		rectangle.x,  rectangle.y,
		rectangle.x + rectangle.w, 
		rectangle.y + rectangle.h, 
		rectangle.c
	)
end

function draw_bricks()
	offset_y = 10
	
	for brick in all(bricks) do
		rectfill(brick.x * brick_w, 
			brick.y * brick_h + offset_y,
			(brick.x + 1) * brick_w,
			(brick.y + 1) * brick_h + offset_y,
			8)
			
	end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
