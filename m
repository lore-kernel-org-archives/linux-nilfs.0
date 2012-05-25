From: Kenneth Langga <klangga-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: NILFS: bad btree node
Date: Fri, 25 May 2012 22:30:40 +0800
Message-ID: <CAHmELnWvFNdiePs=mQJ=nqfsxJ_49zxawa9jncE-RJ2-omYHOg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to:content-type;
        bh=bhH8brvT7273eBfQTRjFKvvq0jopEHsdMozwxuGa3NM=;
        b=mKnOIYxr6pzRwFL2TzWzPmFqKS61ILRXpZhLS0gLIxX2Fh08fozy0eBim+rdzTRQdG
         9lxm2d2Aa1ScHMIcT3ewpV2m9uduDZHPJzseqncd5xWuI/zV19URGnVDXebIfgY07tSO
         d+9MXkYWNtbifJtQ5iQ6LPL7d8GaXK9qhKsjbtxVjANk1xL6TLDI5ZGQ7ozXreCG8/UF
         ilBo4nkzGhK/qZjFr8M7oGB/LOX9dU11nJU6hXgFBWKmF8141fZrKjmtovIoyDCEkHqO
         EEiI/7n6dr0F4Jln4rKMoY436g2OqWIhXksFO/fpY8DMLBu+XBRZDtMgrCWO4VDfRUO2
         PgpQ==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I got this error from kernel.log:

NILFS: bad btree node (blocknr=111560943): level = 242, flags = 0x3f,
nchildren = 23369
NILFS error (device sdc2): nilfs_bmap_lookup_contig: broken bmap
(inode number=19696)

What is the correct course of action for this type of error? And what
would have caused this?
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
