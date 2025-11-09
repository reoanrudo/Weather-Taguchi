//
//  WeatherViewModel.swift
//  Weather
//
//  Created by 田口怜央 on 2025/11/09.
//

import Foundation
import SwiftUI
import Alamofire
import Combine

// --- APIレスポンスを保持するクラス ---
class WeatherViewModel: ObservableObject {
    
    // --- リクエスト用URLの共通部分とAPIキー ---
    let baseUrl = APIProperties().baseUrl
    let apiKey = APIProperties().myAPIKey
    
    // --- レスポンスの値を保持する変数 ---
    @Published var forecast: Forecast?
    @Published var location: UserLocation?
    
    // --- 3日間予報リクエスト、引数は latが緯度、lonが経度 ---
    func request3DaysForecast(lat: Double, lon: Double) {
        
        // --- リクエストするためのURLを生成 ---
        let url = URL(string: baseUrl + "/forecast.json")!
        
        // --- リクエストに含めるパラメータを用意 ---
        let parameters: Parameters = [
            "key": apiKey,        // APIキー
            "q": "\(lat),\(lon)", // 緯度、経度
            "days": "3",          // 予報を取得する日数、今回は3日分
            "lang": "ja"          // Conditionのtextの言語、日本語を指定
        ]
        
        // --- 実際のリクエスト→レスポンス部分 ---
        AF.request(url, method: .get, parameters: parameters)
            .responseJSON { jsonResponse in
                // JSONレスポンスをデバッグ出力
                if let json = jsonResponse.value {
                    print("JSON Response:", json)
                }
            }
            .responseDecodable(of: WeatherInfo.self) { response in
                switch response.result {
                    
                    // --- 通信成功時 ---
                case .success(let data):
                    
                    // レスポンスの値を保持する変数に渡す
                    self.forecast = data.forecast
                    self.location = data.location
                    
                    // --- ロケーション確認用 ---
                    print("LOCATION:", data.location.name)
                    
                    // --- 月の満ち欠け情報確認用 ---
                    if let firstDay = data.forecast.forecastsDay.first {
                        print("Astro available:", firstDay.astro != nil)
                        if let astro = firstDay.astro {
                            print("Moon Phase:", astro.moonPhase)
                        }
                    }
                    
                    // --- 通信失敗時 ---
                case .failure(let err):
                    
                    // --- エラーをコンソールに出力 ---
                    print("FAILED:", err)
                }
            }
    }
}
