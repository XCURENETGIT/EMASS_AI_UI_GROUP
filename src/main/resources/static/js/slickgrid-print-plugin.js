/**!
 * @license slickgrid-print-plugin v0.1.0
 * Copyright (c) 2013 .
 * License: MIT
 */
(function ($) {
    'use strict';

    var SlickPrint = function (xGrid) {
        var _self = this;
        var _grid;
        var _xGrid = xGrid;
        

        this.init = function (grid) {
            _grid = grid;
        };

        this.printToHtml = function (title) {
        	
        	var header = JSON.parse(_xGrid.getHeaderEXCEL());
        	var body = JSON.parse(_xGrid.getBodyEXCEL());
        	var str = '<table class="request"><caption>'+title+'</caption><colgroup>';
        	for (var i=0; i < header.length; i++) {
				str += '<col width="'+(header[i]['width']+30)+'px"/>';
			}
        	str += '</colgroup><thead><tr>';
    		for (var i=0; i < header.length; i++) {
				str += '<th>' + header[i]['title'] + '</th>';
			}
    		str += '</tr></thead><tbody>';

        	for (var i=0; i < body.length; i++) {
        		str += '<tr>';
        		for (var j=0; j < header.length; j++) {
        			var align = '';
        			if(header[j]['align'] != 'left') align = 'align="' + header[j]['align'] + '"';
        			str += '<td '+align+'>' + nvl(body[i][header[j]['key']]) + '</td>';
        		}
        		str += '</tr>';
			}
        	return str;
        	
//            var numRows = _grid.getDataLength();
//            var columns = _grid.getColumns();
//            var r, c;
//            var rows = [], cols = [], headers = [], colgroup = [];
//            var cellNode;
//            var topRow = _grid.getRenderedRange().top;
//
//            for ( var i=0 ; i < columns.length ; i++ ) {
//            	if(columns[i].id=='_checkbox_selector') continue;
//            	headers.push(columns[i].name);
//            }
//
//            Slick.GlobalEditorLock.cancelCurrentEdit();
//
//            _grid.scrollRowToTop(0);
//
//            var width = 0;
//
//            for ( var i=0 ; i < columns.length ; i++ ) {
//            	if(columns[i].id=='_checkbox_selector') continue;
//            	width += columns[i].width;
//            	colgroup.push('<col width="'+columns[i].width+'px"/>');
//            }
//
//            for (r = 0; r < numRows; r++) {
//                cols = [];
//                for (c = 0; c < columns.length; c++) {
//                	if(columns[c].id=='_checkbox_selector') continue;
//                    cellNode = _grid.getCellNode(r, c);
//                    if (!cellNode) {
//                        _grid.scrollRowToTop(r);
//                        cellNode = _grid.getCellNode(r, c);
//                    }
//                    var string = $(cellNode).html();
//                    cols.push(string);
//                }
//                rows.push('<td>' + cols.join('</td><td>') + '</td>');
//            }
//
//            var table = [
//                '<table class="table table-bordered" style="width:'+width+'px;">',
//                '<caption>'+title+'</caption>',
//                '<colgroup>',
//                colgroup.join(' '),
//                '</colgroup>',
//                '<thead>',
//                '<tr>',
//                    '<th>' + headers.join('</th><th>') + '</th>',
//                '</tr>',
//                '</thead>',
//                '<tbody>',
//                    '<tr>' + rows.join('</tr>\n<tr>') + '</tr>',
//                '</tbody>',
//                '</table>'
//            ].join('\n');
//            
//            _grid.scrollRowToTop(topRow);
//            return table;
        };
        
        this.nvl = function(obj){
        	if(obj == null || obj == undefined) return '';
        	else obj;
        };

        this.printToElement = function ($element, w, title) {
        	w.document.title = title;
            $($element).html(_self.printToHtml(title));
            w.print();
        };

        this.printToWindow = function (w, title) {
            setTimeout(function () {
                _self.printToElement(w.document.body, w, title);
            }, 2000);
        };
    };

    // register namespace
    $.extend(true, window, {
        Slick: {
            Plugins: {
                Print: SlickPrint
            }
        }
    });
}(jQuery));