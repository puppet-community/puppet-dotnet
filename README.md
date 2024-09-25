# Dotnet module for Puppet

[![Build Status](https://travis-ci.org/voxpupuli/puppet-dotnet.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-dotnet)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-dotnet/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-dotnet)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/dotnet.svg)](https://forge.puppetlabs.com/puppet/dotnet)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/dotnet.svg)](https://forge.puppetlabs.com/puppet/dotnet)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/dotnet.svg)](https://forge.puppetlabs.com/puppet/dotnet)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/dotnet.svg)](https://forge.puppetlabs.com/puppet/dotnet)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What is the dotnet module?](#module-description)
3. [Tasks - Inspect which version(s) of .NET are installed](#tasks)
4. [Setup - The basics of getting started with dotnet](#setup)
    * [What dotnet affects](#what-dotnet-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with dotnet](#beginning-with-dotnet)

5. [Usage - Configuration options and additional functionality](#usage)
6. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
7. [Limitations - OS compatibility, etc.](#limitations)
8. [Development - Guide for contributing to the module](#development)

## Overview

Puppet module for installing and managing [Microsoft .NET framework](http://www.microsoft.com/net).

[![Build Status](https://travis-ci.org/voxpupuli/puppet-dotnet.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-dotnet)
[![Puppet Forge](http://img.shields.io/puppetforge/v/puppet/dotnet.svg)](https://forge.puppet.com/puppet/dotnet)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/puppet/dotner.svg)](https://forge.puppetlabs.com/puppet/dotnet)

## Module Description

This module installs and configures the Microsoft .NET framework on Windows
systems. It support side-by-side installs where appropriate.

## Tasks

You can use the regcheck.rb task (located in the tasks folder) with Bolt to inspect which versions of .NET are installed on your servers. To run the task, use the following base command along with any additional options as necessary:

```
bolt script run regcheck.rb --nodes
```

## Setup

### What dotnet affects

* Installs the .net framework package or the windows server role.

### Beginning with dotnet

Installing the .net 3.5 server role on windows server:

```puppet
  dotnet { 'dotnet35': version => '3.5' }
```

Installing .net 4.5:

```puppet
  dotnet { 'dotnet45':
    version => '4.5'
    deployment_root => 'Z:\packages'
  }
```

## Usage

### Classes and Defined Types

#### Defined Type: `dotnet`

The dotnet module primary definition, `dotnet` install and configures the .net
framework packages/roles

**Parameters within `dotnet`:**
##### `ensure`
Ensures the state of .net on the system. Present or Absent.

##### `version`

The version of .net that you want to be managed by this definition.

##### `package_dir`

If installing .NET from a directory or a mounted network location then this is
that directory

## Reference

### Definitions

### Public Definitions

* [`dotnet`](#define_dotnet): Guides the basic management of the .net framework
  on the system.

### Private Definitions

* [`dotnet::install::feature`](#define-install_feature): Installs dotnet as windows
  feature (.net 3.5)
* [`dotnet::install::package`](#define-install_package): Installs dotnet from a downloaded
  package.

## Limitations

This module is tested on the following platforms:

* Windows 2008 R2

It is tested with the OSS version of Puppet only.

## Development

### Contributing

Please read CONTRIBUTING.md for full details on contributing to this project.
