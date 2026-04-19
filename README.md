# Animation Blueprint DSL Editor

A visual editor for designing Unreal Engine Animation Blueprint state machines using YAML/JSON.

![Editor Preview](docs/preview.png)

## Features

- **Visual State Machine Editor** - Drag, connect, and configure states with a node-based interface
- **YAML/JSON Export** - Generate machine-readable DSL from your visual design
- **Transition Conditions** - Define state transition rules with variable comparisons
- **Local-First** - No server required, works entirely in your browser
- **Open Source** - MIT licensed, contribution-friendly

## Quick Start

### 1. Start the Editor

**Option A: Double-click (Windows)**
```bash
cd editor
start-server.bat
```

**Option B: Manual Start**
```bash
cd editor
python -m http.server 8080
# or
npx serve .
```

### 2. Open in Browser

Navigate to: **http://localhost:8080**

### 3. Create Your State Machine

1. Click **加载示例** to load a sample locomotion blueprint
2. Double-click the canvas to add new states
3. Double-click a state, then click another to create transitions
4. Edit state/transition properties in the right panel
5. Click **保存 YAML** to export

## Usage with Claude

After designing your state machine:

1. Save the YAML file to your project's `animation-dsl/examples/` folder
2. Tell Claude to implement it:

```
"Parse /Game/Characters/ABP_Player.yaml and create the Animation Blueprint"
```

Claude will generate the actual UE Animation Blueprint from your DSL definition.

## DSL Format

```yaml
format_version: "1.0"
metadata:
  name: "ABP_Player"
  skeleton: "/Game/Characters/SK_Mannequin"

state_machines:
  Locomotion:
    states:
      - name: Idle
        animation:
          type: sequence
          asset: "/Game/Animations/Idle_Loop"
      - name: Walk
        animation:
          type: blendspace1d
          asset: "/Game/Animations/BS_Walk"
          parameters:
            Speed: Speed

    transitions:
      - from: Idle
        to: Walk
        conditions:
          - variable: Speed
            operator: greater
            value: 10
        duration: 0.2

    entry_state: Idle
```

## Supported Features

| Feature | Status |
|---------|--------|
| State machine creation | ✅ |
| State definition | ✅ |
| Animation assignment | ✅ |
| Transitions with conditions | ✅ |
| Transition duration | ✅ |
| Entry state | ✅ |
| Blueprint variables | ✅ |
| BlendSpace parameter bindings | ✅ |

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `Delete` | Delete selected state/transition |
| `Escape` | Cancel current operation |

## Browser Compatibility

| Browser | Support |
|---------|---------|
| Chrome 86+ | ✅ Full (File System Access API) |
| Edge 86+ | ✅ Full (File System Access API) |
| Firefox | ⚠️ Limited (no file picker) |
| Safari | ⚠️ Limited (no file picker) |

## File Structure

```
animation-dsl/
├── editor/                    # Visual editor
│   ├── index.html
│   ├── start-server.bat
│   └── lib/                  # Bundled dependencies
├── examples/                 # Example blueprints
│   └── ABP_Player.yaml
├── docs/                     # Documentation assets
├── SPEC.md                   # DSL specification
├── README.md
├── LICENSE
└── CONTRIBUTING.md
```

## Technology Stack

- [vis-network](https://visjs.github.io/vis-network/docs/) - Graph visualization
- [js-yaml](https://github.com/nodeca/js-yaml) - YAML serialization
- Vanilla JavaScript - No framework dependencies

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
