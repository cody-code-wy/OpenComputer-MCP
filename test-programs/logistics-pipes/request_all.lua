local component = require("component")
local pipe = component.logisticspipe.getPipe()
local items = pipe.getAvailableItems()
print("Requesting all items I can find... this might take up a lot of storage space!")
for _,item in pairs(items) do
  local itemStack = item.getValue1()
  print("Requesting :" .. item.getValue2() .. " of " .. itemStack.getName() .. " from mod " .. itemStack.getModName())
  pipe.makeRequest(itemStack, item.getValue2() + .0)
end
