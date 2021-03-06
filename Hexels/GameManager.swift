//
//  GameManager.swift
//  Hexels
//
//  Created by Nick Belzer on 08/02/16.
//  Copyright © 2016 Nick Belzer.
//

import Foundation
import SpriteKit
import Darwin

class GameManager {
  
  var grid: ActiveHexGrid!
  let hexNode: SKNode
  
  var highscore: Int = 0
  let livesLabel: SKLabelNode
  let scoreLabel: SKLabelNode
  let timeLabel: SKLabelNode
  
  var gameRunning = false
  
  var gameLength: Int = 30
  var startTime: CFTimeInterval = 0
  var currentTime: CFTimeInterval = 0
  var timeLeft: Int {
    get {
      return gameLength - Int(currentTime - startTime)
    }
  }
  var lives: Int = 0 {
    didSet {
      checkGameConditions();
    }
  }
  
  private var currentScore = 0
  internal var score: Int {
    get {
      return currentScore
    }
    set {
      currentScore = newValue
      updateLabel()
    }
  }
  
  init(centerNode: SKNode, scene: SKScene) {
    self.hexNode = centerNode
    
    let labelParent = scene.childNodeWithName("LabelParent")! as SKNode;
    labelParent.position.x = scene.size.width/2;
    livesLabel = labelParent.childNodeWithName("Lives") as! SKLabelNode;
    scoreLabel = labelParent.childNodeWithName("Score") as! SKLabelNode;
    timeLabel = labelParent.childNodeWithName("Time") as! SKLabelNode;
  }
  
  func initializeLevel() {
    grid = ActiveHexGrid(gameManager: self, node: hexNode)
    grid.createGrid(Int(2), atNode: hexNode)
  }
  
  func startGame() {
    lives = 3
    score = 0
    startTime = self.currentTime
    gameRunning = true
  }
  
  func endGame() {
    grid.resetAllActives();
    if (currentScore > highscore) {
      highscore = currentScore
    }
    gameRunning = false
    grid.resetGrid()
  }
  
  func updateLabel() {
    livesLabel.text = String(lives);
    scoreLabel.text = String(currentScore);
    timeLabel.text = String(timeLeft);
  }
  
  func checkGameConditions() {
    /* Activate a hex when none are active. */
    if (grid.activeHex == nil) {
      grid.activateHexagon()
    }
    
    if self.startTime == 0 { self.startTime = self.currentTime }
    
    if (self.startTime + CFTimeInterval(gameLength) <= self.currentTime) {
      endGame()
    } else if (lives <= 0) {
      endGame()
    }
  }
  
  func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    self.currentTime = currentTime
    
    if gameRunning {
      checkGameConditions()
      updateLabel()
    }
  }
}
