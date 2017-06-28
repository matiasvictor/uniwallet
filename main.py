"""
main

This snippet is executed just once for the machine.
But it creates a thread that keeps listening 'forever' for requests until it is quit. 
It means it is just a spark for the system which is actually built through the boostrap process.
"""

from wsgiref.simple_server import make_server
from framework.bootstrap import bootstrap
import os
	
host = 'localhost'
port = 8000

httpd = make_server(host, port, bootstrap)
print("Serving on port {}...".format(port))

os.system("HTTP_PORT=3001 P2P_PORT=6001 npm start &")
os.system("HTTP_PORT=3002 P2P_PORT=6002 PEERS=ws://localhost:6001 npm start &")

httpd.serve_forever()

