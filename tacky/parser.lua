if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
if _VERSION:find("5.1") then local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _temp = (function()
	local counter = 0
	local function pretty(x)
		if type(x) == 'table' and x.tag then
			if x.tag == 'list' then
				local y = {}
				for i = 1, #x do
					y[i] = pretty(x[i])
				end
				return '(' .. table.concat(y, ' ') .. ')'
			elseif x.tag == 'symbol' or x.tag == 'key' or x.tag == 'string' or x.tag == 'number' then
				return x.contents
			else
				return tostring(x)
			end
		elseif type(x) == 'string' then
			return ("%q"):format(x)
		else
			return tostring(x)
		end
	end
	local function pretty (x)
		if type(x) == 'table' and x.tag then
			if x.tag == 'list' then
				local y = {}
				for i = 1, #x do
					y[i] = pretty(x[i])
				end
				return '(' .. table.concat(y, ' ') .. ')'
			elseif x.tag == 'symbol' or x.tag == 'key' or x.tag == 'string' or x.tag == 'number' then
				return x.contents
			else
				return tostring(x)
			end
		elseif type(x) == 'string' then
			return ("%q"):format(x)
		else
			return tostring(x)
		end
	end
	return {
		['='] = function(x, y) return x == y end,
		['/='] = function(x, y) return x ~= y end,
		['<'] = function(x, y) return x < y end,
		['<='] = function(x, y) return x <= y end,
		['>'] = function(x, y) return x > y end,
		['>='] = function(x, y) return x >= y end,
		['+'] = function(x, y) return x + y end,
		['-'] = function(x, y) return x - y end,
		['*'] = function(x, y) return x * y end,
		['/'] = function(x, y) return x / y end,
		['%'] = function(x, y) return x % y end,
		['^'] = function(x, y) return x ^ y end,
		['..'] = function(x, y) return x .. y end,
		['slice'] = function(xs, start, finish)
			if not finish then finish = xs.n end
			if not finish then finish = #xs end
			return { tag = "list", n = finish - start + 1, table.unpack(xs, start, finish) }
		end,
		pretty = pretty,
		['gensym'] = function(name)
			if name then
				name = "_" .. tostring(name)
			else
				name = ""
			end
			counter = counter + 1
			return { tag = "symbol", contents = ("r_%d%s"):format(counter, name) }
		end,
		_G = _G, _ENV = _ENV, _VERSION = _VERSION,
		assert = assert, collectgarbage = collectgarbage,
		dofile = dofile, error = error,
		getmetatable = getmetatable, ipairs = ipairs,
		load = load, loadfile = loadfile,
		next = next, pairs = pairs,
		pcall = pcall, print = print,
		rawequal = rawequal, rawget = rawget,
		rawlen = rawlen, rawset = rawset,
		require = require, select = select,
		setmetatable = setmetatable, tonumber = tonumber,
		tostring = tostring, ["type#"] = type,
		xpcall = xpcall }
end)()
for k, v in pairs(_temp) do _libs["lib/lua/basic/".. k] = v end
local _temp = (function()
	return {
		['empty-struct'] = function() return {} end,
		['unpack'] = table.unpack or unpack,
		['iter-pairs'] = function(xs, f)
			for k, v in pairs(xs) do
				f(k, v)
			end
		end,
		concat = table.concat,
		insert = table.insert,
		move = table.move,
		pack = table.pack,
		remove = table.remove,
		sort = table.sort,
	}
end)()
for k, v in pairs(_temp) do _libs["lib/lua/table/".. k] = v end
local _temp = (function()
	return {
		byte = string.byte,
		char = string.char,
		dump = string.dump,
		find = string.find,
		format = string.format,
		gsub = string.gsub,
		len = string.len,
		lower = string.lower,
		match = string.match,
		rep = string.rep,
		reverse = string.reverse,
		sub = string.sub,
		upper = string.upper,
	}
end)()
for k, v in pairs(_temp) do _libs["lib/lua/string/".. k] = v end
local _temp = (function()
	return os
end)()
for k, v in pairs(_temp) do _libs["lib/lua/os/".. k] = v end
local _temp = (function()
	return io
end)()
for k, v in pairs(_temp) do _libs["lib/lua/io/".. k] = v end

