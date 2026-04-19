# Animation Blueprint DSL Specification

## Overview

This DSL defines Animation Blueprints in a declarative YAML format that can be:
1. **Read by AI** → Generate implementation via MCP tools
2. **Written by AI** → Export existing AnimBP to DSL
3. **Version controlled** → Track changes in git
4. **Validated** → Check for errors before implementation

## File Format

- Extension: `.animbp.yaml`
- Encoding: UTF-8
- Format version: `1.0`

---

## Complete Schema

```yaml
# ===== Header =====
format_version: "1.0"
metadata:
  name: "ABP_Character"              # Required: Blueprint name
  path: "/Game/Characters/"          # Required: Content path
  skeleton: "/Game/Characters/SK_Character"  # Required: Target skeleton
  description: "Main character locomotion"  # Optional

# ===== Variables =====
# Blueprint variables that can be used in conditions
variables:
  Speed:
    type: float
    default: 0.0
  Direction:
    type: float
    default: 0.0
  bIsInAir:
    type: bool
    default: false
  MovementMode:
    type: uint8
    default: 0

# ===== State Machines =====
state_machines:
  Locomotion:
    position: { x: 0, y: 0 }        # Graph position
    
    # ===== States =====
    states:
      Idle:
        position: { x: 100, y: 100 }
        animation:
          type: sequence
          asset: "/Game/Animations/Idle_LP"
        
      Walk:
        position: { x: 300, y: 100 }
        animation:
          type: blendspace1d
          asset: "/Game/Animations/BS_Walk"
          parameters:
            Speed: Speed              # Bind to variable
        
      Run:
        position: { x: 500, y: 100 }
        animation:
          type: blendspace2d
          asset: "/Game/Animations/BS_Locomotion"
          parameters:
            Speed: Speed
            Direction: Direction
        
      Jump:
        position: { x: 300, y: 300 }
        animation:
          type: montage
          asset: "/Game/Animations/Jump_Montage"
    
    # ===== Transitions =====
    transitions:
      # Simple transition (auto-condition: always allowed)
      - from: Idle
        to: Walk
        
      - from: Walk
        to: Run
        
      # Transition with conditions
      - from: Idle
        to: Run
        conditions:
          - variable: Speed
            operator: greater
            value: 300
        duration: 0.25                    # Blend time in seconds
        priority: 1                        # Higher = checked first
        
      # Complex transition with AND logic
      - from: Any
        to: Jump
        conditions:
          - variable: bIsInAir
            operator: equals
            value: true
        
      # Transition with OR logic
      - from: Run
        to: Idle
        conditions:
          - variable: Speed
            operator: less
            value: 50
          logic: OR                         # AND (default) or OR
          
    # ===== Entry State =====
    entry_state: Idle
    
    # ===== Output Connection =====
    connect_to_output: true

# ===== Blend Spaces (Definition) =====
# Note: Assets should exist; this defines parameter bindings
blend_spaces:
  BS_Locomotion:
    type: 2D                             # 1D or 2D
    skeleton: "/Game/Characters/SK_Character"
    axes:
      X:
        name: Speed
        min: 0
        max: 600
        grid_divisions: 10
      Y:
        name: Direction
        min: -180
        max: 180
        grid_divisions: 12
    samples:
      - [0, 0, "/Game/Anim/Idle_LP"]
      - [150, 0, "/Game/Anim/Walk_F"]
      - [150, 90, "/Game/Anim/Walk_R"]
      - [150, -90, "/Game/Anim/Walk_L"]
      - [400, 0, "/Game/Anim/Jog_F"]
      - [400, 90, "/Game/Anim/Jog_R"]
      - [400, -90, "/Game/Anim/Jog_L"]
      - [600, 0, "/Game/Anim/Sprint_F"]
      - [600, 45, "/Game/Anim/Sprint_FR"]
      - [600, -45, "/Game/Anim/Sprint_FL"]

# ===== Animation Notifies =====
notifies:
  - name: "FootstepSound"
    type: notify                    # notify or notify_state
    track: 0
    time: 0.3                       # Normalized time (0.0-1.0)
    class: "/Game/Anim/Notify_Footstep"
    
  - name: "WeaponTrail"
    type: notify_state
    track: 1
    time_start: 0.1
    time_end: 0.6
    class: "/Game/Anim/NotifyState_WeaponTrail"

# ===== Pose Assets =====
pose_assets:
  AimOffset:
    skeleton: "/Game/Characters/SK_Character"
    poses:
      - name: Neutral
        time: 0.0
      - name: AimUp
        time: 0.33
      - name: AimDown
        time: 0.66

# ===== Layered Animation =====
layers:
  UpperBody:
    type: anim_layer                 # anim_layer or sub_anim_instance
    interface: "/Game/Anim/ABI_UpperBody"
    source: "/Game/Anim/AB_UpperBody"
```

