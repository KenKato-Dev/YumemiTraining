//
//  ViewController.swift
//  YumemiTraining
//
//  Created by 加藤研太郎 on 2022/03/20.
//
//area date のStructの変数をData型⇨String（.utf8）型に変換して再度Json Stringに入れる
import UIKit
import YumemiWeather

import Foundation

//要質問 
protocol WeatherModel {
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<ReturnedInfo,  YumemiWeatherError>) -> Void)
}

//要質問
protocol DisasterModel{
    func fetchDesaster(completion:((String)->Void)?)
}
class YumemiWeatherModel: WeatherModel {
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<ReturnedInfo, YumemiWeatherError>) -> Void) {
        let areaAndDate = AreaAndDate(area: area, date: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        do{
            let enconder = JSONEncoder()
            enconder.dateEncodingStrategy = .formatted(dateFormatter)
            
            let data = try enconder.encode(areaAndDate)
            let encodedToJsonString:String = String(data: data, encoding: .utf8)!
            // 下記変数によりjson文字列のランダムな結果が吐き出されるようになるのでこれを変換していく
            YumemiWeather.callbackFetchWeather(encodedToJsonString) { result in
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
                        let alartController = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
                        alartController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ ->Void in
                            print("\(message)")
                        }))
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
            let alert = UIAlertController(title: "FetchWeatherエラー", message: weatherMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ボタン1", style: .default, handler: { _ -> Void in
                print(weatherMessage)
            }))
        }
    }
    
}
private extension UIImageView {
    func imageSet(weather: Weather) {
        switch weather {
        case .sunny:
            self.image = UIImage(named: "Sunny")
            self.tintColor = UIColor(named: "Red")
        case .cloudy:
            self.image = UIImage(named: "Cloudy")
            self.tintColor = UIColor(named: "Gray")
        case .rainy:
            self.image = UIImage(named: "Rainy")
            self.tintColor = UIColor(named: "Blue")
        }
    }
}
//①YumemiWeatherModelを使用するように書き換える、従来通りの動きをするか要確認
//②Unittestに移行する
class ViewController: UIViewController {
    var yumemiWeatherModel = YumemiWeatherModel()
//    var originalDisasterMde: DisasterModel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var maxTmperature: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    
//    static let shared:ViewController = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reloadButton.addTarget(self, action: #selector(reloadAction), for: .touchUpInside)
        closeButton.addAction(UIAction.init(handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        //下記の記述によりバックグランド・フォアグラウンド状態を検知・判定
        //引数はそれぞれobserverが観察側のView、selectorで実施するobjcFunc、nameは観察先でここが実行されたらこの記述が実行
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAction), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
//    @objc func clocseAction() {
//        dismiss(animated: true, completion: nil)
//    }
    @objc func reloadAction() {
        yumemiWeatherModel.fetchWeather(at: "Tokyo", date: Date()){ result in
            switch result{
            case .success(let returnedInfo):
                self.weatherImage.imageSet(weather: Weather(rawValue: returnedInfo.weather) ?? .sunny)
                self.maxTmperature.text = String(returnedInfo.max_temp)
                self.minTemperature.text = String(returnedInfo.min_temp)

            case.failure(let weatherError):
                let weatherMessage:String
                switch weatherError {
                case .unknownError:
                    weatherMessage = "原因不明のエラーが発生"
                case .invalidParameterError:
                    weatherMessage = "無効なパラメータが返されました"
//                case .jsonEncodeError:
//                    weatherError = .jsonEncodeError
//                    weatherMessage = "jsonEncodeに失敗しました"
//                case .jsonDecodeError:
//                    weatherError = .jsonDecodeError
//                    weatherMessage = "jsonDecodeに失敗しました"
//                case .unknownError:
//                    weatherError = .unknownError
//                    weatherMessage = "FetchWeatherでよく分からないエラーが発生しました"
                }
                let alert = UIAlertController(title: "FetchWeatherエラー", message: weatherMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: { _ -> Void in
                    print(weatherMessage)
                }))
                self.present(alert, animated: true) {
                    print("エラー発生")
                }
            }
            
        }
//        // 下記のままだと返り値が重複するものの回避には画像データ名変更が必要
//        do {
//            let areaAndDate = AreaAndDate(area: "tokyo", date: Date())
//            let data = try JSONEncoder().encode(areaAndDate)
//            let encodedToJsonString:String = String(data: data, encoding: .utf8)!
//            // 下記変数によりjson文字列のランダムな結果が吐き出されるようになるのでこれを変換していく
//            let fetchWeatherJson = try YumemiWeather.fetchWeather(encodedToJsonString)
//            let jsonData = fetchWeatherJson.data(using: .utf8)
//            let decodedJson = try! JSONDecoder().decode(ReturnedInfo.self, from: jsonData!)
//            weatherImage.imageSet(weather: Weather(rawValue: decodedJson.weather) ?? .sunny)
//            maxTmperature.text = String(decodedJson.max_temp)
//            minTemperature.text = String(decodedJson.min_temp)
//
//        } catch {
//            print("エラー")
//            let alert =  UIAlertController(title: "タイトル", message: "エラーが発生しました", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "ボタン1", style: .default, handler: { _ -> Void in
//                print("ボタン1が押されました")
//            }))
//            alert.addAction(UIAlertAction(title: "ボタン2", style: .destructive, handler: { _ -> Void in
//                    print("ボタン2が押されました")
//            }))
//            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { _ -> Void in
//                    print("キャンセルが押されました")
//            }))
//            self.present(alert, animated: true, completion: {
//                print("アラートを表示")
//            })
//    }
}
//    func getfile(_ filePath: String) -> Data? {
//        let fileData: Data?
//        do {
//            let fileUrl = URL(fileURLWithPath: filePath)
//            fileData = try Data(contentsOf: fileUrl)
//        } catch {
//            // ファイルデータ破損の際にエラー
//            fileData = nil
//        }
//        return fileData
//    }
    func getJsonData() throws-> Data? {
        guard let path = Bundle.main.path(forResource: "WeatherInformation", ofType: "json") else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
}
