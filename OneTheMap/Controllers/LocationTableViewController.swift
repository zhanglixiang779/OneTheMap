//
//  LocationTableViewController.swift
//  OneTheMap
//
//  Created by Lixiang Zhang on 1/23/21.
//

import UIKit

class LocationTableViewController: BaseLocationUIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        indicator.startAnimating()
        fetchLocations {
            self.tableView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        indicator.startAnimating()
        fetchLocations {
            self.tableView.reloadData()
            self.indicator.stopAnimating()
        }
    }

}

extension LocationTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationCell")!
        let location = locations[indexPath.row]
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel?.text = location.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let location = locations[indexPath.row]
        guard let url = URL(string: location.mediaURL) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
