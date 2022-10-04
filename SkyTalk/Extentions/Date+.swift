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
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func MSGTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func stringDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }

}
