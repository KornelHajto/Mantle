local Mantle = require("mantle.init")

Mantle.Window({
    width = 400,
    height = 500,
    title = "Login",
    draggable = true
})

-- APP STATE
local username = ""
local password = "" -- We won't hide chars yet, but it's a separate input
local rememberMe = false

Mantle.Run(function()
    Mantle.Clear()
    Mantle.Rect(0, 0, 400, 600, { 240, 240, 240 })

    Mantle.Column(50, 50, 20, function()
        Mantle.Text("Welcome Back", 30, { 50, 50, 50 })

        Mantle.Text("Username:", 20, { 100, 100, 100 })
        -- Syntax: variable = Mantle.Input(variable, placeholder)
        username = Mantle.Input(username, "Enter username...")

        Mantle.Text("Password:", 20, { 100, 100, 100 })
        password = Mantle.Input(password, "Enter password...")

        rememberMe = Mantle.Checkbox("Remember me", rememberMe)

        -- Add some space
        Mantle.Row(nil, nil, 0, function() end)

        if Mantle.Button("Login", nil, nil, 200) then
            print("Login Attempt:", username, password)
        end

        -- Debug View
        Mantle.Text("You typed: " .. username, 10, { 150, 150, 150 })
    end)
end)
