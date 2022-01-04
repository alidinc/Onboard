//
//  ErrorMessage.swift
//  goodgames
//
//  Created by Ali Dinç on 17/10/2021.
//

import Foundation

enum RCError: String, Error {
    case invalidQuery = "This query created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data received from the server was invalid. Please try again"
    case unableToFavorite = "There was an error liking this game. Please try again"
    case unableToDetectFace = "Object background removal segmentation will be applied."
    case alreadyInFavorites = "You already liked this game. You must really like it"
}
