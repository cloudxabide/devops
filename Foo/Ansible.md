# Ansible Foo 

## Files and Directories
Playbook  
Inventory  
Configuration

### Example File (playbook)

```
$ cat local_web_server.yml
--- # Playbook
- hosts: localhost
  user: mansible
  become: yes
  gather_facts: no
  vars:
    http_port: 80
    max_clients: 200
    webserver: httpd
  tasks:
  - name: Install Web Server Software "{{ webserver }}"
    yum:
      name: "{{ webserver }}"
      state: latest
      notify:
        Enable Web Service
        Restart Web Service

  handlers:
  - name: Enable Web Service
    systemd:
      name: "{{ webserver }}"
      enabled: yes
      masked: no
  - name: Restart Web Service
    systemd:
      name: "{{ webserver }}"
      state: restarted
...

```

#### Run the playbook
```
$ ansible-playbook -v local_web_server.yml
```

### Example File (Inventory)

### Example File (Configuration)

## Order of precendence 
Ansible will assess and process configurations/vars/etc... from a TON of different locations.  This is another area that will probably "get you" at some point.


## Tips
Spacing/indentation matters - it WILL cause you an issue at some point, I can *almost* guaruntee it.
