//
//  CountryData.swift
//  PhoneWithCountryCodeTextField
//
//  Created by Ishu Passi on 11/09/24.
//

import Foundation

class CountryData {
    
    let utility = PhoneNumberUtility()
    let commonCountryCodes: [String] = []
    var hasCurrent = true
    var hasCommon = true
    
    lazy var allCountries = utility
        .allCountries()
        .compactMap({ Country(for: $0, with: utility) })
        .sorted(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending })
    
    lazy var countries: [[Country]] = {
        let countries = allCountries
            .reduce([[Country]]()) { collection, country in
                var collection = collection
                guard var lastGroup = collection.last else { return [[country]] }
                let lhs = lastGroup.first?.name.folding(options: .diacriticInsensitive, locale: nil)
                let rhs = country.name.folding(options: .diacriticInsensitive, locale: nil)
                if lhs?.first == rhs.first {
                    lastGroup.append(country)
                    collection[collection.count - 1] = lastGroup
                } else {
                    collection.append([country])
                }
                return collection
            }

        let popular = commonCountryCodes.compactMap({ Country(for: $0, with: utility) })

        var result: [[Country]] = []
        // Note we should maybe use the user's current carrier's country code?
        if hasCurrent, let current = Country(for: PhoneNumberUtility.defaultRegionCode(), with: utility) {
            result.append([current])
        }
        hasCommon = hasCommon && !(popular.isEmpty)
        if hasCommon {
            result.append(popular)
        }
        return result + countries
    }()
}
