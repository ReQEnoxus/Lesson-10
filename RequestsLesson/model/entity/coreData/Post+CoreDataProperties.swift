//
//  Post+CoreDataProperties.swift
//  RequestsLesson
//
//  Created by Enoxus on 20/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: Int64
    @NSManaged public var reposted: Bool
    @NSManaged public var text: String?
    @NSManaged public var likes: Int16
    @NSManaged public var canLike: Bool
    @NSManaged public var comments: Int16
    @NSManaged public var reposts: Int16
    @NSManaged public var date: Date?
    @NSManaged public var repostedText: String?
    @NSManaged public var repostedImageLink: String?
    @NSManaged public var repostedImage: Data?
    @NSManaged public var originalDate: Date?
    @NSManaged public var imageLink: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var owner: String?
    @NSManaged public var ownerImageLink: String?
    @NSManaged public var ownerImage: Data?
}
