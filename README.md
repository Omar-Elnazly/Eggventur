# 🥚 Eggventur

A 3D survival adventure game where you play as a brave chicken navigating a dangerous world. Dodge rocks, collect eggs, and manage your stamina to survive as long as possible!


## Game Overview

**Eggventur** is a third-person survival adventure game built using **Godot Engine**.  
You control a chicken in a hostile environment where rocks are thrown at you. Your goal is to collect as many eggs as possible while avoiding obstacles.

- 🥚 Normal eggs give **1 point**
- ✨ Golden eggs give **3 points**
- Difficulty increases as you collect more eggs


## Features

- **Dynamic Stamina System**  
  Sprint to escape rocks, but stamina drains and regenerates slowly over time.

- **Progressive Difficulty**  
  Every 5 eggs collected increases rock speed and spawn frequency.

- **Golden Eggs**  
  Rare collectibles worth 3 points, spawning every 30 seconds.

- **Smooth 3D Movement**  
  Responsive controls with sprinting, jumping, and smooth camera rotation.

- **Visual Polish**  
  Real-time shadows, smooth animations, and tilt effects for immersive gameplay.


## Controls

| Action         | Key(s)              |
|----------------|---------------------|
| Move           | Arrow Keys / WASD   |
| Jump           | Space               |
| Sprint         | Shift               |
| Collect Eggs   | Walk over them      |


## Installation & Running

### Prerequisites
- Godot Engine **4.x**

### Steps
1. Clone the repository
   ```bash
   git clone https://github.com/Omar-Elnazly/Eggventur.git
2. Open **Godot Engine**
3. Click **Import**
4. Navigate to the cloned folder and select `project.godot`
5. Press **F5** or click **Play** to run the game


## Game Mechanics

### Stamina
- Increases by **6%** over time when walking or idle
- Sprinting drains stamina quickly
- When stamina reaches zero, sprinting is disabled
- Maximum stamina increases gradually as eggs are collected

### Eggs
- **Normal Egg**  
  - +1 point  
  - Spawns regularly (max 5 on the map)

- **Golden Egg**  
  - +3 points  
  - Spawns every 30 seconds

### Rocks
- Rocks are thrown randomly
- Colliding with a rock ends the game
- Every 5 eggs collected increases:
  - Rock speed
  - Spawn rate


## Technologies Used

- **Engine:** Godot 4.x  
- **Language:** GDScript  
- **3D Assets:** Sketchfab  
- **Audio:** Pixabay Sound Effects  
- **Version Control:** Git & GitHub  


## Project Structure

Key scripts include:

- `Player.gd` – Chicken movement, stamina, egg collection  
- `EggSpawner.gd` – Spawns normal and golden eggs  
- `Rock.gd` – Rock behavior and rolling physics  
- `Main.gd` – Game manager and difficulty scaling  
- `StartMenu.gd` – Menu navigation and settings  


## Team

| Name                     | Role |
|--------------------------|------|
| Mohamed Hussein Kamal    | Main game loop, camera, player physics |
| Omar Sayed Abdel-Hakam   | Lighting, shaders, textures |
| Ziad Elsayed Fouad       | Level design, 3D model importing, report |


## 🖼️ Screenshots

- <img width="1596" height="906" alt="image" src="https://github.com/user-attachments/assets/5841d6a8-9ca8-4b64-a5b1-1904e192157d" />

- <img width="1590" height="902" alt="image" src="https://github.com/user-attachments/assets/9e89c8a6-8dda-4359-bc28-1f6665f842cf" />

- <img width="1595" height="896" alt="image" src="https://github.com/user-attachments/assets/5816592d-7573-47c0-908c-6a930f36c08f" />



## License

This project is for **educational purposes** as part of a Computer Graphics course.  
All third-party assets are used under their respective licenses.


## 🙏 Acknowledgements

- **3D Models:** Sketchfab  
- **Sound Effects:** Pixabay  
- **Engine:** Godot  


Enjoy the game!  
Collect eggs, avoid rocks, and see how long you can survive! 🐔🥚
