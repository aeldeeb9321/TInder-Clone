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
    private let user: User
    let section: SettingsSections
    
    let placeHolderText: String
    var value: String?
    
    var shouldHideInputField: Bool{
        return section == .AgeRange
    }
    
    var shouldHideSlider: Bool {
        return section != .AgeRange
    }
    
    var minAgeSliderValue: Float {
        return Float(user.minSeekingAge)
    }
    
    var maxAgeSliderValue: Float {
        return Float(user.maxSeekingAge)
    }
    
    init(user: User, section: SettingsSections) {
        self.user = user
        self.section = section
        placeHolderText = "Enter \(section.description.lowercased()) here.."
        
        switch section {
        case .Name:
            value = user.name
        case .Profession:
            value = user.profession
        case .Age:
            value = "\(user.age)"
        case .Bio:
            value = user.bio
        case .AgeRange:
            value = "\(user.minSeekingAge) - \(user.maxSeekingAge)"
        }
    }
    
    func minAgeLabelText(forValue value: Float) -> String {
        return "Min: \(Int(value))"
    }
    
    func maxAgeLabelText(forValue value: Float) -> String {
        return "Max: \(Int(value))"
    }
    
}
