//
//  SortingView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct SortingView: View{
    @Binding var selectedSortingOption: Int
    let sortingOptions = [
        "Market Cap - High to Low",
        "Market Cap - Low to High",
        "Volume - High to Low",
        "Current Price - High to Low",
        "Current Price - Low to High",
        "A - Z",
        "Z - A"
    ]
    
    var body: some View  {
        Button {
            selectedSortingOption = (selectedSortingOption + 1) % sortingOptions.count
        } label: {
            HStack (spacing: 12){
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text(sortingOptions[selectedSortingOption])
                    .font(.subheadline)
            }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    SortingView(selectedSortingOption: .constant(0))
}
