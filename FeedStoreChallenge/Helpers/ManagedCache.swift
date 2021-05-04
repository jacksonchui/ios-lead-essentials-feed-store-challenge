//
//  ManagedCache.swift
//  FeedStoreChallenge
//
//  Created by Jackson Chui on 5/4/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

@objc(ManagedCache)
internal class ManagedCache: NSManagedObject {
	@NSManaged var timestamp: Date
	@NSManaged var feed: NSOrderedSet
}


