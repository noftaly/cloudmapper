# CloudMapper (Cirpack version)

Steps needed to install and use CloudMapper locally.\
To see the original information about the project, see [cloudmapper.md](./CLOUDMAPPER.md).

## Prerequisites

### Packages

You need python3 and the aws cli to run this project.\
You will also need make, but if you don't have it and don't want to install it, you can look the the `./Makefile` to
see the alternative commands that you should run.

### Add a profile to aws cli

You first have to add your profile to the AWS CLI. To do that, go on the SSO portail, click on your account and on the
desired project, then click on "command-line or programmatic access". Choose one of the options to register your
credentials.

### Create a CloudMapper account

Duplicate the `./config.json.demo` file, at the root of this project. Fill in your account ID and your account name.

### Install dependencies

You must then install the python dependencies. To do that, `cd` at the root of this project and run `make setup`.
If on your computer, the `pip` command refers to python2 and not python3, you might need to do it manually with
`pip3 install -r requirements.txt`.

## Start CloudMapper

### Collect the data

The first step to use CloudMapper is to collect the data from your AWS project. To fetch them, you can use one of these
two commands:
- `make collect account=AccountName profile=AWSProfileName`: to collect all the information. The
`AccountName` is what you entered in the `config.json`, and `AWSProfileName` is your AWS profile name, which
will look like this `ID_Name` (`001234567890_SomeName`).
- `make collecteu account=AccountName profile=AWSProfileName`: to collect the information only in
`eu-west-3`.

This data is saved in `./account-data` and will be used later as a cache pool. If you wish to refetch some data,
you can simply remove the associated file or folder. For example, if you want to remove all internet gateways, you can
run `rm -rf ./account-data/AccountName/**/ec2-describe-internet-gateways.json`. There is a make shortcut for
that: `make cleancache files=file1,file2 account=AccountName`.

### Prepare the data

Once you've collected all the data and it has been cache, you need to generate it for the frontend. A simple
`make prepare account=AccountName` will suffice.

If you want to prepare the data to only show SIG or SSH connections, you can add `connections=sig`
(or `connections=ssh`) to the make command. Otherwise, it will default to `connections=all`.

### Start the webserver

The last step is to boot the webserver up, with `make webserver`.

### Generate a report

If you want, you can generate a little report with audits, charts etc. Run `make report account=AccountName`.

### Make shortcuts

You can use make shortcuts to accelerate your process:
- `make weball account=AccountName`: will prepare the data and start the webserver
- `make remake files=xxx,xxx,xxx account=AccountName profile=AWSProfileName`: will remove the desired cache,
collect the data, and run `make weball`
- `make remakeall account=AccountName profile=AWSProfileName`: will remove all the cache associated to that
account, collect the data and run `make weball`.

It is possible that the collect step fails for some resources for the last two commands. As long as the resources are
not important, then it is not important, but this means make will stop the process. To prevent it from stopping the
process, you can add the `-i` flag to the `make` command.

## The web interface

You can now access all your data on [127.0.0.1:8000](http://127.0.0.1:8000). The nodes might not be in the best
position, and they might be stacked. You can move and rearrange them as you want.\
If you fill like a node or an arrow
should not be displayed, you can click on it, and then click the "Hide" button (eye with a bar on the top left corner).\
If you wish to display all the nodes and arrow again, click the "Show All" button next to it.\
The next two buttons are to highlight all the selected node's neighbors.\
You can then decide to collapse all the containers, or the selected containers.\
The "plug"s icons are to show or hide all the ports.

If you wish to have more information about a node or an arrow, click on it, and then expand the little bar on the top
right corner, and click on "Details". This will show you the JSON data associated with the node.
