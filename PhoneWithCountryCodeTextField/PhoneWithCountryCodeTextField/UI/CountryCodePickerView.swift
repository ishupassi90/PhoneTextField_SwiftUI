//
//  CountryCodePickerView.swift
//  PhoneWithCountryCodeTextField
//
//  Created by Ishu Passi on 11/09/24.
//

import SwiftUI

// Delegate protocol replacement with a closure
public struct CountryCodePickerView: View {
    // Bindings and state variables
    @State private var searchText: String = ""
    @State private var filteredCountries: [Country] = []
    @State private var isFiltering: Bool = false

    public let utility: PhoneNumberUtility
    public let options: CountryCodePickerOptions
    public let commonCountryCodes: [String]
    public var onCountrySelected: (Country) -> Void

    // Lazy initialization of country data
    private var allCountries: [Country] {
        utility.allCountries()
            .compactMap { Country(for: $0, with: utility) }
            .sorted(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending })
    }

    private var popularCountries: [Country] {
        commonCountryCodes.compactMap { Country(for: $0, with: utility) }
    }

    private var groupedCountries: [[Country]] {
        let countries = (isFiltering ? filteredCountries : allCountries)
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

        // Add common and current countries
        let currentCountry = Country(for: PhoneNumberUtility.defaultRegionCode(), with: utility)
        var result: [[Country]] = []
        if let currentCountry = currentCountry {
            result.append([currentCountry])
        }
        if !popularCountries.isEmpty {
            result.append(popularCountries)
        }
        return result + countries
    }

    // Body of the SwiftUI view
    public var body: some View {
        NavigationView {
            List {
                ForEach(groupedCountries, id: \.self) { section in
                    Section(header: Text(sectionHeader(for: section))) {
                        ForEach(section, id: \.self) { country in
                            Button(action: {
                                onCountrySelected(country)
                            }) {
                                CountryRowView(country: country, options: options)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Choose your country")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: searchText) { newValue in
                applySearchFilter(with: newValue)
            }
        }
    }

    // Helper for section header title
    private func sectionHeader(for section: [Country]) -> String {
        if section == popularCountries {
            return "Popular Countries"
        } else if let currentCountry = Country(for: PhoneNumberUtility.defaultRegionCode(), with: utility),
                  section.contains(currentCountry) {
            return "Current Country"
        } else {
            return section.first?.name.prefix(1).uppercased() ?? ""
        }
    }

    // Search filter logic
    private func applySearchFilter(with searchText: String) {
        filteredCountries.removeAll()
        if searchText.isEmpty {
            isFiltering = false
        } else {
            isFiltering = true
            filteredCountries = allCountries.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.lowercased().contains(searchText.lowercased()) ||
                $0.prefix.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

// Row view for displaying individual countries
struct CountryRowView: View {
    var country: CountryCodePickerView.Country
    var options: CountryCodePickerOptions

    var body: some View {
        HStack {
            Text("\(country.flag) \(country.prefix)")
                .foregroundColor(options.textLabelColor.map(Color.init) ?? .primary)
            Spacer()
            Text(country.name)
                .foregroundColor(options.detailTextLabelColor.map(Color.init) ?? .secondary)
        }
        .padding()
        .background(options.cellBackgroundColor.map(Color.init) ?? .clear)
    }
}

public extension CountryCodePickerView {
    struct Country: Hashable {
        public var code: String
        public var flag: String
        public var name: String
        public var prefix: String

        public init?(for countryCode: String, with utility: PhoneNumberUtility) {
            let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
            guard let name = (Locale.current as NSLocale).localizedString(forCountryCode: countryCode),
                  let prefix = utility.countryCode(for: countryCode)?.description else { return nil }

            self.code = countryCode
            self.name = name
            self.prefix = "+" + prefix
            self.flag = ""
            countryCode.uppercased().unicodeScalars.forEach {
                if let scalar = UnicodeScalar(flagBase + $0.value) {
                    flag.append(String(describing: scalar))
                }
            }
        }
    }
}
