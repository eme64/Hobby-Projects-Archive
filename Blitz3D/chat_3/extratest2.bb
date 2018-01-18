n = CountHostIPs CountHostIPs("")
ip = HostIP(1) ;internal ID
ipaddress$ = DottedIP(ip)

Print "Dotted IP Test"
Print "=============="
Print ""
Print "Internal Host IP ID:" + ip
Print "Dotted IP Address:" + ipaddress$
Print ""
Print "Press any key to continue"

WaitKey()
End