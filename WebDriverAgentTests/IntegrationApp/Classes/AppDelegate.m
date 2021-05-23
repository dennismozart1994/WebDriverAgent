/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

-(void)deleteAllFilesOfFolder:(NSString *)folderPath withExtension:(NSString *)extension {
  // navigate through all the files inside the folder
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil]) {
        if ([[file pathExtension] isEqualToString:extension]) {
            [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        }
    }
}

-(void)deleteAllFilesOfFolder:(NSString *)folderPath {
  for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil]) {
    [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
  }
}

-(BOOL)isRunningUITest {
  NSString* documentsFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  BOOL isUITest = [[[[NSProcessInfo processInfo] environment] objectForKey:@"UI_TEST"] boolValue] == YES;
  
  // delete all app local files if UI Test
  // can be changed to delete only some files if needed
  if (isUITest) {
    [self deleteAllFilesOfFolder:documentsFolderPath];
  }

  return isUITest;
}
@end
