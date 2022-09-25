//
//  Date+.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 25/09/2022.
//

import Foundation

extension Date{
    func longDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd mmm yyyy"
        return dateFormatter.string(from: self)
    }
}
