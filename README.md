# Coco Key System public launcher

This repository contains only the public access launcher. Paid Lua scripts stay in the private Script Portal storage and require a redeemed game key.

Post this line as the ScriptBlox loader:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/brookbrookcms-cmyk/Coco-Key-System/main/loader.lua"))()
```

The monochrome launcher follows the Coco Hub reference design. It uses a high-contrast 520 × 340 card on larger screens and a compact 340 × 360 layout on phones. It detects the current Roblox game, highlights its published Script Portal listing when available, and offers **Copy access link** or **Have a key**. Buyers open the copied link in a browser to verify their Roblox account, buy that game's pass, and redeem the key you issue. The key screen verifies a redeemed key for the current game and loads its script from the portal. The UI has short TweenService transitions, no continuous rendering loop, and cleans up on close or repeat execution.

The copied link points to <https://portal-production-baf8.up.railway.app/>. Before a game appears in the launcher or buyer page, publish that game and upload its Lua file from the owner dashboard. Executor clipboard support varies; if unavailable, the URL stays visible for manual copying.
