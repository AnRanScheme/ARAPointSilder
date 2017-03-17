//
//  ViewController.swift
//  ARASlider
//
//  Created by 安然 on 17/3/14.
//  Copyright © 2017年 安然. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.bounds.size = CGSize(width: UIScreen.main.bounds.width, height: 40)
        label.textAlignment = .center
        return label
    }()
    
    lazy var numberLabel1: UILabel = {
        let label = UILabel()
        label.bounds.size = CGSize(width: UIScreen.main.bounds.width, height: 40)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let silder = ARAPointSilder()
        silder.bounds = CGRect(x: 0, y: 0, width: 300, height: 80)
        silder.center = view.center
        silder.type = .point
        silder.continuous = false
        silder.pointWidth = 20
        silder.numberOfPoint = 4
        silder.titleAttributes = [NSForegroundColorAttributeName: UIColor.red, NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 18)!]
        silder.titleArray = ["面议","报价","你看你","傻不傻"]
        silder.addTarget(self, action: #selector(printNumber(sender:)), for: .valueChanged)
        view.addSubview(silder)
        
        numberLabel.center = CGPoint(x: UIScreen.main.bounds.width / 2.0,
                                     y: silder.frame.origin.y - 20)
        view.addSubview(numberLabel)
        
        let silder1 = ARAPointSilder()
        silder1.bounds = CGRect(x: 0, y: 0, width: 300, height: 40)
        silder1.center = CGPoint(x: UIScreen.main.bounds.width / 2.0,
                                 y: numberLabel.center.y - 40)
        silder1.type = .normal
        silder1.pointWidth = 20
        silder1.addTarget(self, action: #selector(printNumber(sender:)), for: .valueChanged)
        view.addSubview(silder1)
 
        numberLabel1.center = CGPoint(x: UIScreen.main.bounds.width / 2.0,
                                      y: silder1.frame.origin.y - 20)
        view.addSubview(numberLabel1)
        
        let silder2 = ARAPointSilder()
        silder2.bounds = CGRect(x: 0, y: 0, width: 300, height: 80)
        silder2.center = CGPoint(x: UIScreen.main.bounds.width / 2.0,
                                 y: silder.center.y + 80)
        silder2.titleArray = ["报价","面议"]
        silder2.type = .point
        silder2.pointWidth = 20
        silder2.numberOfPoint = 2
        silder2.thumbImage = UIImage(named: "报价")
        silder2.addTarget(self, action: #selector(changeImage(sender:)), for: .valueChanged)
        view.addSubview(silder2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func printNumber(sender: ARAPointSilder) {
        if sender.type == .point {
            print("样式.point\(sender.index)")
            numberLabel.text = "样式.point\(sender.index)"
        } else {
            print("样式.normal\(sender.value)")
            numberLabel1.text = "样式.normal\(sender.value)"
        }
    }
    
    func changeImage(sender: ARAPointSilder) {
        if sender.type == .point {
            if sender.index == 0 {
                sender.thumbImage = UIImage(named: "报价")
            } else if sender.index == 1 {
                sender.thumbImage = UIImage(named: "面议")
            }
        }
    }

}

