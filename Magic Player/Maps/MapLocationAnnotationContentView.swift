//
//  MapLocationAnnotationContentView.swift
//  Magic Player
//
//  Created by Andrew Finke on 7/26/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import SwiftUI

struct MapLocationAnnotationContentView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color.white)
                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 1)
            
            ZStack {
                Circle()
                    .foregroundColor(Color(red: 71 / 255, green: 148 / 255, blue: 210 / 255))
                Image("Note")
                    .resizable()
            }.padding(2)
        }.padding(2)
    }
}
