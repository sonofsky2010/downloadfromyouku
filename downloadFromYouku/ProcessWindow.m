//
//  ProcessWindow.m
//  downloadFromYouku
//
//  Created by li shunnian on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProcessWindow.h"

@implementation ProcessWindow
@synthesize processIndicator;
@synthesize processInfo;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
