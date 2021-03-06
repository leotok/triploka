//
//  TextMoment.swift
//  triploka
//
//  Created by Victor Souza on 6/1/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class TextMoment: UIView {
    
    var label : UILabel! = nil
    
    override func drawRect(rect: CGRect) {
        
        
        var tap = UITapGestureRecognizer(target: self, action: "new:")
        
        label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        label.text = "Text"
        label.sizeToFit()
        
        //label.alpha = 0
        
        var width = label.frame.width
        var height = label.frame.height
        
        label.frame.origin = CGPoint(x: self.frame.width/2 - width/2, y: self.frame.height/2 - height/2)
        
        label.textColor = UIColor.whiteColor()
        self.addSubview(label)
        
        self.addGestureRecognizer(tap)
        
    }
    
    func new(recognizer: UITapGestureRecognizer) {
        
        println("text")
        NSNotificationCenter.defaultCenter().postNotificationName("TextMoment", object: self)
        
    }
    
    
}
