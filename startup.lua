-- === SECURE POCKET TERMINAL ===

local USERNAME = "Mike"
local PASSWORD = "FGC-1"

-- Colors (if supported)
term.setBackgroundColor(colors.black)
term.setTextColor(colors.lime)
term.clear()
term.setCursorPos(1,1)

-- Slow print
local function slowPrint(text, speed)
    speed = speed or 0.02
    for i = 1, #text do
        write(text:sub(i,i))
        sleep(speed)
    end
    print()
end

-- Boot animation
local function boot()
    slowPrint("Initializing Secure Link...", 0.03)
    sleep(0.3)
    slowPrint("Checking Clearance Database...", 0.03)
    sleep(0.3)
    slowPrint("Connecting to Facility Network...", 0.03)
    sleep(0.5)
    slowPrint("ACCESS NODE READY", 0.05)
    sleep(0.5)

    print("\n=== POCKET TERMINAL v1.0 ===\n")
end

-- Login system
local function login()
    while true do
        write("Username: ")
        local user = read()

        write("Password: ")
        local pass = read("*")

        if user == USERNAME and pass == PASSWORD then
            slowPrint("\nACCESS GRANTED", 0.03)
            sleep(0.5)
            return true
        else
            slowPrint("\nACCESS DENIED", 0.03)
            sleep(1)
            term.clear()
            term.setCursorPos(1,1)
        end
    end
end

-- Main UI
local function terminalUI()
    term.clear()
    term.setCursorPos(1,1)

    print("Welcome, Mike")
    print("Rank: FGC-1")
    print("Clearance Level: 10")
    print("\nType 'help' for commands.\n")

    while true do
        write("> ")
        local input = read()

        if input == "help" then
            print("COMMANDS:")
            print("help - show commands")
            print("clear - clear screen")
            print("exit - shutdown terminal")

        elseif input == "clear" then
            term.clear()
            term.setCursorPos(1,1)

        elseif input == "exit" then
            print("Shutting down...")
            sleep(1)
            os.shutdown()

        else
            print("UNKNOWN COMMAND")
        end
    end
end

-- Run system
boot()
login()
terminalUI()
