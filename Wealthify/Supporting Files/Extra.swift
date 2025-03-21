//
//  Extra.swift
//  Money
//
//  Created by Priyansh on 01/03/25.
//

import Foundation
import SwiftUI

struct colorModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body (content: Content) -> some View {
        content
            .foregroundStyle(colorScheme == .dark ? .white : .black)
    }
}
