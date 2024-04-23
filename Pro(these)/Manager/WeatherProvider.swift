//
//  WeatherProvider.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 05.10.23.
//

import SwiftUI
import Alamofire

class WeatherModel: ObservableObject {
    
    @Published var weather: WeatherResponse?
    
    @AppStorage("lastFetch", store: AppConfig.store) private var lastFetch:Date = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
    
    private var handlerState = HandlerStates.shared
    
    private let weatherProvider = WeatherProvider()

    var fetchData: Bool {
        guard lastFetch < Calendar.current.date(byAdding: .minute, value: -15, to: Date())! else {
            print("[weatherHandler] last fetch was less them 15minutes")
            return false
        }
        
        return true
    }
    
    func fetchWeather(city: String) {
        if fetchData {
            weatherProvider.fetchWeather(city: city) { WeatherResponse in
                
                DispatchQueue.main.async {
                    self.weather = WeatherResponse
                    
                    self.handlerState.weatherTempC = WeatherResponse.current.tempC
                    self.handlerState.weatherTempF = WeatherResponse.current.tempF
                    self.handlerState.weatherCondition = WeatherResponse.current.condition.text
                    self.handlerState.weatherPressureMb = WeatherResponse.current.pressureMb
                    self.handlerState.weatherConditionIcon = WeatherResponse.current.condition.icon
                }
            }
        }
    }
    
    func weatherForPainEntrie(city: String, completion: @escaping (PainWeather) -> Void) {
        if fetchData {
            weatherProvider.fetchWeather(city: city) { WeatherResponse in
                DispatchQueue.main.async {
                    let entrie = PainWeather(
                        tempF: WeatherResponse.current.tempF,
                        tempC: WeatherResponse.current.tempC,
                        condition: WeatherResponse.current.condition.text,
                        pressureMb: WeatherResponse.current.pressureMb,
                        icon: WeatherResponse.current.condition.icon
                    )
                    
                    self.lastFetch = Date()
                    
                    completion(entrie)
                }
            }
        } else {
            let entrie = PainWeather(
                tempF: HandlerStates.shared.weatherTempC,
                tempC: HandlerStates.shared.weatherTempF,
                condition: HandlerStates.shared.weatherCondition,
                pressureMb: HandlerStates.shared.weatherPressureMb,
                icon: HandlerStates.shared.weatherConditionIcon
            )
            
            completion(entrie)
        }
    }
}

class WeatherProvider {
    let key = "116035f5706f4f7ab36160702230410"
    
    func fetchWeather(city: String, printState: Bool? = nil ,completion: @escaping (WeatherResponse) -> Void) {
        AF.request("https://api.weatherapi.com/v1/current.json?key=\(key)&q=\(city)&aqi=no").responseJSON { response in
            
            if let data = response.data {
                if let weatherResponse = self.parseWeatherResponse(data: data) {
                    
                    if printState ?? false {
                        // Du kannst jetzt auf die geparsten Daten im WeatherResponse-Objekt zugreifen
                        print("Parsed Weather Response: \(weatherResponse)")
                        print("Location: \(weatherResponse.location.name)")
                        print("Temperature: \(weatherResponse.current.tempC)°C")
                        // ... und so weiter
                    }
                    
                    completion(weatherResponse)
                }
            }
        }
    }
    
    func parseWeatherResponse(data: Data) -> WeatherResponse? {
        let decoder = JSONDecoder()
        do {
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
            return weatherResponse
        } catch {
            print("Error parsing weather response: \(error)")
            return nil
        }
    }
}

struct PainWeather {
    var tempF: Double
    var tempC: Double
    var condition: String
    var pressureMb: Double
    var icon: String
}

/*
enum weaterKind {
    case .sunny = "Sunny"
    case .clear = "Clear"
    case .partlyCloudy = "Partly cloudy"
    case .cloudy = "Cloudy"
    case .overcast = "Overcast"
    case .mist = "Mist"
    case .patchyRainPossible = "Patchy rain possible"
    case .patchySnowPossible = "Patchy snow possible"
    case .patchySleetPossible = "Patchy sleet possible"
    case .patchyFreezingDrizzlePossible = "Patchy freezing drizzle possible"
    case .thunderyOutbreaksPossible = "Thundery outbreaks possible"
    case .blowingSnow = "Blowing snow"
    case .blizzard = "Blizzard"
    case .fog = "Fog"
    case .freezingFog = "Freezing fog"
    case .patchyLightDrizzle = "Patchy light drizzle"
    case .lightDrizzle = "Light drizzle"
    case .freezingDrizzle = "Freezing drizzle"
    case .heavyFreezingDrizzle = "Heavy freezing drizzle"
    case .patchyLightRain = "Patchy light rain"
    case "Light rain"
    case "Moderate rain at times"
    case "Moderate rain"
    case "Heavy rain at times"
    case "Heavy rain"
    case "Light freezing rain"
    case "Moderate or heavy freezing rain"
    case "Light sleet"
    case "Moderate or heavy sleet"
    case "Patchy light snow"
    case "Light snow"
    case "Patchy moderate snow"
    case "Moderate snow"
    case .patchyHeavySnow = "Patchy heavy snow"
    case .hHeavySnow = "Heavy snow"
    case .icePellets = "Ice pellets"
    case .lightRainShower = "Light rain shower"
    case .moderateOrHeavyRainShower = "Moderate or heavy rain shower"
    case .torrentialRainShower = "Torrential rain shower"
    case .Light sleetShowers = "Light sleet showers"
    case "Moderate or heavy sleet showers"
    case "Light snow showers"
    case "Moderate or heavy snow showers"
    case "Light showers of ice pellets"
    case "Moderate or heavy showers of ice pellets"
    case "Patchy light rain with thunder"
    case "Moderate or heavy rain with thunder"
    case .patchyLightSnowWithThunder = "Patchy light snow with thunder"
    case .ModerateOrHeavySnowWithThunder = "Moderate or heavy snow with thunder"
}
*/
