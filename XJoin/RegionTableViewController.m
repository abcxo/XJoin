//
//  RegionTableViewController.m
//  XJoin
//
//  Created by shadow on 14-8-25.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "RegionTableViewController.h"
#import "XJoin.h"
@interface RegionTableViewController () {
	NSMutableDictionary *_conCode;
}
@end

@implementation RegionTableViewController

- (void)prepareForView {
	[super prepareForView];
	self.dataSource = [[NSMutableArray alloc] init];
	NSString *regionPath = [[NSBundle mainBundle] pathForResource:@"region_new" ofType:@"txt"];
	NSArray *arrayTemp = [[NSString stringWithContentsOfFile:regionPath encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
    NSString *lang=[Utils preferredLanguage];
    if (![lang containStrings:@"zh-Hans",@"zh-Hant",@"en", nil]) {
        lang=@"zh-Hant";
    }
	for (NSString *string in arrayTemp) {
        if ([string containString:lang]) {
            NSArray *array = [string componentsSeparatedByString:@"|"];
            NSString *country = [array objectAtIndex:1];
            if ([country rangeOfString:@"_"].location == NSNotFound) {
                [self.dataSource addObject:@{ @"region":[array lastObject], @"country":country }];
            }
        }
		
	}
	_conCode = [[NSMutableDictionary alloc] init];
	NSString *codePath = [[NSBundle mainBundle] pathForResource:@"country_code" ofType:@"txt"];
	NSArray *arrayTemp2 = [[NSString stringWithContentsOfFile:codePath encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
	for (NSString *string in arrayTemp2) {
		NSArray *array = [string componentsSeparatedByString:@" "];
		[_conCode setObject:[array lastObject] forKey:[array firstObject]];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *dict = [self.dataSource objectAtIndex:indexPath.row];

	if ([self.passedDelegate respondsToSelector:@selector(backPassViewController:pass:)]) {
		[self.passedDelegate backPassViewController:self pass:@{ @"region":dict[@"region"], @"code":Format(@"+%@", _conCode[dict[@"country"]]) }];
	}
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	    if (self.navigationController.presentingViewController) {
	        [self.navigationController dismissModalViewControllerAnimated:YES];
		}
	    else {
	        [self.navigationController popViewControllerAnimated:YES];
		}
	});
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	RegionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RegionTableViewCell className]];
	cell.nameLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"region"];

	return cell;
}

@end
