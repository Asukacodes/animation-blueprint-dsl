# About Animation Blueprint DSL

## What is This?

Animation Blueprint DSL is an open-source tool that makes Unreal Engine animation state machines **designable as code**.

Instead of clicking through the Animation Blueprint editor, you define your animation system in a simple YAML format:

```yaml
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
    transitions:
      - from: Idle
        to: Walk
        conditions:
          - variable: Speed
            operator: greater
            value: 10
```

Then let Claude generate the actual Animation Blueprint from this definition.

## Why?

| Traditional | With DSL |
|-------------|----------|
| Click through editor UI | Write YAML or use visual editor |
| Hard to version control | Git-friendly text format |
| Difficult to review | Easy to diff and understand |
| Time-consuming | Fast iteration with AI |

## Features

- **Visual Editor** - Drag-and-drop state machine design
- **YAML Export** - Human-readable, version-controllable format
- **AI Integration** - Claude generates UE blueprints from DSL
- **Local-First** - Works offline in your browser
- **Open Source** - MIT licensed, community-driven

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Visual     │     │   YAML      │     │   Claude    │
│  Editor     │ ──▶ │  Definition │ ──▶ │   Agent     │
└─────────────┘     └─────────────┘     └─────────────┘
                                               │
                                               ▼
                                      ┌─────────────┐
                                      │  Unreal     │
                                      │  Animation  │
                                      │  Blueprint  │
                                      └─────────────┘
```

## Technology

- **vis-network** - Interactive graph visualization
- **js-yaml** - YAML parsing and serialization
- **Vanilla JS** - Zero framework dependencies

## Browser Support

| Browser | Status | Notes |
|---------|--------|-------|
| Chrome 86+ | ✅ Full | File System Access API support |
| Edge 86+ | ✅ Full | Chromium-based |
| Firefox | ⚠️ Limited | Uses download fallback |
| Safari | ⚠️ Limited | Uses download fallback |

## License

MIT License - Free for personal and commercial use.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Related Projects

- [UnrealClaude](https://github.com/Asukacodes/UnrealClaude) - Claude integration for Unreal Engine
- [Unreal Engine Animation System](https://docs.unrealengine.com/AnimationOverview/) - Official UE docs
