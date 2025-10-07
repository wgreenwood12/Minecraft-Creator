# Angry Cow Behavior Pack

This behavior pack makes cows in Minecraft Bedrock Edition aggressive and hostile towards players.

## Features
- Cows will attack players within a 5-block radius
- Cows deal 6 damage per attack
- Maintains normal cow breeding, aging, and loot mechanics
- Compatible with Minecraft Bedrock 1.21+

## File Structure & Explanation
```
Minecraft-Creator/
├── manifest.json                 # Main pack metadata (name, description, UUIDs, version)
├── generate_and_build.ps1        # PowerShell script to build/export the pack and generate new UUIDs
├── README.md                     # Project documentation and instructions
├── Angry_Cow_BP.mcpack           # Exported behavior pack file (for Minecraft import)
├── Test_Pack.mcpack              # Another exported pack file (for Minecraft import)
├── entities/
│   └── cow.json                  # Defines the custom Angry Cow entity and its behaviors
├── items/
│   └── angry_cow_spawn_egg.json  # Defines the Angry Cow spawn egg item
├── recipes/
│   └── angry_cow_spawn_egg.json  # Crafting recipe for the Angry Cow spawn egg
├── loot_tables/
│   └── entities/
│       ├── cow.json              # Loot table for vanilla cow (if overridden)
│       └── myaddon/
│           └── angry_cow.json    # Loot table for Angry Cow (drops when killed)
├── spawn_rules/
│   └── myaddon/
│       └── angry_cow.json        # Natural spawn conditions for Angry Cow
├── examples/
│   └── cow.json                  # Example entity file (for reference/testing)
```

### What Each File/Folder Does
- **manifest.json**: Required metadata for Minecraft to recognize the pack.
- **generate_and_build.ps1**: Automates UUID generation and pack building.
- **README.md**: Documentation and instructions.
- **entities/cow.json**: Defines the Angry Cow entity and its behaviors.
- **items/angry_cow_spawn_egg.json**: Defines the spawn egg item for Angry Cow.
- **recipes/angry_cow_spawn_egg.json**: Crafting recipe for the spawn egg.
- **loot_tables/entities/myaddon/angry_cow.json**: Loot table for Angry Cow.
- **spawn_rules/myaddon/angry_cow.json**: Natural spawn rules for Angry Cow.
- **examples/cow.json**: Example entity file for reference.

## How to Package and Install

### Method 1: Direct Copy (Recommended)
1. Copy the entire `Minecraft-Creator` folder
2. Rename it to something like `Angry_Cow_BP`
3. Copy the renamed folder to your Minecraft behavior packs directory:
   - **Windows 10/11**: `%localappdata%\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\development_behavior_packs\`
   - **Android**: `/storage/emulated/0/games/com.mojang/development_behavior_packs/`
   - **iOS**: `On My iPhone/Minecraft/games/com.mojang/development_behavior_packs/`

### Method 2: ZIP File
1. Select all files in the `Minecraft-Creator` folder (not the folder itself)
2. Create a ZIP file containing:
   - manifest.json
   - entities/ folder
   - loot_tables/ folder  
   - spawn_rules/ folder
3. Rename the ZIP file to `Angry_Cow_BP.mcpack`
4. Double-click the .mcpack file to automatically import it into Minecraft

### Activating the Pack
1. Open Minecraft Bedrock Edition
2. Create a new world or edit an existing world
3. Go to "Behavior Packs" in world settings
4. Find "Angry Cow Behavior Pack" and activate it
5. Apply the pack to your world

## Testing
Once installed, you can test the pack by:
1. Creating a world with the behavior pack enabled
2. Spawning a cow using `/summon myaddon:angry_cow`
3. Approach the cow - it should become hostile and attack you
4. Or wait for natural spawns in grassy biomes

## Technical Details
- Entity identifier: `myaddon:angry_cow`
- Attack damage: 6 hearts
- Attack range: 5 blocks
- Health: 20 (same as normal cows)
- Speed: 0.25 (same as normal cows)

## Troubleshooting
- Make sure you're using Minecraft Bedrock Edition (not Java Edition)
- Verify the manifest.json has valid UUIDs
- Check that all file paths are correct and case-sensitive
- Ensure the pack is activated in world settings before creating/loading the world