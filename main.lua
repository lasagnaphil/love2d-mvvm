require "plugins.gooi.gooi"
local ui = require "mvvm"

--ui.loadGlobal()

ui.ViewModel {
    name = "button",
    data = {
        text = "Exit",
        x = 300,
        y = 300,
        width = 150,
        height = 35,
    },
    methods = {
        onRelease = function()
            gooi.confirm("Are you sure?", function() love.event.quit() end)
        end
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
        text = ui.bindVar "text",
        x = ui.bindVar "x",
        y = ui.bindVar "y",
        w = ui.bindVar "width",
        h = ui.bindVar "height",
        align = "left", icon = "imgs/exit.png",
        onRelease = ui.bindMethod "onRelease"
    }
    local panel = ui.Panel {
        name = "panel",
        x = 0, y = 0, w = ui.bindVar "w", h = ui.bindVar "h",
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
            ui.getData("button").width = ui.getData("button").width - 1
        else
            ui.getData("button").x = ui.getData("button").x - 1
        end
    end
    if love.keyboard.isDown('right') then
        if love.keyboard.isDown('lctrl') then
            ui.getData("button").width = ui.getData("button").width + 1
        else
            ui.getData("button").x = ui.getData("button").x + 1
        end
    end
    if love.keyboard.isDown('up') then
        if love.keyboard.isDown('lctrl') then
            ui.getData("button").height = ui.getData("button").height - 1
        else
            ui.getData("button").y = ui.getData("button").y - 1
        end
    end
    if love.keyboard.isDown('down') then
        if love.keyboard.isDown('lctrl') then
            ui.getData("button").height = ui.getData("button").height + 1
        else
            ui.getData("button").y = ui.getData("button").y + 1
        end
    end
    if love.keyboard.isDown('return') then
        ui.getMethods("button").onRelease()
    end
end

function love.mousepressed(x, y, button)  gooi.pressed() end
function love.mousereleased(x, y, button) gooi.released() end
