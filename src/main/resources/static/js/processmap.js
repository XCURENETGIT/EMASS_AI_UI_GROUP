var processmap_config = {};

var processmap_graph       = {},
    selected    = {},
    highlighted = null,
    isIE        = false;
var dataSize = 0;

isIE = $.browser.msie;
var maxX = 1000, maxY = 900;

var xScale = null;
var yScale = null;

function processmap(id, data, inputX, inputY) {
    maxX = inputX;
    maxY = inputY;
    $('#chart_tab a:first').tab('show');
    var jData = eval("("+JSON.stringify(data)+")");
    processmap_graph.data = eval("("+jData.links+")");
    processmap_config = eval("("+jData.config+")");

    var dataSize = Object.keys(processmap_graph.data);
    drawGraph(id);
    resize(dataSize);
    if(Object.keys(processmap_graph.data) > 100) {
        alert(baseMsg1 + dataSize + baseMsg2 + ")");
    }
}

$(document).on('click', '.select-object', function() {
    var obj = processmap_graph.data[$(this).data('name')];
    if (obj) {
        selectObject(obj);
    }
    return false;
});

function drawGraph(id) {
    $('#'+id).empty();

    processmap_graph.margin = {
        top    : 20,
        right  : 20,
        bottom : 20,
        left   : 20
    };


    var display = $('#'+id).css('display');
    $('#'+id)
        .css('display', 'block')
        .css('height', processmap_config.graph.height + 'px');
    processmap_graph.width  = $('#'+id).width()  - processmap_graph.margin.left - processmap_graph.margin.right;
    processmap_graph.height = $('#'+id).height() - processmap_graph.margin.top  - processmap_graph.margin.bottom;
    $('#'+id).css('display', display);

    console.log( "processmap_graph");
    console.log( processmap_graph.data);


    for (var name in processmap_graph.data) {
        var obj = processmap_graph.data[name];
        obj.positionConstraints = [];
        obj.linkStrength        = 1;

        processmap_config.constraints.forEach(function(c) {
            for (var k in c.has) {
                if (c.has[k] !== obj[k]) {
                    return true;
                }
            }

            switch (c.type) {
                case 'position':
                    obj.positionConstraints.push({
                        weight : c.weight,
                        x      : c.x * processmap_graph.width,
                        y      : c.y * processmap_graph.height
                    });
                    break;

                case 'linkStrength':
                    obj.linkStrength *= c.strength;
                    break;
            }
        });
    }

    processmap_graph.links = [];

    for (var name in processmap_graph.data) {
        var obj = processmap_graph.data[name];

        for (var depIndex = 0; depIndex < obj.depends.length; depIndex++) {
            var link = {
                source : processmap_graph.data[obj.depends[depIndex]],
                target : obj
            };


            console.log("link")
            console.log(link)

            link.strength = (link.source.linkStrength || 1)
                * (link.target.linkStrength || 1);
            processmap_graph.links.push(link);
        }
    }

    processmap_graph.categories = {};
    for (var name in processmap_graph.data) {
        var obj = processmap_graph.data[name],
            key = obj.type + ':' + (obj.group || ''),
            cat = processmap_graph.categories[key];

        obj.categoryKey = key;
        if (!cat) {
            cat = processmap_graph.categories[key] = {
                key      : key,
                type     : obj.type,
                typeName : (processmap_config.types[obj.type]
                    ? processmap_config.types[obj.type].short
                    : obj.type),
                group    : obj.group,
                count    : 0
            };
        }
        cat.count++;
    }

    processmap_graph.categoryKeys = d3.keys(processmap_graph.categories);

    processmap_graph.colors = confColor; //서비스별 색상

    function getColor(group) {
        for(var i = 0; i < confGroup.length; i++) {
            if(group == confGroup[i]) return processmap_graph.colors[i];
        }
    }

    processmap_graph.nodeValues = d3.values(processmap_graph.data); //data set

    processmap_graph.force = d3.layout.force() //Force Layout set
        .nodes(processmap_graph.nodeValues) //노드 값
        .links(processmap_graph.links) //노드 간 연결 선
        .linkStrength(0.9)
        .size([processmap_graph.width, processmap_graph.height]) //크기
        .linkDistance(200)
        .charge(processmap_config.graph.charge)
        .on('tick', tick);

    xScale = d3.scale.linear() //줌을 위한 x축 set
        .domain([0, processmap_graph.width])
        .range([0, processmap_graph.width]);

    yScale = d3.scale.linear() //줌을 위한 y축 set
        .domain([0, processmap_graph.height])
        .range([0, processmap_graph.height]);

    var zoomer = d3.behavior.zoom().x(xScale).y(yScale).scaleExtent([0.3, 8]).on("zoom", zoom); //zoom 이벤트 저장

    function zoom(d) { //첫 차트 출력 시 zoom 오류로 인해 tick 호출
        tick(d);
    };

    processmap_graph.svg = d3.select('#'+id).append('svg') //전체 차트 레이아웃 설정
        .attr('width' , processmap_graph.width  + processmap_graph.margin.left + processmap_graph.margin.right)
        .attr('height', processmap_graph.height + processmap_graph.margin.top  + processmap_graph.margin.bottom)
        .call(zoomer)
        .on('dblclick.zoom', null)
        .append('g')
        .attr('transform', 'translate(' + processmap_graph.margin.left + ',' + processmap_graph.margin.top + ')');

    processmap_graph.svg.append('defs').selectAll('marker') //끝선 처리 (화살표)
        .data(['end'])
        .enter().append('marker')
        .attr('id'          , String)
        .attr('viewBox'     , '0 -5 10 10')
        .attr('refX'        , 10)
        .attr('refY'        , 0)
        .attr('markerWidth' , 6)
        .attr('markerHeight', 6)
        .attr('orient'      , 'auto')
        .append('path')
        .attr('d', 'M0,-5L10,0L0,5');

    var glow = processmap_graph.svg.append('filter') //노드 선택 시 노드 속성
        .attr('x'     , '-50%')
        .attr('y'     , '-50%')
        .attr('width' , '200%')
        .attr('height', '200%')
        .attr('id'    , 'blue-glow');

    glow.append('feColorMatrix') //노드 선택 시 그림자 색상 행렬 형식 설정
        .attr('type'  , 'matrix')
        .attr('values', '0 0 0 0  0 '
            + '0 0 0 0  0 '
            + '0 0 0 0  .7 '
            + '0 0 0 1  0 ');

    glow.append('feGaussianBlur')
        .attr('stdDeviation', 3) //노드 선택 시 그림자 크기
        .attr('result'      , 'coloredBlur'); //설정 저장

    glow.append('feMerge').selectAll('feMergeNode') //생성
        .data(['coloredBlur', 'SourceGraphic'])
        .enter().append('feMergeNode')
        .attr('in', String);

    processmap_graph.legend = processmap_graph.svg.append('g') //카데고리 표기 초기 set
        .attr('class', 'legend')
        .attr('x', 0)
        .attr('y', 0)
        .selectAll('.category')
        .data(d3.values(processmap_graph.categories))
        .enter().append('g')
        .attr('class', 'category');

    processmap_graph.legendConfig = { //카데고리 표기 설정 값
        rectWidth   : 12,
        rectHeight  : 12,
        xOffset     : -10,
        yOffset     : 30,
        xOffsetText : 20,
        yOffsetText : 10,
        lineHeight  : 15
    };
    processmap_graph.legendConfig.xOffsetText += processmap_graph.legendConfig.xOffset;
    processmap_graph.legendConfig.yOffsetText += processmap_graph.legendConfig.yOffset;

    processmap_graph.legend.append('rect') //카테고리 좌측 박스
        .attr('x', processmap_graph.legendConfig.xOffset)
        .attr('y', function(d, i) {
            return processmap_graph.legendConfig.yOffset + i * processmap_graph.legendConfig.lineHeight;
        })
        .attr('height', processmap_graph.legendConfig.rectHeight)
        .attr('width' , processmap_graph.legendConfig.rectWidth)
        .attr('fill'  , function(d) {
            return getColor(d.type) == undefined ? '#b0f2be' : getColor(d.type);
        })
        .attr('stroke', function(d) {
            return getColor(d.type) == undefined ? '#b0f2be' : getColor(d.type);
        })
        .on('mouseover', function(d) {
            var cursor = d3.select(this);
            cursor.style('cursor', 'pointer');
        })
        .on('click', nodeHidden);

    function nodeHidden(d) {
        var typeName = d.typeName;

        if(this.innerHTML != "") var legendRect = d3.select(this.previousElementSibling);
        else var legendRect = d3.select(this);

        processmap_graph.node.each(function(d) {
            if((d.type == typeName) && (d.depends.length > 0)) {
                var node  = d3.select(this);
                if(node.attr('visibility') == 'hidden') {
                    node.attr('visibility', 'visible');
                    legendRect.attr('fill-opacity', '1');
                }
                else {
                    node.attr('visibility', 'hidden');
                    legendRect.attr('fill-opacity', '0.5');
                }

                spliceLinksForNode(d);
            }
        });
    }

    function spliceLinksForNode(node) {
        var toSplice = processmap_graph.links.filter(function(l) { return (l.target === node); });
        processmap_graph.line.each(function(d) {
            var link = d3.select(this);
            for(var i = 0; i < toSplice.length; i++) {
                if(d == toSplice[i]) {
                    if(link.attr('visibility') == 'visible' || link.attr('visibility') == null) link.attr('visibility', 'hidden');
                    else link.attr('visibility', 'visible');
                }
            }
        });
    };

    processmap_graph.legend.append('text') //카테고리 명 text
        .attr('x', processmap_graph.legendConfig.xOffsetText)
        .attr('y', function(d, i) {
            return processmap_graph.legendConfig.yOffsetText + i * processmap_graph.legendConfig.lineHeight;
        })
        .text(function(d) {
            return d.typeName + (d.group ? ': ' + d.group : '');
        })
        .on('mouseover', function(d) {
            var cursor = d3.select(this);
            cursor.style('cursor', 'pointer');
        })
        .on('click', nodeHidden);

    //스크롤 이벤트 발생 시에도 카테고리 위치 좌측 상단 표기
    $('#graph-container').on('scroll', function() {
        processmap_graph.legend.attr('transform', 'translate(0,' + $(this).scrollTop() + ')');
    });

    //노드간 연결 선
    processmap_graph.line = processmap_graph.svg.append('g').selectAll('.link')
        .data(processmap_graph.force.links())
        .enter().append('line')
        .attr('class', 'link');

    //드래그 이벤트 관련
    processmap_graph.draggedThreshold = d3.scale.linear()
        .domain([0, 0.1])
        .range([5, 20])
        .clamp(true);

    //현재 드래그 상태 확인
    function dragged(d) {
        var threshold = processmap_graph.draggedThreshold(processmap_graph.force.alpha()),
            dx        = d.oldX - d.px,
            dy        = d.oldY - d.py;
        if (Math.abs(dx) >= threshold || Math.abs(dy) >= threshold) {
            d.dragged = true;
        }
        return d.dragged;
    }

    //드래그 이벤트
    processmap_graph.screenDrag = d3.behavior.drag()
        .origin(function(d) { return d; }) //원점 설정
        .on('dragstart', function(d) {
            d3.event.sourceEvent.stopPropagation();
            d.oldX    = d.x;
            d.oldY    = d.y;
            d.dragged = false;
            d.fixed |= 2;
        })
        .on('drag', function(d) {
            var mouse = d3.mouse(processmap_graph.svg.node());
            d.x = xScale.invert(mouse[0]);
            d.y = yScale.invert(mouse[1]);
            d.px = d.x;
            d.py = d.y;
            if (dragged(d)) {
                if (!processmap_graph.force.alpha()) {
                    processmap_graph.force.alpha(.025);
                }
            }
        })
        .on('dragend', function(d) {
            if (!dragged(d)) {
                selectObject(d, this);
            }
            d.fixed &= ~6;
        });

    $('#graph-container').on('click', function(e) {
        if (!$(e.target).closest('.node').length) {
            deselectObject();
        }
    });

    processmap_graph.node = processmap_graph.svg.selectAll('.node') //노드 설정
        .data(processmap_graph.force.nodes())
        .enter().append('g')
        .attr('class', 'node')
        .call(processmap_graph.screenDrag)
        .on('mouseover', function(d) {
            if (!selected.obj) {
                if (processmap_graph.mouseoutTimeout) {
                    clearTimeout(processmap_graph.mouseoutTimeout);
                    processmap_graph.mouseoutTimeout = null;
                }
                highlightObject(d);
            }
        })
        .on('mouseout', function(d) {
            if (!selected.obj) {
                if (processmap_graph.mouseoutTimeout) {
                    clearTimeout(processmap_graph.mouseoutTimeout);
                    processmap_graph.mouseoutTimeout = null;
                }
                processmap_graph.mouseoutTimeout = setTimeout(function() {
                    highlightObject(null);
                }, 300);
            }
        });

    processmap_graph.nodeRect = processmap_graph.node.append('rect') //노드의 박스 설정
        .attr('rx', 5)
        .attr('ry', 5)
        .attr('stroke', function(d) {
            if(d.depends.length == 0) return 'rgb(0, 0, 214)';
            return getColor(d.type) == undefined ? '#b0f2be' : getColor(d.type);
        })
        .attr('fill', function(d) {
            return getColor(d.type) == undefined ? '#b0f2be' : getColor(d.type);
        })
        .attr('width' , 120)
        .attr('height', 30);

    processmap_graph.node.each(function(d) { //노드의 내용 작성
        var node  = d3.select(this),
            rect  = node.select('rect'),
            lines = wrap(d.name),
            ddy   = 1.1,
            dy    = -ddy * lines.length / 2 + .5;
        lines.forEach(function(line) {
            var text = node.append('text')
                .text(line)
                .attr('dy', dy + 'em');
            dy += ddy;
        });
    });

    setTimeout(function() {  //차트 출력 With 바운드 애니메이션
        processmap_graph.node.each(function(d) {
            var node   = d3.select(this),
                text   = node.selectAll('text'),
                bounds = {},
                first  = true;

            text.each(function() {
                var box = this.getBBox();
                if (first || box.x < bounds.x1) {
                    bounds.x1 = box.x;
                }
                if (first || box.y < bounds.y1) {
                    bounds.y1 = box.y;
                }
                if (first || box.x + box.width > bounds.x2) {
                    bounds.x2 = box.x + box.width;
                }
                if (first || box.y + box.height > bounds.y2) {
                    bounds.y2 = box.y + box.height;
                }
                first = false;
            })
                .attr('style', function(d){
                    if(d.mySelf == 'Y') {
                        return 'font-weight:bold;fill:#980000;';
                    } else {
                        return '';
                    }
                })
                .attr('text-anchor', 'middle');

            var padding  = processmap_config.graph.labelPadding,
                margin   = processmap_config.graph.labelMargin,
                oldWidth = bounds.x2 - bounds.x1;

            bounds.x1 -= oldWidth / 2;
            bounds.x2 -= oldWidth / 2;

            bounds.x1 -= padding.left;
            bounds.y1 -= padding.top;
            bounds.x2 += padding.left + padding.right;
            bounds.y2 += padding.top  + padding.bottom;

            node.select('rect')
                .attr('x', bounds.x1)
                .attr('y', bounds.y1)
                .attr('width' , bounds.x2 - bounds.x1)
                .attr('height', bounds.y2 - bounds.y1);

            d.extent = {
                left   : bounds.x1 - margin.left,
                right  : bounds.x2 + margin.left + margin.right,
                top    : bounds.y1 - margin.top,
                bottom : bounds.y2 + margin.top  + margin.bottom
            };

            d.edge = {
                left   : new geo.LineSegment(bounds.x1, bounds.y1, bounds.x1, bounds.y2),
                right  : new geo.LineSegment(bounds.x2, bounds.y1, bounds.x2, bounds.y2),
                top    : new geo.LineSegment(bounds.x1, bounds.y1, bounds.x2, bounds.y1),
                bottom : new geo.LineSegment(bounds.x1, bounds.y2, bounds.x2, bounds.y2)
            };
        });

        processmap_graph.numTicks = 0;
        processmap_graph.preventCollisions = false;
        processmap_graph.force.start();
        for (var i = 0; i < processmap_config.graph.ticksWithoutCollisions; i++) {
            processmap_graph.force.tick();
        }
        processmap_graph.preventCollisions = true;
        $('#graph-container').css('visibility', 'visible');
    });

    for (var name in processmap_graph.data) {
        var obj = processmap_graph.data[name];
        obj = outCheck(obj);
    };
}

