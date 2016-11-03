//
//  MBMainTableViewController.m
//  MBStatistics
//
//  Created by Nikolay Galkin on 30.10.16.
//  Copyright © 2016 MyBook. All rights reserved.
//

#import "MBMainTableViewController.h"
#import "MBSummaryStatisticsTableViewCell.h"
#import "MBNicheTableViewCell.h"
#import "MBEmptyNichesTableViewCell.h"
#import "MBStatisticsCoreDataStack.h"
#import "MBSummary+CoreDataClass.h"
#import "MBNiche+CoreDataClass.h"
#import "UIAlertController+NGAdditions.h"

@interface MBMainTableViewController ()

@property (nonatomic, strong) MBStatisticsCoreDataStack *coreDataStack;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) MBSummary *currentSummary;
@property (nonatomic, strong) NSMutableArray *currentNiches;
@property (nonatomic) BOOL isDownloadInProgress;

@end

@implementation MBMainTableViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize variables.
    self.currentNiches = [NSMutableArray array];
    
    // Initialize core data stack.
    self.coreDataStack = [[MBStatisticsCoreDataStack alloc] init];
    self.managedObjectContext = self.coreDataStack.managedObjectContext;
    
    // Rigister nibs for cells.
    NSString *nicheCellReuseIdentifier = NSStringFromClass(MBNicheTableViewCell.class);
    UINib *nicheNib = [UINib nibWithNibName:nicheCellReuseIdentifier bundle:nil];
    [self.tableView registerNib:nicheNib forCellReuseIdentifier:nicheCellReuseIdentifier];
    
    NSString *summaryCellReuseIdentifier = NSStringFromClass(MBSummaryStatisticsTableViewCell.class);
    UINib *summaryNib = [UINib nibWithNibName:summaryCellReuseIdentifier bundle:nil];
    [self.tableView registerNib:summaryNib forCellReuseIdentifier:summaryCellReuseIdentifier];
    
    NSString *emptyNichesCellReuseIdentifier = NSStringFromClass(MBEmptyNichesTableViewCell.class);
    UINib *emptyNichesNib = [UINib nibWithNibName:emptyNichesCellReuseIdentifier bundle:nil];
    [self.tableView registerNib:emptyNichesNib forCellReuseIdentifier:emptyNichesCellReuseIdentifier];
    
    [self fetchDataFromDatabase];
    [self downloadAndSaveNiches];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Self Methods
#pragma mark Private

- (void)downloadAndSaveNiches {
    if (self.isDownloadInProgress) {
        return;
    }
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURL *url = [NSURL URLWithString:@"http://www.mocky.io/v2/57ff840b1300006c09cce2d8"];
//    NSURL *url = [NSURL URLWithString:@"http://www.mocky.io/v2/581a6f60260000c9004b6af8"];
//    NSURL *url = [NSURL URLWithString:@"http://www.mocky.io/v2/581a8dfd26000083014b6b01"];
//    NSURL *url = [NSURL URLWithString:@"http://www.mocky.io/v2/581a98a3260000c6014b6b05"];
//    NSURL *url = [NSURL URLWithString:@"http://www.mocky.io/v2/581a995b260000b8014b6b07"];
    [self.refreshControl beginRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.isDownloadInProgress = YES;
    __weak __typeof(self)weakSelf = self;
    [[session dataTaskWithURL:url
            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __typeof(weakSelf)blockSelf = weakSelf;
        if (data) {
            NSError *error = nil;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            // Delete all niches from DB for the case when niches count decrease.
            [blockSelf deleteAllNicheObjects];
            
            int32_t allUserBooksCount = 0;
            for (NSDictionary *nicheDictionary in jsonObject[@"niche_stats"]) {
                MBNiche *niche = [blockSelf uniqueNicheWithID:nicheDictionary[@"niche"][@"id"]];
                niche.name = nicheDictionary[@"niche"][@"name"];
                niche.resourceURI = nicheDictionary[@"niche"][@"resource_uri"];
                niche.slug = nicheDictionary[@"niche"][@"slug"];
                niche.wishlistCount = [nicheDictionary[@"wishlist_count"] intValue];
                niche.readingCount = [nicheDictionary[@"nowreading_count"] intValue];
                niche.readCount = [nicheDictionary[@"read_count"] intValue];
                niche.allBooksCount = niche.wishlistCount + niche.readingCount + niche.readCount;
                allUserBooksCount = allUserBooksCount + niche.allBooksCount;
            }
            
            MBSummary *summary = [blockSelf uniqueSummary];
            summary.wishlistCount = [jsonObject[@"wishlist_count"] intValue];
            summary.readingCount = [jsonObject[@"nowreading_count"] intValue];
            summary.readCount = [jsonObject[@"read_count"] intValue];
            summary.secondsCount = [jsonObject[@"seconds_count"] intValue];
            summary.allUserBooksCount = allUserBooksCount;
            
            [blockSelf.coreDataStack saveContext];
            
            [blockSelf performSelectorOnMainThread:@selector(fetchDataFromDatabase) withObject:nil waitUntilDone:NO];
        } else {
            [UIAlertController showAlertWithTitle:@"Error" message:error.localizedDescription inViewController:blockSelf];
        }
        [blockSelf.refreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        blockSelf.isDownloadInProgress = NO;
    }] resume];
}

- (void)fetchDataFromDatabase {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MBNiche"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"allBooksCount" ascending:NO];
    fetchRequest.sortDescriptors = @[ sortDescriptor ];
    
    NSError *error = nil;
    self.currentNiches = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error].mutableCopy;
    if (error) {
        NSLog(@"Error fetching MBNiche objects: %@", error);
    }
    
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MBSummary"];
    self.currentSummary = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error].firstObject;
    if (error) {
        NSLog(@"Error fetching MBSummary objects: %@", error);
    }
    
    [self.tableView reloadData];
}

