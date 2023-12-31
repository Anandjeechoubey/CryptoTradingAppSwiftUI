//
//  XMarkButton.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-27.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
                Image(systemName: "xmark")
                .font(.headline)
            })
    }
}

#Preview {
    XMarkButton()
}
