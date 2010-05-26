From: Gordan Bobic <gordan-UpbECiGlrmGsTnJN9+BGXg@public.gmane.org>
Subject: SSD and non-SSD Suitability
Date: Wed, 26 May 2010 11:18:02 +0100
Message-ID: <4BFCF55A.80205@bobich.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I've got a somewhat broad question on the suitability of nilfs for 
various workloads and different backing storage devices. From what I 
understand from the documentation available, the idea is to always write 
sequentially, and thus avoid slow random writes on old/naive SSDs. Hence 
I have a few questions.

1) Modern SSDs (e.g. Intel) do this logical/physical mapping internally, 
so that the writes happen sequentially anyway. Does nilfs demonstrably 
provide additional benefits on such modern SSDs with sensible firmware?

2) Mechanical disks suffer from slow random writes (or any random 
operation for that matter), too. Do the benefits of nilfs show in random 
write performance on mechanical disks?

3) How does this affect real-world read performance if nilfs is used on 
a mechanical disk? How much additional file fragmentation in absolute 
terms does nilfs cause?

4) As the data gets expired, and snapshots get deleted, this will 
inevitably lead to fragmentation, which will de-linearize writes as they 
have to go into whatever holes are available in the data. How does this 
affect nilfs write performance?

5) How does the specific writing amount measure against other file 
systems (I'm specifically interested in comparisons vs. ext2). What I 
mean by specific writing amount is for writing, say, 100,000 random 
sized files, how many write operations and MBs (or sectors) of writes 
are required for the exact same operation being performed on nilfs and 
ext2 (e.g. as measured by vmstat -d).

Many thanks.

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
