//
//  Dates+Ext.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 19.07.22.
//

import Foundation

extension Date {
   
    func convertDateToString() -> String {
        return formatted(.dateTime.month().year())
    }
}
