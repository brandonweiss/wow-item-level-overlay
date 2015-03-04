local ItemUpgradeInfo = LibStub('LibItemUpgradeInfo-1.0')

local inventorySlotNames = {
  "HeadSlot",
  "NeckSlot",
  "ShoulderSlot",
  "BackSlot",
  "ChestSlot",
  "WristSlot",
  "HandsSlot",
  "WaistSlot",
  "LegsSlot",
  "FeetSlot",
  "Finger0Slot",
  "Finger1Slot",
  "Trinket0Slot",
  "Trinket1Slot",
  "MainHandSlot",
  "SecondaryHandSlot"
}

local inventoryItemOverlayCache = {}

local function getInventoryItemLevelFromInventorySlotName(inventorySlotName)
  local inventorySlotNumber = select(1, GetInventorySlotInfo(inventorySlotName))
  local inventoryItemLink   = GetInventoryItemLink("player", inventorySlotNumber)
  if inventoryItemLink then
    return ItemUpgradeInfo:GetUpgradedItemLevel(inventoryItemLink)
  end
end

local function updateItemOverlay(overlayFrame, inventorySlotName, itemLevel)
  local cachedInventoryItemOverlay = inventoryItemOverlayCache[inventorySlotName]

  if cachedInventoryItemOverlay then
    cachedInventoryItemOverlay:SetText(itemLevel)
  else
    local text = overlayFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    text:SetPoint("TOPLEFT", "Character" .. inventorySlotName, 3, -3)
    text:Hide()
    text:SetText(itemLevel)
    text:Show()
    inventoryItemOverlayCache[inventorySlotName] = text
  end
end

local function updateItemOverlays(overlayFrame)
  for index, inventorySlotName in ipairs(inventorySlotNames) do
    local itemLevel = getInventoryItemLevelFromInventorySlotName(inventorySlotName)

    updateItemOverlay(overlayFrame, inventorySlotName, itemLevel)
  end
end

local function createOverlayFrame()
  local overlayFrame = CreateFrame("Frame", nil, PaperDollItemsFrame)

  overlayFrame:SetScript("OnShow", function(self)
    updateItemOverlays(self)
  end)

  overlayFrame:SetScript("OnEvent", function(self, event, ...)
    if (event == "PLAYER_EQUIPMENT_CHANGED") then
      updateItemOverlays(self)
    end
  end)

  overlayFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
  overlayFrame:Show()

  return overlayFrame
end

local function initialize()
  local overlayFrame = createOverlayFrame()
  updateItemOverlays(overlayFrame)
end

initialize()
