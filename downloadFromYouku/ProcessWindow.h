//
//  ProcessWindow.h
//  downloadFromYouku
//
//  Created by li shunnian on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProcessWindow : NSWindowController
@property (assign) IBOutlet NSProgressIndicator *processIndicator;
@property (assign) IBOutlet NSTextField *processInfo;

@end
