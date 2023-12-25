
import networkx

def parse_input(input):
    input = input.splitlines()
    connections = set()
    for l in input:
        lh, rh = l.split(": ")
        cons = rh.split(" ")
        for con in cons:
            con = sorted((lh, con))
            connections.add(tuple(con))

    return connections

def solve(input):
    connections = parse_input(input)
    graph = networkx.Graph()
    for con in connections:
        graph.add_edge(*con)

    graph.remove_edges_from(networkx.minimum_edge_cut(graph))
    p = 1
    for subgraph in networkx.connected_components(graph):
        p *= len(subgraph)

    return p


part_1 = solve(open("25.in").read())
print("Part 1:", part_1)