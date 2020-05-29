//
//  ViewController.m
//  STPrivacyDemo
//
//  Created by Jivan on 2020/5/25.
//  Copyright © 2020 Jivan. All rights reserved.
//

#import "ViewController.h"
#import "STPrivacyAuthorizationTool.h"
#import "STPrivacySettingCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray <STPrivacySettingModel*>*dataSource; //数据源
@property (nonatomic,strong) UITableView *tableView;

@end

static const NSString *KEY_APP_NAME = @"STPrivacyDemo";

@implementation ViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"隐私设置";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self packageDataSource] ;
    [self.tableView reloadData];
}

-(void)applicationWillEnterForegroundNotification:(NSNotification *)notification{
    [self packageDataSource] ;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    STPrivacySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([STPrivacySettingCell class]) forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    STPrivacySettingModel *model = self.dataSource[indexPath.row];
    if (model.status == STAuthorizationStatus_NotDetermined) {
        //首次访问相应内容会提示用户进行授权
        if (model.type == STPrivacyType_LocationServices) {//定位
            STPrivacyAuthorizationTool *tool = [[STPrivacyAuthorizationTool alloc]init];
            [tool requestLocationAccessStatus:^(STAuthorizationStatus status, STPrivacyType type) {
                model.status = status ;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            }];
        }else{//其他
            [STPrivacyAuthorizationTool requestAccessForType:model.type accessStatus:^(STAuthorizationStatus status, STPrivacyType type) {
                model.status = status ;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            }];
        }
    }else{
        //打开应用设置
        [STPrivacyAuthorizationTool openApplicationSetting];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView =[[ UITableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(tableView.frame), 40.f)];
        headerView.contentView.backgroundColor = UIColor.whiteColor;
        headerView.textLabel.text = self.navigationItem.title;
        headerView.textLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return headerView;
}
-(void)packageDataSource{
    
    STPrivacySettingModel *model ;
    NSMutableArray <STPrivacySettingModel*>*dataSource = [NSMutableArray array];
    
    model = [[STPrivacySettingModel alloc]init];
    model.type = STPrivacyType_LocationServices;
    model.title = [NSString stringWithFormat:@"允许%@访问位置信息",KEY_APP_NAME];
    model.subTitle = @"位置信息使用规则" ;
    model.pageUrl = @"locationAgreement.html";
    model.status = [STPrivacyAuthorizationTool checkAuthorizationStatusForType:STPrivacyType_LocationServices];
    [dataSource addObject:model];
    
    model = [[STPrivacySettingModel alloc]init];
    model.type = STPrivacyType_Camera;
    model.title = [NSString stringWithFormat:@"允许%@使用相机功能",KEY_APP_NAME];
    model.subTitle = @"相机权限使用规则" ;
    model.pageUrl = @"CameraAgreement.html";
    model.status = [STPrivacyAuthorizationTool checkAuthorizationStatusForType:STPrivacyType_Camera];
    [dataSource addObject:model];
    
    model = [[STPrivacySettingModel alloc]init];
    model.type = STPrivacyType_Photos;
    model.title = [NSString stringWithFormat:@"允许%@使用相册存储和访问功能",KEY_APP_NAME];
    model.subTitle = @"相册存储和访问权限使用规则" ;
    model.pageUrl = @"AlbumAgreement.html";
    model.status = [STPrivacyAuthorizationTool checkAuthorizationStatusForType:STPrivacyType_Photos];
    [dataSource addObject:model];
    
    model = [[STPrivacySettingModel alloc]init];
    model.type = STPrivacyType_Microphone;
    model.title = [NSString stringWithFormat:@"允许%@使用麦克风功能",KEY_APP_NAME];
    model.subTitle = @"麦克风权限使用规则" ;
    model.pageUrl = @"RecordAgreement.html";
    model.status = [STPrivacyAuthorizationTool checkAuthorizationStatusForType:STPrivacyType_Microphone];
    [dataSource addObject:model];
    
    model = [[STPrivacySettingModel alloc]init];
    model.type = STPrivacyType_Calendars;
    model.title = [NSString stringWithFormat:@"允许%@使用日历功能",KEY_APP_NAME];
    model.subTitle = @"日历权限使用规则" ;
    model.pageUrl = @"RecordAgreement.html";
    model.status = [STPrivacyAuthorizationTool checkAuthorizationStatusForType:STPrivacyType_Calendars];
    [dataSource addObject:model];
    
    model = [[STPrivacySettingModel alloc]init];
    model.type = STPrivacyType_Reminders;
    model.title = [NSString stringWithFormat:@"允许%@使用提醒事项功能",KEY_APP_NAME];
    model.subTitle = @"提醒事项权限使用规则" ;
    model.pageUrl = @"RecordAgreement.html";
    model.status = [STPrivacyAuthorizationTool checkAuthorizationStatusForType:STPrivacyType_Reminders];
    [dataSource addObject:model];
    
    self.dataSource = dataSource ;
    
}

#pragma mark - getter

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self ;
        _tableView.dataSource = self ;
        [_tableView registerClass:[STPrivacySettingCell class] forCellReuseIdentifier:NSStringFromClass([STPrivacySettingCell class])];
        _tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end

