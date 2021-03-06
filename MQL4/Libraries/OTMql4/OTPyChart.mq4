// -*-mode: c; c-style: stroustrup; c-basic-offset: 4; coding: utf-8-dos -*-

/*
This will provide the interface from Mql to our Chart class in Python.

*/

#property copyright "Copyright 2014 Open Trading"
#property link      "https://github.com/OpenTrading/"
#property library

#include <OTMql4/OTLibPy27.mqh>
#include <OTMql4/OTZmqProcessCmd.mqh>
#include <OTMql4/OTLibSimpleFormatCmd.mqh>

#include <OTMql4/OTLibLog.mqh>

string eSendOnSpeaker(string uChartId, string uType, string uMess) {
    return(eReturnOnSpeaker(uChartId, uType, uMess, ""));
}

string eReturnOnSpeaker(string uChartId, string uType, string uMess, string uOriginCmd) {
    string uRetval;

    if (uOriginCmd == "") {
        uMess = uChartId +".eSendOnSpeaker('" +uType +"', '''" +uMess +"''')";
    } else {
        // This message is a reply in a cmd
        uMess = uChartId +".eReturnOnSpeaker('" +uType +"', '''" +uMess
            +"''', '''" +uOriginCmd +"''')";
    }
    //vTrace("eReturnOnSpeaker:  uMess: " +uMess);
    // the retval should be empty - otherwise its an error
    vPyExecuteUnicode(uMess);
    vPyExecuteUnicode("sFoobar = '%s : %s' % (sys.last_type, sys.last_value,)");
    uRetval=uPyEvalUnicode("sFoobar");
    if (StringFind(uRetval, "exceptions", 0) >= 0) {
        vWarn("eReturnOnSpeaker: ERROR: " +uRetval);
        return(uRetval);
    }
    if (StringFind(uRetval, "select.error", 0) >= 0) {
	//? Panic
        vWarn("eReturnOnSpeaker: ERROR: " +uRetval);
        return(uRetval);
    }
    if (uRetval != " : ") {
        vDebug("eReturnOnSpeaker:  WTF?" +uRetval);
        return(uRetval);
    }
    // vTrace("eReturnOnSpeaker: sent " +uMess);
    return("");
}

