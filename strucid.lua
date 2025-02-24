--[[

       Alina                                                                                                                                                 
]] --  
-- Alina

-- Fly script
local flySettings={fly=false,flyspeed=50}
local c local h local bv local bav local cam local flying local p=game.Players.LocalPlayer
local buttons={W=false,S=false,A=false,D=false,Moving=false}
local startFly=function()if not p.Character or not p.Character.Head or flying then return end c=p.Character h=c.Humanoid h.PlatformStand=true cam=workspace:WaitForChild('Camera') bv=Instance.new("BodyVelocity") bav=Instance.new("BodyAngularVelocity") bv.Velocity,bv.MaxForce,bv.P=Vector3.new(0,0,0),Vector3.new(10000,10000,10000),1000 bav.AngularVelocity,bav.MaxTorque,bav.P=Vector3.new(0,0,0),Vector3.new(10000,10000,10000),1000 bv.Parent=c.Head bav.Parent=c.Head flying=true h.Died:connect(function()flying=false end)end
local endFly=function()if not p.Character or not flying then return end h.PlatformStand=false bv:Destroy() bav:Destroy() flying=false end
game:GetService("UserInputService").InputBegan:connect(function(input,GPE)if GPE then return end for i,e in pairs(buttons)do if i~="Moving" and input.KeyCode==Enum.KeyCode[i]then buttons[i]=true buttons.Moving=true end end end)
game:GetService("UserInputService").InputEnded:connect(function(input,GPE)if GPE then return end local a=false for i,e in pairs(buttons)do if i~="Moving"then if input.KeyCode==Enum.KeyCode[i]then buttons[i]=false end if buttons[i]then a=true end end end buttons.Moving=a end)
local setVec=function(vec)return vec*(flySettings.flyspeed/vec.Magnitude)end
game:GetService("RunService").Heartbeat:connect(function(step)if flying and c and c.PrimaryPart then local p=c.PrimaryPart.Position local cf=cam.CFrame local ax,ay,az=cf:toEulerAnglesXYZ()c:SetPrimaryPartCFrame(CFrame.new(p.x,p.y,p.z)*CFrame.Angles(ax,ay,az))if buttons.Moving then local t=Vector3.new()if buttons.W then t=t+(setVec(cf.lookVector))end if buttons.S then t=t-(setVec(cf.lookVector))end if buttons.A then t=t-(setVec(cf.rightVector))end if buttons.D then t=t+(setVec(cf.rightVector))end c:TranslateBy(t*step)end end end)

local Players=game:GetService("Players");
local Player=Players.LocalPlayer;
local Workspace=game:GetService("Workspace");
local CurrentCam=Workspace.CurrentCamera;
local require=require;
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt"))()
local win = lib:Window("Alina | Strucid | V1 | Alina", Color3.fromRGB(44, 120, 224), Enum.KeyCode.P)

-- Hitbox settings
local hitboxEnabled = false
local hitboxTransparency = 0
local originalHitboxSize = Vector3.new(1, 1, 1)
local hitboxSize = 20

local tab = win:Tab("Main")
tab:Label("> Silent Aim")

