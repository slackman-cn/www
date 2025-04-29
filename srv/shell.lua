local os = require("os")
local io = require("io")

local current_time = os.time() -- 获取当前时间
local date_string = os.date("%Y-%m-%d %H:%M:%S", current_time)
print(date_string) 
print(os.date())
print(os.date('%H:%M:%S'))

print("Lua", _VERSION:sub(-3))

-------- IO
local file_handle = io.tmpfile()
if file_handle then
    print("临时文件已创建: ")
    -- 向临时文件写入数据
    file_handle:write("Hello, 临时文件!")
    -- 重置文件指针到文件开始
    file_handle:seek("set", 0)
    -- 读取刚才写入的数据
    local content = file_handle:read("*a")
    print(content)
    -- 关闭文件句柄，删除临时文件
    file_handle:close()
else
    print("临时文件创建失败")
end

-- os.tmpname() 只返回文件名，需要手动打开和关闭
local temp_file = os.tmpname()
print("Temp file name:", temp_file)
local f, err = io.open(temp_file, "w")
if err then
    error(err)
end

-- Write some data to the file
f:write(string.char(1, 2, 3, 4))
f:close()

-- Clean up the file after we're done
os.remove(temp_file)


-------- Command
print('CLI')
if os.execute('date -R') then
    print('命令执行成功')
else
   print('命令执行失败')
end

local result,exitCode,sinal = os.execute('date -RR')
if result == nil then
    print("Command failed with exit code: " .. sinal)
end


local handle = io.popen("date -R")
if handle == nil then
    return
end
local stdout = handle:read()
if handle:close() then
    print('output is:', stdout)
else
    print('error when executing command')
end


--------- LOG
--- local logging = require('logging')
--- local LOG = logging.file("test%s.log")
function logMessage(level, message)
    print(string.format("[%s] %s: %s", os.date("%Y-%m-%d %H:%M:%S"), level, message))
end

logMessage("INFO", "应用程序已启动。")
logMessage("WARN", "检测到已弃用的函数调用。")
logMessage("ERROR", "文件打开失败。")

local logging = {
    _VERSION = "1.0"
}

function logging.file()
end

function logging()
end

local function log(...)
    local args = {...}
    -- get length
    -- if #args == 0 then
    --     print('LOG')
    --     return
    -- end
    print('LOG', #args , table.concat(args, '; '))
    -- foreach
    -- local t = {}
    -- for i = 1, select('#', ...) do
    --     local x = select(i, ...)
    --     t[#t + 1] = tostring(x)
    -- end
    -- return table.concat(t, " ")

    -- for i,v in ipairs(args) do
    --     print(v)
    -- end
end