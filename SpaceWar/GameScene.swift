//
//  GameScene.swift
//  SpaceWar
//
//  Created by Aleksy Nikolaishvili on 10/5/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let spaceShipCategory: UInt32 = 0x1 << 0
    let asteroidCategory: UInt32 = 0x1 << 1
    var spaceShip: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.8)
        //scene?.size = UIScreen.main.bounds.size
        
        let spaceBackground = SKSpriteNode(imageNamed: "background")
       // spaceBackground.size = CGSize(width: UIScreen.main.bounds.width * 4, height: UIScreen.main.bounds.height * 4)
        spaceBackground.zPosition = -1
        spaceBackground.size =  self.frame.size
        addChild(spaceBackground)
        
        spaceShip = SKSpriteNode(imageNamed: "spaceShip")
        spaceShip.physicsBody = SKPhysicsBody(texture: spaceShip.texture!, size: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = false
        spaceShip.physicsBody?.categoryBitMask = spaceShipCategory
        spaceShip.physicsBody?.collisionBitMask = asteroidCategory
        spaceShip.physicsBody?.contactTestBitMask = asteroidCategory
       // spaceShip.xScale = 2.5
       // spaceShip.yScale = 2.5
        //spaceShip.position = CGPoint(x: 100, y: 100)
        addChild(spaceShip)
        
        let asteroidCreate = SKAction.run {
            let asteroid = self.createAsteroid()
            self.addChild(asteroid)
        }
        
        let asteroidsPerSecond: Double = 2
        
        let asteroidCreationDelay = SKAction.wait(forDuration: 1.0 / asteroidsPerSecond, withRange: 0.5)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreate, asteroidCreationDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction)
        
        run(asteroidRunAction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
           // print(touchLocation)
            
            let distance = distanceCalc(a: spaceShip.position, b: touchLocation)
            let speed: CGFloat = 500
            let time = timeToTravelDistance(to: distance, with: speed)
            
            let moveAction = SKAction.move(to: touchLocation, duration: time)
            spaceShip.run(moveAction)
            
            print("distance: \(distance)","speed: \(speed)", "time: \(time)")
        }
    }
    
    func timeToTravelDistance(to distance: CGFloat,with speed: CGFloat) -> TimeInterval {
        let time = distance / speed
        return TimeInterval(time)
    }
    
    override func update(_ currentTime: TimeInterval) {
       // let asteroid = createAsteroid()
       // addChild(asteroid)
    }
    
    func distanceCalc(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y))
    }
    
    func createAsteroid() -> SKSpriteNode {
        let asteroid = SKSpriteNode(imageNamed: "asteroid")
        
        let randomScale = CGFloat.random(in: 4 ... 6) / 10
        
        asteroid.xScale = randomScale
        asteroid.yScale = randomScale
        
        let halfWidth = size.width / 2
        asteroid.position.x = CGFloat.random(in: -halfWidth ... halfWidth)
        //asteroid.position.x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 16))
        asteroid.position.y = frame.size.height / 2
        
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.size)
        asteroid.name = "asteroid"
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.collisionBitMask = spaceShipCategory
        asteroid.physicsBody?.contactTestBitMask = spaceShipCategory
        
        return asteroid
    }
    
    override func didSimulatePhysics() {
        enumerateChildNodes(withName: "asteroid") { (asteroid, stop) in
            let heightScreen = UIScreen.main.bounds.height
            if asteroid.position.y < -heightScreen {
                asteroid.removeFromParent()
            }
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Contact")
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
}
