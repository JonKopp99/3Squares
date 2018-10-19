//
//  playVC.swift
//  ThreeSquares
//
//  Created by Jonathan Kopp on 10/1/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import CoreGraphics

class playVC: UIViewController
{
    
    var playButton: UIButton!
    var lBButton: UIButton!
    var daNum = 0.0
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval()
        viewDidLayoutSubviews()
        
    }
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "drawBack" with the interval of 1 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: {_ in self.drawBack()})
    }
    
    //Adds a fading background animation to the play button.
    func drawBack()
    {
        if (daNum >= 1){
            daNum=0.0
        }
        else
        {
            daNum += 0.01
        }
        let color = UIColor(hue: CGFloat(daNum), saturation: 1, brightness: 1, alpha: 1)
        self.playButton.backgroundColor = color
    }
    //Loads the views for textLabels and 2 buttons.
    override func viewDidLayoutSubviews() {
        let label = UILabel(frame: CGRect(x:0, y: 40, width: view.bounds.width, height: 50))
        label.text = "Warning:"
        label.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        label.font = UIFont(name: "AvenirNext-Bold", size: 42.0)
        label.textAlignment = .center
        let label2 = UILabel(frame: CGRect(x:0, y: 90, width: view.bounds.width, height: 50))
        label2.text = "Do not play if"
        label2.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        label2.font = UIFont(name: "AvenirNext-Regular", size: 35.0)
        label2.textAlignment = .center
        let label3 = UILabel(frame: CGRect(x:0, y: 140, width: view.bounds.width, height: 50))
        label3.text = "you have epilepsy."
        label3.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        label3.font = UIFont(name: "AvenirNext-Regular", size: 35.0)
        label3.textAlignment = .center
        self.view.addSubview(label)
        self.view.addSubview(label2)
        self.view.addSubview(label3)
        
        playButton = UIButton(frame: CGRect(x: 10, y: view.bounds.height-310, width: view.bounds.width-20, height: 150))
        playButton.backgroundColor = .green
        playButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 60.0)
        playButton.setTitle("PLAY", for: .normal)
        playButton.addTarget(self, action:#selector(self.playPressed), for: .touchUpInside)
        self.view.addSubview(playButton)
        
        lBButton = UIButton(frame: CGRect(x: 10, y: view.bounds.height-150, width: view.bounds.width-20, height: 80))
        lBButton.backgroundColor = #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
        lBButton.titleLabel?.font = UIFont(name: "AvenirNext-Heavy", size: 35.0)
        lBButton.setTitle("LEADER BOARD", for: .normal)
        lBButton.addTarget(self, action:#selector(self.leaderBoardPressed), for: .touchUpInside)
        self.view.addSubview(lBButton)
        
    }
    //Sends to game
    @objc func playPressed()
    {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GVVC") as UIViewController
        
        self.present(viewController, animated: false, completion: nil)
        }
    //Sends to leaderboard
    @objc func leaderBoardPressed()
    {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LBVC") as! LeaderBoardView
        
        self.present(viewController, animated: false, completion: nil)
    }
    
    
}
