//
//  DateHelper.swift
//  RequestsLesson
//
//  Created by Enoxus on 26/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

class DateHelper {
    
    private init() {
        
    }
    
    /// shared instance
    public static let shared = DateHelper()
    
    /// relative date formatter for close dates
    private lazy var relativeDateFormatter: RelativeDateTimeFormatter = {
        
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    /// date formatter for more distant dates
    private lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    /// formats the date in VK style
    /// - Parameter date: date to format
    func formatDate(_ date: Date) -> String {
        
        let currentDate = Date()
        
        switch Date.currentDateDifferenceTo(date: date) {
            
        case .hour:
            return relativeDateFormatter.localizedString(for: date, relativeTo: currentDate)
            
        case .today:
            
            dateFormatter.dateFormat = "Сегодня в HH:ss"
            
            return dateFormatter.string(from: date)
            
        case .yesterday:
            
            dateFormatter.dateFormat = "Вчера в HH:ss"
            
            return dateFormatter.string(from: date)
            
        case .earlier:
            
            dateFormatter.dateFormat = "d MMMM yyyy"
            
            return dateFormatter.string(from: date)
        }
    }
}
