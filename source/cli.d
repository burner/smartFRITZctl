import std.getopt;
import std.stdio;
import std.string;

import inifiled;

import config;
import session;
import smarthome;

void main(string[] args)
{
	SessionConfig confConnection;

	bool cmdListDevices = false;
	bool cmdConfigure = false;
	string cmdSwitchOn;
	string cmdSwitchOff;
	string cmdSwitchToggle;
	getopt(args, "list-devices", &cmdListDevices,
			"configure" , &cmdConfigure,
			"smarthome-turnOn", &cmdSwitchOn,
			"smarthome-turnOff", &cmdSwitchOff,
			"smarthome-toggle", &cmdSwitchToggle);

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

	// smarthome
	if(cmdListDevices){
		string[] deviceIDs = SmartHome.getListofDevicesIDs(se);
		writeln("List of SmartHome devices:");
		foreach(string deviceID; deviceIDs) {
			writeln("- " ~ deviceID ~ " (" ~ SmartHome.getNameOfDevice(se, deviceID) ~ ")");
		}
	}

	// control device
	writeln(cmdSwitchToggle);

	if(cmdSwitchOn != "")
		SmartHome.setSwitchDevice(se, cmdSwitchOn, true);	
	if(cmdSwitchOff != "")
		SmartHome.setSwitchDevice(se, cmdSwitchOff, false);	
	if(cmdSwitchToggle != "")
		SmartHome.toggleSwitchDevice(se, cmdSwitchToggle);	

}
