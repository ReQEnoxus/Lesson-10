//
//  Extensions.swift
//  DynamicTable
//
//  Created by Enoxus on 11/10/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    /// registers the given cell for the tableview
    /// - Parameter cell: cell to register
    func register(cell: UITableViewCell.Type) {
        self.register(UINib(nibName: cell.nibName, bundle: nil), forCellReuseIdentifier: cell.nibName)
    }
}

extension UITableViewCell {
    
    /// returns the nib name for the cell
    static var nibName: String {
        
        get {
            return String(describing: self)
        }
    }
}

extension Date {
    
    enum Difference {
        
        case hour
        case today
        case yesterday
        case earlier
    }
    
    /// decides the difference between current and given dates
    /// - Parameter date: date to compare with
    static func currentDateDifferenceTo(date: Date) -> Difference {
        
        let calendar = Calendar.current
        
        if calendar.compare(date, to: Date(), toGranularity: .hour) == .orderedSame {
            
            return .hour
        }
        else if calendar.isDateInToday(date) {
            
            return .today
        }
        else if calendar.isDateInYesterday(date) {
            
            return .yesterday
        }
        else {
            
            return .earlier
        }
    }
}

extension URL {
    
    /// extracts query parameters from GET request as a dictionary
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

extension Post {
    
    /// converts core data model to dto
    func toDto() -> PostDTO {
                
        return PostDTO(id: Int(self.id), reposted: self.reposted, text: self.text, likes: Int(self.likes), canLike: self.canLike, comments: Int(self.comments), reposts: Int(self.reposts), date: self.date ?? Date(timeIntervalSince1970: TimeInterval(exactly: 0)!), repostedText: self.repostedText, repostedImageLink: self.repostedImageLink, repostedImage: self.repostedImage, originalDate: self.originalDate, imageLink: self.imageLink, imageData: self.imageData, owner: self.owner, ownerImageLink: self.ownerImageLink, ownerImage: self.ownerImage)
    }
}

extension User {
    
    /// converts core data model to dto
    func toDto() -> UserDTO {
        
        return UserDTO(id: Int(self.id), firstName: self.firstName ?? "", lastName: self.lastName ?? "", online: self.online, avi: self.avi, aviLink: self.aviLink!, token: self.token)
    }
}
