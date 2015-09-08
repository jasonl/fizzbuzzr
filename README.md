# FizzBuzz

FizzBuzz as a distributed service, using HashiCorp's Serf.

# Installation
You'll need Vagrant and Ansible installed to launch the VMs.

```
$ brew install vagrant
$ brew install ansible
$ vagrant plugin install vagrant-hostmanager
$ vagrant up
```

You should then be able to ssh into any of the four instances with:
```
$ vagrant ssh buzz1 # (or fizz1, fizz2 or buzz2)
```

And running (in the VM), in the `vagrant` home directory:

```
./fizzbuzz
```
