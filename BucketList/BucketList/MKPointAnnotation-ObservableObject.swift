//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by DeNNiO   G on 11.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown value"
        }
        set {
            subtitle = newValue
        }
    }
}
