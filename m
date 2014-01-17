From: "Mark Trumpold" <markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>
Subject: Re:  Does nilfs2 do any in-place writes?
Date: Fri, 17 Jan 2014 19:19:56 +0000
Message-ID: <W856311016549541389986396@atl4webmail15>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, Mark Trumpold <markt-qk0wvQ0ghJwAvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


>-----Original Message-----
>From: Vyacheslav Dubeyko [mailto:slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org]
>Sent: Thursday, January 16, 2014 10:31 PM
>To: 'Mark Trumpold'
>Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: Does nilfs2 do any in-place writes?
>
>On Thu, 2014-01-16 at 17:48 +0000, Mark Trumpold wrote:
>> Hello All,
>> 
>> I am wondering what the impact of in-place writes of the
>> superblock has on SSDs in terms of wear?
>> 
>> I've been stress testing our system which uses Nilfs, and
>> recently I had a SSD fail with the classic messages indicating
>> low level media problems -- and also implicating Nilfs as trying
>> to locate a superblock (I think).
>> 
>> Following is a partial dmesg list: 
>> 
>> [    7.630382] Sense Key : Medium Error [current] [descriptor]
>> [    7.630385] Descriptor sense data with sense descriptors (in hex):
>> [    7.630386]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
>> [    7.630394]         05 ff 0e 58 
>> [    7.630397] sd 0:0:0:0: [sda]  
>> [    7.630399] Add. Sense: Unrecovered read error - auto reallocate failed
>> [    7.630401] sd 0:0:0:0: [sda] CDB: 
>> [    7.630402] Read(10): 28 00 05 ff 0e 54 00 00 08 00
>> [    7.630409] end_request: I/O error, dev sda, sector 100601432
>> [    7.635326] NILFS warning: I/O error on loading last segment
>> [    7.635329] NILFS: error searching super root.
>> 
>> 
>
>I don't think that this issue is related to superblocks. Because I can't
>see in your output the magic signature of NILFS2. For example, I have
>such first 16 bytes in superblock:
>
>00000400  02 00 00 00 00 00 34 34  18 01 00 00 52 85 db 71  |......44....R..q|
>
>Of course, I don't know your partition table details but I doubt that
>sector 100601432 is a superblock sector. Moreover, you have error
>messages that inform about troubles with loading last segment during
>super root searching.
>
>We have on NILFS2 only two blocks that live under in-place update
>policy. An update frequency is not so high. So, I suppose that any FTL
>can easily provide good wear leveling support for superblocks. But, of
>course, in-place update is not good policy for flash-based devices,
>anyway.
>
>Maybe, I misunderstand something in your output. But I suppose that
>during stress-testing you can discover I/O error in any part of volume.
>Because it is really hard to predict when you will exhaust spare pool of
>erase blocks.
>
>With the best regards,
>Vyacheslav Dubeyko.
>
>
>

Hi Vyacheslav,

Thank you for taking a look at this.

Your assessment makes good sense, and I am relieved we have
a plausible explanation.

BTW: I upgraded to the 3.11.6 linux kernel (per your's and Ryusuke's
suggestions) to pick up the most recent Nilfs devel, and am finding things
to be very stable.

Best regards,
Mark T.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
