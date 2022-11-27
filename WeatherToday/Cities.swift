//
//  Cities.swift
//  WeatherToday
//
//  Created by 박다연 on 2022/11/27.
//

import Foundation

/*
 {
    "city_name":"파리",
    "state":10,
    "celsius":11.3,
    "rainfall_probability":90
 }
 
 10 : sunny
 11 : cloudy
 12 : rainy
 13 : snowy
 */

struct Cities: Codable {
    
    let cityName: String
    let state: Int
    let celsius: Double
    let rainfallProbability: Int
    
    var temp: String {
        return "섭씨 \(celsius)도 / 화씨 \(celsius * 2 + 30)도"
    }
    
    var rain: String {
        return "강수확률 \(rainfallProbability)%"
    }
    enum CodingKeys: String, CodingKey {
        case state, celsius
        case cityName = "city_name"
        case rainfallProbability = "rainfall_probability"
    }
}

//       {
//          "city_name":"베를린",
//          "state":12,
//          "celsius":10.8,
//          "rainfall_probability":60
//       },
//       {
//          "city_name":"함부르크",
//          "state":12,
//          "celsius":5.6,
//          "rainfall_probability":40
//       },
//       {
//          "city_name":"뮌헨",
//          "state":13,
//          "celsius":7.2,
//          "rainfall_probability":10
//       },
//       {
//          "city_name":"쾰른",
//          "state":12,
//          "celsius":18.8,
//          "rainfall_probability":90
//       },
//       {
//          "city_name":"프랑크푸르트",
//          "state":11,
//          "celsius":11.2,
//          "rainfall_probability":70
//       },
//       {
//          "city_name":"슈투트가르트",
//          "state":11,
//          "celsius":18.6,
//          "rainfall_probability":60
//       },
//       {
//          "city_name":"뒤셀도르프",
//          "state":11,
//          "celsius":15.1,
//          "rainfall_probability":80
//       },
//       {
//          "city_name":"도르트문트",
//          "state":10,
//          "celsius":24.8,
//          "rainfall_probability":40
//       },
//       {
//          "city_name":"에센",
//          "state":13,
//          "celsius":19.2,
//          "rainfall_probability":0
//       },
//       {
//          "city_name":"브레멘",
//          "state":10,
//          "celsius":14.6,
//          "rainfall_probability":60
//       },
//       {
//          "city_name":"하노버",
//          "state":12,
//          "celsius":20.2,
//          "rainfall_probability":10
//       },
//       {
//          "city_name":"라이프치히",
//          "state":13,
//          "celsius":10.1,
//          "rainfall_probability":20
//       },
//       {
//          "city_name":"드레스덴",
//          "state":12,
//          "celsius":12.6,
//          "rainfall_probability":80
//       },
//       {
//          "city_name":"뉘른베르크",
//          "state":11,
//          "celsius":5.2,
//          "rainfall_probability":10
//       },
//       {
//          "city_name":"뒤스부르크",
//          "state":12,
//          "celsius":24.1,
//          "rainfall_probability":50
//       }
//}
