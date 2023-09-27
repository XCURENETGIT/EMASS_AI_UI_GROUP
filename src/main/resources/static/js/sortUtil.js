var sortUtil = {
	string : function(a, b, sign) {
	    return sign * (a === b ? 0 : (a > b ? 1 : -1));
	},
	numeric : function(a, b, sign) {
	    var x = (isNaN(a) || a === "" || a === null) ? -99e+10 : parseFloat(a);
	    var y = (isNaN(b) || b === "" || b === null) ? -99e+10 : parseFloat(b);
	    return sign * (x === y ? 0 : (x > y ? 1 : -1));
	},
	rating : function(a, b, sign) {
	    var xrow = a, yrow = b;
	    var x = xrow[3], y = yrow[3];
	    return sign * (x === y ? 0 : (x > y ? 1 : -1));
	},
	dateIso : function(a, b, sign) {
	    var regex_a = new RegExp("^((19[1-9][1-9])|([2][01][0-9]))\\d-([0]\\d|[1][0-2])-([0-2]\\d|[3][0-1])(\\s([0]\\d|[1][0-2])(\\:[0-5]\\d){1,2}(\\:[0-5]\\d){1,2})?$", "gi");
	    var regex_b = new RegExp("^((19[1-9][1-9])|([2][01][0-9]))\\d-([0]\\d|[1][0-2])-([0-2]\\d|[3][0-1])(\\s([0]\\d|[1][0-2])(\\:[0-5]\\d){1,2}(\\:[0-5]\\d){1,2})?$", "gi");
	    if (regex_a.test(a) && regex_b.test(b)) {
	        var date_a = new Date(a);
	        var date_b = new Date(b);
	        var diff = date_a.getTime() - date_b.getTime();
	        return sign * (diff === 0 ? 0 : (date_a > date_b ? 1 : -1));
	    }
	    else {
	        var x = a, y = b;
	        return sign * (x === y ? 0 : (x > y ? 1 : -1));
	    }
	},
	ip : function(a, b, sign) {
		var d = a.split('.');
		var e = b.split('.');
		d = ((((((+d[0])*256)+(+d[1]) )*256)+(+d[2]) )*256)+(+d[3]);
		e = ((((((+e[0])*256)+(+e[1]) )*256)+(+e[2]) )*256)+(+e[3]);
	    return sortUtil.numeric(d, e, sign);
	},
	inout : function(a, b, sign) {
		var d = a.substring(a.indexOf('[')+1,a.indexOf('/'));
		var e = b.substring(b.indexOf('[')+1,b.indexOf('/'));
		
		if( d == e ) {
			var f = a.substring(a.indexOf('/')+1,a.indexOf(']'));
			var g = b.substring(b.indexOf('/')+1,b.indexOf(']'));
			
			if( f == g ) {
				var h = a.substring(a.indexOf(']')+1);
				var i = b.substring(b.indexOf(']')+1);
				return sortUtil.string(h, i, sign);
			}
			return sortUtil.numeric(f, g, sign);
		}
		return sortUtil.numeric(d, e, sign);
	}
};