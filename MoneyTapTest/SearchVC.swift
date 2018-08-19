//
//  SearchVC.swift
//  MoneyTapTest
//
//  Created by Uniqolabel Developer on 19/08/18.
//  Copyright © 2018 GeekGuns. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices
class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SFSafariViewControllerDelegate {
    
    

    @IBOutlet weak var keySearchBar: UISearchBar!
    
    @IBOutlet weak var resultTableView: UITableView!
    
    var pages: NSDictionary = [:]
    var pageArrayResult : NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()

        resultTableView.register(UINib(nibName:"ResultTableCell",bundle: nil), forCellReuseIdentifier: "resultCellId")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageArrayResult.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ResultTableCell = resultTableView.dequeueReusableCell(withIdentifier: "resultCellId") as! ResultTableCell
        
        let dict : NSDictionary = pageArrayResult[indexPath.row] as! NSDictionary
        
        if let pageId : String = dict["pageid"] as? String{
            cell.pageId = pageId
        }
        
        if let termsDict: NSDictionary = dict.value(forKey: "terms") as? NSDictionary {
             let descriptionArray : NSArray = termsDict.value(forKey: "description") as! NSArray//termsDict["description"]
             cell.subTitleLabel.text = descriptionArray[0] as? String//"Gupta"
        }
        
       
    
        if let imageDict : NSDictionary = dict["thumbnail"] as? NSDictionary {
            let source = imageDict["source"] as! String
            cell.resultImageView.sd_setImage(with: URL(string: source ), placeholderImage:nil )
        }
        cell.titleLabel.text = dict["title"] as? String//"Anup"
       
        
        return cell;
        
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//           https://en.wikipedia.org/w/api.php?action=query&prop=info&pageids=18630637&inprop=url
        
        OpenfullDetils(indexPath: indexPath.row)
        
        
    }
    
    // Mark:- Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search Text",searchText)
        
        if searchText.count > 0{
            searchApiCalling(searchText: searchText)
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Yes333")
        self.view.endEditing(true)
    }
    
    
    // Mark:- Api Calling Function
    
    
    
    func searchApiCalling(searchText : String) {

        let param : NSDictionary = [ "action": "query",
                                     "format": "json",
                                     "prop": "pageterms|pageimages",
                                     "generator": "prefixsearch",
                                     "redirects": "1",
                                     "formatversion": "2",
                                     "piprop": "thumbnail",
                                     "pithumbsize" : "50",
                                     "pilimit": "10",
                                     "wbptterms": "description",
                                    "gpssearch": "\(searchText)",
//                                    "gpssearch": "Sachin T",
                                     "gpslimit": "20"
        ]
        
        AlamofireConnectionMangager.getSingleton().getDataFromServer(url: WikiApi.url, param: param, success: { (responseResult)->Void in
//            print(responseResult)
//            print("your result:::",responseResult["query"])
            
            self.pages = responseResult["query"] as! NSDictionary
            
//            print("your result page",self.pages)
            
            self.pageArrayResult = self.pages["pages"] as! NSArray
            print("pageArrayResult",self.pageArrayResult)
            
            self.resultTableView.reloadData()
            
        }, failure: {(err)-> Void in
            print(err!);
            })
        
    }
    
    
    func OpenfullDetils(indexPath : Int){
        
        let dict : NSDictionary = pageArrayResult[indexPath] as! NSDictionary
        
        if let pageId = dict["pageid"] as? Int{
            
            let param : NSDictionary = ["action":"query",
                                        "prop":"info",
                                        "pageids":"\(pageId)",
                                        "inprop":"url",
                                        "format":"json",
                                        "formatversion":"2"
            ]
            
//            https://en.wikipedia.org/w/api.php?action=query&prop=info&pageids=\(pageId)&inprop=url")
            
//            https://en.wikipedia.org/w/api.php?action=query&prop=info&pageids=18630637&inprop=url
            
            
            
            AlamofireConnectionMangager.getSingleton().getDataFromServer(url: WikiApi.openDeatils, param: param, success: { (responseResult)->Void in
                            print(responseResult)
                
                let queryDict : NSDictionary = responseResult["query"] as! NSDictionary
                
                let pageArray : NSArray = queryDict["pages"] as! NSArray
                let pageDict : NSDictionary = pageArray[0] as! NSDictionary
                
                let fullUrl : String = pageDict["fullurl"] as! String
                print("fullUrl",fullUrl)
                self.openSafariVC(fullUrl: fullUrl)
            }, failure: {(err)-> Void in
                print(err!);
            })
           
        }
        else{
            print("no deatils")
        }
        
    }
    func openSafariVC(fullUrl : String){
        
        let safariVC = SFSafariViewController(url: URL(string: fullUrl)!)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//struct searchResultStruct {
//    var
//    <#fields#>
//}
