//
//  MyLocation.swift
//  Weather
//
//  Created by 田口怜央 on 2025/11/09.
//

import CoreLocation

struct MyLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
