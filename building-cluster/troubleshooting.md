# apt update error
```bash
    Problem with sudo apt get update: The repository cdrom... does not have a Release file
```

```bash
sudo vi /etc/apt/sources.list
```

deb [check-date=no] file:///cdrom jammy main restricted

https://askubuntu.com/questions/776721/problem-with-sudo-apt-get-update-the-repository-cdrom-does-not-have-a-releas

---

# ansible

### [ Problem - Fingerprint ] 
> "msg": "Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this. Please add this host's fingerprint to your known_hosts file to manage this host."

https://linux.systemv.pe.kr/ansible-fingerprint-접속-오류/

