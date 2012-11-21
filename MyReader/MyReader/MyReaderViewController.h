//
//  OfflineReaderViewController.h
//  OfflineReader
//
//  Created by chenjs.us on 12-10-30.
//  Copyright (c) 2012年 HellTom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReaderViewController : UIViewController <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, assign) BOOL isFileExists;
@property (nonatomic, strong) UIPasteboard *pasteboard;
//@property (nonatomic, strong) UIImage *correctImage;
//@property (nonatomic, strong) UIImage *incorrectImage;
//@property (nonatomic, strong) NSData *thumbImageData;


- (void)openDocumentIn;
- (void)handleDocumentOpenURL:(NSURL *)url;
- (void)displayAlert:(NSString *)str;
- (void)loadFileFromDocumentsFolder:(NSString *)filename;
- (void)listFilesFromDocumentsFolder;

- (void)handleOpenFileWithFileName:(NSString *)filename forOtherApp:(NSString *)otherAppName;


- (IBAction)btnDisplayFiles;
- (IBAction)exportFile;

@end
