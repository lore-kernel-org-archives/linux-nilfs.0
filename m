From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: =?UTF-8?Q?nilfs=5Fcleanerd=20using=20a=20lot=20of=20disk-write=20?=
 =?UTF-8?Q?bandwidth?=
Date: Tue, 09 Aug 2011 11:18:12 +0100
Message-ID: <94b06fe504b540199f338f9bd4ed890f@mail.shatteredsilicon.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

 Hi,

 I'm seeing nilfs_cleanerd using a lot of disk write bandwidth according 
 to iotop. It seems to be performing approximately equal amounts of reads 
 and writes when it is running. Reads I can understand, but why is it 
 writing so much in order to garbage collect? Should it not be just 
 trying to mark blocks as free? The disk I/O r/w symmetry implies that it 
 is trying to do something like defragment the file system. Is there a 
 way to configure this behaviour in some way? The main use-case I have 
 for nilfs is cheap flash media that suffers from terrible random-write 
 performance, but on such media this many writes are going to cause media 
 failure very quickly. What can be done about this?

 Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
