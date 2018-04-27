//
//  GameScene.swift
//  Shooter
//
//  Created by Jordi Segura on 25/4/18.
//  Copyright © 2018 Jordi Segura. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let Mainball = SKSpriteNode(imageNamed: "Ball")
    var EnemyTimer = Timer()
    
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.white
        Mainball.size = CGSize (width: 100, height: 100)
        //lo pongo enmedio
        Mainball.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        Mainball.color = UIColor(red: 0.2,green: 0.2, blue: 0.2, alpha: 1.0)
        Mainball.colorBlendFactor = 1.0
        self.addChild(Mainball)
        EnemyTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Selector(("Enemies")), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches){
            let location = touch.location(in: self)
            
            let SmallBall = SKSpriteNode(imageNamed: "Ball")
            SmallBall.position = (Mainball.position)
            SmallBall.size = CGSize(width: 30, height: 30)
            SmallBall.physicsBody = SKPhysicsBody(circleOfRadius: SmallBall.size.width / 2)
            SmallBall.physicsBody?.affectedByGravity = true
            SmallBall.color = UIColor(red: 0.1, green: 0.85, blue: 0.95, alpha: 1.0)
            SmallBall.colorBlendFactor = 1.0

            self.addChild(SmallBall)
            
            var dx = CGFloat (location.x - (Mainball.position.x))
            var dy = CGFloat (location.y-(Mainball.position.y))
            
            let magnitude = sqrt(dx*dx+dy*dy)
            dx /= magnitude
            dy /= magnitude
            let vector = CGVector(dx:16.0 * dy,dy: 16.0 * dy)
            SmallBall.physicsBody?.applyImpulse(vector)
        }
    }
    func Enemies(){
        let Enemy = SKSpriteNode(imageNamed: "Ball")
        Enemy.size = CGSize(width: 20, height: 20)
        Enemy.color = UIColor (red: 0.9, green: 0.1, blue: 0.1, alpha: 1.0)
        Enemy.colorBlendFactor = 1.0
        let RandomPosNmbr = arc4random() % 4
        
        switch RandomPosNmbr {
        case 0:
            Enemy.position.x = 0
            var PositionY = arc4random_uniform(UInt32(frame.size.height))
            Enemy.position.y = CGFloat (PositionY)
            self.addChild(Enemy)
        break
        
        case 1:
            Enemy.position.y = 0
            var PositionX = arc4random_uniform(UInt32(frame.size.height))
            Enemy.position.x = CGFloat (PositionX)
            self.addChild(Enemy)
        break
        case 2:
            Enemy.position.y = frame.size.height
            var PositionX = arc4random_uniform(UInt32(frame.size.height))
            Enemy.position.x = CGFloat (PositionX)
            self.addChild(Enemy)
            break
        case 3:
            Enemy.position.x = frame.size.width
            var PositionY = arc4random_uniform(UInt32(frame.size.height))
            Enemy.position.y = CGFloat (PositionY)
            self.addChild(Enemy)
            
        break
        
        default:
            break}
            
            Enemy.run(SKAction.move(to: Mainball.position, duration: 3))
            
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
