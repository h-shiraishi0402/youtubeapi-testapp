//
//  Page1ViewController.swift
//  Youtube
//
//  Created by 白石裕幸 on 2020/12/13.
//

import UIKit
import SegementSlide
import Alamofire
import SwiftyJSON
import SDWebImage

class Page1ViewController: UITableViewController, SegementSlideContentScrollViewDelegate {
    
    var youtubeData = YoutubeData()
    var videoIdArray = [String]()
    var publishedAtArray = [String]()
    var titleArray = [String]()
    var imageURLStringArray = [String]()
    var youtubeURLArray = [String]()
    var channelTitleArray = [String]()
    
    let refresh = UIRefreshControl()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        tableView.refreshControl = refresh
        
        refresh.addTarget(self, action: #selector(update), for: .valueChanged)
        
        getData()
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    

    @objc var scrollView: UIScrollView{
        
        
        return tableView
        
        
    }

    @objc func update(){
        getData()
        tableView.reloadData()
        refresh.endRefreshing()
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titleArray.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        //ハイライトを消す
        cell.selectionStyle = .none
        
        
        let profileImageURL = URL(string: self.imageURLStringArray[indexPath.row] as String)!
        
        cell.imageView?.sd_setImage(with: profileImageURL , completed: { (image, error, _, _) in
            if error == nil{
                cell.setNeedsLayout()
            }
        })
        
        
        //cell.imageView?.sd_setImage(with: profileImageURL, completed: nil)
        cell.textLabel?.text = self.titleArray[indexPath.row]
       // cell.detailTextLabel?.text = self.publishedAtArray[indexPath.row]
        //文字を収める
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        
        cell.textLabel?.numberOfLines = 5
        cell.detailTextLabel?.numberOfLines = 5
        
        
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let indexNumber = indexPath.row
        let webviewController = WebViewController()
        let url = youtubeURLArray[indexNumber]
        
        UserDefaults.standard.set(url, forKey: "url")
        
        present(webviewController, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/5
    }

    
    func getData(){
       
        let text = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyA_XlXfP3DkcnhMnSnUhqPm9LwO9w5C-ww&q=AYA a.k.a. PANDA&part=snippet&maxResults=40&order=date"
        
        //日本語のままだとAlmoFireなどでエラーになるから、その解消のため
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        //リクエストを送
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {(respond) in
            
            //JSON解析
            print(respond.debugDescription)
            
            
            switch respond.result{
            
            //40の値が返ってくるからFordemawasu
            case .success :
                for i in 0...100{
                    
                    let json:JSON = JSON(respond.data as Any)
                    
                    if json["items"][i]["id"]["videoId"].string != nil && json["items"][i]["snippet"]["title"].string != nil {
                    let videoId = json["items"][i]["id"]["videoId"].string
                    
                    
                    //let publishedAt = json["items"][i]["snippet"]["publishedAt"].string
                    let title = json["items"][i]["snippet"]["title"].string
                    let imageURLString = json["items"][i]["snippet"]["thumbnails"]["default"]["url"].string
                    let youtubeURL = "https://www.youtube.com/watch?v=\(videoId!)"
                    let channelTitle = json["items"][i]["snippet"]["channelTitle"].string
                    
                    
                    //ローカルで宣言した配列に値を入れる
                    self.videoIdArray.append(videoId!)
                    //self.publishedAtArray.append(publishedAt!)
                    self.titleArray.append(title!)
                    self.imageURLStringArray.append(imageURLString!)
                    self.channelTitleArray.append(channelTitle!)
                    self.youtubeURLArray.append(youtubeURL)
                    
                    }
                    
                }
                break
                
            case .failure(let error):
                print(error)
                break
            }
            self.tableView.reloadData()
            
            
            
        }
       
        
        
    }
    
    
}
