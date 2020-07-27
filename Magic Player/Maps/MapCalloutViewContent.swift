//
//  MapAnnotation.swift
//  MapTest
//
//  Created by Andrew Finke on 7/23/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import SwiftUI

struct MapCalloutContentView: View {
    
    let items: [AudioFeedItem]
    let onClick: (AudioFeedItem) -> Void
    
    var body: some View {
        VStack {
            ForEach(items) { item in
                VStack(spacing: 0) {
                    HStack {
                        Text(item.name)
                            .font(Font.system(size: 12, weight: .medium, design: .default))
                        Spacer()
                        ZStack {
                            Circle()
                                .foregroundColor(Color(red: 71 / 255, green: 148 / 255, blue: 210 / 255))
                            Image("Play")
                                .resizable()
                        }
                        .frame(width: 20, height: 20)
                    }.onTapGesture {
                        self.onClick(item)
                    }
                }.frame(height: 32)
                
            }
        }
    }
}
