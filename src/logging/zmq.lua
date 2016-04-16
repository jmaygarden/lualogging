-------------------------------------------------------------------------------
-- Sends the logging information through a socket using luasocket
--
-- @author Judge Maygarden (jmaygarden@gmail.com)
--
-- @copyright 2016 Kepler Project
--
-------------------------------------------------------------------------------

local logging = require"logging"

function logging.zmq(zmqContext, socketType, address, logPattern)
	return logging.new( function(self, level, message)
		local s = logging.prepareLogMsg(logPattern, os.date(), level, message)

		local socket, err = zmqContext:socket{
            socketType,
            connect = address
        }
		if not socket then
			return nil, err
		end

		local cond, err = socket:send(s)
		if not cond then
			return nil, err
		end
		socket:close()

		return true
	end)
end

return logging.zmq

