//
//  YumemiWeatherModel.swift
//  YumemiTraining
//
//  Created by 加藤研太郎 on 2022/05/17.
//

import Foundation
import YumemiWeather

class WeatherModelImpl: WeatherModel {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
    
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<ReturnedInfo, YumemiWeatherError>) -> Void) {
        let areaAndDate = AreaAndDate(area: area, date: date)
//        let areaAndDate = AreaAndDate(area: areaAndDate.area, date: areaAndDate.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        do{
            let enconder = JSONEncoder()
            enconder.dateEncodingStrategy = .formatted(dateFormatter)
            
            let data = try enconder.encode(areaAndDate)
            let encodedToJsonString:String = String(data: data, encoding: .utf8)!
            // 下記変数によりjson文字列のランダムな結果が吐き出されるようになるのでこれを変換していく
            
            self.callbackFetchWeather(encodedToJsonString) { result in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let returnedJsonString):
                        let jsonData = returnedJsonString.data(using: .utf8)
                        let decodedJsonDataToReturnedInfo = try! JSONDecoder().decode(ReturnedInfo.self, from: jsonData!)
                        completion(.success(decodedJsonDataToReturnedInfo))
                    case .failure(let yumemiWeatherError):
                        completion(.failure(yumemiWeatherError))
                        let message: String
                        switch yumemiWeatherError {
                        case .invalidParameterError:
                            message = "無効なパラメータが返されました"
                        case .unknownError:
                            message = "YumemiAPIでよく分からないエラーが発生しました"
                        }
//                        let alartController = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
//                        alartController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ ->Void in
//                            print("\(message)")
//                        }))
                    }
                }
                
            }
        }catch{
            var weatherError:WeatherError = .jsonEncodeError
            let weatherMessage:String
            switch weatherError {
            case .jsonEncodeError:
                weatherError = .jsonEncodeError
                weatherMessage = "jsonEncodeに失敗しました"
            case .jsonDecodeError:
                weatherError = .jsonDecodeError
                weatherMessage = "jsonDecodeに失敗しました"
            case .unknownError:
                weatherError = .unknownError
                weatherMessage = "FetchWeatherでよく分からないエラーが発生しました"
            }
//            let alert = UIAlertController(title: "FetchWeatherエラー", message: weatherMessage, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ボタン1", style: .default, handler: { _ -> Void in
//                print(weatherMessage)
//            }))
        }
    }
    func callbackFetchWeather(_ jsonString: String, completion: @escaping (Result<String, YumemiWeatherError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + TimeInterval(2.0)) {
            do {
                let response = try self.fetchWeather(jsonString)
                completion(Result.success(response))
            }
            catch let error where error is YumemiWeatherError {
                completion(Result.failure(error as! YumemiWeatherError))
            }
            catch {
                fatalError()
            }
        }
    }
    func fetchWeather(_ jsonString: String) throws -> String {
        guard let dataFromJsonString = jsonString.data(using: .utf8),
              let areaAndDate = try? WeatherModelImpl.decoder.decode(AreaAndDate.self, from: dataFromJsonString) else {
            throw YumemiWeatherError.invalidParameterError
        }
        
        let response = makeRandomResponse(date: areaAndDate.date)
        let responseData = try WeatherModelImpl.encoder.encode(response)
        
        if Int.random(in: 0...4) == 4 {
            throw YumemiWeatherError.unknownError
        }
        
        return String(data: responseData, encoding: .utf8)!
    }
    func makeRandomResponse(weather: Weather? = nil, maxTemp: Int? = nil, minTemp: Int? = nil, date: Date? = nil) -> ReturnedInfo {
        let weather = weather ?? Weather.allCases.randomElement()!
        let maxTemp = maxTemp ?? Int.random(in: 10...40)
        let minTemp = minTemp ?? Int.random(in: -40..<maxTemp)
        let date = date ?? Date()
        
        return ReturnedInfo(
            max_temp: maxTemp,
            date: "\(date)",
            min_temp: minTemp,
            weather: weather.rawValue
        )
    }
}
