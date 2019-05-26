//
//  TelaDoacao.swift
//  HelpCare
//
//  Created by Lucas Dok on 25/05/19.
//  Copyright © 2019 Lucas Dok. All rights reserved.
//

import UIKit
import Alamofire

class TelaDoacao: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var kitsTbl: UITableView!
    
    struct Kit : Codable {
        let id: String
        let name : String
        let valor : Float
        let items: String
        let updatedAt: Int
    }

    var kits = [Kit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kitsTbl.delegate = self
        kitsTbl.dataSource = self

        Alamofire.request("https://lclzk8zkji.execute-api.us-east-1.amazonaws.com/dev/x/kits").responseJSON { response in
            if let json = response.data {
                
                do {
                    let decoder = JSONDecoder()
                    self.kits = try decoder.decode([Kit].self, from: json as! Data)
                    
                    self.kitsTbl.reloadData()
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
    }
    
    @IBAction func doarPressed(_ sender: Any) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = kits[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "kit") as? TableViewCell {
            
            cell.layer.cornerRadius = 10
            let shadowPath2 = UIBezierPath(rect: cell.bounds)
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = shadowPath2.cgPath
            
            cell.kitLbl.text = post.name
            cell.valorLbl.text = String(format: "R$ %.2f", post.valor)
            var item = post.items.components(separatedBy: ",")
            cell.descricao1Lbl.text = item[0]
            cell.descricao2lbl.text = item[1].trimmingCharacters(in: .whitespacesAndNewlines)
            return cell
        } else {
            return TableViewCell()
        }

    }
}
