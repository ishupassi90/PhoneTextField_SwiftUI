//
//  PhoneNumberTextFieldView.swift
//  PhoneWithCountryCodeTextField
//
//  Created by Ishu Passi on 11/09/24.
//

import SwiftUI
import UIKit

struct PhoneNumberTextFieldView: UIViewRepresentable {
    @Binding var text: String
    @Binding var selectedRegion: String
    let utility: PhoneNumberUtility
    var withPrefix: Bool = false
    var withExamplePlaceholder: Bool = true
    var isPartialFormatterEnabled: Bool = true
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PhoneNumberTextFieldView
        var partialFormatter: PartialFormatter

        init(parent: PhoneNumberTextFieldView) {
            self.parent = parent
            self.partialFormatter = PartialFormatter(
                utility: parent.utility,
                defaultRegion: PhoneNumberUtility.defaultRegionCode(),
                withPrefix: parent.withPrefix,
                ignoreIntlNumbers: true
            )
            super.init()
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            if let text = textField.text {
                if parent.isPartialFormatterEnabled {
                    textField.text = partialFormatter.formatPartial(text)
                }
                parent.text = textField.text ?? ""
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = withPrefix ? .phonePad : .numberPad
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)

        if withExamplePlaceholder {
            self.setPlaceholder(withTextfield: textField)
        }

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        self.setPlaceholder(withTextfield: uiView)
    }
    
    func setPlaceholder(withTextfield: UITextField) {
//        let example = utility.getFormattedExampleNumber(forCountry: self.selectedRegion, withFormat: withPrefix ? .international : .national, withPrefix: withPrefix) ?? "12345678"
        let example = utility.getFormattedExampleNumber(forCountry: self.selectedRegion, withFormat: .international, withPrefix: withPrefix) ?? "12345678"
        withTextfield.placeholder = example
    }
}
