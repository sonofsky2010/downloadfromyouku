//
//  TESTAppDelegate.m
//  downloadFromYouku
//
//  Created by li shunnian on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TESTAppDelegate.h"

@implementation TESTAppDelegate
static NSString *agent = @"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5";
static NSString *jsString = @"document.getElementById('youku-html5-player-video').src";
@synthesize window = _window;
@synthesize urlText = _urlText;
@synthesize webView = _webView;
@synthesize downloadLock = _downloadLock;
@synthesize globalData = _globalData;
@synthesize fileName = _fileName;
@synthesize downloadPercent = _downloadPercent;
@synthesize processWindowController = _processWindowController;
- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.downloadLock = [[NSLock alloc] init];
    [_downloadLock release];
}

- (IBAction)clickDownload:(id)sender {
    NSString *url = [self.urlText stringValue];
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel beginWithCompletionHandler:^(NSInteger retCode){
        if (retCode == NSFileHandlingPanelOKButton) {
            self.downloadPercent = 0.0f;
            self.processWindowController = [[[ProcessWindow alloc] initWithWindowNibName:@"processWindow"] autorelease];
            [NSApp beginSheet:_processWindowController.window modalForWindow:self.window modalDelegate:self didEndSelector:NULL contextInfo:NULL];
            [self.processWindowController.processIndicator setDoubleValue:0.0f];
            [self.processWindowController.processInfo setStringValue:[NSString stringWithFormat:@"%.1f%%", 0.0f]];
            self.fileName = [panel filename];
            self.webView = [[WebView alloc] initWithFrame:NSMakeRect(0, 0, 10, 10)];
            [_webView release];
            [_webView setCustomUserAgent:agent];
            [_webView setFrameLoadDelegate:self];
            WebFrame *webframe = [_webView mainFrame];
            NSURL *urlRequest = [NSURL URLWithString:url];
            [webframe loadRequest:[NSURLRequest requestWithURL:urlRequest]];
        }
    }];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    NSString *m3u8 = [sender stringByEvaluatingJavaScriptFromString:jsString];
    if ([m3u8 rangeOfString:@"m3u8"].location != NSNotFound) {
        [sender setFrameLoadDelegate:nil];
        [self performSelectorInBackground:@selector(downloadUrl:) withObject:m3u8];
    }
    else if (![sender isLoading]) {
        [NSApp endSheet:self.processWindowController.window];
        [self.processWindowController.window orderOut:nil];
    }
}

- (void)downloadUrl:(NSString *)m3u8
{
    if (!_fileName) {
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            [NSApp endSheet:self.processWindowController.window];
            [self.processWindowController.window orderOut:nil];
        });
        return;
    }
    
    FILE *f = fopen([_fileName cStringUsingEncoding:NSUTF8StringEncoding], "wb+");
    NSURL *m3u8Url = [NSURL URLWithString:m3u8];
    NSString *list = [NSString stringWithContentsOfURL:m3u8Url encoding:NSUTF8StringEncoding error:NULL];
    NSArray *lines = [list componentsSeparatedByString:@"\r\n"];
    NSMutableArray *downUrl = [NSMutableArray array];
    for (NSString *al in lines) {
        if ([al length] != 0 && ![[al substringToIndex:1] isEqualToString:@"#"]) {
            [downUrl addObject:al];
        }
    }
    for (NSString *al in downUrl) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:al]];
        if (data && [data length] > 0) {
            fwrite([data bytes], [data length], 1, f);
            dispatch_sync(dispatch_get_main_queue(), ^(void){
                self.downloadPercent += 1.0f / [downUrl count];
                [self.processWindowController.processIndicator incrementBy: 100.0f / [downUrl count]];
                [self.processWindowController.processInfo setStringValue:[NSString stringWithFormat:@"%.1f%%", _downloadPercent*100]];
                
            });
        }
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^(void){
//        [self.processWindowController.processIndicator stopAnimation:nil];
        [NSApp endSheet:self.processWindowController.window];
        [self.processWindowController.window orderOut:nil];
    });
    
    fclose(f);
}

@end
