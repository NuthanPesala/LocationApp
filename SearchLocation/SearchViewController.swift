//
//  SearchViewController.swift
//  SearchLocation
//
//  Created by Nuthan Raju Pesala on 06/05/21.
//

import UIKit
import  CoreLocation
protocol searchViewControllerDelegate {
    func sendingCoordinates(coordinates: CLLocationCoordinate2D)
}

class SearchViewController: UIViewController {

    var delegate: searchViewControllerDelegate? = nil
    
    private let textLabel: UILabel = {
       let label = UILabel()
        label.text = "Where To?"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    private lazy var textField: UITextField = {
       let text = UITextField()
        text.placeholder = "Enter Destination"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.font = UIFont.systemFont(ofSize: 16)
        text.textColor = UIColor.lightGray
        text.backgroundColor = UIColor.secondarySystemBackground
        text.layer.cornerRadius = 8
        text.delegate = self
        return text
    }()
    
    private lazy var tableView: UITableView = {
      let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.tableFooterView = UIView()
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = UIColor.clear
        return tv
    }()
    
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.view.addSubview(textLabel)
        self.view.addSubview(textField)
        self.view.addSubview(tableView)
     
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textLabel.sizeToFit()
        textLabel.frame = CGRect(x: 10, y: 10, width: view.frame.size.width , height: textLabel.frame.size.height)
        textField.frame = CGRect(x: 10, y: 20 + textLabel.frame.size.height, width: view.frame.size.width - 20 , height: 40)
        let tableY = textField.frame.origin.y + textField.frame.size.height + 5
        tableView.frame = CGRect(x: 0, y: tableY, width: view.frame.size.width, height: view.frame.size.height - tableY)
    }

 

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coordinates = locations[indexPath.row].coordinates
        delegate?.sendingCoordinates(coordinates: coordinates)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        LocationManager.shared.findingLocations(with: text) { [weak self] (location) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.locations = location
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
        return true
    }
    
}
