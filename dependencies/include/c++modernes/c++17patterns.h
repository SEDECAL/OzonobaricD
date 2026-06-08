#pragma once

/*
 * JB#31122019
 * Second template parameter solves the diamond corner case of use, see Boccara on CRTP
 * This expands the concrete interface layer on the crtp layer,
 * so the end point of the hierarchy is NOT aliased and the diamond is broken
 * This extra stuff allows to build Specialized classes assembled with different
 * crtps, composition taste is powered.
*/
template <typename T, template<typename> class crtpType>
struct crtpBoccara {
    T& underly(){ return static_cast<T&>(*this); }
    T const& underly() const { return static_cast<T const&>(*this); }
private:
    crtpBoccara(){}
    friend crtpType<T>;
};

struct nullpattern{};

#include <cstddef>
template <typename T>
constexpr auto enumSqueeze(T val) { return static_cast<size_t>(val); }

template <typename T>
auto constPrune( const T *var ){ return const_cast<T*>(var); }

#include <functional>
template <typename F,typename... T> void doWhatEver( std::function<F> f, T&&... args)
{ return [&args..., f]{ f(std::forward<T>(args)...); }(); }

#include <utility>
template <typename ... F>
struct overload_set : public F ... {
    overload_set( F&& ... f) : F(std::forward<F>(f)) ... {}
    using F::operator() ... ;
};

// Below function template roles as a factory of variadic lambdas
template <typename ... F>
auto overload( F && ... f ){ return overload_set<F...>( std::forward<F>(f)... ); }

#include <variant>
template<class... Ts> struct overloaded : Ts... { using Ts::operator()...; };
template<class... Ts> overloaded(Ts...) -> overloaded<Ts...>;

template <typename Variant, typename... Matchers>
auto match(Variant&& variant, Matchers&&... matchers)
{
    return std::visit(
                overloaded{std::forward<Matchers>(matchers)...},
                std::forward<Variant>(variant));
}

// JB#October 2020 generic variable reset
#include <cstring>
template <class T>
inline void resetVar( T &t ){ memset( & t, 0, sizeof( T ) ); }

// JB#January 2021 helper to representate 1970 seconds in a decent way
#include <string>
#include <ctime>
#include <iostream>
#include <iomanip>
#include <sys/time.h>

typedef struct {} signaturedTime;
template <typename T=void>
std::string snapshot( unsigned int now_ = 0 )
{
    using namespace std;
    string oss;
    if constexpr ( std::is_same_v<T, signaturedTime> )
    {
        time_t t; time( & t );
        struct tm * tm = localtime( & t );
        struct timeval tv; gettimeofday( & tv, 0);

	oss.append( to_string( tm->tm_year + 1900 ) );
	for( auto i : { tm->tm_mon +1, tm->tm_mday, tm->tm_hour, tm->tm_min, tm->tm_sec } )
	    oss.append( to_string(i) );
	return oss;
    }
    time_t now = now_ == 0 ? time(0) : static_cast<time_t>( now_ );
    string tmp = string( ctime( & now ) );
    struct timespec msec;
    clock_gettime( CLOCK_REALTIME, & msec);
    oss.append(tmp.substr(0, tmp.length() -6 )).append(".").append(to_string( (int) (msec.tv_nsec / 1000000 )));
    return oss;
}

#include <thread>
#include <chrono>
template <typename T=void>
void releaseCpu( size_t msec = 1000 ) { std::this_thread::sleep_for(std::chrono::milliseconds(msec)); }

// JB#December 2020 helper to lookup on containers of tuples
#include <algorithm>
template <typename T, typename Index >
auto indexLookUp( T && container, const Index & probe )
{
    return std::find_if(container.begin(), container.end(), [& probe ]( const auto & m ){
        return std::get<0>(m) == probe;
    } );
};

static auto lookupIndex = []( auto & table, auto probe )
{
    if( indexLookUp(table,probe) == table.end())
        return std::get<1>( *( table.end() -1 ) );
    return std::get<1>( *indexLookUp( table, probe ));
};

#include <string>
#include <algorithm>

//
//  Lowercases string
//
template <typename T>
static std::basic_string<T> lowercase(const std::basic_string<T>& s)
{
    std::basic_string<T> s2 = s;
    std::transform(s2.begin(), s2.end(), s2.begin(), tolower);
    return std::move(s2);
}


#include <regex>
template <typename T=std::string>
static std::string rideOffhtml( std::string html )
{
#ifdef i686linux
    std::regex tags("<[^<]*>");
    T output;
    std::regex_replace(std::back_inserter(output), html.begin(), html.end(), tags, "");
    return output;
#else
    return html;
#endif
}

class cElapser {
public:
    using Clock = std::chrono::high_resolution_clock;
    using MyTimeUnits = std::chrono::microseconds;
    static inline Clock::time_point start() { return Clock::now(); }
    static auto elapsed( const Clock::time_point & start ) {
        Clock::time_point now = Clock::now();
        auto experiment = std::chrono::duration_cast<MyTimeUnits>(now - start);
        return experiment.count();
    }
};


