//
//  ViewController.swift
//  MonsterhIGH
//
//  Created by alumno on 11/8/24.
//

import UIKit

class ViewControllerLista: UICollectionViewController {
    
    // Array para almacenar los monstruos
    var monsters = [Monster]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Llamar a la función para obtener los datos de la API
        fetchMonsterData()
        
    }
    
    func fetchMonsterData() {
        guard let url = URL(string: "http://mh.somee.com/api/Monsters") else { return }

        // Crear una tarea de URLSession para obtener los datos de la API
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al obtener datos: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                self.monsters = try decoder.decode([Monster].self, from: data)
                
                // Recargar la colección después de obtener los datos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error al decodificar JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    // MARK: - UICollectionViewDataSource
    
    // Este método es llamado cada vez que se necesita una celda
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Recuperamos la celda utilizando el identificador
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonsterCell", for: indexPath) as! MonsterCollectionViewCell
        
        // Obtenemos el monstruo correspondiente a este índice
        let monster = monsters[indexPath.item]
        
        // Actualizamos la celda con los datos del monstruo
        cell.Nombre.text = monster.nombre
        cell.Padres.text = monster.padres
        
        // Cargar la imagen de la URL si está disponible
        if let imageUrlString = monster.imagenUrl, let imageUrl = URL(string: imageUrlString) {
            // Descargar la imagen
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.foto_de_perfil.image = image
                    }
                } else if let error = error {
                    print("Error al cargar la imagen: \(error)")
                }
            }.resume()
        }
        
        return cell
    }
    
    // Número de celdas a mostrar en la colección
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monsters.count
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout (opcional)

    // Este método se ejecuta cuando el usuario hace clic en una celda de la colección
    // Método donde se selecciona un monstruo
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMonster = monsters[indexPath.item]
        print("Seleccionando monstruo con ID: \(selectedMonster.id)")  // Verifica que el ID es correcto
        
        // Instanciar el ViewController de detalles
        if let detallesVC = self.storyboard?.instantiateViewController(withIdentifier: "DetallesViewController") as? DetallesViewController {
            detallesVC.monster = selectedMonster  // Pasar el objeto completo
            self.navigationController?.pushViewController(detallesVC, animated: true)
        }
    }
}

