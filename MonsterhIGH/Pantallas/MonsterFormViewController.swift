//
//  MonsterFormViewController.swift
//  MonsterhIGH
//
//  Created by alumno on 11/11/24.
//

import UIKit

class MonsterFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Conectar elementos de la interfaz ya diseñados
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var edadTextField: UITextField!
    @IBOutlet weak var padresTextField: UITextField!
    @IBOutlet weak var defectoTextField: UITextField!
    @IBOutlet weak var comidaTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuración de botón para seleccionar imagen
        selectImageButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        
        // Configuración de botón para guardar datos
        saveButton.addTarget(self, action: #selector(saveMonster), for: .touchUpInside)
    }
    
    // Método para seleccionar imagen desde el dispositivo
    @objc func selectImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    // Método para capturar imagen seleccionada
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imageView.image = image
        }
        dismiss(animated: true)
    }
    
    // Método para guardar el monstruo en la API
    @objc func saveMonster() {
        guard let nombre = nombreTextField.text,
              let edad = edadTextField.text,
              let padres = padresTextField.text,
              let defecto = defectoTextField.text,
              let comida = comidaTextField.text,
              let color = colorTextField.text,
              let selectedImage = selectedImage,
              let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            print("Faltan campos o imagen")
            return
        }
        
        // Crear el objeto Monster para el POST (sin id y hexa)
        let monster = Monster(id: nil, nombre: nombre, edad: edad, padres: padres, defecto: defecto, comida: comida, color: color, hexa: nil, imagenUrl: nil)
        
        // Llamar al servicio de red
        MonsterService.shared.createMonster(monster: monster, imageData: imageData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let alert = UIAlertController(title: "Éxito", message: "Monstruo creado correctamente", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                case .failure(let error):
                    print("Error al crear el monstruo: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Error", message: "Hubo un problema al crear el monstruo", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}


