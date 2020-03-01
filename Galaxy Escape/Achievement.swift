//
//  Achievement.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 01/03/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation

class Achievement
{
    
    var name: String = ""
    var barrier: Int = 0
    var id: Int = 0
    var progress: Int = 0
    var description: String = ""
    
    init(id:Int, name:String, barrier:Int, progress:Int, description: String)
    {
        self.id = id
        self.name = name
        self.barrier = barrier
        self.progress = progress
        self.description = description
    }
    
}
