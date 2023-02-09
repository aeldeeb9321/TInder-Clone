//
//  SettingsViewModel.swift
//  Tinder Clone
//
//  Created by Ali Eldeeb on 2/9/23.
//

import Foundation

enum SettingsSections: Int, CustomStringConvertible, CaseIterable {
    case Name
    case Profession
    case Age
    case Bio
    case AgeRange
    
    var description: String {
        switch self {
        case .Name:
            return "Name"
        case .Profession:
            return "Profession"
        case .Age:
            return "Age"
        case .Bio:
            return "Bio"
        case .AgeRange:
            return "Seeking Age Range"
        }
    }
}

struct SettingsViewModel {
    //where we configure all our tableView Data
    
}
