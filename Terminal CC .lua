-- === SECURE TERMINAL (CC:TWEAKED VERSION) ===

-- USER DATABASE
local users = {
    Mike = {
        password = "Lt.Mike",
        organization = "FurrArmy",
        division = "Federal Government",
        rank = "FGC-1",
        clearance = 10
    },
    Travis = {
        password = "Reelmind",
        organization = "Reelmind Corp.",
        division = "Head of Reelmind Corp.",
        rank = "HoRC",
        clearance = 10
    },
    GSP_LR_R = {
        password = "Recruit",
        organization = "FurrArmy",
        division = "Ground Service Personal",
        rank = "Recruit",
        clearance = 1
    },
    FA_Guest = {
        password = "Guest",
        organization = "FurrArmy",
        division = "Guest/Visitor",
        rank = "Visitor",
        clearance = 0
    }
}

-- DOCUMENT DATABASE
local docs = {
    {
        id = "FA_DOC_001",
        title = "Operation Paw",
        organization = "FurrArmy",
        divisions = {"Federal Government"},
        ranks = {"FGC-1"},
        clearance = 5
    },
    {
        id = "FA_DOC_003",
        title = "Guest Info",
        organization = "FurrArmy",
        divisions = {"Guest/Visitor"},
        ranks = {"Visitor"},
        clearance = 0
    },
    {
        id = "RM_DOC_001",
        title = "Surveillance Protocol",
        organization = "Reelmind Corp.",
        divisions = {"Head of Reelmind Corp."},
        ranks = {"HoRC"},
        clearance = 7
    }
}

local currentUser = nil

-- Slow print
local function slowPrint(text, speed)
    speed = speed or 0.02
    for i = 1, #text do
        write(text:sub(i,i))
        sleep(speed)
    end
    print()
end

-- Login
local function login()
    term.clear()
    term.setCursorPos(1,1)
    print("=== SECURE TERMINAL ===\n")

    write("Username: ")
    local username = read()

    write("Password: ")
    local password = read("*")

    local user = users[username]

    if user and user.password == password then
        currentUser = user
        print("\nACCESS GRANTED\n")
        print("Welcome " .. username)
        print("Org: " .. user.organization)
        print("Division: " .. user.division)
        print("Rank: " .. user.rank)
        print("Clearance: " .. user.clearance)
        sleep(2)
        return true
    else
        print("\nACCESS DENIED")
        sleep(2)
        return false
    end
end

-- Find document
local function getDoc(id)
    for _, doc in ipairs(docs) do
        if doc.id == id then return doc end
    end
end

-- Check access
local function hasAccess(user, doc)
    if user.organization ~= doc.organization then return false end

    local divisionOK = false
    for _, d in ipairs(doc.divisions) do
        if d == user.division then divisionOK = true end
    end

    local rankOK = false
    for _, r in ipairs(doc.ranks) do
        if r == user.rank then rankOK = true end
    end

    return divisionOK and rankOK and user.clearance >= doc.clearance
end

-- Open document
local function openDocument(id)
    local doc = getDoc(id)

    if not doc then
        slowPrint("DOCUMENT NOT FOUND")
        return
    end

    if not hasAccess(currentUser, doc) then
        slowPrint("ACCESS DENIED: INSUFFICIENT CLEARANCE")
        return
    end

    -- Content generation
    if id == "FA_DOC_001" then
        slowPrint([[
FA_DOC_001 - Operation Paw
STATUS: ACTIVE

MISSION:
Infiltration and containment protocol initiated.
        ]])
    elseif id == "FA_DOC_003" then
        slowPrint([[
FA_DOC_003 - Guest Info

Welcome Visitor.
More content coming soon.
        ]])
    elseif id == "RM_DOC_001" then
        slowPrint([[
RM_DOC_001 - Surveillance Protocol
STATUS: ENCRYPTED

All communications are monitored.
        ]])
    else
        slowPrint("DATA CORRUPTED")
    end
end

-- List docs
local function listDocs()
    for _, doc in ipairs(docs) do
        if hasAccess(currentUser, doc) then
            print("[ACCESS] " .. doc.id .. " - " .. doc.title)
        else
            print("[DENIED] " .. doc.id)
        end
    end
end

-- Terminal loop
local function terminal()
    while true do
        write("\n> ")
        local input = read()

        local cmd, arg = input:match("^(%S+)%s*(.*)$")

        if cmd == "open" then
            openDocument(arg)

        elseif cmd == "help" then
            print("COMMANDS:")
            print("open <DOC_ID>")
            print("docs")
            print("logout")

        elseif cmd == "docs" then
            listDocs()

        elseif cmd == "logout" then
            break

        else
            print("UNKNOWN COMMAND")
        end
    end
end

-- MAIN LOOP
while true do
    if login() then
        terminal()
    end
end
