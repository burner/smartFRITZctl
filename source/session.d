struct Session
{
	import std.algorithm : equal;
	import std.conv : to;
	import std.digest.md;
	import std.net.curl;
	import std.stdio;
	import std.string;
	import std.utf;
	import std.xml;

	string _id;
	string _challenge;
	int _blocktime;
	string _rights;

	string getID()
	{
		return _id;
	}

	bool start(string login_host, string login_user, string login_pwd)
	{
		import std.format : format;
		try{
			// get challenge
			auto url_session = "http://%s/login_sid.lua".format(login_host);
			parseSessionInfo(url_session);
		}catch (Exception e){
			return false;	// invalid hostname
		}

		// calculate response
		auto challenge = _challenge;
		auto response = _challenge ~ "-" ~ login_pwd;
		response = challenge ~ "-" ~ cast(string) md5utf16le(response);
		auto url_login = "http://%s/login_sid.lua?username=%s&response=%s"
			.format(login_host, login_user, response);
		parseSessionInfo(url_login);

		return !equal(_id, "0000000000000000");
	}

	static char[32] md5utf16le(string input)
	{
		wstring input_utf16 = toUTF16(input);
		auto hash = md5Of(input_utf16);
		return toHexString!(LetterCase.lower)(hash);
	}

	unittest
	{
		assert(md5utf16le("Hello World!") == "d9bd4a0c2c2117158ed933ab7468a461");
	}

	void parseSessionInfo(string url)
	{
		string content = cast(string) get(url);
		check(content);
		auto xml = new DocumentParser(content);
		xml.onEndTag["SID"] = (in Element e) { _id = e.text(); };
		xml.onEndTag["Challenge"] = (in Element e) { _challenge = e.text(); };
		xml.onEndTag["Blocktime"] = (in Element e) { _blocktime = to!(uint)(e.text()); };
		xml.onEndTag["Rights"] = (in Element e) { _rights = e.text(); };
		xml.parse();
	}

	void printSessionInfo()
	{
		writeln("- Session ID: ", _id);
		writeln("- Challenge: ", _challenge);
		writeln("- Blocktime: ", _blocktime);
		writeln("- Rights: ", _rights);
	}
}
