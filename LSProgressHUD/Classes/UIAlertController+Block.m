//
//  TTFloatButton.m
//  TutorTalk-Consultant
//
//  Created by ThoamsTan on 16/8/4.
//  Copyright © 2016年 eddytsai. All rights reserved.
//

#import "TTFloatButton.h"
@interface TTFloatButton()
@property(nonatomic, strong)NSValue *startPoint;
@property (nonatomic, copy)FloatButtonTaped floatButtonTaped;
@end
@implementation TTFloatButton
static TTFloatButton *floatButton = nil;
+ (TTFloatButton *)sharedFloatButtonWithBlock:(FloatButtonTaped)floatButtonTaped
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        floatButton = [[TTFloatButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        
        floatButton.backgroundColor = [UIColor blackColor];
        floatButton.alpha = 0.8;
        floatButton.floatButtonTaped = floatButtonTaped;
        floatButton.layer.cornerRadius = 5;
        floatButton.layer.borderWidth = 1;
        floatButton.layer.borderColor = [UIColor whiteColor].CGColor;
        floatButton.windowLevel = UIWindowLevelAlert + 1;
        floatButton.hidden = NO;
        floatButton.rootViewController = [[UIViewController alloc] init];
        //
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:floatButton action:@selector(panGesture:)];
        [floatButton addGestureRecognizer:pan];
        //
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:floatButton action:@selector(tapGesture:)];
        [floatButton addGestureRecognizer:tap];
    });
    return floatButton;
}
- (void)panGesture:(UIPanGestureRecognizer*)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint currentPoint = [pan translationInView:[UIApplication sharedApplication].keyWindow];
            self.startPoint = [NSValue valueWithCGPoint:currentPoint];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self setCenter:[pan locationInView:[UIApplication sharedApplication].keyWindow]];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            CGPoint currentPoint = [pan locationInView:[UIApplication sharedApplication].keyWindow];
            NSInteger right = [UIApplication sharedApplication].keyWindow.frame.size.width - currentPoint.x;
            
            [UIView animateWithDuration:0.5 animations:^{
                CGPoint newPoint;
                float y = 0;
                if (currentPoint.y - self.frame.size.height/2 < 0) {
                    y = self.frame.size.height/2;
                }else if (currentPoint.y + self.frame.size.height/2> [UIApplication sharedApplication].keyWindow.frame.size.height) {
                    y = [UIApplication sharedApplication].keyWindow.frame.size.height - self.frame.size.height/2;
                } else {
                    y = currentPoint.y;
                }
                if (currentPoint.x < right) {
                    newPoint = CGPointMake(self.frame.size.width/2, y);
                }else{
                    newPoint = CGPointMake([UIApplication sharedApplication].keyWindow.frame.size.width - self.frame.size.width/2, y);
                }
                
                [self setCenter:newPoint];
            }];
            break;
        }
        default:
            break;
    }
}
- (void)tapGesture:(UITapGestureRecognizer*)tap
{
    if (self.floatButtonTaped)
    {
        self.floatButtonTaped();
    }
}
@end
