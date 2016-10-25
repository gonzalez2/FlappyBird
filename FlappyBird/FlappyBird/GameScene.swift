//  GameScene.swift
//  FlappyBird

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    let birdGroup:UInt32 = 1
    let objectGroup:UInt32 = 2
    var gameOver = 0
    var movingObjects = SKNode()
    
    override func didMoveToView(view: SKView)
    {
        //Begining BackGround Texture
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5) // creates the gravity note: higher y number the faster bird falls
        self.addChild(movingObjects) // this add anothing associated with moving object to do the same thing
        let bgTexture = SKTexture(imageNamed:"imges/bg.png") // variable that gets the background image
       
        let movebg = SKAction.moveByX(-bgTexture.size().width, y:0, duration: 9) // variable that moves the background
        let replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0) // var that replaces the background
        let movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg,replacebg])) // loops movebg and moveForever
        
        
        //loops action to move the background
        for var i:CGFloat=0; i<3; i++ {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y:CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
        
        
            bg.runAction(movebgForever)
            movingObjects.addChild(bg)
        }

        //Beginning Flappy Bird Texture
        let birdTexture = SKTexture(imageNamed:"imges/flappy1.png") // var that take in flappy1 image
        let birdTexture2 = SKTexture(imageNamed:"imges/flappy2.png")// var that take in flappy2 image
        let animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)//var that cycles
        let makeBirdFlap = SKAction.repeatActionForever(animation) //var that repeats animation forever
        bird = SKSpriteNode(texture: birdTexture)// add texture to bird node
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))// make the position of the bird center
        bird.runAction(makeBirdFlap)// run the makeBirdFlap action
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)//make physics dectector around the bird
        bird.physicsBody?.dynamic=true
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdGroup //birdgroup is 1
        bird.physicsBody?.collisionBitMask = objectGroup // objectGroup is 2
        bird.physicsBody?.contactTestBitMask = objectGroup // if it hits object group
        bird.zPosition = 10
        
        self.addChild(bird)// add everything of bird to the scene
        
        
        //Added ground so bird doesnt fall out of screen
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)//botton at botton of screen
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))//contact body for ground
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = objectGroup

        self.addChild(ground)
        
        //calls the func makePipes every 3 seconds
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        
        
    }
    
    //creates pipes
    func makePipes(){
        
        if(gameOver == 0){
        let gapHeight = bird.size.height * 4 // Distance between pipes
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2) // randomly places pipes each round
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4  // ^^^
        
        
        let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))//how fast pipe moves
        
        let removePipe = SKAction.removeFromParent()// deletes pipes out of frame
        let moveAndRemovePipes = SKAction.sequence([movePipes,removePipe])//moves pipes then deletes pipes in that order
        
        let pipe1Texture = SKTexture(imageNamed:"imges/pipe1.png")// add pipe1 sprite
        let pipe1 = SKSpriteNode(texture: pipe1Texture)//stores spite in this variable
        pipe1.position = CGPoint(x:CGRectGetMidX(self.frame) + self.frame.size.width,y:CGRectGetMidY(self.frame) + (pipe1.size.height / 2 + gapHeight / 2 + pipeOffset)) // sets the position of pipe1
        pipe1.runAction(moveAndRemovePipes)//this runs the action
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1.size)//gives pipe1 a physical body for contact
        pipe1.physicsBody?.dynamic = false
        pipe1.zPosition = 5
        pipe1.physicsBody?.categoryBitMask = objectGroup
        movingObjects.addChild(pipe1)//adds everything about pipe1 to the scene
        
        let pipe2Texture = SKTexture(imageNamed:"imges/pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x:CGRectGetMidX(self.frame) + self.frame.size.width,y:CGRectGetMidY(self.frame) - pipe2.size.height / 2 - gapHeight / 2 + pipeOffset)
        pipe2.runAction(moveAndRemovePipes)
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
        pipe2.physicsBody?.dynamic = false
        pipe2.zPosition = 5
        pipe2.physicsBody?.categoryBitMask = objectGroup
        movingObjects.addChild(pipe2)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("Hit")
        gameOver = 0
        //movingObjects.speed = 0
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if(gameOver == 0){
            
           bird.physicsBody?.velocity = CGVectorMake(0, 0)
           bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        }

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
