//
//  LSProgressHUD.m
//  Demo
//
//  Created by ThoamsTan on 16/7/28.
//  Copyright © 2016年 ThoamsTan. All rights reserved.
//

#import "LSProgressHUD.h"
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
//toast显现时长，单位是秒
#define visible_duration 1
@interface LSProgressHUD()
@property (assign, nonatomic)float bottomInset;
@property (strong, nonatomic)UIControl *ctrToast;
@property (strong, nonatomic)UIControl *ctrActivity;

@property (strong, nonatomic)UIImageView *icon;
@property (strong, nonatomic)UILabel *content;
@end
@implementation LSProgressHUD
static LSProgressHUD *instance = nil;
+ (void)load
{
    instance = [[LSProgressHUD alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(keyboardDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}
+ (LSProgressHUD*)sharedProgressHUD
{
    return instance;
}
+ (void)show
{
    [LSProgressHUD showActivity];
}
+ (void)dismiss
{
    [instance.ctrActivity removeFromSuperview];
    [instance.ctrToast removeFromSuperview];
}
+ (void)showMessage:(NSString*)message
{
    [LSProgressHUD showToastWithImage:nil andText:message];
}
+ (void)showErrorMessage:(NSString*)message
{
    [LSProgressHUD showToastWithImage:[self imageNamed:@"wrong"] andText:message];
}
+ (void)showSuccessMessage:(NSString*)message
{
    [LSProgressHUD showToastWithImage:[self imageNamed:@"right"] andText:message];
}
+ (void)showWarningMessage:(NSString*)message
{
    [LSProgressHUD showToastWithImage:[self imageNamed:@"wrong"] andText:message];
}
#pragma mark - private method
+ (UIImage *)imageNamed:(NSString *)name
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    //    [bundle URLForResource:@"OtherResources" withExtension:@"bundle"];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    
}
+ (void)showActivity
{
    [instance.ctrToast removeFromSuperview];
    if (!instance.ctrActivity) {
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectZero];
        instance.ctrActivity = control;
        [[UIApplication sharedApplication].keyWindow addSubview:control];
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(control.superview).insets(UIEdgeInsetsMake(0, 0, instance.bottomInset, 0));
        }];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        [control addSubview:view];
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        
        [view addSubview:visualEffectView];
        [visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(visualEffectView.superview);
        }];
        
        //
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [view addSubview:activityIndicator];
        [activityIndicator startAnimating];
        [activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.width.mas_equalTo(view.mas_width);
            make.height.mas_equalTo(view.mas_height);
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(100);
            make.center.equalTo(view.superview);
        }];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:instance.ctrActivity];
        
        [instance.ctrActivity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(instance.ctrActivity.superview).insets(UIEdgeInsetsMake(0, 0, instance.bottomInset, 0));
        }];
    }
}

+ (void)showToastWithImage:(UIImage*)image andText:(NSString*)text
{
    [instance.ctrActivity removeFromSuperview];
    if (!instance.ctrToast) {
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectZero];
        instance.ctrToast = control;
        [[UIApplication sharedApplication].keyWindow addSubview:control];
        
        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(control.superview).insets(UIEdgeInsetsMake(0, 0, instance.bottomInset, 0));
        }];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        
        [view addSubview:visualEffectView];
        [visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(visualEffectView.superview);
        }];
        [control addSubview:view];
        //icon
        UIImageView *icon = [[UIImageView alloc] initWithImage:image];
        if (image) {
            instance.icon = icon;
            [view addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(icon.superview);
                make.top.equalTo(icon.superview).offset(10);
                make.width.mas_equalTo(image.size.width);
                make.height.mas_equalTo(image.size.height);
            }];
        }
        //text
        UILabel *label = [[UILabel alloc] init];
        instance.content = label;
        label.text = text;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:69/255.f green:69/255.f blue:69/255.f alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (image) {
                make.top.equalTo(icon.mas_bottom).offset(10);
            }else{
                make.top.equalTo(view).offset(10);
            }
            make.bottom.equalTo(view).offset(-10);
            make.right.lessThanOrEqualTo(view).offset(-20);
            make.left.greaterThanOrEqualTo(view).offset(20);
            make.centerX.equalTo(view);
        }];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view.superview);
            make.width.lessThanOrEqualTo(@270);
        }];
        
        
        [control layoutIfNeeded];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:instance.ctrToast];
        instance.icon.image = image;
        instance.content.text = text;
        [instance.ctrToast mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(instance.ctrToast.superview).insets(UIEdgeInsetsMake(0, 0, instance.bottomInset, 0));
        }];
    }
    //更新toast内容
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(visible_duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LSProgressHUD dismiss];
    });
}
#pragma mark - keyboard notification
- (void)keyboardDidChange:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    self.bottomInset = [UIScreen mainScreen].bounds.size.height - [aValue CGRectValue].origin.y;
}
@end
