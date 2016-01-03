import std.getopt;
import std.stdio;
import std.string;

import inifiled;

import config;
import session;
import homeautomation;

import std.process;

void main(string[] args)
{
	// parsing command line arguments
	bool cmdConfigure = false;
	bool cmdHomeDevices = false;
	string cmdHomeSwitchOn;
	string cmdHomeSwitchOff;
	string cmdHomeSwitchToggle;
	getopt(args, "configure" , &cmdConfigure,
			"home-devices", &cmdHomeDevices,
			"home-switch-on", &cmdHomeSwitchOn,
			"home-switch-off", &cmdHomeSwitchOff,
			"home-switch-toggle", &cmdHomeSwitchToggle);
	
	// configuration
	string configDir = environment.get("HOME") ~ "/.config/smartFRITZctl/";
	writeln(configDir);

	SessionConfig confConnection;
	if(cmdConfigure){
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
	if(!se.start(confConnection.host, confConnection.user, confConnection.pwd))
	{
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
