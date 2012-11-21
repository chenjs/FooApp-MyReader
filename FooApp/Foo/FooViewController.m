//
//  ViewController.m
//  Sender
//
//  Created by chenjs.us on 12-10-31.
//  Copyright (c) 2012年 HellTom. All rights reserved.
//

#import "FooViewController.h"
#import "MyReaderResult.h"

#define kPasteboardNameForMyReader  @"com.hellotom.myreader"
#define kDataTypeMyReaderResult     @"com.hellotom.myreader.result"

@interface FooViewController ()

@end

@implementation FooViewController
@synthesize textField = _textField;
@synthesize resultValueLabel = _resultValueLabel;
@synthesize resultImageView = _resultImageView;
@synthesize pasteboard = _pasteboard;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.textField.text = @"1.pdf";
    self.resultValueLabel.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didEnterDoneKey
{
    [self.textField resignFirstResponder];
}

- (IBAction)textFieldValueChanged:(id)sender
{
    [self resetResultFields];
}

- (void)resetResultFields
{
    self.resultValueLabel.text = @"";
    if (self.resultImageView != nil) {
        [self.resultImageView removeFromSuperview];
        self.resultImageView = nil;
    }
}

- (void)viewTapped
{
    [self.textField resignFirstResponder];
}

- (IBAction)sendTextToMyReader:(id)sender
{
    NSString *URLEncodedText = [self.textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *ourPath = [@"tompp://" stringByAppendingString:URLEncodedText];
    NSURL *url = [NSURL URLWithString:ourPath];
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        
        [app openURL:url];
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Can't find APP to open your URL(tompp://)" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
}

- (void)handleMyReaderResult
{
    self.pasteboard = [UIPasteboard pasteboardWithName:kPasteboardNameForMyReader create:NO];
    
    NSData *data = [self.pasteboard dataForPasteboardType:kDataTypeMyReaderResult];
    MyReaderResult *readerResult = (MyReaderResult *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.resultValueLabel.text = readerResult.retValue;
    
    if (readerResult.retImage != nil) {
        [self showResultImage:readerResult.retImage];
    }
    /*
    else if (readerResult.thumbImageData != nil) {

        UIImage *thumbImage = [UIImage imageWithData:readerResult.thumbImageData];
        if (thumbImage != nil) {
            [self showResultImage:thumbImage];
        }
    }
     */
}

- (void)showResultImage:(UIImage *)image
{
    if (self.resultImageView == nil) {

        if (image != nil) {
            
            self.resultImageView = [[UIImageView alloc] initWithImage:image];
            int x = (320 - image.size.width) / 2;
            int y = 480 - 20 - image.size.height;
        
            CGRect frame = CGRectMake(x, y, image.size.width, image.size.height);
            self.resultImageView.frame = frame;
            
            [self.view addSubview:self.resultImageView];
        }
    } else {
        self.resultImageView.image = image;
    }
}

- (IBAction)openMaps:(id)sender
{
    //NSURL *url = [NSURL URLWithString:@"http://maps.google.com/maps?ll=-37.812022,144.969277"];
    NSURL *url = [NSURL URLWithString:@"http://maps.baidu.com"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)openYoutube:(id)sender
{
    //NSURL *url = [NSURL URLWithString:@"http://www.youtube.com/watch?v=TFFkK2SmPg4"];
    NSURL *url = [NSURL URLWithString:@"http://v.youku.com/v_show/id_XNDcyMDI0Nzky.html"];
    [[UIApplication sharedApplication] openURL:url];
}

@end
