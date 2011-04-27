From: Ivan Telichko <itelichko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Regarding =?utf-8?b?YGBwcm9ibGVt?= with =?utf-8?b?bmlsZnNfY2xlYW5lcmQ=?= - part 2'' and =?utf-8?b?YGBOaWxmc19jbGVhbmVyZA==?= err=-17''
Date: Wed, 27 Apr 2011 09:27:59 +0000 (UTC)
Message-ID: <loom.20110427T111017-105@post.gmane.org>
References: <loom.20110425T072626-629@post.gmane.org> <20110425.163414.06954497.ryusuke@osrg.net> <loom.20110426T231606-740@post.gmane.org> <20110427.154007.255390385.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> Is there dumpseg data of the segment 1718 and 1719 ?

I put them here: http://pastebin.com/8aHrkv7V
 
> If the duplicated block exists, it will look like:
> 
>       finfo
>         ino = 97606, cno = 281, nblocks = xx, ndatblk = xx
>           ...
>           vblocknr = xxxxxxx, blkoff = 14, blocknr = xxxxxxxx
>           ...
> 

The first block in segment 1718 looks exactly like this. Is it wrong,
even if segments are different?

Also, I tried to change mc_nsegments_per_clean to 3 in
nilfs_cleanerd.conf. After that, cleanerd started and worked for
some time, but then died again. Now duplicate blocks were found
in segments 1363 and 1364. No free space was created in the
process.

---

Regards,
   Ivan Telichko


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
