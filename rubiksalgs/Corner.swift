struct Corner: Equatable {
    static let allSorted = Position.allCases.map {
        Corner(position: $0, orientation: .oriented)
    }

    enum Position: Int, CaseIterable {
        case topFrontRight, topFrontLeft, topBackLeft, topBackRight
        case bottomFrontLeft, bottomFrontRight, bottomBackRight, bottomBackLeft
    }

    enum Orientation: Int {
        case oriented
        case clockwise
        case counterClockwise

        var clockwiseTurns: Int {
            return rawValue
        }

        enum MutationOffset: Int {
            case none
            case clockwise
            case counterClockwise

            var clockwiseTurns: Int {
                return rawValue
            }
        }

        struct Mutation: Equatable {
            let position: Position
            let offset: MutationOffset

            func sortsBefore(_ mutation: Mutation, inFace face: Face) -> Bool {
                precondition(position.isContained(in: face))
                precondition(mutation.position.isContained(in: face))
                let positions = Position.in(face: face)
                return positions.index(of: position)! <= positions.index(of: mutation.position)!
            }
        }
    }

    let position: Position
    var orientation: Orientation

    func add(_ mutationOffset: Corner.Orientation.MutationOffset) -> Corner {
        return Corner(position: position, orientation: orientation.add(mutationOffset))
    }
}

extension Corner.Position {
    static func `in`(face: Face) -> [Corner.Position] {
        switch face {
        case .front:
            return [topFrontRight, bottomFrontRight, bottomFrontLeft, topFrontLeft]
        case .right:
            return [topFrontRight, topBackRight, bottomBackRight, bottomFrontRight]
        case .up:
            return [topFrontRight, topFrontLeft, topBackLeft, topBackRight]
        case .back:
            return [topBackRight, topBackLeft, bottomBackLeft, bottomBackRight]
        case .left:
            return [topFrontLeft, bottomFrontLeft, bottomBackLeft, topBackLeft]
        case .down:
            return [bottomFrontRight, bottomBackRight, bottomBackLeft, bottomFrontLeft]
        }
    }
}

extension Corner.Position {
    func isContained(in face: Face) -> Bool {
        let contained: Set<Corner.Position>
        switch face {
        case .front: contained = [.topFrontRight, .bottomFrontRight, .bottomFrontLeft, .topFrontLeft]
        case .right: contained = [.topFrontRight, .bottomFrontRight, .bottomFrontLeft, .topFrontLeft]
        case .up: contained = [.topFrontRight, .topFrontLeft, .topBackLeft, .topBackRight]
        case .back: contained = [.topBackRight, .topBackLeft, .bottomBackLeft, .bottomBackRight]
        case .left: contained = [.topFrontLeft, .bottomFrontLeft, .bottomBackLeft, .topBackLeft]
        case .down: contained = [.bottomFrontRight, .bottomBackRight, .bottomBackLeft, .bottomFrontLeft]
        }

        return contained.contains(self)
    }
}

extension Corner.Orientation {
    static func mutations(forMove move: Move) -> [Mutation] {
        typealias MutationOffset = Corner.Orientation.MutationOffset

        let affectedPositions = Corner.Position.in(face: move.face)
        let positionsAndOffsets: Zip2Sequence<[Corner.Position], [MutationOffset]>

        let buildPositionsAndOffsets = { (offsets: [MutationOffset]) in zip(affectedPositions, offsets) }

        switch (move.face, move.magnitude) {
        case (_, .half), (.up, _), (.down, _):
            positionsAndOffsets = buildPositionsAndOffsets(Array(repeating: .none, count: 4))

        case (.right, _), (.back, _):
            positionsAndOffsets = buildPositionsAndOffsets([.counterClockwise,
                                                            .clockwise,
                                                            .counterClockwise,
                                                            .clockwise])
        case (.left, _), (.front, _):
            positionsAndOffsets = buildPositionsAndOffsets([.clockwise,
                                                            .counterClockwise,
                                                            .clockwise,
                                                            .counterClockwise])
        }

        return positionsAndOffsets.map(Mutation.init)
    }

    func add(_ mutationOffset: MutationOffset) -> Corner.Orientation {
        return Corner.Orientation(rawValue: (clockwiseTurns + mutationOffset.clockwiseTurns) % 3)!
    }
}

func <<< (lhs: inout Corner.Orientation, rhs: Corner.Orientation.MutationOffset) {
    lhs = lhs.add(rhs)
}

func <<< (lhs: inout Corner, rhs: Corner.Orientation.MutationOffset) {
    lhs.orientation <<< rhs
}
