# AirPlayControl
An Xcode project which compiles into a Mac app that can be launched from the command line and used to automate switching between AirPlay devices. The app uses Accessibility and AppleScript to trigger the system menu and select a device named in the first argument passed to the app.

## Usage
* Build the Xcode project to produce AirPlayControl.app
* Launch the app from the command line, specifying the name of the AirPlay device to connect to as the first argument. e.g.: `$ open -W /Users/<blah>/Desktop/AirPlayControl.app --args "Living Room"`
* On first launch, MacOS will for your permission to allow the app to use Accessibility. You must grant access to allow the app to control the AirPlay menu. 
* To disconnect from the current airplay device: `$ open -W /Users/<blah>/Desktop/AirPlayControl.app --args "Turn AirPlay Off"`

## Accessibility
* You can grant or remove Accessibility permissions at any time, using System Preferences > Security & Privacy > Privacy > Accessibility
  * Drag the app into the list of allowed apps to grant permission
  * Remove the app from the list if you no longer wish to use the app. 

## License
AirPlayControl is available under the MIT license. See the LICENSE file for more info.
