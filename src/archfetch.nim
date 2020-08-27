import osproc, os, strtabs, strutils, strformat

var
    config, modules, logo: seq[string]
    result, color: string

let
    confPath = getConfigDir() & "archfetch/main.conf"
    colors = {
        "red" : "\e[31m",
        "green" : "\e[32m",
        "yellow" : "\e[33m",
        "cyan" : "\e[34m",
        "magenta": "\e[35m",
        "blue": "\e[36m",
        "white" : "\e[0m",
             }.newStringTable

const
    confDefault = """blue
hostname..kernel..packages..uptime..ram..shell
${blue}               +                    
${blue}               #                    
${blue}              ###                   
${blue}             #####                  
${blue}             ######                 
${blue}            ; #####;                
${blue}           +##.#####                
${blue}          +##########               
${blue}         ######${cyan}#####${blue}##;             
${blue}        ###${cyan}############${blue}+            
${blue}       #${cyan}######   #######            
     .######;     ;###;`".          
    .#######;     ;#####.           
    #########.   .########`         
   ######'           '######        
  ;####                 ####;       
  ##'                     '##       
 #'                         `#      
${white}"""

try:
    config = (readFile(confPath) % colors).split("\n")
except IOError:
    config = (confDefault % colors).split("\n")
    discard execProcess("mkdir -p ~/.config/archfetch/")
    writeFile(confPath, confDefault)
    
color = colors[config[0]]
modules = config[1].split("..")
logo = config[2..^1]

echo ""

for n, str in logo:
    if n < modules.len:
        case modules[n]
        of "hostname": result = &"{color}Hostname\e[0m: " & execProcess("uname -n")[0..^2]
        of "kernel": result = &"{color}Kernel\e[0m: " & execProcess("uname -r")[0..^2]
        of "packages": result = &"{color}Packages\e[0m: " & execProcess("pacman -Q | wc -l")[0..^2]
        of "uptime": result = &"{color}Uptime\e[0m: " & execProcess("uptime -p")[0..^2]
        of "shell": result = &"{color}Shell\e[0m: " & getEnv("SHELL").split("/")[^1]
        of "ram":
            var temp = execProcess("free --mega").split("\n")[1].split(":           ")[1].split("        ")
            result = &"{color}RAM\e[0m: {temp[1]}/{temp[0]} MB"
        else: result = execProcess(modules[n])[0..^2]
        echo str & result
    else:
        echo str
