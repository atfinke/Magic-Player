//
//  MagicAnnotationView.swift
//  Magic Player
//
//  Created by Andrew Finke on 7/26/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import MapKit
import SwiftUI

class MagicAnnotationView: MKAnnotationView {
    
    lazy var hostingView = NSHostingView(rootView: MapLocationAnnotationContentView())
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = NSRect(x: 0,
                       y: 0,
                       width: Design.annotationViewRadius * 2,
                       height: Design.annotationViewRadius * 2)
        addSubview(hostingView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layout() {
        super.layout()
        hostingView.frame = bounds
    }
}
