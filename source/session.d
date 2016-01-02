import std.digest.md;
import std.utf;
import std.conv;
import std.net.curl;
import std.stdio;
import std.string;
import std.xml;
import std.bitmanip;

class Session
{
	string _session_id = "0";
	string _session_challenge;
	int _session_blocktime;
	string _session_rights;

	this()
	{

	}

	bool isValid()
	{
		return true; //return parse!int(_session_id, 16) != 0;
	}

	string getID()
	{
		return _session_id;
	}

	void start(string login_url, string login_user, string login_pwd)
	{
		parseSessionInfo(login_url);

		// challenge response
		auto challenge = _session_challenge;
		auto response = _session_challenge ~ "-" ~ login_pwd;
		response = md5utf16le(response);
		response = challenge ~ "-" ~ response;
		auto url2 = login_url ~ "?username=" ~ login_user ~ "&response=" ~ response;

		// valid session?
		parseSessionInfo(url2);
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
		xml.onEndTag["SID"] = (in Element e) { _session_id = e.text(); };
		xml.onEndTag["Challenge"] = (in Element e) { _session_challenge = e.text(); };
		xml.onEndTag["Blocktime"] = (in Element e) { _session_blocktime = to!(uint)(e.text()); };
		xml.onEndTag["Rights"] = (in Element e) { _session_rights = e.text(); };
		xml.parse();
	}

	void printSessionInfo()
	{
		writeln("- Session ID: ", _session_id);
		writeln("- Challenge: ", _session_challenge);
		writeln("- Blocktime: ", _session_blocktime);
		writeln("- Rights: ", _session_rights);
	}
}

