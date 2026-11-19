# Bloodmoon – Ruby/Gosu Mini-Game Collection

Custom program for **COS10009 Introduction to Programming** at Swinburne University of Technology (Hanoi), August 2024.

Bloodmoon is a desktop game hub written in Ruby with the [Gosu](https://www.libgosu.org/) 2D game library. A single menu lets the player enter a name, choose a difficulty and launch one of four games; each finished game is kept as a record (game, score, time, result) that can be viewed from the menu.

| Game | File | Description |
| --- | --- | --- |
| Gems Collection | `Games/Game_1/Gems_collection.rb` | Mine and collect falling gems while dodging rocks |
| Star Wars Shooter | `Games/Game_2/Star_wars.rb` | Space shooter with player ship, enemies, bullets, explosions and lives |
| 2048 | `Games/Game_3/2048.rb` | The 2048 sliding-tile puzzle (tile drawing, move/merge logic, game-over detection) |
| Overcoming Obstacles | `Games/Game_4/Overcoming_obstacles.rb` | Side-scrolling "flappy" style game through brick obstacles |

Shared code: `Games/Games_Menu.rb` (main menu, navigation, difficulty buttons), `Games/Name.rb` (player name input), `Games/Record.rb` (high-score records).

## Concepts practised
Procedural decomposition across files, records/classes, arrays, game loop (`update`/`draw`), keyboard and mouse input, collision detection, simple file I/O.

## Run
```bash
gem install gosu
ruby Bloodmoon.rb
```

## Notes
- Background music and sound effects (≈1 GB of `.wav` files, including copyrighted soundtracks) are **not** included. Add your own `Media/Song_*.wav` / `Media/Sound_*.wav` files or comment out the `Gosu::Song`/`Gosu::Sample` lines to run without audio.
- Commit dates reflect the original file modification dates of the coursework; the repository itself was published on GitHub in November 2026.
