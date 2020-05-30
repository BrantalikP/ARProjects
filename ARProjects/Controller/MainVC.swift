//
//  MainVC.swift
//  ARProjects
//
//  Created by Petr Brantalík on 30/05/2020.
//  Copyright © 2020 Petr Brantalík. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    var routes: [Route] = [Route(name: "Basics", segueId: K.basicsSegue)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

   

}

extension MainVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = routes[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let route = routes[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: route.segueId, sender: self)
        
    }
    
    
}
