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
//    var weatherModel:WeatherModelMock!
//    var weatherViewController:ViewController!
    //テスト実行前に呼ばれる
    override func setUpWithError() throws {
//        weatherModel = WeatherModelMock()
//        weatherViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "weather") as? ViewController
//        weatherViewController.originalWeatherModel = weatherModel
//        _ = weatherViewController.view

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
    // 天気予報がsunnyだったら、画面に晴れ画像が表示されること
//    func testDisplaySunnyByWeatherReport(){
//        weatherModel.fetchWeatherimp1 = { _ in
//         ReturnedInfo(max_temp: 0, date: "2022-03-29T02:50:25+09:00", min_temp: 0, weather: "sunny")
//        }
////        weatherViewController.loadWeather()
//    }
//}
//class WeatherModelMock: WeatherModel {
//    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<ReturnedInfo, WeatherError>) -> Void) {
//        <#code#>
//    }
//
//
//    var fetchWeatherimp1 : ((AreaAndDate) throws -> ReturnedInfo)!
////    func fetchWeather(_ areaAndDate:AreaAndDate) throws -> ReturnedInfo {
////        return try fetchWeatherimp1(areaAndDate)
////    }
}
