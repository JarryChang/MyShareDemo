//
//   Notify.h
//  MyShareDemo
//
//  Created by chang on 14/11/12.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import "Notify.h"

@implementation Notify

+ (void)showAlertDialog:(id)context titleString:(NSString *)titleString messageString:(NSString *)messageString {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:titleString
                                                          message:messageString
                                                         delegate:context
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
        [myAlert show];
    });
}

+ (void)showAlertDialog:(id)context messageString:(NSString *)messageString {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle: @"提示"
                                                          message:messageString
                                                         delegate:context
                                                cancelButtonTitle: @"确定"
                                                otherButtonTitles:nil];
        [myAlert show];
        
    });
}

@end
