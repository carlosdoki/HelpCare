//
//  Cursos.swift
//  HelpCare
//
//  Created by Lucas Dok on 25/05/19.
//  Copyright © 2019 Lucas Dok. All rights reserved.
//

import UIKit

class Cursos: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    

    @IBOutlet weak var usuarioLbl: UILabel!
    @IBOutlet weak var cursosTbl: UITableView!
    @IBOutlet weak var totalLbl: UILabel!
    
    var cursos = ["Primeiros Socorros", "Brigada de Incêndio", "Manuseio Hidrantes e extintores", "Mergulho"]
    var locais = ["1. Batalhão Corpo de Bombeiro. Av. Rangel Pestana, 99.", "Praça Clovis Bevilácqua, 421", "Rua Hélion Povoa, 120", "R. Sumidouro, 520"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        total = 0
        
        cursosTbl.delegate = self
        cursosTbl.dataSource = self
        
        usuarioLbl.text = "Olá \(nome)"
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cursos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curso = cursos[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CursosTVC {
            
            cell.layer.cornerRadius = 10
            let shadowPath2 = UIBezierPath(rect: cell.bounds)
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = shadowPath2.cgPath
            
            cell.cursoLbl.text = curso
            cell.localLbl.text = locais[indexPath.row]
            cell.valorLbl.text = String(format: "%.2f", Float.random(in: 1..<20))
            cell.switchS.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            
            return cell
        } else {
            return CursosTVC()
        }
    }
    
    
    @objc func switchChanged(_ sender : UISwitch!){
        totalLbl.text = String(format: "%.2f", total)
    }
}
