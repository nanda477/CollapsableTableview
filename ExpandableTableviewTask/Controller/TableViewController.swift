//
//  ViewController.swift
//  ExpandableTableviewTask
//
//  Created by mahiti on 19/11/18.
//  Copyright © 2018 nanda. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var ecTableView: UITableView!
    var tableData: TableData!
    var expandedSectionHeaderNumber: Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        getJsonData()
    }
    
    func getJsonData() {
        
        if let path = Bundle.main.path(forResource: "AllMenu", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                
                guard let result = try? JSONDecoder().decode(TableData.self, from: data) else {
                    print("Error")
                    return
                }
                tableData = result
                
                
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid Path.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Tableview DataSource & Delegete
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if tableData.count > 0 {
            return tableData.count
        } else {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            let category = tableData[section].subCategory
            return category.count
        } else {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableData.count != 0) {
            return tableData[section].name.uppercased()
        }
        return ""
    }
    
    override  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.groupTableViewBackground
        
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18))
        theImageView.image = UIImage(named: "down")
        header.addSubview(theImageView)
        
        if let viewWithTag = self.view.viewWithTag(section) {
            viewWithTag.removeFromSuperview()
        }
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(TableViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        let section = tableData[indexPath.section].subCategory[indexPath.row]
        cell.nameLabel.text = section.name
        cell.subLabel.text = section.displayName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Expand / Collapse Methods
    
    @objc
    func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section)
            } else {
                tableViewCollapeSection(self.expandedSectionHeaderNumber)
                tableViewExpandSection(section)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int) {
        let sectionData = tableData[section].subCategory
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return
        } else {
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int) {
        let sectionData = tableData[section].subCategory
        
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return
        } else {
            
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
           // self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.middle)
            //self.tableView!.endUpdates()
        }
    }
    
    
}

