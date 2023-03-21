local component = require("component")

local driver = {}

--------------------------------------------------------------------------------
---------------------------------- Item Class ----------------------------------
--------------------------------------------------------------------------------

local ItemStack = {}
ItemStack.__index = ItemStack

local function ItemStack_new(item)
  checkArg(1, item, "table");
  local out = {
    data = item.getValue1(),
    quantity = item.getValue2()
  }
  setmetatable(out, ItemStack)
  return out
end

function ItemStack:getName()
  return self.data.getName()
end

--------------------------------------------------------------------------------
-------------------------------- Private Driver --------------------------------
--------------------------------------------------------------------------------


driver.internal = {}

--------------------------------------------------------------------------------
-------------------------------- Public  Driver --------------------------------
--------------------------------------------------------------------------------

function driver.getItems()
  if not component.isAvailable("logisticspipe") then
    error("no logistics pipe available", 2)
  end
  local pipe = component.logisticspipe.getPipe()
  if not pipe.getAvailableItems and not pipe.makeRequest then
    error("Logistics pipe is not a a requesting pipe")
  end
  local output = {}
  for _,item in pairs(pipe.getAvailableItems()) do
    table.insert(output, ItemStack_new(item))
  end
  return output
end

return driver
