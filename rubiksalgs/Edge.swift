struct Edge: Equatable {
    static let allSorted = Position.allCases.map {
        Edge(position: $0, orientation: .oriented)
    }

    enum Position: Int, Hashable, CaseIterable {
        case topFront, topLeft, topBack, topRight
        case frontRight, frontLeft, backLeft, backRight
        case bottomFront, bottomRight, bottomBack, bottomLeft
    }

    enum Orientation: Int, Hashable {
        case oriented
        case flipped

        var flips: Int {
            return rawValue
        }

        static func + (lhs: Orientation, rhs: Orientation) -> Orientation {
            return lhs == rhs ? .oriented : .flipped
        }

        enum MutationOffset: Int {
            case none
            case flip

            var flips: Int {
                return rawValue
            }
        }

        struct Mutation: Equatable {
            let position: Position
            let offset: MutationOffset
        }
    }

    let position: Position
    var orientation: Orientation

    func add(_ mutationOffset: Orientation.MutationOffset) -> Edge {
        return Edge(position: position, orientation: orientation.add(mutationOffset))
    }
}

extension Edge.Position {
    static func `in`(face: Face) -> [Edge.Position] {
        switch face {
        case .front:
            return [topFront, frontRight, bottomFront, frontLeft]
        case .right:
            return [frontRight, topRight, backRight, bottomRight]
        case .up:
            return [topFront, topLeft, topBack, topRight]
        case .back:
            return [topBack, backLeft, bottomBack, backRight]
        case .left:
            return [frontLeft, bottomLeft, backLeft, topLeft]
        case .down:
            return [bottomFront, bottomLeft, bottomBack, bottomRight]
        }
    }
}

extension Edge.Orientation {
    static func mutations(forMove move: Move) -> [Mutation] {
        typealias MutationOffset = Edge.Orientation.MutationOffset

        let affectedPositions = Edge.Position.in(face: move.face)
        let positionsAndOffsets: Zip2Sequence<[Edge.Position], [MutationOffset]>

        let result = { (mutation: MutationOffset) in
            zip(affectedPositions, Array(repeating: mutation, count: affectedPositions.count))
        }

        switch (move.face, move.magnitude) {
        case (_, .half): positionsAndOffsets = result(MutationOffset.none)
        case (.front, _), (.back, _): positionsAndOffsets = result(MutationOffset.flip)
        default: positionsAndOffsets = result(MutationOffset.none)
        }

        return positionsAndOffsets.map(Mutation.init)
    }

    func add(_ mutationOffset: MutationOffset) -> Edge.Orientation {
        return Edge.Orientation(rawValue: (flips + mutationOffset.flips) % 2)!
    }
}

infix operator <<<
func <<< (lhs: inout Edge.Orientation, rhs: Edge.Orientation.MutationOffset) {
    lhs = lhs.add(rhs)
}

func <<< (lhs: inout Edge, rhs: Edge.Orientation.MutationOffset) {
    lhs.orientation <<< rhs
}
