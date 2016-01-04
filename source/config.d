import std.string;

import inifiled;

@INI("connection")
struct SessionConfig {
	@INI("hostname of fritz.box")
	string host;
	@INI("username (empty by default)")
	string user;
	@INI("password")
	string pwd;
}
