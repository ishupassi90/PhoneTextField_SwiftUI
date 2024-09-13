//
//  FlagButton.swift
//  PhoneWithCountryCodeTextField
//
//  Created by Ishu Passi on 12/09/24.
//

import SwiftUI
import UIKit

struct FlagButton: UIViewRepresentable {
    @Binding var selectedRegion: String
    let utility: PhoneNumberUtility
    @Binding var selectedFlag: Bool
    
    class Coordinator: NSObject {
        var parent: FlagButton
        
        init(parent: FlagButton) {
            self.parent = parent
            super.init()
        }
        
        @objc func didPressFlagButton() {
            parent.didPressFlagButton()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(Country(for: self.selectedRegion, with: utility)?.flag, for: .normal)
        button.addTarget(context.coordinator, action: #selector(Coordinator.didPressFlagButton), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        uiView.setTitle(Country(for: self.selectedRegion, with: utility)?.flag, for: .normal)
    }
    
    func didPressFlagButton() {
        self.selectedFlag = true
    }
}
