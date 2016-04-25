import threading
from threading import Thread
import facebook
import time

user_list = "xax"
result_list = "xax-result.txt"

THREADS = 20
FBNUM = 0

user_token="<FB TOKEN>"

def findPost(graph, fbid, connection_type):
    try:
        feed = graph.get_connections(fbid, connection_type, limit=250)
        found = False
        while not found and 'paging' in feed and 'next' in feed['paging'] and feed['paging']['next']:
            for post in feed['data']:
                date = post['created_time']
                found = True
                break
            if not found:
                nextUrl = feed['paging']['next']
                parsed = urlparse.urlparse(nextUrl)
                until = int(urlparse.parse_qs(parsed.query)['until'][0])
                feed = graph.get_connections(fbid, connection_type, limit=250, until=until)
    except facebook.GraphAPIError as e:
        date = "error"
        return date
    if not found:
        date = "not found"
    return date

def userInfo(graph, fbid):
    try:
        profile = graph.get_object(fbid)
        return profile['updated_time'], profile['name'], "OK"
    except facebook.GraphAPIError as e:
        return "", "", e.message, 

def fillfromfile():
    lines = [line.strip() for line in open(user_list)]
    for item in lines:
        FBID.append(item)

def tmain():
    for tn in range(THREADS):
        t = Agent(tn)
        t.start()

class Agent(Thread):
    def __init__(self, tnumber):
        Thread.__init__(self)
        self.tnumber = tnumber
        t.append("T"+str(self.tnumber))

    def run(self):
        graph = facebook.GraphAPI(user_token)
        connection_type = "feed"
        while len(FBID) > 0:
            fbid = FBID.pop(0)
            lastLogin, profileName, error = userInfo(graph, fbid)
            if error != "OK":
                #print "https://www.facebook.com/%s;%s" % (fbid, error)
                writeInfo(fbid, error)
            else:
                post_time = findPost(graph, fbid, connection_type)
                if post_time != "not found" and post_time != "error":
                    if lastLogin > post_time:
                        lastDate = lastLogin
                    else:
                        lastDate = post_time
                else:
                    lastDate = lastLogin
                #print "https://www.facebook.com/%s;%s" % (fbid, lastDate)
                writeInfo(fbid, lastDate)

        t.remove("T"+str(self.tnumber))
        print "Threads "+str(self.tnumber)+" exits"
        exit()
 
def writeInfo(user, date):
    global FBNUM
    FBNUM = FBNUM+1
    if FBNUM % 1000 == 0:
        fout.flush()
    print "Checking records #'%s':'https://www.facebook.com/%s' => last activity %s" % (FBNUM, user, date)
    info = "%s;%s\n" % (user, date)
    fout.write(info)

if __name__ == "__main__":
    time_start = time.time()
    print "Start time: ", time_start
    FBID = []
    fillfromfile()
    fout = open(result_list,'w')
    t = []
    tmain()
    while threading.activeCount()>1:
        pass
    time_end = time.time()
    time_diff = time_end - time_start
    print "End time: ", time_end
    print "Total time: ", time_diff
    print "End of checks. %s IDs completed" % FBNUM
    fout.close()
