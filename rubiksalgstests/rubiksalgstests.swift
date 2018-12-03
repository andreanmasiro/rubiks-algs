import XCTest

class rubiksalgstests: XCTestCase {
    func testCornersAllSortedAreAllSorted() {
        let corners = Corner.allSorted

        XCTAssertEqual(corners.map { $0.position.rawValue },
                       Array(0...7))
    }

    func testEdgesAllSortedAreAllSorted() {
        let corners = Edge.allSorted

        XCTAssertEqual(corners.map { $0.position.rawValue },
                       Array(0...11))
    }

    func testIsSolved() {
        let cube = Cube()

        let cornersSolved = { (cube: Cube) in
            return cube.corners.enumerated().reduce(true) { solved, args in
                solved && args.0 == args.1.position.rawValue && args.1.orientation == .oriented
            }
        }

        let edgesSolved = { (cube: Cube) in
            return cube.edges.enumerated().reduce(true) { solved, args in
                solved && args.0 == args.1.position.rawValue && args.1.orientation == .oriented
            }
        }

        XCTAssertEqual(cube.isSolved, cornersSolved(cube) && edgesSolved(cube))

        let unsolvedCube = cube.move(.r)

        XCTAssertEqual(unsolvedCube.isSolved, cornersSolved(unsolvedCube) && edgesSolved(unsolvedCube))
        XCTAssertFalse(unsolvedCube.isSolved)
    }

    func testCubeWhenInitializedIsSolved() {
        XCTAssertTrue(Cube().isSolved)
    }

    func testRotateRotatesCorrectly() {
        let a = [0, 1, 2, 3]

        XCTAssertEqual(a.rotated(times: 1), [3, 0, 1, 2])
        XCTAssertEqual(a.rotated(times: 2), [2, 3, 0, 1])
        XCTAssertEqual(a.rotated(times: 3), [1, 2, 3, 0])
        XCTAssertEqual(a.rotated(times: -1), [1, 2, 3, 0])
        XCTAssertEqual(a.rotated(times: -2), [2, 3, 0, 1])
        XCTAssertEqual(a.rotated(times: -3), [3, 0, 1, 2])
        XCTAssertEqual(a.rotated(times: 4), a)
        XCTAssertEqual(a.rotated(times: 0), a)
        XCTAssertEqual(a.rotated(times: -4), a)
    }

    func testMove() {
        let cube = Cube()

        XCTAssertEqual(cube.move(Algorithm.PLL.t).move(Algorithm.PLL.t), cube)
    }

    func testEdgeMutations() {
        let moves = Move.standardSequence
        let nonFlippinMoves = moves.subtracting([.f, .b])
        let flippinMoves = moves.subtracting(nonFlippinMoves)

        flippinMoves.forEach {
            XCTAssertEqual(
                Edge.Orientation.mutations(forMove: $0).map {
                    $0.offset
                }, Array(repeating: .flip, count: 4)
            )
        }

        nonFlippinMoves.forEach {
            XCTAssertEqual(
                Edge.Orientation.mutations(forMove: $0).map {
                    $0.offset
                }, Array(repeating: .none, count: 4)
            )
        }
    }

    func testCornerMutations() {
        typealias Orientation = Corner.Orientation
        typealias Mutation = Orientation.Mutation
        typealias Position = Corner.Position
        typealias MutationOffset = Orientation.MutationOffset

        let mutationsInFace = { (offsets: [MutationOffset], face: Face) -> [Mutation] in
            return zip(Position.in(face: face), offsets).map(Mutation.init)
        }

        let cc_cMoves = [Move.r, .b, .rp, .bp]
        cc_cMoves.forEach {
            XCTAssertEqual(Orientation.mutations(forMove: $0),
                           mutationsInFace([.counterClockwise,
                                            .clockwise,
                                            .counterClockwise,
                                            .clockwise], $0.face))
        }

        let c_ccMoves = [Move.f, .l, .fp, .lp]
        c_ccMoves.forEach {
            XCTAssertEqual(Orientation.mutations(forMove: $0),
                           mutationsInFace([.clockwise,
                                            .counterClockwise,
                                            .clockwise,
                                            .counterClockwise], $0.face))
        }

        let noneMoves = [Move.u, .up, .d, .dp]
        noneMoves.forEach {
            XCTAssertEqual(Orientation.mutations(forMove: $0),
                           mutationsInFace(Array(repeating: MutationOffset.none, count: 4), $0.face))
        }
    }
}

extension Array {
    func remove(atIndices indices: [Int]) -> [Element] {
        return enumerated().lazy
            .filter { !indices.contains($0.0) }
            .map { $0.1 }
    }
}
