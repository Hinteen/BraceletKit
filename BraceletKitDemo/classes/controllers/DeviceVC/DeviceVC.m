//
//  DeviceVC.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 26/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "DeviceVC.h"
#import "DeviceCollectionView.h"
#import "DeviceCollectionViewCell.h"
#import <BraceletKit/BraceletKit.h>
#import <AXKit/AXKit.h>

static NSString *deviceCollectionCell = @"deviceCollectionCell";

@interface DeviceVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//@property (assign, nonatomic) NSUInteger bindDeviceCount;
@property (strong, nonatomic) NSMutableArray<ZeronerBlePeripheral *> *bindDevices;

@end

@implementation DeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupValues];
    [self setupCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupValues{
//    self.bindDeviceCount = 0;
    self.bindDevices = [NSMutableArray array];
    
}

- (void)setupCollectionView{
//    UICollectionViewLayout *lay = [[UICollectionViewLayout alloc] init];
//    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:lay];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DeviceCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:deviceCollectionCell];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bindDevices.count + 3;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DeviceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:deviceCollectionCell forIndexPath:indexPath];
    if (indexPath.row < self.bindDevices.count) {
        cell.device = self.bindDevices[indexPath.row];
    } else {
        cell.device = nil;
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.width, self.view.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}



@end
