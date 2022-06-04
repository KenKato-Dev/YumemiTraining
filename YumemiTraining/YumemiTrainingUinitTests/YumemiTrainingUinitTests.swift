//
//  YumemiTrainingUinitTests.swift
//  YumemiTrainingUinitTests
//
//  Created by 加藤研太郎 on 2022/04/30.
//

import XCTest
import YumemiWeather
@testable import YumemiTraining

class YumemiTrainingUinitTests: XCTestCase {
    var weatherModel:WeatherModelMock!
    var weatherViewController:ViewController!
    //テスト実行前に呼ばれる
    override func setUpWithError() throws {
        weatherModel = WeatherModelMock()
        weatherViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "weather") as? ViewController
        weatherViewController.weatherModel = weatherModel
        _ = weatherViewController.view

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    //テスト実行後に呼ばれる
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
//     天気予報がsunnyだったら、画面に晴れ画像が表示されること
    func testDisplaySunnyByWeatherReport(){
        let mock = WeatherModelMock()
        //ここでViewが呼ばれてしまう、このためinitにWeathermodelを入れる
        let viewController = UIStoryboard(name:"WeatherViewController", bundle: Bundle.main).instantiateInitialViewController { coder in
            ViewController(coder: coder, weatherModel: mock)
        }
        viewController!.weatherModel = mock
//        UIApplication.shared.keyWindow!.rootViewController = viewController
        //ここでviewが呼ばれることでViewdidloadが読み込まれると考えていたが実際はviewconを変数の時点で呼ばれている
//        viewController.loadViewIfNeeded()
        XCTAssertEqual(UIImage(named: "Sunny"),viewController!.weatherImage.image)
    }
}
class WeatherModelMock:WeatherModel{
    
    var fetchWeatherImpl:((AreaAndDate) throws -> ReturnedInfo)!
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<ReturnedInfo, YumemiWeatherError>) -> Void) {
        fetchWeather(at: "tokyo", date: Date()) { result in
            completion(.success(.init(max_temp: 25, date: "2023-04-01T12:00:00+09:00", min_temp: 12, weather: "sunny")))
        }
    }
}
