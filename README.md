# First 2D Game - Dodge the Creeps!

A simple 2D game built with Godot Engine where you control a character trying to avoid enemies for as long as possible.

![First 2D Game](./assets/first_2d_game.gif)

## Game Features
- Simple and intuitive controls
- Score tracking based on survival time
- Randomized enemy movement and appearance
- Sound effects and background music

## Requirements
- Godot Engine 4.4 or later
- Basic understanding of GDScript

## How to Play
1. Use arrow keys or WASD to move the player character
2. Avoid the creeps (enemies) for as long as possible
3. Your score increases the longer you survive
4. The game ends when you collide with a creep
5. Press the Start button or Enter key to play again

## Project Structure
- `scenes/` - Contains all game scenes (player, mob, main, HUD)
- `scripts/` - Contains all GDScript files for game logic
- `assets/` - Contains art, fonts, and other resources
- `project.godot` - Main project file

## Implementation Details
- Player movement with screen boundary constraints
- Randomized enemy spawning system
- Signal-based communication between game components
- Efficient collision detection
- Simple but effective UI system

## Learning Resources
This project is based on the official Godot tutorial. For more information, see:
- [Your first 2D game](https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html)
- [Godot Engine Documentation](https://docs.godotengine.org/en/stable/)
- [GDScript Reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)

## Development
To modify this game:
1. Clone the repository
2. Open the project in Godot Engine
3. Explore the scenes and scripts to understand the implementation
4. Make your changes and test them in the editor

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Credits
- Game assets from the official Godot tutorial
- Godot Engine by Juan Linietsky, Ariel Manzur and contributors
