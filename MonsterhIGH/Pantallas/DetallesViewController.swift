//
//  DetallesViewController.swift
//  MonsterhIGH
//
//  Created by alumno on 11/11/24.
//

import UIKit

class DetallesViewController: UIViewController {
    
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var edadLabel: UILabel!
    @IBOutlet weak var padresLabel: UILabel!
    @IBOutlet weak var defectoLabel: UILabel!
    @IBOutlet weak var comidaLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var monsterId: Int?  // Asegúrate de que este es el id que estás pasando
        var monster: Monster?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Verificar si el monsterId está disponible y luego obtener los detalles
            if let id = monsterId {
                print("Recibido el id del monstruo: \(id)")  // Verifica que el id es correcto
                fetchMonsterDetails(for: id)
            }
        }
        
        // Función para obtener los detalles del monstruo con el id
        func fetchMonsterDetails(for id: Int) {
            guard let url = URL(string: "http://mh.somee.com/api/Monsters/\(id)") else {
                print("URL no válida")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error al obtener los detalles: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No se recibieron datos")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    self.monster = try decoder.decode(Monster.self, from: data)
                    
                    print("Detalles del monstruo: \(String(describing: self.monster))")  // Verifica si se obtiene el monstruo
                    
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                } catch {
                    print("Error al decodificar los detalles: \(error)")
                }
            }
            
            task.resume()
        }
        
        // Función para actualizar la UI con los detalles del monstruo
        func updateUI() {
            // Asegurarse de que los detalles del monstruo están disponibles
            if let monster = monster {
                print("Actualizando UI con el monstruo: \(monster.nombre)")  // Verifica que el monstruo se pasa correctamente
                nombreLabel.text = monster.nombre
                edadLabel.text = monster.edad
                padresLabel.text = monster.padres
                defectoLabel.text = monster.defecto
                comidaLabel.text = monster.comida
                colorLabel.text = monster.color
                
                // Cargar la imagen si está disponible
                if let imageUrlString = monster.imagenUrl, let imageUrl = URL(string: imageUrlString) {
                    URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.imageView.image = image
                            }
                        } else if let error = error {
                            print("Error al cargar la imagen: \(error)")
                        }
                    }.resume()
                }
            } else {
                print("No se recibió un monstruo válido")
            }
        }

}



