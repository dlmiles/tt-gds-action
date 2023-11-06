#!/usr/bin/env python3
#
#
#
#
import os
import sys

# Analyse
# Emit Summary
# Emit DOT cross-reference
# Emit web friendly (JSON?) cross-reference database
# Emit HTML extended report
#	Build diagrams/picture
#	Load a specific path diagram
# DOT cross-reference WASM widget (this is separate project in itself)
#	like python xdot but online, allowing traversal of partial circuit graph
#		(and on demand expansion towards input/output, to next gate, to next flop, to output)
#	filter out dlymetal/dlygate/clkbuf/buf insertions
#	populate with path timing data (from report)
#	use flop/logic symbols
#	use custom sky130 cell symbols
# Github Step Summary

def gh_pages_url(sfx: str) -> str:
    sfx = '' if sfx is None else sfx
    url = ''
    if 'GITHUB_REPOSITORY' in os.environ:
        repo = os.environ['GITHUB_REPOSITORY'].split('/')
        url = 'https://' + repo[0] + '.github.io/' + '/'.join(repo[1:])
    return url + sfx


def emit_github_step_summary(args) -> None:
    # FIXME this would interrogate the data and collate and most important things
    # Fastest:min -> Typical:nom -> Slowest:max
    link = gh_pages_url('/sta_reporter/')
    print(f"# STA Report Summary ([link]({link}))")
    print("")
    print(">[!WARNING]")
    print("> __This is an example only of the intention of this action__")
    print("")
    print("| Param                    |        Value | Corner       | Status  |")
    print("| :--------                | -----------: | :------      | :------ |")
    print("| CLOCK_PERIOD (ns)        |  (50 Mhz) 20 | all          |         |")
    print("| Worst Slack (-hold)      |         0.11 | all          | $\\textcolor{green}{MET}$    |")
    print("| Worst Slack (-setup)     |        -0.01 | all          | $\\textcolor{green}{MET}$    |")
    print("| TNS (slack ns)           |     -1012.00 | Fastest:min  | $\\textcolor{red}{VIOLATED}$ |")
    print("| WNS (slack ns)           |       -16.32 | Fastest:min  | $\\textcolor{red}{VIOLATED}$ |")
    print("| Critical Path (slack ns) |         2.32 | all          | $\\textcolor{green}{MET}$    |")
    print("| max slew (ns)            | (+190%) 2.23 | Fastest:min  | $\\textcolor{red}{VIOLATED}$ |")
    print("| max cap                  | (+290%) 2.23 | Fastest:min  | $\\textcolor{orange}{VIOLATED}$ |")
    print("| max fanout (count)       |    (+19%) 29 | Fastest:min  | $\\textcolor{orange}{VIOLATED}$ |")
    print("")
    print("")
    print("## Typical Corner Summary")
    print("")
    print("$\\textcolor{green}{No hold violations at the typical corner}$<br/>")
    print("$\\textcolor{green}{No setup violations at the typical corner}$<br/>")
    print("$\\textcolor{green}{No max slew violations at the typical corner}$<br/>")
    print("$\\textcolor{green}{No max capcitance violations at the typical corner}$<br/>")
    print("$\\textcolor{green}{No max fanout violations at the typical corner}$<br/>")
    print("")
    print("")
    print("## Critial Path Summary (Slowest:max:clk)")
    print(" Startpoint: [\\_\\_123__.Q]()")
    print(" Endpoint: [\\_\\_987__.D]()")
    print(" Path: 18 logic, 4 clkbuf, 2 buf, 1 dlymetal, 2 dlygate (27 total)")
    print(" Propagation Delay: 34.34ns (29.120 MHz) [estimated fMAX: 41.21ns (24.266 Mhz)]")
    print(" Slack: 2.32 $\\textcolor{green}{(MET)}$")
    print(" Remarks: critical path contains, 2 max slew ([\_\_232__](), [\_\_972__]()) and 1 max cap ([\_\_232__]()) violations")
    print("")
    print("")
    print("## Max slew violations")
    print("")
    print("Fastest Corner: 18 nets, 0.75/?/?/? (/?%/?%/?%) target/min/mean/max")
    print("Fastest Corner (over 1.5ns):  8 nets, 1.50/1.76/1.99/2.04 (/+17.3%/+32.6%/+36%) target/min/mean/max")
    print("")
    print("Typical Corner:  9 nets, 0.75/?/?/? (/?%/?%/?%) target/min/mean/max")
    print("Typical Corner (over 1.5ns):  3 nets, 1.50/1.52/1.87/2.09 (/+1.3%/+24.6%/+39.3%) target/min/mean/max")
    print("")
    print("Slowest Corner:  2 nets, 0.75/0.80/1.09/2.23 (/+6%/+45%/+197%) target/min/mean/max")
    print("Slowest Corner (over 1.5ns):  1 net, 1.50/2.23/2.23/2.23 (/+48%/+48%/+48%) target/min/mean/max")
    ## Maybe we're interested in the spread, maybe 0.75 to 1.5 is amber status, but over 1.5 is red ?
    ## FIXME want histogram picture here ?
    ##  Maybe indicate which nets show up in all 3 corners (red), 2 corners (amber) or just 1 corner (yellow)
    ##  hover over dynamic statistics, mouse pointer, worst than this count
    ##  cross-reference any wires with VIOLATED reporting ?
    ##  Number of input gates connected to nets with high slew (might as well link to browser, hover over cell type, hover over upstream cell type (not *buf/dly*))
    print("")
    print("## Max cap")
    ## FIXME want histogram picture here ?
    ##  cross-reference max-slew/max-fanout for common union
    ##  cross-reference any wires with VIOLATED reporting ?
    print("")
    print("## Max fanout")
    ## FIXME want histogram picture here ?
    ## Maybe 10 to 25 is amber status ?  but over 25 is red ?
    ##  cross-reference max-slew/max-fanout for common union
    ##  cross-reference any wires with VIOLATED reporting ?
    print("")
    print("## Unannotated (32 elements)  [+]()")
    print("")
    print("## Unconstrained (12 elements)  [+]()")
    print("")
    print("")


def main():
    args = sys.argv[1:]
    if len(args) > 0 and args[0] == '--github-step-summary':
        emit_github_step_summary(args)
    else:
        print("sta_report.py {}".format(' '.join(args)))
    sys.exit(0)


if __name__ == "__main__":
    main()
