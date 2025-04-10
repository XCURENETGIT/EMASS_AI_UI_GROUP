/**
 * @license
 * (c) 2015 changmin jo
 * http://www.xcurenet.com
 *
 * Distributed under MIT license.
 * All rights reserved.
 *
 * SlickGrid Common v1.0
 */
window.__grids=[];
function Xgrid ( target, contextRoot, rowHeight, options, dataview ) {
	this.options = {
		enableCellNavigation : true,
		enableColumnReorder : true,
		enableTextSelectionOnCells:true,
		editable : false,
		rowHeight : rowHeight != undefined ? rowHeight : 26,
		syncColumnCellResize : true,
		multiColumnSort: true,
		autoNumSize:40,
		commonId:'',
		status_cnt_id : '',
		status_cnt_ing_name : '',
		status_cnt_end_name : '',
		more_btn : ''
	};
	$.extend( this.options, options );
	this.dragEnable = false;
	this.status_cnt_id = this.options.status_cnt_id == '' ? '#total_cnt' : this.options.status_cnt_id;
	this.status_cnt_ing_name = this.options.status_cnt_ing_name == '' ? slickGridJS.searchCnt : this.options.status_cnt_ing_name;
	this.status_cnt_end_name = this.options.status_cnt_end_name == '' ? slickGridJS.searchSuccess : this.options.status_cnt_end_name;
	this.more_btn = this.options.more_btn == '' ? 'slick_grid_more_btn' : this.options.more_btn;
	this.num_title = 'No.';
	this.id = target;
	this.commonId = this.options.commonId;
	this.target = '#'+target;
	this.root = contextRoot == undefined ? '' : contextRoot;
	this.overlapData = [];
	this.data = [];
	this.Col = -1;
	this.Row = -1;
	this.Cols = -1;
	this.Rows = -1;
	this.columns = [];
	this.loadingPage = 0;
	this.autoNum=false;
	this.pageSize = 3000; //전체 페이지 자동 로드 기능을 사용할때 한번에 출력될 사이즈
	this.rtnNextPageFunc=null; //페이지 스크롤을 통한 추가 데이터 조회 시 활용.
	this.columnpicker;
	this.columnpickerUsed = true;
	this.printPlugin = new Slick.Plugins.Print(this);
	this.grid = new Slick.Grid(this, this.target, dataview ? dataview : [], [], this.options);
	this.grid.setSelectionModel(new Slick.RowSelectionModel());

	$(this.target).after('<div id="'+this.id+'_statusbar" class="slickgrid_statusbar"><div class="status_selno"></div><div class="status_count"></div><div class="nextpage"></div><div class="status_rownum"></div><div class="status_func"></div></div>');

	var moveRowsPlugin = new Slick.RowMoveManager({
		cancelEditOnDrag: false
	});

	this.loadPageSize = function() {
		var rownum = this.pageSize;
		ui.get({url : 'getConfAdmin.xcn', confId : 'msgGridPageSize', asyncFlag : false, success : function(data, total) {if( data != null) { rownum = Number(data.val);}}});

		var str = '';
		str += '<div class="btn-group dropup grid_rowcount" id="'+this.id+'_listCnt">';
		str += '<button type="button" class="btn btn-xs btn-default dropdown-toggle" style="color: #375E9A; background: #fff; border:1px solid #375E9A;" data-toggle="dropdown">';
		str += '	<span class="glyphicon glyphicon-list-alt"></span> '+slickGridJS.listCnt+' (<span class="dropdown-text">'+rownum.comma()+'</span>) <span val="'+rownum+'" class="caret"></span>';
		str += '</button>';
		str += '<ul class="dropdown-menu dropdown-menu-right" role="menu">';
		str += '	<li><a href="javascript:void(0);" data="100">100</a></li>';
		str += '	<li><a href="javascript:void(0);" data="500">500</a></li>';
		str += '	<li><a href="javascript:void(0);" data="1000">1,000</a></li>';
		str += '	<li><a href="javascript:void(0);" data="2000">2,000</a></li>';
		str += '	<li><a href="javascript:void(0);" data="3000">3,000</a></li>';
		str += '	<li><a href="javascript:void(0);" data="4000">4,000</a></li>';
		str += '	<li><a href="javascript:void(0);" data="5000">5,000</a></li>';
		str += '</ul>';
		str += '</div>';
		$(this.target + '_statusbar .status_rownum').append(str);

		this.pageSize = rownum;

		var grid = this.grid;
		$(this.target + '_listCnt .caret').change(function(){
			var cnt = Number($(this).attr('val'));
			grid.__parent.pageSize = cnt;
			try{grid.__parent.changePageSize(cnt);}catch(e){};
			ui.get({url : 'setConfAdmin.xcn',confId : 'msgGridPageSize',val : cnt,success : function(data, total) {}});
		});
	};

	this.loadExportMenu = function(title, exportMenu){
		var defaultExport = [];
		defaultExport.push('<li><a href="javascript:void(0);" class="excel_link" data-target="'+this.id+'" rel="' + title + '"><span class="fa fa-file-excel-o"></span>&nbsp;'+slickGridJS.excel+'(xlsx)</a></li>');
		defaultExport.push('<li><a href="javascript:void(0);" class="cell_link" data-target="'+this.id+'" rel="' + title + '"><span class="fa fa-file-excel-o"></span>&nbsp;'+slickGridJS.hancell+'(cell)</a></li>');
		defaultExport.push('<li><a href="javascript:void(0);" class="csv_link" data-target="'+this.id+'" rel="' + title + '"><span class="fa fa-file-text"></span>&nbsp;'+slickGridJS.text+'(csv)</a></li>');
		defaultExport.push('<li><a href="javascript:void(0);" class="pdf_link" data-target="'+this.id+'" rel="' + title + '"><span class="fa fa-file-pdf-o"></span>&nbsp;PDF</a></li>');
		defaultExport.push('<li><a href="javascript:void(0);" class="print_link" data-target="'+this.id+'" rel="' + title + '"><span class="glyphicon glyphicon-print"></span>&nbsp;'+slickGridJS.print+'</a></li>');
		if(exportMenu!=undefined && exportMenu!=null) {
			defaultExport = exportMenu;
		}
		var str = '';
		str += '<div class="btn-group dropup">';
		str += '	<button type="button" class="btn btn-xs btn-default dropdown-toggle" style="color: #375E9A; background: #fff; border:1px solid #375E9A;" data-toggle="dropdown">';
		str += '		<span class="glyphicon glyphicon-download-alt"></span> '+slickGridJS.exportData+' <span class="caret"></span>';
		str += '	</button>';
		str += '	<ul class="dropdown-menu dropdown-menu-right" role="menu">';
		for (var i=0; i < defaultExport.length; i++) {
			str += defaultExport[i];
		}
		str += '	</ul>';
		str += '</div>';
		$(this.target + '_statusbar .status_func').append(str);
	};

	this.setDrag = function (flag){
		this.dragEnable = flag;
	};

	this.grid.onDragInit.subscribe(function (e, dd) {
		if(!this.__parent.dragEnable) return;
		try{this.__parent.onDragInit(e,dd);}catch(e){};
		e.stopImmediatePropagation();
	});
	this.grid.onDragStart.subscribe(function(e, dd) {
		if(!this.__parent.dragEnable) return;
		var cell = this.__parent.grid.getCellFromEvent(e);
		var data = this.__parent.data;
		if (!cell) {
			return;
		}

		dd.row = cell.row;
		if (!data[dd.row]) {
			return;
		}

		if (Slick.GlobalEditorLock.isActive()) {
			return;
		}

		e.stopImmediatePropagation();
		dd.mode = "dragEl";

		var selectedRows = this.__parent.grid.getSelectedRows();

		if (!selectedRows.length || $.inArray(dd.row, selectedRows) == -1) {
			selectedRows = [ dd.row ];
			this.__parent.grid.setSelectedRows(selectedRows);
		}

		dd.rows = selectedRows;
		dd.count = selectedRows.length;

		var proxy = $("<span></span>").css({
			position : "absolute",
			display : "inline-block",
			padding : "4px 10px",
			background : "#FFA040",
			border : "1px solid #FFA040",
			"z-index" : 99999,
			"-moz-border-radius" : "8px",
			"-moz-box-shadow" : "2px 2px 6px silver"
		}).text("Move Selected Row(s) " + dd.count.comma() ).css('color','#fff').appendTo("body");
		dd.helper = proxy;
		$(dd.available).css("background", "#FFA040");

		try{this.__parent.onDragStart(e,dd);}catch(e){};
		return proxy;
	});

	this.grid.onDrag.subscribe(function(e, dd) {
		if(!this.__parent.dragEnable) return;
		if (dd.mode != "dragEl") {
			return;
		}
		dd.helper.css({
			top : e.pageY + 5,
			left : e.pageX + 5
		});
		try{this.__parent.onDrag(e,dd);}catch(e){};
	});

	this.grid.onDragEnd.subscribe(function(e, dd) {
		if (dd.mode != "dragEl") {
			return;
		}
		var selectedRows = dd.grid.__parent.getSelectedRows();
		console.warn( 'selectedRows:'+selectedRows.length );
		console.warn('rows : ' + JSON.stringify(selectedRows));

		dd.helper.remove();
		$(dd.available).css("background", "beige");
		try{this.__parent.onDragEnd(e,dd);}catch(e){};
	});

	this.grid.registerPlugin(moveRowsPlugin);
	this.grid.registerPlugin(new Slick.AutoTooltips());
	this.grid.registerPlugin(new Slick.CellExternalCopyManager({ dataItemColumnValueExtractor: function (item, columnDef) { return item[columnDef.field]; } }));
	this.grid.registerPlugin(this.printPlugin);
	this.grid.id = this.id;
	$(this.target).on("selectstart", function(event){ return false; });
    $(this.target).on("dragstart", function(event){ return false; });
    this.grid.onKeyDown.subscribe(function(e) {
		if (e.ctrlKey) {
			if (e.keyCode == 65 || e.keyCode == 97) { // 'A' or 'a'
				this.__parent.setSelectAll();
			}
		}
		if((e.keyCode==40||e.keyCode==38) && this.__parent.getSelectedRows().length ==0 ) {
			if(this.__parent.getData().length>0){
				this.__parent.Select( 0, 1 );
			}
		}
		try{this.__parent.onKeyDown(e);}catch(e){};
    });

	//$(this.target).show();
	window.__grids.push ( this );

	this.close = function ( ) {
		$(this.target).unbind('sizeChanged');
		$(this.target).html('');
		for ( var i=0 ; i < window.__grids.length; i++ ) {
			if ( window.__grids[i].id == this.id ) {
				window.__grids.remove(i,0);
				break;
			}
		}
	};

	this.colAdd = function ( id, name, width, align, hidden, type, formatter, sortCol,hide) {
		if ( this.isAdd(id) ) return;
		var sortable = true;
		//if ( id == 'NUM' ) sortable = false;
		var css = this.getCss(align,type);
		if (type == 'check') this.columns.push( this.checkBoxCol ( id, name, width, hidden ) );
		else if(formatter!=null) {
			this.columns.push ( { id:id, name:name, field:id, width:width, cssClass:css, headerCssClass:'link_cell' + css, formatter:formatter, resizable:true, hidden:hidden,sortable:sortable, sortCol:sortCol} );
		} else {
			if(hide) this.columns.push ( { id:id, name:name, field:id, width:0, minWidth:0,maxWidth:0, cssClass:"realHidden", headerCssClass:"realHidden"} );
			this.columns.push ( { id:id, name:name, field:id, width:width, cssClass:css, headerCssClass:'link_cell' + css, resizable:true, hidden:hidden,sortable:sortable, sortCol:sortCol} );
		}
	};

	this.isAdd = function(id){
		for ( var i=0 ; i < this.columns.length ; i++ ) {
			if ( this.columns[i].id === id ) return true;
		}
		return false;
	};

	this.getCss = function(align,type){
		type = type == undefined ? 'nomal' : type;
		var css = 'slick-left';
		if ( align == 'center' ) css = 'slick-center';
		else if ( align == 'right' ) css = 'slick-right';
		else if ( align == 'left' ) css = 'slick-left';
		return css += ' ' + type;
	};

	/**
	 * 컬럼 삭제
	 * 그리드 헤더 컬럼 삭제 위해 사용
	 */
	this.colVisible = function ( colKey, hidden ) {
		for ( var i=0 ; i < this.columns.length ; i++ ) {
			if ( this.columns[i].id == colKey || colKey == -1) {
				this.columns[i].hidden = hidden;
			}
		}
		this.setColumns();
	};

	this.setColumns = function ( ) {
		this.grid.setColumns( this.columns );
		this.Cols = this.columns.length;
		if ( !this.columnpickerUsed ) return;

		var id = this.target + '_columnpicker';
		$(id).remove();
		if ($(id).length == 0) this.columnpicker = new Slick.Controls.ColumnPicker(this.columns, this.grid, this.options);
		var colCnt = 0;
		for ( var i=0 ; i < this.columns.length ; i++ ) {
			$(id + ' :checkbox[value="' + this.columns[i].id + '"]').attr('checked', !this.columns[i].hidden );
			if ( !this.columns[i].hidden ) colCnt++;
		}
		if ( colCnt == 0 ) for ( var i=0 ; i < this.columns.length ; i++ ) {this.columns[i].hidden = false;}
		this.columnpicker.updateColumn();
	};


	/**
	 * Auto Number Column
	 */
	this.autoNumber = function ( ) {
		this.autoNum = true;
		//this.colAdd('NUM', this.num_title, this.options.autoNumSize, 'center', false, 'nomal', function ( row, cell, value, columnDef, dataContext ) {return ( row + 1 ).comma();});
		this.colAdd('NUM', this.num_title, this.options.autoNumSize, 'center', false, 'nomal');
	};

	/**
	 * First Colnmn CheckBox
	 */
	this.onCheckBox = function ( ) {
		this.colAdd('C', '', 30, 'center', false, 'check');
	};

	/**
	 * Un Selected Row
	 */
	this.unSelectAll = function ( ) {
		this.grid.getSelectionModel().setSelectedRanges([]);
	};

	/**
	 * 컬럼 정보 초기화
	 */
	this.colInit = function ( ) {
		this.columns = [];
		this.grid.setColumns( this.columns );
		this.Cols = 0;
		this.columns = this.grid.getColumns();
	};

	/**
	 * 컬럼 정보 초기화
	 */
	this.setCols = function ( len ) {
		this.columns.length = len;
		this.grid.setColumns( this.columns );
		this.Cols = len;
		this.columns = this.grid.getColumns();
	};

	this.checkBoxCol = function ( colKey, colName, colWidth, hidden ) {
		var checkboxSelector = new Slick.CheckboxSelectColumn({ cssClass : "slick-cell-checkboxsel" });
		var check = checkboxSelector.getColumnDefinition( );
		check.name = "<input type='checkbox' name='" + colKey + "'>" + colName;
		check.width = colWidth;
		check.resizable = false;
		check.cssClass = 'slick-center';
		check.hidden = hidden;
		this.grid.registerPlugin(checkboxSelector);
		return check;
	};

	this.initData = function ( msg ) {
		if ( msg == undefined ) msg = slickGridJS.searching;
		this.data = [];
		this.render( );
		$(this.target + ' .grid-canvas' ).html ( '<div class="ui-widget-content slick-row even nodata_msg"><div class="slick-cell l0 r'+(this.columns.length-1)+' slick-init-msg">'+msg+'</div></div>' );
	};

	/**
	 * JSON Array 데이터 일괄 적용
	 * 한번에 조회된 데이터를 일괄 출력 한다.
	 * @param data JSONArray
	 */
	this.setData = function ( data ) {
		this.removeSorting();
		this.data = [];
		this.overlapData = [];
		this.render( );
		this.data = data;
		
		for ( var i=0, t=data.length ; i < t ; i++ ) {
			if(data[i].overlap != undefined) {
				for ( var j=0, t2=data[i].overlap.length ; j < t2 ; j++ ) {
					this.overlapData.push(data[i].overlap[j]);
				}
			}
		}
		
		this.setAutoNum();
		$(this.target + '_statusbar .nextpage').html('');
		$(this.target + '_statusbar .status_selno').html('No: 0 / ');
		if ( this.data.length == 0 ) {
			$(this.target + '_statusbar .status_count').html('Total Record: ' + 0);
			this.initData(slickGridJS.noData);
		}
		else {
			$(this.target + '_statusbar .status_count').html('Total Record: ' + ( this.data.length + this.overlapData.length).comma());
			this.render( );
		}
		this.Row = -1;
	};

	/**
	 * JSON Array 데이터 추가 적용
	 * 기존에 조회된 데이터 밑으로 추가 된다.
	 * @param row JSONObject
	 */
	this.addData = function ( row ) {
		for ( var i=0; i < row.length; i++) {
			this.data.push(row[i]);
		}
		this.setAutoNum();
		this.Rows = this.data.length;
		this.render( );
	};
	this.render = function ( ) {
		$(this.target + ' .grid-canvas .nodata_msg' ).remove();
		this.Rows = this.data.length + this.overlapData.length;
		this.grid.invalidateRow(this.data.length);
		this.grid.setData( this.data, true );
		this.grid.updateRowCount();
		this.grid.render( );
		this.grid.resizeCanvas( );
		this.unSelectAll( );
	};

	/**
	 * 스크롤 처리로 페이징을 할때 사용된다.
	 * 기존에 조회된 데이터 밑으로 추가 된다.
	 * @param row JSONObject
	 */
	this.appendData = function ( data ) {
		var overlap = [];
		
		for ( var i=0, t=data.length ; i < t ; i++ ) {
			if(data[i].overlap != undefined) {
				for ( var j=0, t2=data[i].overlap.length ; j < t2 ; j++ ) {
					overlap.push(data[i].overlap[j]);
					this.overlapData.push(data[i].overlap[j]);
				}
			}
			this.data.push ( data[i] );
		}
		if ( this.loadingPage == 0 ) this.setData(this.data);
		else {
			this.setAutoNum();
			this.Rows = this.data.length + this.overlapData.length;
			this.grid.invalidateRow(this.data.length);
			this.grid.updateRowCount();
			this.grid.resizeCanvas();
			this.grid.render();
		}
		
		$(this.target + '_statusbar .nextpage').html('');
		if ( data.length < this.pageSize ) {
			if((overlap.length + data.length) < this.pageSize) {
				$(this.target + '_statusbar .status_count').html('Total Record: ' + this.Rows.comma());
			} else {
				if ( this.rtnNextPageFunc != null ){
					$(this.target + '_statusbar .status_count').html('Record ' + this.Rows.comma() + ' (scroll for more)');
					$(this.target + '_statusbar .nextpage').html('<a href="javascript:;" id="'+this.more_btn+'">Next</a>');
				} else $(this.target + '_statusbar .status_count').html('Total Record: ' + this.Rows.comma());
			} 
		} else {
			if ( this.rtnNextPageFunc != null ){
				$(this.target + '_statusbar .status_count').html('Record ' + this.Rows.comma() + ' (scroll for more)');
				$(this.target + '_statusbar .nextpage').html('<a href="javascript:;" id="'+this.more_btn+'">Next</a>');
			} else {
				$(this.target + '_statusbar .status_count').html('Total Record: ' + this.Rows.comma());
			}
		}
		
		var obj = this;
		$('#'+this.more_btn).click(function(){
			try{eval( obj.rtnNextPageFunc( data[data.length-1] ) );}catch(e){};
		});
	};

	this.setAutoNum = function() {
		if(this.autoNum) {
			for(var i=0, t=this.data.length ; i < t ; i++){
				if(this.data[i]['NUM'] == undefined ) this.data[i]['NUM'] = i+1;
			}
		}
	};

	/**
	 * 단일 Row 추가 방식
	 * JSON Object 형식으로 추가 한다.
	 * @param row JSONObject
	 */
	this.addRow = function ( row ) {
		this.data.push(row);
		this.setAutoNum();
		this.render( );
		return this.data.length-1;
	};


	this.deleteSelectedRows = function ( ) {
		var selectedIndexes = this.grid.getSelectedRows( );
		for ( var i=selectedIndexes.length-1 ; i >= 0 ; i-- ) {
			this.data.remove(selectedIndexes[i], 0);
		}
		this.setData(this.data);
	};

	//선택된 Row 배열로 반환
	this.getSelectedRows = function ( ) {
		var selectedData = [];
		var selectedIndexes = this.grid.getSelectedRows( );
		selectedIndexes.sort(function(a, b){return a-b});
		for ( var i=0 ; i < selectedIndexes.length ; i++ ) {
			selectedData.push( this.getRowData(selectedIndexes[i]));
		}
		return selectedData;
	};
	//선택된 Row의 Key값을 배열로 반환
	this.getSelectedKey = function ( key ) {
		var selectedData = [];
		var selectedIndexes = this.grid.getSelectedRows( );
		selectedIndexes.sort(function(a, b){return a-b});
		for ( var i=0 ; i < selectedIndexes.length ; i++ ) {
			selectedData.push( this.getRowData(selectedIndexes[i])[key] );
		}
		return selectedData;
	};

	//전체 Row의 Key값을 배열로 반환
	this.getKeyData = function ( key ) {
		var selectedData=[];
		for ( var i=0, total=this.getData( ).length ; i < total ; i++ ) {
			selectedData.push(this.getRowData(i)[key]);
		}
		return selectedData;
	};


	//Row 선택(rows:숫자,배열)
	this.setSelectAll = function ( ) {
		var rows = [];
		for (var i=0 ; i < this.Rows ; i++){
			rows.push(i);
		}
		this.setSelectedRows(rows);
	};

	//선택된 Row Index 번호
	this.getSelectedIndex = function ( ) {
		return this.grid.getSelectedRows( ).sort();
	};

	//Row 선택(rows:숫자,배열)
	this.setSelectedRows = function ( rows ) {
		if ( typeof rows === 'number' ) this.grid.setSelectedRows([rows]);
		else this.grid.setSelectedRows(rows);
	};
	this.getValue = function ( row, col ) {
		if ( typeof col === 'number' ) return this.nvl(this.grid.getDataItem(row)[this.ColKey(col)]);
		else return this.nvl(this.grid.getDataItem(row)[col]);
	};
	this.nvl = function ( val ) {
		return ( val == null || val == undefined ) ? '' : val;
	};

	/**
	 * Auto Data Load 사용 시 한번에 로드될 건수
	 */
	this.setPageSize = function ( size ) {
		this.pageSize = size;
	};

	this.setValue = function ( row, col, text ) {
		var data = this.getRowData(row);

		if ( typeof col === 'number' ) data[this.ColKey(col)] = text;
		else data[col] = text;

		this.grid.invalidateRow(row);
		this.grid.render();
	};
	this.getRowData = function ( row ) {
		return this.grid.getDataItem(row);
	};
	this.ColKey = function ( col ) {
		if ( this.grid.getColumns()[col] == undefined || this.grid.getColumns().length == 0 ) return -1;
		else return this.grid.getColumns()[col].id;
	};

	this.ColNm = function ( col ) {
		if ( this.grid.getColumns()[col] == undefined || this.grid.getColumns().length == 0 ) return -1;
		else return this.grid.getColumns()[col].name;
	};

	this.ColIndex = function ( key ) {
		return this.grid.getColumnIndex( key ) == undefined ? -1 : this.grid.getColumnIndex( key );
	};
	this.Select = function ( row, col ) {
		if ( row == -1 || col == -1 ) this.grid.resetActiveCell();
		else this.grid.setActiveCell( row, col );
	};
	this.getData = function ( ) {
		return this.grid.getData( );
	};
	this.getDataKey = function ( key ) {
		var selectedData = [];
		var rows = this.getData( );
		for ( var i=0 ; i < rows.length ; i++ ) {
			selectedData.push( rows[i][key] );
		}
		return selectedData;
	};
	this.getCols = function ( ) {
		return this.grid.getColumns();
	};

	this.toJson = function ( ) {
		return this.grid.getData( );
	};
	this.getHeader = function ( ) {
		if ( this.columnpickerUsed ) return this.columnpicker.getAllColumns();
		else return this.getCols();
	};
	this.getHeaderId = function ( ) {
			return this.getCols();
	};
	this.saveHeader = function ( ) {
		var header = [];
		var cols = this.columnpicker.getAllColumns();
		for ( var i=0 ; i < cols.length ; i++ ) {
			header.push({id:cols[i].field, width:cols[i].width, hidden:cols[i].hidden});
		}

		ui.postJson({
			url : 'updateGridHeader.xcn',
			gridId 	: this.commonId == '' ? this.id : this.commonId,
			header 	: JSON.stringify(JSON.stringify(header)),
			success : function(data, total) {
			},
			error : function(status, message) {
				ui.alertMsg('error:' + status);
			},
			complete : function() {
			}
		});
	};
	this.loadHeader = function (mysql_load) {
		var col_tmp = [];
		var cols = this.columns;
		if ( mysql_load == undefined || mysql_load ) {
			ui.get({
				url 		: 'getGridHeader.xcn',
				gridId 		: this.commonId == '' ? this.id : this.commonId,
				asyncFlag 	: false,
				success 	: function(data, total) {
					if ( data == null ) return;
					var header = JSON.parse(JSON.parse(data.header));
					for ( var i=0 ; i < header.length ; i++ ){
						for ( var j=0 ; j < cols.length ; j++ ) {
							if ( header[i].id == cols[j].id || ( header[i].id == 'sel' && cols[j].id == '_checkbox_selector' ) ) {
								cols[j].width = header[i].width;
								cols[j].hidden = header[i].hidden;
								col_tmp.push( cols[j] );
								break;
							}
						}
					}
					for ( var i=0 ; i < cols.length ; i++ ) {
						if ( cols[i].id == '_checkbox_selector' ) continue;
						var flag = true;
						for ( var x=0 ; x < header.length ; x++ ) {
							if ( header[x].id == cols[i].id ) {
								flag = false;
								break;
							}
						}
						if ( flag ) col_tmp.push( cols[i] );
					}
				},
				error : function(status, message) {
					ui.alertMsg('error:' + status);
				},
				complete : function() {
				}
			});
		} else {
			this.columnpickerUsed = false;
		}
		this.colInit();
		if ( col_tmp.length > 0 ) this.columns = col_tmp;
		else this.columns = cols;
		this.setColumns();
	};

	this.getBodyEXCEL = function (selectOption) {
		var data = [];
		if (selectOption == "Y") data = this.getSelectedRows();
		if (data.length == 0) data = this.grid.getData();
		console.log(data);
		var result = JSON.parse(JSON.stringify(data));

		for (var j = 0; j < data.length; j++) {
			for (var i = 0; i < this.columns.length; i++) {
				var columnId = this.columns[i].id;
				if ($.isArray(data[j][columnId])) {
					if (this.columns[i].formatter == undefined) {
						result[j][columnId] = result[j][columnId].join(', ');
					} else {
						var org = this.columns[i].formatter(j, i, nvl(data[j][columnId]));
						var str = $("#replace_html").html(org).text().trim();
						result[j][columnId] = (str == '') ? '' : str; // 빈 문자열 그대로 유지
					}
				} else {
					if ( this.columns[i].formatter == undefined ) continue;
					var org = this.columns[i].formatter( j, i, data[j][this.columns[i].id] );
					var str = $("#replace_html").html(org).text().trim();
					if(str == '') continue;
					result[j][this.columns[i].id] = str;
				}
			}
		}
		return JSON.stringify(result);
	};

	this.getHeaderEXCEL = function ( ) {
		var result = [];
		var tmpWidth = 0;
		var cols = this.getHeader();
		for ( var i=0 ; i < cols.length ; i++ ) {
			if(cols[i].cssClass == 'realHidden') continue;
			if( cols[i].hidden ) continue;
			var align = cols[i].cssClass.split(' ')[0];
			if ( align == 'slick-center' ) align = 'center';
			else if ( align == 'slick-left' ) align = 'left';
			else if ( align == 'slick-right' ) align = 'right';
			if ( cols[i].id == '_checkbox_selector' ) continue;
			if ( cols[i].length -1 == i ) result.push({key:cols[i].id,title:cols[i].name,width:tmpWidth,align:align});
			else result.push({key:cols[i].id,title:cols[i].name,width:cols[i].width,align:align});

			tmpWidth = cols[i].width;
		}
		return JSON.stringify(result);
	};
	//Progress on
	this.on = function ( ) {
		if ( $('#loading_div_' + this.id).get().length > 0 ){
			//$('#loading_div_' + this.id).remove(); //한번 지우고 새로 처리 해야 한다. (높이값이 달라질 경우 처리 위해..)
		}
		if ( $('#loading_div_' + this.id).get().length == 0 ) {
			var width = $( this.target ).width( );
			var height = $( this.target ).height( );
			var offset = $( this.target ).offset( );
			$(this.target).append( '<div class="loading_div_grid" id="loading_div_' + this.id + '"><img id="loading_img_' + this.id + '" src="'+this.root+'/img/loading/Loading.gif"/></div>');
			$('#loading_div_' + this.id).css({
				"position" : "absolute",
				"top" : "0px",
				"left" : "0px",
				"right" : "0px",
				"bottom" : "0px",
				"background-color" : "#F0F0F0",
				"opacity" : "0.3",
				"z-index" : "998",
				"text-align" : "center"
			});
			$('#loading_img_' + this.id).css({
				"margin-top" : ((height / 2) - 46) + "px",
				"width" : "69px"
			});
		} else {
			var height = $( this.target ).height( );
			$('#loading_img_' + this.id).css({
				"margin-top" : ((height / 2) - 46) + "px",
				"width" : "69px"
			});
			$('#loading_div_' + this.id).show( );
		}
	};

	/**
	 * 전체 프로그레스바 표시 종료
	 */
	this.offAll = function ( ) {
		$('.loading_div_grid').hide( );
	};

	/**
	 * 프로그레스바 표시 종료
	 */
	this.off = function ( ) {
		$('#loading_div_' + this.id).hide( );
	};

	this.onColumnsResized = function(){
		this.saveHeader();
	};
	this.onColumnsReordered = function(){
		this.saveHeader();
	};
	this.onColumnsVisibled = function(){
		this.saveHeader();
	};

	this.print = function(title, pMenuId, menuId){
		this.printPlugin.printToWindow(fnOpenWindow(this.root + '/print.do', 'print_window', 870, 600, 'scroll'), title);

		ui.get({
			url : 'insertAuditListPrint.xcn',
			pMenuId : pMenuId,
			menuId : menuId,
			success : function ( data, total ) {

			},
			error : function (status, message) {
				ui.alertMsg(message);
			},
			complete : function (){

			}
		});
	};

	this.removeSorting = function() {
		$(this.target).find('span').removeClass("slick-sort-indicator-desc").removeClass('slick-sort-indicator-asc');
	};


	this.grid.onSort.subscribe(function(e, args) {
		var cols = args.sortCols;
		var data = this.__parent.data;
		if( data.length == 0 ) return;
		try{
			//this.__parent.onSortX(cols, data);
			data.sort(function(dataRow1, dataRow2) {
				for ( var i = 0, l = cols.length; i < l; i++) {
					var field = cols[i].sortCol.field;
					var sortCol = cols[i].sortCol.sortCol;
					var result = 0;
					if(sortCol!=undefined && sortCol.sortField!=undefined) field = sortCol.sortField;

					var sign = cols[i].sortAsc ? 1 : -1;
					var value1 = dataRow1[field], value2 = dataRow2[field];
					if(value1==undefined) value1 = '';
					if(value2==undefined) value2 = '';
					if(sortCol!=undefined && sortCol.sorter!=undefined) {
						result = sortCol.sorter(value1, value2, sign);
					} else {
						if( typeof value1 == 'number' && typeof value2 == 'number') {
							result = sortUtil.numeric(value1, value2, sign);
						} else {
							result = sortUtil.string(value1, value2, sign);
						}
					}
					if (result != 0) return result;
				}
				return 0;
			});
		} catch(e) {
			console.log(e);
		};
		this.__parent.render();
	});


	this.moveRow = function(fromIndex, toIndex) {
		this.data.move(fromIndex, toIndex);
		this.setData(this.data);
	};

	this.reSize = function ( ) {
		var total = 0;
		if ( this.grid.getColumns() == 0 ) return;
		this.columns = this.grid.getColumns();
		for ( var i=0 ; i < this.columns.length ; i++ ) {
			total += this.columns[i].width;
		}
		if ( total >= $( this.target + ' .slick-viewport').width() ) return;
		var margin = $( this.target + ' .slick-viewport').width() - total;
		var w = this.columns[this.columns.length-1].width;
		this.columns[this.columns.length-1].width = w + margin-17;
		this.grid.setColumns( this.columns );
	};


	/**
	 * Event Area...
	 */
	$(this.target).sizeChanged( function(element){
		for ( var i=0 ; i < window.__grids.length ; i++ ) {
			if( $(element).attr('id') == window.__grids[i].id) {
				window.__grids[i].grid.resizeCanvas( );
			}
		}
	});

	this.grid.onViewportChanged.subscribe(function(scope, e, args){
		var data = this.__parent.data;
		var rows = data.length;
		var overlapData = this.__parent.overlapData;
		var overlapDataRows = overlapData.length;
		var bottom = this.__parent.grid.getViewport().bottom;
		var allLength = overlapData.length + data.length;
		if ( data.length % this.__parent.pageSize > 0 ) {
			if( allLength % this.__parent.pageSize > 0 ) return;
		}
		if(rows <= bottom && data.length > 0 || allLength <= bottom && allLength > 0 ) {
			try{eval( this.__parent.rtnNextPageFunc( data[data.length-1] ) );}catch(e){};
		}
	});

	this.OldCol = -1;
	this.OldRow = -1;
	this.grid.onActiveCellChanged.subscribe( function(e,args){
		this.__parent.Col = args.cell;
		this.__parent.Row = args.row;
		try{this.__parent.onActiveCellChanged( );}catch(e){};

		if ( args.cell != this.__parent.OldCol ) {
			this.__parent.OldCol = args.cell;
		}
		if ( args.row != this.__parent.OldRow ) {
			try{this.__parent.onActiveRowChanged( );}catch(e){};
			this.__parent.OldRow = args.row;
			this.__parent.setSelectedRows([args.row]);//체크박스로 선택 되어있던 Row 해제
			$(this.__parent.target + '_statusbar .status_selno').html('No: ' + (this.__parent.Row + 1) + ' / ');
		}
	});

	this.grid.onViewportChanged.subscribe( function(e,args){
		$('.slick-viewport .slick-cell.selected').parent().addClass('selected');
	});
	this.grid.onSelectedRowsChanged.subscribe( function(e,args){
		window.setTimeout(function(){
			$('.slick-viewport .slick-row').removeClass('selected');
			$('.slick-cell.selected').parent().addClass('selected');
		}, 10);
	});

	this.grid.onClick.subscribe( function(e,args){
		this.__parent.Col = args.cell;
		this.__parent.Row = args.row;
		this.__parent.OldRow = args.row;
		if(e.target.nodeName!='INPUT'){
			//this.__parent.setSelectedRows([args.row]);//체크박스로 선택 되어있던 Row 해제
		}
		var obj=this;
		setTimeout(function(){
			$(obj.__parent.target + '_statusbar .status_selno').html('No: ' + (obj.__parent.Row + 1) + ' / ');
			try{obj.__parent.onClick(args.row,args.cell,e);}catch(e){};
		}, 20);
	});
	this.grid.onDblClick.subscribe( function(e,args){
		this.__parent.Col = args.cell;
		this.__parent.Row = args.row;
		try{this.__parent.onDblClick( );}catch(e){};
		e.stopPropagation();
	});
	this.grid.onContextMenu.subscribe(function (e) {
		var args = this.__parent.grid.getCellFromEvent(e);
		if (!args) {
			return;
		}
		this.__parent.Col = args.cell;
		this.__parent.Row = args.row;
		/*if(e.target.nodeName!='INPUT'){
			this.__parent.setSelectedRows([args.row]);//체크박스로 선택 되어있던 Row 해제
		}*/
		
		
		var len = this.__parent.grid.getSelectedRows( ).length;
		if( len <= 1 || ( len > 1 && e.target.className.indexOf('selected') <= -1 ) ) {
			this.__parent.setSelectedRows([args.row]);
		}
		//$('.slick-viewport .slick-row').removeClass('active');
		try{this.__parent.onContextMenu(args.row,args.cell,e);}catch(e){};
		e.stopPropagation();
	});

}



