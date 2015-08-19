//
//  StarFieldEmitter.swift
//  Asteroid Quest
//
//  Created by Matt on 18/08/15.
//  Copyright © 2015 Matthew Brooker. All rights reserved.
//

import Foundation
import SpriteKit

class starFieldEmitter: SKEmitterNode {
    var colour:SKColor?
    var starSpeedY:CGFloat?
    var starsPerSecond: CGFloat?
    var starScaleFactor: CGFloat?
    

    init (imageName: String, colour: SKColor, starSpeedY:CGFloat, starsPerSecond: CGFloat, starScaleFactor:CGFloat) {
        
    // Determine the time a star is visible on screen
  //  let lifetime =  frame.size.height * UIScreen.mainScreen().scale / starSpeedY
        
    super.init()
    self.colour = colour
    self.starSpeedY = starSpeedY
    self.starsPerSecond = starsPerSecond
    self.starScaleFactor = starScaleFactor
    self.particleTexture = SKTexture(imageNamed:imageName)
    self.particleBirthRate = starsPerSecond
    self.particleColor = SKColor.lightGrayColor()
    self.particleSpeed = starSpeedY * -1
    self.particleScale = starScaleFactor
    self.particleColorBlendFactor = 1
//    self.particleLifetime = lifetime
}
    


required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

    


}