//
//  User+CoreDataProperties.swift
//  RequestsLesson
//
//  Created by Enoxus on 20/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int64
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var online: Bool
    @NSManaged public var avi: Data?
    @NSManaged public var aviLink: String?
    @NSManaged public var token: String?
}
