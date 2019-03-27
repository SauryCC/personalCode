"""
   Custom topology example

   There are 5 switches and 6 Hosts.

   Switch A connected with B and C
   Switch B connected with A, C, D and E
   Switch C connected with A, B, and E
   Switch D connected with B and E
   Switch E connected with B, C, and D

   Switch A has Host 1 and 2
   Switch B has Host 3
   Switch C has Host 4
   Switch D has Host 5
   Switch E has Host 6

Adding the 'topos' dict with a key/value pair to generate our newly defined
topology enables one to pass in '--topo=mytopo' from the command line.
"""

from mininet.topo import Topo

class MyTopo( Topo ):
    "Simple topology example."

    def __init__( self ):
        "Create custom topo."

        # Initialize topology
        Topo.__init__( self )

        # Add hosts and switches
        a_h1 = self.addHost( 'h1' )
        a_h2 = self.addHost( 'h2' )
        b_h3 = self.addHost( 'h3' )
        c_h4 = self.addHost( 'h4' )
        d_h5 = self.addHost( 'h5' )
        e_h6 = self.addHost( 'h6' )

        sw_a = self.addSwitch( 's1' )
        sw_b = self.addSwitch( 's2' )
        sw_c = self.addSwitch( 's3' )
        sw_d = self.addSwitch( 's4' )
        sw_e = self.addSwitch( 's5' )
        rightSwitch = self.addSwitch( 's6' )

        # Add links
        self.addLink( a_h1, sw_a )
        self.addLink( a_h2, sw_a )
        self.addLink( sw_a, sw_b )
        self.addLink( sw_a, sw_c )
        self.addLink( b_h3, sw_b )
        self.addLink( sw_b, sw_c )
        self.addLink( sw_b, sw_d )
        self.addLink( sw_b, sw_e )
        self.addLink( c_h4, sw_c )
        self.addLink( sw_c, sw_e )
        self.addLink( d_h5, sw_d )
        self.addLink( sw_d, sw_e )
        self.addLink( e_h6, sw_e )

topos = { 'mytopo': ( lambda: MyTopo() ) }
