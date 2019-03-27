#!/usr/bin/python

import sys
import re # For regex

import ryu_ofctl
from ryu_ofctl import *

def main(macHostA, macHostB):
    print "Installing flows for %s <==> %s" % (macHostA, macHostB)

    ##### FEEL FREE TO MODIFY ANYTHING HERE #####
    try:
        pathA2B = dijkstras(macHostA, macHostB)
        installPathFlows(macHostA, macHostB, pathA2B)
    except:
        raise


    return 0

# Installs end-to-end bi-directional flows in all switches
def installPathFlows(macHostA, macHostB, pathA2B):
    ##### YOUR CODE HERE #####
    sourceIngress = getMacIngressPort(macHostA)
    sinkIngress = getMacIngressPort(macHostB)
    print(pathA2B)
    for path in pathA2B:
        dpid = path['dpid']
        hostAPort = path['in_port']
        hostBPort = path['out_port']
        print "Sub-process: Installing %s switch flows for port%s <==> port%s" % (dpid, hostAPort, hostBPort)

    
        forwardFlow = FlowEntry()
        backwardFlow = FlowEntry()
    
        forwardAction = OutputAction(hostBPort)
        backwardAction = OutputAction(hostAPort)
    
        forwardFlow.in_port = hostAPort
        forwardFlow.addAction(forwardAction)
    
        backwardFlow.in_port = hostBPort
        backwardFlow.addAction(backwardAction)
    
        # Add the flows to ryu
        insertFlow(str(dpid), forwardFlow)
        insertFlow(str(dpid), backwardFlow)
    
    return

# Calculates least distance path between A and B
# Returns detailed path (switch ID, input port, output port)
#   - Suggested data format is a List of Dictionaries
#       e.g.    [   {'dpid': 3, 'in_port': 1, 'out_port': 3},
#                   {'dpid': 2, 'in_port': 1, 'out_port': 2},
#                   {'dpid': 4, 'in_port': 3, 'out_port': 1},
#               ]
# Raises exception if either ingress or egress ports for the MACs can't be found
def dijkstras(macHostA, macHostB):

    # Optional helper function if you use suggested return format
    def nodeDict(dpid, in_port, out_port):
        assert type(dpid) in (int, long)
        assert type(in_port) is int
        assert type(out_port) is int
        return {'dpid': dpid, 'in_port': in_port, 'out_port': out_port}

    # Optional variables and data structures
    INFINITY = float('inf')
    UNKNOWN = "UNKNOWN"
    pathAtoB = [] # Holds path information

    ##### YOUR CODE HERE #####
    # Get the list of switch
    sourceIngress = getMacIngressPort(macHostA)
    sinkIngress = getMacIngressPort(macHostB)
    sourceDPID = sourceIngress['dpid']
    sinkDPID = sinkIngress['dpid']
    sourceInPort = sourceIngress['port']
    sinkOutPort = sinkIngress['port']
    # Initialize the switch map structure
    switches = listSwitches()['dpids']
    switchMap = {i: {'distance': INFINITY, 'parent':UNKNOWN, 'in_port':UNKNOWN, 'out_port': UNKNOWN}  for i in switches}
    switchMap[sourceDPID]['distance'] = 0.0
    switchMap[sourceDPID]['parent'] = 'self'
    switchMap[sourceDPID]['in_port'] = sourceInPort
    
    while len(switches) > 0:
        # Extract switch of min distance
        cur_min = min(switches, key=lambda item: switchMap[item]['distance'])
        switches.remove(cur_min)
        # Find out outbound links for the min switch
        # First ignore links for previously extracted switches
        links_of_min = list(filter(lambda item:item['endpoint2']['dpid'] in switches, listSwitchLinks(cur_min)['links']))
        # Then filter links only going outbound from min
        outbound_links_from_min = list(filter(lambda item:item['endpoint1']['dpid']==cur_min, links_of_min))
        # Finally determine which outbound links should be relaxed
        links_to_relax = list(filter(lambda item:switchMap[item['endpoint2']['dpid']]['distance'] > switchMap[item['endpoint1']['dpid']]['distance'] + 1.0, outbound_links_from_min))
        # Relax each eligible outbound link accordingly
        for link in links_to_relax:
            switchMap[link['endpoint2']['dpid']]['distance'] = switchMap[link['endpoint1']['dpid']]['distance'] + 1.0
            switchMap[link['endpoint2']['dpid']]['parent'] = link['endpoint1']['dpid']
            switchMap[link['endpoint2']['dpid']]['in_port'] = link['endpoint2']['port']
            switchMap[link['endpoint2']['dpid']]['out_port'] = link['endpoint1']['port']
#    print(switchMap)

    switchMap[sourceDPID]['in_port'] = sourceInPort
    
    # Generate pathAtoB based on relaxed switchMap. Note that the *out_port* stored in switchMap is actually the out_port of parent switch
    cur_DPID = sinkDPID
    out_port = sinkOutPort
    while True:
        in_port = switchMap[cur_DPID]['in_port']
        pathAtoB.insert(0, nodeDict(int(cur_DPID), int(in_port), int(out_port)))
        if switchMap[cur_DPID]['parent'] is 'self':
#            print('Ta-da!')
#            print(pathAtoB)
            return pathAtoB
        else:
            out_port = switchMap[cur_DPID]['out_port']
            cur_DPID = switchMap[cur_DPID]['parent']

    print ("Something is wrong")

    return []



# Validates the MAC address format and returns a lowercase version of it
def validateMAC(mac):
    invalidMAC = re.findall('[^0-9a-f:]', mac.lower()) or len(mac) != 17
    if invalidMAC:
        raise ValueError("MAC address %s has an invalid format" % mac)

    return mac.lower()

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print "This script installs bi-directional flows between two hosts"
        print "Expected usage: install_path.py <hostA's MAC> <hostB's MAC>"
    else:
        macHostA = validateMAC(sys.argv[1])
        macHostB = validateMAC(sys.argv[2])

        sys.exit( main(macHostA, macHostB) )