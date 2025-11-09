//
//  PointWeatherView.swift
//  Weather
//
//  Created by 田口怜央 on 2025/11/09.
//

import SwiftUI
import CoreLocation // CLLocationManagerを使うため

struct PointWeatherView: View {
    @Environment(\.dismiss) var dismiss // 1つ前の画面に戻るボタンを使うため
    @StateObject var weatherVM = WeatherViewModel() // マーカーの位置の天気取得用
    @ObservedObject var locationManager: LocationManager // 前の画面のLocationManagerを受け取る
    @State var myLocation: MyLocation // マーカー(タップした位置)の情報のオブジェクトを受け取る変数
    
    var body: some View {
        VStack {
            // 地名(住所)を表示
            Text("\(myLocation.name) の天気")
                .font(.title3)
            
            // 日毎の天気予報
            DailyWeatherView(
                weatherVM: weatherVM,
                locationManager: locationManager,
                weatherLocation: myLocation
            )
            .padding()
            
            // 前の画面に戻るボタン
            Button("閉じる") {
                dismiss()
            }
        }
        .padding()
        
        // 画面が表示されたときの処理
        .onAppear {
            // マーカーの位置の天気予報をAPIにリクエスト
            weatherVM.request3DaysForecast(
                lat: myLocation.coordinate.latitude,
                lon: myLocation.coordinate.longitude
            )
        }
    }
}