_3d_1 = _libs["lib/lua/basic/="]
_2f3d_1 = _libs["lib/lua/basic//="]
_3c_1 = _libs["lib/lua/basic/<"]
_3c3d_1 = _libs["lib/lua/basic/<="]
_3e_1 = _libs["lib/lua/basic/>"]
_3e3d_1 = _libs["lib/lua/basic/>="]
_2b_1 = _libs["lib/lua/basic/+"]
_2d_1 = _libs["lib/lua/basic/-"]
_25_1 = _libs["lib/lua/basic/%"]
slice1 = _libs["lib/lua/basic/slice"]
error1 = _libs["lib/lua/basic/error"]
getmetatable1 = _libs["lib/lua/basic/getmetatable"]
print1 = _libs["lib/lua/basic/print"]
rawget1 = _libs["lib/lua/basic/rawget"]
rawset1 = _libs["lib/lua/basic/rawset"]
tostring1 = _libs["lib/lua/basic/tostring"]
type_23_1 = _libs["lib/lua/basic/type#"]
_23_1 = (function(x1)
	return x1["n"]
end)
concat1 = _libs["lib/lua/table/concat"]
emptyStruct1 = _libs["lib/lua/table/empty-struct"]
car1 = (function(xs1)
	return xs1[1]
end)
cdr1 = (function(xs2)
	return slice1(xs2, 2)
end)
list1 = (function(...)
	local xs3 = _pack(...) xs3.tag = "list"
	return xs3
end)
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
find1 = _libs["lib/lua/string/find"]
format1 = _libs["lib/lua/string/format"]
len1 = _libs["lib/lua/string/len"]
rep1 = _libs["lib/lua/string/rep"]
sub1 = _libs["lib/lua/string/sub"]
table_3f_1 = (function(x2)
	return (type_23_1(x2) == "table")
end)
list_3f_1 = (function(x3)
	return (type1(x3) == "list")
end)
nil_3f_1 = (function(x4)
	local r_11 = x4
	if r_11 then
		local r_21 = list_3f_1(x4)
		if r_21 then
			return (_23_1(x4) == 0)
		else
			return r_21
		end
	else
		return r_11
	end
end)
function_3f_1 = (function(x5)
	return (type1(x5) == "function")
end)
key_3f_1 = (function(x6)
	return (type1(x6) == "key")
end)
between_3f_1 = (function(val1, min1, max1)
	local r_71 = (val1 >= min1)
	if r_71 then
		return (val1 <= max1)
	else
		return r_71
	end
end)
type1 = (function(val2)
	local ty1 = type_23_1(val2)
	if (ty1 == "table") then
		local tag1 = val2["tag"]
		if tag1 then
			return tag1
		else
			return "table"
		end
	else
		return ty1
	end
end)
car2 = (function(x7)
	local r_131 = type1(x7)
	if (r_131 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_131), 2)
	else
	end
	return car1(x7)
end)
cdr2 = (function(x8)
	local r_141 = type1(x8)
	if (r_141 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_141), 2)
	else
	end
	return cdr1(x8)
end)
last1 = (function(xs4)
	local r_221 = type1(xs4)
	if (r_221 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_221), 2)
	else
	end
	return xs4[_23_1(xs4)]
end)
nth1 = rawget1
pushCdr_21_1 = (function(xs5, val3)
	local r_231 = type1(xs5)
	if (r_231 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_231), 2)
	else
	end
	local len2 = (_23_1(xs5) + 1)
	xs5["n"] = len2
	xs5[len2] = val3
	return xs5
end)
popLast_21_1 = (function(xs6)
	local r_241 = type1(xs6)
	if (r_241 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_241), 2)
	else
	end
	xs6[_23_1(xs6)] = nil
	xs6["n"] = (_23_1(xs6) - 1)
	return xs6
