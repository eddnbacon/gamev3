//
//  ViewController.swift
//  Gamev3
//
//  Created by Eduard on 18/04/2018.
//  Copyright © 2018 Eduard. All rights reserved.
//

import UIKit
protocol shipDelegate {
    func changeShipMovement()
}


class ViewController: UIViewController, shipDelegate{
    
    func changeShipMovement(){
        
    }
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var shipImage: ShipMovement!
    @IBOutlet weak var bgImage1: UIImageView!
    @IBOutlet weak var bgImage2: UIImageView!
    
    var timer = Timer()
    var animator:UIDynamicAnimator!
    var gravity:UIGravityBehavior!
    var collision:UICollisionBehavior!
    var itemBehavior:UIDynamicItemBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: self.view)
        hitboxTimer()
        meteorTimer()
        bgAnimation()
        
        shipImage.shipDel = self
      
    
      
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //Background Animation loop
    func bgAnimation(){
        UIView.animate(withDuration: 5, delay:0.0, options:[UIViewAnimationOptions.repeat, .curveLinear], animations: {
            
            self.bgImage1.center.y += self.view.bounds.height
            self.bgImage2.center.y += self.view.bounds.height
            
        })
    }
    
    func meteorTimer(){
        timer = Timer.scheduledTimer(timeInterval:0.85, target: self, selector: #selector(ViewController.meteorFalling),userInfo:nil, repeats: true )
        
    }
    
    func meteorFalling(hitbox:UIImageView){
        
        let num = Int(randomNrGen(firstNum: 1, secondNum: 4))
        
        let meteor = UIImageView()
        let hitbox = hitboxSpawn()
        
        meteor.image = UIImage(named:"Meteor \(num)")
        meteor.frame = CGRect(x:randomNrGen(firstNum: 5, secondNum: 300), y:50, width:50, height: 50)

        self.view.addSubview(meteor)
        gravity = UIGravityBehavior(items: [meteor])
        gravity.magnitude = 0.4
        animator.addBehavior(gravity)
        collision = UICollisionBehavior(items: [meteor])
        animator.addBehavior(collision)
        itemBehavior = UIDynamicItemBehavior(items:[meteor])
        itemBehavior.elasticity = 0.6
        animator.addBehavior(itemBehavior)
        collision.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect:hitbox.frame))
        animator.addBehavior(collision)
        
        
        if(hitbox.frame.intersects(meteor.frame)){
            score.text = "nice"
        }
        
    }
    
    func hitboxTimer(){
        timer = Timer.scheduledTimer(timeInterval:0.1, target: self, selector: #selector(ViewController.hitboxSpawn),userInfo:nil, repeats: true )
        
    }
    
    func hitboxSpawn()->UIImageView{
        let barrier = UIImageView(frame: CGRect(x: shipImage.center.x-40, y: shipImage.center.y-40, width:80, height: 80))
        //barrier.backgroundColor = UIColor.red
        view.addSubview(barrier)
        self.view.bringSubview(toFront: shipImage)
        
        return barrier
//        gravity = UIGravityBehavior(items: [barrier])
//        animator.addBehavior(gravity)
        
        
      
    }
    
    

    func randomNrGen (firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs (firstNum - secondNum) + min(firstNum,secondNum);
    }
    
    
}//end

