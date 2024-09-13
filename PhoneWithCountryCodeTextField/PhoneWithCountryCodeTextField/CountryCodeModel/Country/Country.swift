//
//  Country.swift
//  PhoneWithCountryCodeTextField
//
//  Created by Ishu Passi on 11/09/24.
//

import Foundation

struct Country {
    public var code: String
    public var flag: String
    public var name: String
    public var prefix: String

    public init?(for countryCode: String, with utility: PhoneNumberUtility) {
        let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
        guard
            let name = (Locale.current as NSLocale).localizedString(forCountryCode: countryCode),
            let prefix = utility.countryCode(for: countryCode)?.description
        else {
            return nil
        }

        self.code = countryCode
        self.name = name
        self.prefix = "+" + prefix
        self.flag = ""
        countryCode.uppercased().unicodeScalars.forEach {
            if let scaler = UnicodeScalar(flagBase + $0.value) {
                flag.append(String(describing: scaler))
            }
        }
        if flag.count != 1 { // Failed to initialize a flag ... use an empty string
            return nil
        }
    }
}
