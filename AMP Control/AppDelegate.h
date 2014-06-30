//
//  AppDelegate.h
//  AMP Control
//
//  Created by Lars Häuser on 26.03.14.
//  Copyright (c) 2014 Lars Häuser. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSLevelIndicator *apacheIndi;
@property (weak) IBOutlet NSLevelIndicator *mysqlIndi;
@property (weak) IBOutlet NSButton *apacheButton;
@property (weak) IBOutlet NSButton *mysqlButton;
@property (weak) IBOutlet NSButton *recheck;
@property (weak) IBOutlet NSLevelIndicatorCell *apacheIndiCell;
@property (weak) IBOutlet NSLevelIndicatorCell *mysqlIndiCell;
- (IBAction)apacheStartButton:(id)sender;
- (IBAction)mysqlStartButton:(id)sender;
@property (weak) IBOutlet NSTextField *apacheLabel;
@property (weak) IBOutlet NSTextField *mysqlLabel;
@property (weak) IBOutlet NSProgressIndicator *apacheCircIndi;
@property (weak) IBOutlet NSProgressIndicator *mysqlCircIndi;
- (IBAction)recheck:(id)sender;

@property NSDockTile *tile;

@end
