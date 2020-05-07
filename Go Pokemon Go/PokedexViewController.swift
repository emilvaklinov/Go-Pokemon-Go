//
//  PokedexViewController.swift
//  Go Pokemon Go
//
//  Created by Emil Vaklinov on 07/05/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
}
