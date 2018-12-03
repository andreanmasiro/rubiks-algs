struct Cube: Equatable {
    private(set) var corners: [Corner]
    private(set) var edges: [Edge]

    var isSolved: Bool {
        for (i, corner) in corners.enumerated() where i != corner.position.rawValue || corner.orientation != .oriented {
            return false    
        }

        for (i, edge) in edges.enumerated() where i != edge.position.rawValue || edge.orientation != .oriented {
            return false
        }

        return true
    }

    init(corners: [Corner],
         edges: [Edge]) {
        self.corners = corners
        self.edges = edges
    }

    init() {
        self.corners = Corner.allSorted
        self.edges = Edge.allSorted
    }
}

extension Cube {
    subscript(_ position: Corner.Position) -> Corner {
        get {
            return corners[position.rawValue]
        }
        set {
            corners[position.rawValue] = newValue
        }
    }

    subscript(_ position: Edge.Position) -> Edge {
        get {
            return edges[position.rawValue]
        }
        set {
            edges[position.rawValue] = newValue
        }
    }

    func move(_ move: Move) -> Cube {
        var cube = self

        let cornerPositions = Corner.Position.in(face: move.face)
        let edgePositions = Edge.Position.in(face: move.face)

        let newCornerPositions = cornerPositions.rotated(times: move.magnitude.clockwiseTurns)
        let newEdgePositions = edgePositions.rotated(times: move.magnitude.clockwiseTurns)

        let newCorners = newCornerPositions.map { cube[$0] }
        let newEdges = newEdgePositions.map { cube[$0] }

        zip(cornerPositions, newCorners).forEach { cube[$0.0] = $0.1 }
        zip(edgePositions, newEdges).forEach { cube[$0.0] = $0.1 }

        let cornerMutations = Corner.Orientation.mutations(forMove: move)
        let edgeMutations = Edge.Orientation.mutations(forMove: move)

        cornerMutations.forEach {
            cube[$0.position] <<< $0.offset
        }

        edgeMutations.forEach {
            cube.edges[$0.position.rawValue] <<< $0.offset
        }

        return cube
    }

    func move(_ moves: [Move]) -> Cube {
        return moves.reduce(self) {
            $0.move($1)
        }
    }

    func move(_ moves: Move...) -> Cube {
        return move(moves)
    }
}

extension Array {
    func rotated(times: Int) -> [Element] {
        let times = times %% count

        if times == 0 { return self }

        let x = count - times

        return Array(self[x...] + self[..<x])
    }
}

infix operator %%
func %% (lhs: Int, rhs: Int) -> Int {
    if lhs > 0 { return lhs % rhs }
    if lhs == 0 { return 0 }
    return ((lhs % rhs) + rhs) % rhs
}
