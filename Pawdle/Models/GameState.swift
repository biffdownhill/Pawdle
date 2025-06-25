//
//  GameState.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

enum GameState: Equatable {
    case loading
    case playing(GameQuestion)
    case answered(GameQuestion)
    case error(String)
}
