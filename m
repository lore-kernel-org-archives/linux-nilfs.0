From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Binary diff between two snapshots?
Date: Tue, 16 Dec 2014 00:18:53 +0900 (JST)
Message-ID: <20141216.001853.291636235984035545.konishi.ryusuke@lab.ntt.co.jp>
References: <4CB39535-0200-459E-8FCD-59F130F0D185@openminds.be>
	<1418592731.4039.5.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=DvWO6dOyPbpgPctzfQqfBILCFET02e5xYCJkKVr/Ayk=;
        b=g5p4GIgUnXcQUomN/Bc8lo1Y8kXZLWBcw6H8r2AeY/F9fZNLm2Bex2cUYM1sBJb00O
         5LyRSkFELXTrLe+NqnmLCKP936vTOuFYX/9qN6sIn/ypXKiKTIjyGAxNkTb2yd3CyleO
         d6kNJSt/+EasHKLJg5Xvarf/b8RV/nHgaFBiLkIMWMQN+IrfIoLUjQs5SPRLPfmZoX+i
         AEggZrGkypAswcAXZdpeuCY047uaqPdVl1TXb/Pchb+s8d02sDScVW1sjQxRQOYDSR+N
         PbIJwa09S56kAdYJR1MKk4QNrxZZaFR+zBm59g/gQb2zMpHR3QH9Zq3MLteNqP7xVJfD
         i3cw==
In-Reply-To: <1418592731.4039.5.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Frank Louwers <frank-sbM3GJIWwA3bB1ukUYwELw@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, 14 Dec 2014 13:32:11 -0800, Vyacheslav Dubeyko wrote:
> On Mon, 2014-12-08 at 20:12 +0100, Frank Louwers wrote:
>> Hi all,
>> 
>> I was wondering if there is a way to get a binary “diff” between two snapshots? Output would be the contents off the blocks that are changed + some metadata to tell which blocks it actually are. Goal would be:
>> 
>> - take FS at snapshot A, sync that snapshot to a different volume/LUN/remote machine/…
>> - [changes occur to the fs]
>> - take FS at point B
>> 
>> I’d now like to get the “diff” between A and B, and get it in a format we can apply to the secondary (“backup”) volume that is still at level A. Outcome would be that the second volume is a copy of the first volume, at point B.
>> 
>> Inspiration: https://github.com/mpalmer/lvmsync
>> 
> 
> There are experimental branches:
> 
> nilfs-utils  git://github.com/konis/nilfs-utils.git  (diff-v2 branch)
> kernel       git://github.com/konis/nilfs2.git       (diffapi-v2 branch)
> 
> The nilfs-diff shows changes between two checkpoints of nilfs2 volume.
> 
> [1] http://marc.info/?l=linux-nilfs&m=141294888117653&w=2
> [2] http://marc.info/?l=linux-nilfs&m=134404514116556&w=2

Sorry for my late reply.  (And, thanks Vyacheslav for following)

This patchset is very experimental and only implements diff of changed
inodes.  it doesn't provide API to enumerate data extents changed
between two snapshots.

To realize the fs-diff, we need to implement the missing API.

Another approach is listing block numbers changed between two
snapshots by scanning throuch DAT file - a special metadata of NILFS
used to translate relocatable block addresses to real ones.

This approach, however, is not flexible than the former because the
size of source partition must equal that of destination partition, and
also needs to sync partitions before running garbage collection.

Regards,
Ryusuke Konishi

> Thanks,
> Vyacheslav Dubeyko.
> 
>> 
>> 
>> Frank Louwers
>> Openminds bvba
>> 
>> Tel: +32 9 225 82 91--
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
