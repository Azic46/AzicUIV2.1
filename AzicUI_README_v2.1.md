# Azic UI

A dark, low-glare Roblox Luau UI library with a Linoria-style API. Written from scratch.

## Files

- `Library.lua` — UI library core.
- `LoadingScreen.lua` — optional standalone animated loading screen module.
- `Example.lua` — complete component showcase using both files.

## Load

Keep all three files in the same GitHub repository and use the matching raw base URL in `Example.lua`.

The loading screen is optional. If it cannot be loaded, the example continues and reports the issue in the console.

## Design

- OLED-style dark surfaces.
- One live-switchable accent.
- Vector-drawn icons; no external icon assets.
- Low-contrast ambient effects and a subtle shimmer.
- Responsive default window sizing and viewport-aware resizing.
- Touch-sized controls on touch-only devices.
- Reduced-motion and ambient-effect controls.

## Included features

- Dashboard, profile and live session statistics.
- Music player with playlist, seek bar and visualizer.
- Toggles, buttons, labels, dividers, sliders, inputs and dropdowns.
- Multi-select and searchable dropdowns.
- Color pickers and key pickers.
- Dependency boxes and tabboxes.
- 3D viewport and character viewer.
- Notifications, watermark and floating launcher.
- Theme and config builders.
- Standalone loading screen.

## Config support

Saving configs requires an environment that provides `writefile`, `readfile`, `isfolder`, `makefolder`, `listfiles` and `isfile`.

## Audio

Roblox only allows audio that is public or available to the experience. Private or unavailable IDs may fail.

## Resolution note

Roblox UI is rendered from vector-based UI instances and scaled to the device viewport. A script cannot force a device to output 4K; actual display resolution is controlled by the device and Roblox client.
