local VirtualInputManager = Instance.new('VirtualInputManager')
local GuiService = game:GetService('GuiService')

getgenv().firesignal = function(button)
    if not button or not button.Parent then return end;

    GuiService.SelectedObject = button;

    VirtualInputManager:SendKeyEvent(true, 'Return', false, game)
    task.wait(.1)
    VirtualInputManager:SendKeyEvent(false, 'Return', false, game)

    task.wait(.5)
    GuiService.SelectedObject = nil;
end;

while task.wait(10) do
    local Player = game:GetService("Players")

    local Check = Player.LocalPlayer.PlayerGui.CharacterCreator.Enabled
    local Button = Player.LocalPlayer.PlayerGui.CharacterCreator.EditorFrame.ItemsNextButton.TextLabel

    if Check == true then
        firesignal(Button)
    end
end
