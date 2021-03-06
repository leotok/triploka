//
//  TestMoment.swift
//  chp3
//
//  Created by Victor Souza on 5/25/15.
//  Copyright (c) 2015 Leonardo Edelman Wajnsztok. All rights reserved.
//

import UIKit

class TestMoment: UIView {
    
    var image: UIImageView = UIImageView()
    var textLabel: UILabel = UILabel()
    var deltaY: CGFloat = 120
    var originalFrame: CGPoint = CGPoint()
    
    var text : TextMoment! = nil
    var audio : AudioMoment! = nil
    var picture : PictureMoment! = nil
    var restaurant : RestaurantMoment! = nil
    
    var move = Bool()
    
    override func drawRect(rect: CGRect) {
        
//        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        originalFrame = self.frame.origin
        var gesture = UILongPressGestureRecognizer(target: self, action: Selector("teste:"))
        self.addGestureRecognizer(gesture)
        
        var width = self.frame.width/2 - 7.5
        
        text = TextMoment(frame: CGRect(x: 5, y: 5, width: width, height: self.frame.height/2 - 7.5))
        audio = AudioMoment(frame: CGRect(x: self.frame.width/2 + 2.5, y: 5, width: width, height: self.frame.height/2 - 7.5))
        picture = PictureMoment(frame: CGRect(x: 5, y: self.frame.height/2 + 2.5, width: width, height: self.frame.height/2 - 7.5))
        restaurant = RestaurantMoment(frame: CGRect(x: self.frame.width/2 + 2.5, y: self.frame.height/2 + 2.5, width: width, height: self.frame.height/2 - 7.5))
        
        self.addSubview(text)
        self.addSubview(picture)
        self.addSubview(audio)
        self.addSubview(restaurant)
        
//        text.textMomentInit()
//        picture.pictureMomentInit()
        
    }
    
    func animate() {
        
        var width = self.frame.width/2 - 7.5
        
        var expandText = CGRect(x: 5, y: 5, width: width, height: self.frame.height/2 - 7.5)
        var expandAudio = CGRect(x: self.frame.width/2 + 2.5, y: 5, width: width, height: self.frame.height/2 - 7.5)
        var expandPicture = CGRect(x: 5, y: self.frame.height/2 + 2.5, width: width, height: self.frame.height/2 - 7.5)
        var expandRestaurant = CGRect(x: self.frame.width/2 + 2.5, y: self.frame.height/2 + 2.5, width: width, height: self.frame.height/2 - 7.5)
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.audio.frame = expandAudio
            self.audio.centerText()
            self.text.frame = expandText
            //self.text.centerText()
            self.picture.frame = expandPicture
            //self.picture.centerText()
            self.restaurant.frame = expandRestaurant
            self.restaurant.centerText()
            
        })
    
        self.image.frame = self.frame
        self.textLabel.frame = self.frame
        self.textLabel.textAlignment = .Center
        self.textLabel.textColor = UIColor.blackColor()
        self.move = false
        
    }
    
    func normalState(type: Int) {
        
        self.audio.removeFromSuperview()
        self.text.removeFromSuperview()
        self.picture.removeFromSuperview()
        self.restaurant.removeFromSuperview()
        
        if type == 0
        {
            self.image.frame.origin.x = self.frame.origin.x - 10
            self.image.frame.origin.y = self.frame.origin.y - 10
            self.addSubview(self.image)
        }
        else if type == 1
        {
            self.textLabel.center = self.center
            self.addSubview(self.textLabel)
        }
        
        self.move = true
        
    }
    
    func teste(recognizer: UILongPressGestureRecognizer) {
        
        if self.move {
            
            if recognizer.state == .Began {
                
                originalFrame = self.frame.origin
                
                UIView.animateWithDuration(0.2, animations: {
                    
                    self.alpha -= 0.3
                    self.superview?.bringSubviewToFront(self)
                    
                })
                
            }
                
            else if recognizer.state == .Changed {
                
                var center = getCenter(self.frame)
                
                var moveByX = recognizer.locationInView(self.superview).x - self.frame.midX
                var moveByY = recognizer.locationInView(self.superview).y - self.frame.midY
                
                self.frame.origin.x += moveByX
                self.frame.origin.y += moveByY
                NSNotificationCenter.defaultCenter().postNotificationName("ScrollNotification", object: self)
                
                
            }
                
            else if recognizer.state == .Ended {
                
                
                NSNotificationCenter.defaultCenter().postNotificationName("ViewHold", object: self)
                self.alpha += 0.3
                
            }
        }
    }
    
    func getCenter(rect: CGRect) -> CGPoint {
        
        return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        
    }
    
}
