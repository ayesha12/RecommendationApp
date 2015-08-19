<%@ page import="com.tinkerpop.blueprints.Edge,com.tinkerpop.blueprints.Graph" %>
<%@ page import="com.tinkerpop.blueprints.GraphFactory" %>
<%@ page import="com.tinkerpop.blueprints.Vertex" %>
<%@ page
        import="com.tinkerpop.blueprints.util.io.graphson.GraphSONMode,com.tinkerpop.blueprints.util.io.graphson.GraphSONWriter" %>
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
    <!-- FONTAWESOME STYLES-->
    <link href="/static/css/font-awesome.css" rel="stylesheet" />
    <!-- CUSTOM STYLES-->
    <link href="/static/css/custom.css" rel="stylesheet" />
    <!-- GOOGLE FONTS-->
    <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css' />
    <link href="http://fonts.googleapis.com/css?family=Lobster" rel="stylesheet" type="text/css">
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
<div id="wrapper">
    <nav class="navbar navbar-default navbar-cls-top " role="navigation" style="margin-bottom: 5" color="lightgreen" ;>
        <div class="navbar-header">
            <h5>
                <div style="color: darkblue;
                    padding: 15px 3px;
                    float: right;
                    font-size: 18px;
                    font-family: 'Lobster', Georgia, Times, serif;
                    text-align: center;
                    background-color: lightgreen;">
                    <div id="welcome">
                        <p>&nbsp;&nbsp;&nbsp;Welcome To Blueprints for Usergrid!</p>
                    </div>
                </div></h5> <br>
            <!--<a class="navbar-brand" href="user_dashboard.html">Welcome<br>Nishita</a>-->
        </div>
    </nav>
</div>
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
                        <option>BurgerKing</option>
                        <option>CheeseCakeFactory</option>

                    </select>
                </div>
            </div>
            <p>&nbsp;</p>
            <input name="submit" id="submit" type="button" class="btn btn-primary" value ="Submit" colour="darkblue">
        </div>
    </div>
    </div>
</form>

<div id="modal">
    <div id="content"></div>
    <button id="modalClose" onclick="nodeOut();d3.select('#modal').style('display','none');">X</button>
</div>


<%--Adding all the Scripts here--%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.5/d3.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>

<script>
    function nodeOut(){
        d3.selectAll(".hoverLabel")
                .attr("r", 5)
                .attr("class", "node")
                .style("opacity",1)
                .style("stroke", function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" })
                .style("stroke-width", "2px")
                .style("fill", function(d) { { if(d.group == 1){return "red"}else if(d.group == 2){return "blue"} else return "green" }});
        d3.selectAll(".link")
                .style("stroke-width", "2px")
                .style("stroke",function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" })
                .style("fill",function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" })
                .style("opacity",1);
//                                .style("opacity",1)
//                                .style("stroke-width", "2px")
//                                .style("fill",function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" });
    }

    var jsonResponse = null;
    $(document).ready(function () {
        $('#submit').click(function () {
            $.ajax({
                type: "post",
                url: "serverGraph.jsp", //this is my servlet
                data: "pName=" + $('#personName').val() + "&rName=" + $('#restaurantName').val(),
                success: function (msg) {
                    alert(msg);
                    jsonResponse = msg;
                    d3.select('#modal').style('display','none');
                    var width = 1500,
                            height = 1000;
                    var nodeFocous = false;
                    var color = d3.scale.category20();

                    var force = d3.layout.force()
                            .charge(-120)
                            .linkDistance(30)
                            .size([width, height]);

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
                        d3.selectAll(".hoverLabel")
                                .attr("r", 5)
                                .attr("class", "node")
                                .style("opacity",1)
                                .style("stroke", function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" })
                                .style("stroke-width", "2px")
                                .style("fill", function(d) { { if(d.group == 1){return "red"}else if(d.group == 2){return "blue"} else return "green" }});
                        d3.selectAll(".link")
                                .style("stroke-width", "2px")
                                .style("stroke",function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" })
                                .style("fill",function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" })
                                .style("opacity",1);
//                                .style("opacity",1)
//                                .style("stroke-width", "2px")
//                                .style("fill",function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" });
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
                                    .style("stroke", isNeighbor > -1 ? "blue" : function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" })
                        })
                        d3.selectAll(".link")
                                .style("stroke", function (d) {
                                    return nodeNeighbors.links.indexOf(d) > -1 ? "black" : function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" }
                                })
                                .style("stroke-width", function (d) {
                                    return nodeNeighbors.links.indexOf(d) > -1 ? 2 : 1
                                })
                                .style("opacity", function (d) {
                                    return nodeNeighbors.links.indexOf(d) > -1 ? 1 : 1
                                });
                    }


                    function nodeClick(d,i) {
                        nodeFocus = false;
                        nodeOut();
                        //            nodeOver(d,i,this);
                        nodeFocus = true;

                        var newContent = "<p>Name : " + d.name ; 
                        newContent += "<p>Attributes: </p><p><ul><li>created : "+ d.created+"</li><li>modified : "+ d.modified+"</li><li>id : "+ d._id+"</li></ul></p>";

                        d3.select("#modal").style("display", "block").select("#content").html(newContent);
                    }

                    function nodeOver(d,i,e){
                        el = this;
                        d3.select(el)
                                .attr("class", "hoverLabel")
                                .style("stroke", function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" })
                                .style("stroke-width", "2px")
                                .style("opacity", 1)
                                .style("fill",function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" });
                        highlightNeighbors(d,i);
                        el.text(function(d) { return d.name; });

                    }

                    d3.json(jsonResponse,function(error , graph){
                        graph = JSON.parse(JSON.stringify(jsonResponse));
                        force
                                .nodes(graph.nodes)
                                .links(graph.links)
                                .start();

                        var link = vis.selectAll(".link")
                                .data(graph.links)
                                .enter().append("line")
                                .attr("class", "link")
                                .style("stroke-width", "2px")
                                .style("stroke",function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" })
                                .style("fill",function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" })
                                .style("opacity",1);

                        var node = vis.selectAll(".node")
                                .data(graph.nodes)
                                .enter().append("circle")
                                .attr("class", "node")
                                .attr("r", 5)
                                .style("opacity",1)
                                .style("fill", function(d) { if(d.group == 1){return "red"}else if(d.group == 2){return "blue"} else return "green" })
                                .style("stroke", function(d){ if(d.group == 0){return "green"}else if(d.group == 1){return "blue"} else if(d.group == 2){return "orange"} else if(d.group == 3){return "red"} else return "black" })
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
                }
            });
        });

    });
</script>
</body>
</html>
