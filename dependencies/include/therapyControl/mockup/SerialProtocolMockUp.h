#ifndef SERIALPROTOCOLMOCKUP_H
#define SERIALPROTOCOLMOCKUP_H

#include "therapyControl/serial/SerialProtocol.public.h"
class iSPTesting {
public:

    using SPAck = std::tuple<bool,SPResponse,std::string>;
    virtual std::string composite( const SPCommand &spc ) = 0;
    virtual SPStatus xmitt( const SPCommand & spCommand, size_t deadline = 0 ) = 0;
    virtual void busActivity( const std::string & payload ) = 0;
    virtual  SPAck busResponse( size_t deadline = 1000 ) = 0;
    virtual ~iSPTesting(){}
};

#include <map>
class cSPMockUp {
public:
    cSPMockUp( iSPTesting & spt );
    std::string serializer( const char* str_command );
    SPStatus emulate( const SPCommand *spCommand );

    using CommandEnum = serialCommandEnum ;
    void replier( CommandEnum command );
    std::map<CommandEnum, uint32_t> vmod_settings;
    std::map<CommandEnum, uint32_t> proc_settings;

private:
    iSPTesting & spt;
};
#endif // SERIALPROTOCOLMOCKUP_H
