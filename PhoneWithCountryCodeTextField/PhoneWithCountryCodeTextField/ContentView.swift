//
//  ContentView.swift
//  PhoneWithCountryCodeTextField
//
//  Created by Ishu Passi on 10/09/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedCountry = PartialFormatter().currentRegion // Default country code
    @State private var phoneNumber = ""
    @State private var submitAttempted = false // Track if the sign-up was attempted
    @State private var selectFlag = false // for flag tapped

    var countryData = CountryData()
    let myUtilities = PhoneNumberUtility()
    
    var isValidNumber: Bool {
        do {
            let phoneNumber = try myUtilities.parse(phoneNumber, withRegion: selectedCountry, ignoreType: false)
            _ = phoneNumber.countryCode.description + "-" + phoneNumber.nationalNumber.description
            if phoneNumber.type == .mobile {
                return true
            }else{
                return false
            }
        }
        catch {
            return false
        }
    }
    
    var body: some View {
        
        VStack {
            
            Capsule(style: .continuous)
                .frame(height: 50)
                .foregroundColor(.gray.opacity(0.2))
                .overlay {
                    HStack(spacing: 4) {
                        FlagButton(selectedRegion: $selectedCountry, utility: myUtilities, selectedFlag: $selectFlag)
                            .frame(width: 30, height: 20)
                        
                        Text(Country(for: self.selectedCountry, with: myUtilities)?.prefix ?? "--")
                            .font(.caption)
                        
                        PhoneNumberTextFieldView(text: $phoneNumber, selectedRegion: $selectedCountry, utility: myUtilities)
                            .padding()
                            .keyboardType(.phonePad)
                            .onChange(of: phoneNumber) { _ in
                                print(phoneNumber)
                                print(isValidNumber)
                            }
                    }
                    .padding()
                }
            
            if self.selectFlag {
                CountryCodePickerView(utility: myUtilities, options: CountryCodePickerOptions(backgroundColor: .white, separatorColor: .black, textLabelColor: .black, cellBackgroundColor: .white, cellBackgroundColorSelection: .clear), commonCountryCodes: [""]) { country in
                    self.selectedCountry = country.code
                    self.selectFlag = false
                }
            }
            
        }
        .padding()
    }
}
