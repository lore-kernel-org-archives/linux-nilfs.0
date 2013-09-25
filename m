From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] [CRITICAL] nilfs2: fix issue with race condition of
 competition between segments for dirty blocks
Date: Wed, 25 Sep 2013 16:22:43 +0400
Message-ID: <1380111763.2335.32.camel@slavad-ubuntu>
References: <1378221484.4325.51.camel@slavad-ubuntu>
	 <20130905.053518.235784172.konishi.ryusuke@lab.ntt.co.jp>
	 <1378395778.2299.10.camel@slavad-ubuntu>
	 <20130919.030910.27786580.konishi.ryusuke@lab.ntt.co.jp>
	 <1379572190.2310.9.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=4yNZKXjuI4KHZjDoDfuB+zTUf2oh98FsKnOEB167dUY=;
	b=feyw5WV8xI6VEm8I20O1HkLvuKgG/BoOv/YoRPwe9F6rojYyMHIl2jeP6IOSDVfLOiP+Q9iu6MmjxvAPc+Dnf1267JVOcI8VU3ySBuhVOIr34oB2B1uhGLFqGeHhJdYg;
In-Reply-To: <1379572190.2310.9.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org, fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hermes-akuOmOme3sQYOdUovKs6ag@public.gmane.org, szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org, Linux-pOR+BrglI3BO41XttqYhMtHuzzzSOjJt@public.gmane.org, zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org, freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, klangga-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hi Ryusuke,

> On Thu, 2013-09-19 at 03:09 +0900, Ryusuke Konishi wrote:
> 
> [snip]
> > 
> > Vyacheslav, could you please test your patch for 1KB-block format to
> > make sure ?
> > 

I have prepared NILFS2 rootfs with 1 KB block size and I tried to
reproduce the issue as for 1 KB block size as for 4 KB block size. So, I
can see such situation. I reproduce the issue for 4 KB block size,
easily. But I can't reproduce the issue for the rootfs with 1 KB block
size.

I tried to reproduce the issue several times. And every time I reproduce
the issue for 4 KB block size and I don't reproduce the issue for 1 KB
block size.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
