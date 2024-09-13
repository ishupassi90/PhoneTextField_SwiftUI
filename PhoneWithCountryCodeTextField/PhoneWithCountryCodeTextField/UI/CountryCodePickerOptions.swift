//
//  CountryCodePickerOptions.swift
//  PhoneWithCountryCodeTextField
//
//  Created by Ishu Passi on 11/09/24.
//

import SwiftUI

/// CountryCodePickerOptions object for SwiftUI
/// - Parameter backgroundColor: Color used for background
/// - Parameter separatorColor: Color used for the separator line between cells
/// - Parameter textLabelColor: Color for the TextLabel (Country code)
/// - Parameter textLabelFont: Font for the TextLabel (Country code)
/// - Parameter detailTextLabelColor: Color for the DetailTextLabel (Country name)
/// - Parameter detailTextLabelFont: Font for the DetailTextLabel (Country name)
/// - Parameter tintColor: Default TintColor used on the view
/// - Parameter cellBackgroundColor: Color for the cell background
/// - Parameter cellBackgroundColorSelection: Color for the cell selected background
public struct CountryCodePickerOptions {
    public init() { }

    public init(backgroundColor: Color? = nil,
                separatorColor: Color? = nil,
                textLabelColor: Color? = nil,
                textLabelFont: Font? = nil,
                detailTextLabelColor: Color? = nil,
                detailTextLabelFont: Font? = nil,
                tintColor: Color? = nil,
                cellBackgroundColor: Color? = nil,
                cellBackgroundColorSelection: Color? = nil) {
        self.backgroundColor = backgroundColor
        self.separatorColor = separatorColor
        self.textLabelColor = textLabelColor
        self.textLabelFont = textLabelFont
        self.detailTextLabelColor = detailTextLabelColor
        self.detailTextLabelFont = detailTextLabelFont
        self.tintColor = tintColor
        self.cellBackgroundColor = cellBackgroundColor
        self.cellBackgroundColorSelection = cellBackgroundColorSelection
    }

    public var backgroundColor: Color?
    public var separatorColor: Color?
    public var textLabelColor: Color?
    public var textLabelFont: Font?
    public var detailTextLabelColor: Color?
    public var detailTextLabelFont: Font?
    public var tintColor: Color?
    public var cellBackgroundColor: Color?
    public var cellBackgroundColorSelection: Color?
}

