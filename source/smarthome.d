import std.conv;
import std.net.curl;
import std.string;

import session;

class SmartHome
{
	static string[] getListofDevicesIDs(Session session)
	{
		string request = "http://fritz.box/webservices/homeautoswitch.lua?switchcmd=getswitchlist&sid=" ~ session.getID();
		string result = cast(string) get(request);
		return split(result.chop(), ",");
	}

	static string getNameOfDevice(Session session, string deviceID)
	{
		string request = "http://fritz.box/webservices/homeautoswitch.lua?switchcmd=getswitchname&ain=" ~ deviceID ~ "&sid=" ~ session.getID();
		return chop(cast(string) get(request));
	}

	static bool setSwitchDevice(Session session, string deviceID, bool power)
	{
		string command = power ? "setswitchon" : "setswitchoff";
		string request = "http://fritz.box/webservices/homeautoswitch.lua?ain=" ~ deviceID ~ "&switchcmd=" ~ command  ~"&sid=" ~ session.getID();
		return cast(bool) to!int(get(request));
	}

	static bool toggleSwitchDevice(Session session, string deviceID)
	{
		string request = "http://fritz.box/webservices/homeautoswitch.lua?ain=" ~ deviceID ~ "&switchcmd=setswitchtoggle&sid=" ~ session.getID();
		return cast(bool) to!int(get(request));
	}
}

