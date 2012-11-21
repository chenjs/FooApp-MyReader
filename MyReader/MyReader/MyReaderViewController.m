//
//  OfflineReaderViewController.m
//  OfflineReader
//
//  Created by chenjs.us on 12-10-30.
//  Copyright (c) 2012年 HellTom. All rights reserved.
//

#import "MyReaderViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MyReaderResult.h"

#define kPasteboardNameForMyReader  @"com.hellotom.myreader"
#define kDataTypeMyReaderResult     @"com.hellotom.myreader.result"

@interface MyReaderViewController ()

- (void)handleOpenFileWithFileName:(NSString *)filename;

@end

@implementation MyReaderViewController {
    UIDocumentInteractionController *documentController;
}

@synthesize webView;
@synthesize isFileExists = _isFileExists;
@synthesize pasteboard = _pasteboard;
//@synthesize correctImage = _correctImage;
//@synthesize incorrectImage = _incorrectImage;
//@synthesize thumbImageData = _thumbImageData;


#pragma mark - Interface for open file 


- (void)handleOpenFileWithFileName:(NSString *)filename forOtherApp:(NSString *)otherAppName
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(onBackBtnTapped)];

    if (otherAppName != nil) {
        self.title = otherAppName;
    } else {
        self.title = @"OtherApp";
    }
    
    [self handleOpenFileWithFileName:filename];
}


- (void)onBackBtnTapped
{
    [self resetToNormalSecne];
    
    MyReaderResult *result = [[MyReaderResult alloc] init];
    
    NSString *imageFilePath;
    
    if (self.isFileExists) {
        
        self.isFileExists = NO;
        
        result.retCode = 0;
        result.retValue = @"我看完了!";
        imageFilePath = [[NSBundle mainBundle] pathForResource:@"correct" ofType:@"png"];
    } else {
        result.retCode = -1;
        result.retValue = @"没找到该文档";
        imageFilePath = [[NSBundle mainBundle] pathForResource:@"incorrect" ofType:@"png"];
    }
    
    NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath];
    result.retImage = [UIImage imageWithData:imageData];
    result.thumbImageData = nil;
        
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:result];
    if (data != nil) {
        [self.pasteboard setData:data forPasteboardType:kDataTypeMyReaderResult];
    }

    [self switchToOtherApp];
}

- (void)switchToOtherApp
{
    NSString *respText = @"";
    
    NSString *URLEncodedText = [respText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *ourPath = [@"mysender://" stringByAppendingString:URLEncodedText];
    NSURL *url = [NSURL URLWithString:ourPath];
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        
        [app openURL:url];
    } else {
        NSLog(@"No app registered for URL Schemal: [mysender://]");
    }
    
}

- (void)peekResult
{
    // Test to see if OK
    NSData *peekedData = [self.pasteboard dataForPasteboardType:kDataTypeMyReaderResult];
    MyReaderResult *peekedResult = (MyReaderResult *)[NSKeyedUnarchiver unarchiveObjectWithData:peekedData];
    
    NSLog(@"data on pasteboard: [code: %d, value: %@]", peekedResult.retCode, peekedResult.retValue);
    if (peekedResult.retImage == nil) {
        NSLog(@"RetImage is nil");
    }    
}

- (void)resetToNormalSecne
{
    self.navigationItem.rightBarButtonItem = nil;
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self setTitle:@"MyReader"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        self.navigationController.navigationBar.hidden = YES;
        [self setWebViewToFullScreen];
        
    } else {
        
        self.navigationController.navigationBar.hidden = NO;
        [self resumeWebViewFromFullScreen];
    }
}

- (void)setWebViewToFullScreen
{
    CGRect fullRect = [[UIScreen mainScreen] bounds];
    self.webView.frame = fullRect;
}

- (void)resumeWebViewFromFullScreen
{
    /*
    CGRect rect = self.webView.frame;
    
    rect.origin.y += 44;
    self.webView.frame = rect;
     */
}

#pragma mark - Private Methods

- (void)openDocumentIn
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Core Data on iOS5 Tutorial" ofType:@"pdf"];
    documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    documentController.delegate = self;
    documentController.UTI = @"com.adobe.pdf";
    [documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

- (void)handleDocumentOpenURL:(NSURL *)url
{
    [self displayAlert:[url absoluteString]];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView setUserInteractionEnabled:YES];
    [self.webView loadRequest:requestObj];
}

- (void)handleOpenFileWithFileName:(NSString *)filename
{
    /*
    NSArray *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)];
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsPath stringByAppendingPathComponent:filename];
     */
    
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        
        self.isFileExists = YES;
        
        NSURL *fileUrl = [NSURL URLWithString:fullPath];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:fileUrl];
        [self.webView setUserInteractionEnabled:YES];
        [self.webView loadRequest:requestObj];
    } else {
        self.isFileExists = NO;
        
        [self.webView loadHTMLString:@"" baseURL:nil];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"File Not Exists!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         
        [alertView show];
    }
}

- (void)displayAlert:(NSString *)str
{
    
}

- (void)loadFileFromDocumentsFolder:(NSString *)filename
{
    
}

- (void)listFilesFromDocumentsFolder
{

}

- (IBAction)btnDisplayFiles
{
    
    
}

- (IBAction)exportFile
{
    [self openDocumentIn];
}

#pragma mark - UIDocumentInteractionControllerDelegate

-(void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application
{
    
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application
{
    
}

-(void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resetToNormalSecne];
        
    self.pasteboard = [UIPasteboard pasteboardWithName:kPasteboardNameForMyReader create:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //[UIPasteboard removePasteboardWithName:kPasteboardNameForMyReader];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
