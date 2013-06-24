From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Corrupt root inode
Date: Mon, 24 Jun 2013 09:42:16 +0400
Message-ID: <1372052536.2279.5.camel@slavad-ubuntu>
References: <1372043988.4304.140661247622873.2030B278@webmail.messagingengine.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=AzfR37ymFAPexNtxiPHYUaePP+KH+oibEPaB85JZzkQ=;
	b=ph45Fq6tfB9rn3haxV5piLhPv16fQ5Px5JVgJ4T+uxwt33ancCVUEWlfzfL3qDXFPg2yRdY0KpxwVv6ZqC1SfAlMgK98AOb/+Nr9ZkzrbLCqGCL4XEt2nuqcbj/AqcgV;
In-Reply-To: <1372043988.4304.140661247622873.2030B278-2RFepEojUI2N1INw9kWLP6GC3tUn3ZHUQQ4Iyu8u01E@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Bryce,

On Mon, 2013-06-24 at 13:19 +1000, Bryce Gibson wrote:
> Hi :-)
> 
> I have a root nilfs partition that appears to have been corrupted.
> 
> When I try to mount the partition - either on boot or with a liveusb -
> I'm getting "NILFS: corrupt root inode".
> 

Could you share content of system log with exact error messages related
to NILFS2 for beginning? I simply need to see exact error message that
it was printed out.

Thanks,
Vyacheslav Dubeyko.


> I don't believe anything too exciting happened on the last shutdown, but
> it's entirely possible that the umount/sync command didn't execute
> correctly.
> 
> I've tried mounting with with two kernels, being 3.9 and 3.9.4
> 
> In the first case nilfs is built in, in the second it's a module.
> 
> This is an x86_64 laptop.
> 
> I was hoping someone might be able to offer some help with trying to
> recover the partition :-)
> 
> I'm happy to provide any useful info from the drive :-)
> 
> Cheers :-)
> Bryce
> 
> 
> 
> nilfs-tune -l /dev/loop4
> --------------------------
> nilfs-tune 2.1.5
> Filesystem volume name:   (none)
> Filesystem UUID:          fb7fe0c7-f6ef-44e9-8fd7-0125801e5f36
> Filesystem magic number:  0x3434
> Filesystem revision #:    2.0
> Filesystem features:      (none)
> Filesystem state:         valid
> Filesystem OS type:       Linux
> Block size:               4096
> Filesystem created:       Fri Aug 17 00:26:09 2012
> Last mount time:          Sat Jun 22 04:18:22 2013
> Last write time:          Sun Jun 23 01:00:59 2013
> Mount count:              691
> Maximum mount count:      50
> Reserve blocks uid:       0 (user root)
> Reserve blocks gid:       0 (group root)
> First inode:              11
> Inode size:               128
> DAT entry size:           32
> Checkpoint size:          192
> Segment usage size:       16
> Number of segments:       269
> Device size:              2264924160
> First data block:         1
> # of blocks per segment:  2048
> Reserved segments %:      5
> Last checkpoint #:        373808
> Last block address:       405504
> Last sequence #:          568326
> Free blocks count:        73728
> Commit interval:          0
> # of blks to create seg:  0
> CRC seed:                 0x44983069
> CRC check sum:            0xced8962d
> CRC check data size:      0x00000118
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
