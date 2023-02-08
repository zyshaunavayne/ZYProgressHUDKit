//
//  ZYProgressHUD.m
//  ZYProgressHUDKit
//
//  Created by 张宇 on 2023/2/8.
//

#import "ZYProgressHUD.h"
#import "MBProgressHUD.h"
@import Lottie;

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif

/// 用来专门显示 需要全屏覆盖的loading的界面
static __weak MBProgressHUD *loadHud;

/// 用来专门显示提示消息的
static __weak MBProgressHUD *messageHud;

@interface ZYProgressHUD ()
@property (nonatomic, assign) ZYProgressHUDLoadingStyle style;
@end

@implementation ZYProgressHUD

+ (NSBundle *)resourceBundle
{
    static NSBundle *resourceBundle = nil;
    if (!resourceBundle) {
        NSBundle *mainBundle = [NSBundle bundleForClass:self];
        NSString *resourcePath = [mainBundle pathForResource:@"ZYProgressHUDKit_Resources" ofType:@"bundle"];
        resourceBundle = [NSBundle bundleWithPath:resourcePath] ?: mainBundle;
    }
    return resourceBundle;
}

- (instancetype)initWithStyle:(ZYProgressHUDLoadingStyle)style
{
    if (self = [super init]) {
        self.style = style;
        if (style == ZYProgressHUDLoadingStyleRotate) {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            self.layer.cornerRadius = 10;
        } else if (style == ZYProgressHUDLoadingStyleSandClock) {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            self.layer.cornerRadius = 10;
        }
    }
    return self;
}

+ (void)showHUD
{
    [ZYProgressHUD showHUDWithStyle:ZYProgressHUDLoadingStyleRotate];
}

+ (void)showHUDWithStyle:(ZYProgressHUDLoadingStyle)style
{
    [ZYProgressHUD showHUDWithStyle:style message:nil];
}

+ (void)showHUDWithStyle:(ZYProgressHUDLoadingStyle)style
                 message:(NSString *)message
{
    dispatch_main_async_safe(^{
        if (!loadHud || loadHud.finished) {
            MBProgressHUD *hud = [self.class HUDForView:[self.class contentView] style:style message:message];
            loadHud = hud;
        } else {
            UIView *contentView = [self.class contentView];
            if (loadHud.superview != contentView) {
                [contentView addSubview:loadHud];
            }
        }
        
        /// show
        [loadHud showAnimated:YES];
    });
}

+ (void)hideHUD
{
    dispatch_main_async_safe(^{
        if (loadHud || loadHud.hasFinished == NO) {
            loadHud.removeFromSuperViewOnHide = YES;
            [loadHud hideAnimated:YES];
        }
    })
}

+ (void)showAutoHUD
{
    dispatch_main_async_safe(^{
        [self showHUDAddedTo:[self.class currentViewController].view];
    });
}

+ (void)hideAutoHUD
{
    dispatch_main_async_safe(^{
        [self.class hideHUDForView:[self.class currentViewController].view];
    });
}

+ (void)showHUDAddedTo:(UIView *)view
{
    [self.class showHUDAddedTo:view animated:YES style:ZYProgressHUDLoadingStyleRotate userInteraction:NO message:nil];
}

+ (void)showHUDAddedTo:(UIView *)view
                 style:(ZYProgressHUDLoadingStyle)style
{
    [self.class showHUDAddedTo:view animated:YES style:style userInteraction:NO message:nil];
}

+ (void)showHUDAddedTo:(UIView *)view
                 style:(ZYProgressHUDLoadingStyle)style
               message:(NSString *)message
{
    [self.class showHUDAddedTo:view animated:YES style:style userInteraction:NO message:message];
}

+ (void)showHUDAddedTo:(UIView *)view
                 style:(ZYProgressHUDLoadingStyle)style
       userInteraction:(BOOL)enabled
{
    [ZYProgressHUD showHUDAddedTo:view animated:YES style:style userInteraction:enabled message:nil];
}

+ (void)showHUDAddedTo:(UIView *)view
                 style:(ZYProgressHUDLoadingStyle)style
       userInteraction:(BOOL)enabled
               message:(NSString *)message
{
    [ZYProgressHUD showHUDAddedTo:view animated:YES style:style userInteraction:enabled message:message];
}

+ (void)showHUDAddedTo:(UIView *)view
              animated:(BOOL)animated
                 style:(ZYProgressHUDLoadingStyle)style
       userInteraction:(BOOL)enabled
               message:(NSString *)message
{
    if (!view) {
        return;
    }
    dispatch_main_async_safe(^{
        MBProgressHUD *hud = [self.class HUDForView:view style:style message:message];
        [hud showAnimated:animated];
        hud.userInteractionEnabled = !enabled;
    });
}

