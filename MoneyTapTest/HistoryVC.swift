//
//  HistoryVC.swift
//  MoneyTapTest
//
//  Created by Uniqolabel Developer on 19/08/18.
//  Copyright © 2018 GeekGuns. All rights reserved.
//

import UIKit
import SafariServices
import CoreData
class HistoryVC: UIViewController , SFSafariViewControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var historyTable: UITableView!
     var coreDataManagedObj: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
            historyTable.register(UINib(nibName:"ResultTableCell",bundle: nil), forCellReuseIdentifier: "resultCellId")
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getDataFromCoreData()
    }
    
    func getDataFromCoreData()  {
       coreDataManagedObj = SaveCoreDataDetails.getSingleton().getDataFromCoreData()
        
        if coreDataManagedObj.count > 0 {
//            historyTable.reloadData()
        }
        else{
//             historyTable.reloadData()
        }
         historyTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManagedObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell : ResultTableCell = historyTable.dequeueReusableCell(withIdentifier: "resultCellId") as! ResultTableCell
        let dict =  coreDataManagedObj[indexPath.row]

        cell.titleLabel.text = dict.value(forKey: "title") as? String
        cell.subTitleLabel.text = dict.value(forKey: "subTitle") as? String
        
        let imgUrl : String = dict.value(forKey: "imgUrl") as! String
        cell.resultImageView.sd_setImage(with: URL(string: imgUrl ), placeholderImage:nil )

       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let dict =  coreDataManagedObj[indexPath.row]
        let url : String = dict.value(forKey: "pageUrl") as! String
        openSafariVC(fullUrl: url)
    }

   
    
    func openSafariVC(fullUrl : String){
        
        let safariVC = SFSafariViewController(url: URL(string: fullUrl)!)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
  
    @IBAction func deleteAllHIstoryButtonAction(_ sender: Any) {
        showDeleteAlert(deleteAlertMessage : "Are you sure to delete all History data")
    }
    
    func showDeleteAlert(deleteAlertMessage : String){
        
        let deleteAlertTitle = "Money Tap"
        let alertController = UIAlertController(title: deleteAlertTitle, message: deleteAlertMessage, preferredStyle: .alert)
        
        let deleteButtonAction = UIAlertAction(title: "Delete All", style: .destructive, handler: {
            alert -> Void in
            
            let isDeleted =  SaveCoreDataDetails.getSingleton().deleteAllSaveDataFromCoreData()
            if isDeleted {
                print("Success")
                self.getDataFromCoreData()
//                self.historyTable.reloadData()
            }
            else{
                print("failed")
                
            }
        })
        
        let cancelButton =  UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(cancelButton)
        alertController.addAction(deleteButtonAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}

