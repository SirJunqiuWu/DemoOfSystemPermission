//
//  ViewController.m
//  DemoOfSystemPermissions
//
//  Created by 吴 吴 on 16/11/8.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <ContactsUI/ContactsUI.h>

#import "WJQSystemPermissionManager.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    /**
     *  创建CNContactStore对象,用与获取和保存通讯录信息
     */
    CNContactStore *contactStore;
}

@property(nonatomic,strong)UIImagePickerController *imagePicker;
@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建UI

- (void)setupUI {
    
    float btnW = self.view.frame.size.width/3;
    
    UIButton *one = [UIButton buttonWithType:UIButtonTypeCustom];
    [one setTitle:@"相册" forState:UIControlStateNormal];
    [one setBackgroundColor:[UIColor blackColor]];
    [one addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    one.tag = 1000+0;
    [self.view addSubview:one];
    
    UIButton *two = [UIButton buttonWithType:UIButtonTypeCustom];
    [two setTitle:@"相机" forState:UIControlStateNormal];
    [two setBackgroundColor:[UIColor orangeColor]];
    [two addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    two.tag = 1000+1;
    [self.view addSubview:two];
    
    UIButton *three = [UIButton buttonWithType:UIButtonTypeCustom];
    [three setTitle:@"语音" forState:UIControlStateNormal];
    [three setBackgroundColor:[UIColor purpleColor]];
    [three addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    three.tag = 1000+2;
    [self.view addSubview:three];
    
    UIButton *four = [UIButton buttonWithType:UIButtonTypeCustom];
    [four setTitle:@"通讯录" forState:UIControlStateNormal];
    [four setBackgroundColor:[UIColor redColor]];
    [four addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    four.tag = 1000+3;
    [self.view addSubview:four];
    
    [one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.equalTo(self.view);
        make.width.mas_equalTo(btnW);
        make.height.equalTo(one.mas_width).with.multipliedBy(0.5);
    }];
    
    [two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.equalTo(one.mas_right);
        make.width.equalTo(one);
        make.height.equalTo(one.mas_height);
    }];
    
    [three mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(two);
        make.left.equalTo(two.mas_right);
        make.width.equalTo(two);
        make.height.equalTo(two);
    }];
    
    [four mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(one.mas_bottom);
        make.left.equalTo(one);
        make.width.equalTo(one);
        make.height.equalTo(one);
    }];
}

#pragma mark - Getter

- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}

#pragma mark - 按钮点击事件

- (void)btnPressed:(UIButton *)btn {
    NSInteger index = btn.tag - 1000;
    if (index == 0)
    {
        NSLog(@"相册");
        [self getPhoto];
    }
    else if (index == 1)
    {
        NSLog(@"相机");
        [self takePhoto];
    }
    else if (index == 2)
    {
        NSLog(@"语音");
        [[WJQSystemPermissionManager sharedManager]checkAudioAuthorizationStatusWithCallback:^(AuthStatus status) {
            //想有其他处理可在获取状态后自行处理:拒绝后可跳转到系统设置里面进行开启
            //配置URL Scheme:prefs
            //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"prefs:root=privacy"]];
        }];
    }
    else if (index == 3)
    {
        NSLog(@"通讯录");
        if (!contactStore)
        {
            contactStore = [[CNContactStore alloc]init];
        }
       if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined)
       {
           [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error)
            {
                if (error) return;
                if (granted)
                {
                    NSLog(@"授权访问通讯录");
                    //开始拿到通讯录的联系人 如下demo就有
                    //https://github.com/SirJunqiuWu/DemoOfGetPhoneAllContacts
                }
                else
                {
                    NSLog(@"拒绝访问通讯录");
                }
            }];
       }
    }
    else
    {
        
    }
}

- (void)takePhoto {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (void)getPhoto {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}


@end
