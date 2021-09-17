//
//  XMarkButton.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 17/09/2021.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.presentationMode) var presentatinMode
    
    var body: some View {
        Button(action: {
            presentatinMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}
