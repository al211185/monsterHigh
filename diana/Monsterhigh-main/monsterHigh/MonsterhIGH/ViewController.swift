//
//  ViewController.swift
//  MonsterhIGH
//
//  Created by alumno on 11/8/24.
//

import UIKit
 
class ViewController: UIViewController {
override func viewDidLoad() {
    super.viewDidLoad()

    
}

    @IBAction func VerPersonajes(_ sender: Any) {
        performSegue(withIdentifier: "ViewControllerLista", sender: self)
    }
    @IBAction func CrearPersonaje(_ sender: Any) {
        performSegue(withIdentifier: "MonsterFormViewController", sender: self)
    }
}

