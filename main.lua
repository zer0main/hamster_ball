local x, y, enemies, shots, speed, dt1, dt2, bg, ball
local is_winner = false
local is_loser = false
local group_number = 0

local tableLength = function(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local checkFail = function()
    if tableLength(enemies) ~= 0 then
        if enemies[1].y > 700 then
            is_loser = true
        end
    end
end

local keyIsDown = function(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if love.keyboard.isDown("right") then
        x = x + dt * speed
    end
    if love.keyboard.isDown("left") then
        x = x - dt * speed
    end
    if love.keyboard.isDown("down") then
        y = y + speed * dt
    end
    if love.keyboard.isDown("up") then
        y = y - dt * speed
    end
    if love.keyboard.isDown(" ") then
        if (dt1 - dt2) >= 0.2 then
            local shot = {}
            shot.x = x + 50
            shot.y = y
            shot.pict = love.graphics.newImage("fireball.png")
            table.insert(shots, shot)
            dt2 = dt1
        end
    end
end

local addEnemies = function(number, width, height, speed)
    for i = 0, number - 1 do
        local enemy = {}
        enemy.width = width
        enemy.height = height
        enemy.speed = speed
        enemy.x = i * (enemy.width + 60) + 100
        enemy.y = enemy.height + 100
        table.insert(enemies, enemy)
    end
end

local addEnemiesGroup = function(diff)
    addEnemies(8 - group_number, 30, 15, 10 + group_number * diff)
end

local checkCollision = function(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function love.load() 
    if love.window and love.window.setFullscreen then
        love.windo.setFullscreen(true, "desctop")
    elseif love.graphics.setMode then
        love.graphics.setMode(800, 640, true, false, 0)
    end
    bg = love.graphics.newImage("bg.png")
    enemies = {}
    addEnemies(8, 30, 15, 20)
    ball = love.graphics.newImage("hamster_ball.png")
    x = 50
    y = 50
    speed = 300
    shots = {}
    dt1 = 0
    dt2 = dt1
end

function love.update(dt)
    dt1 = dt1 + dt
    checkFail()
    if tableLength(enemies) == 0 then
        addEnemiesGroup(40)
        group_number = group_number + 1
        if group_number == 9 then
            is_winner = true
        end
    end
    for x, d in ipairs(enemies) do
        d.y = d.y + d.speed * dt
    end
    for i, v in ipairs(shots) do
        v.y = v.y - dt * 500
        for x, d in ipairs(enemies) do
            if checkCollision(v.x, v.y, 20, 20, d.x, d.y, d.width, d.height) then
                table.remove(enemies, x)
            end
        end
    end
    keyIsDown(dt)
end

function love.draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(bg)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(ball, x, y)
    if is_loser then
        love.graphics.print("You are loser...", 75, 300, 0, 7, 7)
    elseif is_winner then
        love.graphics.print("You are winner!", 100, 300, 0, 7, 7)
    else 
        love.graphics.print("Level "  ..group_number,
        300, 100, 0, 5, 5)
    end
    for i, v in ipairs (shots) do
        love.graphics.draw(v.pict, v.x, v.y)
    end
    love.graphics.setColor(0, 255, 255, 255)
    for i, v in ipairs (enemies) do
        love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
    end
end
