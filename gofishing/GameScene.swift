//
//  GameScene.swift
//  gofishing
//
//  Created by Placoderm on 7/7/17.
//  Copyright © 2017 Placoderm. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    let manager = CMMotionManager()
    var hook = SKSpriteNode()
    var TextureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()
    
    var outer_circle = SKSpriteNode()
    var fish1: SKSpriteNode? = SKSpriteNode()
    var fish2: SKSpriteNode? = SKSpriteNode()
    var fish3: SKSpriteNode? = SKSpriteNode()
    
    var fish1_path = UIBezierPath()
    var fish2_path = UIBezierPath()
    var fish3_path = UIBezierPath()
    
    var fish_radius = CGFloat(112)
    var fish_speed = CGFloat(100)
    
    var game_score = 0
    var score_node = SKLabelNode()
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        //fishhook
        hook = (self.childNode(withName: "hook") as? SKSpriteNode!)!
        
        hook.zPosition = CGFloat(0)
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdates(to: OperationQueue.main) {
            (data, error) in
            
            self.physicsWorld.gravity = CGVector(dx: CGFloat((data?.acceleration.y)!) * -10, dy: CGFloat((data?.acceleration.x)!) * 20)
        }
        
        //circle
        outer_circle = SKSpriteNode(imageNamed: "circle")
        outer_circle.size = CGSize(width: 310, height: 300)
        outer_circle.position = CGPoint(x: CGFloat(0) , y: CGFloat(0))
        outer_circle.zPosition = CGFloat(-1)
            //self.outer_circle.position = CGPoint(x: self.view!.center.x, y: self.view!.center.y)
        self.addChild(outer_circle)
        
        //fish1
        TextureAtlas = SKTextureAtlas(named: "fish")
        for i in 0...1 {
            let name = "fish\(i+1).png"
            TextureArray.append(SKTexture(imageNamed: name))
        }
        fish1 = SKSpriteNode(imageNamed: self.TextureAtlas.textureNames[0])
        fish1?.name = "fish1"
        fish1?.size = CGSize(width: 50, height: 50)
        fish1?.position = CGPoint(x: CGFloat(0) , y: (CGFloat(0)+fish_radius))
        fish1?.zPosition = CGFloat(0)
        self.addChild(fish1!)
        fish1?.run(SKAction.repeatForever(SKAction.animate(withNormalTextures: self.TextureArray, timePerFrame: 0.1)))
        
        //fish2
        fish2 = SKSpriteNode(imageNamed: self.TextureAtlas.textureNames[1])
        fish2?.name = "fish2"
        fish2?.size = CGSize(width: 50, height: 50)
        fish2?.position = CGPoint(x: CGFloat(0)-55 , y: (CGFloat(0)-84))
        fish2?.zPosition = CGFloat(0)
        self.addChild(fish2!)
        fish2?.run(SKAction.repeatForever(SKAction.animate(withNormalTextures: self.TextureArray, timePerFrame: 0.1)))
        
        //fish3
        fish3 = SKSpriteNode(imageNamed: self.TextureAtlas.textureNames[1])
        fish3?.name = "fish2"
        fish3?.size = CGSize(width: 50, height: 50)
        fish3?.position = CGPoint(x: CGFloat(0)+55 , y: (CGFloat(0)-84))
        fish3?.zPosition = CGFloat(0)
        self.addChild(fish3!)
        fish3?.run(SKAction.repeatForever(SKAction.animate(withNormalTextures: self.TextureArray, timePerFrame: 0.1)))
        
        moveClockWise()
        
        //score
        self.score_node = createScoreNode(game_score: self.game_score)
        self.addChild(score_node)
    }
    
    override func update(_ currentTime: TimeInterval) {
        //check for fishook collision with fish
        
        if let fish = fish1 {
            if hook.intersects(fish) {
                print("oh my god")
                fish.removeFromParent()
                self.fish1 = nil
                game_score += 10
                score_node.text = "Score: \(game_score)"
            }
        }
        
        if let fish = fish2 {
            if hook.intersects(fish) {
                print("oh my god")
                fish.removeFromParent()
                self.fish2 = nil
                game_score += 10
                score_node.text = "Score: \(game_score)"
            }
        }
        
        if let fish = fish3 {
            if hook.intersects(fish) {
                print("oh my god")
                fish.removeFromParent()
                self.fish3 = nil
                game_score += 10
                score_node.text = "Score: \(game_score)"
            }
        }
    }
    
    //create scoreboard
    func createScoreNode(game_score: Int) -> SKLabelNode {
        let scoreNode = SKLabelNode(fontNamed: "Arial")
        scoreNode.name = "scoreNode"
        scoreNode.text = "Score: \(game_score)"
        scoreNode.fontSize = 31
        scoreNode.fontColor = SKColor.black
        scoreNode.position = CGPoint(x: CGFloat(0), y: CGFloat(0))
        scoreNode.zPosition = CGFloat(1)
        
        return scoreNode
    }
    //add to score
    func addToScore() {
        self.game_score += 10
        self.score_node.text = "Score: \(self.game_score)"
    }
    
    func moveClockWise() {
        
        //fish1 motion
        let dx1 = fish1?.position.x
        let dy1 = fish1?.position.y
        var rad1: CGFloat?
        var follow1: SKAction?
        
        if let y = dy1 {
            if let x = dx1 {
                rad1 = atan2(y, x)
            }
        }
        if let rad = rad1 {
            self.fish1_path = UIBezierPath(arcCenter: CGPoint(x: CGFloat(0) , y: CGFloat(0)), radius: self.fish_radius, startAngle: rad, endAngle: rad + CGFloat(Double.pi * 4), clockwise: true)
            follow1 = SKAction.follow(self.fish1_path.cgPath, asOffset: false, orientToPath: true, speed: self.fish_speed)
        }
        if let follow = follow1 {
            fish1?.run(SKAction.repeatForever(follow).reversed())
        }
        
        //fish2 motion
        let dx2 = fish2?.position.x
        let dy2 = fish2?.position.y
        var rad2: CGFloat?
        var follow2: SKAction?
        
        if let y = dy2 {
            if let x = dx2 {
                rad2 = atan2(y, x)
            }
        }
        if let rad = rad2 {
            self.fish2_path = UIBezierPath(arcCenter: CGPoint(x: CGFloat(0) , y: CGFloat(0)), radius: self.fish_radius, startAngle: rad, endAngle: rad + CGFloat(Double.pi * 4), clockwise: true)
            follow2 = SKAction.follow(self.fish2_path.cgPath, asOffset: false, orientToPath: true, speed: self.fish_speed)
        }
        if let follow = follow2 {
            fish2?.run(SKAction.repeatForever(follow).reversed())
        }
        
        //fish3 motion
        let dx3 = fish3?.position.x
        let dy3 = fish3?.position.y
        var rad3: CGFloat?
        var follow3: SKAction?
        
        if let y = dy3 {
            if let x = dx3 {
                rad3 = atan2(y, x)
            }
        }
        if let rad = rad3 {
            self.fish3_path = UIBezierPath(arcCenter: CGPoint(x: CGFloat(0) , y: CGFloat(0)), radius: self.fish_radius, startAngle: rad, endAngle: rad + CGFloat(Double.pi * 4), clockwise: true)
            follow3 = SKAction.follow(self.fish3_path.cgPath, asOffset: false, orientToPath: true, speed: self.fish_speed)
        }
        if let follow = follow3 {
            fish3?.run(SKAction.repeatForever(follow).reversed())
        }
    }
    
    //func moveCounterClockWise() {
        //fish1 motion
        //let dx1 = fish1.position.x
        //let dy1 = fish1.position.y
        
        //let rad1 = atan2(dy1, dx1)
        
        //self.fish1_path = UIBezierPath(arcCenter: CGPoint(x: CGFloat(0) , y: CGFloat(0)), radius: self.fish_radius, startAngle: rad1, endAngle: rad1 + CGFloat(Double.pi * 4), clockwise: true)
        //let follow1 = SKAction.follow(self.fish1_path.cgPath, asOffset: false, orientToPath: true, speed: self.fish_speed)
        
        //fish1.run(SKAction.repeatForever(follow1))
    //}
    
    //func touchDown(atPoint pos : CGPoint) {
    //    if let n = self.spinnyNode?.copy() as! SKShapeNode? {
    //        n.position = pos
    //        n.strokeColor = SKColor.green
    //        self.addChild(n)
    //    }
   // }
    
    //func touchMoved(toPoint pos : CGPoint) {
    //    if let n = self.spinnyNode?.copy() as! SKShapeNode? {
    //        n.position = pos
    //        n.strokeColor = SKColor.blue
     //       self.addChild(n)
     //   }
   // }
    
   // func touchUp(atPoint pos : CGPoint) {
    //    if let n = self.spinnyNode?.copy() as! SKShapeNode? {
    //        n.position = pos
    //        n.strokeColor = SKColor.red
    //        self.addChild(n)
    //    }
   // }
    
    //override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  if let label = self.label {
        //    label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
    //    }
      //
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    //}
    
    //override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
   // }
    
    //override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
   // }
    
    //override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    //    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
   // }
}
