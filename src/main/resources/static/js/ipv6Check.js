
var ipv6Check = {
	normalize : function (a) {
		if (!ipv6Check._validate(a)) {
			return false;
		}
		var nh = a.split(/\:\:/g);
		if (nh.length > 2) {
			return false;
		}
		
		var sections = [];
		if (nh.length == 1) {
			// full mode
			sections = a.split(/\:/g);
			if (sections.length !== 8) {
				return false;
			}
		} else if (nh.length == 2) {
			// compact mode
			var n = nh[0];
			var h = nh[1];
			var ns = n.split(/\:/g);
			var hs = h.split(/\:/g);
			for (var i in ns) {
				sections[i] = ns[i];
			}
			for (var i = hs.length; i > 0; --i) {
				sections[7 - (hs.length - i)] = hs[i - 1];
			}
		}
		for (var i = 0; i < 8; ++i) {
			if (sections[i] === undefined) {
				sections[i] = '0000';
			}
			if (sections[i].length < 4) {
				sections[i] = '0000'.substring(0, 4 - sections[i].length) + sections[i];
			}
		}
		return sections.join(':');
	},
	abbreviate : function (a) {
		if (!ipv6Check._validate(a)) {
			return false;
		}
		a = ipv6Check.normalize(a);
		a = a.replace(/0000/g, 'g');
		a = a.replace(/\:000/g, ':');
		a = a.replace(/\:00/g, ':');
		a = a.replace(/\:0/g, ':');
		a = a.replace(/g/g, '0');
		var sections = a.split(/\:/g);
		var zPreviousFlag = false;
		var zeroStartIndex = -1;
		var zeroLength = 0;
		var zStartIndex = -1;
		var zLength = 0;
		for (var i = 0; i < 8; ++i) {
			var section = sections[i];
			var zFlag = (section === '0');
			if (zFlag && !zPreviousFlag) {
				zStartIndex = i;
			}
			if (!zFlag && zPreviousFlag) {
				zLength = i - zStartIndex;
			}
			if (zLength > 1 && zLength > zeroLength) {
				zeroStartIndex = zStartIndex;
				zeroLength = zLength;
			}
			zPreviousFlag = (section === '0');
		}
		if (zPreviousFlag) {
			zLength = 8 - zStartIndex;
		}
		if (zLength > 1 && zLength > zeroLength) {
			zeroStartIndex = zStartIndex;
			zeroLength = zLength;
		}
		//console.log(zeroStartIndex, zeroLength);
		//console.log(sections);
		if (zeroStartIndex >= 0 && zeroLength > 1) {
			sections.splice(zeroStartIndex, zeroLength, 'g');
		}
		//console.log(sections);
		a = sections.join(':');
		//console.log(a);
		a = a.replace(/\:g\:/g, '::');
		a = a.replace(/\:g/g, '::');
		a = a.replace(/g\:/g, '::');
		a = a.replace(/g/g, '::');
		//console.log(a);
		return a;
	},
	_validate : function (a) {
		//return /^[a-f0-9\\:]+$/ig.test(a);
		var expression = /((^\s*((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))\s*$)|(^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$))/;

		if (expression.test(a))
		{
			return true;
		}
		else
		{
			return false;
		}
	},
	isIP : function (addr) {
		return ipaddr.isValid(addr);
	},
	isRange : function (range) {
		try {
			var cidr = ipaddr.parseCIDR(range);
				return true;
		} catch(err) {
			return false;
		}
	},
	ver : function (addr) {
		try {
			var parse_addr = ipaddr.parse(addr);
			var kind = parse_addr.kind();
			
			if (kind === 'ipv4') {
				return 4; //IPv4
			} else if (kind === 'ipv6') {
				return 6; //IPv6
			} else {
				return 0; //not 4 or 6
			}
		} catch(err) {
			return 0; //not 4 or 6
		}
	},
	isV4 : function (addr) {
		return (ipv6Check.ver(addr) === 4);
	},
	isV6 : function (addr) {
		return (ipv6Check.ver(addr) === 6);
	},
	displayIP : function (addr) {
		try {
			var parse_addr = ipaddr.parse(addr);
			var kind = parse_addr.kind();
			
			if (kind === 'ipv4') //is a plain v4 address
			{
				return addr;
			}
			else if (kind === 'ipv6')
			{
				if (parse_addr.isIPv4MappedAddress()) //convert v4 mapped to v6 addresses to a v4 in it's original format
				{
					return parse_addr.toIPv4Address().toString();
				}
				else //is a v6, abbreviate it
				{
					return ipv6Check.abbreviate(addr);
				}
			}
			else
			{
				return null; //invalid IP address
			}
		}
		catch(err) {
			return null; //invalid IP address
		}
	},
	storeIP : function (addr) {
		try {
			var parse_addr = ipaddr.parse(addr);
			var kind = parse_addr.kind();
			
			if (kind === 'ipv4') //is a plain v4 address
			{
				return addr;
			}
			else if (kind === 'ipv6')
			{
				if (parse_addr.isIPv4MappedAddress()) //convert v4 mapped to v6 addresses to a v4 in it's original format
				{
					return parse_addr.toIPv4Address().toString();
				}
				else //is a v6, normalize it
				{
					return ipv6Check.normalize(addr);
				}
			}
			else
			{
				return ''; //invalid IP address
			}
		}
		catch(err) {
			return ''; //invalid IP address
		}
	},
	inRange : function inRange(addr, range) {
		if (typeof range === 'string')
		{
			if (range.indexOf('/') !== -1)
			{
				try {
					var range_data = range.split('/');
					
					var parse_addr = ipaddr.parse(addr);
					var parse_range = ipaddr.parse(range_data[0]);
					
					return parse_addr.match(parse_range, range_data[1]);
				}
				catch(err) {
					return false;
				}
			}
			else
			{
				addr = (isV6(addr)) ? ipv6Check.normalize(addr) : addr; //v6 normalize addr
				range = (isV6(range)) ? ipv6Check.normalize(range) : range; //v6 normalize range
				
				return ipv6Check.isIP(range) && addr === range;
			}
		}
		else if (range && typeof range === 'object') //list
		{
			for (var check_range in range)
			{
				if (ipv6Check.inRange(addr, range[check_range]) === true)
				{
					return true;
				}
			}
			return false;
		}
		else
		{
			return false;
		}
	}
};
/*(function ()
{
    var ipaddr = require('ipaddr.js'),
        ip6 = require('ip6');

    function isIP(addr)
    {
        return ipaddr.isValid(addr);
    }

    function isRange(range)
    {
        try {
            var cidr = ipaddr.parseCIDR(range);
            return true;
        } catch(err) {
            return false;
        }

    }

    function ver(addr)
    {
        try {
            var parse_addr = ipaddr.parse(addr);
            var kind = parse_addr.kind();

            if (kind === 'ipv4')
            {
                return 4; //IPv4
            }
            else if (kind === 'ipv6')
            {
                return 6; //IPv6
            }
            else
            {
                return 0; //not 4 or 6
            }

        }
        catch(err) {
            return 0; //not 4 or 6
        }

    }

    function isV4(addr)
    {
        return (ver(addr) === 4);
    }

    function isV6(addr)
    {
        return (ver(addr) === 6);
    }

    function storeIP(addr)
    {
        try {
            var parse_addr = ipaddr.parse(addr);
            var kind = parse_addr.kind();

            if (kind === 'ipv4') //is a plain v4 address
            {
                return addr;
            }
            else if (kind === 'ipv6')
            {
                if (parse_addr.isIPv4MappedAddress()) //convert v4 mapped to v6 addresses to a v4 in it's original format
                {
                    return parse_addr.toIPv4Address().toString();
                }
                else //is a v6, abbreviate it
                {
                    return ip6.abbreviate(addr);
                }

            }
            else
            {
                return null; //invalid IP address
            }

        }
        catch(err) {
            return null; //invalid IP address
        }

    }

    function displayIP(addr)
    {
        try {
            var parse_addr = ipaddr.parse(addr);
            var kind = parse_addr.kind();

            if (kind === 'ipv4') //is a plain v4 address
            {
                return addr;
            }
            else if (kind === 'ipv6')
            {
                if (parse_addr.isIPv4MappedAddress()) //convert v4 mapped to v6 addresses to a v4 in it's original format
                {
                    return parse_addr.toIPv4Address().toString();
                }
                else //is a v6, normalize it
                {
                    return ip6.normalize(addr);
                }

            }
            else
            {
                return ''; //invalid IP address
            }

        }
        catch(err) {
            return ''; //invalid IP address
        }

    }

    function inRange(addr, range)
    {
        if (typeof range === 'string')
        {
            if (range.indexOf('/') !== -1)
            {
                try {
                    var range_data = range.split('/');

                    var parse_addr = ipaddr.parse(addr);
                    var parse_range = ipaddr.parse(range_data[0]);

                    return parse_addr.match(parse_range, range_data[1]);
                }
                catch(err) {
                    return false;
                }
            }
            else
            {
                addr = (isV6(addr)) ? ip6.normalize(addr) : addr; //v6 normalize addr
                range = (isV6(range)) ? ip6.normalize(range) : range; //v6 normalize range

                return isIP(range) && addr === range;
            }
        }
        else if (range && typeof range === 'object') //list
        {
            for (var check_range in range)
            {
                if (inRange(addr, range[check_range]) === true)
                {
                    return true;
                }
            }
            return false;
        }
        else
        {
            return false;
        }
    }

    // Export public API
    var range_check = {};
    //Validate IP Address
    range_check.vaild_ip = range_check.vaildIp = isIP;
    range_check.valid_ip = range_check.validIp = isIP;
    range_check.isIP = isIP;

    //isV4 and isV6
    range_check.isV4 = isV4;
    range_check.isV6 = isV6;

    //storeIP, searchIP and displayIP
    range_check.storeIP = storeIP;
    range_check.searchIP = storeIP;
    range_check.displayIP = displayIP;

    //Validate Range
    range_check.valid_range = range_check.validRange = isRange;
    range_check.isRange = isRange;

    //Others
    range_check.ver = ver;
    range_check.in_range = range_check.inRange = inRange;

    module.exports = range_check;
}());*/