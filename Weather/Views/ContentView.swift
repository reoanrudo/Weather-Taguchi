//
//  ContentView.swift
//  Weather
//
//  Created by 田口怜央 on 2025/11/09.
//

import SwiftUI
import MapKit // CLLocationManager(位置情報の管理)を使うため
struct ContentView: View {
    // --- APIへリクエスト、レスポンスの値を保持するオブジェクト ---
    @StateObject private var weatherVM = WeatherViewModel()
    @StateObject var locationManager = LocationManager() // 位置情報管理のオブジェクト
    
    // --- 八幡平市大更の緯度・経度 ---
    var lat: Double = 39.91167
    var lon: Double = 141.093459
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 20) {
                    DailyWeatherView(weatherVM: weatherVM)
                    HourlyWeatherView(weatherVM: weatherVM)
                }
                .padding()
                
            }
            .navigationTitle("現在地: \(locationManager.address)")
            .navigationBarTitleDisplayMode(.inline) // タイトルの書式
        }
        .padding()
        .onAppear {
            getWeatherForecast()
        }
        // --- スクロールビューを下に引っ張って実行 ---
        .refreshable {
            getWeatherForecast()
        }
    }
    
    // --- 現在地の天気予報取得、順番に処理したいのでDispatchQueue.main.async使用 ---
    func getWeatherForecast() {
        DispatchQueue.main.async {
            if let location = locationManager.location {
                let latitude = location.coordinate.latitude     // 緯度
                let longitude = location.coordinate.longitude   // 軽度
                weatherVM.request3DaysForecast(lat: latitude, lon: longitude) // 天気リクエスト
                print("LAT:", latitude, "LON:", longitude)
            } else {
                print("getting weather is failed")
            }
        }
    }
}

#Preview {
    ContentView()
}