Array.prototype.remove = function(from, to) {
	var rest = this.slice((to || from) + 1 || this.length);
	this.length = from < 0 ? this.length + from : from;
	return this.push.apply(this, rest);
};

Array.prototype.insert = function(index) {
    this.splice.apply(this, [index, 0].concat(
        Array.prototype.slice.call(arguments, 1)));
    return this;
};
Array.prototype.move = function(from, to) {
    this.splice(to, 0, this.splice(from, 1)[0]);
};

(function ($) {
	$.fn.sizeChanged = function (handleFunction) {
	    var element = this;
	    var lastWidth = element.width();
	    var lastHeight = element.height();
	    setInterval(function () {
	        if (lastWidth === element.width()&&lastHeight === element.height())
	            return;
	        if (typeof (handleFunction) == 'function') {
	            handleFunction(element);
	            lastWidth = element.width();
	            lastHeight = element.height();
	        }
	    }, 100);
	    return element;
	};
}(jQuery));

function objToString (obj) {
    var str = '';
    for (var p in obj) {
        if (obj.hasOwnProperty(p)) {
            str += p + '::' + obj[p] + '\n';
        }
    }
    return str;
}

$.fn.hasScrollBar = function() {
	return (this.prop("scrollHeight") == 0 && this.prop("clientHeight") == 0) || (this.prop("scrollHeight") > this.prop("clientHeight"));
};