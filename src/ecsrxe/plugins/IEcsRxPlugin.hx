package ecsrx.plugins; 

import ecsrx.framework.IEcsRxApplication; 

interface IEcsRxPlugin { 
    var pluginName:String; 
    function beforeApplicationStarts(application:IEcsRxApplication):Void; 
    function afterApplicationStarts(application:IEcsRxApplication):Void; 
    function beforeApplicationStops(application:IEcsRxApplication):Void; 
    function afterApplicationStops(application:IEcsRxApplication):Void; 
}