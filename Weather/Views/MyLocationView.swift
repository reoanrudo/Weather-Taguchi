//
//  MyLocationView.swift
//  Weather
//
//  Created by 田口怜央 on 2025/11/09.
//

import SwiftUI
import MapKit

struct MyLocationView: View {
    
    // ロケーションマネージャーは前の画面のものを受け取って使い回す
    @ObservedObject var locationManager: LocationManager
    
    // --- マップの表示の位置 → ユーザーの位置を初期表示に設定 ---
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    // --- タップされた位置の座標、あとで削除するかも ---
    @State private var tappedPoint: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    // 作成したマーカーを入れておく変数
    @State var myLocations: [MyLocation] = []
    
    // マーカー(地図上でタップした)位置の天気を表示する画面への遷移を制御
    @State private var isPresented = false
    
    var body: some View {
        
        MapReader { mapProxy in
            Map(position: $position)  {// Map の表示位置を $position に指定
                UserAnnotation() // ユーザーの位置の青ピンを表示
                
                // マーカー(アノテーション)を配置
                ForEach(myLocations) { myLocation in
                    Annotation(myLocation.name, coordinate: myLocation.coordinate) {
                        
                        Image(systemName: "cloud.sun.circle")
                            .resizable()
                            .foregroundStyle(.orange)
                            .frame(width: 50, height: 50)
                            .background(.white)
                            .clipShape(.circle)
                        
                        // マーカーがタップされたときの処理
                            .onTapGesture {
                                isPresented = true
                            }
                    }
                }
            }
            .mapStyle(.standard) // 地図のスタイル
            .mapControls {
                MapUserLocationButton() // ユーザー位置に戻るボタン
                MapCompass()            // コンパス
                MapScaleView()          // 縮尺表示
            }
            // 地図がタップされたときの処理、locationは画面上のタップされた点の座標
            .onTapGesture { location in
                
                // タップされた画面上の点の座標を地図上の座標に変換できたときの処理
                if let coordinate = mapProxy.convert(location, from: .local) {
                    tappedPoint = coordinate
                    
                    // myLocationsにタップした地点の情報を追加(地図上にピンを追加)
                    generateNewLocation(coordinate: coordinate)
                }
            }
            // マーカーの位置の天気予報を画面の下から出てくるシートとして表示
            .sheet(isPresented: $isPresented) {
                // マーカー(MyLocationオブジェクト)があるとき
                if let myLocation = myLocations.last {
                    // PointWeatherViewをシートに表示
                    PointWeatherView(locationManager: locationManager,myLocation: myLocation)
                        .presentationDetents([.medium]) //シートの高さを画面の半分ほどに設定
                }
            }
        }
    }
    // MyLocationオブジェクトを作って配列に追加する関数
    func generateNewLocation(coordinate: CLLocationCoordinate2D) {
        
        // MapReaderで変換した座標からCLLocationをつくる
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // 座標を住所(地名)に変換
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (places, error) in
            if let error {
                print(error)
                return
            }
            
            if let place = places?.last {
                let address = [
                    // place.name,
                    // place.country
                    // place.postalCode,
                    place.administrativeArea,
                    place.locality,
                    place.subLocality/*,*/
                    // place.thoroughfare,
                    // place.subThoroughfare,
                ].compactMap { $0 }.joined(separator: " ")
                
                // 地名と座標からMyLocationオブジェクトを作って配列に追加
                let newLocation = MyLocation(name: address, coordinate: coordinate)
                myLocations = [newLocation]
            }
        }
    }
}

#Preview {
    MyLocationView(locationManager: ContentView().locationManager)
}
