#pragma once

#ifdef __cplusplus
class iSPPPort {
public:
    static constexpr const int   serverPort{23};

    virtual bool busXmitt( const char *payload, const char *device = nullptr ) = 0;
    virtual bool emulation( bool enabled = true ) = 0;
    virtual void boot( int acceptPort = serverPort ) = 0;
    virtual void shutdown() = 0;
    virtual ~iSPPPort(){}
};
#endif
