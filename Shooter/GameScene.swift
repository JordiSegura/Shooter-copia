//
//  GameScene.swift
//  Shooter
//
//  Created by Jordi Segura on 25/4/18.
//  Copyright © 2018 Jordi Segura. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
class GameScene: SKScene,SKPhysicsContactDelegate {
    var sonido = try! AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "pop", ofType: "mp3")!) as URL)
    var Mainball = SKSpriteNode()
    var Enemigo = SKSpriteNode()
    var texturaEnemigo = SKTexture()
    var texturaMain = SKTexture()
    var EnemyTimer = Timer()
    var cameraNode: SKCameraNode?
    var gameOver = false
    var labelPuntuacion = SKLabelNode()
    var puntuacion = 0
    
    
    enum tipo:UInt32{
        case prota = 1
        case suelo = 2
        case enemigo = 4
        
    }
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.white
        self.physicsWorld.contactDelegate = self
      
        reiniciar()

        
    }
    
    func reiniciar(){
        EnemyTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.Enemies), userInfo: nil, repeats: true)
        
        ponerPuntuacion()
        crearSuelo()

        crearMainBola()
    }
 
    func ponerPuntuacion(){
        labelPuntuacion.fontName = "Arial"
        labelPuntuacion.fontSize = 80
        labelPuntuacion.fontColor = UIColor.black
        labelPuntuacion.text = "0"
        labelPuntuacion.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 500)
        labelPuntuacion.zPosition = 1
        self.addChild(labelPuntuacion)
    }
    func crearSuelo(){
        
        let suelo = SKNode()
        suelo.position = CGPoint(x: -self.frame.midX, y: -self.frame.height / 2)
        suelo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        suelo.physicsBody!.isDynamic = false
        
        suelo.physicsBody!.categoryBitMask = tipo.prota.rawValue
        suelo.physicsBody!.contactTestBitMask = tipo.prota.rawValue
        
        self.addChild(suelo)

    }
  
    func didBegin(_ contact: SKPhysicsContact) {
        let cuerpoA = contact.bodyA
        let cuerpoB = contact.bodyB
        
        if (cuerpoA.categoryBitMask != tipo.prota.rawValue && cuerpoB.categoryBitMask != tipo.suelo.rawValue || cuerpoA.categoryBitMask != tipo.enemigo.rawValue && cuerpoB.categoryBitMask != tipo.prota.rawValue){
            //sonidoPlayer()
            puntuacion += 1
            sonido.play()
            sonido.numberOfLoops = puntuacion
            labelPuntuacion.text = String(puntuacion)
            
            if puntuacion >= 10000{
                gameOver = true
                self.speed = 1000
                backgroundColor = UIColor.black

                Enemigo.color = UIColor.brown
              EnemyTimer.invalidate()
                //self.childNode(withName: "Enemigo")?.removeFromParent()
                self.removeFromParent()
                Enemigo.physicsBody?.isDynamic = false
                labelPuntuacion.fontColor = UIColor.white
                labelPuntuacion.text = "Has perdido :("
                

            }
            
    
        }
        else {/*SUCK A DIIIIICK*/}
            
        }
    
    func crearMainBola(){
        texturaMain = SKTexture(imageNamed: "Ball")
        Mainball = SKSpriteNode(texture: texturaMain)
        Mainball.size = CGSize (width: 100, height: 100)

        Mainball.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        Mainball.physicsBody = SKPhysicsBody(circleOfRadius: max(texturaMain.size().width / 2, texturaMain.size().width / 2))
        Mainball.physicsBody?.isDynamic = false
        Mainball.physicsBody!.categoryBitMask = tipo.prota.rawValue
        Mainball.physicsBody!.collisionBitMask = 0//tipo.suelo.rawValue
        Mainball.physicsBody!.contactTestBitMask = tipo.suelo.rawValue

        Mainball.zPosition = 0
        self.addChild(Mainball)
    
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches){
                print("FUUCK")
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
            
            cameraNode = SKCameraNode()
            self.addChild(cameraNode!)
            camera = cameraNode
            cameraNode?.position.x = size.width / 2
            cameraNode?.position.y = size.height / 2
            
            Mainball.physicsBody!.isDynamic = true
            Mainball.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            Mainball.physicsBody!.applyImpulse(CGVector(dx: 100, dy: 100))
            print(Mainball.position)
        
            }
}

    @objc func Enemies(){
        texturaEnemigo = SKTexture(imageNamed: "Ball2.png")
        Enemigo = SKSpriteNode(texture: texturaEnemigo)
        Enemigo.physicsBody = SKPhysicsBody(circleOfRadius: max(texturaEnemigo.size().width / 2, texturaEnemigo.size().width / 2))
        Enemigo.physicsBody?.categoryBitMask = tipo.enemigo.rawValue
        Enemigo.physicsBody?.collisionBitMask = 0//tipo.enemigo.rawValue
        Enemigo.physicsBody?.contactTestBitMask = tipo.prota.rawValue
        Enemigo.zPosition = 0
        
        Enemigo.size = CGSize (width: 50, height: 50)
        Enemigo.color = UIColor (red: 0.9, green: 0.1, blue: 0.1, alpha: 1.0)
        Enemigo.physicsBody?.isDynamic = true
        Enemigo.colorBlendFactor = 1.0
       let RandomPosNmbr = arc4random() % 4
        
        switch RandomPosNmbr {
        case 0:
            Enemigo.position.x = 0
            var PositionY = arc4random_uniform(UInt32(frame.size.height))
            Enemigo.position.y = CGFloat (PositionY)
            Mainball.physicsBody!.velocity = CGVector(dx: 200, dy: 200)

            Enemigo.zPosition = 0

            self.addChild(Enemigo)
        break
        
        case 1:
            Enemigo.position.y = 0
            var PositionX = arc4random_uniform(UInt32(frame.size.height))
            Enemigo.position.x = CGFloat (PositionX)
            Mainball.physicsBody!.velocity = CGVector(dx: 200, dy: 200)

            Enemigo.zPosition = 0


            self.addChild(Enemigo)
        break
        case 2:
            Enemigo.position.y = frame.size.height
            var PositionX = arc4random_uniform(UInt32(frame.size.height))
            Enemigo.position.x = CGFloat (PositionX)
            Mainball.physicsBody!.velocity = CGVector(dx: 200, dy: 200)

            Enemigo.zPosition = 0

            self.addChild(Enemigo)
            break
        case 3:
            Enemigo.position.x = frame.size.width
            var PositionY = arc4random_uniform(UInt32(frame.size.height))
            Enemigo.position.y = CGFloat (PositionY)
            Mainball.physicsBody!.velocity = CGVector(dx: 200, dy: 200)

            Enemigo.zPosition = 0


            self.addChild(Enemigo)
            
        break
        
        default:
            break}
      
            
            Enemigo.run(SKAction.move(to: Mainball.position, duration: 3))
       /* var randomX = CGFloat (arc4random_uniform(UInt32(self.frame.maxX)))
        var randomX = CGFloat (arc4random_uniform(UInt32(self.frame.maxX)))

        Enemigo.run(SKAction.moveTo(x: , duration: <#T##TimeInterval#>))*/

        
    }
 
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        cameraNode?.position.x = Mainball.position.x
        
    }
}
