//
//  UserProgress.swift
//  pocketWords
//
//  Created by Mohammad on 5/13/25.
//

import Foundation
import SwiftData

@Model
final class UserProgress {
    @Attribute(.unique) var id: UUID
    var xp: Int

    init(id: UUID = UUID(), xp: Int = 0) {
        self.id = id
        self.xp = xp
    }
}
