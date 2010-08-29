//
//  StringFromCommandPlugIn.h
//  StringFromCommand
//
//  Created by Noah Paessel on 8/27/10.
//  MIT License
//

#import <Quartz/Quartz.h>

@interface StringFromCommandPlugIn : QCPlugIn
{

}
@property(assign) NSString* inputArguments;
@property(assign) NSString* inputWorkingDir;
@property(assign) NSString* inputCommandName;
@property(assign) NSString* outputResult;

//@property(assign) int		counter;
/*
Declare here the Obj-C 2.0 properties to be used as input and output ports for the plug-in e.g.
@property double inputFoo;
@property(assign) NSString* outputBar;
 
 You can access their values in the appropriate plug-in methods using self.inputFoo or self.inputBar
 
 IMPORTANT:  The names must include 'input' and 'output' in them.
 easiset thing to do is to make them dynamic:
 

*/

@end