var maxLineChars = 26,
    wrapChars    = ' /_-.'.split('');

function wrap(text) {
    if (text.length <= maxLineChars) {
        return [text];
    } else {
        for (var k = 0; k < wrapChars.length; k++) {
            var c = wrapChars[k];
            for (var i = maxLineChars; i >= 0; i--) {
                if (text.charAt(i) === c) {
                    var line = text.substring(0, i + 1);
                    return [line].concat(wrap(text.substring(i + 1)));
                }
            }
        }
        return [text.substring(0, maxLineChars)]
            .concat(wrap(text.substring(maxLineChars)));
    }
}

function preventCollisions() {
    var quadtree = d3.geom.quadtree(processmap_graph.nodeValues);

    for (var name in processmap_graph.data) {
        var obj = processmap_graph.data[name];

        if(obj.extent == undefined) {
            ox1 = obj.x + -30,
                ox2 = obj.x + 30,
                oy1 = obj.y + -10,
                oy2 = obj.y + 10;
        } else {
            ox1 = obj.x + obj.extent.left,
                ox2 = obj.x + obj.extent.right,
                oy1 = obj.y + obj.extent.top,
                oy2 = obj.y + obj.extent.bottom;
        }

        quadtree.visit(function(quad, x1, y1, x2, y2) {
            if (quad.point && quad.point !== obj) {
                // Check if the rectangles intersect
                var p   = quad.point,
                    px1 = p.x + p.extent.left,
                    px2 = p.x + p.extent.right,
                    py1 = p.y + p.extent.top,
                    py2 = p.y + p.extent.bottom,
                    ix  = (px1 <= ox2 && ox1 <= px2 && py1 <= oy2 && oy1 <= py2);
                if (ix) {
                    var xa1 = ox2 - px1, // shift obj left , p right
                        xa2 = px2 - ox1, // shift obj right, p left
                        ya1 = oy2 - py1, // shift obj up   , p down
                        ya2 = py2 - oy1, // shift obj down , p up
                        adj = Math.min(xa1, xa2, ya1, ya2);

                    if (adj == xa1) {
                        obj.x -= adj / 2;
                        p.x   += adj / 2;
                    } else if (adj == xa2) {
                        obj.x += adj / 2;
                        p.x   -= adj / 2;
                    } else if (adj == ya1) {
                        obj.y -= adj / 2;
                        p.y   += adj / 2;
                    } else if (adj == ya2) {
                        obj.y += adj / 2;
                        p.y   -= adj / 2;
                    }
                }
                return ix;
            }
        });
    }
}

