        <%@ page import="com.tinkerpop.blueprints.Graph,com.tinkerpop.blueprints.GraphFactory" %>
<%@ page import="com.tinkerpop.blueprints.util.io.graphson.GraphSONMode,com.tinkerpop.blueprints.util.io.graphson.GraphSONWriter" %>
<%@ page import="org.json.simple.JSONArray,org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser,org.json.simple.parser.ParseException" %>
<%@ page import="java.io.BufferedWriter,java.io.ByteArrayOutputStream,java.io.FileWriter" %>
<%@ page import="java.io.IOException" %>
<%@ page import="com.tinkerpop.blueprints.Vertex" %>
<%@ page import="com.tinkerpop.blueprints.Edge" %>
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
    Graph usergrid = GraphFactory.open("/Users/ayeshadastagiri/blueprints-web-example/src/main/resources/usergrid.properties");
    System.out.println("Graph Created!");
    System.out.println(pName);
    System.out.println(rName);

    if (pName != null && rName != null) {
        Vertex v1 = usergrid.addVertex("person/" + pName);
        Vertex v2 = usergrid.addVertex("restaurant/" + rName);
        Edge e1 = usergrid.addEdge(null, v1, v2, "Likes");
        System.out.println("Inside If !! ");
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
                } else {
                    edge.put("group", 2);
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