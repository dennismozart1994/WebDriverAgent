/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ViewController.h"
#import "AppDelegate.h"

  @interface ViewController ()
  @property (weak, nonatomic) IBOutlet UILabel *orentationLabel;
  @property (weak, nonatomic) IBOutlet UILabel *documentsFolderLabel;
  @end

@implementation ViewController

- (IBAction)deadlockApp:(id)sender
{
  dispatch_sync(dispatch_get_main_queue(), ^{
    // This will never execute
  });
}

- (IBAction)didTapButton:(UIButton *)button
{
  button.selected = !button.selected;
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  [self updateOrentationLabel];
  [self updateDocumentsFolder];
}

- (void)updateOrentationLabel
{
  NSString *orientation = nil;
  switch (self.interfaceOrientation) {
    case UIInterfaceOrientationPortrait:
      orientation = @"Portrait";
      break;
    case UIInterfaceOrientationPortraitUpsideDown:
      orientation = @"PortraitUpsideDown";
      break;
    case UIInterfaceOrientationLandscapeLeft:
      orientation = @"LandscapeLeft";
      break;
    case UIInterfaceOrientationLandscapeRight:
      orientation = @"LandscapeRight";
      break;
    case UIInterfaceOrientationUnknown:
      orientation = @"Unknown";
      break;
  }
  self.orentationLabel.accessibilityIdentifier = @"orientationLabel";
  self.orentationLabel.text = orientation;
  
}

- (void)updateDocumentsFolder
{
  // Documents Folder Path
  NSString* documentsFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

  if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] isRunningUITest]) {
    _documentsFolderLabel.hidden = NO;
    _documentsFolderLabel.text = documentsFolderPath;
  } else {
    _documentsFolderLabel.hidden = YES;
  }
}

@end