end)
cadr1 = (function(x9)
	return car2(cdr2(x9))
end)
charAt1 = (function(xs7, x10)
	return sub1(xs7, x10, x10)
end)
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
_23_s1 = len1
split1 = (function(text1, pattern1, limit1)
	local out1 = {tag = "list", n =0}
	local loop1 = true
	local start1 = 1
	local r_341 = nil
	r_341 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local _temp
			local r_351 = ("nil" == type_23_1(pos1))
			if r_351 then
				_temp = r_351
			else
				local r_361 = (nth1(pos1, 1) == nil)
				if r_361 then
					_temp = r_361
				else
					local r_371 = limit1
					if r_371 then
						_temp = (_23_1(out1) >= limit1)
					else
						_temp = r_371
					end
				end
			end
			if _temp then
				loop1 = false
				pushCdr_21_1(out1, sub1(text1, start1, _23_s1(text1)))
				start1 = (_23_s1(text1) + 1)
			else
				if car1(pos1) then
					pushCdr_21_1(out1, sub1(text1, start1, (car1(pos1) - 1)))
					start1 = (cadr1(pos1) + 1)
				else
					loop1 = false
				end
			end
			return r_341()
		else
		end
	end)
	r_341()
	return out1
end)
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_1(keys1) % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return sub1(key1["contents"], 2)
	end)
	local out2 = emptyStruct1()
	local r_481 = _23_1(keys1)
	local r_491 = 2
	local r_461 = nil
	r_461 = (function(r_471)
		local _temp
		if (0 < 2) then
			_temp = (r_471 <= r_481)
		else
			_temp = (r_471 >= r_481)
		end
		if _temp then
			local i1 = r_471
			local key2 = keys1[i1]
			local val4 = keys1[(1 + i1)]
			out2[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val4
			return r_461((r_471 + r_491))
		else
		end
	end)
	r_461(1)
	return out2
end)
invokable_3f_1 = (function(x11)
	local r_741 = function_3f_1(x11)
	if r_741 then
		return r_741
	else
		local r_751 = table_3f_1(x11)
		if r_751 then
			local r_761 = table_3f_1(getmetatable1(x11))
			if r_761 then
				return function_3f_1(getmetatable1(x11)["__call"])
			else
				return r_761
			end
		else
			return r_751
		end
	end
end)
compose1 = (function(f1, g1)
	local _temp
	local r_771 = invokable_3f_1(f1)
	if r_771 then
		_temp = invokable_3f_1(g1)
	else
		_temp = r_771
	end
	if _temp then
		return (function(x12)
			return f1(g1(x12))
		end)
	else
		return nil
	end
end)
succ1 = (function(x13)
	return (x13 + 1)
end)
pred1 = (function(x14)
	return (x14 - 1)
end)
number_2d3e_string1 = tostring1
error_21_1 = error1
print_21_1 = print1
fail_21_1 = (function(x15)
	return error_21_1(x15, 0)
end)
verbosity1 = struct1("value", 0)
setVerbosity_21_1 = (function(level1)
	verbosity1["value"] = level1
	return nil
end)
showExplain1 = struct1("value", false)
setExplain_21_1 = (function(value1)
	showExplain1["value"] = value1
	return nil
end)
colored1 = (function(col1, msg1)
	return _2e2e_1("\27[", col1, "m", msg1, "\27[0m")
end)
printError_21_1 = (function(msg2)
	local lines1 = split1(msg2, "\n", 1)
	print_21_1(colored1(31, _2e2e_1("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return print_21_1(cadr1(lines1))
	else
	end
end)
printWarning_21_1 = (function(msg3)
	local lines2 = split1(msg3, "\n", 1)
	print_21_1(colored1(33, _2e2e_1("[WARN] ", car2(lines2))))
	if cadr1(lines2) then
		return print_21_1(cadr1(lines2))
	else
	end
end)
printVerbose_21_1 = (function(msg4)
	if (verbosity1["value"] > 0) then
		return print_21_1(_2e2e_1("[VERBOSE] ", msg4))
	else
	end
end)
printDebug_21_1 = (function(msg5)
	if (verbosity1["value"] > 1) then
		return print_21_1(_2e2e_1("[DEBUG] ", msg5))
	else
	end
end)
formatPosition1 = (function(pos2)
	return _2e2e_1(pos2["line"], ":", pos2["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format1("%s %s-%s", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format1("%s %s", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node1)
	local _temp
	local r_781 = node1["range"]
	if r_781 then
		_temp = node1["contents"]
	else
		_temp = r_781
	end
	if _temp then
		return format1("%s (%q)", formatRange1(node1["range"]), node1["contents"])
	elseif node1["range"] then
		return formatRange1(node1["range"])
	elseif node1["macro"] then
		local macro1 = node1["macro"]
		return format1("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		return "?"
	end
end)
getSource1 = (function(node2)
	local result1 = nil
	local r_791 = nil
	r_791 = (function()
		local _temp
		local r_801 = node2
		if r_801 then
			_temp = _21_1(result1)
		else
			_temp = r_801
		end
		if _temp then
			result1 = node2["range"]
			node2 = node2["parent"]
			return r_791()
		else
		end
	end)
	r_791()
	return result1
end)
putLines_21_1 = (function(range2, ...)
	local entries1 = _pack(...) entries1.tag = "list"
	if nil_3f_1(entries1) then
		error_21_1("Positions cannot be empty")
	else
	end
	if ((_23_1(entries1) % 2) ~= 0) then
		error_21_1(_2e2e_1("Positions must be a multiple of 2, is ", _23_1(entries1)))
	else
	end
	local previous1 = -1
	local maxLine1 = entries1[pred1(_23_1(entries1))]["start"]["line"]
	local code1 = _2e2e_1("\27[92m %", _23_s1(number_2d3e_string1(maxLine1)), "s |\27[0m %s")
	local r_901 = _23_1(entries1)
	local r_911 = 2
	local r_881 = nil
	r_881 = (function(r_891)
		local _temp
		if (0 < 2) then
			_temp = (r_891 <= r_901)
		else
			_temp = (r_891 >= r_901)
		end
		if _temp then
			local i2 = r_891
			local position1 = entries1[i2]
			local message1 = entries1[succ1(i2)]
			local _temp
			local r_921 = (previous1 ~= -1)
			if r_921 then
				_temp = ((position1["start"]["line"] - previous1) > 2)
			else
				_temp = r_921
			end
			if _temp then
				print_21_1(" \27[92m...\27[0m")
			else
			end
			previous1 = position1["start"]["line"]
			print_21_1(format1(code1, number_2d3e_string1(position1["start"]["line"]), position1["lines"][position1["start"]["line"]]))
			local pointer1
			if _21_1(range2) then
				pointer1 = "^"
			else
				local _temp
				local r_931 = position1["finish"]
				if r_931 then
					_temp = (position1["start"]["line"] == position1["finish"]["line"])
				else
					_temp = r_931
				end
				if _temp then
					pointer1 = rep1("^", _2d_1(position1["finish"]["column"], position1["start"]["column"], -1))
				else
					pointer1 = "^..."
				end
			end
			print_21_1(format1(code1, "", _2e2e_1(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_881((r_891 + r_911))
		else
		end
	end)
	return r_881(1)
end)
putTrace_21_1 = (function(node3)
	local previous2 = nil
	local r_811 = nil
	r_811 = (function()
		if node3 then
			local formatted1 = formatNode1(node3)
			if (previous2 == nil) then
				print_21_1(colored1(96, _2e2e_1("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print_21_1(_2e2e_1("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node3 = node3["parent"]
			return r_811()
		else
		end
	end)
	return r_811()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_831 = lines3
		local r_861 = _23_1(r_831)
		local r_871 = 1
		local r_841 = nil
		r_841 = (function(r_851)
			local _temp
			if (0 < 1) then
				_temp = (r_851 <= r_861)
			else
				_temp = (r_851 >= r_861)
			end
			if _temp then
				local r_821 = r_851
				local line1 = r_831[r_821]
				print_21_1(_2e2e_1("  ", line1))
				return r_841((r_851 + r_871))
			else
			end
		end)
		return r_841(1)
	else
	end
end)
errorPositions_21_1 = (function(node4, msg6)
	printError_21_1(msg6)
	putTrace_21_1(node4)
	local source1 = getSource1(node4)
	if source1 then
		putLines_21_1(true, source1, "")
	else
	end
	return fail_21_1("An error occured")
end)
struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)
lex1 = (function(str1, name1)
	local lines4 = split1(str1, "\n")
	local line2 = 1
	local column1 = 1
	local offset1 = 1
	local length1 = _23_s1(str1)
	local out3 = {tag = "list", n =0}
	local consume_21_1 = (function()
		if (charAt1(str1, offset1) == "\n") then
			line2 = (line2 + 1)
			column1 = 1
		else
			column1 = (column1 + 1)
		end
		offset1 = (offset1 + 1)
		return nil
	end)
	local position2 = (function()
		return struct1("line", line2, "column", column1, "offset", offset1)
	end)
	local range3 = (function(start2, finish1)
		return struct1("start", start2, "finish", finish1, "lines", lines4, "name", name1)
	end)
	local appendWith_21_1 = (function(data1, start3, finish2)
		local start4
		local r_1141 = start3
		if r_1141 then
			start4 = r_1141
		else
			start4 = position2()
		end
		local finish3
		local r_1151 = finish2
		if r_1151 then
			finish3 = r_1151
		else
			finish3 = position2()
		end
		data1["range"] = range3(start4, finish3)
		data1["contents"] = sub1(str1, start4["offset"], finish3["offset"])
		return pushCdr_21_1(out3, data1)
	end)
	local append_21_1 = (function(tag2, start5, finish4)
		return appendWith_21_1(struct1("tag", tag2), start5, finish4)
	end)
	local r_941 = nil
	r_941 = (function()
		if (offset1 <= length1) then
			local char1 = charAt1(str1, offset1)
			local _temp
			local r_951 = (char1 == "\n")
			if r_951 then
				_temp = r_951
			else
				local r_961 = (char1 == "\t")
				if r_961 then
					_temp = r_961
				else
					_temp = (char1 == " ")
				end
			end
			if _temp then
			elseif (char1 == "(") then
				appendWith_21_1(struct1("tag", "open", "close", ")"))
			elseif (char1 == ")") then
				appendWith_21_1(struct1("tag", "close", "open", "("))
			elseif (char1 == "[") then
				appendWith_21_1(struct1("tag", "open", "close", "]"))
			elseif (char1 == "]") then
				appendWith_21_1(struct1("tag", "close", "open", "["))
			elseif (char1 == "{") then
				appendWith_21_1(struct1("tag", "open", "close", "}"))
			elseif (char1 == "}") then
				appendWith_21_1(struct1("tag", "close", "open", "{"))
			elseif (char1 == "'") then
				append_21_1("quote")
			elseif (char1 == "`") then
				append_21_1("quasiquote")
			elseif (char1 == ",") then
				if (charAt1(str1, succ1(offset1)) == "@") then
					local start6 = position2()
					consume_21_1()
					append_21_1("unquote-splice", start6)
				else
					append_21_1("unquote")
				end
			else
				local _temp
				local r_971 = between_3f_1(char1, "0", "9")
				if r_971 then
					_temp = r_971
				else
					local r_981 = (char1 == "-")
					if r_981 then
						_temp = between_3f_1(charAt1(str1, succ1(offset1)), "0", "9")
					else
						_temp = r_981
					end
				end
				if _temp then
					local start7 = position2()
					local r_991 = nil
					r_991 = (function()
						if find1(charAt1(str1, succ1(offset1)), "[0-9.e+-]") then
							consume_21_1()
							return r_991()
						else
						end
					end)
					r_991()
					append_21_1("number", start7)
				elseif (char1 == "\"") then
					local start8 = position2()
					consume_21_1()
					char1 = charAt1(str1, offset1)
					local r_1001 = nil
					r_1001 = (function()
						if (char1 ~= "\"") then
							local _temp
							local r_1011 = (char1 == nil)
							if r_1011 then
								_temp = r_1011
							else
								_temp = (char1 == "")
							end
							if _temp then
								printError_21_1("Expected '\"', got eof")
								local start9 = range3(start8)
								local finish5 = range3(position2())
								putTrace_21_1(struct1("range", finish5))
								putLines_21_1(false, start9, "string started here", finish5, "end of file here")
								fail_21_1("Lexing failed")
							elseif (char1 == "\\") then
								consume_21_1()
							else
							end
							consume_21_1()
							char1 = charAt1(str1, offset1)
							return r_1001()
						else
						end
					end)
					r_1001()
					append_21_1("string", start8)
				elseif (char1 == ";") then
					local r_1021 = nil
					r_1021 = (function()
						local _temp
						local r_1031 = (offset1 <= length1)
						if r_1031 then
							_temp = (charAt1(str1, succ1(offset1)) ~= "\n")
						else
							_temp = r_1031
						end
						if _temp then
							consume_21_1()
							return r_1021()
						else
						end
					end)
					r_1021()
				else
					local start10 = position2()
					local tag3
					if (char1 == ":") then
						tag3 = "key"
					else
						tag3 = "symbol"
					end
					char1 = charAt1(str1, succ1(offset1))
					local r_1041 = nil
					r_1041 = (function()
						local _temp
						local r_1051 = (char1 ~= "\n")
						if r_1051 then
							local r_1061 = (char1 ~= " ")
							if r_1061 then
								local r_1071 = (char1 ~= "\t")
								if r_1071 then
									local r_1081 = (char1 ~= "(")
									if r_1081 then
										local r_1091 = (char1 ~= ")")
										if r_1091 then
											local r_1101 = (char1 ~= "[")
											if r_1101 then
												local r_1111 = (char1 ~= "]")
												if r_1111 then
													local r_1121 = (char1 ~= "{")
													if r_1121 then
														local r_1131 = (char1 ~= "}")
														if r_1131 then
															_temp = (char1 ~= "")
														else
															_temp = r_1131
														end
													else
														_temp = r_1121
													end
												else
													_temp = r_1111
												end
											else
												_temp = r_1101
											end
										else
											_temp = r_1091
										end
									else
										_temp = r_1081
									end
								else
									_temp = r_1071
								end
							else
								_temp = r_1061
							end
						else
							_temp = r_1051
						end
						if _temp then
							consume_21_1()
							char1 = charAt1(str1, succ1(offset1))
							return r_1041()
						else
						end
					end)
					r_1041()
					append_21_1(tag3, start10)
				end
			end
			consume_21_1()
			return r_941()
		else
		end
	end)
	r_941()
	append_21_1("eof")
	return out3
end)
parse1 = (function(toks1)
	local index1 = 1
	local head1 = {tag = "list", n =0}
	local stack1 = {tag = "list", n =0}
	local append_21_2 = (function(node5)
		local next1 = {tag = "list", n =0}
		pushCdr_21_1(head1, node5)
		node5["parent"] = head1
		return nil
	end)
	local push_21_1 = (function()
		local next2 = {tag = "list", n =0}
		pushCdr_21_1(stack1, head1)
		append_21_2(next2)
		head1 = next2
		return nil
	end)
	local pop_21_1 = (function()
		head1["open"] = nil
		head1["close"] = nil
		head1["auto-close"] = nil
		head1["last-node"] = nil
		head1 = last1(stack1)
		return popLast_21_1(stack1)
	end)
	local r_1171 = toks1
	local r_1201 = _23_1(r_1171)
	local r_1211 = 1
	local r_1181 = nil
	r_1181 = (function(r_1191)
		local _temp
		if (0 < 1) then
			_temp = (r_1191 <= r_1201)
		else
			_temp = (r_1191 >= r_1201)
		end
		if _temp then
			local r_1161 = r_1191
			local tok1 = r_1171[r_1161]
			local tag4 = tok1["tag"]
			local autoClose1 = false
			local previous3 = head1["last-node"]
			local tokPos1 = tok1["range"]
			local _temp
			local r_1221 = (tag4 ~= "eof")
			if r_1221 then
				local r_1231 = (tag4 ~= "close")
				if r_1231 then
					if head1["range"] then
						_temp = (tokPos1["start"]["line"] ~= head1["range"]["start"]["line"])
					else
						_temp = true
					end
				else
					_temp = r_1231
				end
			else
				_temp = r_1221
			end
			if _temp then
				if previous3 then
					local prevPos1 = previous3["range"]
					if (tokPos1["start"]["line"] ~= prevPos1["start"]["line"]) then
						head1["last-node"] = tok1
						if (tokPos1["start"]["column"] ~= prevPos1["start"]["column"]) then
							printWarning_21_1("Different indent compared with previous expressions.")
							putTrace_21_1(tok1)
							putExplain_21_1("You should try to maintain consistent indentation across a program,", "try to ensure all expressions are lined up.", "If this looks OK to you, check you're not missing a closing ')'.")
							putLines_21_1(false, prevPos1, "", tokPos1, "")
						else
						end
					else
					end
				else
					head1["last-node"] = tok1
				end
			else
			end
			local _temp
			local r_1241 = (tag4 == "string")
			if r_1241 then
				_temp = r_1241
			else
				local r_1251 = (tag4 == "number")
				if r_1251 then
					_temp = r_1251
				else
					local r_1261 = (tag4 == "symbol")
					if r_1261 then
						_temp = r_1261
					else
						_temp = (tag4 == "key")
					end
				end
			end
			if _temp then
				append_21_2(tok1)
			elseif (tag4 == "open") then
				push_21_1()
				head1["open"] = tok1["contents"]
				head1["close"] = tok1["close"]
				head1["range"] = struct1("start", tok1["range"]["start"], "name", tok1["range"]["name"], "lines", tok1["range"]["lines"])
			elseif (tag4 == "close") then
				if nil_3f_1(stack1) then
					errorPositions_21_1(tok1, format1("'%s' without matching '%s'", tok1["contents"], tok1["open"]))
				elseif head1["auto-close"] then
					printError_21_1(format1("'%s' without matching '%s' inside quote", tok1["contents"], tok1["open"]))
					putTrace_21_1(tok1)
					putLines_21_1(false, head1["range"], "quote opened here", tok1["range"], "attempting to close here")
					fail_21_1("Parsing failed")
				elseif (head1["close"] ~= tok1["contents"]) then
					printError_21_1(format1("Expected '%s', got '%s'", head1["close"], tok1["contents"]))
					putTrace_21_1(tok1)
					putLines_21_1(false, head1["range"], format1("block opened with '%s'", head1["open"]), tok1["range"], format1("'%s' used here", tok1["contents"]))
					fail_21_1("Parsing failed")
				else
					head1["range"]["finish"] = tok1["range"]["finish"]
					pop_21_1()
				end
			else
				local _temp
				local r_1271 = (tag4 == "quote")
				if r_1271 then
					_temp = r_1271
				else
					local r_1281 = (tag4 == "unquote")
					if r_1281 then
						_temp = r_1281
					else
						local r_1291 = (tag4 == "quasiquote")
						if r_1291 then
							_temp = r_1291
						else
							_temp = (tag4 == "unquote-splice")
						end
					end
				end
				if _temp then
					push_21_1()
					head1["range"] = struct1("start", tok1["range"]["start"], "name", tok1["range"]["name"], "lines", tok1["range"]["lines"])
					append_21_2(struct1("tag", "symbol", "contents", tag4, "range", tok1["range"]))
					autoClose1 = true
					head1["auto-close"] = true
				elseif (tag4 == "eof") then
					if (0 ~= _23_1(stack1)) then
						printError_21_1("Expected ')', got eof")
						putTrace_21_1(tok1)
						putLines_21_1(false, head1["range"], "block opened here", tok1["range"], "end of file here")
						fail_21_1("Parsing failed")
					else
					end
				else
					error_21_1(_2e2e_1("Unsupported type", tag4))
				end
			end
			if autoClose1 then
			else
				local r_1301 = nil
				r_1301 = (function()
					if head1["auto-close"] then
						if nil_3f_1(stack1) then
							errorPositions_21_1(tok1, format1("'%s' without matching '%s'", tok1["contents"], tok1["open"]))
							fail_21_1("Parsing failed")
						else
						end
						head1["range"]["finish"] = tok1["range"]["finish"]
						pop_21_1()
						return r_1301()
					else
					end
				end)
				r_1301()
			end
			return r_1181((r_1191 + r_1211))
		else
		end
	end)
	r_1181(1)
	return head1
end)
read1 = compose1(parse1, lex1)
return struct1("lex", lex1, "parse", parse1, "read", read1)
