import time
import ctypes
import pyautogui

def send_input(keys):
    for key in keys:
        PressKey(key)
    time.sleep(0.1)
    for key in keys:
        ReleaseKey(key)

# Constants for keyboard scan codes
VK_LEFT = 0x25
VK_UP = 0x26
VK_SPACE = 0x20

# Define the PressKey and ReleaseKey functions
def PressKey(hexKeyCode):
    ctypes.windll.user32.keybd_event(hexKeyCode, 0, 0, 0)

def ReleaseKey(hexKeyCode):
    ctypes.windll.user32.keybd_event(hexKeyCode, 0, 0x0002, 0)

if __name__ == "__main__":
    application_name = "v06x (DEBUG)"
    # Switch to the target application (you may need to adjust the window title)
    pyautogui.getWindowsWithTitle(application_name)[0].activate()

    # List of keys to send simultaneously
    keys_to_send = [VK_LEFT, VK_UP, VK_SPACE]

    # Send the specified key s simultaneously
    send_input(keys_to_send)
