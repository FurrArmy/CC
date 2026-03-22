-- === REMOTE TERMINAL SERVER ===

local modem = peripheral.find("modem")
if not modem then error("No modem!") end
rednet.open(peripheral.getName(modem))

print("Server ready. Waiting for client...")

local clientID = nil

-- Wait for connection
while not clientID do
    local id, msg = rednet.receive()
    if msg == "connect" then
        clientID = id
        rednet.send(clientID, "CONNECTED")
        print("Client connected: " .. clientID)
    end
end

-- Redirect terminal output
local oldPrint = print
local function sendPrint(...)
    local text = table.concat({...}, " ")
    oldPrint(text)
    rednet.send(clientID, "[OUT] " .. text)
end

print = sendPrint

-- Main loop
while true do
    local id, msg = rednet.receive()

    if id == clientID then
        if msg == "exit" then
            print("Client disconnected.")
            clientID = nil
            break
        end

        print("> " .. msg)

        -- Run command safely
        local ok, err = pcall(function()
            shell.run(msg)
        end)

        if not ok then
            print("ERROR: " .. err)
        end
    end
end