-- Silent Aim feature (closest enemy)
local silentAimEnabled = false
tab:Toggle("Silent Aim", false, function(state)
    silentAimEnabled = state

    local function getClosestEnemy()
        local closestEnemy
        local shortestDistance = math.huge

        local myTeam = Player.Team

        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if myTeam then
                    local enemyTeam = myTeam.Name == "Blue" and "Red" or "Blue" 

                    if player.Team.Name == enemyTeam then
                        local character = player.Character
                        local rootPart = character:FindFirstChild("HumanoidRootPart")

                        if rootPart then
                            local distance = (rootPart.Position - CurrentCam.CFrame.Position).Magnitude

                            if distance < shortestDistance then
                                closestEnemy = player
                                shortestDistance = distance
                            end
                        end
                    end
                else -- FFA mode, no team
                    local character = player.Character
                    local rootPart = character:FindFirstChild("HumanoidRootPart")

                    if rootPart then
                        local distance = (rootPart.Position - CurrentCam.CFrame.Position).Magnitude

                        if distance < shortestDistance then
                            closestEnemy = player
                            shortestDistance = distance
                        end
                    end
                end
            end
        end

        return closestEnemy
    end
    local function run()
        task.wait()
        local gunModule = require(Players.PlayerGui:WaitForChild("MainGui").NewLocal.Tools.Tool.Gun)
        local oldFunc = gunModule.ConeOfFire

        gunModule.ConeOfFire = function(...)
            if silentAimEnabled then
                local closestEnemy = getClosestEnemy()

                if closestEnemy and closestEnemy.Character then
                    return closestEnemy.Character.Head.CFrame * CFrame.new(math.random(0.1, 0.25), math.random(0.1, 0.25), math.random(0.1, 0.25)).p
                end
            else
                return oldFunc(...)
            end
        end
    end
    run()
    Player.CharacterAdded:Connect(run)
end)

-- Hitbox Collide
tab:Label("> Hitbox Collide")
local function hitboxes()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game:GetService("Players").LocalPlayer then
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CanCollide = hitboxEnabled
                rootPart.Transparency = hitboxEnabled and hitboxTransparency or 0
                rootPart.Size = hitboxEnabled and Vector3.new(hitboxSize, hitboxSize, hitboxSize) or originalHitboxSize
            end
        end
    end
end

local connection
tab:Toggle("Hitbox", false, function(state)
    hitboxEnabled = state

    if state then
        connection = game:GetService("RunService").Stepped:Connect(hitboxes)
    else
        if connection then
            connection:Disconnect()
        end
        hitboxes()
    end
end)

tab:Slider("Hitbox Size", 1, 50, hitboxSize, function(value)
    hitboxSize = value
    hitboxes()
end)

tab:Slider("Hitbox Transparency", 0, 1, hitboxTransparency, function(value)
    hitboxTransparency = value
    hitboxes()
end)

-- Player Tab
local tab3 = win:Tab("Player")
tab3:Label("> Fly")
tab3:Toggle("Fly", false, function(state)
    if state then
        startFly()
    else
        endFly()
    end
end)

tab3:Slider("Fly Speed", 1, 500, 1, function(s)
    flySettings.flyspeed = s
end)

tab3:Label("> WalkSpeed")

local settings = {
    WalkSpeed = 16,
    JumpPower = 50
}

local function setWalkSpeed(value)
    settings.WalkSpeed = value
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChild("Humanoid")

    if humanoid then
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            humanoid.WalkSpeed = settings.WalkSpeed
        end)
        humanoid.WalkSpeed = settings.WalkSpeed
    end
end

tab3:Slider("Walkspeed", 16, 500, 16, function(value)
    setWalkSpeed(value)
end)

tab3:Label("> JumpPower")

local function setJumpPower(value)
    settings.JumpPower = value
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChild("Humanoid")

    if humanoid then
        humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
            humanoid.JumpPower = settings.JumpPower
        end)
        humanoid.JumpPower = settings.JumpPower
    end
end

tab3:Slider("JumpPower", 50, 500, 50, function(value)
    setJumpPower(value)
end)

local IJ = false
tab3:Toggle("Inf Jump", false, function(state)
    IJ = state
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if IJ then
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
        end
    end)
end)

-- Misc Tab with Key to Close Menu
local miscTab = win:Tab("Misc")
miscTab:Label("> Key to Close Menu")

local closeKey = Enum.KeyCode.P  -- Default key to close the menu

miscTab:Dropdown("Key to Close Menu", {"P", "Q", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M"}, function(value)
    closeKey = Enum.KeyCode[value]
end)

-- Close the UI when the specified key is pressed
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == closeKey then
        win:Close()
    end
end)

-- Notify user of successful setup
miscTab:Label("Press the selected key to close the menu")
