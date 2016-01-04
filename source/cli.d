import std.getopt;
import std.stdio;
import std.string;

import inifiled;

import config;
import session;
import homeautomation;

void main(string[] args)
{
	// parsing command line arguments
	bool cmdConfigure = false;
	bool cmdHomeDevices = false;
	string cmdHomeSwitchOn;
	string cmdHomeSwitchOff;
	string cmdHomeSwitchToggle;
	auto getoptRslt = getopt(args, "configure" , &cmdConfigure,
			"home-devices", "List all available devices", &cmdHomeDevices,
			"home-switch-on", "Turn on electrical switch", &cmdHomeSwitchOn,
			"home-switch-off", "Turn off electrical switch", &cmdHomeSwitchOff,
			"home-switch-toggle", "Toggle electrical switch", 
				&cmdHomeSwitchToggle);

	if(getoptRslt.helpWanted) {
        defaultGetoptPrinter(
			"Command line tools for accessing AVM FRITZ!Box devices.",
            getoptRslt.options
		);
		return;
	}
	
	// configuration
	SessionConfig confConnection;
	if(cmdConfigure) {
		char[] input;
		confConnection.host = "fritz.box";
		writeln("Enter Username");
		readln(input);
		confConnection.user = chop(cast(string) input);
		writeln("Enter Password");
		readln(input);
		confConnection.pwd = chop(cast(string) input);
		writeINIFile(confConnection, "smartFRITZctl.ini");
		return;
	}
	readINIFile(confConnection, "smartFRITZctl.ini");
	
	// create connection 
	Session se = new Session();
	if(!se.start(confConnection.host, confConnection.user, confConnection.pwd)) {
		writeln("error: invalid configuration");
		return;
	}

	// home
	if(cmdHomeDevices){
		string[] deviceIDs = HomeAutomation.getListofDevicesIDs(se);
		writeln("List of HomeAutomation devices:");
		foreach(string deviceID; deviceIDs) {
			writeln("- AIN: " ~ deviceID ~ " (" ~ HomeAutomation.getNameOfDevice(se, deviceID) ~ ")");
		}
	}
	if(cmdHomeSwitchOn != "")
		HomeAutomation.setSwitchDevice(se, cmdHomeSwitchOn, true);	
	if(cmdHomeSwitchOff != "")
		HomeAutomation.setSwitchDevice(se, cmdHomeSwitchOff, false);	
	if(cmdHomeSwitchToggle != "")
		HomeAutomation.toggleSwitchDevice(se, cmdHomeSwitchToggle);	

}
