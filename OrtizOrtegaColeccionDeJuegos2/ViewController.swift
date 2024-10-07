//
//  ViewController.swift
//  OrtizOrtegaColeccionDeJuegos2
//
//  Created by mauro on 10/6/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let juego = juegos[indexPath.row]
        
        let titulo = juego.titulo ?? "Sin título"
        let categoria = juego.categoria ?? "Sin categoría"
        cell.textLabel?.text = "\(titulo) - \(categoria)"
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juegoToDelete = juegos[indexPath.row]
            context.delete(juegoToDelete)
            
            do {
                try context.save()
                juegos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Error al eliminar el juego")
            }
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var juegos : [Juego] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try juegos = context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        }catch{
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
    }

}

