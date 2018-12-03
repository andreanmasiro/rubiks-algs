extension String {
    var positionToColor: String {
        return self
            .replacingOccurrences(of: "Front", with: "Green")
            .replacingOccurrences(of: "Right", with: "Red")
            .replacingOccurrences(of: "Top", with: "White")
            .replacingOccurrences(of: "Back", with: "Blue")
            .replacingOccurrences(of: "Left", with: "Orange")
            .replacingOccurrences(of: "Bottom", with: "Yellow")
    }
}
