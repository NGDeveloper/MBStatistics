//
//  MBNicheTableViewCell.h
//  MBStatistics
//
//  Created by Nikolay Galkin on 30.10.16.
//  Copyright © 2016 MyBook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNicheTableViewCell : UITableViewCell

- (void)fillWithNicheID:(NSInteger)nicheID
              nicheName:(NSString *)nicheName
          wishlistCount:(NSInteger)wishlistCount
           readingCount:(NSInteger)readingCount
              readCount:(NSInteger)readCount
     allNicheBooksCount:(NSInteger)allNicheBooksCount
      allUserBooksCount:(NSInteger)allUserBooksCount;

+ (CGFloat)height;

@end
