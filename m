From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix issue of nilfs_set_page_dirty for page at EOF boundary
Date: Wed, 1 May 2013 18:14:56 +0400
Message-ID: <FB20329D-7028-478C-896E-88E1106A34A5@dubeyko.com>
References: <20130501.163930.56348973.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=ItZUJkDfWj4EnqG5Yme3ZPI52QkdmjSk0lsHitQnKek=;
	b=tH+ekHDESjJKPwnca6MRig0Zg1oVvgagUrJJvo+SCnByCRcnedkWTJdVIQHMQCWSOEFqv1yS3IXyCrtpL7YI+9KzQCr/XlneyhdU9c7C2AKI3caNtqPwh2i4Soo87EQf;
In-Reply-To: <20130501.163930.56348973.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>

Hi Ryusuke,

On May 1, 2013, at 11:39 AM, Ryusuke Konishi wrote:

> Hi Vyacheslav,
> 
> Here I post the bug fix of the problem that Anthony Doggett reported
> and you originally proposed a bug fix with the patch titled "nilfs2:
> fix issue with broken bmap for the case of block size lesser than 4
> KB".
> 
> I tested this patch against the mainline and stable trees, and so far
> it works fine (the issue is fixed without any side effect).
> 
> If you meet an issue on this patch, or have a question, please let me
> know.
> 

Yes, this patch much better than mine. :-)

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
