From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH 0/1] nilfs2: add mount option that reduces super block writes
Date: Thu, 30 Jan 2014 03:46:59 +0100
Message-ID: <cover.1391048231.git.andreas.rohner@gmx.net>
References: <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg@mail.gmail.com>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFvQSYSu5CGxs+K6bZUCtq17PrS_paX3bXBuLBRTba_XWYGgAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

Hi,

This is only a hacky proof of concept implementation and probably 
full of nasty bugs. I also havn't really tested it. I was 
just interested how hard it would be to implement Clemens' suggestion 
of writing the super block only at umount time and do a linear scan 
of all the segments in case of file system failure.

The linear scan is only performed if the file system wasn't shut down 
properly. So for normal operation there shouldn't be any slowdown.

I repurposed the ss_pad field of nilfs_segment_summary to contain the 
crc seed, because I needed a way to distinguish left over segments 
from previous nilfs2 volumes from real segments that are part of the 
current file system. 

I don't really expect it to be merged or anything. Maybe it can spark 
a discussion. Maybe somebody could try it out on an old SD-Card and 
time the mount command or something.

I tested it on a virtual machine. It seemed to recover fine when I 
killed the VM and mounted it again. Clearly more testing is 
necessary...

br,
Andreas Rohner

---
Andreas Rohner (1):
  nilfs2: add mount option that reduces super block writes

 fs/nilfs2/segbuf.c        |  3 ++-
 fs/nilfs2/segment.c       |  3 ++-
 fs/nilfs2/super.c         | 10 +++++++--
 fs/nilfs2/the_nilfs.c     | 54 ++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/nilfs2_fs.h |  4 +++-
 5 files changed, 66 insertions(+), 8 deletions(-)

-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
