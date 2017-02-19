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
error1 = _libs["lib/lua/basic/error"]
rawget1 = _libs["lib/lua/basic/rawget"]
rawset1 = _libs["lib/lua/basic/rawset"]
require1 = _libs["lib/lua/basic/require"]
type_23_1 = _libs["lib/lua/basic/type#"]
_23_1 = (function(x1)
	return x1["n"]
end)
concat1 = _libs["lib/lua/table/concat"]
remove1 = _libs["lib/lua/table/remove"]
emptyStruct1 = _libs["lib/lua/table/empty-struct"]
iterPairs1 = _libs["lib/lua/table/iter-pairs"]
car1 = (function(xs1)
	return xs1[1]
end)
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
format1 = _libs["lib/lua/string/format"]
sub1 = _libs["lib/lua/string/sub"]
list_3f_1 = (function(x2)
	return (type1(x2) == "list")
end)
symbol_3f_1 = (function(x3)
	return (type1(x3) == "symbol")
end)
key_3f_1 = (function(x4)
	return (type1(x4) == "key")
end)
type1 = (function(val1)
	local ty1 = type_23_1(val1)
	if (ty1 == "table") then
		local tag1 = val1["tag"]
		if tag1 then
			return tag1
		else
			return "table"
		end
	else
		return ty1
	end
end)
car2 = (function(x5)
	local r_131 = type1(x5)
	if (r_131 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_131), 2)
	else
	end
	return car1(x5)
end)
nth1 = rawget1
pushCdr_21_1 = (function(xs2, val2)
	local r_231 = type1(xs2)
	if (r_231 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_231), 2)
	else
	end
	local len1 = (_23_1(xs2) + 1)
	xs2["n"] = len1
	xs2[len1] = val2
	return xs2
end)
removeNth_21_1 = (function(li1, idx1)
	local r_251 = type1(li1)
	if (r_251 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_251), 2)
	else
	end
	li1["n"] = (li1["n"] - 1)
	return remove1(li1, idx1)
end)
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
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
	local out1 = emptyStruct1()
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
			local val3 = keys1[(1 + i1)]
			out1[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val3
			return r_461((r_471 + r_491))
		else
		end
	end)
	r_461(1)
	return out1
