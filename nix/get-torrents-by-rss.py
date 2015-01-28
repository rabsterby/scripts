#!/usr/bin/env python

## @editby    Samoylov Nikolay
## @based on  https://github.com/soddengecko/tranmission_rss.py
##              <https://github.com/soddengecko>
## @project   RSS torrent downloader for Transmission-daemon
## @copyright 2014 < https://github.com/tarampampam >
## @github    https://github.com/tarampampam/scripts/nix/
## @version   0.1.4
##
## @depends   python, Transmission-daemon, python libs (feedparser, difflib,  
##              urllib, urllib2, transmissionrpc, datetime, time, os, sys)

## Installation details on "WD My Book Live":
## # Install ipkg
## > wget http://mybookworld.wikidot.com/local--files/optware/setup-mybooklive.sh && sh setup-mybooklive.sh && rm -f setup-mybooklive.sh
## # Install python26 and easy_install
## > ipkg update && ipkg install python26 py26-setuptools
## # Install packages
## > mkdir -p /tmp2 && TEMP=/tmp2 easy_install feedparser transmissionrpc && rm -Rf /tmp2
## # Run it:
## > /opt/bin/python2.6 ./get_torrents_by_rss.py



# User details
# Add the url to your feed
feed_url = "http://torrentrss.net/getrss.php?rsslink=XXXXXXX"
# Download torrents from feed to this folder
down_path = "/shares/Public/Films/New/"
# Important - path to DIFF files (path must be writeable)
logs_path = "/root/.config/gettorrentsbyrss/"

hist = logs_path + "rss-hist.txt"		# Location of history file
inc  = logs_path + "rss-inc.txt"		# Location of incoming links file
diff = logs_path + "rss-diff.txt"		# Location of difference file
evnt = logs_path + "events.log"			# Location of simple events log

# Transmission RPC details
# Fill in your transmission details below
USER = 'Your_RPC_Login_Here'            # Username
PASS = 'Enter_RPC_password_here'        # Password
HOST = 'localhost'                      # The remote host
PORT = '9091'                           # The same port as used by the server

# -----------------------------------------------------------------------------
# DO NOT MODIFY BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING!!
# -----------------------------------------------------------------------------

print "[i] Init libraries.."

# Import some needed libraries
import feedparser
import difflib
import urllib
import urllib2
import transmissionrpc
import datetime, time
import os, sys

# Prepare for logging ---------------------------------------------------------
d = os.path.dirname(evnt)
if not os.path.exists(d):
    os.makedirs(d)
if not os.path.exists(evnt):
    file(evnt, 'w').close()
evntlog = open(evnt, 'a+b')
now = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
# -----------------------------------------------------------------------------

evntlog.write(now + " : Script runing\r\n")

print "[i] Connect to the transmission RPC server.."

# Use contents of diff file and add them to transmission via the rpc
try:
   # Connect to the transmission RPC server
   tc = transmissionrpc.Client(HOST, port=PORT, user=USER, password=PASS)
   tc.session_stats()
except:
   print "[Fatal] Transmission error, check config or transmission library (root# easy_install transmissionrpc)"
   evntlog.write(now + " : [Fatal] Transmission error\r\n")
   evntlog.close()
   sys.exit(1)

print "[i] Check for log/history/diff files.."

if not os.path.exists(down_path):
    os.makedirs(down_path)

# Create the log files if they do not exist. This will prevent read/write
#   errors later on
d = os.path.dirname(hist)
if not os.path.exists(d):
    os.makedirs(d)
if not os.path.exists(hist):
    file(hist, 'w').close()

d = os.path.dirname(inc)
if not os.path.exists(d):
    os.makedirs(d)
if not os.path.exists(inc):
    file(inc, 'w').close()

d = os.path.dirname(diff)
if not os.path.exists(d):
    os.makedirs(d)
if not os.path.exists(diff):
    file(diff, 'w').close()

print "[i] Parse the feed url.."

# Parse the feed url given in the user details section.
feed = feedparser.parse(feed_url)
# Strip all the unnecessary data and grab the links 
with open(inc, 'w+') as incoming_file:
	for post in feed.entries:
		incoming_file.write(post.link + "\n")
		#post.title
		#post.link
		#post.comments
		#post.pubDate

print "[i] Check the incoming file against the history.."

# Check the incoming file against the history file. If there is a differece,
#   write it to the diff file. 
def build_set(inc):
    # A set stores a collection of unique items.  Both adding items and 
    #   searching for them are quick, so it's perfect for this application.
    found = set()

    with open(inc) as incoming:
        for line in incoming:
            # [:2] gives us the first two elements of the list.
            # Tuples, unlike lists, cannot be changed, which is a requirement 
            #   for anything being stored in a set.
            found.add(tuple(sorted(line.split()[:2])))

    return found

set_more = build_set(inc)
set_del = build_set(hist)

with open(diff, 'w+') as difference:
   # Using with to open files ensures that they are properly closed, even if 
   #   the code raises an exception.

   for res in (set_more - set_del):
      # The - computes the elements in set_more not in set_del.
      difference.write(" ".join(res) + "\n") 


# Open the diff file and add the contents (links) to transmission
f = open(diff)
for line in iter(f):
   try:
      now = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())

      # Add torrents to transmission via the rpc
      tc.add_torrent(line, download_dir=down_path)
      print "   [t] Add task: " + line.strip()
      time.sleep(5)

      evntlog.write(now + " : Added torrent (" + line.strip() + ")\r\n")
   except:
      print "   [Error] Adding torrent error\n"
      now = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
      evntlog.write(now + " : Adding torrent error (" + line.strip() + ")\r\n")
      pass
f.close()

print "[i] Move contents of diff file and append to history file.."

# Move contents of diff file and append to history file, then reset diff file
# Open diff file, read contents then close file
diff_file = open(diff, "r")
diff_data = diff_file.read()
diff_file.close()
# Open history file and appaend diff file data
hist_file = open(hist, "a")
hist_file.write(diff_data)
hist_file.close()

print "[i] Finishing.."

# Now we have finished with the diff and inc files, we open them, write in 
#   nothing and resave the file
open(diff, 'w').close()
open(inc, 'w').close()
evntlog.close()

print "[i] Complete"