+ (MBProgressHUD *)HUDForView:(UIView *)view
                        style:(ZYProgressHUDLoadingStyle)style
                      message:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud || hud.tag != 500003) {
        hud = [[MBProgressHUD alloc] initWithView:view];
        hud.tag = 500003;
        hud.backgroundView.color = [UIColor clearColor];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor clearColor];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.mode = MBProgressHUDModeCustomView;
        hud.removeFromSuperViewOnHide = YES;
        
        CGSize animationSize = CGSizeMake(50, 50);
        CGSize contentSize = CGSizeMake(80, 80);
        NSString *animationName = @"loading_2";
        if (style == ZYProgressHUDLoadingStyleBounce) {
            animationSize = CGSizeMake(200, 200);
            contentSize = CGSizeMake(220, 220);
            animationName = @"loading_7";
        } else if (style == ZYProgressHUDLoadingStyleSandClock) {
            animationSize = CGSizeMake(62, 62);
            contentSize = CGSizeMake(100, 100);
            animationName = @"loading_shalou";
        }
        
        /// 创建 contentView
        UIView *contentView = [[ZYProgressHUD alloc] initWithStyle:style];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView.widthAnchor constraintEqualToConstant:contentSize.width].active = YES;
        [contentView.heightAnchor constraintGreaterThanOrEqualToConstant:contentSize.height].active = YES;
        
        UILabel *label = nil;
        if (message.length > 0) {
            label = UILabel.new;
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.textColor = style == ZYProgressHUDLoadingStyleBounce ? UIColor.blackColor : UIColor.whiteColor;
            label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
            label.text = message;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [contentView addSubview:label];
        }
        
        hud.customView = contentView;
    
        NSURL *url = [[ZYProgressHUD resourceBundle] URLForResource:@"ZYProgressHUDKit" withExtension:@"bundle"];
        
        CompatibleAnimationView *animation = [[CompatibleAnimationView alloc] init];
        animation.compatibleAnimation = [[CompatibleAnimation alloc] initWithName:animationName bundle:[NSBundle bundleWithURL:url]];
        animation.translatesAutoresizingMaskIntoConstraints = NO;
        animation.contentMode = UIViewContentModeScaleAspectFit;
        animation.loopAnimationCount = -1;
        
        [contentView addSubview:animation];
        
        [animation.widthAnchor constraintEqualToConstant:animationSize.width].active = YES;
        [animation.heightAnchor constraintEqualToConstant:animationSize.height].active = YES;
        [animation.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor].active = YES;
        
        if (label) {
            [animation.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:5].active = YES;
            [label.topAnchor constraintEqualToAnchor:animation.bottomAnchor constant:5].active = YES;
            [label.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-5].active = YES;
            [label.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor].active = YES;
            [label.widthAnchor constraintLessThanOrEqualToConstant:71].active = YES;
        } else {
            [animation.centerYAnchor constraintEqualToAnchor:contentView.centerYAnchor].active = YES;
        }
        
        [animation play];
    }
    
    if (((ZYProgressHUD *)hud.customView).style != style) {
        [hud hideAnimated:NO];
        return [ZYProgressHUD HUDForView:view style:style message:message] ;
    }
    
    if (!hud.superview) {
        [view addSubview:hud];
    } else {
        [view bringSubviewToFront:hud];
    }
    return hud;
}

+ (void)hideHUDForView:(UIView *)view
{
    [self.class hideHUDForView:view animated:YES];
}

+ (void)hideHUDForView:(UIView *)view animated:(BOOL)animated
{
    if (!view) {
        return;
    }
    dispatch_main_async_safe(^{
        [MBProgressHUD hideHUDForView:view animated:animated];
    });
}

+ (void)showMessage:(NSString *)string
{
    [self.class showMessage:string position:ZYProgressHUDPositionCenter];
}

+ (void)showTopMessage:(NSString *)string
{
    [self.class showMessage:string position:ZYProgressHUDPositionTop];
}

+ (void)showBottomMessage:(NSString *)string
{
    [self.class showMessage:string position:ZYProgressHUDPositionBottom];
}

+ (void)showMessage:(NSString *)string position:(ZYProgressHUDPosition)position
{
    [self.class showMessage:string position:position dismissWithDelay:1.2f];;
}

+ (void)showMessage:(NSString *)string position:(ZYProgressHUDPosition)position dismissWithDelay:(NSTimeInterval)delay
{
    dispatch_main_async_safe(^{
        if (!messageHud || messageHud.hasFinished) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self.class contentView] animated:YES];
            hud.userInteractionEnabled = NO;
            hud.mode = MBProgressHUDModeText;
            hud.label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
            hud.label.numberOfLines = 0;
            hud.label.textColor = UIColor.whiteColor;
            hud.backgroundView.color = [UIColor clearColor];
            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            hud.margin = 20;
            hud.verticalMargin = 12;
            messageHud = hud;
        }
        messageHud.label.text = string;
        switch (position) {
            case ZYProgressHUDPositionCenter:
                messageHud.offset = CGPointMake(0.f, 0.f);
                break;
            case ZYProgressHUDPositionTop:
                messageHud.offset = CGPointMake(0.f, -MBProgressMaxOffset);
                break;
            case ZYProgressHUDPositionBottom:
                messageHud.offset = CGPointMake(0.f, 250);
                break;
            default:
                break;
        }
        [messageHud hideAnimated:YES afterDelay:delay];
    });
}

#pragma mark - other

+ (UIView *)contentView
{
    UIView *view;
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            view = window;
            break;
        }
    }
    return view;
}

+ (UIViewController *)currentViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

+ (UIViewController *)currentViewControllerFrom:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    } else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    } else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    } else {
        return viewController;
    }
}

@end


@implementation ZYProgressHUD (Deprecated)

+ (void)showSuccessWithStatus:(NSString *)status
{
    [ZYProgressHUD showMessage:status];
}

+ (void)showSuccessWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay
{
    [ZYProgressHUD showMessage:status];
}

+ (void)showErrorWithStatus:(NSString *)status
{
    [ZYProgressHUD showMessage:status];
}

+ (void)showErrorWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay
{
    [ZYProgressHUD showMessage:status];
}

+ (void)showWithStatus:(NSString *)status
{
    [ZYProgressHUD showMessage:status];
}

+ (void)showWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay
{
    [ZYProgressHUD showMessage:status];
}

+ (void)showInfoWithStatus:(NSString *)status
{
    [ZYProgressHUD showMessage:status];
}

+ (void)showInfoWithStatus:(NSString*)status dismissWithDelay:(NSTimeInterval)delay
{
    [ZYProgressHUD showMessage:status];
}

@end

