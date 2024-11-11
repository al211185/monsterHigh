//
//  Monster.swift
//  MonsterhIGH
//
//  Created by alumno on 11/8/24.
//
import Foundation

// Estructura para representar un monstruo.
struct Monster: Codable {
    let id: Int?
    let nombre: String
    let edad: String
    let padres: String
    let defecto: String
    let comida: String
    let color: String
    let hexa: String?
    let imagenUrl: String? // Hacerlo opcional para que pueda ser nil

    enum CodingKeys: String, CodingKey {
        case id
        case nombre
        case edad
        case padres
        case defecto
        case comida
        case color
        case hexa
        case imagenUrl = "imagenUrl" // Esta es la clave en el JSON
    }
}


