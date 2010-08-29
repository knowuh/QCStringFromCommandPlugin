//
//  StringFromCommandPlugIn.m
//  StringFromCommand
//
//  Created by Noah Paessel on 8/27/10.
//  MIT License
//

/* It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering */
#import <OpenGL/CGLMacro.h>

#import "StringFromCommandPlugIn.h"

#define	kQCPlugIn_Name				@"String From Command"
#define	kQCPlugIn_Description		@"String From Command description"

@implementation StringFromCommandPlugIn
@dynamic inputCommandName;
@dynamic inputArguments;
@dynamic inputWorkingDir;
@dynamic outputResult;

/*
Here you need to declare the input / output properties as dynamic as Quartz Composer will handle their implementation
@dynamic inputFoo, outputBar;
*/

+ (NSDictionary*) attributes
{
	/*
	Return a dictionary of attributes describing the plug-in (QCPlugInAttributeNameKey, QCPlugInAttributeDescriptionKey...).
	*/
	
	return [NSDictionary dictionaryWithObjectsAndKeys:
			kQCPlugIn_Name, QCPlugInAttributeNameKey, 
			kQCPlugIn_Description, QCPlugInAttributeDescriptionKey, nil];
}

+ (NSDictionary*) attributesForPropertyPortWithKey:(NSString*)key
{
	/*
	Specify the optional attributes for property based ports (QCPortAttributeNameKey, QCPortAttributeDefaultValueKey...).
	*/
	if([key isEqualToString:@"inputCommandName"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
				@"Command Line", QCPortAttributeNameKey,
				@"/bin/hostname", QCPortAttributeDefaultValueKey,
				nil];
	if([key isEqualToString:@"inputArguments"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
				@"Command Line Arguments", QCPortAttributeNameKey,
				nil];
	if([key isEqualToString:@"inputWorkingDir"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
				@"Working Directory", QCPortAttributeNameKey,
				@"/tmp", QCPortAttributeDefaultValueKey,
				nil];
    if([key isEqualToString:@"outputResult"])
        return [NSDictionary dictionaryWithObjectsAndKeys:
				@"Result", QCPortAttributeNameKey,
				nil];
	NSLog(@"Huh, %@", key);
	return nil;
}

+ (QCPlugInExecutionMode) executionMode
{
	/*
	Return the execution mode of the plug-in: kQCPlugInExecutionModeProvider, kQCPlugInExecutionModeProcessor, or kQCPlugInExecutionModeConsumer.
	*/
	
	return kQCPlugInExecutionModeProvider;
}

+ (QCPlugInTimeMode) timeMode
{
	/*
	Return the time dependency mode of the plug-in: kQCPlugInTimeModeNone, kQCPlugInTimeModeIdle or kQCPlugInTimeModeTimeBase.
	*/
	
	return kQCPlugInTimeModeNone;
}

- (id) init
{
	NSLog(@"Hey init");
	if(self = [super init]) {
		/*
		Allocate any permanent resource required by the plug-in.
		*/
	}
	NSLog(@"Hey init2");
	return self;
}

- (void) finalize
{
	/*
	Release any non garbage collected resources created in -init.
	*/
	
	[super finalize];
}

- (void) dealloc
{
	/*
	Release any resources created in -init.
	*/
	
	[super dealloc];
}

@end

@implementation StringFromCommandPlugIn (Execution)

- (BOOL) startExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when rendering of the composition starts: perform any required setup for the plug-in.
	Return NO in case of fatal failure (this will prevent rendering of the composition to start).
	*/
	NSLog(@"Hey startExecution");
	return YES;
}

- (void) enableExecution:(id<QCPlugInContext>)context
{
	NSLog(@"Hey enableExecution");
	/*
	Called by Quartz Composer when the plug-in instance starts being used by Quartz Composer.
	*/
}

- (BOOL) execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{
	/*
	Called by Quartz Composer whenever the plug-in instance needs to execute.
	Only read from the plug-in inputs and produce a result (by writing to the plug-in outputs or rendering to the destination OpenGL context) within that method and nowhere else.
	Return NO in case of failure during the execution (this will prevent rendering of the current frame to complete).
	
	The OpenGL context for rendering can be accessed and defined for CGL macros using:
	CGLContextObj cgl_ctx = [context CGLContextObj];
	*/

	NSTask *task = [[NSTask alloc] init];
    NSPipe *newPipe = [NSPipe pipe];
    NSFileHandle *readHandle = [newPipe fileHandleForReading];
    NSData *inData = nil;
	
    // write handle is closed to this process
    [task setStandardOutput:newPipe];
	[task setCurrentDirectoryPath:self.inputWorkingDir];
	[task setArguments: [self.inputArguments componentsSeparatedByString: @" "]];
    [task setLaunchPath: self.inputCommandName];
	@try {
		[task launch];
		inData = [readHandle readDataToEndOfFile];
		self.outputResult = [[NSString alloc] initWithData:inData encoding:NSUTF8StringEncoding];
	}
	@catch ( NSException *e ) {
		self.outputResult = @"(an unnerving silence)";
	}

	[task release];
	return YES;
}

- (void) disableExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when the plug-in instance stops being used by Quartz Composer.
	*/
}

- (void) stopExecution:(id<QCPlugInContext>)context
{
	/*
	Called by Quartz Composer when rendering of the composition stops: perform any required cleanup for the plug-in.
	*/
}

@end
