extension Cube: CustomStringConvertible {
    var description: String {
        guard !isSolved else { return "solved!" }

        return """
        topcorners: \(Corner.Position.allCases[..<4].map { corners[$0.rawValue] })
        topedges: \(Edge.Position.allCases[..<4].map { edges[$0.rawValue] })
        middleedges: \(Edge.Position.allCases[4..<8].map { edges[$0.rawValue] })
        botcorners: \(Corner.Position.allCases[4...].map { corners[$0.rawValue] })
        botedges: \(Edge.Position.allCases[8...].map { edges[$0.rawValue] })
        """
    }
}

extension Corner: CustomStringConvertible {
    var description: String {
        return "\(position.colorDescription):\(orientation)"
    }
}

extension Corner.Position: CustomStringConvertible {
    var description: String {
        switch self {
        case .topFrontRight: return "TopFrontRight"
        case .topFrontLeft: return "TopFrontLeft"
        case .topBackLeft: return "TopBackLeft"
        case .topBackRight: return "TopBackRight"
        case .bottomFrontLeft: return "BottomFrontLeft"
        case .bottomFrontRight: return "BottomFrontRight"
        case .bottomBackRight: return "BottomBackRight"
        case .bottomBackLeft: return "BottomBackLeft"
        }
    }

    var colorDescription: String {
        return description.positionToColor
    }
}

extension Corner.Orientation.MutationOffset: CustomStringConvertible {
    var description: String {
        switch self {
        case .none: return "none"
        case .clockwise: return "clockwise"
        case .counterClockwise: return "counter clockwise"
        }
    }
}

extension Corner.Orientation.Mutation: CustomStringConvertible {
    var description: String {
        return "\(position) + \(offset)"
    }
}

extension Edge: CustomStringConvertible {
    var description: String {
        return "\(position.colorDescription):\(orientation)"
    }
}

extension Edge.Position: CustomStringConvertible {
    var description: String {
        switch self {
        case .topFront: return "TopFront"
        case .topLeft: return "TopLeft"
        case .topBack: return "TopBack"
        case .topRight: return "TopRight"
        case .bottomFront: return "BottomFront"
        case .bottomRight: return "BottomRight"
        case .bottomBack: return "BottomBack"
        case .bottomLeft: return "BottomLeft"
        case .frontRight: return "FrontRight"
        case .frontLeft: return "FrontLeft"
        case .backLeft: return "BackLeft"
        case .backRight: return "BackRight"
        }
    }

    var colorDescription: String {
        return description.positionToColor
    }
}

extension Edge.Orientation: CustomStringConvertible {
    var description: String {
        switch self {
        case .oriented: return "oriented"
        case .flipped: return "flipped"
        }
    }
}

extension Edge.Orientation.MutationOffset: CustomStringConvertible {
    var description: String {
        switch self {
        case .none: return "none"
        case .flip: return "flip"
        }
    }
}

extension Edge.Orientation.Mutation: CustomStringConvertible {
    var description: String {
        return "\(position) + \(offset)"
    }
}
