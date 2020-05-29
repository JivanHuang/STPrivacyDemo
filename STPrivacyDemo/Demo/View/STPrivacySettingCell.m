//
//  STPrivacySettingCell.m
//  HTSJ
//
//  Created by Jivan on 2020/5/20.
//  Copyright © 2020 北京红云融通技术有限公司. All rights reserved.
//

#import "STPrivacySettingCell.h"
#import <Masonry.h>

@interface STPrivacySettingCell()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UIButton *linkButton;

@end

@implementation STPrivacySettingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupUI];
        [self configureFont];
        [self configureColor];
    }
    return self;
}
-(void)configureFont{
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _subTitleLabel.font= [UIFont systemFontOfSize:12];
    _linkButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _statusLabel.font = [UIFont systemFontOfSize:12];
}
-(void)configureColor{
    _titleLabel.textColor = UIColor.darkTextColor ;
    _subTitleLabel.textColor = UIColor.lightGrayColor ;
    _statusLabel.textColor =  UIColor.lightGrayColor ;
    [_linkButton setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    [_linkButton setTitleColor:UIColor.systemRedColor forState:UIControlStateHighlighted];
}
-(void)setupUI{
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.linkButton];
    [self.contentView addSubview:self.statusLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(15);
        make.width.mas_lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.82);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-8);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.subTitleLabel);
        make.left.equalTo(self.subTitleLabel.mas_right);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-6.5);
    }];
    
}
-(void)setModel:(STPrivacySettingModel *)model{
    _model = model ;
    _titleLabel.text = model.title ;
    [_linkButton setTitle:model.subTitle forState:UIControlStateNormal];
    [self congfigureStateLabelWithStatus:model.status];
    [self configureColor];
}

-(void)congfigureStateLabelWithStatus:(STAuthorizationStatus) status{
    
    if (status == STAuthorizationStatus_Authorized || status == STAuthorizationStatus_LocationAlways || status == STAuthorizationStatus_LocationWhenInUse) {
        _statusLabel.text = @"已开启";
    }else{
        _statusLabel.text = @"去设置";
    }
    
}


- (void)didTapLink{
    
}

#pragma mark - getter
-(UIButton *)linkButton{
    if (!_linkButton) {
        _linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_linkButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_linkButton addTarget:self action:@selector(didTapLink) forControlEvents:UIControlEventTouchUpInside];
    }
    return _linkButton;
}
-(UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
    }
    return _statusLabel;
}
-(UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _subTitleLabel.text = @"查看详细";
    }
    return _subTitleLabel;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
    }
    return _titleLabel;
}
@end
