//
//  PBDetailController.m
//  GitX
//
//  Created by Pieter de Bie on 16-06-08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PBDetailController.h"


@implementation PBDetailController

@synthesize selectedTab, webCommit, rawCommit, gitTree;

- awakeFromNib
{
	[fileBrowser setTarget:self];
	[fileBrowser setDoubleAction:@selector(openSelectedFile:)];
	self.selectedTab = [NSNumber numberWithInt:0];
	[commitController addObserver:self forKeyPath:@"selection" options:(NSKeyValueObservingOptionNew,NSKeyValueObservingOptionOld) context:@"commitChange"];

	return self;
}

- (void) updateKeys
{
	NSArray* selection = [commitController selectedObjects];
	if ([selection count] > 0)
		realCommit = [selection objectAtIndex:0];
	else
		realCommit = nil;
	
	self.webCommit = nil;
	self.rawCommit = nil;
	self.gitTree = nil;
	
	int num = [self.selectedTab intValue];

	if (num == 0) // Detailed view
		self.webCommit = realCommit;
	else if (num == 1)
		self.rawCommit = realCommit;
	else if (num == 2)
		self.gitTree = realCommit.tree;
}	


- (void) setSelectedTab: (NSNumber*) number
{
	selectedTab = number;
	[self updateKeys];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([(NSString *)context isEqualToString: @"commitChange"]) {
		[self updateKeys];
		return;
	}
	else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (IBAction) openSelectedFile: sender
{
	NSArray* selectedFiles = [treeController selectedObjects];
	if ([selectedFiles count] == 0)
		return;
	PBGitTree* tree = [selectedFiles objectAtIndex:0];
	NSString* name = [tree tmpFileNameForContents];
	[[NSWorkspace sharedWorkspace] openTempFile:name];
}

- (IBAction) setDetailedView: sender {
	self.selectedTab = [NSNumber numberWithInt:0];
}
- (IBAction) setRawView: sender {
	self.selectedTab = [NSNumber numberWithInt:1];
}
- (IBAction) setTreeView: sender {
	self.selectedTab = [NSNumber numberWithInt:2];
}


@end
