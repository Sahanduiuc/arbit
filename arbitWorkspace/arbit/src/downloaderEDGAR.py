import edgar.downloader
import sched
import datetime
import time

class downloader:
	schedule = sched.scheduler(time.time, time.sleep)
	
	def __init__(self):
		self.schedule.enterabs(time.time(), 0, self.download, ())
		self.schedule.run()

	def download(self):
		print ('Running quote download at ' + datetime.datetime.today().isoformat())
	
		# Assume the system clock uses NY time.
		today = datetime.date.today()
		tomorrow = today + datetime.timedelta(days=1)
	
		# 2:30am tomorrow
		# It looks like new master files show up at 2:01am, though are sometimes delayed as late as 2:14am.
		# Need to check when form 4 files show up
		downloadTime=datetime.time(2,30,0)
		downloadDateTime = datetime.datetime.combine(tomorrow, downloadTime)
		downloadTime = time.mktime(downloadDateTime.timetuple())
	
		print ('Downloading...')
	
		edgar.downloader.run()
		
		# Reschedule the download to run again tomorrow.
		self.schedule.enterabs(downloadTime, 0, self.download, ())
	
		print ('Done with EDGAR download at ' + datetime.datetime.today().isoformat())
		
downloader()