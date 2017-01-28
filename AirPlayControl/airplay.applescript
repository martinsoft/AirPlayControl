use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

on setAirplay(device_name)

    tell application "System Events"

        tell process "SystemUIServer"
            set display_menu to menu bar item 1 of menu bar 1 whose description contains "Displays Menu"
            click display_menu

            set the_menu to menu 1 of result

            delay 1.0               -- Wait a while for the menu to fetch devices

            if menu item device_name of the_menu exists then
              click menu item device_name of the_menu
            else
              key code 53            --Close the AirPlay menu again if not found
            end if

        end tell

    end tell

end run