function tick(e) {
    if(e == undefined) {
        e = {
            type: "tick",
            alpha: 0
        };
    }

    processmap_graph.line.attr("x1", function (d) { return  xScale(d.source.x); })
        .attr("y1", function (d) { return yScale(d.source.y);  })
        .attr("x2", function (d) { return xScale(d.target.x); })
        .attr("y2", function (d) { return yScale(d.target.y); });

    processmap_graph.node.attr("transform", function (d) {
        return "translate(" + xScale(d.x) + "," + yScale(d.y) + ")";
    });
    processmap_graph.numTicks++;

    for (var name in processmap_graph.data) {
        var obj = processmap_graph.data[name];

        obj.positionConstraints.forEach(function(c) {
            var w = c.weight * e.alpha;
            if (!isNaN(c.x)) {
                obj.x = (c.x * w + obj.x * (1 - w));
            }
            if (!isNaN(c.y)) {
                obj.y = (c.y * w + obj.y * (1 - w));
            }
        });
    }

    if (processmap_graph.preventCollisions) {
        preventCollisions();
    }
}

function selectObject(obj, el) {
    var node;
    if (el) {
        node = d3.select(el);
    } else {
        processmap_graph.node.each(function(d) {
            if (d === obj) {
                node = d3.select(el = this);
            }
        });
    }
    if (!node) return;

    if (node.classed('selected')) {
        deselectObject();
        return;
    }
    deselectObject(false);

    selected = {
        obj : obj,
        el  : el
    };

    highlightObject(obj);

    node.classed('selected', true);

    getSelectList(obj.ip);
}

