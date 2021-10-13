function stamp = getTimeStamp()

stamp = char(datetime('now','TimeZone','local','Format',['yyyy-MM-dd_HH-mm-ss']))