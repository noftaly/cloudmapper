# CloudMapper

Steps needed to install and use CloudMapper locally.
To see the original information about the project, see [cloudmapper.md](./CLOUDMAPPER.md).

## Prerequisites

### Packages

You need python3 and the aws cli to run this project.
You will also need make, but if you don't have it and don't want to install it, you can look the the `./Makefile` to
see the alternative commands that you should run.

### Add a profile to aws cli

You first have to add your profile to the AWS CLI. To do that, go on the SSO portail, click on your account and on the
desirect projet, then click on "command-line or programmatic access".
Choose one of the options to register your credentials.

### Create a CloudMapper account

Duplicate the `./config.json.demo` file, at the root of this project. Fill in your account ID and your account name.

### Install dependencies

You must then install the python dependencies. To do that, `cd` at the root of this project and run `make setup`.
If on your computer, the `pip` commands refers to python2 and not python3, you might need to do it manually with
`pip3 install -r requirements.txt`.

## Start CloudMapper

### Collect the data

The first step to use CloudMapper is to collect the data from your AWS project. For that, you can use one of these two
commands:
- `make collect account=CloudMapperAccountName profile=AWSProfileName`: to collect all the informations. The
`CloudMapperAccountName` is what you entered in the `config.json`, and `AWSProfileName` is your AWS profile name, which
will look like this `ID_Name` (`001234567890_SomeName`).
- `make collect account=CloudMapperAccountName profile=AWSProfileName`: to collect the information only in `eu-west-3`.

These data are saved in `./account-data` and will be used later as a cache pool. If you which to refetch some data,
you can simply remove the associated file or folder. For example, if you want to remove all internet gateways, i can
run `rm -rf ./account-data/CloudMapperAccountName/**/ec2-describe-internet-gateways.json`. There is a make shortcut for
that: `make cleancache files=file1,file2 account=CloudMapperAccountName`.

### Prepare the data

Once you've collected all the data and it has been cache, you need to generate it for the frontend. A simple
`make prepare account=CloudMapperAccountName` will suffice.

### Start the webserver

The last step is to boot the webserver up, with `make webserver`.

### Make shortcuts

You can use make shortcuts to accelerate your process:
- `make weball account=CloudMapperAccountName`: will prepare the data, generate a report and start the webserver
- `make remake files=xxx,xxx,xxx account=CloudMapperAccountName profile=AWSProfileName`: will remove the desired cache,
collect the data, and run `make weball`
- `make remakeall account=CloudMapperAccountName profile=AWSProfileName`: will remove all the cache associated to that
account, collect the data and run `make weball`.

It is possible that the collect step fails for some resources for the last two commands. As long as the resources are
not important, then it is not important, but this means make will stop the process. You might need to run `make weball`
on your own after that.

## The web interface

You can now access all your data on [127.0.0.1:8000](http://127.0.0.1:8000). The nodes might not be in the best
position, and they might be stacked. You can move and rearrange them as you want. If you fill like a node or an arrow
should not be displayed, you can click on it, and then click the "Hide" button (eye with a bar on the top left corner).
If you wish to display all the nodes and arrow again, click the "Show All" button next to it.
The next two buttons are to highlight all the selected node's neighbors.
You can then decide to collapse all the containers, or the selected containers.
The "plug"s icons are to show or hide all the ports.

If you wish to have more informations about a node or an arrow, click on it, and then expand the little bar on the top
right corner, and click on "Details". This will show you the JSON data associated with the node.
