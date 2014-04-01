//
//  AppDelegate.m
//  AMP Control
//
//  Created by Lars Häuser on 26.03.14.
//  Copyright (c) 2014 Lars Häuser. All rights reserved.
//

#import "AppDelegate.h"



@implementation AppDelegate

@synthesize apacheButton, apacheIndi,
            mysqlButton, mysqlIndi,
            mysqlIndiCell, apacheIndiCell,
            apacheLabel, mysqlLabel, apacheCircIndi, mysqlCircIndi;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [apacheCircIndi setDisplayedWhenStopped:NO];
    [mysqlCircIndi setDisplayedWhenStopped:NO];
    [apacheIndiCell setDoubleValue:1];
    [mysqlIndiCell setDoubleValue:1];
}

- (BOOL) startApache {
    NSString * output = nil;
    NSString * processErrorDescription = nil;
    BOOL isRunning = [self runProcessAsAdministrator:@"httpd"
                             withArguments:[NSArray arrayWithObjects:@"-k", @"start", nil]
                                    output:&output
                          errorDescription:&processErrorDescription];
    [apacheLabel setStringValue:output];
    [apacheCircIndi stopAnimation:self];
    return isRunning;
}

- (BOOL) runProcessAsAdministrator:(NSString*)scriptPath
                     withArguments:(NSArray *)arguments
                            output:(NSString **)output
                  errorDescription:(NSString **)errorDescription {
    
    NSString * allArgs = [arguments componentsJoinedByString:@" "];
    NSString * fullScript = [NSString stringWithFormat:@"'%@' %@", scriptPath, allArgs];
    
    NSDictionary *errorInfo = [NSDictionary new];
    NSString *script =  [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", fullScript];
    
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor * eventResult = [appleScript executeAndReturnError:&errorInfo];
    
    // Check errorInfo
    if (! eventResult)
    {
        // Describe common errors
        *errorDescription = nil;
        if ([errorInfo valueForKey:NSAppleScriptErrorNumber])
        {
            NSNumber * errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
            if ([errorNumber intValue] == -128)
                *errorDescription = @"The administrator password is required to do this.";
        }
        
        // Set error message from provided message
        if (*errorDescription == nil)
        {
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage])
                *errorDescription =  (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
        }
        
        return NO;
    }
    else
    {
        // Set output to the AppleScript's output
        *output = [eventResult stringValue];
        
        return YES;
    }
}

- (BOOL) checkIfApacheIsRunning {
    return YES;
}

- (BOOL) checkIfMysqlIsRunning {
    return YES;
}

- (IBAction)apacheStartButton:(id)sender {
    [apacheCircIndi startAnimation:self];
    if([self startApache]){
        [apacheIndiCell setDoubleValue:3];
        [apacheButton setTitle:@"Apache stoppen"];
    }
}

- (IBAction)mysqlStartButton:(id)sender {
}
@end
