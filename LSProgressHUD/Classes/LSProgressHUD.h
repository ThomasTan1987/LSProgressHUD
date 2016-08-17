//
//  LSProgressHUD.h
//  Demo
//
//  Created by ThoamsTan on 16/7/28.
//  Copyright © 2016年 ThoamsTan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSProgressHUD : NSObject
+ (void)show;
+ (void)dismiss;
+ (void)showMessage:(NSString*)message;
+ (void)showErrorMessage:(NSString*)message;
+ (void)showSuccessMessage:(NSString*)message;
+ (void)showWarningMessage:(NSString*)message;
@end
