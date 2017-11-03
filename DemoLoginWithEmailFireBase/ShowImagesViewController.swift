//
//  ShowImagesViewController.swift
//  DemoLoginWithEmailFireBase
//
//  Created by Jatin on 04/07/17.
//  Copyright © 2017 iOS-Trainee. All rights reserved.
//

import UIKit
import Firebase

class ShowImagesViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imagesCollection: UICollectionView!
    
    var images = [UIImage]()
    var linksArray = [String:AnyObject]()
    var links = [String]()
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    var idOfUser = String()
    lazy var lazyImage:LazyImage = LazyImage()
    var readData =  DatabaseReference()
    var databaseHandler:DatabaseHandle?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK: -----viewDidLoad-----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.idofuser != ""{
            idOfUser = appDelegate.idofuser
        }
        else{
            idOfUser = ""
        }

        //Get links in Start
        getImageLinks()
        

    }
    
    //MARK: -----get all image Links-----
    func getImageLinks() {
         self.readData = Database.database().reference()
        
        self.databaseHandler = self.readData.child("artists").child(idOfUser).child("imagesLinks").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                self.linksArray = ((snapshot.value) as? [String : AnyObject]!)!
                
                
                if let snapDict = snapshot.value as? [String:AnyObject]{
                    
                    for each in snapDict{
                        //append link one by one
                        let LinksUrl = each.value["Link"] as! String
                        self.links.append(LinksUrl)
                        
                    }
                    //reload collectionView
                    self.imagesCollection.dataSource = self
                    self.imagesCollection.delegate = self
                    self.imagesCollection.reloadData()
                }
            }
            else {
                let alertController = UIAlertController.init(title: "Sorry!", message: "No images Stored in this User", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction.init(title: "Dismiss", style: .destructive, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
            
        })
        
    }
    //MARK: -----viewDidAppear-----
    override func viewDidAppear(_ animated: Bool) {
        if idOfUser == ""
        {
            let alert : UIAlertController = UIAlertController(title: "Error", message: "No user ID Reterived", preferredStyle: .alert)
            let action  = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else
        {
            readData = Database.database().reference().child("artists").child(idOfUser).child("imagesLinks")
        }
        
    }

    //MARK: -----CollectionView Delegates-----
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return links.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imagesCollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    
        let imageView = (cell.viewWithTag(1) as! UIImageView)
        self.lazyImage.showWithSpinner(imageView:imageView, url:links[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: width/3, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return  UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return 0
    }
    
    
    //MARK: -----Button used-----
    @IBOutlet weak var backAction: UIButton!

    
    @IBAction func back(_ sender: Any) {
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
