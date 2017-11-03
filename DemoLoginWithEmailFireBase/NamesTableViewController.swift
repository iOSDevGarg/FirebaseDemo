//
//  NamesTableViewController.swift
//  DemoLoginWithEmailFireBase
//
//  Created by Jatin on 03/07/17.
//  Copyright © 2017 iOS-Trainee. All rights reserved.
//

import UIKit
import Firebase

class NamesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var namesTable: UITableView!
    var names = [String]()
    var id = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var readData = DatabaseReference()
    var postData = [String:AnyObject]()
    var databaseHandler:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Database reference to Fetch Data
        readData = Database.database().reference()
        //Database reference to Fetch Data
        readData = Database.database().reference()
      
            self.databaseHandler = self.readData.child("artists").observe(.value, with: { (snapshot) in
                self.postData = ((snapshot.value) as? [String : AnyObject]!)!
                print(self.postData)
                
                if let snapDict = snapshot.value as? [String:AnyObject]{
                    
                    for each in snapDict{
                        
                        let artistName = each.value["artistName"] as! String
                        let ID = each.value["id"] as! String
                        self.names.append(artistName)
                        self.id.append(ID)
                        print(self.names[0])
                    }
                    self.namesTable.dataSource = self
                    self.namesTable.delegate = self
                    self.namesTable.reloadData()
                }
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        print(names.count)
        return names.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = self.namesTable.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = id[indexPath.row]
        print(state)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddImage")
        appDelegate.idofuser = id[indexPath.row]
        self.present(vc!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    //Delete Data from dataBase and from table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let state = id[indexPath.row]
            print(state)
            
            
            
            Database.database().reference().child("artists").child(id[indexPath.row]).removeValue(completionBlock: { (error, databaseRef) in
                
                
                if error != nil {
                    print("There has been an error:\(error)")
                }
                
            })
            names.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            id.remove(at: indexPath.row)
        }
    }
    
    
    

    
    
    
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
