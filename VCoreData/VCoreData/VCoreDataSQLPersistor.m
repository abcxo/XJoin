//
//  VCoreDataSQLPersistor.m
//  VCoreData
//
//  Created by shadow on 14-3-28.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "VCoreDataSQLPersistor.h"
#import <sqlite3.h>
#import "VCoreData.h"
#define ENABLE_TRANSACTION_THRESHOLD_MAX 3
@interface VCoreDataSQLPersistor () {
	sqlite3 *_database;
}
@end
@implementation VCoreDataSQLPersistor
- (id)init {
	self = [super init];
	if (self) {
		[self initDataBase];
	}
	return self;
}

- (BOOL)initDataBase {
	NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
	                                                              , NSUserDomainMask
	                                                              , YES);
	NSString *databaseFilePath = [[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"VCoreData.db"];
	int success = sqlite3_open([databaseFilePath UTF8String], &_database);
	return success == SQLITE_OK;
}

- (BOOL)createTable:(id)obj {
	NSMutableArray *paramArray = [[NSMutableArray alloc] init];
	int i = 0;
	for (NSProperty*mProperty in[obj allProperties]) {
		NSString *type = [NSObject dataVTypeToString:mProperty.type];
		NSString *name = mProperty.name;
		NSString *param = [NSString stringWithFormat:@"%@ %@ ", name, type];
		if (i == 0) {
			param = [param addString:@"PRIMARY KEY"];
		}
		[paramArray addObject:param];
		i++;
	}
	NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",[obj className], [paramArray componentsJoinedByString:@","]];

	int success = [self executeSQL:sql];
	return success == SQLITE_OK;
}


- (BOOL)isTableExist:(id)obj {
	sqlite3_stmt *statement;
	NSString *sql = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'", [obj className]];
	sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, nil);
	BOOL isExist = NO;
	if (sqlite3_step(statement) == SQLITE_ROW) {
		isExist = YES;
	}
	sqlite3_finalize(statement);
	return isExist;
}

- (int)executeSQL:(NSString *)sql {
	char *err = nil;
    int suc=sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &err);
    NSLog(@"sql exe err %s",err);
    return suc;
}


#pragma mark - VCoreDataPersistorProtocol

- (NSArray *)queryData:(VCoreDataQueryRequest *)request {
    Class resultClass=NSClassFromString(request.resultClass);
	NSArray *classArray = request.classes;
	NSMutableArray *tableArray = [[NSMutableArray alloc] init];
	for (NSString * className in classArray) {
		[tableArray addObject:className];
	}
	NSString *tableNames = [tableArray componentsJoinedByString:@","];

	NSArray *propertyArray = request.properties;
    NSMutableArray *columnArray = [[NSMutableArray alloc] init];
    for (NSProperty *mProperty in propertyArray) {
        [columnArray addObject:[mProperty.parentClass addFormat:@".%@",mProperty.name] ];
    }
	NSString *columnNames = [columnArray componentsJoinedByString:@","];

    NSString *filter=request.filter;
    NSString *query=nil;
    if ([filter containString:@"@all"]) {
        query=[filter deleteString:@"@all"];
    }else{
        query = [filter isMeaningful] ? [@" WHERE " addString:filter]:@"";
    }
	


	NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@ %@", columnNames, tableNames,query];
	sqlite3_stmt *statement = nil;
	int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
	    if (success != SQLITE_OK) {
        NSLog(@"sql err %s",sqlite3_errmsg(_database));
		return nil;
	}
	NSMutableArray *result = [[NSMutableArray alloc] init];
	while ((sqlite3_step(statement) == SQLITE_ROW)) {
		id resultObj = resultClass?[[resultClass alloc] init]:[[NSMutableDictionary alloc] init];
		int column = 0;
		for (NSProperty *mProperty in propertyArray) {
			NSDataVType type = mProperty.type;
			id value = [self bindOrGetValue:nil withStatement:statement withType:type withIndex:column++ isBind:NO];
			[resultObj setValue:value forKey:mProperty.name];
		}
		[result addObject:resultObj];
	}
	sqlite3_finalize(statement);
	return result;
}

- (BOOL)updateData:(VCoreDataUpdateRequest *)request {
    NSArray *objArray = request.objects;
	NSMutableArray *tableArray = [[NSMutableArray alloc] init];
	for (id obj in objArray) {
		[tableArray addObject:[obj className]];
	}
	NSString *tableNames = [tableArray componentsJoinedByString:@","];
    
	NSArray *propertyArray = request.properties;

    NSString *filter=request.filter;
	NSString *query = [filter isMeaningful] ? [@" WHERE " addString:filter]:@"";
    
    NSMutableArray *paramArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement = nil;
    for (NSProperty *mProperty in propertyArray) {
        NSString *name = mProperty.name;
        [paramArray addObject:[name addString:@"=?"]];
    }
    NSString *paramNames=[paramArray componentsJoinedByString:@","];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ %@", tableNames,  paramNames ,query] ;
    int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
        if (success != SQLITE_OK) {
        NSLog(@"sql err %s",sqlite3_errmsg(_database));
        return NO;
    }
    int i = 1;
    for (NSProperty *mProperty  in propertyArray) {
        NSDataVType type = mProperty.type;
        id value =mProperty.value;
        [self bindOrGetValue:value withStatement:statement withType:type withIndex:i++ isBind:YES];
    }
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    return success == SQLITE_OK;

}

