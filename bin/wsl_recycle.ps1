$distroname = "Ubuntu-CC"
wsl --unregister $distroname
wsl --import $distroname .\wslDistroStorage\$distroname .\distros\$distroname.tar
wsl --set-default $distroname
wsl