--[[


  
       Alina                                                                                                                                                  
]] --
-- Alina



--[[

Alina Strucid

OPEN SOURCE VERSION: I wont be maintaining the old version of the code so its open source now.

]]--

-- fly script
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
--local Mouse=Player:GetMouse();
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

-- not really a silent aim just shoots the closest enemy player lol
-- also could be patched since i havent updated it for awhile 
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
        local oldFunc   = gunModule.ConeOfFire

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
  
-- Hitbox (No Collision)
tab:Label("> Hitbox (No Collision)")
local function hitboxesNoCollision()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game:GetService("Players").LocalPlayer then
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local success, err = pcall(function()
                    rootPart.CanCollide = not hitboxEnabled
                    rootPart.Transparency = hitboxEnabled and hitboxTransparency or 0
                    rootPart.Size = hitboxEnabled and Vector3.new(hitboxSize, hitboxSize, hitboxSize) or originalHitboxSize
                    rootPart.CollisionGroup = hitboxEnabled and "PlayerHitbox" or "Default"
                end)
                if not success then
                    warn("Error modifying the hitbox:", err)
                end
            end
        end
    end
end
  
tab:Toggle("Hitbox", false, function(state)
    hitboxEnabled = state
  
    if state then
        connection = game:GetService("RunService").Stepped:Connect(hitboxesNoCollision)
    else
        if connection then
            connection:Disconnect()
        end
        hitboxesNoCollision()
    end
end)
  
tab:Slider("Hitbox Size", 1, 50, hitboxSize, function(value)
    hitboxSize = value
    hitboxesNoCollision()
end)
  
tab:Slider("Hitbox Transparency", 0, 1, hitboxTransparency, function(value)
    hitboxTransparency = value
    hitboxesNoCollision()
end)
  
-- Visuals tab
local Visual = win:Tab("Visuals")
Visual:Label("> ESP")
-- kiriot22s esp
local aj = loadstring(game:HttpGet("https://raw.githubusercontent.com/StevenK-293/Loadstrings/main/esp.lua"))()
  
Visual:Toggle("Enable Esp (Won't Work For FFA)", false, function(K)
    aj:Toggle(K)
    aj.Players = K
end)
  
Visual:Toggle("Tracers Esp", false, function(K)
    aj.Tracers = K
end)
  
Visual:Toggle("Name Esp", false, function(K)
    aj.Names = K
end)
  
Visual:Toggle("Boxes Esp", false, function(K)
    aj.Boxes = K
end)
  
Visual:Toggle("TeamColor", false, function(L)
    aj.TeamColor = L
end)
  
Visual:Toggle("TeamMates", false, function(L)
    aj.TeamMates = L
end)
  
Visual:Colorpicker("ESP Color", Color3.fromRGB(0, 0, 255), function(P)
    aj.Color = P
end)
  
-- Player tab
local tab3 = win:Tab("Player")
tab3:Label("> Fly")
tab3:Toggle("Fly", false, function(state)
    if state then
        startFly()
    else
        endFly()
    end
end)

tab3:Label("> God Mode")

-- God Mode Toggle
local godModeEnabled = false
tab3:Toggle("God Mode", false, function(state)
    godModeEnabled = state
    local function setGodMode()
        if godModeEnabled then
            -- Make the player invincible by disabling damage taking
            p.Character:FindFirstChild("Humanoid").Health = math.huge
            p.Character:FindFirstChild("Humanoid").MaxHealth = math.huge
        else
            -- Revert health back to default values (you can adjust the health values here as needed)
            p.Character:FindFirstChild("Humanoid").Health = p.Character:FindFirstChild("Humanoid").MaxHealth
            p.Character:FindFirstChild("Humanoid").MaxHealth = 100
        end
    end
    -- Keep the god mode active as long as the toggle is on
    setGodMode()
    p.Character:WaitForChild("Humanoid").Changed:Connect(function()
        setGodMode()
    end)
end)

-- Speed hack
tab3:Label("> Speed Hack")

local speedEnabled = false
local speedAmount = 100
tab3:Toggle("Speed Hack", false, function(state)
    speedEnabled = state
    local function setSpeed()
        if speedEnabled then
            -- Change walking speed
            p.Character.Humanoid.WalkSpeed = speedAmount
        else
            p.Character.Humanoid.WalkSpeed = 16 -- default walk speed
        end
    end
    setSpeed()
    p.Character.Humanoid.Changed:Connect(function()
        setSpeed()
    end)
end)

tab3:Slider("Speed Amount", 16, 500, speedAmount, function(value)
    speedAmount = value
    if speedEnabled then
        p.Character.Humanoid.WalkSpeed = value
    end
end)

-- Fly speed adjustment
tab3:Slider("Fly Speed", 50, 500, flySettings.flyspeed, function(value)
    flySettings.flyspeed = value
end)

-- Reset all
tab3:Button("Reset All Settings", function()
    -- Reset all toggles and settings to default values
    godModeEnabled = false
    speedEnabled = false
    flySettings.flyspeed = 50
    hitboxEnabled = false
    hitboxSize = 20
    hitboxTransparency = 0
    silentAimEnabled = false
    tab3:Toggle("Fly", false)
    tab3:Toggle("God Mode", false)
    tab3:Toggle("Speed Hack", false)
    tab3:Slider("Speed Amount", 16, 500, 100, function() end)
    tab3:Slider("Fly Speed", 50, 500, 50, function() end)
    tab3:Slider("Hitbox Size", 1, 50, 20, function() end)
    tab3:Slider("Hitbox Transparency", 0, 1, 0, function() end)
end)

-- Fly Mode and God Mode toggle button
tab3:Button("Enable Fly and God Mode", function()
    tab3:Toggle("Fly", true)
    tab3:Toggle("God Mode", true)
end)

