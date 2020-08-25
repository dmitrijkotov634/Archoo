import osproc, os, strtabs, strutils, times, strformat

const white = "\e[0m"

let colors = {
    "red" : "\e[31m",
    "green" : "\e[32m",
    "yellow" : "\e[33m",
    "cyan" : "\e[34m",
    "magenta": "\e[35m",
    "blue": "\e[36m",
    "white" : "\e[0m",
    }.newStringTable

var
    config = (readFile(getConfigDir() & "/archfetch/main.conf") % colors).split("\n")
    color = colors[config[0]]
    modules = config[1].split("..")
    logo = config[2..^1]
    result: string

echo ""

for n, str in logo:
    if n < modules.len:
        case modules[n]
        of "hostname": result = &"{color}Hostname{white}: " & execProcess("uname -n")[0..^2]
        of "kernel": result = &"{color}Kernel{white}: " & execProcess("uname -r")[0..^2]
        of "packages": result = &"{color}Packages{white}: " & execProcess("pacman -Q | wc -l")[0..^2]
        of "uptime": result = &"{color}Uptime{white}: " & execProcess("uptime -p")[0..^2]
        of "ram":
            var temp = execProcess("free --mega").split("\n")[1].split(":           ")[1].split("        ")
            result = &"{color}RAM{white}: {temp[1]}/{temp[0]} MB"
        else: result = execProcess(modules[n])[0..^2]
        echo str & result
    else:
        echo str
