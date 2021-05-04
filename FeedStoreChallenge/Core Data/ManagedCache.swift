//
//  ManagedCache.swift
//  FeedStoreChallenge
//
//  Created by Jackson Chui on 5/4/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

@objc(ManagedCache)
final internal class ManagedCache: NSManagedObject {
	@NSManaged var timestamp: Date
	@NSManaged var feed: NSOrderedSet

	static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
		let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
		request.returnsObjectsAsFaults = false
		return try context.fetch(request).first
	}

	static func delete(in context: NSManagedObjectContext) throws {
		try ManagedCache.find(in: context).map(context.delete)
	}

	static func replaceCurrentFeedIfPresent(with feed: [LocalFeedImage], at timestamp: Date, in context: NSManagedObjectContext) throws {
		try ManagedCache.delete(in: context)
		let feedCache = ManagedCache(context: context)
		feedCache.timestamp = timestamp
		feedCache.feed = ManagedCache.map(feed, in: context)
	}

	static func map(_ local: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
		return NSOrderedSet(array: local.map { local in
			let managed = ManagedFeedImage(context: context)
			managed.id = local.id
			managed.imageDescription = local.description
			managed.location = local.location
			managed.url = local.url
			return managed
		})
	}

	var local: [LocalFeedImage] {
		feed.compactMap { ($0 as? ManagedFeedImage)?.local }
	}
}
