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
    
    var monsterId: Int?
    var monster: Monster?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Si recibimos el id del monstruo, buscar los detalles
        if let monsterId = monsterId {
            fetchMonsterDetails(for: monsterId)
        }
    }

    func fetchMonsterDetails(for id: Int) {
        // Asegurarse de que la URL es válida y contiene el id
        guard let url = URL(string: "http://mh.somee.com/api/Monsters/\(id)") else { return }

        // Realizar la solicitud a la API
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al obtener los detalles: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                // Decodificar el JSON recibido
                let decoder = JSONDecoder()
                self.monster = try decoder.decode(Monster.self, from: data)
                
                // Actualizar la interfaz de usuario en el hilo principal
                DispatchQueue.main.async {
                    self.updateUI()
                }
            } catch {
                print("Error al decodificar los detalles: \(error)")
            }
        }
        
        task.resume()
    }

    func updateUI() {
        // Asegurarse de que los detalles del monstruo están disponibles
        if let monster = monster {
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
        }
    }
}



