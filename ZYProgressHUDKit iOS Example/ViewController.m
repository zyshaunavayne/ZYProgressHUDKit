//
//  ViewController.m
//  ZYProgressHUDKit iOS Example
//
//  Created by 张宇 on 2023/2/8.
//

#import "ViewController.h"
#import "ZYProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[@"显示loading1",@"显示loading2",@"显示提示",@"显示很长的提示",@"沙漏效果loading"];
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 10 + i;
        btn.backgroundColor = UIColor.blueColor;
        [btn setTitle:array[i] forState:0];
        [self.view addSubview:btn];
        btn.frame = CGRectMake(100, 50 + 80 * i, 150, 50);
        [btn addTarget:self action:@selector(showBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)showBtn:(UIButton *)btn
{
    switch (btn.tag - 10) {
        case 0:
            [ZYProgressHUD showHUD];
            break;
        case 1:
            [ZYProgressHUD showHUDAddedTo:self.view];
            break;
        case 2:
            [ZYProgressHUD showMessage:@"显示提示"];
            break;
        case 3:
            [ZYProgressHUD showMessage:@"陕师大是的是的是的是的是的实打实是多少的的"];
            break;
        case 4:
            [ZYProgressHUD showHUDAddedTo:self.view style:ZYProgressHUDLoadingStyleRotate];
            break;
        default:
            break;
    }
    
    [self performSelector:@selector(hideHud) withObject:nil afterDelay:3.0];
}

- (void)hideHud
{
    [ZYProgressHUD hideHUD];
    [ZYProgressHUD hideHUDForView:self.view];
}

@end
