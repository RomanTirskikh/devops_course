#!/bin/bash


#-e option=started
function vagrant_up
    {
    status=$(vagrant status | grep default | awk '{print $2}')
    if [ "$status" == "running" ]; then
        get_vars
        printf '{"ip": "%s", "port": "%s", "user": "%s", "key": "%s", "status": "%s", "os_name": "%s", "ram": "%s"}' "$ip" "$port" "$user" "$key" "$status" "$os_name" "$ram"
        exit 0
    else
        vagrant up &>/dev/null
        get_vars
        printf '{"ip": "%s", "port": "%s", "user": "%s", "key": "%s", "status": "%s", "os_name": "%s", "ram": "%s"}' "$ip" "$port" "$user" "$key" "$status" "$os_name" "$ram"
    fi
}


#-e option=stopped
function vagrant_halt
{   status=$(vagrant status | grep default | awk '{print $2}')
    if [ "$status" == "running" ]; then
        vagrant halt &>/dev/null
        status=$(vagrant status | grep default | awk '{print $2}')
        printf '{ "status": "%s"}' "$status"
        exit 0
    else
        changed="false"
        failed="false"
        printf '{"status": "%s"}' "$status"
    fi
}



#-e option=destroyed
function vagrant_destroy
{   status=$(vagrant status | grep default | head -n1 | awk '{print $2}')
    if [ "$status" == "running" ] || [ "$status" == "poweroff" ]; then
        vagrant destroy --force  &>/dev/null
        status=$(vagrant status | grep default | head -n1 | awk '{print $2 " " $3}')
        printf '{"failed": false, "changed": true, "status": "%s"}' "$status"
        exit 0
    else
        status=$(vagrant status | grep default |  head -n1 | awk '{print $2 " " $3}')
        changed="false"
        failed="false"
        printf '{"failed": false, "changed": true, "status": "%s"}' "$status"
    fi
}



source $1

# CHECKING SECTION
if [ -z "$path" ]; then
    printf '{"failed": true, "msg": "Missing required argument: path"}'
    exit 1
fi

if [ -z "$state" ]; then
    printf '{"failed": true, "msg": "Missing required argument: state"}'
    exit 1
fi


if [ ! -f "$path" ]; then
	printf '{"failed": true, "msg": "Vagrantfile does not exist"}'
	exit 1
fi



# OUTPUT PARAMETERS
function get_vars
{
  ip=$(vagrant ssh-config | grep HostName | awk '{print $2}')
  port=$(vagrant ssh-config | grep Port | awk '{print $2}')
  user=$(vagrant ssh-config | grep -w "User" | awk '{print $2}' 2>/dev/null)
  key=$(vagrant ssh-config | grep IdentityFile | awk '{print $2}' 2>/dev/null)
  status=$(vagrant status | grep virtualbox | awk '{print $2}')
  os_name=$(vagrant ssh -c "lsb_release -a" | grep Description | awk '{print$2,$3}')
  ram=$(vagrant ssh -c "cat /proc/meminfo | grep MemTotal | awk '{print \$2}'" 2>/dev/null)
}



case $state in
    started)
        vagrant_up
    ;;
    stopped)
        vagrant_halt
    ;;
    destroyed)
        vagrant_destroy
    ;;
    *)
        printf '{"failed": true, "msg": "invalid state selected {started | stopped | destroyed}"}'
        exit 1
    ;;
esac

exit 0
