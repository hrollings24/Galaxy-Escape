//
//  Terrain.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 10/02/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class Terrain{
    
    var terrainNode: SCNNode
    var xSize: Int
    var zSize: Int
    var vertices: [SCNVector3]

    init(){
        
        //let verticesSize = (xSize + 1) * (zSize + 1)
        
        vertices = [SCNVector3]()
        xSize = 600
        zSize = 272
        
        terrainNode = SCNNode()
        terrainNode = createVertices()
        
    }
    
    func createVertices() -> SCNNode{
                    
        var i = 0
        for z in 0 ..< zSize + 1 {
           for x in 0 ..< xSize + 1 {
            vertices.append(SCNVector3(x, 0, z))
               i += 1
           }
        }
        
        var triangles = [UInt32]()
        var vert = UInt32(0)
        var tris = UInt32(0)
        
        for z in 0 ..< zSize {
            for x in 0 ..< xSize {
                triangles.append(vert + 0)
                triangles.append(vert + UInt32(xSize) + 1)
                triangles.append(vert + 1)
                triangles.append(vert + 1)
                triangles.append(vert + UInt32(xSize) + 1)
                triangles.append(vert + UInt32(xSize) + 2)
                vert += 1
                tris += 6
            }
            vert += 1
        }
        
      
    
        let source = SCNGeometrySource(vertices: vertices)
        
        let element = SCNGeometryElement(indices: triangles, primitiveType: .triangles)
        let geometry = SCNGeometry(sources: [source], elements: [element])
        
        let material = SCNMaterial()
        material.emission.contents = UIColor.white
        //material.emission.contents = UIImage(named: "rock")
        material.isLitPerPixel = true

        geometry.firstMaterial = material
        geometry.firstMaterial!.isDoubleSided = true
        
        let node = SCNNode(geometry: geometry)

        return node
         
    }
    
    func createNoiseMap() -> GKNoiseMap {
        //Get our noise source, this can be customized further
        let source = GKPerlinNoiseSource()
        //source.persistence = 0.9

        //Initalize our GKNoise object with our source
        let noise = GKNoise.init(source)
        //Create our map
        let sampleCount = vector2(Int32(zSize), Int32(xSize))

        let map = GKNoiseMap.init(noise, size: vector2(10.0, 10.0), origin: vector2(0, 0), sampleCount: sampleCount, seamless: true)
        return map
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
