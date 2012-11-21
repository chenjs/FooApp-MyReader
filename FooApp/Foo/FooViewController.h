//
//  ViewController.h
//  Sender
//
//  Created by chenjs.us on 12-10-31.
//  Copyright (c) 2012年 HelloTom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UILabel *resultValueLabel;
@property (nonatomic, strong) UIImageView *resultImageView;
@property (strong, nonatomic) UIPasteboard *pasteboard;


- (IBAction)sendTextToMyReader:(id)sender;
- (IBAction)openMaps:(id)sender;
- (IBAction)openYoutube:(id)sender;
- (IBAction)didEnterDoneKey;
- (IBAction)textFieldValueChanged:(id)sender;

- (void)handleMyReaderResult;


@end
