#!/bin/env python3
#
# Testing xml node.
#

import sys, getopt
from xml.etree.ElementTree import dump, parse

#options
be_quiet = False

def notice(*objs):
    print(*objs, file=sys.stderr)
    
def report(*objs):
    global be_quiet
    
    if (be_quiet):
        return
    
    print(*objs)

def parse_xml(file, tag1):
    tree = parse(file)
    root = tree.getroot()
    ns = root.tag.split('}')[0] + ('}')
    
#    notice("root tag:", root.tag)
#    notice("xmlns:", ns)
    
# Searching all subelements(fast enough).
    element = root.find('.//' + ns + tag1)
    if element == None:
        notice("Can't find the %s tag." % tag1)
        exit(1)

    rows = []
    for child in element:
        rows.append(child.text)
    
    if (len(rows) == 0):
        report(rows)
        return

    val = rows[0]
    for i in rows:
        if i != val:
            report(rows)
            return
        
#The node is good.
    report(val)

def usage():
    notice('''
Testing xml node. v1.0
notice("usage: testxml -t tag <filename>
-h, --help:\tThis message
-t, --tag:\tTag name is mandatory.
-q, --quient:\tDon't print out result.
''')
    
def main(argv):
    global be_quiet
    tag = ''
    
    try:
        opts, args = getopt.getopt(argv, 'hqt:', ['help', 'quiet', 'tag='])

    except getopt.GetoptError:
        usage()
        notice("I've gotten error.")
        exit(2)
        
    for opt, arg in opts:
        if opt == '-h' or opt == '--help':
            usage()
            exit()
            
        elif opt in ("-t", "--tag"):
            tag = arg

        elif opt in ("-q", "--quiet"):
            be_quiet = True
            
    if (tag == ''):
        usage()
        exit(1)
        
    file = args[0]
    
    notice('args/tag: %s/%s' % (args, tag))
    
    parse_xml(file, tag)

if __name__ == "__main__":
    main(sys.argv[1:])
