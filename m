From: mikael-m2T68/X/qvZAfugRpC6u6w@public.gmane.org
Subject: NILFS error after power loss
Date: Sun, 16 Jul 2017 21:37:01 +0200
Message-ID: <39eaa9df1d7d61fbcbfba585f26896e5@fripost.org>
References: <3909a3843e9fc28c7c1f7812f47b7b2b@fripost.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fripost.org; h=
        user-agent:message-id:references:in-reply-to:subject:subject
        :from:from:date:date:content-transfer-encoding:content-type
        :content-type:mime-version; s=20140703; t=1500233827; x=
        1502048228; bh=KBTKF0AtmpwJHJgAFOt6z+2/Uzl8Wbxml144DY5GHZY=; b=i
        didWZCJBU5IeIFCij5w/IH7xIELVYIqM0xvBEEBkws32I1gFdu/CldbvGBXpTVbm
        P2eW1ZPqxj0Mex5IbFhX/enOAn5IljgN8da0ScAgFYEwY52R6PIUMG3SmIt5Xe2M
        wfGwsmhm05CI/aihFSEm1YRmIX8vPS8mQzJUGpsMXs=
In-Reply-To: <3909a3843e9fc28c7c1f7812f47b7b2b-m2T68/X/qvZAfugRpC6u6w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

The battery in my laptop, Lenovo X1 Carbon, with NixOS version 17.03 ran 
out of power in May. When I started the laptop again, it did not boot 
properly. I have used another laptop since then.

I booted it with a Live USB with NixOS 17.03 and followed the 
instructions under the section 'NILFS got stuck' at 
http://nilfs.sourceforge.net/en/faq.html:

# echo t > /proc/sysrq-trigger
# dmesg

I should say I have no prior experience of sysrq. Anyhow, you can see 
the dmesg output at the following link:

https://mega.nz/#F!4UoFwYaQ!u7GEnZ3n0BUyNexe3vI2-w

Please get back to me if you want more information.

Not sure if this is of any interest but this is an excerpt from 
journalctl:

Apr 24 06:55:22 nixos kernel: NILFS (dm-0): bad btree node (ino=1609, 
blocknr=13626216): level = 51, flags = 0x44, nchildren = 12298
Apr 24 06:55:22 nixos kernel: NILFS error (device dm-0): 
nilfs_bmap_lookup_contig: broken bmap (inode number=1609)
Apr 24 06:55:22 nixos kernel: Remounting filesystem read-only
Apr 24 06:55:22 nixos kernel: NILFS (dm-0): bad btree node (ino=1609, 
blocknr=13626216): level = 51, flags = 0x44, nchildren = 12298
Apr 24 06:55:22 nixos kernel: NILFS error (device dm-0): 
nilfs_bmap_lookup_contig: broken bmap (inode number=1609)
Apr 24 06:55:22 nixos kernel: NILFS (dm-0): bad btree node (ino=1609, 
blocknr=13626216): level = 51, flags = 0x44, nchildren = 12298
Apr 24 06:55:22 nixos kernel: NILFS error (device dm-0): 
nilfs_bmap_lookup_contig: broken bmap (inode number=1609)
Apr 24 06:55:22 nixos kernel: NILFS (dm-0): bad btree node (ino=1609, 
blocknr=13626216): level = 51, flags = 0x44, nchildren = 12298
Apr 24 06:55:22 nixos kernel: NILFS error (device dm-0): 
nilfs_bmap_lookup_contig: broken bmap (inode number=1609)
Apr 24 06:55:22 nixos kernel: NILFS (dm-0): bad btree node (ino=1609, 
blocknr=13626216): level = 51, flags = 0x44, nchildren = 12298
Apr 24 06:55:22 nixos kernel: NILFS error (device dm-0): 
nilfs_bmap_lookup_contig: broken bmap (inode number=1609)
Apr 24 06:55:22 nixos kernel: NILFS (dm-0): bad btree node (ino=1609, 
blocknr=13626216): level = 51, flags = 0x44, nchildren = 12298
Apr 24 06:55:22 nixos kernel: NILFS error (device dm-0): 
nilfs_bmap_lookup_contig: broken bmap (inode number=1609)
Apr 24 06:55:22 nixos kernel: NILFS (dm-0): bad btree node (ino=1609, 
blocknr=13626216): level = 51, flags = 0x44, nchildren = 12298
Apr 24 06:55:22 nixos kernel: NILFS error (device dm-0): 
nilfs_bmap_lookup_contig: broken bmap (inode number=1609)
Apr 24 06:55:22 nixos kernel: NILFS (dm-0): bad btree node (ino=1609, 
blocknr=13626216): level = 51, flags = 0x44, nchildren = 12298
Apr 24 06:55:22 nixos kernel: NILFS error (device dm-0): 
nilfs_bmap_lookup_contig: broken bmap (inode number=1609)
Apr 24 06:55:22 nixos kernel: NILFS (dm-0): bad btree node (ino=1609, 
blocknr=13626216): level = 51, flags = 0x44, nchildren = 12298
Apr 24 06:55:22 nixos kernel: NILFS error (device dm-0): 
nilfs_bmap_lookup_contig: broken bmap (inode number=1609)
Apr


Kind regards,

Mikael Andersson
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
