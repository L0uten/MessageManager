VERSION = "0.2.1"

local frame = CreateFrame("Frame") -- main frame
local fOption = CreateFrame("Frame") -- interfrace options category
local fSubOptions1 = CreateFrame("Frame") --
local fSubOptions2 = CreateFrame("Frame") --
local fSubOptions3 = CreateFrame("Frame") -- subcategory
local fSubOptions4 = CreateFrame("Frame") --
local fSubOptions5 = CreateFrame("Frame") --

mainOptionDB = {
    isEnabled
}

soundOptionDB = {
    isEnabled,
    generalSound,
    playersSoundList = {},
    customSounds = {},
}

ignoreOptionDB = {
    isEnabled,
    ignoreEveryoneMode,
    ignorePlayerMode,
    ignoreInBattleMode,
    playersIgnoreList = {},
    playersExceptionList = {},
    exceptionGuild,
    exceptionFriends,
    exceptionRaid,
}

local pathSounds = "Interface\\AddOns\\MessageManager\\sounds\\"
local pathSoundsCustom = "Interface\\AddOns\\MessageManager\\sounds\\custom\\"

local soundsList = {
    [0] = {
        ["path"] = pathSounds,
        ["name"] = "Отключено"
    },
    [1] = {
        ["path"] = pathSounds.."obeme.mp3",
        ["name"] = "Обэме"
    },
    [2] = {
        ["path"] = pathSounds.."ded_oret.mp3",
        ["name"] = "Уаааааааааааа"
    },
    [3] = {
        ["path"] = pathSounds.."pacman.mp3",
        ["name"] = "Пакмэн"
    },
    [4] = {
        ["path"] = pathSounds.."bell.mp3",
        ["name"] = "Колокольчик"
    },
    [5] = {
        ["path"] = pathSounds.."cough.mp3",
        ["name"] = "Кашель"
    },
    [6] = {
        ["path"] = pathSounds.."fkfkfk.mp3",
        ["name"] = "Fuck fuck fuck"
    },
    [7] = {
        ["path"] = pathSounds.."somebody.mp3",
        ["name"] = "Somebody"
    },
    [8] = {
        ["path"] = pathSounds.."amogus.mp3",
        ["name"] = "Amogus"
    },
    [9] = {
        ["path"] = pathSounds.."broa.mp3",
        ["name"] = "Broa"
    },
    [10] = {
        ["path"] = pathSounds.."clown.mp3",
        ["name"] = "Клоунский клаксон"
    },
    [11] = {
        ["path"] = pathSounds.."fbi.mp3",
        ["name"] = "FBI OPEN DOOR"
    },
    [12] = {
        ["path"] = pathSounds.."mario.mp3",
        ["name"] = "It's me, Mario!"
    },
    [13] = {
        ["path"] = pathSounds.."monkey.mp3",
        ["name"] = "Крик обезьяны"
    },
    [14] = {
        ["path"] = pathSounds.."nice_cock.mp3",
        ["name"] = "Nice cock"
    },
    [15] = {
        ["path"] = pathSounds.."rodnoi.mp3",
        ["name"] = "Любимый мой, родной"
    },
    [16] = {
        ["path"] = pathSounds.."toccata_organ.mp3",
        ["name"] = "Орган"
    },
    [17] = {
        ["path"] = pathSounds.."discord.mp3",
        ["name"] = "Звук уведомления Discord"
    },
    [18] = {
        ["path"] = pathSounds.."telegram.mp3",
        ["name"] = "Звук уведомления Telegram"
    },
    [19] = {
        ["path"] = pathSounds.."vkontakte.mp3",
        ["name"] = "Звук уведомления Вконтакте"
    },
    [20] = {
        ["path"] = pathSounds.."murloc.mp3",
        ["name"] = "Мргргрлргл"
    },
    [21] = {
        ["path"] = pathSounds.."oh_my_god.mp3",
        ["name"] = "Oh My God"
    },
    [22] = {
        ["path"] = pathSounds.."oof.mp3",
        ["name"] = "Уу"
    },
    [23] = {
        ["path"] = pathSounds.."wow.mp3",
        ["name"] = "Woow"
    },
    [24] = {
        ["path"] = pathSounds.."bass_drop.mp3",
        ["name"] = "Bass Drop"
    },
}

local inCombat = false

frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function (self, event, addOnName)
    if (event == "ADDON_LOADED" and addOnName == "MessageManager") then
        print("|cff9d5be3[Massage Manager]|r v"..VERSION)

        if (soundOptionDB.generalSound ~= nil) then
            if (soundOptionDB.generalSound > #soundsList) then
                soundOptionDB.generalSound = nil
            end
        end

        if (#soundOptionDB.playersSoundList > 0) then
            for i = 1, #soundOptionDB.playersSoundList do
                if (soundOptionDB.playersSoundList[i].soundIndex > #soundsList) then
                    soundOptionDB.playersSoundList[i].soundPath = soundsList[0].path
                    soundOptionDB.playersSoundList[i].soundIndex = 0
                end
            end
        end

        if (#soundOptionDB.customSounds > 0) then
            for i = 1, #soundOptionDB.customSounds do
                local maxList = #soundsList + 1
                soundsList[maxList] = {}
                soundsList[maxList].name = soundOptionDB.customSounds[i]
                soundsList[maxList].path = pathSoundsCustom..soundOptionDB.customSounds[i]
            end
        end

        fOption.name = "Message Manager"
        InterfaceOptions_AddCategory(fOption)

        fSubOptions1.name = "Звук вход. сообщения"
        fSubOptions1.parent = fOption
        InterfaceOptions_AddCategory(fSubOptions1)

        -- fSubOptions2.name = "Автоответчик"
        -- fSubOptions2.parent = fOption
        -- InterfaceOptions_AddCategory(fSubOptions2)

        fSubOptions3.name = "Режим игнорирования"
        fSubOptions3.parent = fOption
        InterfaceOptions_AddCategory(fSubOptions3)

        -- fSubOptions4.name = "Автоинвайт"
        -- fSubOptions4.parent = fOption
        -- InterfaceOptions_AddCategory(fSubOptions4)

        -- fSubOptions5.name = "Анти-спам/флуд"
        -- fSubOptions5.parent = fOption
        -- InterfaceOptions_AddCategory(fSubOptions5)

        if (mainOptionDB.isEnabled == nil) then mainOptionDB.isEnabled = true end
        if (soundOptionDB.isEnabled == nil) then soundOptionDB.isEnabled = true end
        if (ignoreOptionDB.isEnabled == nil) then ignoreOptionDB.isEnabled = true end
        if (ignoreOptionDB.ignoreEveryoneMode == nil) then ignoreOptionDB.ignoreEveryoneMode = false end
        if (ignoreOptionDB.ignorePlayerMode == nil) then ignoreOptionDB.ignorePlayerMode = false end
        if (ignoreOptionDB.ignoreInBattleMode == nil) then ignoreOptionDB.ignoreInBattleMode = false end
        if (ignoreOptionDB.exceptionGuild == nil) then ignoreOptionDB.exceptionGuild = false end
        if (ignoreOptionDB.exceptionFriends == nil) then ignoreOptionDB.exceptionFriends = false end
        if (ignoreOptionDB.exceptionRaid == nil) then ignoreOptionDB.exceptionRaid = false end
        
        fOption:mainOptions()
        fSubOptions1:msgSoundOptions()
        fSubOptions3:msgIgnoreOptions()
    end
end)

function fOption:mainOptions()
    ------------------------
    -- Основные настройки --
    ------------------------
    self.title = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    self.title:SetPoint("TOPLEFT", 25, -13)
    self.title:SetTextHeight(18)
    self.title:SetText("Основные настройки")

    --------------------------------
    -- Включить / отключить аддон --
    --------------------------------
    self.enabledCB = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
	self.enabledCB:SetPoint("TOPLEFT", 25, -53)
	self.enabledCB.Text:SetText("Включить аддон")
    self.enabledCB:SetChecked(mainOptionDB.isEnabled)
    self.enabledCB:SetScript("OnClick", function()
        mainOptionDB.isEnabled = not(not self.enabledCB:GetChecked())
	end)
end

function fSubOptions1:msgSoundOptions()
    -----------------------------------------
    -- Настройка звука входящего сообщения --
    -----------------------------------------
    self.title = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    self.title:SetPoint("TOPLEFT", 25, -13)
    self.title:SetTextHeight(18)
    self.title:SetText("Настройка звука входящего сообщения")

    --------------------------------
    -- Включить / отклоючить звук --
    --------------------------------
    self.enabledCB = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
	self.enabledCB:SetPoint("TOPLEFT", 40, -43)
	self.enabledCB.Text:SetText("Включить звук")
    self.enabledCB:SetChecked(soundOptionDB.isEnabled)
    self.enabledCB:SetScript("OnClick", function()
        soundOptionDB.isEnabled = not(not self.enabledCB:GetChecked())
	end)

    ------------------------
    -- Выбор общего звука --
    ------------------------
    local dropDown = CreateFrame("FRAME", "WPDemoDropDown", self, "UIDropDownMenuTemplate")
    dropDown:SetPoint("TOPLEFT", 30, -83)
    UIDropDownMenu_SetWidth(dropDown, 170)
    if (soundOptionDB.generalSound == nil) then
        UIDropDownMenu_SetText(dropDown, "Установить общий звук:")
    else
        if (soundOptionDB.generalSound == 0) then
            UIDropDownMenu_SetText(dropDown, "Общий звук: "..soundsList[soundOptionDB.generalSound].name)
        else
            UIDropDownMenu_SetText(dropDown, "Общий звук: \""..soundsList[soundOptionDB.generalSound].name.."\"")
        end
    end
    local function WPDropDownDemo_OnClick(self, arg1, arg2, checked)
        PlaySoundFile(soundsList[arg1].path, "Master")
        if (arg1 == 0) then
            UIDropDownMenu_SetText(dropDown, "Общий звук: "..soundsList[arg1].name)
        else
            UIDropDownMenu_SetText(dropDown, "Общий звук: \""..soundsList[arg1].name.."\"")
        end
        soundOptionDB.generalSound = arg1
    end
    UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        if (level or 1) == 1 then
            for i = 0, #soundsList do
                info.text = soundsList[i].name
                info.arg1 = i
                info.arg2 = soundOptionDB.generalSound
                info.checked = soundOptionDB.generalSound == i
                info.func = WPDropDownDemo_OnClick
                UIDropDownMenu_AddButton(info)
            end
        end
    end)

    ---------------------------------------
    -- Настройка звука отдельного игрока --
    ---------------------------------------
    self.playerSoundTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.playerSoundTitle:SetPoint("TOPLEFT", 25, -133)
    self.playerSoundTitle:SetTextHeight(13)
    self.playerSoundTitle:SetText("Настройка звука отдельного игрока")

    -------------------
    -- Ввод никнейма --
    -------------------
    local sName
    local sI

    self.enterNameTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.enterNameTitle:SetPoint("TOPLEFT", 40, -160)
    self.enterNameTitle:SetTextHeight(12)
    self.enterNameTitle:SetText("Никнейм")

    local inputName = CreateFrame("Frame", nil, self)
    inputName:SetPoint("TOPLEFT", 40, -180)
    inputName:SetWidth(110)
    inputName:SetHeight(23)
    inputName:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    inputName:SetBackdropColor(0, 0, 0, .8)
    inputName:SetBackdropBorderColor(1, 1, 1, .4)

    inputName.EditBox = CreateFrame("EditBox", nil, inputName)
    inputName.EditBox:SetPoint("CENTER", 0, 0)
    inputName.EditBox:SetWidth(inputName:GetWidth() - 18)
    inputName.EditBox:SetHeight(inputName:GetHeight() - 2)
    inputName.EditBox:SetFontObject(GameFontHighlight)
    inputName.EditBox:SetJustifyH("LEFT")
    inputName.EditBox:EnableMouse(true)
    inputName.EditBox:SetAutoFocus(false)
    inputName.EditBox:SetMaxLetters(11)
    inputName.EditBox:SetScript("OnEscapePressed", function ()
        inputName.EditBox:ClearFocus()
    end)
    inputName.EditBox:SetScript("OnTextChanged", function (self, argg2, argg3, argg4)
        sName = self:GetText()
    end)

    -----------------
    -- Выбор звука --
    -----------------
    self.chooseSoundTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.chooseSoundTitle:SetPoint("TOPLEFT", 165, -160)
    self.chooseSoundTitle:SetTextHeight(12)
    self.chooseSoundTitle:SetText("Звук")

    local chooseSound = CreateFrame("Frame", "ChooseSoundDropDown", self, "UIDropDownMenuTemplate")
    chooseSound:SetPoint("TOPLEFT", 148, -173)
    UIDropDownMenu_SetWidth(chooseSound, 100)
    UIDropDownMenu_SetText(chooseSound, "Выбрать звук")


    local function ChooseSoundDropDown_OnClick(self, arg1, arg2, checked)
        PlaySoundFile(soundsList[arg1].path, "Master")
        if (arg1 == 0) then
            UIDropDownMenu_SetText(ChooseSoundDropDown, soundsList[arg1].name)
        else
            UIDropDownMenu_SetText(ChooseSoundDropDown, "\""..soundsList[arg1].name.."\"")
        end
        sI = arg1
    end
    UIDropDownMenu_Initialize(ChooseSoundDropDown, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        if (level or 1) == 1 then
            for i = 0, #soundsList do
                info.text = soundsList[i].name
                info.arg1 = i
                info.func = ChooseSoundDropDown_OnClick
                UIDropDownMenu_AddButton(info)
            end
        end
    end)

    -------------------
    -- Подтверждение --
    -------------------
    local submit = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
    submit:SetWidth(50)
    submit:SetPoint("TOPLEFT", 295, -178)
    submit:SetText("Ок")

    --------------------------
    -- Вывод список игроков --
    --------------------------
    self.displayFrameTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.displayFrameTitle:SetPoint("TOPLEFT", 40, -213)
    self.displayFrameTitle:SetTextHeight(12)
    self.displayFrameTitle:SetText("Список игроков")

    local displayFrame = CreateFrame("Frame", nil, self)
    displayFrame:SetWidth(250)
    displayFrame:SetHeight(100)
    displayFrame:SetPoint("TOPLEFT", 40, -233)
    displayFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    })
    displayFrame:SetBackdropColor(0, 0, 0, .4)
    displayFrame:EnableMouse(true)
    displayFrame:EnableMouseWheel(true)

    displayFrame.scrollFrame = CreateFrame("ScrollFrame", nil, displayFrame)
    displayFrame.scrollFrame:SetPoint("TOPLEFT", 3, -4)
    displayFrame.scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

    displayFrame.scrollChild = CreateFrame("Frame")
    displayFrame.scrollFrame:SetScrollChild(displayFrame.scrollChild)
    displayFrame.scrollChild:SetWidth(displayFrame:GetWidth()-10)
    displayFrame.scrollChild:SetHeight(1)

    displayFrame.scrollBar = CreateFrame("Slider", nil, displayFrame.scrollFrame, "UIPanelScrollBarTemplate")
    displayFrame.scrollBar:SetPoint("RIGHT", displayFrame, "RIGHT", -5, 0)
    displayFrame.scrollBar:SetSize(10, displayFrame:GetHeight() - 40)
    displayFrame.scrollBar:SetMinMaxValues(0, 10)
    displayFrame.scrollBar:SetValue(0)
    displayFrame.scrollBar:SetValueStep(1)
    displayFrame.scrollBar:SetOrientation('VERTICAL')

    displayFrame:SetScript("OnMouseWheel", function (self, delta)
        displayFrame.scrollBar:SetValue(displayFrame.scrollBar:GetValue() - delta * 20)
        displayFrame.scrollBar:SetMinMaxValues(0, displayFrame.scrollFrame:GetVerticalScrollRange())
    end)

    displayFrame.scrollBar:SetScript("OnMouseDown", function (self, button)
        displayFrame.scrollBar:SetMinMaxValues(0, displayFrame.scrollFrame:GetVerticalScrollRange())
    end)

    local playerFrames = {}

    local function refreshDisplay()
        if (#soundOptionDB.playersSoundList ~= 0) then

            ----------------------------
            -- Очистка фреймов вывода --
            ----------------------------
            for i = 1, #soundOptionDB.playersSoundList do
                if (playerFrames[i] ~= nil) then
                    playerFrames[i]:Hide()
                end
            end
            
            for i = 1, #soundOptionDB.playersSoundList do
                if (playerFrames[i] ~= nil) then
                    if (playerFrames[i].isPressed == true) then
                        soundOptionDB.playersSoundList[i] = nil
                    end
                end
            end

            playerFrames = {}

            -------------------------------
            -- Добавление фреймов вывода --
            -------------------------------
            for i = 1, #soundOptionDB.playersSoundList do
                local _, _, _, _, yOfs
                if (i > 1) then
                    _, _, _, _, yOfs = playerFrames[i - 1]:GetPoint()
                end
                playerFrames[i] = CreateFrame("Button", nil, displayFrame.scrollChild)
                playerFrames[i].isPressed = false
                playerFrames[i]:SetSize(displayFrame:GetWidth(), 20)
                if (i == 1) then
                    playerFrames[i]:SetPoint("TOP", 0, 0)
                else
                    playerFrames[i]:SetPoint("TOP", 0, (yOfs + -22))
                end
                playerFrames[i]:SetBackdrop({
                    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                })
                playerFrames[i]:SetBackdropColor(0, 0, 0, 0)

                playerFrames[i]:SetScript("OnEnter", function ()
                    playerFrames[i]:SetBackdropColor(1, 1, 1, .4)
                end)

                playerFrames[i]:SetScript("OnLeave", function ()
                    playerFrames[i]:SetBackdropColor(0, 0, 0, 0)
                end)

                playerFrames[i]:SetScript("OnClick", function ()
                    if (playerFrames[i].isPressed == false or playerFrames[i].isPressed == nil) then
                        playerFrames[i]:SetBackdrop({
                            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                            edgeSize = 10,
                            insets = { left = 1, right = 1, top = 0, bottom = 1 }
                        })
                        playerFrames[i]:SetScript("OnLeave", function ()
                            playerFrames[i]:SetBackdropColor(1, 1, 1, .2)
                        end)
                        playerFrames[i].isPressed = true
                    else
                        playerFrames[i]:SetBackdrop({
                            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                        })
                        playerFrames[i]:SetScript("OnLeave", function ()
                            playerFrames[i]:SetBackdropColor(0, 0, 0, 0)
                        end)
                        playerFrames[i].isPressed = false
                    end
                end)

                -- Добавить текст в фрейм
                local nameText = soundOptionDB.playersSoundList[i].playerName
                local soundText = soundsList[soundOptionDB.playersSoundList[i].soundIndex].name
                playerFrames[i].text = playerFrames[i]:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                playerFrames[i].text:SetPoint("LEFT", 20, 0)
                playerFrames[i].text:SetText(nameText.." - "..soundText)
            end
        end
    end

    refreshDisplay()

    local function addPlayerSound(pName, sIndex)
        ------------------------------------
        -- небольшая чистка от nil-данных --
        ------------------------------------
        if (#soundOptionDB.playersSoundList > 1) then
            for i = 1, #soundOptionDB.playersSoundList do
                if (soundOptionDB.playersSoundList[i] == nil) then
                    if (i + 1 ~= #soundOptionDB.playersSoundList) then
                        for y = i + 1, (#soundOptionDB.playersSoundList + 1) do
                            if (soundOptionDB.playersSoundList[y] ~= nil) then
                                soundOptionDB.playersSoundList[i] = soundOptionDB.playersSoundList[y]
                                soundOptionDB.playersSoundList[y] = nil
                                break
                            end
                        end
                    end
                end
            end
        end

        if (sIndex ~= nil) then
            for i = 1, #soundOptionDB.playersSoundList + 1 do
                if (soundOptionDB.playersSoundList[i] == nil) then
                    soundOptionDB.playersSoundList[i] = {}
                    soundOptionDB.playersSoundList[i].playerName = pName
                    soundOptionDB.playersSoundList[i].soundPath = soundsList[sIndex].path
                    soundOptionDB.playersSoundList[i].soundIndex = sIndex
                else
                    if (soundOptionDB.playersSoundList[i].playerName == pName) then
                        soundOptionDB.playersSoundList[i].soundPath = soundsList[sIndex].path
                        soundOptionDB.playersSoundList[i].soundIndex = sIndex
                        break
                    end
                end
            end
        end
    end

    submit:SetScript("OnClick", function (self, event)
        if (string.len(sName) > 1) then
            addPlayerSound(sName, sI)
            
            if (#playerFrames > 0) then
                for i = 1, #playerFrames do
                    playerFrames[i].isPressed = false
                end
            end

            refreshDisplay()
        end
    end)

    local remove = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
    remove:SetWidth(80)
    remove:SetPoint("TOPLEFT", 295, -308)
    remove:SetText("Удалить")
    remove:SetScript("OnClick", function ()
        refreshDisplay()
    end)

    --------------------
    -- Кастомный звук --
    --------------------
    self.customSoundTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.customSoundTitle:SetPoint("TOPLEFT", 25, -348)
    self.customSoundTitle:SetTextHeight(13)
    self.customSoundTitle:SetText("Кастомный звук")

    ---------------------------
    -- Ввод кастомного звука --
    ---------------------------
    local csName

    self.enterCustomSoundTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.enterCustomSoundTitle:SetPoint("TOPLEFT", 40, -378)
    self.enterCustomSoundTitle:SetTextHeight(12)
    self.enterCustomSoundTitle:SetText("Имя файла        (например myCustomSound.mp3)")

    local inputCustomSound = CreateFrame("Frame", nil, self)
    inputCustomSound:SetPoint("TOPLEFT", 40, -398)
    inputCustomSound:SetWidth(220)
    inputCustomSound:SetHeight(23)
    inputCustomSound:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    inputCustomSound:SetBackdropColor(0, 0, 0, .8)
    inputCustomSound:SetBackdropBorderColor(1, 1, 1, .4)

    inputCustomSound.EditBox = CreateFrame("EditBox", nil, inputCustomSound)
    inputCustomSound.EditBox:SetPoint("CENTER", 0, 0)
    inputCustomSound.EditBox:SetWidth(inputCustomSound:GetWidth() - 18)
    inputCustomSound.EditBox:SetHeight(inputCustomSound:GetHeight() - 2)
    inputCustomSound.EditBox:SetFontObject(GameFontHighlight)
    inputCustomSound.EditBox:SetJustifyH("LEFT")
    inputCustomSound.EditBox:EnableMouse(true)
    inputCustomSound.EditBox:SetAutoFocus(false)
    inputCustomSound.EditBox:SetScript("OnEscapePressed", function ()
        inputCustomSound.EditBox:ClearFocus()
    end)
    inputCustomSound.EditBox:SetScript("OnTextChanged", function (self, argg2, argg3, argg4)
        csName = self:GetText()
    end)

    local submitCustomSound = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
    submitCustomSound:SetWidth(50)
    submitCustomSound:SetPoint("TOPLEFT", 270, -396)
    submitCustomSound:SetText("Ок")

    -----------------------------------
    -- Вывод списка кастомного звука --
    -----------------------------------
    self.displayCustomSoundFrameTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.displayCustomSoundFrameTitle:SetPoint("TOPLEFT", 40, -428)
    self.displayCustomSoundFrameTitle:SetTextHeight(12)
    self.displayCustomSoundFrameTitle:SetText("Список кастомного звука")

    local displayCustomSoundFrame = CreateFrame("Frame", nil, self)
    displayCustomSoundFrame:SetWidth(250)
    displayCustomSoundFrame:SetHeight(100)
    displayCustomSoundFrame:SetPoint("TOPLEFT", 40, -448)
    displayCustomSoundFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    })
    displayCustomSoundFrame:SetBackdropColor(0, 0, 0, .4)
    displayCustomSoundFrame:EnableMouse(true)
    displayCustomSoundFrame:EnableMouseWheel(true)

    displayCustomSoundFrame.scrollFrame = CreateFrame("ScrollFrame", nil, displayCustomSoundFrame)
    displayCustomSoundFrame.scrollFrame:SetPoint("TOPLEFT", 3, -4)
    displayCustomSoundFrame.scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

    displayCustomSoundFrame.scrollChild = CreateFrame("Frame")
    displayCustomSoundFrame.scrollFrame:SetScrollChild(displayCustomSoundFrame.scrollChild)
    displayCustomSoundFrame.scrollChild:SetWidth(displayCustomSoundFrame:GetWidth()-10)
    displayCustomSoundFrame.scrollChild:SetHeight(1)

    displayCustomSoundFrame.scrollBar = CreateFrame("Slider", nil, displayCustomSoundFrame.scrollFrame, "UIPanelScrollBarTemplate")
    displayCustomSoundFrame.scrollBar:SetPoint("RIGHT", displayCustomSoundFrame, "RIGHT", -5, 0)
    displayCustomSoundFrame.scrollBar:SetSize(10, displayCustomSoundFrame:GetHeight() - 40)
    displayCustomSoundFrame.scrollBar:SetMinMaxValues(0, 10)
    displayCustomSoundFrame.scrollBar:SetValue(0)
    displayCustomSoundFrame.scrollBar:SetValueStep(1)
    displayCustomSoundFrame.scrollBar:SetOrientation('VERTICAL')

    displayCustomSoundFrame:SetScript("OnMouseWheel", function (self, delta)
        displayCustomSoundFrame.scrollBar:SetValue(displayCustomSoundFrame.scrollBar:GetValue() - delta * 20)
        displayCustomSoundFrame.scrollBar:SetMinMaxValues(0, displayCustomSoundFrame.scrollFrame:GetVerticalScrollRange())
    end)

    displayCustomSoundFrame.scrollBar:SetScript("OnMouseDown", function (self, button)
        displayCustomSoundFrame.scrollBar:SetMinMaxValues(0, displayCustomSoundFrame.scrollFrame:GetVerticalScrollRange())
    end)

    local customSoundFrames = {}

    local function refreshCustomSoundDisplay()
        if (#soundOptionDB.customSounds ~= 0) then

            ----------------------------
            -- Очистка фреймов вывода --
            ----------------------------
            for i = 1, #soundOptionDB.customSounds do
                if (customSoundFrames[i] ~= nil) then
                    customSoundFrames[i]:Hide()
                end
            end
            
            for i = 1, #soundOptionDB.customSounds do
                if (customSoundFrames[i] ~= nil) then
                    if (customSoundFrames[i].isPressed == true) then
                        soundOptionDB.customSounds[i] = nil
                    end
                end
            end

            customSoundFrames = {}

            -------------------------------
            -- Добавление фреймов вывода --
            -------------------------------
            for i = 1, #soundOptionDB.customSounds do
                local _, _, _, _, yOfs
                if (i > 1) then
                    _, _, _, _, yOfs = customSoundFrames[i - 1]:GetPoint()
                end
                customSoundFrames[i] = CreateFrame("Button", nil, displayCustomSoundFrame.scrollChild)
                customSoundFrames[i].isPressed = false
                customSoundFrames[i]:SetSize(displayFrame:GetWidth(), 20)
                if (i == 1) then
                    customSoundFrames[i]:SetPoint("TOP", 0, 0)
                else
                    customSoundFrames[i]:SetPoint("TOP", 0, (yOfs + -22))
                end
                customSoundFrames[i]:SetBackdrop({
                    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                })
                customSoundFrames[i]:SetBackdropColor(0, 0, 0, 0)

                customSoundFrames[i]:SetScript("OnEnter", function ()
                    customSoundFrames[i]:SetBackdropColor(1, 1, 1, .4)
                end)

                customSoundFrames[i]:SetScript("OnLeave", function ()
                    customSoundFrames[i]:SetBackdropColor(0, 0, 0, 0)
                end)

                customSoundFrames[i]:SetScript("OnClick", function ()
                    if (customSoundFrames[i].isPressed == false or customSoundFrames[i].isPressed == nil) then
                        customSoundFrames[i]:SetBackdrop({
                            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                            edgeSize = 10,
                            insets = { left = 1, right = 1, top = 0, bottom = 1 }
                        })
                        customSoundFrames[i]:SetScript("OnLeave", function ()
                            customSoundFrames[i]:SetBackdropColor(1, 1, 1, .2)
                        end)
                        customSoundFrames[i].isPressed = true
                    else
                        customSoundFrames[i]:SetBackdrop({
                            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                        })
                        customSoundFrames[i]:SetScript("OnLeave", function ()
                            customSoundFrames[i]:SetBackdropColor(0, 0, 0, 0)
                        end)
                        customSoundFrames[i].isPressed = false
                    end
                end)

                -- Добавить текст в фрейм
                local nameText = soundOptionDB.customSounds[i]
                customSoundFrames[i].text = customSoundFrames[i]:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                customSoundFrames[i].text:SetPoint("LEFT", 20, 0)
                customSoundFrames[i].text:SetText(nameText)
            end
        end
    end

    refreshCustomSoundDisplay()

    local function addCustomSound(sName)
        ------------------------------------
        -- небольшая чистка от nil-данных --
        ------------------------------------
        if (#soundOptionDB.customSounds > 1) then
            for i = 1, #soundOptionDB.customSounds do
                if (soundOptionDB.customSounds[i] == nil) then
                    if (i + 1 ~= #soundOptionDB.customSounds) then
                        for y = i + 1, (#soundOptionDB.customSounds + 1) do
                            if (soundOptionDB.customSounds[y] ~= nil) then
                                soundOptionDB.customSounds[i] = soundOptionDB.playersSoundList[y]
                                soundOptionDB.customSounds[y] = nil
                                break
                            end
                        end
                    end
                end
            end
        end

        for i = 1, #soundOptionDB.customSounds + 1 do
            if (soundOptionDB.customSounds[i] == nil) then
                soundOptionDB.customSounds[i] = sName
            else
                if (soundOptionDB.playersSoundList[i] == sName) then
                    break
                end
            end
        end
    end

    submitCustomSound:SetScript("OnClick", function (self, event)
        if (string.len(csName) > 1) then
            addCustomSound(csName)

            if (#customSoundFrames > 0) then
                for i = 1, #customSoundFrames do
                    customSoundFrames[i].isPressed = false
                end
            end

            refreshCustomSoundDisplay()
        end
    end)

    local removeCustomSound = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
    removeCustomSound:SetWidth(80)
    removeCustomSound:SetPoint("TOPLEFT", 295, -523)
    removeCustomSound:SetText("Удалить")
    removeCustomSound:SetScript("OnClick", function ()
        refreshCustomSoundDisplay()
    end)

    self.enterCustomSoundHelp = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.enterCustomSoundHelp:SetWidth(320)
    self.enterCustomSoundHelp:SetPoint("TOPLEFT", 300, -430)
    self.enterCustomSoundHelp:SetTextHeight(12)
    self.enterCustomSoundHelp:SetJustifyH("LEFT")
    self.enterCustomSoundHelp:SetText(
        "Инструкция: В папку\nInterface\\AddOns\\MessageManager\\sounds\\custom\\\nзакиньте аудио файл с форматом .mp3, .ogg"..
        "\n\nДалее добавьте полное название файла в список и полностью перезайдите в игру."
    )
end

local function friendCheck(playerName)
    numTotalFriends, onlineFriends = GetNumFriends()

    for i = 1, numTotalFriends do
        local friendName = GetFriendInfo(i);

        if (friendName == playerName) then
            return true
        end
    end
    return false
end

local function guildMemberCheck(playerName)
    numTotalMembers, numOnlineMaxLevelMembers, numOnlineMembers = GetNumGuildMembers()

    for i = 1, numTotalMembers do
        local guildMemberName = GetGuildRosterInfo(i)

        if (guildMemberName == playerName) then
            return true
        end
    end
    return false
end

local function raidMemberCheck(playerName)
    numTotalMembers = GetNumRaidMembers()

    if (numTotalMembers > 0) then
        for i = 1, numTotalMembers do
            local raidMemberName = GetRaidRosterInfo(i)
            
            if (raidMemberName == playerName) then
                return true
            end
        end
    end
    return false
end

function fSubOptions3:msgIgnoreOptions()

    ------------------------------------
    -- Настройка режима игнорирования --
    ------------------------------------
    self.title = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    self.title:SetPoint("TOPLEFT", 25, -13)
    self.title:SetTextHeight(18)
    self.title:SetText("Настройка режима игнорирования")

    -----------------------------------------------
    -- Включить / отклоючить режим игнорирования --
    -----------------------------------------------
    self.enabledCB = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
	self.enabledCB:SetPoint("TOPLEFT", 40, -43)
	self.enabledCB.Text:SetText("Включить режим игнорирования")
    self.enabledCB:SetChecked(ignoreOptionDB.isEnabled)
    self.enabledCB:SetScript("OnClick", function()
        ignoreOptionDB.isEnabled = not(not self.enabledCB:GetChecked())
	end)

    -------------------
    -- Выбрать режим --
    -------------------
    self.ignoreModeTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.ignoreModeTitle:SetPoint("TOPLEFT", 25, -78)
    self.ignoreModeTitle:SetTextHeight(13)
    self.ignoreModeTitle:SetText("Выбрать режим игнорирования")

    self.ignoreEveryoneCB = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
	self.ignoreEveryoneCB:SetPoint("TOPLEFT", 40, -103)
	self.ignoreEveryoneCB.Text:SetText("Игнорировать всех")
    self.ignoreEveryoneCB:SetChecked(ignoreOptionDB.ignoreEveryoneMode)
    self.ignoreEveryoneCB:SetScript("OnClick", function()
        ignoreOptionDB.ignoreEveryoneMode = not(not self.ignoreEveryoneCB:GetChecked())
	end)

    self.ignorePlayerCB = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
	self.ignorePlayerCB:SetPoint("TOPLEFT", 40, -133)
	self.ignorePlayerCB.Text:SetText("Игнорировать определенных игроков")
    self.ignorePlayerCB:SetChecked(ignoreOptionDB.ignorePlayerMode)
    self.ignorePlayerCB:SetScript("OnClick", function()
        ignoreOptionDB.ignorePlayerMode = not(not self.ignorePlayerCB:GetChecked())
	end)
    
    self.ignoreInBattleCB = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
	self.ignoreInBattleCB:SetPoint("TOPLEFT", 340, -103)
	self.ignoreInBattleCB.Text:SetText("Игнорировать во время боя (В рейде)")
    self.ignoreInBattleCB:SetChecked(ignoreOptionDB.ignoreInBattleMode)
    self.ignoreInBattleCB:SetScript("OnClick", function()
        ignoreOptionDB.ignoreInBattleMode = not(not self.ignoreInBattleCB:GetChecked())
	end)

    ----------------
    -- Ввод никнейма --
    ----------------
    local iName

    self.enterNameTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.enterNameTitle:SetPoint("TOPLEFT", 40, -173)
    self.enterNameTitle:SetTextHeight(12)
    self.enterNameTitle:SetText("Никнейм")

    local inputName = CreateFrame("Frame", nil, self)
    inputName:SetPoint("TOPLEFT", 40, -183)
    inputName:SetWidth(110)
    inputName:SetHeight(23)
    inputName:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    inputName:SetBackdropColor(0, 0, 0, .8)
    inputName:SetBackdropBorderColor(1, 1, 1, .4)

    inputName.EditBox = CreateFrame("EditBox", nil, inputName)
    inputName.EditBox:SetPoint("CENTER", 0, 0)
    inputName.EditBox:SetWidth(inputName:GetWidth() - 18)
    inputName.EditBox:SetHeight(inputName:GetHeight() - 2)
    inputName.EditBox:SetFontObject(GameFontHighlight)
    inputName.EditBox:SetJustifyH("LEFT")
    inputName.EditBox:EnableMouse(true)
    inputName.EditBox:SetAutoFocus(false)
    inputName.EditBox:SetMaxLetters(11)
    inputName.EditBox:SetScript("OnEscapePressed", function ()
        inputName.EditBox:ClearFocus()
    end)
    inputName.EditBox:SetScript("OnTextChanged", function (self, argg2, argg3, argg4)
        iName = self:GetText()
    end)

    local submit = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
    submit:SetWidth(90)
    submit:SetPoint("TOPLEFT", 170, -183)
    submit:SetText("Добавить")

    ---------------------------------------
    -- Вывод списка игнорируемых игроков --
    ---------------------------------------
    local displayIgnoreFrameTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    displayIgnoreFrameTitle:SetPoint("TOPLEFT", 43, -213)
    displayIgnoreFrameTitle:SetTextHeight(12)
    displayIgnoreFrameTitle:SetText("Список игнорируемых игроков")

    local displayIgnoreFrame = CreateFrame("Frame", nil, self)
    displayIgnoreFrame:SetWidth(180)
    displayIgnoreFrame:SetHeight(80)
    displayIgnoreFrame:SetPoint("TOPLEFT", 43, -233)
    displayIgnoreFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    })
    displayIgnoreFrame:SetBackdropColor(0, 0, 0, .4)
    displayIgnoreFrame:EnableMouse(true)
    displayIgnoreFrame:EnableMouseWheel(true)

    displayIgnoreFrame.scrollFrame = CreateFrame("ScrollFrame", nil, displayIgnoreFrame)
    displayIgnoreFrame.scrollFrame:SetPoint("TOPLEFT", 3, -4)
    displayIgnoreFrame.scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

    displayIgnoreFrame.scrollChild = CreateFrame("Frame")
    displayIgnoreFrame.scrollFrame:SetScrollChild(displayIgnoreFrame.scrollChild)
    displayIgnoreFrame.scrollChild:SetWidth(displayIgnoreFrame:GetWidth()-10)
    displayIgnoreFrame.scrollChild:SetHeight(1)

    displayIgnoreFrame.scrollBar = CreateFrame("Slider", nil, displayIgnoreFrame.scrollFrame, "UIPanelScrollBarTemplate")
    displayIgnoreFrame.scrollBar:SetPoint("RIGHT", displayIgnoreFrame, "RIGHT", -5, 0)
    displayIgnoreFrame.scrollBar:SetSize(10, displayIgnoreFrame:GetHeight() - 40)
    displayIgnoreFrame.scrollBar:SetMinMaxValues(0, 10)
    displayIgnoreFrame.scrollBar:SetValue(0)
    displayIgnoreFrame.scrollBar:SetValueStep(1)
    displayIgnoreFrame.scrollBar:SetOrientation('VERTICAL')

    displayIgnoreFrame:SetScript("OnMouseWheel", function (self, delta)
        displayIgnoreFrame.scrollBar:SetValue(displayIgnoreFrame.scrollBar:GetValue() - delta * 20)
        displayIgnoreFrame.scrollBar:SetMinMaxValues(0, displayIgnoreFrame.scrollFrame:GetVerticalScrollRange())
    end)

    displayIgnoreFrame.scrollBar:SetScript("OnMouseDown", function (self, button)
        displayIgnoreFrame.scrollBar:SetMinMaxValues(0, displayIgnoreFrame.scrollFrame:GetVerticalScrollRange())
    end)

    local playerFrames = {}

    local function refreshDisplay()
        if (#ignoreOptionDB.playersIgnoreList ~= 0) then

            ----------------------------
            -- Очистка фреймов вывода --
            ----------------------------
            for i = 1, #ignoreOptionDB.playersIgnoreList do
                if (playerFrames[i] ~= nil) then
                    playerFrames[i]:Hide()
                end
            end
            
            for i = 1, #ignoreOptionDB.playersIgnoreList do
                if (playerFrames[i] ~= nil) then
                    if (playerFrames[i].isPressed == true) then
                        ignoreOptionDB.playersIgnoreList[i] = nil
                    end
                end
            end

            playerFrames = {}

            -------------------------------
            -- Добавление фреймов вывода --
            -------------------------------
            for i = 1, #ignoreOptionDB.playersIgnoreList do
                local _, _, _, _, yOfs
                if (i > 1) then
                    _, _, _, _, yOfs = playerFrames[i - 1]:GetPoint()
                end
                playerFrames[i] = CreateFrame("Button", nil, displayIgnoreFrame.scrollChild)
                playerFrames[i].isPressed = false
                playerFrames[i]:SetSize(displayIgnoreFrame:GetWidth(), 20)
                if (i == 1) then
                    playerFrames[i]:SetPoint("TOP", 0, 0)
                else
                    playerFrames[i]:SetPoint("TOP", 0, (yOfs + -22))
                end
                playerFrames[i]:SetBackdrop({
                    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                })
                playerFrames[i]:SetBackdropColor(0, 0, 0, 0)

                playerFrames[i]:SetScript("OnEnter", function ()
                    playerFrames[i]:SetBackdropColor(1, 1, 1, .4)
                end)

                playerFrames[i]:SetScript("OnLeave", function ()
                    playerFrames[i]:SetBackdropColor(0, 0, 0, 0)
                end)

                playerFrames[i]:SetScript("OnClick", function ()
                    if (playerFrames[i].isPressed == false or playerFrames[i].isPressed == nil) then
                        playerFrames[i]:SetBackdrop({
                            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                            edgeSize = 10,
                            insets = { left = 1, right = 1, top = 0, bottom = 1 }
                        })
                        playerFrames[i]:SetScript("OnLeave", function ()
                            playerFrames[i]:SetBackdropColor(1, 1, 1, .2)
                        end)
                        playerFrames[i].isPressed = true
                    else
                        playerFrames[i]:SetBackdrop({
                            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                        })
                        playerFrames[i]:SetScript("OnLeave", function ()
                            playerFrames[i]:SetBackdropColor(0, 0, 0, 0)
                        end)
                        playerFrames[i].isPressed = false
                    end
                end)

                -- Добавить текст в фрейм
                local nameText = ignoreOptionDB.playersIgnoreList[i].playerName
                playerFrames[i].text = playerFrames[i]:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                playerFrames[i].text:SetPoint("LEFT", 20, 0)
                playerFrames[i].text:SetText(nameText)
            end
        end
    end

    refreshDisplay()

    local function addPlayerIgnore(pName)
        ------------------------------------
        -- небольшая чистка от nil-данных --
        ------------------------------------
        if (#ignoreOptionDB.playersIgnoreList > 1) then
            for i = 1, #ignoreOptionDB.playersIgnoreList do
                if (ignoreOptionDB.playersIgnoreList[i] == nil) then
                    if (i + 1 ~= #ignoreOptionDB.playersIgnoreList) then
                        for y = i + 1, (#ignoreOptionDB.playersIgnoreList + 1) do
                            if (ignoreOptionDB.playersIgnoreList[y] ~= nil) then
                                ignoreOptionDB.playersIgnoreList[i] = ignoreOptionDB.playersIgnoreList[y]
                                ignoreOptionDB.playersIgnoreList[y] = nil
                                break
                            end
                        end
                    end
                end
            end
        end

        for i = 1, #ignoreOptionDB.playersIgnoreList + 1 do
            if (ignoreOptionDB.playersIgnoreList[i] == nil) then
                ignoreOptionDB.playersIgnoreList[i] = {}
                ignoreOptionDB.playersIgnoreList[i].playerName = pName
            else
                if (ignoreOptionDB.playersIgnoreList[i].playerName == pName) then
                    break
                end
            end
        end
    end

    submit:SetScript("OnClick", function (self, event)
        if (string.len(iName) > 1) then
            addPlayerIgnore(iName)

            if (#playerFrames > 0) then
                for i = 1, #playerFrames do
                    playerFrames[i].isPressed = false
                end
            end

            refreshDisplay()
        end
    end)

    local remove = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
    remove:SetWidth(80)
    remove:SetPoint("TOPLEFT", 240, -293)
    remove:SetText("Удалить")
    remove:SetScript("OnClick", function ()
        refreshDisplay()
    end)

    ------------------------------
    -- Проверка на комбат (бой) --
    ------------------------------

    local tempIgnoreFrame = CreateFrame("Frame")
    tempIgnoreFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
    tempIgnoreFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    tempIgnoreFrame:SetScript("OnEvent", function(self, event)
        if (event == "PLAYER_REGEN_DISABLED") then
            inCombat = true
        end

        if (event == "PLAYER_REGEN_ENABLED") then
            inCombat = false
        end
    end)

    self.exceptionsTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.exceptionsTitle:SetPoint("TOPLEFT", 25, -333)
    self.exceptionsTitle:SetTextHeight(13)
    self.exceptionsTitle:SetText("Исключения")

    ----------------
    -- Ввод имени --
    ----------------
    local eName

    self.enterNameExceptionTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    self.enterNameExceptionTitle:SetPoint("TOPLEFT", 40, -363)
    self.enterNameExceptionTitle:SetTextHeight(12)
    self.enterNameExceptionTitle:SetText("Никнейм")

    local inputNameException = CreateFrame("Frame", nil, self)
    inputNameException:SetPoint("TOPLEFT", 40, -373)
    inputNameException:SetWidth(110)
    inputNameException:SetHeight(23)
    inputNameException:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    inputNameException:SetBackdropColor(0, 0, 0, .8)
    inputNameException:SetBackdropBorderColor(1, 1, 1, .4)

    inputNameException.EditBox = CreateFrame("EditBox", nil, inputNameException)
    inputNameException.EditBox:SetPoint("CENTER", 0, 0)
    inputNameException.EditBox:SetWidth(inputName:GetWidth() - 18)
    inputNameException.EditBox:SetHeight(inputName:GetHeight() - 2)
    inputNameException.EditBox:SetFontObject(GameFontHighlight)
    inputNameException.EditBox:SetJustifyH("LEFT")
    inputNameException.EditBox:EnableMouse(true)
    inputNameException.EditBox:SetAutoFocus(false)
    inputNameException.EditBox:SetMaxLetters(11)
    inputNameException.EditBox:SetScript("OnEscapePressed", function ()
        inputNameException.EditBox:ClearFocus()
    end)
    inputNameException.EditBox:SetScript("OnTextChanged", function (self, argg2, argg3, argg4)
        eName = self:GetText()
    end)

    local submitException = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
    submitException:SetWidth(90)
    submitException:SetPoint("TOPLEFT", 170, -373)
    submitException:SetText("Добавить")

    local displayExceptionFrameTitle = self:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    displayExceptionFrameTitle:SetPoint("TOPLEFT", 43, -403)
    displayExceptionFrameTitle:SetTextHeight(12)
    displayExceptionFrameTitle:SetText("Список исключений")

    local displayExceptionFrame = CreateFrame("Frame", nil, self)
    displayExceptionFrame:SetWidth(180)
    displayExceptionFrame:SetHeight(90)
    displayExceptionFrame:SetPoint("TOPLEFT", 43, -413)
    displayExceptionFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    })
    displayExceptionFrame:SetBackdropColor(0, 0, 0, .4)
    displayExceptionFrame:EnableMouse(true)
    displayExceptionFrame:EnableMouseWheel(true)

    displayExceptionFrame.scrollFrame = CreateFrame("ScrollFrame", nil, displayExceptionFrame)
    displayExceptionFrame.scrollFrame:SetPoint("TOPLEFT", 3, -4)
    displayExceptionFrame.scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

    displayExceptionFrame.scrollChild = CreateFrame("Frame")
    displayExceptionFrame.scrollFrame:SetScrollChild(displayExceptionFrame.scrollChild)
    displayExceptionFrame.scrollChild:SetWidth(displayExceptionFrame:GetWidth()-10)
    displayExceptionFrame.scrollChild:SetHeight(1)

    displayExceptionFrame.scrollBar = CreateFrame("Slider", nil, displayExceptionFrame.scrollFrame, "UIPanelScrollBarTemplate")
    displayExceptionFrame.scrollBar:SetPoint("RIGHT", displayExceptionFrame, "RIGHT", -5, 0)
    displayExceptionFrame.scrollBar:SetSize(10, displayExceptionFrame:GetHeight() - 40)
    displayExceptionFrame.scrollBar:SetMinMaxValues(0, 10)
    displayExceptionFrame.scrollBar:SetValue(0)
    displayExceptionFrame.scrollBar:SetValueStep(1)
    displayExceptionFrame.scrollBar:SetOrientation('VERTICAL')

    displayExceptionFrame:SetScript("OnMouseWheel", function (self, delta)
        displayExceptionFrame.scrollBar:SetValue(displayExceptionFrame.scrollBar:GetValue() - delta * 20)
        displayExceptionFrame.scrollBar:SetMinMaxValues(0, displayExceptionFrame.scrollFrame:GetVerticalScrollRange())
    end)

    displayExceptionFrame.scrollBar:SetScript("OnMouseDown", function (self, button)
        displayExceptionFrame.scrollBar:SetMinMaxValues(0, displayExceptionFrame.scrollFrame:GetVerticalScrollRange())
    end)

    local playerExceptionFrames = {}

    local function refreshExceptionDisplay()
        if (#ignoreOptionDB.playersExceptionList ~= 0) then

            ----------------------------
            -- Очистка фреймов вывода --
            ----------------------------
            for i = 1, #ignoreOptionDB.playersExceptionList do
                if (playerExceptionFrames[i] ~= nil) then
                    playerExceptionFrames[i]:Hide()
                end
            end
            
            for i = 1, #ignoreOptionDB.playersExceptionList do
                if (playerExceptionFrames[i] ~= nil) then
                    if (playerExceptionFrames[i].isPressed == true) then
                        ignoreOptionDB.playersExceptionList[i] = nil
                    end
                end
            end

            playerExceptionFrames = {}

            -------------------------------
            -- Добавление фреймов вывода --
            -------------------------------
            for i = 1, #ignoreOptionDB.playersExceptionList do
                local _, _, _, _, yOfs
                if (i > 1) then
                    _, _, _, _, yOfs = playerExceptionFrames[i - 1]:GetPoint()
                end
                playerExceptionFrames[i] = CreateFrame("Button", nil, displayExceptionFrame.scrollChild)
                playerExceptionFrames[i].isPressed = false
                playerExceptionFrames[i]:SetSize(displayExceptionFrame:GetWidth(), 20)
                if (i == 1) then
                    playerExceptionFrames[i]:SetPoint("TOP", 0, 0)
                else
                    playerExceptionFrames[i]:SetPoint("TOP", 0, (yOfs + -22))
                end
                playerExceptionFrames[i]:SetBackdrop({
                    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                })
                playerExceptionFrames[i]:SetBackdropColor(0, 0, 0, 0)

                playerExceptionFrames[i]:SetScript("OnEnter", function ()
                    playerExceptionFrames[i]:SetBackdropColor(1, 1, 1, .4)
                end)

                playerExceptionFrames[i]:SetScript("OnLeave", function ()
                    playerExceptionFrames[i]:SetBackdropColor(0, 0, 0, 0)
                end)

                playerExceptionFrames[i]:SetScript("OnClick", function ()
                    if (playerExceptionFrames[i].isPressed == false or playerExceptionFrames[i].isPressed == nil) then
                        playerExceptionFrames[i]:SetBackdrop({
                            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                            edgeSize = 10,
                            insets = { left = 1, right = 1, top = 0, bottom = 1 }
                        })
                        playerExceptionFrames[i]:SetScript("OnLeave", function ()
                            playerExceptionFrames[i]:SetBackdropColor(1, 1, 1, .2)
                        end)
                        playerExceptionFrames[i].isPressed = true
                    else
                        playerExceptionFrames[i]:SetBackdrop({
                            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                        })
                        playerExceptionFrames[i]:SetScript("OnLeave", function ()
                            playerExceptionFrames[i]:SetBackdropColor(0, 0, 0, 0)
                        end)
                        playerExceptionFrames[i].isPressed = false
                    end
                end)
                -- Добавить текст в фрейм
                local nameText = ignoreOptionDB.playersExceptionList[i].playerName
                playerExceptionFrames[i].text = playerExceptionFrames[i]:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                playerExceptionFrames[i].text:SetPoint("LEFT", 20, 0)
                playerExceptionFrames[i].text:SetText(nameText)
            end
        end
    end

    refreshExceptionDisplay()

    local function addPlayerException(pName)
        ------------------------------------
        -- небольшая чистка от nil-данных --
        ------------------------------------
        if (#ignoreOptionDB.playersExceptionList > 1) then
            for i = 1, #ignoreOptionDB.playersExceptionList do
                if (ignoreOptionDB.playersExceptionList[i] == nil) then
                    if (i + 1 ~= #ignoreOptionDB.playersExceptionList) then
                        for y = i + 1, (#ignoreOptionDB.playersExceptionList + 1) do
                            if (ignoreOptionDB.playersExceptionList[y] ~= nil) then
                                ignoreOptionDB.playersExceptionList[i] = ignoreOptionDB.playersExceptionList[y]
                                ignoreOptionDB.playersExceptionList[y] = nil
                                break
                            end
                        end
                    end
                end
            end
        end

        for i = 1, #ignoreOptionDB.playersExceptionList + 1 do
            if (ignoreOptionDB.playersExceptionList[i] == nil) then
                ignoreOptionDB.playersExceptionList[i] = {}
                ignoreOptionDB.playersExceptionList[i].playerName = pName
            else
                if (ignoreOptionDB.playersExceptionList[i].playerName == pName) then
                    break
                end
            end
        end
    end

    submitException:SetScript("OnClick", function (self, event)
        if (string.len(eName) > 1) then
            addPlayerException(eName)

            if (#playerExceptionFrames > 0) then
                for i = 1, #playerExceptionFrames do
                    playerExceptionFrames[i].isPressed = false
                end
            end

            refreshExceptionDisplay()
        end
    end)

    local removeException = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
    removeException:SetWidth(80)
    removeException:SetPoint("TOPLEFT", 240, -483)
    removeException:SetText("Удалить")
    removeException:SetScript("OnClick", function ()
        refreshExceptionDisplay()
    end)

    self.exceptionGuildCB = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
	self.exceptionGuildCB:SetPoint("TOPLEFT", 40, -523)
	self.exceptionGuildCB.Text:SetText("Гильдия")
    self.exceptionGuildCB:SetChecked(ignoreOptionDB.exceptionGuild)
    self.exceptionGuildCB:SetScript("OnClick", function()
        ignoreOptionDB.exceptionGuild = not(not self.exceptionGuildCB:GetChecked())
	end)

    self.exceptionFriendsCB = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
	self.exceptionFriendsCB:SetPoint("TOPLEFT", 170, -523)
	self.exceptionFriendsCB.Text:SetText("Друзья")
    self.exceptionFriendsCB:SetChecked(ignoreOptionDB.exceptionFriends)
    self.exceptionFriendsCB:SetScript("OnClick", function()
        ignoreOptionDB.exceptionFriends = not(not self.exceptionFriendsCB:GetChecked())
	end)

    self.exceptionRaidCB = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
	self.exceptionRaidCB:SetPoint("TOPLEFT", 300, -523)
	self.exceptionRaidCB.Text:SetText("Рейд")
    self.exceptionRaidCB:SetChecked(ignoreOptionDB.exceptionRaid)
    self.exceptionRaidCB:SetScript("OnClick", function()
        ignoreOptionDB.exceptionRaid = not(not self.exceptionRaidCB:GetChecked())
	end)



    --------------------------
    -- Фильтрация сообщений --
    --------------------------
    local function messageFilter(self, event, msg, author)
        if (ignoreOptionDB.isEnabled) then

            if (ignoreOptionDB.ignoreEveryoneMode) then
                if (#ignoreOptionDB.playersExceptionList > 0) then
                    for i = 1, #ignoreOptionDB.playersExceptionList do
                        if (ignoreOptionDB.playersExceptionList[i].playerName == author) then
                            return false
                        end
                    end
                end

                if (ignoreOptionDB.exceptionFriends) then
                    if (friendCheck(author)) then
                        return false
                    end
                end

                if (ignoreOptionDB.exceptionGuild) then
                    if (guildMemberCheck(author)) then
                        return false
                    end
                end

                if (ignoreOptionDB.exceptionRaid) then
                    if (raidMemberCheck(author)) then
                        return false
                    end
                end
                
                return true
            end

            if (ignoreOptionDB.ignorePlayerMode) then
                if (#ignoreOptionDB.playersIgnoreList > 0) then
                    for i = 1, #ignoreOptionDB.playersIgnoreList do
                        if (ignoreOptionDB.playersIgnoreList[i].playerName == author) then
                            playSound = false
                            return true
                        end
                    end
                end
            end

            if (ignoreOptionDB.ignoreInBattleMode) then
                if (ignoreOptionDB.exceptionFriends) then
                    if (friendCheck(author)) then
                        return false
                    end
                end

                if (ignoreOptionDB.exceptionGuild) then
                    if (guildMemberCheck(author)) then
                        return false
                    end
                end

                if (ignoreOptionDB.exceptionRaid) then
                    if (raidMemberCheck(author)) then
                        return false
                    end
                end

                inInstance, instanceType = IsInInstance()
                if (inInstance) then
                    if (instanceType == "raid") then
                        if (#ignoreOptionDB.playersExceptionList > 0) then
                            for i = 1, #ignoreOptionDB.playersExceptionList do
                                if (ignoreOptionDB.playersExceptionList[i].playerName == author) then
                                    return false
                                end
                            end
                        end

                        return inCombat
                    end
                end
            end

        end
    end

    local prompt = CreateFrame("Frame", nil, self)
    prompt:SetPoint("TOPLEFT", 80, -10)
    prompt:SetWidth(350)
    prompt:SetHeight(40)
    prompt:SetFrameStrata("BACKGROUND")
    prompt:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    prompt:SetBackdropColor(0, 0, 0, 1)
    prompt:SetBackdropBorderColor(1, 1, 1, .4)
    prompt.text = prompt:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    prompt.text:SetPoint("CENTER", prompt, "CENTER", 0, 0)
    prompt.text:SetTextHeight(12)
    prompt.text:SetText("Убирает/отключает входящие личные сообщения из чата.")
    prompt:Hide()

    self.enabledCB:SetScript("OnEnter", function ()
        prompt:Show()
    end)
    self.enabledCB:SetScript("OnLeave", function ()
        prompt:Hide()
    end)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", messageFilter)
end

local playSoundFrame = CreateFrame("Frame")
playSoundFrame:RegisterEvent("CHAT_MSG_WHISPER")
playSoundFrame:SetScript("OnEvent", function(self, event, msg, sender)

    local function playGeneralSound()
        PlaySoundFile(soundsList[soundOptionDB.generalSound].path, "Master")
    end

    local function playFriendSound()
        for i = 1, #soundOptionDB.playersSoundList do
            if (soundOptionDB.playersSoundList[i].playerName == sender) then
                PlaySoundFile(soundOptionDB.playersSoundList[i].soundPath, "Master")
                return
            end
        end
        playGeneralSound()
    end

    local function playSound(typePlaySound)
        if (ignoreOptionDB.isEnabled) then
                    
            if (ignoreOptionDB.ignoreEveryoneMode) then
                if (#ignoreOptionDB.playersExceptionList > 0) then
                    for y = 1, #ignoreOptionDB.playersExceptionList do
                        if (ignoreOptionDB.playersExceptionList[y].playerName == sender) then
                            if (typePlaySound == "friend") then
                                playFriendSound()
                            elseif (typePlaySound == "general") then
                                playGeneralSound()
                            end
                            return
                        end
                    end
                end

                if (ignoreOptionDB.exceptionFriends) then
                    if (friendCheck(sender)) then
                        if (typePlaySound == "friend") then
                            playFriendSound()
                        elseif (typePlaySound == "general") then
                            playGeneralSound()
                        end
                        return
                    end
                end

                if (ignoreOptionDB.exceptionGuild) then
                    if (guildMemberCheck(sender)) then
                        if (typePlaySound == "friend") then
                            playFriendSound()
                        elseif (typePlaySound == "general") then
                            playGeneralSound()
                        end
                        return
                    end
                end

                if (ignoreOptionDB.exceptionRaid) then
                    if (raidMemberCheck(sender)) then
                        if (typePlaySound == "friend") then
                            playFriendSound()
                        elseif (typePlaySound == "general") then
                            playGeneralSound()
                        end
                        return
                    end
                end

                if (ignoreOptionDB.ignoreInBattleMode == false and ignoreOptionDB.ignorePlayerMode == false) then
                    return
                end
            end

            if (ignoreOptionDB.ignorePlayerMode) then
                if (#ignoreOptionDB.playersIgnoreList > 0) then
                    for i = 1, #ignoreOptionDB.playersIgnoreList do
                        if (ignoreOptionDB.playersIgnoreList[i].playerName == sender) then
                            return
                        end
                    end
                end
            end

            if (ignoreOptionDB.ignoreInBattleMode) then
                if (ignoreOptionDB.exceptionFriends) then
                    if (friendCheck(sender)) then
                        if (typePlaySound == "friend") then
                            playFriendSound()
                        elseif (typePlaySound == "general") then
                            playGeneralSound()
                        end
                        return
                    end
                end

                if (ignoreOptionDB.exceptionGuild) then
                    if (guildMemberCheck(sender)) then
                        if (typePlaySound == "friend") then
                            playFriendSound()
                        elseif (typePlaySound == "general") then
                            playGeneralSound()
                        end
                        return
                    end
                end

                if (ignoreOptionDB.exceptionRaid) then
                    if (raidMemberCheck(sender)) then
                        if (typePlaySound == "friend") then
                            playFriendSound()
                        elseif (typePlaySound == "general") then
                            playGeneralSound()
                        end
                        return
                    end
                end

                inInstance, instanceType = IsInInstance()
                if (inInstance) then
                    if (instanceType == "raid") then
                        if (#ignoreOptionDB.playersExceptionList > 0) then
                            for i = 1, #ignoreOptionDB.playersExceptionList do
                                if (ignoreOptionDB.playersExceptionList[i].playerName == sender) then
                                    if (typePlaySound == "friend") then
                                        playFriendSound()
                                    elseif (typePlaySound == "general") then
                                        playGeneralSound()
                                    end
                                    return
                                end
                            end
                        end

                        if (inCombat) then
                            return
                        end
                    end
                end
            end

            if (typePlaySound == "friend") then
                playFriendSound()
            elseif (typePlaySound == "general") then
                playGeneralSound()
            end
            return
        else
            if (typePlaySound == "friend") then
                playFriendSound()
            elseif (typePlaySound == "general") then
                playGeneralSound()
            end
            return
        end
    end

    if (mainOptionDB.isEnabled) then
        if (soundOptionDB.isEnabled) then
            if (#soundOptionDB.playersSoundList > 0) then
                playSound("friend")
            else
                playSound("general")
            end
        end
    end
end)

SlashCmdList.MSGMNR = function(msg, editBox)
	InterfaceOptionsFrame_OpenToCategory(fOption)
end

SLASH_MSGMNR1 = "/mm"
SLASH_MSGMNR2 = "/messagemanager"