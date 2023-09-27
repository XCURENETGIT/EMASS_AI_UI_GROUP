(function ($) {
  function SlickColumnPicker(columns, grid, options) {
    var $menu;
    var columnCheckboxes=null;
    var defaults = {
    	fadeSpeed:0
    };
    function init() {
      $('#'+grid.id + '_columnpicker').remove();
      $('#'+grid.id + '_columnpicker_overlay').remove();
      grid.onHeaderContextMenu.subscribe(handleHeaderContextMenu);
      grid.onColumnsReordered.subscribe(updateColumnOrder);
      grid.onColumnsResized.subscribe(updateColumnWidth);
      options = $.extend({}, defaults, options);
      $menu = $("<span class='slick-columnpicker' style='display:none;position:absolute;z-index:1000001;' />").appendTo(document.body).attr('id', grid.id + '_columnpicker');
      $menu.bind("click", updateColumn);
      handleHeaderContextMenu();
      updateColumn();
    }
    function handleHeaderContextMenu(e, args) {
      if(e) e.preventDefault();
      $menu.empty();
      updateColumnOrder(false);
      columnCheckboxes = [];
      var $li, $input;
      for (var i = 0; i < columns.length; i++) {
        $li = $("<li />").appendTo($menu);
        $input = $("<input type='checkbox' />").data("column-id", columns[i].id).val(columns[i].id);
        columnCheckboxes.push($input);
        if (grid.getColumnIndex(columns[i].id) != null) {
        	$input.attr("checked", "checked");
        }
        var name = columns[i].name;
        if ( columns[i].id == '_checkbox_selector' ) name = 'Check';
        $("<label />").text(name).prepend($input).appendTo($li);
      }

      if(e){
    	  $menu.css("top", e.pageY).css("left", e.pageX).fadeIn(options.fadeSpeed);
    	  var bg = $('<div></div>').css({
  			left : 0,
  			top : 0,
  			width : '100%',
  			height : '100%',
  			position : 'absolute',
  			zIndex : 1000000
  		}).appendTo(document.body).bind('contextmenu mousedown', function() {
  			bg.remove();
  			$($menu).fadeOut(options.fadeSpeed);
  			return false;
  		}).attr('id', grid.id + '_columnpicker_overlay');
      }
    }

    function updateColumnWidth() {
    	var col = grid.getColumns();
    	for ( var i=0 ; i < col.length ; i++ ) {
    		for ( var x=0 ; x < columns.length ; x++ ) {
    			if ( col[i].field == columns[x].id ) {
    				columns[x].width = col[i].width;
    				break;
    			}
    		}
    	}
    	grid.__parent.onColumnsResized();
    }

    function updateColumnOrder(flag) {
      var current = grid.getColumns().slice(0);
      var ordered = new Array(columns.length);
      for (var i = 0; i < ordered.length; i++) {
        if ( grid.getColumnIndex(columns[i].id) === undefined ) {
          ordered[i] = columns[i];
        } else {
          ordered[i] = current.shift();
        }
      }
      columns = ordered;
      if ( flag != false ) grid.__parent.onColumnsReordered();
    }

    function updateColumn(e) {
    	if ( e && $(e.target).is(":checkbox") ) {
    		$('#'+grid.id + '_columnpicker :checkbox[value="' + $(e.target).val() + '"]').attr('checked', $(e.target).is(":checked") );
    	}
    	var visibleColumns = [];
        $('#'+grid.id + '_columnpicker :checkbox').each(function (i, val) {
        	if ($(this).attr('checked') == 'checked' || $(this).is(':checked') ) {
        		visibleColumns.push(columns[i]);
        	}
        });
        if (!visibleColumns.length) {
        	$('#'+grid.id + '_columnpicker :checkbox').each(function (i, e) {
        		$(this).attr("checked", true);
        		visibleColumns.push(columns[i]);
        	});
        }
        grid.setColumns(visibleColumns);
        if ( e && $(e.target).is(":checkbox") ) grid.__parent.onColumnsVisibled();
        
    }

    function getAllColumns() {
    	for ( var i=0 ; i < columns.length ; i++ ) {
    		columns[i].hidden = true;
    	}
    	if ( columnCheckboxes != null ) {
    		$('#'+grid.id + '_columnpicker :checkbox').each(function (i, e) {
	    		for ( var j=0 ; j < columns.length ; j++ ) {
	    			if ( ( $(this).attr('checked') == 'checked' || $(this).is(':checked') ) && $(this).val() == columns[j].id ) {
	    				columns[j].hidden = false;
	    				break;
	    			}
	    		}
	    	});
    	}
      return columns;
    }
    init();
    return {"getAllColumns": getAllColumns, "updateColumn":updateColumn, "handleHeaderContextMenu":handleHeaderContextMenu};
  }
  // Slick.Controls.ColumnPicker
  $.extend(true, window, { Slick:{ Controls:{ ColumnPicker:SlickColumnPicker }}});
})(jQuery);
