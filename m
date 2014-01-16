From: "Mark Trumpold" <markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>
Subject: Re: Does nilfs2 do any in-place writes?
Date: Thu, 16 Jan 2014 17:48:41 +0000
Message-ID: <W9375626839227141389894521@atl4webmail02>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello All,

I am wondering what the impact of in-place writes of the
superblock has on SSDs in terms of wear?

I've been stress testing our system which uses Nilfs, and
recently I had a SSD fail with the classic messages indicating
low level media problems -- and also implicating Nilfs as trying
to locate a superblock (I think).

Following is a partial dmesg list: 

[    7.630382] Sense Key : Medium Error [current] [descriptor]
[    7.630385] Descriptor sense data with sense descriptors (in hex):
[    7.630386]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
[    7.630394]         05 ff 0e 58 
[    7.630397] sd 0:0:0:0: [sda]  
[    7.630399] Add. Sense: Unrecovered read error - auto reallocate failed
[    7.630401] sd 0:0:0:0: [sda] CDB: 
[    7.630402] Read(10): 28 00 05 ff 0e 54 00 00 08 00
[    7.630409] end_request: I/O error, dev sda, sector 100601432
[    7.635326] NILFS warning: I/O error on loading last segment
[    7.635329] NILFS: error searching super root.


Best regards,
Mark T.



--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
