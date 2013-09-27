From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] [CRITICAL] nilfs2: fix issue with race condition of
 competition between segments for dirty blocks
Date: Sat, 28 Sep 2013 01:43:46 +0900 (JST)
Message-ID: <20130928.014346.248890599.konishi.ryusuke@lab.ntt.co.jp>
References: <20130919.030910.27786580.konishi.ryusuke@lab.ntt.co.jp>
	<1379572190.2310.9.camel@slavad-ubuntu>
	<1380111763.2335.32.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380111763.2335.32.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org, fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org, szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org, Linux-pOR+BrglI3BO41XttqYhMtHuzzzSOjJt@public.gmane.org, zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org, freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, klangga-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Wed, 25 Sep 2013 16:22:43 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
>> On Thu, 2013-09-19 at 03:09 +0900, Ryusuke Konishi wrote:
>> 
>> [snip]
>> > 
>> > Vyacheslav, could you please test your patch for 1KB-block format to
>> > make sure ?
>> > 
> 
> I have prepared NILFS2 rootfs with 1 KB block size and I tried to
> reproduce the issue as for 1 KB block size as for 4 KB block size. So, I
> can see such situation. I reproduce the issue for 4 KB block size,
> easily. But I can't reproduce the issue for the rootfs with 1 KB block
> size.
> 
> I tried to reproduce the issue several times. And every time I reproduce
> the issue for 4 KB block size and I don't reproduce the issue for 1 KB
> block size.

Ok, thank you for your effort trying to reproduce the issue.

Andrew, please send this patch to the upstream.


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
