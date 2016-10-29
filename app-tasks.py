#!/usr/bin/python
import json
import sys
out = []
try:
    doc = json.load(sys.stdin)
except Exception as e:
    sys.stderr.write('ERROR: no valid JSON\n')
    sys.exit(1)

if 'app' in doc and 'tasks' in doc['app']:
    for task in doc['app']['tasks']:
        port = doc['app']['ports'][0]
        if 'ipAddresses' in task:
            for ipAddress in task['ipAddresses']:
                if port > 0:
                    out.append(ipAddress['ipAddress'] + ' ' + str(port))
                elif 'ports' in task:
                    for port in task['ports']:
                        out.append(ipAddress['ipAddress'] + ' ' + str(port))
if len(out) > 0:
    print '\n'.join(out)
