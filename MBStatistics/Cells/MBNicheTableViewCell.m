//
//  MBNicheTableViewCell.m
//  MBStatistics
//
//  Created by Nikolay Galkin on 30.10.16.
//  Copyright © 2016 MyBook. All rights reserved.
//

#import "MBNicheTableViewCell.h"
#import "UIColor+NGAdditions.h"

@interface MBNicheTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *nicheImageView;
@property (nonatomic, weak) IBOutlet UILabel *nicheNameLabel;

@property (nonatomic, weak) IBOutlet UILabel *wishlistCountLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wishlistCountLabelLeadingConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wishlistCountLabelTrailingConstraint;

@property (nonatomic, weak) IBOutlet UILabel *readingCountLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *readingCountLabelLeadingConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *readingCountLabelTrailingConstraint;

@property (nonatomic, weak) IBOutlet UILabel *readCountLabel;

@property (nonatomic, weak) IBOutlet UIView *progressBackgroundView;
@property (nonatomic, weak) IBOutlet UIView *progressView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *progressViewEqualWidthConstraint;

@end

@implementation MBNicheTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Self Methods
#pragma mark Public

- (void)fillWithNicheID:(NSInteger)nicheID
              nicheName:(NSString *)nicheName
          wishlistCount:(NSInteger)wishlistCount
           readingCount:(NSInteger)readingCount
              readCount:(NSInteger)readCount
     allNicheBooksCount:(NSInteger)allNicheBooksCount
      allUserBooksCount:(NSInteger)allUserBooksCount {
    // Fill niche's image and name.
    self.nicheImageView.image = [self badgeImageForNicheID:nicheID];
    self.nicheNameLabel.text = nicheName;
    
    // Set niche's progress view color and value.
    self.progressView.backgroundColor = [self colorForNicheID:nicheID];
    CGFloat multiplierForConstraint = (CGFloat)allNicheBooksCount / (CGFloat)allUserBooksCount;
    [self.contentView removeConstraint:self.progressViewEqualWidthConstraint];
    self.progressViewEqualWidthConstraint = [NSLayoutConstraint constraintWithItem:self.progressView
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.progressBackgroundView
                                                                         attribute:NSLayoutAttributeWidth
                                                                        multiplier:multiplierForConstraint
                                                                          constant:0.0];
    [self.contentView addConstraint:self.progressViewEqualWidthConstraint];
    
    // Fill niche's counters.
    NSDictionary *textAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                                      NSForegroundColorAttributeName : [UIColor colorWithWhite:1.0 alpha:0.6]};
    NSDictionary *countAttributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12.0],
                                       NSForegroundColorAttributeName : [UIColor colorWithWhite:1.0 alpha:1.0]};
    if (wishlistCount > 0) {
        NSString *wishlistTextString = @"хочу прочитать ";
        NSMutableAttributedString *wishlistAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%ld", wishlistTextString, (long)wishlistCount]];
        NSInteger wishlistTextLength = wishlistTextString.length;
        NSInteger wishlistCountLength = wishlistAttributedString.length - wishlistTextLength;
        [wishlistAttributedString addAttributes:textAttributes range:NSMakeRange(0, wishlistTextLength)];
        [wishlistAttributedString addAttributes:countAttributes range:NSMakeRange(wishlistTextLength, wishlistCountLength)];
        self.wishlistCountLabel.attributedText = wishlistAttributedString;
        self.wishlistCountLabelLeadingConstraint.constant = 8.0;
    } else {
        self.wishlistCountLabel.attributedText = [[NSAttributedString alloc] init];
        self.wishlistCountLabelLeadingConstraint.constant = 0.0;
    }
    
    if (readingCount > 0) {
        NSString *readingTextString = @"читаю ";
        NSMutableAttributedString *readingAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%ld", readingTextString, (long)readingCount]];
        NSInteger readingTextLength = readingTextString.length;
        NSInteger readingCountLength = readingAttributedString.length - readingTextLength;
        [readingAttributedString addAttributes:textAttributes range:NSMakeRange(0, readingTextLength)];
        [readingAttributedString addAttributes:countAttributes range:NSMakeRange(readingTextLength, readingCountLength)];
        self.readingCountLabel.attributedText = readingAttributedString;
        self.readingCountLabelLeadingConstraint.constant = 8.0;
    } else {
        self.readingCountLabel.attributedText = [[NSAttributedString alloc] init];
        self.readingCountLabelLeadingConstraint.constant = 0.0;
    }
    
    if (readCount > 0) {
        NSString *readTextString = @"прочитал ";
        NSMutableAttributedString *readAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%ld", readTextString, (long)readCount]];
        NSInteger readTextLength = readTextString.length;
        NSInteger readCountLength = readAttributedString.length - readTextLength;
        [readAttributedString addAttributes:textAttributes range:NSMakeRange(0, readTextLength)];
        [readAttributedString addAttributes:countAttributes range:NSMakeRange(readTextLength, readCountLength)];
        self.readCountLabel.attributedText = readAttributedString;
    } else {
        self.readCountLabel.attributedText = [[NSAttributedString alloc] init];
    }
}

+ (CGFloat)height {
    return 72.0;
}

#pragma mark Private

- (UIImage *)badgeImageForNicheID:(NSInteger)nicheID {
    UIImage *badgeImage = nil;
    NSString *nicheIDString = [NSString stringWithFormat:@"%ld", (long)nicheID];
    NSDictionary *badgeImageNameForID = @{ @"13" : @"NicheHumor",
                                           @"2895" : @"NicheErotica",
                                           @"2894" : @"NicheEsoterics",
                                           @"22" : @"NicheFantasy",
                                           @"2" : @"NicheFantasticTales" };
    if ([badgeImageNameForID.allKeys containsObject:nicheIDString]) {
        badgeImage = [UIImage imageNamed:badgeImageNameForID[nicheIDString]];
    }
    return badgeImage;
}

- (UIColor *)colorForNicheID:(NSInteger)nicheID {
    UIColor *color = [UIColor grayColor];
    NSString *nicheIDString = [NSString stringWithFormat:@"%ld", (long)nicheID];
    NSDictionary *colorForID = @{ @"13" : @"#C2FF00",
                                  @"2895" : @"#FF496F",
                                  @"2894" : @"#E2825A",
                                  @"22" : @"#A349C1",
                                  @"2" : @"#BF8BEB" };
    if ([colorForID.allKeys containsObject:nicheIDString]) {
        color = [UIColor ng_colorWithRGBHexString:colorForID[nicheIDString]];
    }
    return color;
}

@end
