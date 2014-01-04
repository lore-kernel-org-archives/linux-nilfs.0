From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2] fs/nilfs2: Integer overflow in
 nilfs_ioctl_wrap_copy()
Date: Sat, 04 Jan 2014 22:43:41 +0900 (JST)
Message-ID: <20140104.224341.57444288.konishi.ryusuke@lab.ntt.co.jp>
References: <20140103161015.b354edd36176e4016840135b@linux-foundation.org>
	<20140104.180646.52171591.konishi.ryusuke@lab.ntt.co.jp>
	<73948D05-9012-4A6A-8C4C-46C6A11F6454@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <73948D05-9012-4A6A-8C4C-46C6A11F6454-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 4 Jan 2014 16:10:07 +0300, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> On Jan 4, 2014, at 12:06 PM, Ryusuke Konishi wrote:
> 
> [snip]
> 
>> Sorry for the poor documentation of nilfs_argv struct and
>> nilfs_ioctl_wrap_copy function.
>> 
> 
> [snip]
> 
>> I modified the commit log and also added a few comment lines to
>> clarify the address of the patch.  The modified patch is attached
>> below.
>> 
> 
> Maybe it makes sense to add comment for the function at whole too?
> I suppose that description of the patch contains many useful details
> about the method at whole.

Yes, I would appreciate it if you help to add the missing comment of
the function (with a separate patch).

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
