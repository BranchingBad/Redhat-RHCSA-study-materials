# Red Hat Certified System Administrator (RHCSA) study guide
RHCSA EX200 study materials

### Test ENV network setup 
| Host name                 | IPv4            | Gateway       | DNS           |
|:--------------------------|:----------------|:--------------|:--------------|
| server.linux-acc.local    | 192.168.122.150 | 192.168.122.1 | 192.168.122.1 |
| client.linux-acc.local    | 192.168.122.151 | 192.168.122.1 | 192.168.122.1 |
| untrusted.linux-acc.local | 192.168.122.160 | 192.168.122.1 | 192.168.122.1 |

### Test ENV root password
linuxacc

### Create RHEL server virtual machine
Run createServer.sh to create a virtual machine with 2 hard drives and install RHEL 9.4 with a graphical server enviroment.

### Remove RHEL server virtual machine
Run removeServer.sh to remove the virual machine

### Create RHEL client virtual machine
Run createClient.sh to create a virtual machine and install RHEL 9.4 with a workstation enviroment.

### Remove RHEL client virtual machine
Run removeServer.sh to remove the virual machine
