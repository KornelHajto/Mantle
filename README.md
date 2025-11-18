# Mantle UI Framework

<p align="center">
  <img src="https://raw.githubusercontent.com/KornelHajto/Mantle/main/images/weather.png" width="48%">
  <img src="https://raw.githubusercontent.com/KornelHajto/Mantle/main/images/graph.png" width="48%">
</p>

**Mantle** is a lightweight, cross-platform **Immediate-Mode UI (IMGUI)** framework built on **Lua** and the **Raylib** library.

It abstracts away the complexities of the game loop, z-ordering, and coordinate management, allowing you to quickly build sleek, declarative desktop widgets and applications that run efficiently on Windows, Linux, and macOS.

---

## 🚀 Core Features

* **Declarative API:** Build complex UIs using simple, nested function calls (e.g., `Mantle.Column`, `Mantle.Button`).
* **Automatic Layout:** Features a **Cursor-based Layout Engine** (`Row`/`Column`) to eliminate manual X/Y coordinate math.
* **Layering (Z-Index Protection):** Popups and Dropdown menus float on a separate layer and automatically block input to widgets underneath them.
* **Input Blocking System:** Prevents click bleed-through when dropdowns or modals overlay other interactive elements.
* **Cross-Platform Ready:** The same Lua code compiles to executables for Windows and Linux.
* **High Performance:** Uses LuaJIT and Raylib's GPU-backed drawing for smooth, fast, and low-resource consumption.

---

## 🛠️ Getting Started

### Prerequisites

1. **Lua Runner:** Download the pre-compiled `raylua_s` executable for your specific OS from the **TSnake41/raylib-lua** repository and place it in a `bin/` folder.
2. **Assets:** Ensure your required `.ttf` font files (e.g., `roboto.ttf`) are placed in the `assets/` directory.

### Running the Demo

Run the application from your repository root using the appropriate starter script:

```bash
# Windows
.\start.bat

```
Currently no unix version.

---

## 📖 Example Usage (Clean API)

```lua
local Mantle = require("mantle.init")

-- 1. Configuration (Only sets global variables)
Mantle.Window({
    width = 350,
    height = 600,
    draggable = true,
    transparent = true
})

-- 2. Asset Loading (Uses the built-in cache)
Mantle.LoadFont("assets/roboto.ttf", 20)

-- 3. The Loop (Purely Declarative Drawing)
Mantle.Run(function()
    Mantle.Clear() 
    
    Mantle.Panel(0, 0, 350, 600, {24, 71, 99, 255}) 

    Mantle.Column(20, 20, 280, 500, 15, function()
        Mantle.Text("MANTLE DEMO", 24, {137, 180, 250})
        Mantle.Spacer(15)
        
        if Mantle.Button("Open Settings", nil, nil, 200, 40) then
            print("Button clicked!")
        end
        
        Mantle.Row(nil, nil, 280, 30, 10, function()
            Mantle.Text("Status:", 16, {255, 255, 255})
            Mantle.Fill() -- Pushes next item to the right
            Mantle.Text("ONLINE", 16, {0, 255, 170})
        end)
    end)
end)
```

---

## 📚 Framework API Reference

### Window & Configuration

| Function | Purpose | Example |
|----------|---------|---------|
| `Mantle.Window(settings)` | Configures window properties (width, height, title, etc.) | `Mantle.Window({width = 800, height = 600})` |
| `Mantle.Run(drawCallback)` | Main loop - executes the draw callback every frame | `Mantle.Run(function() ... end)` |
| `Mantle.LoadFont(path, size)` | Loads a TrueType font and sets it as the default theme font | `Mantle.LoadFont("assets/roboto.ttf", 20)` |
| `Mantle.Clear(color)` | Clears the screen with optional color (transparent by default) | `Mantle.Clear()` |

### Layout Helpers

| Function | Purpose | Example |
|----------|---------|---------|
| `Mantle.Column(x, y, w, h, padding, func)` | Arranges nested items vertically with automatic spacing | `Mantle.Column(20, 20, 400, 500, 10, function() ... end)` |
| `Mantle.Row(x, y, w, h, padding, func)` | Arranges nested items horizontally with automatic spacing | `Mantle.Row(nil, nil, 400, 50, 10, function() ... end)` |
| `Mantle.Spacer(size)` | Adds a fixed, rigid gap (in pixels) | `Mantle.Spacer(15)` |
| `Mantle.Fill()` | Adds flexible space, pushing subsequent items to the edge | `Mantle.Text("Left"); Mantle.Fill(); Mantle.Text("Right")` |

**Note:** Use `nil` for `x` and `y` parameters to use the current layout cursor position.

### Widget API

| Widget | Usage | Return Type | Example |
|--------|-------|-------------|---------|
| `Mantle.Button(text, x, y, w, h)` | Interactive button, returns `true` on click | `boolean` | `if Mantle.Button("Click Me", nil, nil, 120, 40) then ... end` |
| `Mantle.Checkbox(label, checked, x, y)` | Toggle checkbox with label | `boolean` | `checked = Mantle.Checkbox("Enable", checked)` |
| `Mantle.Slider(value, x, y, width)` | Horizontal slider for numeric values (0.0 to 1.0) | `number` | `volume = Mantle.Slider(volume, nil, nil, 200)` |
| `Mantle.Input(text, placeholder, x, y, w)` | Text input field with keyboard support | `string` | `name = Mantle.Input(name, "Enter name...")` |
| `Mantle.Dropdown(options, index, x, y, w)` | Dropdown menu with selectable items | `number` | `selected = Mantle.Dropdown({"Low", "High"}, selected)` |
| `Mantle.Text(text, size, color, x, y)` | Draws text at specified position | `void` | `Mantle.Text("Hello", 20, {255, 255, 255})` |
| `Mantle.Panel(x, y, w, h, color, contentFunc)` | Draws a colored rectangle panel, optionally with content | `void` | `Mantle.Panel(0, 0, 300, 400, {40, 40, 40, 255})` |
| `Mantle.ScrollArea(width, height, contentFunc)` | Scrollable container with mouse wheel support | `void` | `Mantle.ScrollArea(400, 300, function() ... end)` |

