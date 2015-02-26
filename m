From: Benixon Dhas <Benixon.Dhas-Sjgp3cTcYWE@public.gmane.org>
Subject: Making Nilfs ZAC Compliant
Date: Thu, 26 Feb 2015 19:54:48 +0000
Message-ID: <3764420FCC841C4DAE85E3B76FC61A773BF05FB6@wdscexmb03>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: "'linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "'konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org'" <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Hi All,

We are trying to make Nilfs work with a SMR Device which adheres to Zoned ATA Commands(ZAC) Specification.
One of the restrictions in the specification is reading an unwritten part of the Zone(Segment in Nilfs) will cause a read error.

We observe that Nilfs does not write a complete physical segment(we use 256MB segment)  always. After digging in the source a while we figured that this
is due to the fact that Nilfs requires a certain number of minimum blocks for constructing a partial segment (NILFS_PSEG_MIN_BLOCKS), which currently is 2.
So we see some segments where the last block (in our case a block is 4k)  is not being written to.

When some utilities like garbage collector and dump segment reads (May not be an exhaustive list)  a segment it tries to read the entire physical segment. This causes read errors in the kernel and hence retries for the last unwritten block in certain segments.
In an attempt to solve this problem we were trying to figure out if we can write some dummy data to the remaining unutilized blocks in the segment. But we are not sure what would be the best way to do this.

Another solution we had in mind was to figure out all places where segments are read, and modify it to prevent it from reading unwritten blocks. But we feel this might be more complex solution and might impact performance more.

Please advise us on the best way to solve the problem. Also what would be architecturally a best place to fix the problem.

Thanks,
Benixon
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
