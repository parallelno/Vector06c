import time
import pyautogui

def send_keystrokes_to_application(application_name, keys):
    try:
        # Switch to the target application (you may need to adjust the window title)
        pyautogui.getWindowsWithTitle(application_name)[0].activate()

        # Wait for a short time to give the application focus
        time.sleep(1)

        # Send the specified keys to the application using hotkey
        pyautogui.hotkey(*keys)

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__": 
    application_name = "v06x (DEBUG)"
    #application_name = "Untitled - Notepad"
    keys_to_send = ['left', 'up', 'space']
    # Send the left arrow key and up arrow key
    send_keystrokes_to_application(application_name, keys_to_send)