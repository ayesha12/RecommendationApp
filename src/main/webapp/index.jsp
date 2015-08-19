<%@ page import="com.tinkerpop.blueprints.Edge,com.tinkerpop.blueprints.Graph" %>
<%@ page import="com.tinkerpop.blueprints.GraphFactory" %>
<%@ page import="com.tinkerpop.blueprints.Vertex" %>
<%@ page import="com.tinkerpop.blueprints.util.io.graphson.GraphSONMode,com.tinkerpop.blueprints.util.io.graphson.GraphSONWriter" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.ParseException" %>
<%@ page import="java.io.BufferedWriter" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.IOException" %>
<%--
  Created by IntelliJ IDEA.
  User: ayeshadastagiri
  Date: 8/17/15
  Time: 4:02 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Usergrid_Blueprints</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

    <style>

        .node {
            stroke: #fff;
            stroke-width: 1.5px;
        }

        .link {
            stroke: #999;
            stroke-opacity: .6;
        }

        #modal {
            position: fixed;
            /*left:250px;*/
            /*top:20px;*/
            z-index: 1;
            background: white;
            /*border: 1px black solid;*/
            /*box-shadow: 10px 10px 5px #888888;*/
            display: none;
        }

        #content {
            position: relative;
            left: 30px;
            width: 500px;
            border: 1px black solid;
        }

        #modalClose {
            position: absolute;
            top: -0px;
            right: -0px;
            z-index: 1;
        }

    </style>

</head>
<body>
<form id="formid" name="formForGraphInsertion">
<div class="container">
    <div class="row">
        <div class="col-lg-8">
            <div class="form-group" style="padding-top: 10px">
                <label class="control-label col-sm-2">Name:</label>

                <div>
                    <input type="name" id="personName" name="personName"/>
                </div>
            </div>
            <label class="control-label col-sm-2">Resaturants:</label>

            <div class="dropdown">
                <select class="dropdown-toggle btn" type="button" data-toggle="dropdown" id="restaurantName" name="restaurantName">Amici
                    <option>Amici</option>
                    <option>CPK</option>
                    <option>PizzaHut</option>
                </select>
            </div>
        </div>
        <div class="col-lg-2">
            <br/>
            <input name="submit" id="submit" type="button" class="btn btn-primary">Submit</input>
        </div>
    </div>
</div>
</form>

<div id="modal">
    <div id="content"></div>
    <button id="modalClose" onclick="nodeOut();d3.select('#modal').style('display','none');">X</button>
</div>


<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.5/d3.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>


<script>
    var width = 1500,
            height = 1000;
    var nodeFocous = false;
    var color = d3.scale.category20();
    var force = d3.layout.force()
            .charge(-120)
            .linkDistance(30)
            .size([width, height]);

