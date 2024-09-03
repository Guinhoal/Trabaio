import java.util.*;

class PriorityQueue {
    private List<Node> values;

    PriorityQueue() {
        values = new ArrayList<>();
    }

    void enqueue(String val, int priority) {
        values.add(new Node(val, priority));
        sort();
    }

    Node dequeue() {
        return values.remove(0);
    }

    void sort() {
        Collections.sort(values, new Comparator<Node>() {
            public int compare(Node a, Node b) {
                return a.priority - b.priority;
            }
        });
    }
    
    class Node {
        String val;
        int priority;

        Node(String val, int priority) {
            this.val = val;
            this.priority = priority;
        }
    }
}

class Graph {
    private HashMap<String, List<Edge>> adjacencyList;
    private HashMap<String, Integer> vertexWeight;

    Graph() {
        adjacencyList = new HashMap<>();
        vertexWeight = new HashMap<>();
    }

    private int defineWeight(String type) {
        switch(type) {
            case "AGUA COM BARCO":
                return 1;
            case "AGUA SEM BARCO":
                return Integer.MAX_VALUE;
            case "GRAMA":
                return 2;
            case "AREIA":
                return 3;
            default: 
                return 0;
        }
    }

    void addVertex(String vertex, String type) {
        adjacencyList.putIfAbsent(vertex, new ArrayList<>());

        int weight = defineWeight(type);

        if(weight > 0) vertexWeight.put(vertex, weight);
    }

    void addEdge(String vertex1, String vertex2) {
        int vertex1Weight = vertexWeight.get(vertex1);
        int vertex2Weight = vertexWeight.get(vertex2);

        int averageWeight = Math.floorDiv(vertex1Weight + vertex2Weight, 2);

        adjacencyList.get(vertex1).add(new Edge(vertex2, averageWeight));
        adjacencyList.get(vertex2).add(new Edge(vertex1, averageWeight));

        println("Aresta adicionada entre " + vertex1 + " e " + vertex2 + " com peso " + averageWeight);
    }

    List<String> dijkstra(String start, String finish) {
        PriorityQueue nodes = new PriorityQueue();
        HashMap<String, Integer> distances = new HashMap<>();
        HashMap<String, String> previous = new HashMap<>();
        List<String> path = new ArrayList<>();

        for(String vertex : adjacencyList.keySet()) {
            if(vertex.equals(start)) {
                distances.put(vertex, 0);
                nodes.enqueue(vertex, 0);
            } else {
                distances.put(vertex, Integer.MAX_VALUE);
                nodes.enqueue(vertex, Integer.MAX_VALUE);
            }
            previous.put(vertex, null);
        }

        while(!nodes.values.isEmpty()) {
            String smallest = nodes.dequeue().val;

            if(smallest.equals(finish)) {
                while(previous.get(smallest) != null) {
                    path.add(smallest);
                    smallest = previous.get(smallest);
                }
                break;
            }

            if(smallest != null && distances.get(smallest) != Integer.MAX_VALUE) {
                for(Edge neighbor : adjacencyList.get(smallest)) {
                    int candidate = distances.get(smallest) + neighbor.weight;

                    if(candidate < distances.get(neighbor.node)) {
                        distances.put(neighbor.node, candidate);
                        previous.put(neighbor.node, smallest);
                        nodes.enqueue(neighbor.node, candidate);
                    }
                }
            }
        }

        if(path.size() > 0) path.add(start);
        Collections.reverse(path);
        return path;
    }

    class Edge {
        String node;
        int weight;

        Edge(String node, int weight) {
            this.node = node;
            this.weight = weight;
        }
    }
}
