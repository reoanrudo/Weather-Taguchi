//
//  MyLocationView.swift
//  Weather
//
//  Created by 田口怜央 on 2025/11/09.
//

import SwiftUI
import MapKit

struct MyLocationView: View {
    
    // --- マップの表示の位置 → ユーザーの位置を初期表示に設定 ---
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    // --- タップされた位置の座標、あとで削除するかも ---
    @State private var tappedPoint: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var body: some View {
        Map(position: $position)  {// Map の表示位置を $position に指定
            UserAnnotation() // ユーザーの位置の青ピンを表示
        }
        .mapStyle(.standard) // 地図のスタイル
        .mapControls {
            MapUserLocationButton() // ユーザー位置に戻るボタン
            MapCompass()            // コンパス
            MapScaleView()          // 縮尺表示
        }
    }
}

#Preview {
    MyLocationView()
}
