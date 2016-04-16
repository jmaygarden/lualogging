local log_zmq = require"logging.zmq"
local zmq = require"lzmq.ffi"

local address = "tcp://127.0.0.1:5000"
local zmqContext = zmq.context()
local logger, err  = log_zmq(zmqContext, zmq.PUSH, address)
print(logger)
if not logger then
    print("ZeroMQ Logging Failed:", err)
    return
end

logger:info("logging.socket test")
logger:debug("debugging...")
logger:error("error!")

local socket, err = zmqContext:socket{
    zmq.PULL,
    bind = address
}

for i = 1, 3 do
    local message = socket:recv()
    print(message)
end

zmqContext:term()

print("ZeroMQ Logging OK")

