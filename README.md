# Nom Nom Nebula

> *Consume. Expand. Become the universe.*

---

## Overview

Nom Nom Nebula is a 2D pixel art merger/tactics game where you navigate your own galaxy with one goal: get as big as possible. Absorb other galaxies, manage your black hole stabilizer, and dodge the invisible threats lurking in the cosmic field — because out here, not everything can be eaten. Some things eat *you*.

This is an infinite progression game. There is no true win state — only your highest score, and the drive to beat it.

---

## Gameplay

### Core Loop

Galaxies drift toward you through gravitational attraction. Stay within a galaxy's absorption radius for 2 seconds to consume it. Every absorption grows your galaxy — and raises the stakes.

### Controls

| Input | Action |
|-------|--------|
| `WASD` | Move — your galaxy drifts in response |
| `Space + WASD` | Burst propulsion in your movement direction |

### Burst Mechanic

Your burst meter holds 2 charges.

- Each burst moves your galaxy 8 pixels
- Both bursts together cover the full 16-pixel absorption radius — enough to fully escape another galaxy's pull
- Each burst lasts 1 second with a 0.5 second lag between them
- Once both charges are spent, the meter recharges over 3 seconds

Use bursts wisely — they're your only escape tool.

---

## The Black Hole Stabilizer Meter

A pressure meter is always counting down. This is your Black Hole Stabilizer — it tracks how long your galaxy has gone without a new absorption.

- Absorbing a galaxy resets the meter
- If the meter hits zero, your galaxy collapses into itself — game over
- The larger you grow, the faster the meter drains and the more frequent your absorptions need to be
- Difficulty scales continuously the longer you survive

*You cannot coast. You must keep feeding.*

---

## The Galaxies

Six NPC galaxy types drift through the field. Each has a unique shape, color, and condition — a passive effect applied to your galaxy upon absorption.

The mini-map is your primary tool for reading the field. Incoming galaxies are color-coded: blue for good conditions, red for bad ones. Use it to plan your path before galaxies reach your radius.

### Smaller Galaxies

| Galaxy | Color | Shape | Condition Type |
|--------|-------|-------|----------------|
| Small 1 | Orange | Barred Spiral | Varies |
| Small 2 | Purple | Spiral | Varies |
| Small 3 | Green | Irregular | Varies |

### Larger Galaxies

| Galaxy | Color | Shape | Condition Type |
|--------|-------|-------|----------------|
| Large 1 | Pink | Spiral | Varies |
| Large 2 | Blue | Elliptical | Varies |

*Each galaxy has a star at its center with surrounding pixel-art gas clouds. Low-poly by design — the focus is on motion, color, and feel.*

---

## Conditions

Every galaxy carries one condition. Choose carefully — absorbing the wrong one can make survival significantly harder.

### Good Conditions

| Condition | Rarity | Effect |
|-----------|--------|--------|
| Extra Dashes | Uncommon | +2 burst charges available |
| Interaction Radius Factor | Common | Absorption radius +20% |
| Dash Pulse Factor | Common | Propulsion range +50% |
| Absorption Speed Factor | Uncommon | Time to absorb a galaxy reduced by 50% |
| Escaping Time | Rare | +2 seconds to escape a black hole's radius |
| Dash Recharge Factor | Common | Recharge time reduced to 1.5 seconds |
| Warp Speed | Common | WASD movement speed +20% |

### Bad Conditions

| Condition | Rarity | Effect |
|-----------|--------|--------|
| Exotic Matter | Uncommon | Stabilizer max permanently shortened by 5 |
| Control Type 1 | Uncommon | WASD controls switch to tank-style movement |
| Control Type 2 | Common | Directional controls fully reversed (W = back, S = forward, etc.) |
| -1 Dash | Common | Burst limit reduced to 1 charge (same recharge time) |
| Dash Recharge Factor | Common | Recharge time increased to 6 seconds |

---

## Black Holes

Black holes are not visible on the mini-map or screen — until you're already inside their radius.

- Approach one and it becomes visible, triggering a QTE escape window
- You must burst out of its 16-pixel absorption radius in time
- If your galaxy is absorbed by a black hole — game over
- The rate of black hole spawns increases the longer you survive
- Your size at time of absorption is still recorded for your high score

> The field gets more dangerous the longer you last. Plan your path, not just your next meal.

---

## Scoring & Progression

Nom Nom Nebula is an infinite score-chaser. Every player will eventually lose — the goal is to outlast your own record.

Your score is based on how large your galaxy grows. After each run, the Game Over screen displays:
- Your current run's size
- Your all-time highest score

Push your limits. Beat yourself.

---

## Art Style

- Style: 2D pixel art, low-poly, top-down perspective
- Palette: Muted dark purples and blacks for space; each galaxy has its own color identity. The player galaxy starts white and takes on the colors of every galaxy absorbed.
- Motion: All galaxies are animated with a continuous spinning swirl
- Lighting: Flat lighting, soft glow, subtle shader effects on galaxies
- Camera: Follows the player's galaxy with a scrolling starfield background featuring twinkling stars


---

## Development

Nom Nom Nebula was created for *My First Game Jam*, due March 20, 2026.

| Name | Role | Responsibilities |
|------|------|-----------------|
| Savannah Griffiths | Game Designer, 2D Pixel Artist, UI Artist, Creative Director | Concept, GDD, sprite sheets, animations, environment art, UI assets, art direction, color palettes, visual style guide |
| Brandon Klotz | 2D Pixel Artist, UI Artist | 2D UI assets, configuration, environment art |
| Greyber Torrealba | Programmer | Engine, mechanics, player movement, galaxy interactions |
| Cristhian Leonardo Leon | Programmer | UI, navigation, backend |
| Boliverse | Composer | SFX and music |

---

## Built With

- Engine: Godot 4
- Art: Aseprite
- Music: Original chiptune/synth-pop soundtrack with building gameplay tracks and distinct menu music

---
