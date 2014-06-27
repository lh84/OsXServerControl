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
            recheck,
            mysqlIndiCell, apacheIndiCell,
            apacheLabel, mysqlLabel, apacheCircIndi, mysqlCircIndi;


NSString *const APACHESTART = @"Apache start";
NSString *const APACHESTOP = @"Apache stop";
NSString *const MYSQLSTART = @"MySQL start";
NSString *const MYSQLSTOP = @"MySQL stop";

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [apacheCircIndi setDisplayedWhenStopped:NO];
    [mysqlCircIndi setDisplayedWhenStopped:NO];
    [apacheIndiCell setDoubleValue:1];
    [mysqlIndiCell setDoubleValue:1];
    
    [self checkIfApacheIsRunning];
    [self checkIfMysqlIsRunning];
}

- (void) startApache {
    [apacheCircIndi startAnimation:self];
    NSString *command;
    if (apacheButton.title == APACHESTOP) {
        command = @"stop";
    } else if (apacheButton.title == APACHESTART) {
        command = @"start";
    }
    
    NSString * output = nil;
    NSString * processErrorDescription = nil;
    [self runProcessAsAdministrator:@"apachectl"
                      withArguments:[NSArray arrayWithObjects:command, nil]
                             output:&output
                   errorDescription:&processErrorDescription];
    
    [self checkIfApacheIsRunning];
    
}

- (void) startMySql {
    
    [mysqlCircIndi startAnimation:self];
    NSString *command;
    if (mysqlButton.title == MYSQLSTOP) {
        command = @"stop";
    } else if (apacheButton.title == MYSQLSTART) {
        command = @"start";
    }
    
    NSString * output = nil;
    NSString * processErrorDescription = nil;
    [self runProcessAsAdministrator:@"mysql.server"
                      withArguments:[NSArray arrayWithObjects:command, nil]
                             output:&output
                   errorDescription:&processErrorDescription];
    
    [self checkIfMysqlIsRunning];
    
}

- (void) checkIfApacheIsRunning {
    // wait a seconf to look for pid
    [NSThread sleepForTimeInterval:1.0f];
    //grep http
    NSString *output = runCommand(@"ps ax | grep httpd | grep -v grep");
    if([output length] > 0)
    {
        // get pid number
        [apacheLabel setStringValue: runCommand(@"tail /private/var/run/httpd.pid")];
        [apacheButton setTitle:APACHESTOP];
        [apacheIndiCell setDoubleValue:3];
    }
    else
    {
        [apacheLabel setStringValue: @""];
        [apacheButton setTitle:APACHESTART];
        [apacheIndiCell setDoubleValue:1];
    }
    [apacheCircIndi stopAnimation:self];
}

- (void) checkIfMysqlIsRunning {
    // wait a seconf to look for pid
    [NSThread sleepForTimeInterval:1.0f];
    //grep http
    NSString *output = runCommand(@"ps ax | grep mysql | grep -v grep");
    if([output length] > 0)
    {
        // get pid number
        [mysqlLabel setStringValue: runCommand(@"tail /usr/local/var/mysql/lars.fritz.box.pid")];
        [mysqlButton setTitle:MYSQLSTOP];
        [mysqlIndiCell setDoubleValue:3];
    }
    else
    {
        [mysqlLabel setStringValue: @""];
        [mysqlButton setTitle:MYSQLSTART];
        [mysqlIndiCell setDoubleValue:1];
    }
    [mysqlCircIndi stopAnimation:self];
}

- (IBAction)apacheStartButton:(id)sender {
    [self startApache];
}

- (IBAction)mysqlStartButton:(id)sender {
    [self startMySql];
}

- (IBAction)recheck:(id)sender {
    [apacheCircIndi startAnimation:self];
    [self checkIfApacheIsRunning];
    [mysqlCircIndi startAnimation:self];
    [self checkIfMysqlIsRunning];
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

NSString *runCommand(NSString *commandToRun)
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    
    NSArray *arguments = [NSArray arrayWithObjects:
                          @"-c" ,
                          [NSString stringWithFormat:@"%@", commandToRun],
                          nil];
    //NSLog(@"run command: %@",commandToRun);
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *output;
    output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    return output;
}

@end
