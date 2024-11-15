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
    @IBOutlet weak var colorView: UIView!  // Outlet para el UIView que cambiará de color
    
    var monster: Monster?  // El objeto `Monster` completo pasado desde la lista

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Actualizar la UI con los detalles del monstruo si existe
        if let monster = monster {
            updateUI(with: monster)
        } else {
            print("No se recibió un monstruo válido")
        }
    }
    
    // Función para actualizar la UI con los detalles del monstruo
    func updateUI(with monster: Monster) {
        print("Actualizando UI con el monstruo: \(monster.nombre)")  // Verificar que el monstruo se pasa correctamente
        nombreLabel.text = monster.nombre
        edadLabel.text = monster.edad
        padresLabel.text = monster.padres
        defectoLabel.text = monster.defecto
        comidaLabel.text = monster.comida
        colorLabel.text = monster.color
        
        // Cambiar el color del UIView `colorView` usando el valor hexadecimal o blanco si es nulo
        colorView.backgroundColor = UIColor(hex: monster.hexa) ?? UIColor.white
        
        // Cargar la imagen si está disponible
        if let imageUrlString = monster.imagenUrl, let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        
                        // Obtener el color predominante de la imagen
                        if let dominantColor = image.getDominantColor() {
                            self.colorView.backgroundColor = dominantColor
                        }
                    }
                } else if let error = error {
                    print("Error al cargar la imagen: \(error)")
                }
            }.resume()
        }


    }
}

// Extensión para UIColor para manejar colores hexadecimales sin el prefijo #
extension UIColor {
    convenience init?(hex: String?) {
        guard let hex = hex?.trimmingCharacters(in: .whitespacesAndNewlines), hex.count == 6 else { return nil }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