- (BOOL)addData:(VCoreDataAddRequest *)request {
    NSArray *objs=request.objects;
	BOOL isSuc = YES;
    if (objs.count>ENABLE_TRANSACTION_THRESHOLD_MAX) {
        sqlite3_exec(_database,"BEGIN",0,0,0);
    }
	for (id obj in objs) {
		if (![self isTableExist:obj]) {
			[self createTable:obj];
		}
		NSArray *propertyArray = [obj allProperties];
		NSMutableArray *paramArray = [[NSMutableArray alloc] init];
		NSMutableArray *markArray = [[NSMutableArray alloc] init];
		sqlite3_stmt *statement = nil;
		for (NSProperty*mProperty in propertyArray) {
			NSString *name = mProperty.name;
			[paramArray addObject:name];
			[markArray addObject:@"?"];
		}
		NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ (%@) VALUES (%@)", [obj className], [paramArray componentsJoinedByString:@","], [markArray componentsJoinedByString:@","]];
		int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
		    if (success != SQLITE_OK) {
        NSLog(@"sql err %s",sqlite3_errmsg(_database));
            
			return NO;
		}
		int i = 1;
		for (NSProperty*mProperty in propertyArray) {
			NSDataVType type = mProperty.type;
			id value = mProperty.value;
			[self bindOrGetValue:value withStatement:statement withType:type withIndex:i++ isBind:YES];
		}
		success = sqlite3_step(statement);
		sqlite3_finalize(statement);
		isSuc = (success == SQLITE_OK) == YES ? isSuc : NO;
	}
    if (objs.count>ENABLE_TRANSACTION_THRESHOLD_MAX) {
        sqlite3_exec(_database,"BEGIN",0,0,0);
    }
	return isSuc;
}

- (BOOL)deleteData:(VCoreDataDelRequest *)request {
    NSArray *classArray = request.classes;
	NSMutableArray *tableArray = [[NSMutableArray alloc] init];
	for (NSString* className in classArray) {
		[tableArray addObject:className];
	}
	NSString *tableNames = [tableArray componentsJoinedByString:@","];
    NSString *filter=request.filter;
	NSString *query = [filter isMeaningful] ? [@" WHERE " addString:filter]:@"";
    sqlite3_stmt *statement = nil;
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@", tableNames ,query] ;
    int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
        if (success != SQLITE_OK) {
        NSLog(@"sql err %s",sqlite3_errmsg(_database));
        return NO;
    }
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    return success == SQLITE_OK;
	return YES;
}


-(id)executeData:(VCoreDataExecuteRequest *)request{
    NSString *sql=request.command;
    NSArray *paramArray=request.paramArray;
    if ([sql isMeaningful]) {
        sqlite3_stmt *statement = nil;
        int success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
            if (success != SQLITE_OK) {
        NSLog(@"sql err %s",sqlite3_errmsg(_database));
            return nil;
        }
        int i = 1;
		for (NSProperty*mProperty in paramArray) {
			NSDataVType type = mProperty.type;
			id value = mProperty.value;
			[self bindOrGetValue:value withStatement:statement withType:type withIndex:i++ isBind:YES];
		}
        
        NSMutableArray *result = [[NSMutableArray alloc] init];
        while ((sqlite3_step(statement) == SQLITE_ROW)) {
             NSMutableArray *resultObj = [[NSMutableArray alloc] init];
            int count=sqlite3_column_count(statement);
            for (int i=0; i<count;i++) {
                NSDataVType type = (NSDataVType)sqlite3_column_type(statement, i);
                id value = [self bindOrGetValue:nil withStatement:statement withType:type withIndex:i isBind:NO];
                [resultObj addObject:value];
            }
            [result addObject:resultObj];
        }
        sqlite3_finalize(statement);
        return result;

    }
    
    return nil;
}

- (id)bindOrGetValue:(id)value withStatement:(sqlite3_stmt *)statement withType:(NSDataVType)type withIndex:(int)index isBind:(BOOL)isBind {
    switch (type) {
        case NSDataVTypeInteger:
            if (isBind) {
                sqlite3_bind_int(statement, index, [value intValue]);
            }
            else {
                value = @(sqlite3_column_int(statement, index));
            }

            break;
        case NSDataVTypeReal:
            if (isBind) {
                sqlite3_bind_double(statement, index, [value doubleValue]);
            }
            else {
                value = @(sqlite3_column_double(statement, index));
            }

            break;
        case NSDataVTypeText:
            if (isBind) {
                sqlite3_bind_text(statement, index, [value UTF8String], -1, SQLITE_TRANSIENT);
            }
            else {
                value = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, index)];
            }

            break;
        case NSDataVTypeBlob:
            if (isBind) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
                sqlite3_bind_blob(statement, index, [data bytes], (int)data.length, SQLITE_TRANSIENT);
            }
            else {
                int i = index;
                NSUInteger blobLen = sqlite3_column_bytes(statement, i);
                NSMutableData *data = [NSMutableData dataWithBytes:sqlite3_column_blob(statement, index) length:blobLen];
                value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }

            break;
        case NSDataVTypeNull:
            
            break;
            
        default:
            break;
    }
	return value;
}

@end
