From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 1/9] nilfs2: add /sys/fs/nilfs/features group
Date: Thu, 24 Apr 2014 00:09:49 +0900 (JST)
Message-ID: <20140424.000949.330273957.konishi.ryusuke@lab.ntt.co.jp>
References: <1397837276.2178.52.camel@slavad-CELSIUS-H720>
	<20140421.020501.511716674.konishi.ryusuke@lab.ntt.co.jp>
	<1398151250.2181.13.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1398151250.2181.13.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, 22 Apr 2014 11:20:50 +0400, Vyacheslav Dubeyko wrote:
>> The features directory of sysfs interface should have global features
>> which are independent to nilfs instance or version (e.g. nilfs3, etc)
>> since you chose "nilfs" for the fs directory name.  The revision file
>> is self-contradictory in that sense.  I think it should be placed in
>> each device directory.  Otherwise, we should use "nilfs2" as for the
>> fs directory name.
>> 
> 
> In current implementation:
> (1) fs/nilfs/features/revision - show current supported revision by file
> system driver.
> (2) fs/nilfs/<device>/revision - show file system revision that it saved
> in superblock of the volume. As a result, it shows the revision of file
> system is created on a volume.
> 
> I suppose that we have identical understanding. And current
> implementation provides information about revision in the proper way. If
> I misunderstand something, please, correct me.

If we implement nilfs3 filesystem as a different instance like
ext2/3/4 series, the namespace of nilfs/features/revision will
conflict between nilfs2 and nilfs3.  In reality of course, creating
nilfs3 is unlikely at present, but logically the above namespace
design looks incoherent.

I now feel the namespace should be

  fs/nilfs2/xxxx

In this case, it doesn't cause the confliction regardless whether
we add nilfs3 or not.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
