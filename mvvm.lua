--[[
Quick reference:

ui.vues = {
    <comp id>: {
        data: {
            <varName>: <value>
        }
    }
}

ui.dataBinding = {
    <comp id>: {
        ref: <reference to comp>,
        vars: {
        }
    }
}
]]

local ui = {}

require "plugins.gooi.gooi"
-- local genUuid = require "plugins.uuid"

-- vue: shorthand for "ViewModel" (inspired by Vue.js)
ui.vues = {}
ui.dataBinding = {}
ui.components = {}

function ui.bind(args)
    local bindData = { binding = true }
    if type(args) == "string" then
        bindData.varName = args
    else
        error("Wrong argument type in bind() function")
        return nil
    end
    return bindData
end

function ui.createComponent(compCreateFunc, t)
    -- create bindings for the component
    if type(t.name) ~= "string" then
        error("invalid name for component")
        return nil
    end
    local compName = t.name
    ui.dataBinding[compName] = { vars = { } }
    for varName, bindingTable in pairs(t) do
        if type(bindingTable) == "table" and bindingTable.binding then
            ui.dataBinding[compName].vars[varName] = true
            t[varName] = ui.vues[compName].data[varName]
        end
    end
    -- create the component
    local component = compCreateFunc(t)
    component.name = compName
    ui.dataBinding[compName].ref = component
    -- add binding updater to component
    component.updateBindings = function(self)
        local vars = ui.dataBinding[self.name].vars
        for varName, _ in pairs(vars) do
            component[varName] = ui.vues[self.name].data[varName]
        end
    end
    ui.components[#ui.components + 1] = component
    return component
end

function ui.update()
    for _, comp in ipairs(ui.components) do
        comp:updateBindings()
    end
end

function ui.ViewModel(t)
    ui.vues[t.name] = t
    t.name = nil
end

function ui.getData(name)
    return ui.vues[name].data
end

function ui.Label(t)
    return ui.createComponent(gooi.newLabel, t)
end

function ui.Button(t)
    return ui.createComponent(gooi.newButton, t)
end

function ui.Slider(t)
    return ui.createComponent(gooi.newSlider, t)
end

function ui.CheckBox(t)
    return ui.createComponent(gooi.newCheck, t)
end

function ui.TextField(t)
    return ui.createComponent(gooi.newText, t)
end

function ui.ProgressBar(t)
    return ui.createComponent(gooi.newBar, t)
end

function ui.Spinner(t)
    return ui.createComponent(gooi.newSpinner, t)
end

function ui.Joystick(t)
    return ui.createComponent(gooi.newJoy, t)
end

function ui.Knob(t)
    return ui.createComponent(gooi.newKnob, t)
end

function ui.Panel(t)
    local panel = ui.createComponent(gooi.newPanel, t)
    if t.rowspan then
        panel:setRowspan(unpack(t.rowspan))
    end
    if t.colspan then
        panel:setColspan(unpack(t.colspan))
    end
    for _, elem in ipairs(t) do
        panel:add(elem)
    end
    return panel
end

function ui.Button(t)
    local button = ui.createComponent(gooi.newButton, t)
    if not t.text then
        t.text = t.name
    end
    if t.onRelease then
        button:onRelease(t.onRelease)
    end
    if t.onPress then
        button:onPress(t.onPress)
    end
end

-- globally load ui functions
ui.loadGlobal = function()
    _G.bind = ui.bind
    _G.Label = ui.Label
    _G.Button = ui.Button
    _G.Slider = ui.Slider
    _G.CheckBox = ui.CheckBox
    _G.TextField = ui.TextField
    _G.ProgressBar = ui.ProgressBar
    _G.Spinner = ui.Spinner
    _G.Joystick = ui.Joystic
    _G.Knob = ui.Knob
    _G.Panel = ui.Panel
    _G.Button = ui.Button
end
return ui
