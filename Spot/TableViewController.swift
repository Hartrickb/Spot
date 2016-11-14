//
//  ViewController.swift
//  Spot
//
//  Created by Bennett Hartrick on 11/11/16.
//  Copyright © 2016 Bennett. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

var player = AVAudioPlayer()

struct post {
    let image: UIImage!
    let name: String!
    let previewURL: String!
}

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    var searchURL = String()
    
    var posts = [post]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    typealias JSONStandard = [String: AnyObject]
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        
        searchURL = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track"
        
        callAlamo(url: searchURL)
        self.view.endEditing(true)
        posts.removeAll()
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                        let previewURL = item["preview_url"] as! String
                        print(item)
                        
                        if let album = item["album"] as? JSONStandard {
                            if let images = album["images"] as? [JSONStandard] {
                                let imageData = images[0]
                                let mainImageURL = imageData["url"]
                                let mainImageData = NSData(contentsOf: URL(string: mainImageURL as! String)!)
                                
                                let mainImage = UIImage(data: mainImageData as! Data)
                                
                                posts.append(post.init(image: mainImage, name: name, previewURL: previewURL))
                                self.tableView.reloadData()
                                
                            }
                        }
                    }
                }
            }
            print(readableJSON)
        } catch {
            print(error)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let mainImageView = cell?.viewWithTag(2) as! UIImageView
        mainImageView.image = posts[indexPath.row].image
        
        let mainLabel = cell?.viewWithTag(1) as! UILabel
        mainLabel.text = posts[indexPath.row].name
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        
        let viewController = segue.destination as! AudioVC
        
        viewController.image = posts[indexPath!].image
        viewController.mainSongTitle = posts[indexPath!].name
        viewController.mainPreviewURL = posts[indexPath!].previewURL
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

