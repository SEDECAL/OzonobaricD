#pragma once

#include <iostream>
#include "c++modernes/c++17patterns.h"

#include "format/color.h"
#include "format/core.h"

static auto mark1   = [](auto token){ return fmt::format( fmt::emphasis::bold | fg(fmt::color::green), token ); };
static auto warning = [](auto token){ return fmt::format( fmt::emphasis::bold | fg(fmt::color::orange), token ); };
static auto logEnable{true};

enum class LogLevel {
    Log = 0,
    Warning = -1,
};

template <typename T>
static auto auditor( T && backtrace, int ret_val = 0 )
{
    if(logEnable)
        ( std::clog << ( ret_val < 0 ? warning("[ WARNING ] ") : "" ) << snapshot() << backtrace ).flush();
    return ret_val;
};

template <typename T=void>
unsigned int htoi (const std::string & ref)
{
    unsigned int value = 0;
    const char *ptr = ref.c_str();
    char ch = *ptr;

    while (ch == ' ' || ch == '\t')
	ch = *(++ptr);
    for (;;) {
	if (ch >= '0' && ch <= '9')
	    value = (value << 4) + (ch - '0');
	else if (ch >= 'A' && ch <= 'F')
	    value = (value << 4) + (ch - 'A' + 10);
	else if (ch >= 'a' && ch <= 'f')
	    value = (value << 4) + (ch - 'a' + 10);
	else
	    return value;
	ch = *(++ptr);
    }
}

#ifdef i686Linux
template <typename T=void>
auto split( std::string & input, std::string separator )
{
    std::vector<std::string> tokens;
    using namespace std;
    string token;
    stringstream ss(input);
    while( getline( ss , token , separator[0] )) tokens.push_back(token);
    return tokens;
}
#endif

#include <vector>
template <typename T=void>
auto split( const std::string &text, char sep )
{
    std::vector<std::string>  tokens;
    std::size_t start = 0, end = 0;
    while (( end = text.find(sep, start)) != std::string::npos ) {
	tokens.push_back(text.substr(start, end - start));
	start = end + 1;
    }
    tokens.push_back(text.substr(start));
    return tokens;
}
