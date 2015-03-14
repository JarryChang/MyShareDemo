//
//  ViewController.m
//  MyShareDemo
//
//  Created by chang on 14/11/12.
//  Copyright (c) 2014年 chang. All rights reserved.
//

#import "ViewController.h"
#import "COShareView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- Share Btn 点击事件
- (IBAction)sharebtnClicked:(id)sender {

    NSString *ad = @"我在使用沐风客户端新推出的\"预约打车\"服务，首次预约打车去上海浦东国际机场，即送20元话费，打车去上海虹桥机场送10元话费。小伙伴们，快去下载沐风客户端 http://www.baidu.com/client.html";
    [COShareView showShareViewContent:ad];
    
}




@end
