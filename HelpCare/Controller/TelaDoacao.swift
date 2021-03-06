//
//  TelaDoacao.swift
//  HelpCare
//
//  Created by Lucas Dok on 25/05/19.
//  Copyright © 2019 Lucas Dok. All rights reserved.
//

import UIKit
import Alamofire


class TelaDoacao: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate  {

    @IBOutlet weak var kitsTbl: UITableView!
    @IBOutlet weak var usuarioLbl: UILabel!
    @IBOutlet weak var carregandoV: UIView!
    @IBOutlet weak var doacaoV: UIView!
    @IBOutlet weak var webView: UIWebView!
    
    
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
        webView.isHidden = true
        
        webView.delegate = self
        
        carregandoV.isHidden = false
        doacaoV.isHidden = true
        
        usuarioLbl.text = "Olá \(nome)"
        
        kitsTbl.delegate = self
        kitsTbl.dataSource = self

        Alamofire.request("https://lclzk8zkji.execute-api.us-east-1.amazonaws.com/dev/x/kits").responseJSON { response in
            if let json = response.data {
                
                do {
                    let decoder = JSONDecoder()
                    self.kits = try decoder.decode([Kit].self, from: json as! Data)
                    self.kits.sort(by: {$0.name < $1.name})
                    self.kitsTbl.reloadData()
                    self.carregandoV.isHidden = true
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        doacaoV.isHidden = true
    }
    
    @IBAction func doarPressed(_ sender: Any)
    {
        webView.isHidden = false
        carregandoV.isHidden = false
        let url = NSURL(string: "https://sb-autenticacao-api.original.com.br/OriginalConnect/LoginController");
        
        let requestObj = NSURLRequest(url: url! as URL);
        
        webView.loadRequest(requestObj as URLRequest);
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.isHidden = true
        carregandoV.isHidden = true
        usleep(5000000)
        doacaoV.isHidden = false
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
