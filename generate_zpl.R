#a script that reads in a list of ids and writes a zpl script to define labels
#zpl script can be passed as an argument to curl, to download label pdfs from labelary

#preset label suffixes
#suffixes=c("-EDTA","-ADP-L","-ADP-M","-ADP-H","-CRP-L","-CRP-M","-CRP-H","-TRAP-L","-TRAP-M","-TRAP-H","-EPI-L","-EPI-M","-EPI-H","-U46-L","-U46-M","-U46-H")

# Get the command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Read the text file
file_path <- args[1]
suffixes_arg <- args[2]

# Convert the suffixes argument to a vector
if (!is.null(suffixes_arg) && nzchar(suffixes_arg)) {
  suffixes <- unlist(strsplit(suffixes_arg, " "))
} else {
  suffixes <- ""
}

data <- readLines(file_path)

write_chunk=function(id){
  zpl=paste0("^XA\n",
             "^BY6,2,270\n",
             "^FO90,175\n",
             "^BC\n",
             "^FD",id,"^FS\n",
             "^XZ\n",
             "\n")
  return(zpl)
}

write_zpl=function(id,suffixes=c("")){
    idlist=paste0(id,suffixes)
    #apply write_zpl to full list of ids, to generate a list of zpl code chunks for all samples
    allzpl=lapply(idlist,write_chunk)
    
    #unlist to map newline characters properly
    zpl_lines=unlist(strsplit(unlist(allzpl), "\n"))
    
    #write to zpl file
    writeLines(zpl_lines, con = paste0("/Users/kayleigh/Desktop/zpl/SID_",id,".zpl"))
}

for(id in data){
  write_zpl(id,suffixes=suffixes)
}