//    var personName = document.getElementById("personName");
//    var restaurantName = document.getElementById("restaurantName");
var jsonResponse = null;
    $(document).ready(function() {
        $('#submit').click(function ()
        {
            $.ajax({
                type: "post",
                url: "serverGraph.jsp", //this is my servlet
                data: "pName=" +$('#personName').val()+"&rName="+$('#restaurantName').val(),
                success: function(msg){
                    jsonResponse = msg;
                    // alert(JSON.stringify(msg));
//                    fillDiv(jsonResponse);
                }
            });
        });

    });

    var vis = d3.select("body").append("svg:svg")
            .attr("width", width)
            .attr("height", height).attr("pointer-events", "all")
            .append('svg:g')
            .call(d3.behavior.zoom().on("zoom", redraw))
            .append('svg:g');

    vis.append('svg:rect')
            .attr('width', width)
            .attr('height', height)
            .attr('fill', 'white');

    function redraw() {
        console.log("here", d3.event.translate, d3.event.scale);
        vis.attr("transform",
                "translate(" + d3.event.translate + ")"
                + " scale(" + d3.event.scale + ")");
    }
    function nodeOut(){
//
//            if (nodeFocus) {
//                return;
//            }

        d3.selectAll(".hoverLabel")
                .attr("r", 5)
                .attr("class", "node")
                .style("opacity",1)
                .style("stroke", "black")
                .style("stroke-width", "1px")
                .style("fill", function(d) { return color(d.group); });
        d3.selectAll(".link").style("opacity",.25).style("stroke-width", function(d) { return Math.sqrt(d.value); }).style("fill","grey");
    }

    function findNeighbors(d,i) {
        neighborArray = [d];
        var linkArray = [];
        var linksArray = d3.selectAll(".link").filter(function(p) {return p.source == d || p.target == d}).each(function(p) {
            neighborArray.indexOf(p.source) == -1 ? neighborArray.push(p.source) : null;
            neighborArray.indexOf(p.target) == -1 ? neighborArray.push(p.target) : null;
            linkArray.push(p);
        })
//        neighborArray = d3.set(neighborArray).keys();
        return {nodes: neighborArray, links: linkArray};
    }

    function highlightNeighbors(d,i) {
        var nodeNeighbors = findNeighbors(d, i);
//            alert(d3.selectAll(".node"));
        d3.selectAll(".node").each(function (p) {
            var isNeighbor = nodeNeighbors.nodes.indexOf(p);
            d3.select(this)
                    .attr("class", isNeighbor > -1 ? "hoverLabel" : "node")
                    .style("opacity", isNeighbor > -1 ? 0.9 : 1)
                    .style("stroke-width", isNeighbor > -1 ? "2px" : "1px")
                    .style("stroke", isNeighbor > -1 ? "blue" : "black")
        })
        d3.selectAll(".link")
                .style("stroke", function (d) {
                    return nodeNeighbors.links.indexOf(d) > -1 ? "black" : "grey"
                })
                .style("stroke-width", function (d) {
                    return nodeNeighbors.links.indexOf(d) > -1 ? 2 : 1
                })
                .style("opacity", function (d) {
                    return nodeNeighbors.links.indexOf(d) > -1 ? 1 : .25
                });
    }


    function nodeClick(d,i) {
        nodeFocus = false;
        nodeOut();
//            nodeOver(d,i,this);
        nodeFocus = true;
//        var newContent = "<p>Name : " + d.name + "</p><p>Title : " + d.title + "</p><p>Age : " + d.age + "</p><p>City : " + d.City + "</p>" ;
//            newContent += "<p>Attributes: </p><p><ul>";
//            for (x in gD3.nodeAttributes()) {
//                newContent += "<li>" + gD3.nodeAttributes()[x] + ": " + d.properties[gD3.nodeAttributes()[x]]+ "</li>";
//            }
//            newContent += "</ul></p><p>Connections:</p><ul>";
//            var neighbors = findNeighbors(d,i);
//            for (x in neighbors.nodes) {
//                if (neighbors.nodes[x] != d) {
//                    newContent += "<li>" + neighbors.nodes[x].label + "</li>";
//                }
//            }
//            newContent += "</ul></p>";

        d3.select("#modal").style("display", "block").select("#content").html(newContent);
    }

    function nodeOver(d,i,e){
        el = this;
        d3.select(el)
                .attr("class", "hoverLabel")
                .style("stroke", "blue")
                .style("stroke-width", "2px")
                .style("opacity", .9)
                .style("fill",function(d) { return color(d.group); });
        highlightNeighbors(d,i);
        el.text(function(d) { return d.name; });

    }


    d3.json(jsonResponse,function(error , graph){

        if(jsonResponse == null) {
            alert("hi");
            jsonResponse = '{"nodes":[{"created":1439966812074,"name":"Nishita","modified":1439967048010,"_ugBlueprintsId":"person\/Nishita","_ugName":"Nishita","_id":"person\/Nishita","group":1},{"created":1439966817163,"name":"Anne","modified":1439967075905,"_ugBlueprintsId":"person\/Anne","_ugName":"Anne","_id":"person\/Anne","group":1},{"created":1439966817602,"name":"Betty","modified":1439967073964,"_ugBlueprintsId":"person\/Betty","_ugName":"Betty","_id":"person\/Betty","group":1},{"created":1439966818089,"name":"Claire","modified":1439967072236,"_ugBlueprintsId":"person\/Claire","_ugName":"Claire","_id":"person\/Claire","group":1},{"created":1439966818504,"name":"Dave","modified":1439967061191,"_ugBlueprintsId":"person\/Dave","_ugName":"Dave","_id":"person\/Dave","group":1},{"created":1439966818952,"name":"Emma","modified":1439966818952,"_ugBlueprintsId":"person\/Emma","_ugName":"Emma","_id":"person\/Emma","group":1},{"created":1439966819530,"name":"Famida","modified":1439967077699,"_ugBlueprintsId":"person\/Famida","_ugName":"Famida","_id":"person\/Famida","group":1},{"created":1439966812594,"name":"CPK","modified":1439967050032,"_ugBlueprintsId":"restaurant\/CPK","_ugName":"CPK","_id":"restaurant\/CPK","group":2},{"created":1439966819930,"name":"Amici","modified":1439967063036,"_ugBlueprintsId":"restaurant\/Amici","_ugName":"Amici","_id":"restaurant\/Amici","group":2},{"created":1439966820371,"name":"BurgerKing","modified":1439967066712,"_ugBlueprintsId":"restaurant\/BurgerKing","_ugName":"BurgerKing","_id":"restaurant\/BurgerKing","group":2},{"created":1439966821096,"name":"CheeseCakeFactory","modified":1439966821096,"_ugBlueprintsId":"restaurant\/CheeseCakeFactory","_ugName":"CheeseCakeFactory","_id":"restaurant\/CheeseCakeFactory","group":2},{"created":1439966821516,"name":"DelhiChaat","modified":1439966821516,"_ugBlueprintsId":"restaurant\/DelhiChaat","_ugName":"DelhiChaat","_id":"restaurant\/DelhiChaat","group":2},{"created":1439966821966,"name":"EggFactory","modified":1439966821966,"_ugBlueprintsId":"restaurant\/EggFactory","_ugName":"EggFactory","_id":"restaurant\/EggFactory","group":2},{"created":1439966822451,"name":"FalafelStop","modified":1439966822451,"_ugBlueprintsId":"restaurant\/FalafelStop","_ugName":"FalafelStop","_id":"restaurant\/FalafelStop","group":2}],"links":[{"connectionid":"person\/Nishita\/visits\/restaurant\/CPK","_outV":"person\/Nishita","source":0,"_inV":"restaurant\/CPK","_label":"visits","target":7,"group":0},{"connectionid":"person\/Anne\/follows\/person\/Famida","_outV":"person\/Anne","source":1,"_inV":"person\/Famida","_label":"follows","target":6,"group":1},{"connectionid":"person\/Anne\/visits\/restaurant\/Amici","_outV":"person\/Anne","source":1,"_inV":"restaurant\/Amici","_label":"visits","target":8,"group":0},{"connectionid":"person\/Anne\/visits\/restaurant\/BurgerKing","_outV":"person\/Anne","source":1,"_inV":"restaurant\/BurgerKing","_label":"visits","target":9,"group":0},{"connectionid":"person\/Betty\/follows\/person\/Anne","_outV":"person\/Betty","source":2,"_inV":"person\/Anne","_label":"follows","target":1,"group":1},{"connectionid":"person\/Claire\/follows\/person\/Betty","_outV":"person\/Claire","source":3,"_inV":"person\/Betty","_label":"follows","target":2,"group":1},{"connectionid":"person\/Dave\/visits\/restaurant\/Amici","_outV":"person\/Dave","source":4,"_inV":"restaurant\/Amici","_label":"visits","target":8,"group":0},{"connectionid":"person\/Famida\/visits\/restaurant\/BurgerKing","_outV":"person\/Famida","source":6,"_inV":"restaurant\/BurgerKing","_label":"visits","target":9,"group":0}]}';
        }
        graph = JSON.parse(jsonResponse);
        force
                .nodes(graph.nodes)
                .links(graph.links)
                .start();


        var link = vis.selectAll(".link")
                .data(graph.links)
                .enter().append("line")
                .attr("class", "link")
                .style("stroke-width", function(d) { return Math.sqrt(d.group); })
                .style("fill","grey")
                .style("opacity",.25);
//                .style("stroke-width", 1);


        var node = vis.selectAll(".node")
                .data(graph.nodes)
                .enter().append("circle")
                .attr("class", "node")
                .attr("r", 5)
                .style("opacity",1)
                .style("fill", function(d) { return color(d.group); })
                .style("stroke", "black")
                .style("stroke-width", "1px")
                .style("stroke-opacity", 1)
                .on("mouseover", nodeOver)
                .on("mouseout", nodeOut)
                .on("click",nodeClick)
                .call(force.drag);

        node.append("title")
                .text(function(d) { return d.name; });

// Compute the distinct nodes from the links.
        force.on("tick", function() {
            link.attr("x1", function(d) { return d.source.x; })
                    .attr("y1", function(d) { return d.source.y; })
                    .attr("x2", function(d) { return d.target.x; })
                    .attr("y2", function(d) { return d.target.y; });

            node.attr("cx", function(d) { return d.x; })
                    .attr("cy", function(d) { return d.y; });
        });

    });

</script>
</body>
</html>
