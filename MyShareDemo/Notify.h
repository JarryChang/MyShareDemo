//
//   Notify.h
//  MyShareDemo
//
//  Created by chang on 14/11/12.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Notify : NSObject {

}

+ (void)showAlertDialog:(id)context titleString:(NSString *)titleString messageString:(NSString *)messageString;
#pragma mark -
#pragma mark - xuHui 2011-07-25
+ (void)showAlertDialog:(id)context messageString:(NSString *)messageString;

@end
