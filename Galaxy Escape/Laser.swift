//
//  Laser.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 02/03/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation
import SceneKit

class Laser: SCNNode{
    
    private var aimAt: Meteor!
    
    override init(){
        
        super.init()
        
        let laser = SCNCylinder(radius: 0.2, height: 3.5)
        laser.materials.first?.diffuse.contents = UIColor.red
        let laserNode = SCNNode(geometry: laser)
        self.addChildNode(laserNode)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTarget(target: Meteor){
        aimAt = target
    }
    
    func getTarget() -> Meteor{
        return aimAt
    }
    
    
}
