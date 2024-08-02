## YaST Network Module

[![Workflow Status](https://github.com/yast/yast-network/workflows/CI/badge.svg?branch=master)](
https://github.com/yast/yast-network/actions?query=branch%3Amaster)
[![OBS](https://github.com/yast/yast-network/actions/workflows/submit.yml/badge.svg)](https://github.com/yast/yast-network/actions/workflows/submit.yml)
[![Coverage Status](https://coveralls.io/repos/yast/yast-network/badge.png)](https://coveralls.io/r/yast/yast-network)
[![Code Climate](https://codeclimate.com/github/yast/yast-network/badges/gpa.svg)](https://codeclimate.com/github/yast/yast-network)

The YaST2 Network module manages network configuration including device configuration,
DNS, Routing and more

## Features

  * device configuration via netconfig
  * network service selection (netconfig, NetworkManager, wicked)
  * routing configuration
  * DNS and hostname setup
  * remote administration setup

Some features are SuSE Linux specific.

## Installation

To install the latest stable version on openSUSE or SLE, use zypper:

    $ sudo zypper install yast2-network

## Running

To run the module, use the following command as root:

    $ yast2 lan

This will start complex dialog with most of features available.
For more options see section on [running YaST](https://en.opensuse.org/SDB:Starting_YaST) 
in the YaST documentation.

## Documentation

User YaST documentation is available in [general YaST documentation](https://en.opensuse.org/Portal:YaST).

Developer documentation specific for this module is in the [doc](doc)
directory.

### Overview

#### Frontend
![frontend overview](doc/frontend.svg)

Now frontend mostly describes Add/Edit dialog for interfaces which is the most complex. For links to parts see:

* [Interface Config Builder](https://www.rubydoc.info/github/yast/yast-network/master/Y2Network/InterfaceConfigBuilder)
* [Add Dialog](https://www.rubydoc.info/github/yast/yast-network/master/Y2Network/Dialogs/AddInterface)
* [Edit Dialog](https://www.rubydoc.info/github/yast/yast-network/master/Y2Network/Dialogs/EditInterface)
* Tabs and Widgets live in Y2Network::Widgets

## Development

This module is developed as part of YaST. See
[YaST development documentation](
  https://en.opensuse.org/openSUSE:YaST_development)
for information about [YaST architecture](
  https://en.opensuse.org/openSUSE:YaST:_Architecture_Overview),
[development environment](
https://en.opensuse.org/openSUSE:YaST:_Preparing_the_Development_Environment)
and other development-related topics.

To get the source code, clone the GitHub repository:

    $ git clone https://github.com/yast/yast-network.git

Alternatively, you can fork the repository and clone your fork. This is most
useful if you plan to contribute into the project.

Before doing anything useful with the code, you need to setup a development
environment. Fortunately, this is quite simple:

    $ sudo zypper install yast2-devtools

To run the module from the source code, use the `run` Rake task:

    $ rake run

To run the testsuite, use the `test` Rake task:

    $ rake test

For a complete list of tasks, run `rake -T`.

Before submitting any change please read our [contribution
guidelines](CONTRIBUTING.md).

If you have any question, feel free to ask at the [development mailing
list](http://lists.opensuse.org/yast-devel/) or at the
[#yast](https://web.libera.chat/#yast) IRC channel on libera.chat.
We'll do our best to provide a timely and accurate answer.
