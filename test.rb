require 'netease_sms'
include NeteaseSms

c = Client.new('appkey', 'appsecret')
cellphones = ["18575750000","18316960000"]
params=["1234"]
c.send_sms("1234", cellphones, params)
