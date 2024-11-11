//
//  MonsterService.swift
//  MonsterhIGH
//
//  Created by alumno on 11/11/24.
//

import Foundation

class MonsterService {
    static let shared = MonsterService()
    
    func createMonster(monster: Monster, imageData: Data, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://mh.somee.com/api/Monsters") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Configuración de headers para `multipart/form-data`
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Cuerpo de la solicitud
        var body = Data()
        
        // Agregar campos de texto
        let fields = [
            "nombre": monster.nombre,
            "edad": monster.edad,
            "padres": monster.padres,
            "defecto": monster.defecto,
            "comida": monster.comida,
            "color": monster.color
        ]
        
        for (key, value) in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Agregar imagen
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"referencia\"; filename=\"imagen.jpg\"\r\n".data(using: .utf8)!) // Cambiar "imagen" a "referencia"
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        
        // Cerrar el cuerpo de la solicitud
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Llamada a la API
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Validación de respuesta
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    completion(.success(()))
                } else {
                    // Registro detallado de error y respuesta
                    let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Error desconocido"
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    print("Error en la respuesta: \(errorMessage)")
                    completion(.failure(error))
                }
            } else {
                let unknownError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Respuesta desconocida"])
                completion(.failure(unknownError))
            }
        }
        
        task.resume()
    }
}
