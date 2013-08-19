Simple Key Dumper
============
This tool is designed to dump keyboard and mouse inputs to the screen.

It will only work for these users:

- Windows 7 Users Running the Simulator and Simulating and Android Device
- Android Users with any HID device attached.
- OUYA Users 


Note For OUYA Users
============
I released this simple tool because I wanted OUYA users to have the ability to self-document OUYA inputs.

To use this app for discovering OUYA HID input names, do the following:

1. Build the app for Android.
2. Side load it onto your OUYA (http://docs.coronalabs.com/guide/distribution/androidBuild/index.html#device-installation)
3. Run the app.
4. Press buttons and move joysticks on the controller.
5. Write down the info that is displayed on the screen.
   Pay particular attention to these details:

name - Name of event.
keyName - Name of input key/joystick
phase - Phase(s) the input passes through.

There are more details, but they are not universal to the inputs.




