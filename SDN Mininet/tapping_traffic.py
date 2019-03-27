import ryu_ofctl

#clean all existing flow
dpid = '1' #S1
ryu_ofctl.deleteAllFlows(dpid)

#flow 1: h1 to h2 and h3 
flow = ryu_ofctl.FlowEntry()

#h1 output to h2
act = ryu_ofctl.OutputAction(2)
#listen from h1
flow.in_port = 1
#let flow output on h2
flow.addAction(act)
#push to system
ryu_ofctl.insertFlow(dpid,flow)

#h1 output to h3
act1 = ryu_ofctl.OutputAction(3)
#listen from h1
flow.in_port = 1
#let flow output on h3
flow.addAction(act1)
#push to s1
ryu_ofctl.insertFlow(dpid,flow)


#flow 2: h3 to h2 and h1 
flow1 = ryu_ofctl.FlowEntry()

#listen from h3
flow1.in_port = 3
#let flow output on h2
flow1.addAction(act)
#push to s1
ryu_ofctl.insertFlow(dpid,flow1)

#h3 output to h1
act2 = ryu_ofctl.OutputAction(1)
#listen from h1
flow1.in_port = 3
#let flow output on h3
flow1.addAction(act2)
#push to system
ryu_ofctl.insertFlow(dpid,flow1)
