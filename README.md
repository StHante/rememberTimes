# Remember Times

This is an app written in Monkey C for Garmin watches that can record a list of times, such that the user can remember them. I have implemented and used it for tracking the times when I fed my baby child.

## How to use

Start the app on your watch. You will be presented with the last 5 times that you recorded along with the current time in the bottom as well as the difference between the recorded times (and the current time) in green.

You can press the menu button or long tap on the touch screen to bring up the main menu, where you can.

 * Save the current time.
 * Specify a time to save. You can adjust the time by tapping on the top or bottom part of the screen. The time selection can be accepted by tapping on the right part of the screen or discarded by tapping on the left part of the screen.
 * Show a list of all times that were saved. Tapping on one of the entries will close the list.
 * Send the list to a computer in the same local network that is running the receiver script `receiver.py`. You need to configure the IP adress of the computer in the app's setting in one of the Garmin apps (on you mobile phone or computer) as well as enable unsecure HTTP transfer. (This is because the communication will only happen in your local network. It is best to turn this off after sending the list.)
  * Delete the last entry.
  * Delete all entries.
  * Close the menu.

## How to build

You can install the Garmin IQ SDK and Visual Studio Code together with the Monkey C extension as described here:
https://developer.garmin.com/connect-iq/connect-iq-basics/getting-started/
Then use the commands to build the project.