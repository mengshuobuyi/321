////
////  tewet.m
////  APP
////
////  Created by carret on 15/1/22.
////  Copyright (c) 2015年 carret. All rights reserved.
////
//
//#import "tewet.h"
//
//@implementation tewet
//- (NSString *) stringStrippedOfTags: (NSString *) string
//{
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *stripperPath;
//    stripperPath = [bundle pathForAuxiliaryExecutable: @"stripper.pl"];
//    
//    NSTask *task = [[NSTask alloc] init];
//    [task setLaunchPath: stripperPath];
//    
//    NSPipe *readPipe = [NSPipe pipe];
//    NSFileHandle *readHandle = [readPipe fileHandleForReading];
//    
//    NSPipe *writePipe = [NSPipe pipe];
//    NSFileHandle *writeHandle = [writePipe fileHandleForWriting];
//    
//    [task setStandardInput: writePipe];
//    [task setStandardOutput: readPipe];
//    
//    [task launch];
//    
//    [writeHandle writeData: [string dataUsingEncoding: NSASCIIStringEncoding]];
//    [writeHandle closeFile];
//    
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSData *readData;
//    
//    while ((readData = [readHandle availableData])
//           && [readData length]) {
//        [data appendData: readData];
//    }
//    
//    NSString *strippedString;
//    strippedString = [[NSString alloc]
//                      initWithData: data
//                      encoding: NSASCIIStringEncoding];
//    
////    [task release];
////    [data release];
////    [strippedString autorelease];
//@end
