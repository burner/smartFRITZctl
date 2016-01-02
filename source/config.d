import std.string;

import inifiled;

@INI("Connection")
struct Config {
        @INI("hostname of fritz.box")
        string login_host;
        @INI("username (empty by default)")
        string login_user;
        @INI("password")
        string login_pwd;
}

