//
//  MBSummaryStatisticsTableViewCell.h
//  MBStatistics
//
//  Created by Nikolay Galkin on 31.10.16.
//  Copyright © 2016 MyBook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBSummaryStatisticsTableViewCell : UITableViewCell

- (void)fillWithReadCount:(NSInteger)readCount readingSeconds:(NSInteger)readingSeconds wishlistCount:(NSInteger)wishlistCount;

+ (CGFloat)height;

@end
