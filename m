From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 4/5] nilfs-utils: add support for NILFS_IOCTL_SET_SUINFO ioctl
Date: Sat, 25 Jan 2014 19:16:49 +0300
Message-ID: <6C1F6E9B-5EA1-45E3-9E0F-62A4D7059247@dubeyko.com>
References: <cover.1390310509.git.andreas.rohner@gmx.net> <72f8c37258d08ba9793b0c1bb0374dd8efcd4756.1390310509.git.andreas.rohner@gmx.net> <62FA32DB-83AC-4570-BD73-618C169390FE@dubeyko.com> <52E16AE4.4000303@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=4+YIffO0FFijXXOEKh00jXh54tc3dU+o12JVmB2b0hQ=;
	b=N1M9YCn7XK8EDuud+t8gaFTUugzbzoj2iLjo5mA34/8XWysvIqfy21+BpODs1ekDYstXdJqaCJY47NS2AT/837o/JcNgwXxmq27eQe8TxN60hHLJgdij9CWqxodv5F0d;
In-Reply-To: <52E16AE4.4000303-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Jan 23, 2014, at 10:17 PM, Andreas Rohner wrote:

> 
>> Do you free allocated memory in the case of error? 
> 
> Yes I immediately free it before I check the return value. Could you
> please read the code a bit more carefully, before you ask such questions?

+	freeblocks = (nilfs_get_blocks_per_segment(nilfs) * n)
+				- (nilfs_vector_get_size(vdescv)
+				+ nilfs_vector_get_size(bdescv));
+
+	/* if there are less free blocks than the
+	 * minimal threshold try to update suinfo
+	 * instead of cleaning */
+	if (freeblocks < minblocks * n) {
+		ret = gettimeofday(&tv, NULL);
+		if (ret < 0)
+			goto out_lock;
+
+		supv = malloc(sizeof(struct nilfs_suinfo_update) * n);
                             ^^^^^^ memory allocation
+		if (supv == NULL) {
+			ret = -1;
+			goto out_lock;
+		}
+
+		for (i = 0; i < n; ++i) {
+			supv[i].sup_segnum = segnums[i];
+			supv[i].sup_flags = 0;
+			nilfs_suinfo_update_set_lastmod(&supv[i]);
+			supv[i].sup_sui.sui_lastmod = tv.tv_sec;
+		}
+
+		ret = nilfs_set_suinfo(nilfs, supv, n);
+		free(supv);
                ^^^^ memory freeing
+		if (ret >= 0) {
+			/* success, tell caller
+			 * to try another segment/s */
+			ret = -EGCTRYAGAIN;
+			goto out_lock;
+		}
+	}
+

Ok. But I can suggest to free memory in the place of error processing
(goto out_lock) and at the end of function for success. Otherwise, it
looks like hiding free() call. And it is very easy to forget about memory
freeing. It is good practice, I suppose, to group memory freeing operations.

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
