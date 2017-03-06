

require "ssk2.loadSSK"
_G.ssk.init()

display.setStatusBar(display.HiddenStatusBar)

local nameCategory -- EFM

local widget = require "widget"

local addTrashView = display.newGroup()
local logsView = display.newGroup()

local function hideCategories()
  addTrashView.isVisible = false
  nameCategory.isVisible = false --EFM  
  logsView.isVisible = true  
end

local function hideLogs()
  addTrashView.isVisible = true
  nameCategory.isVisible = true --EFM
  logsView.isVisible = false  
end

local tabButtons = {
{ label="Add Trash", defaultFile="icon1.png", overFile="icon1-down.png", width = 32, height = 32, onPress=hideLogs, selected=true },
{ label="View Trash Logs", defaultFile="icon2.png", overFile="icon2-down.png", width = 32, height = 32, onPress=hideCategories },
}

-- create the actual tabBar widget
local tabBar = widget.newTabBar{
top = display.screenOriginY, -- 50 is default height for tabBar widget
width = fullw,
buttons = tabButtons
}

local title = display.newText("Trash Logger \n", centerX, top + 90, native.systemFont, 20)
title:setFillColor(1, 0.398, 0, 1)

local instructions = display.newText("1). Click the 'New Category' button to create \n a new category. \n \n 2). Then, click the green + button to add a subcategory. \n \n Happy Cleaning!", left + 20, title.y + 50, native.systemFont, 11)
instructions.anchorX = 0
instructions:setFillColor(1, 0.398, 0, 1)

nameCategory = native.newTextField(instructions.x, instructions.y + 50, fullw / 2, 20) --EFM
nameCategory.anchorX = 0
nameCategory.anchorY = 0

local addSubcategoryButton = widget.newButton({
    label = "",
    width = 20,
    height = 20,
    --defaultFile = "Hopstarter-Rounded-Square-Button-Add.jpg"
    defaultFile = "rg256.png"
})

addSubcategoryButton.x = nameCategory.x + nameCategory.width + (addSubcategoryButton.width / 2)
addSubcategoryButton.y = nameCategory.y + (addSubcategoryButton.height / 2) - 1

addTrashView:insert( title )
addTrashView:insert( instructions )
addTrashView:insert( nameCategory )
addTrashView:insert( addSubcategoryButton )