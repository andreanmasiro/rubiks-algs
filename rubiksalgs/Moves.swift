struct Move: Hashable {
    enum Magnitude {
        case clockwise, counterClockwise, half

        var clockwiseTurns: Int {
            switch self {
            case .clockwise: return 1
            case .counterClockwise: return 3
            case .half: return 2
            }
        }
    }

    static let standardSequence = [Move.f, .r, .u, .b, .l, .d] as Set

    let face: Face
    let magnitude: Magnitude
}

enum Algorithm {
    enum OLL {
        static let sune: [Move] = [.r, .u, .rp, .u, .r, .u2, .rp]
    }

    enum PLL {
        static let t: [Move] = [.r, .u, .rp, .up, .rp, .f, .r2, .up, .rp, .up, .r, .u, .rp, .fp]
    }
}

extension Move {
    static func clockwise(_ face: Face) -> Move {
        return Move(face: face, magnitude: .clockwise)
    }

    static func counterClockwise(_ face: Face) -> Move {
        return Move(face: face, magnitude: .counterClockwise)
    }

    static func half(_ face: Face) -> Move {
        return Move(face: face, magnitude: .half)
    }

    static let f = clockwise(.front)
    static let r = clockwise(.right)
    static let u = clockwise(.up)
    static let b = clockwise(.back)
    static let l = clockwise(.left)
    static let d = clockwise(.down)

    static let fp = counterClockwise(.front)
    static let rp = counterClockwise(.right)
    static let up = counterClockwise(.up)
    static let bp = counterClockwise(.back)
    static let lp = counterClockwise(.left)
    static let dp = counterClockwise(.down)

    static let f2 = half(.front)
    static let r2 = half(.right)
    static let u2 = half(.up)
    static let b2 = half(.back)
    static let l2 = half(.left)
    static let d2 = half(.down)
}

enum Face: CaseIterable {
    case front, right, up, back, left, down
}
