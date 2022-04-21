//
//  Appearance.swift
//  NPCGen5e
//
//  Created by Michael Craun on 3/19/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

class Appearance {
    private struct Body {
        private var heights: [String] {
            return [
                "very short",
                "a little shorter than average",
                "of average height",
                "a little taller than average",
                "very tall"
            ]
        }
        private var types: [String] {
            return [
                "unhealthily skinny",
                "slightly skinnier than average",
                "average in build",
                "slightly muscular than average",
                "very muscular"
            ]
        }
        var description: String {
            let height = randomItem(in: heights)
            let type = randomItem(in: types)
            return "is \(height) and \(type)"
        }
    }
    private struct Eyes {
        private var isBlind: Bool {
            return Bool.random()
        }
        private var colors: [String] {
            return [
                "blue",
                "brown",
                "cyan",
                "golden",
                "green",
                "red"
            ]
        }
        private var intensities: [String] {
            return [
                "bright",
                "dull",
                "pale"
            ]
        }
        var description: String {
            let color = randomItem(in: colors)
            let intensity = randomItem(in: intensities)
            return isBlind ? "is blind" : "with \(intensity) \(color) eyes"
        }
    }
    private struct Face {
        private var features: [String] {
            return [
                "average",
                "diamond-shaped",
                "heart-shaped",
                "oval",
                "round",
                "square"
            ]
        }
        private var sizes: [String] {
            return [
                "short",
                "average",
                "long"
            ]
        }
        var description: String {
            let feature = randomItem(in: features)
            let size = randomItem(in: sizes)
            return "has a \(size) \(feature) face"
        }
    }
    private struct Hair {
        private var isBald: Bool {
            return Bool.random()
        }
        private var colors: [String] {
            return [
                "auburn",
                "black",
                "blonde",
                "blue",
                "brown",
                "gray",
                "pink",
                "red",
                "white"
            ]
        }
        private var features: [String] {
            return [
                "braided",
                "curly",
                "ponytailed",
                "straight",
                "wavy"
            ]
        }
        private var lengths: [String] {
            return [
                "cropped",
                "chin-length",
                "medium",
                "shoulder-length",
                "elbow-length",
                "mid-back length",
                "waist-length"
            ]
        }
        var description: String {
            let color = randomItem(in: colors)
            let feature = randomItem(in: features)
            let length = randomItem(in: lengths)
            return isBald ? "is also bald" : "has \(length), \(feature), \(color) hair"
        }
    }
    private struct Skin {
        private var colors: [String] {
            return [
                "brown",
                "gray",
                "pale",
                "pink",
                "tan"
            ]
        }
        private var types: [String] {
            return [
                "rough",
                "silky",
                "smooth",
                "soft",
                "sunburned"
            ]
        }
        var description: String {
            let color = randomItem(in: colors)
            let type = randomItem(in: types)
            return "with \(type) \(color) skin"
        }
    }
    
    private var npc: NPC
    
    /// A textual representation of the Appearance object.
    var description: String {
        let body = Body().description
        let eyes = Eyes().description
        let face = Face().description
        let hair = Hair().description
        let skin = Skin().description
        return "$shortName \(body) \(skin). $capsPronoun \(face) \(eyes). $name \(hair).".replacingPlaceholders(with: npc)
    }
    
    /// The default initializer for the Appearance object.
    /// - Parameter npc: The NPC object the Appearance object is being constructed for.
    init(npc: NPC) {
        self.npc = npc
    }
}
