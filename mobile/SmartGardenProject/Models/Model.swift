//
//  Model.swift
//  SmartGarden
//
//  Created by Turma01-26 on 03/04/25.
//

import Foundation

struct PlantaInfo: Codable {
    let nome_popular: String
    let descricao: String
    let umidade_ideal_min: Int
    let umidade_ideal_max: Int
    let luminosidade_ideal: String
}

struct Sensor: Decodable, Hashable {
    var umidade: String
}


struct PlantData: Codable, Hashable {
    var _id: String?
    var _rev: String?
    var nome: String
    var umidadeMinIdeal: Int
    var umidadeMaxIdeal: Int
    var luminosidade: String
    var descricao: String
    var imageBase64: String? 
    var warning: String
}

struct WeatherResponse: Codable, Equatable {
    let name: String
    let weather: [Weather]
    let main: Main
    
    struct Weather: Codable, Equatable {
        let description: String
        let icon: String
    }
    
    struct Main: Codable, Equatable {
        let temp: Double
    }
}
