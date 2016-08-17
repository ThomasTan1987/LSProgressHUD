//
//  UIAlertController+Block.h
//  TutorTalk
//
//  Created by ThoamsTan on 16/8/17.
//  Copyright © 2016年 TutorABC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Block)
+ (UIAlertController*)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle handler:(void (^)(NSInteger buttonIndex))block;
@end
