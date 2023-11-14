from typing import Dict, List
from pytest import mark, raises
from .assignment4 import general_neighborhood, is_transitive  # type: ignore
import networkx as nx  # type: ignore


def _generate_graph_from_dict(graph: Dict[int, List[int]]) -> "nx.DiGraph[int]":
    my_graph = nx.DiGraph()
    for vertex in graph:
        my_graph.add_node(vertex)
        for child_vertex in graph[vertex]:
            my_graph.add_node(child_vertex)
            my_graph.add_edge(vertex, child_vertex)
    return my_graph


@mark.parametrize(
    "graph, k, start_vertex, expected",
    [
        ({1: [2, 3], 2: [3, 5], 3: [7], 4: [2],
         5: [8], 6: [1]}, 2, 1, [1, 2, 3, 5, 7]),
        (
            {1: [2, 3], 2: [3, 5], 3: [7], 4: [2], 5: [8], 6: [1]},
            3,
            1,
            [1, 2, 3, 5, 7, 8],
        ),
    ],
)
def test_general_neighborhood(
    graph: Dict[int, List[int]], k: int, start_vertex: int, expected: List[int]
) -> None:
    my_graph = _generate_graph_from_dict(graph)
    assert sorted(general_neighborhood(my_graph, k, start_vertex)) == expected


@mark.parametrize(
    "graph, vertex",
    [({1: [2, 3], 2: [3, 5], 3: [7], 4: [2], 5: [8], 6: [1]}, 9), ({}, 1)],
)
def test_vertex_not_found(graph: Dict[int, List[int]], vertex: int) -> None:
    my_graph = _generate_graph_from_dict(graph)
    with raises(KeyError) as error:
        general_neighborhood(my_graph, 2, vertex)
    assert (
        f'Oops, there is no node with label "{vertex}" in the graph'
        == error.value.args[0]
    )


@mark.parametrize(
    "graph, transitive",
    [
        ({1: [2, 3], 2: [3, 5], 3: [7], 4: [2], 5: [8], 6: [1]}, False),
        ({1: [2, 3, 5, 7, 8], 2: [3, 5, 7, 8], 3: [7], 5: [8]}, True),
    ],
)
def test_is_transitive(graph: Dict[int, List[int]], transitive: bool) -> None:
    my_graph = _generate_graph_from_dict(graph)
    assert is_transitive(my_graph) is transitive


# @mark.parametrize(
#     "graph, transitive",
#     [
#         (
#             {1: [2, 3], 2: [3, 5], 3: [7], 4: [2], 5: [8], 6: [1]},
#             {
#                 1: [2, 3, 5, 7, 8],
#                 2: [3, 5, 7, 8],
#                 3: [7],
#                 4: [2, 3, 5, 7, 8],
#                 5: [8],
#                 6: [1, 2, 3, 5, 7, 8],
#                 7: [],
#                 8: [],
#             },
#         ),
#         (
#             {1: [2], 2: [3], 3: [4], 4: [5]},
#             {1: [2, 3, 4, 5], 2: [3, 4, 5], 3: [4, 5], 4: [5]},
#         ),
#     ],
# )
# def test_transitive_closure(
#     graph: Dict[int, List[int]], transitive: Dict[int, List[int]]
# ) -> None:
#     my_graph = _generate_graph_from_dict(graph)
#     expected_graph = _generate_graph_from_dict(transitive)
#     result_graph = transitive_closure(my_graph)
#     assert result_graph.nodes == expected_graph.nodes
#     assert result_graph.edges == expected_graph.edges
