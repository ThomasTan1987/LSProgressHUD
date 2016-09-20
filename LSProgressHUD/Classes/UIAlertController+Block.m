//
//  UIAlertController+Block.m
//  TutorTalk
//
//  Created by ThoamsTan on 16/8/17.
//  Copyright © 2016年 TutorABC. All rights reserved.
//

#import "UIAlertController+Block.h"
#import <objc/runtime.h>
@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation UIAlertController (Private)

@dynamic alertWindow;

- (void)setAlertWindow:(UIWindow *)alertWindow {
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)alertWindow {
    return objc_getAssociatedObject(self, @selector(alertWindow));
}

@end

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
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            void (^block)(NSInteger buttonIndex)  = objc_getAssociatedObject(weakAlertController, "block");
            if (block) {
                block(0);
            }
        }];
        if (version>=9.0) {
            [cancelAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
        }
        
        [alertController addAction:cancelAction];
    }
    
    if (otherButtonTitle) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            void (^block)(NSInteger buttonIndex)  = objc_getAssociatedObject(weakAlertController, "block");
            if (block) {
                block(1);
            }
        }];
        if (version>=9.0) {
            [otherAction setValue:[UIColor orangeColor] forKey:@"titleTextColor"];
        }
        [alertController addAction:otherAction];
    }
    return alertController;
}
- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)animated {
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [[UIViewController alloc] init];
    
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    // Applications that does not load with UIMainStoryboardFile might not have a window property:
    if ([delegate respondsToSelector:@selector(window)]) {
        // we inherit the main window's tintColor
        self.alertWindow.tintColor = delegate.window.tintColor;
    }
    
    // window level is above the top window (this makes the alert, if it's a sheet, show over the keyboard)
    UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
    self.alertWindow.windowLevel = topWindow.windowLevel + 1;
    self.alertWindow.hidden = NO;
    //    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:self animated:animated completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // precaution to insure window gets destroyed
    self.alertWindow.hidden = YES;
    self.alertWindow = nil;
}
@end
