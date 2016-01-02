import std.digest.md;
import std.utf;
import std.conv;
import std.getopt;
import std.net.curl;
import std.stdio;
import std.string;
import std.xml;
import std.bitmanip;
import std.c.stdlib;

import inifiled;

import config;
import session;
import smarthome;

void main(string[] args)
{
	Config connection;

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
		connection.login_host = "http://fritz.box/login_sid.lua";
    		
		writeln("Enter Username");
		readln(input);
		connection.login_user = chop(cast(string) input);
    		
		writeln("Enter Password");
		readln(input);
		connection.login_pwd = chop(cast(string) input);
		
		writeINIFile(connection, "smartFRITZctl.ini");
		return;
	}
	
	readINIFile(connection, "smartFRITZctl.ini");
	
	// create a connection 
	Session se = new Session();
	se.start(connection.login_host, connection.login_user, connection.login_pwd);
	if(!se.isValid()) {
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
