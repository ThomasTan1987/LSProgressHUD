//
//  UIAlertController+Block.m
//  TutorTalk
//
//  Created by ThoamsTan on 16/8/17.
//  Copyright © 2016年 TutorABC. All rights reserved.
//

#import "UIAlertController+Block.h"
#import <objc/runtime.h>
@implementation UIAlertController (Block)
- (void)dealloc
{
    NSLog(@"*******dealloc********UIAlertController (Block)********");
}
+ (UIAlertController*)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle handler:(void (^)(NSInteger buttonIndex))block
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //关联block
    if (block){
        objc_setAssociatedObject(alertController, "block", block, OBJC_ASSOCIATION_RETAIN);
    }
    __weak UIAlertController *weakAlertController = alertController;
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            void (^block)(NSInteger buttonIndex)  = objc_getAssociatedObject(weakAlertController, "block");
            if (block) {
                block(0);
            }
        }];
        [cancelAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
        [alertController addAction:cancelAction];
    }
    
    if (otherButtonTitle) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            void (^block)(NSInteger buttonIndex)  = objc_getAssociatedObject(weakAlertController, "block");
            if (block) {
                block(1);
            }
        }];
        [otherAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
        [alertController addAction:otherAction];
    }
    return alertController;
}
@end