- (MBNiche *)uniqueNicheWithID:(NSNumber *)nicheID {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MBNiche"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nicheID = %@", nicheID];
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    MBNiche *niche = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error].firstObject;
    if (!niche) {
        niche = [NSEntityDescription insertNewObjectForEntityForName:@"MBNiche"
                                              inManagedObjectContext:self.managedObjectContext];
        niche.nicheID = [nicheID intValue];
    }
    
    return niche;
}

- (MBSummary *)uniqueSummary {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MBSummary"];
    
    NSError *error = nil;
    MBSummary *summary = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error].firstObject;
    if (!summary) {
        summary = [NSEntityDescription insertNewObjectForEntityForName:@"MBSummary"
                                                inManagedObjectContext:self.managedObjectContext];
    }
    
    return summary;
}

- (void)deleteAllNicheObjects {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MBNiche"];
    
    NSError *error = nil;
    NSArray *niches = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (MBNiche *niche in niches) {
        [self.managedObjectContext deleteObject:niche];
    }
    
    [self.coreDataStack saveContext];
}

#pragma mark - Actions

- (IBAction)refreshControlValueChanged:(UIRefreshControl *)sender {
    [self downloadAndSaveNiches];
}

#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger nichesCount = self.currentNiches.count;
    if (nichesCount == 0) {
        return 2;
    } else {
        return nichesCount + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSString *cellReuseIdentifier = nil;
    if (row == 0) {
        cellReuseIdentifier = NSStringFromClass(MBSummaryStatisticsTableViewCell.class);
        MBSummaryStatisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier
                                               forIndexPath:indexPath];
        [cell fillWithReadCount:self.currentSummary.readCount
                 readingSeconds:self.currentSummary.secondsCount
                  wishlistCount:self.currentSummary.wishlistCount];
        
        return cell;
    } else {
        NSInteger nichesCount = self.currentNiches.count;
        if (nichesCount == 0) {
            cellReuseIdentifier = NSStringFromClass(MBEmptyNichesTableViewCell.class);
            MBEmptyNichesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier
                                                                               forIndexPath:indexPath];
            return cell;
        } else {
            cellReuseIdentifier = NSStringFromClass(MBNicheTableViewCell.class);
            MBNicheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier
                                                                         forIndexPath:indexPath];
            MBNiche *niche = self.currentNiches[row - 1];
            [cell fillWithNicheID:niche.nicheID
                        nicheName:niche.name
                    wishlistCount:niche.wishlistCount
                     readingCount:niche.readingCount
                        readCount:niche.readCount
               allNicheBooksCount:niche.allBooksCount
                allUserBooksCount:self.currentSummary.allUserBooksCount];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        return [MBSummaryStatisticsTableViewCell height];
    } else {
        if (self.currentNiches.count == 0) {
            return [MBEmptyNichesTableViewCell height];
        } else {
            return [MBNicheTableViewCell height];
        }
    }
}

@end
