#!/usr/bin/env python3
#
#
#
#
import os
import sys

# Analyse
# Github Step Summary
#
# Want composite action to report package version
# Want composite action to report.xml results (for matrix of testing params)

def gh_pages_url(sfx: str) -> str:
    sfx = '' if sfx is None else sfx
    url = ''
    if 'GITHUB_REPOSITORY' in os.environ:
        repo = os.environ['GITHUB_REPOSITORY'].split('/')
        url = 'https://' + repo[0] + '.github.io/' + '/'.join(repo[1:])
    return url + sfx


def emit_github_step_summary(args) -> None:
    link = gh_pages_url('/test_reporter/')
    print(f"# TEST Report Summary ([link]({link}))")
    print("")
    print(">[!WARNING]")
    print("> __This is an example only of the intention of this action__")
    print("")
    # JUnit style results.xml
    print("")
    print("")
    print("")


def main():
    args = sys.argv[1:]
    if len(args) > 0 and args[0] == '--github-step-summary':
        emit_github_step_summary(args)
    else:
        print("test_report.py {}".format(' '.join(args)))
    sys.exit(0)


if __name__ == "__main__":
    main()
