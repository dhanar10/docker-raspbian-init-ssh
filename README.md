# raspbian-init-ssh-docker

A Raspbian (armhf) container anti-pattern with systemd init and ssh server to mimic a standalone headless system for development and testing purposes on PC (amd64)

## Requirements

- qemu-user-static
- avahi-daemon
- bash
- docker
- git
- ssh

## Usage

### Deployment

```bash
$ git clone https://github.com/dhanar10/raspbian-init-ssh-docker.git
$ cd raspbian-init-ssh-docker
$ bash deploy.sh --name sandbox --hostname sandbox
```

### SSH Access

```bash
$ ssh pi@sandbox.local # Default password: raspberry
```

## Notes

Once deployed, the container will run in the background and it will start and stop together with the host unless it is stopped explicitly

## References

- https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container
- https://developers.redhat.com/blog/2019/04/24/how-to-run-systemd-in-a-container
- https://github.com/defn/docker-systemd
- https://stackoverflow.com/questions/8671308/non-interactive-method-for-dpkg-reconfigure-tzdata
