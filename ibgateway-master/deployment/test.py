from ibapi import wrapper
from ibapi.client import EClient
class IBWrapper(wrapper.EWrapper):
    def __init__(self, connector):
        super().__init__()
        self.connector = connector
        self.md_payloads = dict()
    # IB Callbacks =============================================================
    def nextValidId(self, orderId: int):
        super().nextValidId(orderId)
        print("setting nextValidOrderId: {}".format(orderId))
        self.nextValidOrderId = orderId
        print("NextValidId:", orderId)
    # Implementation Methods ===================================================
    def create_payload(self, reqId, position, operation, side, price, size):
        pass
    def send(self, payload):
        pass
    # EXAMPLE OF DEPTH MD RECEIVED FROM IB
    # UpdateMarketDepth. ReqId: 2001 Position: 0 Operation: 1 Side: 1 Price: 440.72 Size: 1
class Connector:
    def __init__(self):
        self.ib_wrapper = IBWrapper(self)
        self.client = IBClient('localhost', 4001, 1, self.ib_wrapper)
    def connect(self):
        self.client.connect_to_gw()
class IBClient(EClient):
    def __init__(self, host, port, ib_client_id, wrapper):
        super().__init__(wrapper)
        self.ib_host = host
        self.ib_port = port
        self.ib_client_id = ib_client_id
    def connect_to_gw(self):
        print('Trying to connect to Interactive Brokers...')
        self.connect(self.ib_host, self.ib_port, self.ib_client_id)
        print('  >> Connection to IB gateway successfully!!!')
connector = Connector()
connector.connect()
print("Bye")
