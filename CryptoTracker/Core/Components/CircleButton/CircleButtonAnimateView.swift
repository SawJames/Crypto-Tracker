//
//  CircleButtonAnimateView.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 15/09/2021.
//

import SwiftUI

struct CircleButtonAnimateView: View {
    @Binding var animate : Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none)
    }
}

struct CircleButtonAnimateView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimateView(animate: .constant(false))
            .foregroundColor(.red)
            .frame(width: 100, height: 100)
    }
}
