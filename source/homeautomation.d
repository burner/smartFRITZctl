struct HomeAutomation
{
	import std.conv : to;
	import std.net.curl : get;
	import std.string : chop, split;
	import std.format : format;
	
	import session;

	static string[] getListofDevicesIDs(Session session)
	{
		string request = "http://fritz.box/webservices/homeautoswitch.lua?switchcmd=getswitchlist&sid=%s"
			.format(session.getID());

		string result = cast(string) get(request);
		return split(result.chop(), ",");
	}

	static string getNameOfDevice(Session session, string deviceID)
	{
		string request = "http://fritz.box/webservices/homeautoswitch.lua?switchcmd=getswitchname&ain=%s&sid=%s"
	   		.format(deviceID, session.getID());
		return chop(cast(string) get(request));
	}

	static bool setSwitchDevice(Session session, string deviceID, bool power)
	{
		string command = power ? "setswitchon" : "setswitchoff";
		string request = "http://fritz.box/webservices/homeautoswitch.lua?ain=%s&switchcmd=%s&sid=%s"
			.format(deviceID, command, session.getID());
		return cast(bool) to!int(chop(get(request)));
	}

	static bool toggleSwitchDevice(Session session, string deviceID)
	{
		string request = "http://fritz.box/webservices/homeautoswitch.lua?ain=%s&switchcmd=setswitchtoggle&sid=%s"
			.format(deviceID, session.getID());
		int result = to!int(chop(get(request)));
		return cast(bool) result;
	}
}

