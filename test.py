from pyboy import PyBoy
from pynput import keyboard
from Constante import *
from AccessMemory import *
# Path to the compiled ROM file
rom_path = "pokered.gbc"

# Initialize PyBoy with the ROM file
pyboy = PyBoy(rom_path)

print("Press 'Esc' to stop the emulator.")
print("Press '4' for Start and '6' for Select.")

# Key mappings
key_mapping = {
    '4': 'start',
    '6': 'select'
}

# Store the currently pressed keys
keys_pressed = set()

# Global battle state variables
inBattle = False
nbBattle = 0

def save_game_state(pyboy, filename):
    with open(filename, "wb") as f:
        pyboy.save_state(f)
    print(f"Game state saved to {filename}")

# Function to handle key press events
def on_press(key):
    try:
        if key.char in key_mapping:
            keys_pressed.add(key_mapping[key.char])
    except AttributeError:
        if key == keyboard.Key.esc:
            print("Stopping the emulator.")
            return False

# Function to handle key release events
def on_release(key):
    try:
        if key.char in key_mapping:
            keys_pressed.discard(key_mapping[key.char])
    except AttributeError:
        pass

# Start keyboard listener
listener = keyboard.Listener(on_press=on_press, on_release=on_release)
listener.start()

# Run the emulator until 'Esc' is pressed
running = True
i = 0
while running:
    # Run the emulator for one frame
    pyboy.tick()

    # Check which keys are pressed and send the corresponding action to the game
    for action in keys_pressed.copy():
        pyboy.button(action)
    
    if (i % 4) == 0:
        pass
    i += 1

    # Example: use AccessMemory to detect if a battle has started.
    # Here we assume that if AccessMemory.get_enemy_id(pyboy) returns a non-zero value,
    # a battle has begun. (Adjust the condition and function as needed.)
    # You need to implement or adjust this function
    if not inBattle and pyboy.memory[ENEMY_POKEMONS[0]] != 0 :
        inBattle = True
        nbBattle += 1
        # Save the game state with a unique filename for this battle
        save_game_state(pyboy, f"State/battle_{nbBattle}.state")
    elif inBattle and pyboy.memory[ENEMY_POKEMONS[0]] == 0:
        # Battle is over, reset inBattle flag
        inBattle = False

    print(get_pos(pyboy))

    # Check if the listener is still running
    if not listener.running:
        running = False

# Clean up and close the emulator
pyboy.stop()
listener.stop()