### Advanced Features

#### Layer System (Z-Index)

Use `Mantle.Layer()` to defer rendering until after the main UI is drawn. This is essential for popups and dropdowns that need to appear on top.

```lua
Mantle.Layer(function()
    -- This content draws AFTER everything else
    Mantle.Panel(100, 100, 200, 150, {50, 50, 50, 255})
    Mantle.Text("I'm on top!", 16, {255, 255, 255}, 120, 120)
end)
```

#### Input Blocking

The framework automatically handles input blocking for layered content (like dropdowns). When a dropdown menu is open:

1. `Mantle.SetInputBlock(x, y, w, h)` is called by the dropdown widget
2. All widgets check `Mantle.IsMouseBlocked()` before responding to clicks
3. Only the dropdown menu area remains interactive

**Debug Mode:** The framework draws a red rectangle around blocked areas for debugging.

### Drawing Primitives

| Function | Purpose | Example |
|----------|---------|---------|
| `Mantle.Rect(x, y, w, h, color)` | Draws a filled rectangle | `Mantle.Rect(10, 10, 100, 50, {255, 0, 0, 255})` |
| `Mantle.Line(x1, y1, x2, y2, color, thickness)` | Draws a line between two points | `Mantle.Line(0, 0, 100, 100, {255, 255, 255, 255}, 2)` |
| `Mantle.Circle(x, y, radius, color)` | Draws a filled circle | `Mantle.Circle(50, 50, 25, {0, 255, 0, 255})` |

---

## 🎨 Theme System

Mantle uses a global theme object that can be customized:

```lua
-- Access and modify theme colors
Mantle.Theme.colors.primary = {60, 68, 76, 255}
Mantle.Theme.colors.text = {255, 255, 255, 255}
Mantle.Theme.colors.accent = {137, 180, 250, 255}
Mantle.Theme.colors.highlight = {69, 71, 90, 255}

-- Font and size are set via LoadFont
Mantle.LoadFont("assets/roboto.ttf", 20)
```

---

## 🏗️ Project Structure

```
Mantle/
├── mantle/
│   ├── init.lua          # Main framework entry point
│   ├── core.lua          # Core utilities
│   ├── layout.lua        # Layout engine (Row/Column)
│   ├── theme.lua         # Theme configuration
│   ├── assets.lua        # Asset loading and caching
│   └── widgets/
│       ├── button.lua
│       ├── checkbox.lua
│       ├── slider.lua
│       ├── input.lua
│       ├── dropdown.lua
│       ├── scroll.lua
│       └── panel.lua
├── demo/
│   └── assets/
|      └── font & images/       # Fonts and images
│   └── demos
├── main.lua              # Your application entry point
└── start.bat              # Windows start script
```

---

## 🔧 Advanced Topics

### State Management

Mantle follows the IMGUI pattern - widgets are **stateless**. You manage state in your application:

```lua
local counter = 0

Mantle.Run(function()
    if Mantle.Button("Increment", nil, nil, 150, 40) then
        counter = counter + 1
    end
    
    Mantle.Text("Count: " .. counter, 20, {255, 255, 255})
end)
```
### Custom Widgets

Create your own widgets by following the pattern:

```lua
-- mantle/widgets/mywidget.lua
return function(Mantle, param1, param2, x, y)
    local isBlocked = Mantle.IsMouseBlocked()
    local mouseX = rl.GetMouseX()
    local mouseY = rl.GetMouseY()
    
    -- Your widget logic here
    
    return result
end
```

Then add it to `mantle/init.lua`:

```lua
local mywidget_logic = require("mantle.widgets.mywidget")

function Mantle.MyWidget(param1, param2, x, y)
    local finalX, finalY = resolvePos(x, y)
    return mywidget_logic(Mantle, param1, param2, finalX, finalY)
end
```

---

## 🐛 Troubleshooting

### Common Issues

**Issue:** "attempt to call local 'contentFunc' (a nil value)"
- **Fix:** Ensure all `Mantle.Column()` and `Mantle.Row()` calls have 6 parameters: `(x, y, w, h, padding, contentFunc)`

**Issue:** Clicks bleed through dropdown menus
- **Fix:** Ensure your dropdown widget calls `Mantle.SetInputBlock()` inside the `Mantle.Layer()` callback

**Issue:** Font not loading
- **Fix:** Verify the font file exists in `assets/` and the path is correct

**Issue:** Application won't start
- **Fix:** Ensure you have the correct `raylua_s` executable for your OS in the `bin/` folder

---

📝 Acknowledgements & License
This project is open source and available under the MIT License.

A special thank you to the original terra project (https://github.com/chris-montero/terra) for providing the initial inspiration, design aesthetic, and the core concept of a clean, minimal desktop utility framework.

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Improve documentation

---

## 📧 Contact

For questions or support, please open an issue on the GitHub repository.

---

**Built with ❤️ using Lua and Raylib**
