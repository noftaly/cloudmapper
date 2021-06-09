"""
Copyright 2018 Duo Security

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following
disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote
products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------
"""

import json
import os
import glob
import argparse
from shared.common import get_account

__description__ = "Remove cache"

def remove_cache(account, type, rm_all):
    if rm_all:
        os.removedirs('./account-data/{}'.format(account['name']))
    else:
        files = glob.glob('./account-data/{}/**/{}.json'.format(account['name'], type))
        for file in files:
            try:
                os.remove(file)
            except:
                print("Error while deleting file :", file)


def run(arguments):
    # Parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--all",
        help="Reset all the cache for the given acccount",
        dest="all",
        default=False,
    )
    parser.add_argument(
        "--config",
        help="Config file name",
        default="config.json",
        type=str,
    )
    parser.add_argument(
        "--account",
        help="Account to collect from",
        required=True,
        type=str,
        dest="account_name",
    )
    parser.add_argument(
        "--type",
        help="The type to remove",
        required=False,
        type=str,
        dest="type",
    )
    args = parser.parse_args(arguments)
    if not args.type and not args.all:
        exit('ERROR: Type or All has to be specified')

    # Read accounts file
    try:
        config = json.load(open(args.config))
    except IOError:
        exit('ERROR: Unable to load config file "{}"'.format(args.config))
    except ValueError as e:
        exit(
            'ERROR: Config file "{}" could not be loaded ({}), see config.json.demo for an example'.format(
                args.config, e
            )
        )
    account = get_account(args.account_name, config, args.config)

    remove_cache(account, args.type, args.all)
