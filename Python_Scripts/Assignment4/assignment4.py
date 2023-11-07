"""
author: Harvey Okotie
studentnumber: 2262068

"""

from typing import List, Union
import networkx as nx  # type: ignore


# helper function
def _get_general_neighborhood(graph: "nx.DiGraph[int]", maximum_depth: int,
                              current_node: int, neighbors=None,
                              depth: int = 0) -> List[int]:
    """
    A helper function to check and get all the neighbors around the specified
    node. Where the depth value of the node is less than the maximum depth
    (i.e doesn't go beyond the maximum depth).

    Arg:
        graph: A networkx.DiGraph object.
        maximum_depth: Maximum number of neighborhood nodes.
        current_node: Integer representing the current node.
        depth: The depth of the current node from the initial node.

    Returns:
        Sorted list of all neighbors.
    """
    if neighbors is None:
        neighbors = []

    if depth > maximum_depth:
        return neighbors

    if current_node not in neighbors:
        neighbors.append(current_node)

    for vertex in graph[current_node]:
        _get_general_neighborhood(
            graph, maximum_depth, vertex, neighbors, depth + 1)

    return sorted(neighbors)


# main function
def general_neighborhood(graph: "nx.DiGraph[int]", maximum_depth: int,
                         start_node: int) -> Union[List[int], None]:
    """
    This function returns the list of all nodes from the beginning of the node
    to the final node in the graph such that there is a path from the start_node
    to the final node as long as it doesn't go beyond the maximum depth.

    Arg:
        graph: A networkx.DiGraph object.
        maximum_depth: Maximum number of neighborhood nodes.
        start_node: Integer representing the node to begin.

    Returns:
        Sorted list of all neighbors.
    """

    if start_node is not None and start_node not in graph.nodes:
        raise KeyError(
            f'Oops, there is no node with label "{start_node}" in the graph')

    elif graph.has_node(start_node):
        return _get_general_neighborhood(graph, maximum_depth, start_node)


def is_transitive(G: "nx.DiGraph[int]") -> "nx.DiGraph[int]":
    """
    This function checks whether a given graph (G) is transitive or not.
    A directed graph is transitive if and only if for every two edges (x,y)
    and (y,z), therefore (x,z) must exist.

    Args:
        G: A networkx.DiGraph object

    Returns:
        True: the graph is transitive.
        False: the graph is not transitive.
    """

    for node1 in G:
        for node2 in G[node1]:
            if node2 in G:
                for node3 in G[node2]:
                    if node3 not in G[node1]:
                        return False
    return True


def transitive_closure(G: "nx.DiGraph[int]") -> "nx.DiGraph[int]":
    """
    This function accepts an object of networkx.DiGraph and returns the smallest transitive
    graph containing G. It will construct new edges if certain condition(s) is/are observed.
    If there exist a relationship between node1 and node2 such that node2 and node3 exist,
    therefore it constructs a new edge for node1 and node3.

    Args:
        G: A networkx.DiGraph object

    Returns:
        G: The transitive closure of graph G
    """

    for node1 in G:
        for node2 in G:
            for node3 in G:
                if node2 in G[node1] and node3 in G[node2]:
                    if node3 not in G[node1]:
                        G.add_edge(node1, node3)
    return G
