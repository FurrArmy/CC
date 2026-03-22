-- === REMOTE TERMINAL CLIENT ===

local modem = peripheral.find("modem")
if not modem then error("No modem!") end
rednet.open(peripheral.getName(modem))

print("Searching for server...")

rednet.broadcast("connect")

local serverID, msg = rednet.receive(5)

if not serverID then
    print("No server found.")
    return
end

print("Connected to server: " .. serverID)

-- Receive messages in parallel
local function receiver()
    while true do
        local id, msg = rednet.receive()
        if id == serverID then
            print(msg)
        end
    end
end

-- Send commands
local function sender()
    while true do
        write("> ")
        local input = read()
        rednet.send(serverID, input)
    end
end

parallel.waitForAny(receiver, sender)
