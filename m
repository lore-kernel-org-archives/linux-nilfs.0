From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 0/2] nilfs2: improve inode allocation algorithm
Date: Sun, 12 Oct 2014 12:38:21 +0200
Message-ID: <1413110303-14246-1-git-send-email-andreas.rohner@gmx.net>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi,

The algorithm simply makes sure, that after a directory inode there are
a certain number of free slots available and the search for file inodes
is started at their parent directory.

I havn't had the time yet to do a full scale performance test of it, but 
my simple preliminary tests have shown, that the allocation of inodes 
takes a little bit longer and the lookup is a little bit faster. My 
simple test just creates 1500 directories and after that creates 10 
files in each directory.

So more testing is definetly necessary, but I wanted to get some 
feedback about the design first. Is my code a step in the right 
direction?

Best regards,
Andreas Rohner

Andreas Rohner (2):
  nilfs2: support the allocation of whole blocks of meta data entries
  nilfs2: improve inode allocation algorithm

 fs/nilfs2/alloc.c   | 161 ++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/nilfs2/alloc.h   |  18 +++++-
 fs/nilfs2/ifile.c   |  63 ++++++++++++++++++--
 fs/nilfs2/ifile.h   |   6 +-
 fs/nilfs2/inode.c   |   6 +-
 fs/nilfs2/segment.c |   5 +-
 6 files changed, 235 insertions(+), 24 deletions(-)

-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