end)
succ1 = (function(x6)
	return (x6 + 1)
end)
pred1 = (function(x7)
	return (x7 - 1)
end)
error_21_1 = error1
fail_21_1 = (function(x8)
	return error_21_1(x8, 0)
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node1, visitor1, level1)
	if (level1 == 0) then
		return visitNode1(node1, visitor1)
	else
		local tag2 = node1["tag"]
		local _temp
		local r_1061 = (tag2 == "string")
		if r_1061 then
			_temp = r_1061
		else
			local r_1071 = (tag2 == "number")
			if r_1071 then
				_temp = r_1071
			else
				local r_1081 = (tag2 == "key")
				if r_1081 then
					_temp = r_1081
				else
					_temp = (tag2 == "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif (tag2 == "list") then
			local first1 = nth1(node1, 1)
			local _temp
			local r_1091 = first1
			if r_1091 then
				_temp = (first1["tag"] == "symbol")
			else
				_temp = r_1091
			end
			if _temp then
				local _temp
				local r_1101 = (first1["contents"] == "unquote")
				if r_1101 then
					_temp = r_1101
				else
					_temp = (first1["contents"] == "unquote-splice")
				end
				if _temp then
					return visitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif (first1["contents"] == "quasiquote") then
					return visitQuote1(nth1(node1, 2), visitor1, succ1(level1))
				else
					local r_1121 = node1
					local r_1151 = _23_1(r_1121)
					local r_1161 = 1
					local r_1131 = nil
					r_1131 = (function(r_1141)
						local _temp
						if (0 < 1) then
							_temp = (r_1141 <= r_1151)
						else
							_temp = (r_1141 >= r_1151)
						end
						if _temp then
							local r_1111 = r_1141
							local sub2 = r_1121[r_1111]
							visitQuote1(sub2, visitor1, level1)
							return r_1131((r_1141 + r_1161))
						else
						end
					end)
					return r_1131(1)
				end
			else
				local r_1181 = node1
				local r_1211 = _23_1(r_1181)
				local r_1221 = 1
				local r_1191 = nil
				r_1191 = (function(r_1201)
					local _temp
					if (0 < 1) then
						_temp = (r_1201 <= r_1211)
					else
						_temp = (r_1201 >= r_1211)
					end
					if _temp then
						local r_1171 = r_1201
						local sub3 = r_1181[r_1171]
						visitQuote1(sub3, visitor1, level1)
						return r_1191((r_1201 + r_1221))
					else
					end
				end)
				return r_1191(1)
			end
		elseif error_21_1 then
			return _2e2e_1("Unknown tag ", tag2)
		else
			_error("unmatched item")
		end
	end
end)
visitNode1 = (function(node2, visitor2)
	if (visitor2(node2) == false) then
	else
		local tag3 = node2["tag"]
		local _temp
		local r_1231 = (tag3 == "string")
		if r_1231 then
			_temp = r_1231
		else
			local r_1241 = (tag3 == "number")
			if r_1241 then
				_temp = r_1241
			else
				local r_1251 = (tag3 == "key")
				if r_1251 then
					_temp = r_1251
				else
					_temp = (tag3 == "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif (tag3 == "list") then
			local first2 = nth1(node2, 1)
			local _temp
			local r_1261 = first2
			if r_1261 then
				_temp = (first2["tag"] == "symbol")
			else
				_temp = r_1261
			end
			if _temp then
				local func1 = first2["var"]
				local funct1 = func1["tag"]
				if (func1 == builtins1["lambda"]) then
					return visitBlock1(node2, 3, visitor2)
				elseif (func1 == builtins1["cond"]) then
					local r_1291 = _23_1(node2)
					local r_1301 = 1
					local r_1271 = nil
					r_1271 = (function(r_1281)
						local _temp
						if (0 < 1) then
							_temp = (r_1281 <= r_1291)
						else
							_temp = (r_1281 >= r_1291)
						end
						if _temp then
							local i2 = r_1281
							local case1 = nth1(node2, i2)
							visitNode1(nth1(case1, 1), visitor2)
							visitBlock1(case1, 2, visitor2)
							return r_1271((r_1281 + r_1301))
						else
						end
					end)
					return r_1271(2)
				elseif (func1 == builtins1["set!"]) then
					return visitNode1(nth1(node2, 3), visitor2)
				elseif (func1 == builtins1["quote"]) then
				elseif (func1 == builtins1["quasiquote"]) then
					return visitQuote1(nth1(node2, 2), visitor2, 1)
				else
					local _temp
					local r_1311 = (func1 == builtins1["unquote"])
					if r_1311 then
						_temp = r_1311
					else
						_temp = (func1 == builtins1["unquote-splice"])
					end
					if _temp then
						return fail_21_1("unquote/unquote-splice should never appear head")
					else
						local _temp
						local r_1321 = (func1 == builtins1["define"])
						if r_1321 then
							_temp = r_1321
						else
							_temp = (func1 == builtins1["define-macro"])
						end
						if _temp then
							return visitBlock1(node2, 3, visitor2)
						elseif (func1 == builtins1["define-native"]) then
						elseif (func1 == builtins1["import"]) then
						elseif (funct1 == "macro") then
							return fail_21_1("Macros should have been expanded")
						else
							local _temp
							local r_1331 = (funct1 == "defined")
							if r_1331 then
								_temp = r_1331
							else
								local r_1341 = (funct1 == "arg")
								if r_1341 then
									_temp = r_1341
								else
									_temp = (funct1 == "native")
								end
							end
							if _temp then
								return visitBlock1(node2, 1, visitor2)
							else
								return fail_21_1(_2e2e_1("Unknown kind ", funct1, " for variable ", func1["name"]))
							end
						end
					end
				end
			else
				return visitBlock1(node2, 1, visitor2)
			end
		else
			return error_21_1(_2e2e_1("Unknown tag ", tag3))
		end
	end
end)
visitBlock1 = (function(node3, start1, visitor3)
	local r_1041 = _23_1(node3)
	local r_1051 = 1
	local r_1021 = nil
	r_1021 = (function(r_1031)
		local _temp
		if (0 < 1) then
			_temp = (r_1031 <= r_1041)
		else
			_temp = (r_1031 >= r_1041)
		end
		if _temp then
			local i3 = r_1031
			visitNode1(nth1(node3, i3), visitor3)
			return r_1021((r_1031 + r_1051))
		else
		end
	end)
	return r_1021(start1)
end)
struct1("visitNode", visitNode1, "visitBlock", visitBlock1, "visitList", visitBlock1)
builtins2 = require1("tacky.analysis.resolve")["builtins"]
createState1 = (function()
	return struct1("vars", emptyStruct1(), "nodes", emptyStruct1())
end)
getVar1 = (function(state1, var1)
	local entry1 = state1["vars"][var1]
	if entry1 then
	else
		entry1 = struct1("var", var1, "usages", struct1(), "defs", struct1(), "active", false)
		state1["vars"][var1] = entry1
	end
	return entry1
end)
getNode1 = (function(state2, node4)
	local entry2 = state2["nodes"][node4]
	if entry2 then
	else
		entry2 = struct1("uses", {tag = "list", n =0})
		state2["nodes"][node4] = entry2
	end
	return entry2
end)
addUsage_21_1 = (function(state3, var2, node5)
	local varMeta1 = getVar1(state3, var2)
	local nodeMeta1 = getNode1(state3, node5)
	varMeta1["usages"][node5] = true
	varMeta1["active"] = true
	nodeMeta1["uses"][var2] = true
	return nil
end)
addDefinition_21_1 = (function(state4, var3, node6, kind1, value1)
	local varMeta2 = getVar1(state4, var3)
	if value1 then
		local nodeMeta2 = getNode1(state4, value1)
		if nodeMeta2["definesr"] then
			error_21_1("Value defines multiple variables")
		else
		end
		nodeMeta2["defines"] = var3
	else
	end
	varMeta2["defs"][node6] = struct1("tag", kind1, "value", value1)
	return nil
end)
definitionsVisitor1 = (function(state5, node7)
	local _temp
	local r_931 = list_3f_1(node7)
	if r_931 then
		local r_941 = (_23_1(node7) > 0)
		if r_941 then
			_temp = symbol_3f_1(car2(node7))
		else
			_temp = r_941
		end
	else
		_temp = r_931
	end
	if _temp then
		local func2 = car2(node7)["var"]
		if (func2 == builtins2["lambda"]) then
			local r_961 = nth1(node7, 2)
			local r_991 = _23_1(r_961)
			local r_1001 = 1
			local r_971 = nil
			r_971 = (function(r_981)
				local _temp
				if (0 < 1) then
					_temp = (r_981 <= r_991)
				else
					_temp = (r_981 >= r_991)
				end
				if _temp then
					local r_951 = r_981
					local arg1 = r_961[r_951]
					addDefinition_21_1(state5, arg1["var"], arg1, "arg", arg1)
					return r_971((r_981 + r_1001))
				else
				end
			end)
			return r_971(1)
		elseif (func2 == builtins2["set!"]) then
			return addDefinition_21_1(state5, node7[2]["var"], node7, "set", nth1(node7, 3))
		else
			local _temp
			local r_1011 = (func2 == builtins2["define"])
			if r_1011 then
				_temp = r_1011
			else
				_temp = (func2 == builtins2["define-macro"])
			end
			if _temp then
				return addDefinition_21_1(state5, node7["defVar"], node7, "define", nth1(node7, 3))
			elseif (func2 == builtins2["define-native"]) then
				return addDefinition_21_1(state5, node7["defVar"], node7, "native")
			else
			end
		end
	else
	end
end)
definitionsVisit1 = (function(state6, nodes1)
	return visitBlock1(nodes1, 1, (function(r_1471)
		return definitionsVisitor1(state6, r_1471)
	end))
end)
usagesVisit1 = (function(state7, nodes2, pred2)
	if pred2 then
	else
		pred2 = (function()
			return true
		end)
	end
	local queue1 = {tag = "list", n =0}
	local visited1 = emptyStruct1()
	local addUsage1 = (function(var4, user1)
		addUsage_21_1(state7, var4, user1)
		local varMeta3 = getVar1(state7, var4)
		if varMeta3["active"] then
			return iterPairs1(varMeta3["defs"], (function(_5f_1, def1)
				local val4 = def1["value"]
				local _temp
				local r_1461 = val4
				if r_1461 then
					_temp = _21_1(visited1[val4])
				else
					_temp = r_1461
				end
				if _temp then
					return pushCdr_21_1(queue1, val4)
				else
				end
			end))
		else
		end
	end)
	local visit1 = (function(node8)
		if visited1[node8] then
			return false
		else
			visited1[node8] = true
			if symbol_3f_1(node8) then
				addUsage1(node8["var"], node8)
				return true
			else
				local _temp
				local r_1421 = list_3f_1(node8)
				if r_1421 then
					local r_1431 = (_23_1(node8) > 0)
					if r_1431 then
						_temp = symbol_3f_1(car2(node8))
					else
						_temp = r_1431
					end
				else
					_temp = r_1421
				end
				if _temp then
					local func3 = car2(node8)["var"]
					local _temp
					local r_1441 = (func3 == builtins2["set!"])
					if r_1441 then
						_temp = r_1441
					else
						local r_1451 = (func3 == builtins2["define"])
						if r_1451 then
							_temp = r_1451
						else
							_temp = (func3 == builtins2["define-macro"])
						end
					end
					if _temp then
						if pred2(nth1(node8, 3)) then
							return true
						else
							return false
						end
					else
						return true
					end
				else
					return true
				end
			end
		end
	end)
	local r_1361 = nodes2
	local r_1391 = _23_1(r_1361)
	local r_1401 = 1
	local r_1371 = nil
	r_1371 = (function(r_1381)
		local _temp
		if (0 < 1) then
			_temp = (r_1381 <= r_1391)
		else
			_temp = (r_1381 >= r_1391)
		end
		if _temp then
			local r_1351 = r_1381
			local node9 = r_1361[r_1351]
			pushCdr_21_1(queue1, node9)
			return r_1371((r_1381 + r_1401))
		else
		end
	end)
	r_1371(1)
	local r_1411 = nil
	r_1411 = (function()
		if (_23_1(queue1) > 0) then
			visitNode1(removeNth_21_1(queue1, 1), visit1)
			return r_1411()
		else
		end
	end)
	return r_1411()
end)
builtins3 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
hasSideEffect1 = (function(node10)
	local tag4 = type1(node10)
	local _temp
	local r_781 = (tag4 == "number")
	if r_781 then
		_temp = r_781
	else
		local r_791 = (tag4 == "string")
		if r_791 then
			_temp = r_791
		else
			local r_801 = (tag4 == "key")
			if r_801 then
				_temp = r_801
			else
				_temp = (tag4 == "symbol")
			end
		end
	end
	if _temp then
		return false
	elseif (tag4 == "list") then
		local fst1 = car2(node10)
		if (type1(fst1) == "symbol") then
			local var5 = fst1["var"]
			local r_811 = (var5 ~= builtins3["lambda"])
			if r_811 then
				return (var5 ~= builtins3["quote"])
			else
				return r_811
			end
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
optimise1 = (function(nodes3)
	local r_841 = 1
	local r_851 = -1
	local r_821 = nil
	r_821 = (function(r_831)
		local _temp
		if (0 < -1) then
			_temp = (r_831 <= r_841)
		else
			_temp = (r_831 >= r_841)
		end
		if _temp then
			local i4 = r_831
			local node11 = nth1(nodes3, i4)
			local _temp
			local r_861 = list_3f_1(node11)
			if r_861 then
				local r_871 = (_23_1(node11) > 0)
				if r_871 then
					local r_881 = symbol_3f_1(car2(node11))
					if r_881 then
						_temp = (car2(node11)["var"] == builtins3["import"])
					else
						_temp = r_881
					end
				else
					_temp = r_871
				end
			else
				_temp = r_861
			end
			if _temp then
				if (i4 == _23_1(nodes3)) then
					nodes3[i4] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
				else
					removeNth_21_1(nodes3, i4)
				end
			else
			end
			return r_821((r_831 + r_851))
		else
		end
	end)
	r_821(_23_1(nodes3))
	local r_911 = 1
	local r_921 = -1
	local r_891 = nil
	r_891 = (function(r_901)
		local _temp
		if (0 < -1) then
			_temp = (r_901 <= r_911)
		else
			_temp = (r_901 >= r_911)
		end
		if _temp then
			local i5 = r_901
			local node12 = nth1(nodes3, i5)
			if _21_1(hasSideEffect1(node12)) then
				removeNth_21_1(nodes3, i5)
			else
			end
			return r_891((r_901 + r_921))
		else
		end
	end)
	r_891(pred1(_23_1(nodes3)))
	local lookup1 = createState1()
	definitionsVisit1(lookup1, nodes3)
	usagesVisit1(lookup1, nodes3, hasSideEffect1)
	local r_1501 = 1
	local r_1511 = -1
	local r_1481 = nil
	r_1481 = (function(r_1491)
		local _temp
		if (0 < -1) then
			_temp = (r_1491 <= r_1501)
		else
			_temp = (r_1491 >= r_1501)
		end
		if _temp then
			local i6 = r_1491
			local node13 = nth1(nodes3, i6)
			local _temp
			local r_1521 = node13["defVar"]
			if r_1521 then
				_temp = _21_1(getVar1(lookup1, node13["defVar"])["active"])
			else
				_temp = r_1521
			end
			if _temp then
				if (i6 == _23_1(nodes3)) then
					nodes3[i6] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
				else
					removeNth_21_1(nodes3, i6)
				end
			else
			end
			return r_1481((r_1491 + r_1511))
		else
		end
	end)
	r_1481(_23_1(nodes3))
	return nodes3
end)
return optimise1
