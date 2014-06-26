From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs_clean_segments: segment construction failed. (err=-2)
Date: Thu, 26 Jun 2014 17:34:53 +0400
Message-ID: <1403789693.2609.14.camel@slavad-CELSIUS-H720>
References: <53ABA8F3.3010606@gmail.com>
	 <A863805F-8398-42B1-9BEA-35D4425E2404@dubeyko.com>
	 <53ABB6F4.5050508@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=X3KMHrsP8bcJvTUexEjjbicDsE75wm2WZqvBK9U+DtE=;
	b=SxD+8EKXPL8R//d/+shAzAml4+0Ba+N4dMIch0rxnTnJzjt6ncon9s4FlaCaT6jDCOo5inRAY650fhgxkJMFK3WuXNAbJ/uXjQ8iB8YETLhQ8VXbgJ4UKy/asZYtV0hc;
In-Reply-To: <53ABB6F4.5050508-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: dE <de.techno-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2014-06-26 at 11:30 +0530, dE wrote:

[snip]
> I'm using 3.14.4. I thought there was only 1 selection policy, so it's 
> set to timestamp.

It was added 2 additional GC policies. But code for these policies is
available in 3.15 kernel version, as I see.

> 
> nilfs-tune -l /dev/bitcoin/bitcoin
> nilfs-tune 2.1.6
> Filesystem volume name:   test
> Filesystem UUID:          9e1064e0-4ce8-4831-93c0-758b46118884
> Filesystem magic number:  0x3434
> Filesystem revision #:    2.0
> Filesystem features:      (none)
> Filesystem state:         invalid or mounted
> Filesystem OS type:       Linux
> Block size:               1024

Such block size can be a environment of the issue reproducing. I've
fixed one issue for 1KB block size, namely. What do you have for 4 KB
block size? Can you reproduce the issue for 4 KB block size?

> Filesystem created:       Sun Jun 22 15:31:18 2014

So, it's freshly created file system. Am I correct? I hoped to see the
superblock state for the file system with issue. Or, maybe, you've found
the issue soon after file system creation?

> Last mount time:          Thu Jun 26 11:26:50 2014
> Last write time:          Thu Jun 26 11:27:23 2014
> Mount count:              5
> Maximum mount count:      50
> Reserve blocks uid:       0 (user root)
> Reserve blocks gid:       0 (group root)
> First inode:              11
> Inode size:               128
> DAT entry size:           32
> Checkpoint size:          192
> Segment usage size:       16
> Number of segments:       11375
> Device size:              23857201152
> First data block:         4
> # of blocks per segment:  2048
> Reserved segments %:      1
> Last checkpoint #:        208680
> Last block address:       13015040
> Last sequence #:          525413
> Free blocks count:        3723264
> Commit interval:          0
> # of blks to create seg:  0
> CRC seed:                 0x1b525ab2
> CRC check sum:            0xcede51d1
> CRC check data size:      0x00000118
> 
> I suspect this has to do with the segment size. So I've re-formatted a 
> device with the default segment size. Let's see if I can reproduce it now.

So, anyway, I need to understand how to reproduce the issue. As far as I
can see, you have the issue on segctor side during segment construction.
Frankly speaking, it's really bad situation. It means that you don't
save your information into segments. Moreover, it takes place during GC
operations. Operation of trying to create segment is repeated till
success. So, maybe, finally you have success. Otherwise, if you have
sequence of likewise messages ("nilfs_clean_segments: segment
construction failed") and you need to force shutdown then, potentially,
it means that you have dangerous situation.

But, it needs to understand your issue more deeply for any final
statements.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
