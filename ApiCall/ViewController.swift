//
//  ViewController.swift
//  ApiCall
//
//  Created by Lalaiya Sahil on 02/01/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var arrUsers: [Dictionary<String,AnyObject>] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        configure()
        // Do any additional setup after loading the view.
    }

    private func getUsers(){
        guard let url = URL(string: "https://gorest.co.in/public/v2/users") else{ return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request){ data,response,error in
            guard let apiData = data else { return }
            do{
                let json = try JSONSerialization.jsonObject(with: apiData) as! [Dictionary<String,AnyObject>]
                self.arrUsers = json
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
        .resume()
       
    }
    
    private func configure(){
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier: "TableViewCell")
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let rowDictionary = arrUsers[indexPath.row]
        cell.nameLabel.text = "Name:-\(rowDictionary["name"] as! String)"
        cell.genderLabel.text = "Gender:-\(rowDictionary["gender"] as! String)"
        cell.emailLabel.text = "Email:- \(rowDictionary["email"] as! String)"
        cell.idLabel.text = "Id:- \(rowDictionary["id"] as! Int)"
        cell.statusLabel.text = "Status:- \(rowDictionary["status"] as! String)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