function deselectObject(doResize) {
    processmap_graph.node.classed('selected', false);
    selected = {};
    highlightObject(null);
}

function highlightObject(obj) {
    if (obj) {
        if (obj !== highlighted) {
            processmap_graph.node.classed('inactive', function(d) {
                return (obj !== d
                    && d.depends.indexOf(obj.name) == -1
                    && d.dependedOnBy.indexOf(obj.name) == -1);
            });
            processmap_graph.line.classed('inactive', function(d) {
                return (obj !== d.source && obj !== d.target);
            });
        }
        highlighted = obj;
    } else {
        if (highlighted) {
            processmap_graph.node.classed('inactive', false);
            processmap_graph.line.classed('inactive', false);
        }
        highlighted = null;
    }
}

function resize(dataSize) {
    var graphHeight = 500,
        $processmap_graph = $('#graph-container');

    var graphWidth = 500;
    if(dataSize < 50) {
        graphWidth = dataSize * 10;
    }
    graphHeight = graphHeight + graphWidth;

    $('#graph').css('height', $('#graph-container').height() + 'px');
    $('#graph > svg').css('height', $('#graph-container').height() + 'px');

}

// 화면에서 벗어나지 않도록 설정
function outCheck(obj) {
    if(obj.x < 30) {
        obj.x = 30;
    }
    if(obj.x > maxX) {
        obj.x = maxX;
    }
    if(obj.y < 10) {
        obj.y = 10;
    }
    if(obj.y > maxY) {
        obj.y = maxY;
    }

    return obj;
}