---

## Condition Operators Reference

| Operator | Type | Example |
|----------|------|---------|
| `equals` | any | `value: true` |
| `not_equals` | any | `value: false` |
| `greater` | number | `value: 100` |
| `greater_equal` | number | `value: 100` |
| `less` | number | `value: 50` |
| `less_equal` | number | `value: 50` |
| `time_remaining_less` | number | `value: 0.1` |
| `time_remaining_greater` | number | `value: 0.5` |

---

## Animation Types

| Type | Description | Parameters Required |
|------|-------------|-------------------|
| `sequence` | Single animation | `asset` |
| `blendspace1d` | 1D blend space | `asset`, `parameters.Speed` |
| `blendspace2d` | 2D blend space | `asset`, `parameters.X`, `parameters.Y` |
| `montage` | Animation montage | `asset` |

---

## Special State Names

| Name | Meaning |
|------|---------|
| `[*]` | Entry point (use `entry_state` instead) |
| `Any` | Matches any state (for transitions FROM any state) |

---

## Validation Rules

1. **Skeleton Compatibility**: All animations must use the same skeleton as the blueprint
2. **State Uniqueness**: Each state name within a state machine must be unique
3. **Transition Validity**: `from` and `to` states must exist in the state machine
4. **Variable Existence**: Condition variables must be defined in `variables` section
5. **Asset Existence**: Animation assets should exist (warning, not error)

---

## MCP Tool Mapping

| DSL Element | MCP Operation |
|-------------|---------------|
| `state_machines[].states[]` | `add_state` |
| `state_machines[].transitions[]` | `add_transition` |
| `state_machines[].entry_state` | `set_entry_state` |
| `state_machines[].connect_to_output` | `connect_state_machine_to_output` |
| `states[].animation` | `set_state_animation` |
| `transitions[].conditions[]` | `add_comparison_chain` |
| `transitions[].duration` | `set_transition_duration` |

---

## Example: Simple Locomotion

```yaml
format_version: "1.0"
metadata:
  name: "ABP_SimpleLocomotion"
  path: "/Game/Characters/"
  skeleton: "/Game/Characters/SK_Mannequin"

variables:
  Speed: { type: float, default: 0.0 }

state_machines:
  Main:
    position: { x: 0, y: 0 }
    
    states:
      - name: Idle
        position: { x: 0, y: 0 }
        animation:
          type: sequence
          asset: "/Game/Animations/Idle"
          
      - name: Moving
        position: { x: 300, y: 0 }
        animation:
          type: blendspace1d
          asset: "/Game/Animations/BS_WalkRun"
          parameters:
            Speed: Speed
    
    transitions:
      - from: Idle
        to: Moving
        conditions:
          - variable: Speed
            operator: greater
            value: 10
            
      - from: Moving
        to: Idle
        conditions:
          - variable: Speed
            operator: less
            value: 10
    
    entry_state: Idle
    connect_to_output: true
```

---

## Generated Output

When exporting an existing Animation Blueprint:

```yaml
format_version: "1.0"
exported_from: "/Game/Characters/ABP_Player"
exported_at: "2024-01-15T10:30:00Z"
# ... full blueprint definition
```
