//
//  WeatherError.swift
//  YumemiTraining
//
//  Created by 加藤研太郎 on 2022/04/26.
//

import Foundation
enum WeatherError:Error{
    case jsonEncodeError
    case jsonDecodeError
    case unknownError
}
