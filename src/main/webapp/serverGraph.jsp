        <%@ page import="com.tinkerpop.blueprints.Graph,com.tinkerpop.blueprints.GraphFactory" %>
<%@ page import="com.tinkerpop.blueprints.util.io.graphson.GraphSONMode,com.tinkerpop.blueprints.util.io.graphson.GraphSONWriter" %>
<%@ page import="org.json.simple.JSONArray,org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser,org.json.simple.parser.ParseException" %>
<%@ page import="java.io.BufferedWriter,java.io.ByteArrayOutputStream,java.io.FileWriter" %>
<%@ page import="java.io.IOException" %>
<%@ page import="com.tinkerpop.blueprints.Vertex" %>
<%@ page import="com.tinkerpop.blueprints.Edge" %>
<%@ page import="com.tinkerpop.blueprints.*"%>
<%@ page import="javax.script.ScriptException"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%--
  Created by IntelliJ IDEA.
  User: ayeshadastagiri
  Date: 8/18/15
  Time: 8:55 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String pName = request.getParameter("pName");
    String rName = request.getParameter("rName");
    String SLASH = "/";
    String toReturn = null;
    JSONParser parser = new JSONParser();

    System.out.println("Creating graph...");
    Graph usergrid = GraphFactory.open("/Users/nishitarao/dev/RecommendationApp/src/main/resources/usergrid.properties");
    System.out.println("Graph Created!");

    if (pName != null && rName != null) {
        Vertex v1 = usergrid.addVertex("person/" + pName);
        Vertex v2 = usergrid.addVertex("restaurant/" + rName);
        Edge e1 = usergrid.addEdge(null, v1, v2, "Visits");
        System.out.println("Inside If !! ");
    }

    Vertex person1,person2,person3,person4,person5,person6,restaurant1,restaurant2,restaurant3,restaurant4,restaurant5,restaurant6;
    Edge link1,link2,link3,link4,link5,link6;

    //Creates a graph with 6 people and 6 restaurants, and creates a few edges

        person1 = usergrid.addVertex("person/Anne");
        person2 = usergrid.addVertex("person/Betty");
        person3 = usergrid.addVertex("person/Claire");
        person4 = usergrid.addVertex("person/Dave");
        person5 = usergrid.addVertex("person/Emma");
        person6 = usergrid.addVertex("person/Famida");
        restaurant1 = usergrid.addVertex("restaurant/Amici");
        restaurant2 = usergrid.addVertex("restaurant/BurgerKing");
        restaurant3 = usergrid.addVertex("restaurant/CheeseCakeFactory");
        restaurant4 = usergrid.addVertex("restaurant/DelhiChaat");
        restaurant5 = usergrid.addVertex("restaurant/EggFactory");
        restaurant6 = usergrid.addVertex("restaurant/FalafelStop");

        link1 = usergrid.addEdge(null, person1, restaurant1, "Visits");
        link1 = usergrid.addEdge(null, person1, restaurant2, "Visits");
        link2 = usergrid.addEdge(null, person4, restaurant1, "Visits");
        link3 = usergrid.addEdge(null, person6, restaurant2, "Visits");
        link4 = usergrid.addEdge(null, person2, person1, "Follows");
        link5 = usergrid.addEdge(null, person3, person2, "Follows");
        link6 = usergrid.addEdge(null, person1, person6, "Follows");

    //Suggestions of whom to follow are given to the 'namePerson'
    // It depends on 1) People who visit the same restaurant as him/her 2) People who they follow follow someone else

    List<String> AlreadyFollowing = new ArrayList<String>();
    List<String> AlreadyVisited = new ArrayList<String>();

    for (Vertex nameFollowed: usergrid.getVertex("person/"+pName).getVertices(Direction.OUT, "Follows")) {
    AlreadyFollowing.add(nameFollowed.getId().toString());
    }

    System.out.println("Already following"+AlreadyFollowing);

    for(String nameFollowed: AlreadyFollowing){
    Iterable<Vertex> WhomAllToFollow = usergrid.getVertex(nameFollowed).getVertices(Direction.OUT,"Follows");
    for (Vertex WhoToFollow: WhomAllToFollow){
    String WhoToFollow_Id = WhoToFollow.getId().toString();
    if (!AlreadyFollowing.contains(WhoToFollow_Id)){
    System.out.println("Recommended to follow:"+WhoToFollow_Id);
    usergrid.addEdge(null,usergrid.getVertex("person/"+pName),usergrid.getVertex(WhoToFollow_Id),"RecommendedToFollow");
    }
    }
    }

    for (Vertex nameFollowed: usergrid.getVertex("person/"+pName).getVertices(Direction.OUT, "Visits")) {
    AlreadyVisited.add(nameFollowed.getId().toString());
    }

    System.out.println("Already visited"+AlreadyVisited);

    for(String nameFollowed: AlreadyFollowing){
    Iterable<Vertex> WhomAllToVisit = usergrid.getVertex(nameFollowed).getVertices(Direction.OUT,"Visits");
    for (Vertex WhoToVisit: WhomAllToVisit){
    String WhoToVisit_Id = WhoToVisit.getId().toString();
    if (!AlreadyVisited.contains(WhoToVisit_Id)){
    System.out.println("Recommended to follow:"+WhoToVisit_Id);
    usergrid.addEdge(null,usergrid.getVertex("person/"+pName),usergrid.getVertex(WhoToVisit_Id),"RecommendedToVisit");
    }
    }
    }


        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        ;
        try {

            System.out.println("inside try block");
            GraphSONWriter.outputGraph(usergrid, bos, GraphSONMode.NORMAL);

        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("wrote into graphson");


        byte[] bytes = bos.toByteArray();
        String jsonString = new String(bytes);

        JSONObject json_object = new JSONObject();
        BufferedWriter outb = null;
//            FileWriter fileWrite = null;
        try {
            json_object = (JSONObject) parser.parse(jsonString);
            System.out.println(json_object);
//                fileWrite = new FileWriter("blueprints-usergrid-graph/src/main/resources/test2.json");

            JSONArray vertices = (JSONArray) json_object.get("vertices");
            for (int i = 0; i < vertices.size(); i++) {
                JSONObject vertex = (JSONObject) vertices.get(i);
                vertex.remove("metadata");
                vertex.remove("id");
                if (vertex.get("connecting") != null) {
                    vertex.remove("connecting");
                }
                if (vertex.get("connections") != null) {
                    vertex.remove("connections");
                }
                vertex.remove("_type");
                vertex.remove("propertyKeys");
                String vertexID = vertex.get("_id").toString();
                String[] parts = null;
                parts = vertexID.split(SLASH);
                String VertexType = parts[0];
                if (VertexType.toLowerCase().equals("person") || VertexType.toLowerCase().equals("people")) {
                    vertex.put("group", 1);
                } else if (VertexType.toLowerCase().equals("restaurant") || VertexType.toLowerCase().equals("restaurants")) {
                    vertex.put("group", 2);
                } else {
                    vertex.put("group", 0);
                }
            }

            JSONArray edges = (JSONArray) json_object.get("edges");
            for (int i = 0; i < edges.size(); i++) {
                JSONObject edge = (JSONObject) edges.get(i);
                edge.remove("connectionId");
                edge.remove("_id");
                edge.remove("label");
                edge.remove("_type");
                if (edge.get("_label").toString().toLowerCase().equals("visits")) {
                    edge.put("group", 0);
                } else if (edge.get("_label").toString().toLowerCase().equals("follows")) {
                    edge.put("group", 1);
                } else if (edge.get("_label").toString().toLowerCase().equals("recommendedtofollow")) {
                    edge.put("group", 2);
                }  else if (edge.get("_label").toString().toLowerCase().equals("recommendedtovisit")) {
                    edge.put("group", 3);
                }   else {
                    edge.put("group", 4);
                }
            }

            JSONObject finalObject = new JSONObject();
            finalObject.put("nodes", vertices);
            finalObject.put("links", edges);
            toReturn = finalObject.toJSONString().replace("\\/", "/");
            System.out.println(finalObject);
        } catch (Exception e) {
            e.printStackTrace();
        }

    response.setContentType("application/json");
    JSONObject returnGraph = (JSONObject) parser.parse(toReturn);
    response.getWriter().write(String.valueOf(returnGraph));
%>