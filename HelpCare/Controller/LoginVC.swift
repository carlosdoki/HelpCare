//
//  LoginVC.swift
//  HelpCare
//
//  Created by Carlos Doki on 26/05/19.
//  Copyright © 2019 Lucas Dok. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var pickerLogin: UIPickerView!
    
    struct User : Codable {
        let id: String
        let name: String
        let skills: String
        let email : String
        let distancia : Int
        let telefone: String
        let latitude : Float
        let longitude : Float
        let updatedAt: Int
    }

    var users = [User]()
    var nomes: [String] = [String]()
    var ids: [String] = [String]()
    var id : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerLogin.delegate = self
        self.pickerLogin.dataSource = self
        
        Alamofire.request("https://lclzk8zkji.execute-api.us-east-1.amazonaws.com/dev/x/users").responseJSON { response in
            if let json = response.data {
                do {
                    let decoder = JSONDecoder()
                    var users = try decoder.decode([User].self, from: json as! Data)
                    for user in users {
                        self.nomes.append(user.name)
                        self.ids.append(user.id)
                    }
                    self.pickerLogin.reloadAllComponents()
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        performSegue(withIdentifier: "inicial", sender: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nomes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        nome = nomes[row]
        idusuario = ids[row]
        return nomes[row]
    }
}
