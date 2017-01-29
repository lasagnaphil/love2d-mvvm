--[[
Quick reference:

ui.vues = {
    <comp id>: {
        data: {
            <varName>: <value>
        },
        methods: {
            <methodName>: <function>
        }
    }
}

ui.dataBinding = {
    <comp id>: {
        ref: <reference to comp>,
        vars: {
            <bindingName>: <varName>
        },
        methods: {
            <bindingName>: <varName>
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

function ui.bindVar(args)
    local bindData = { binding = true, type = "var" }
    if type(args) == "string" then
        bindData.name = args
    else
        error("Wrong argument type in bind() function")
        return nil
    end
    return bindData
end

function ui.bindMethod(args)
    local bindData = { binding = true, type = "method" }
    if type(args) == "string" then
        bindData.name = args
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
    ui.dataBinding[compName] = { vars = { }, methods = { } }
    for varName, bindingTable in pairs(t) do
        if type(bindingTable) == "table" and bindingTable.binding then
            if bindingTable.type == "var" then
                ui.dataBinding[compName].vars[bindingTable.name] = varName
                t[varName] = ui.vues[compName].data[bindingTable.name]
            elseif bindingTable.type == "method" then
                ui.dataBinding[compName].methods[bindingTable.name] = varName
                t[varName] = ui.vues[compName].methods[bindingTable.name]
            end
        end
    end
    -- create the component
    local component = compCreateFunc(t)
    component.name = compName
    ui.dataBinding[compName].ref = component

    -- add binding updaters to component
    component.updateVars = function(self)
        local vars = ui.dataBinding[self.name].vars
        for bindingName, varName in pairs(vars) do
            component[varName] = ui.vues[self.name].data[bindingName]
        end
    end
    component.updateMethods = function(self)
        local methods = ui.dataBinding[self.name].methods
        for bindingName, varName in pairs(methods) do
            component[varName] = ui.vues[self.name].methods[bindingName]
        end
    end

    -- add the component to the components list
    ui.components[#ui.components + 1] = component
    return component
end

function ui.update()
    for _, comp in ipairs(ui.components) do
        comp:updateVars()
    end
end

function ui.ViewModel(t)
    ui.vues[t.name] = t
    t.name = nil
end

function ui.getData(name)
    return ui.vues[name].data
end

function ui.getMethods(name)
    return ui.vues[name].methods
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
function ui:loadGlobal()
    _G.bindVar = self.bindVar
    _G.bindMethod = self.bindMethod
    _G.Label = self.Label
    _G.Button = self.Button
    _G.Slider = self.Slider
    _G.CheckBox = self.CheckBox
    _G.TextField = self.TextField
    _G.ProgressBar = self.ProgressBar
    _G.Spinner = self.Spinner
    _G.Joystick = self.Joystic
    _G.Knob = self.Knob
    _G.Panel = self.Panel
    _G.Button = self.Button
end
return ui
