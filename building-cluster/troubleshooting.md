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

