//
//  MBSummaryStatisticsTableViewCell.m
//  MBStatistics
//
//  Created by Nikolay Galkin on 31.10.16.
//  Copyright © 2016 MyBook. All rights reserved.
//

#import "MBSummaryStatisticsTableViewCell.h"
#import "NSNumber+NGAdditions.h"

@interface MBSummaryStatisticsTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *readCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *readUnitLabel;

@property (nonatomic, weak) IBOutlet UILabel *readingTimeCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *readingTimeUnitLabel;

@property (nonatomic, weak) IBOutlet UILabel *wishToReadCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *wishToReadUnitLabel;


@end

@implementation MBSummaryStatisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Self Methods
#pragma mark Public

- (void)fillWithReadCount:(NSInteger)readCount readingSeconds:(NSInteger)readingSeconds wishlistCount:(NSInteger)wishlistCount {
    // Set read books count with correct word's form.
    self.readCountLabel.text = [NSString stringWithFormat:@"%ld", (long)readCount];
    self.readUnitLabel.text = [@(readCount) ng_numeralStringFor1:@"книга"
                                                          for234:@"книги"
                                                        forOther:@"книг"
                                                      withNumber:NO];
    
    // Calculate most valuable unit for displaying reading time with correct word's form.
    if (readingSeconds < 60) {
        self.readingTimeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)readingSeconds];
        self.readingTimeUnitLabel.text = [@(readingSeconds) ng_numeralStringFor1:@"секунда"
                                                                          for234:@"секунды"
                                                                        forOther:@"секунд"
                                                                      withNumber:NO];
    } else {
        NSInteger readingMinutes = readingSeconds / 60;
        if (readingMinutes < 60) {
            self.readingTimeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)readingMinutes];
            self.readingTimeUnitLabel.text = [@(readingMinutes) ng_numeralStringFor1:@"минута"
                                                                              for234:@"минуты"
                                                                            forOther:@"минут"
                                                                          withNumber:NO];
        } else {
            NSInteger readingHours = readingMinutes / 60;
            if (readingHours < 24) {
                self.readingTimeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)readingHours];
                self.readingTimeUnitLabel.text = [@(readingHours) ng_numeralStringFor1:@"час"
                                                                                for234:@"часа"
                                                                              forOther:@"часов"
                                                                            withNumber:NO];
            } else {
                NSInteger readingDays = readingHours / 24;
                if (readingDays < 365) {
                    self.readingTimeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)readingDays];
                    self.readingTimeUnitLabel.text = [@(readingDays) ng_numeralStringFor1:@"день"
                                                                                   for234:@"дня"
                                                                                 forOther:@"дней"
                                                                               withNumber:NO];
                } else {
                    NSInteger readingYears = readingDays / 365;
                    self.readingTimeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)readingYears];
                    self.readingTimeUnitLabel.text = [@(readingYears) ng_numeralStringFor1:@"год"
                                                                                    for234:@"года"
                                                                                  forOther:@"лет"
                                                                                withNumber:NO];
                }
            }
        }
    }
    
    // Set wish to read books count with correct word's form.
    self.wishToReadCountLabel.text = [NSString stringWithFormat:@"%ld", (long)wishlistCount];
    self.wishToReadUnitLabel.text = [@(wishlistCount) ng_numeralStringFor1:@"книга"
                                                                    for234:@"книги"
                                                                  forOther:@"книг"
                                                                withNumber:NO];
}

+ (CGFloat)height {
    return 160.0;
}

@end
