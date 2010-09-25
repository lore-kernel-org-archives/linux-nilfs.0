From: Yuehai Xu <yuehaixu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Performance about nilfs2 for SSD
Date: Sat, 25 Sep 2010 18:54:04 -0400
Message-ID: <AANLkTinLswg7ko3T-cGsSMMqPfcM0dZB7GN2o6Q2b3gY@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:received:date:message-id
         :subject:from:to:cc:content-type;
        bh=A0ni7HjxvvDfj5JOwYcD2zfsY8IZw8LryYm6W8D3vJg=;
        b=T3l+o8FBwFkyE5qpSA4iGLQuY5bXr7hxfE0qBTu59GojHSBkEiSQxu7aPHSx6BzBY0
         77Say4vzWmwNFQzyW9Rtdr8SQoOcE7bSMTpwsoVW8NOC9zR4FVmwi8JU/vnlk+XPWSbg
         QK3t4UGJNSuPDKQcBe1knJx9btZ0Ap8UFWqMk=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yhxu-jgEIgUtgKzeHXe+LvDLADg@public.gmane.org

Hi,

I have a SSD which is Intel x25-v, I use it to test the performance of
different file systems. The results seems confusing to me. It is from
postmark in which I set file number to 50,000 with each size from 9216
bytes to 15360 bytes

	EXT3	NILFS2	BTRFS	EXT4	XFS	REISERFS	EXT2					
PostMark(R)	146.67Kb/s  52.21Kb/s	90.59Kb/s	
172.12Kb/s	60.39Kb/s	146.67Kb/s	83.25Kb/s
PostMark(W)	28.09Mb/s	10Mb/s	17.35Mb/s	31.04Mb/s	11.56Mb/s	28.09Mb/s	15.94Mb/s

From the results, the throughput both for R/W of NILFS2 is much
smaller than EXT3. As I noticed that the performance of NILFS2 for SSD
is much better than other file systems from the web site. What's the
matter with my own test result? My kernel is 2.6.32, and I use default
way to format NILFS2, nothing special is done. So, my questions are:

1. Are there any special parameters that I need to configure when I
mount/format my SSD?
2. Is the performance much different from different kind of SSD?
3. As I know, NILFS2 is a kind of Log-file system, which means it
always makes the random writes sequentially and tries to avoid the
cost of overwrite for SSD. Does it need to overwrite its meta data?
Since I think NILFS2 should always make a mapping table, how about
when the mapping table need to be updated?
4. What's special has done to optimize the performance of SSD? I guess
Log-file systems might have better performance than fast file systems
such as EXT2/3, but at least right now the results shows that I was
wrong.

Thanks,
Yuehai
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
