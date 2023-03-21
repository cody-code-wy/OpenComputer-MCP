local component = require("component")

local driver = {}

--------------------------------------------------------------------------------
------------------------------- ItemStack  Class -------------------------------
--------------------------------------------------------------------------------

local ItemStack = {}
ItemStack.__index = ItemStack

local function ItemStack_new(item)
  checkArg(1, item, "table");
  local output = {
    data = item.getValue1(),
    quantity = item.getValue2()
  }
  setmetatable(output, ItemStack)
  return output
end

function ItemStack:getName()
  --- check for custom name
  if self.data.hasTagCompound() then
    local nbt = self.data.getTagCompound()
    if nbt.value.display and nbt.value.display.value.Name then
      return nbt.value.display.value.Name.value
    end
  end
  return self.data.getName()
end

--------------------------------------------------------------------------------
----------------------------- ItemCollection Class -----------------------------
--------------------------------------------------------------------------------

local ItemCollection = {}
ItemCollection.__index = ItemCollection

local function ItemCollection_new(items)
  checkArg(1, items, "table");
  local output = {}
  output.searchTable = {}
  for i,item in pairs(items) do
    local itemStack = ItemStack_new(item)
    output[i] = itemStack
    output.searchTable[itemStack:getName()] = i
  end
  setmetatable(output, ItemCollection);
  return output
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
  return ItemCollection_new(pipe.getAvailableItems())
end

return driver
