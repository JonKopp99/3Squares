//
//  LeaderBoardCell.swift
//  ThreeSquares
//
//  Created by Jonathan Kopp on 10/1/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//


import UIKit
import Firebase

class LeaderBoardView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var user = [Users]()
    var button = UIButton()
    var label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        retrieveUsers()
        
        button = UIButton(frame: CGRect(x: 20, y: 35, width: 25, height: 25))
        label = UILabel(frame: CGRect(x:0, y: 0, width: view.bounds.width, height: 100))
        label.text = "Leader Board"
        label.textColor = #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
        label.font = UIFont(name: "AvenirNext-HeavyItalic", size: 30)
        label.textAlignment = .center
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "Image"), for: .normal)
        self.view!.addSubview(label)
        self.view!.addSubview(button)
        tableView.frame = CGRect(x: 0, y: 70,width: view.frame.size.width, height: view.frame.size.height - 50)
        tableView.reloadData()
        
    }
    //Goes back to play Controller
     @objc func buttonAction(sender: UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "playVC")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    //Grabs the top 100 users orderd by score and appends them to user array
    func retrieveUsers()
    {
        let ref = Database.database().reference(withPath: "HighScores")
        let ref2 = ref.queryOrdered(byChild: "score").queryLimited(toFirst: 100)
        ref2.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            let test = snapshot.value as! [String : AnyObject]
            for(_, value) in test {
                var userToShow = Users()
                if let name = value["name"] as? String{
                    
                    userToShow.name = name
                }
                if let score = value["score"] as? Int {
                    
                    userToShow.score = score
                }
                self.user.append(userToShow)
                self.tableView.reloadData()
            }
            self.user.sort(by: { $0.score > $1.score })
        })
        
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    //Adds Users array to cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderBoardCell", for: indexPath) as! LeaderBoardCell
        
        
        cell.scoreLabel.text = String(self.user[indexPath.row].score)
        cell.nameLabel.text = self.user[indexPath.row].name
        cell.nameLabel.font = UIFont(name: "Avenir Next Demi Bold", size: 21)
        cell.nameLabel.sizeToFit()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(user.count==0)
        {
            return 0
        }
        return user.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
//Struct for the users we will be using!
struct Users {
    var name: String!
    var score: Int!
}
