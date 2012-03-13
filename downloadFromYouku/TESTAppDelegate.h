//
//  TESTAppDelegate.h
//  downloadFromYouku
//
//  Created by li shunnian on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "ProcessWindow.h"
@interface TESTAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *urlText;
@property (retain) WebView *webView;
@property (retain) NSLock *downloadLock;
@property (retain) NSMutableData *globalData;
@property (copy) NSString *fileName;
@property (assign) float downloadPercent;
@property (retain) ProcessWindow *processWindowController;
- (IBAction)clickDownload:(id)sender;
@end
