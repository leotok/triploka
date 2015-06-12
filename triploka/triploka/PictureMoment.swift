//
//  PictureMoment.swift
//  triploka
//
//  Created by Victor Souza on 6/1/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class PictureMoment: UIView {
    
    var label : UILabel
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        
        label = UILabel(frame: frame)
        label.text = "Picture"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor()
        var tap = UITapGestureRecognizer(target: self, action: "new:")
        self.addGestureRecognizer(tap)
        self.addSubview(label)
    }
    
    func new(recognizer: UITapGestureRecognizer) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("PictureMoment", object: self)
        
    }
}
