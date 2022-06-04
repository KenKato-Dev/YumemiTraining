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
//    func fetchWeather(areaAndDate:AreaAndDate, completion: @escaping (Result<ReturnedInfo,  YumemiWeatherError>) -> Void)
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<ReturnedInfo,  YumemiWeatherError>) -> Void)
}

//要質問
protocol DisasterModel{
    func fetchDesaster(completion:((String)->Void)?)
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
    var weatherModel:WeatherModel!
    var yumemiWeatherModel = WeatherModelImpl()
//    var originalDisasterMde: DisasterModel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var maxTmperature: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    
    
    init!(coder:NSCoder,weatherModel:WeatherModel) {
        self.weatherModel = weatherModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //    static let shared:ViewController = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reloadAction()
        reloadButton.addTarget(self, action: #selector(reloadAction), for: .touchUpInside)
        closeButton.addAction(UIAction.init(handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        //下記の記述によりバックグランド・フォアグラウンド状態を検知・判定
        //引数はそれぞれobserverが観察側のView、selectorで実施するobjcFunc、nameは観察先でここが実行されたらこの記述が実行
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAction), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
//    @objc func clocseAction() {ß
//        dismiss(animated: true, completion: nil)
//    }
    @objc func reloadAction() {
        //ここではfetchweatherは呼び出さず、代替のfuncを描き上げることでエラーを避ける
        weatherModel.fetchWeather(at: "tokyo", date: Date()){ result in
            DispatchQueue.main.async {
                self.handleWeather(result: result)
//                switch result{
//                case .success(let returnedInfo):
//                    self.weatherImage.imageSet(weather: Weather(rawValue: returnedInfo.weather) ?? .sunny)
//                    self.maxTmperature.text = String(returnedInfo.max_temp)
//                    self.minTemperature.text = String(returnedInfo.min_temp)
//
//                case.failure(let weatherError):
//                    let weatherMessage:String
//                    switch weatherError {
//                    case .unknownError:
//                        weatherMessage = "原因不明のエラーが発生"
//                    case .invalidParameterError:
//                        weatherMessage = "無効なパラメータが返されました"
//                    }
//                    let alert = UIAlertController(title: "FetchWeatherエラー", message: weatherMessage, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: { _ -> Void in
//                        print(weatherMessage)
//                    }))
//                    self.present(alert, animated: true) {
//                        print("エラー発生")
//                    }
//                }
            }
            
        }
}
    func handleWeather(result:Result<ReturnedInfo, YumemiWeatherError>) {
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
}
