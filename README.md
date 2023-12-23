# Godot 4 Save System Demo
 Demo of binary serialization save system in Godot 4.


# Overview
This is a binary serialization/deserialization game save system developed by drawing inspiration from the tutorials below. 

I [(Aaron)](https://github.com/ajsams) had a hard time finding a good example of a save system that could accomodate a little more complexity than entry-level games. In searching I found that others had similar issues (e.g. [this example](https://www.reddit.com/r/godot/comments/1708jtl/is_there_an_automated_way_to_saveload_complicated/)).

For example, I was working on a game that had a single currency scene that could represent several different types of currency. The game needed to keep track of all of these currencies across different levels, as players could enter and leave levels without collecting all currency and I wanted the state of each level's currency to be preserved if a player left and re-entered a level.

By no means do I think this is comprehensive or will work for very complex games, but my hope is that this might help a few others to adapt this to their needs.

For much more complex games, as the Godot tutorial linked below mentions, you would probably need to build a more complicated system that takes more direct advantage of the Binary Serialization API. **If anyone reading this knows of some good open source examples of that, please comment on this project and let us know of them**, as we'd love to reference them here and potentially improve on this project with more examples of different types of save systems. 

This type of save system can be extended in various ways, including adding multiple save slots (by adjusting the paths for level save files).

# The Game
This is a simple game we've called "Coin Grab" that includes five levels. In each level, the objective is to collect coins (there are two types of coins, and make it to the door in each level. You have to get to the end of level 5 without running out of lives. Running into the hazards (the snowflake shaped objects) removes a life. 

## Controls
| KEYSTROKES | EFFECT |
| :--- | ---: |
| Arrow keys/WASD | Directional movement |
| P / Delete / Backspace | Open Pause Menu |
| Enter / Return | Select / Press Buttons |

## How to Demo the Save System
You can demo the save system by utilizing the in-game save function in the pause menu:
1. Enter the game.
2. Play enough (without dying) to collect a few coins.
3. While in a level, open the pause menu and choose "Save and Quit".
4. When you return to the title screen, select "Continue from Save". 

If you are playing from Godot and you encounter strange behavior after closing the game mid-way, returning to the title menu and selecting "Start New Game" should clear the save files and start a fresh game. 

# The Save/Load System
The save system uses the Binary Serialization API via Godot's `FileAccess` class. It works by storing data in two types of files:

1. Globals - Global variables that are stored in game in the `Globals` singleton.
2. Level Saves - Data for each level is saved for any scenes added to the `persist` group. This currently includes only `coin.tscn`. However, this could be adapted to include additional scenes. 

In contrast to some other Godot tutorials that use save/load functions within each scene's attached GDscript, this system implements all Save/Load logic in a singleton script called `SaveLoad`.

The Globals serialization/deserialization is fairly straightforward. It stores and loads objects explicitly, in a specific order.

The Levels save files work similarly, however, when deserializing you have to first get the path to the scene and its parent, instantiate the node object, then set it's properties. 

# Links
* [Godot Binary Serialization API](https://docs.godotengine.org/en/stable/tutorials/io/binary_serialization_api.html#doc-binary-serialization-api)
* [Godot FileAccess Docs](https://docs.godotengine.org/en/stable/classes/class_fileaccess.html)
* [Godot Save/Load tutorial](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html)
* [NightQuest's tutorial](https://www.nightquestgames.com/godot-4-save-and-load-games-how-to-build-a-robust-system/) 
