#!/usr/bin/env python2

import subprocess

def get_pass(account):
    return subprocess.check_output(
        ["pass", account],
    ).splitlines()[0]
