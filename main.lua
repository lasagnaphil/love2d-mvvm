require "plugins.gooi.gooi"
local ui = require "mvvm"

--ui.loadGlobal()

ui.ViewModel {
    name = "button",
    data = {
        text = "Exit",
        x = 300,
        y = 300,
        w = 150,
        h = 35,
    }
}

ui.ViewModel {
    name = "panel",
    data = {
        w = 380,
        h = 150
    }
}

function love.load()
    local button = ui.Button {
        name = "button",
        text = ui.bind "text",
        x = ui.bind "x",
        y = ui.bind "y",
        w = ui.bind "w",
        h = ui.bind "h",
        align = "left", icon = "imgs/exit.png",
        onRelease = function()
            gooi.confirm("Are you sure?", function()
                love.event.quit()
            end)
        end
    }
    local panel = ui.Panel {
        name = "panel",
        x = 0, y = 0, w = ui.bind "w", h = ui.bind "h",
        layout = "grid 4x4",
        rowspan = {1, 1, 2},
        colspan = {4, 3, 2},
        gooi.newButton("Fat Button"),
        gooi.newButton("Button 1"),
        gooi.newButton("Button 2"),
        gooi.newButton("Button 3"),
        gooi.newButton("Button X"),
        gooi.newButton("Button Y"),
        gooi.newButton("Button Z"),
        gooi.newButton("Button ."),
        gooi.newButton("Button .."),
        gooi.newButton("Button ..."),
        gooi.newButton("Button ...."),
        gooi.newButton("Last Button"),
        gooi.newCheck("Check 1"),
        gooi.newCheck("Large Check")
    }
end

function love.draw()
    ui.update()
    gooi.draw()
end

function love.update(dt)
    if love.keyboard.isDown('left') then
        -- Alternatively:
        -- ui.vues.button.data.x = ui.vues.button.data.x - 1
        if love.keyboard.isDown('lctrl') then
            ui.getData("button").w = ui.getData("button").w - 1
        else
            ui.getData("button").x = ui.getData("button").x - 1
        end
    end
    if love.keyboard.isDown('right') then
        if love.keyboard.isDown('lctrl') then
            ui.getData("button").w = ui.getData("button").w + 1
        else
            ui.getData("button").x = ui.getData("button").x + 1
        end
    end
    if love.keyboard.isDown('up') then
        if love.keyboard.isDown('lctrl') then
            ui.getData("button").h = ui.getData("button").h - 1
        else
            ui.getData("button").y = ui.getData("button").y - 1
        end
    end
    if love.keyboard.isDown('down') then
        if love.keyboard.isDown('lctrl') then
            ui.getData("button").h = ui.getData("button").h + 1
        else
            ui.getData("button").y = ui.getData("button").y + 1
        end

    end
end

function love.mousepressed(x, y, button)  gooi.pressed() end
function love.mousereleased(x, y, button) gooi.released() end
