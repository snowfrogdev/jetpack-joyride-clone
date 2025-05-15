# Jetpack Joyride Clone

This project is a clone of the classic **Jetpack Joyride** game, created as part of the [20 Games Challenge](https://20_games_challenge.gitlab.io/games/jetpack/). You can play the game here: `url to come`.

## Implementation Goals

- [x] Create a game world with a floor. The world will scroll from right to left endlessly.
- [x] Add a player character that falls when no input is held, but rises when the input is held.
- [x] Add obstacles that move from right to left. Feel free to make more than one type of obstacle.
  - [x] Obstacles can be placed in the world using a script so the level can be truly endless.
  - [x] Obstacles should either be deleted or recycled when they leave the screen.
- [x] The score increases with distance. The goal is to beat your previous score, so the high score should be displayed alongside the current score.

### Stretch Goals

- [] The jetpack is a machine gun! Add bullet objects that spew from your character when the input is held.
  - [x] Particle effects are a fun way to add game juice. Mess around with some here, making explosions or sparks when things get destroyed!

### Super Stretch Goals

- [] Compose and integrate background music to enhance the experience.

## Post-Mortem

I've invested about 80 hours into this project, while I had budgeted 75 hours. I spent a lot of time learning about Godot's skeleton rigging with mesh deformation along with the animation system. 

It became very clear early on that I would not be able to stay within the time budget and produce after decent art and audio assets so I decided to lean into AI generation. Every piece of art, sound effect and music in this project was generated using AI. I used [Sora](https://openai.com/sora/) for the character, hazards and some of the background. I used [Krita AI Diffusion](https://kritaaidiffusion.com/) for most of the background layers. For sound effects I used [OptimizerAI](https://www.optimizerai.xyz/) and for the music I used [Suno](https://suno.com/).

Using these tools to generate assets was a hard and tedious process. I did get a bit better at prompting the AI to get ~~the~~ kinda sorta close to what I wanted. But I still had to do a fair amount of editing to get the assets to work in the game. In the end I am convinced that a talented artis could have produced better assets in a fraction of the time it took me to generate and edit them. One side effect of using AI generation, from different sources, is that the art style tends to be inconsistent and lack cohesion.

My take away is that my time is probably better spent learning to create art and audio assets than trying to git gewd at prompt engineering. Even if the tools get better, people with good art fundamentals will be in a better position to use them effectively. I think the same is true for audio generation.

## How to Run

1. Clone the repository.
2. Open the project in [Godot 4.4.1](https://godotengine.org/download/archive/4.4.1-stable/).
3. Press the play button in the Godot editor to launch the game.

## License

This project is licensed under the **MIT License**.
