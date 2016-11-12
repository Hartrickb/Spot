//
//  ViewController.swift
//  Spot
//
//  Created by Bennett Hartrick on 11/11/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit
import Alamofire

class TableViewController: UITableViewController {
    
    var searchURL = "https://api.spotify.com/v1/search?q=Shawn+Mendes&type=track"
    
    var names = [String]()
    
    typealias JSONStandard = [String: AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        callAlamo(url: searchURL)
    }
    
    func callAlamo(url: String) {
        Alamofire.request(url).responseJSON(completionHandler: { response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData: Data) {
        
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let tracks = readableJSON["tracks"] as? JSONStandard {
                if let items = tracks["items"] as? [JSONStandard] {
                    for i in 0..<items.count {
                        let item = items[i] 
                        
                        let name = item["name"] as! String
                        print(item)
                        names.append(name)
                        
                        self.tableView.reloadData()
                    }
                }
            }
            print(readableJSON)
        } catch {
            print(error)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel?.text = names[indexPath.row]
        
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

