// 단축키 세팅
(function($) {
	$.fn.easyHotkey = function(options)
	{
		var option = $.extend({
			cssKey : "hotkey_disp",
			shape : "circle",
			bgColor : "#ff0000",
			fontColor : "#ffffff",
			size : "20px",
			zindex : "1009",
			side : "left",

			getDiameter : function() {
				return parseInt(this.size);
			},
			getRadius : function() {
				return parseInt(this.size) / 2;
			}
		}, options);

		// 단축키 등록 타겟 엘리먼트 반환 - 추후 기능 확장을 위해 함수로 만들어놓음.
		var $root = $(this);
		var $target = function() {
			return $root;
		};

		// CSS 생성/등록
		var createCSS = function() {
			var css = "<style>."+option.cssKey+" {" +
				"position:absolute;" +
				"font-weight:bolder;" +
				"font-size: " + parseInt(option.getDiameter() * 2 / 3) + "px;" +
				"color:"+option.fontColor+";" +
				"text-align:center;" +
				"z-index:"+option.zindex+";" +
				"line-height:"+option.size+";" +
				"height: "+option.size+";" +
				"width: "+option.size+";" +
				"background-color: "+option.bgColor+";" +
				"-webkit-border-radius: "+option.getRadius()+"px;" +
				"-moz-border-radius: "+option.getRadius()+"px;  " +
				"border-radius: "+option.getRadius()+"px;" +
			"}</style> ";
			$('head').append(css);
		};

		// 단축키 엘리먼트 생성
		var makeHotkey = function(e, text) {
			return $('<div>',{
				"class": option.cssKey,
				css: {
					"top": '-5px',
					"left": '-15px'
				},
				text: text
			});
		};

		// 단축키 생성/등록
		var createHotkeys = function() {
			var $hotkeys = $('.'+option.cssKey);
			if($hotkeys.length) {
				$hotkeys.show();
			}else {
				createCSS();
				$target().each(function(i) {
					var id = $(this).attr('id');
					var accesskey = $(this).attr('accesskey');
					if(accesskey!=undefined) {
						$(this).append(makeHotkey($(this), accesskey));
					}
				});
			}
		};

		// 단축키 숨김
		var hideHotkeys = function() {
			$('.'+option.cssKey).hide();
		};

		// 단축키 제거
		var removeHotkeys = function() {
			var $hotkeys = $('.'+option.cssKey);
			if($hotkeys.length) $hotkeys.remove();
		};

		// 키를 누를때
		$(document).keydown(function( event ) {
			if( event.ctrlKey && event.altKey && $('#bootstrap_alert').length == 0 && $('#bootstrap_confirm').length == 0 ) {
				event.stopImmediatePropagation();
				createHotkeys();

				var modal = false;
				$(".modal").each(function(){
					if($(this).is(':visible')) modal = true;
				});

				var indexCode = event.keyCode - 65;
				if(indexCode >= 0 /*&& indexCode < $('.'+option.cssKey).length*/) {
					if(modal) {
						var obj = $( ".modal:visible button[accesskey*='"+String.fromCharCode(event.keyCode)+"']" );
						if(obj.length==1) {
							$( ".modal:visible button[accesskey*='"+String.fromCharCode(event.keyCode)+"']" ).click();
						} else {
							var lastObj=null;
							$(obj).each(function(){
								lastObj = $(this);
							})
							console.log('close popup');
							if(lastObj!=null) $(lastObj).click();
						}

					} else {
						var obj = $( "button[accesskey*='"+String.fromCharCode(event.keyCode)+"']" );
						if(obj.length==1) {
							obj.click();
						} else {
							$(obj).each(function(){
								if( $(this).parents('.modal').length == 0 ) $(this).click();
							});
						}
					}
					hideHotkeys();
				}
			}
		});

		// 키가 눌렀다 떨어질 때
		$(document).keyup(function( event ) {
			hideHotkeys();
		});
		
		// 창 크기 변경시 기존 등록된 단축키 제거
		window.onresize = function() {
			removeHotkeys();
		}
	};
})(jQuery);
