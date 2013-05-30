From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Thu, 30 May 2013 10:13:05 +0400
Message-ID: <1369894385.2255.8.camel@slavad-ubuntu>
References: <51A0A7A0.6010207@antoneliasson.se>
	 <51A0E62D.5060600@antoneliasson.se>
	 <1369809573.2253.31.camel@slavad-ubuntu>
	 <20130529.233757.27789741.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=FaPLdJOJUUA+Xw9hZfo/kn+jH/O/VQR+MtWrkOQ3VfY=;
	b=mSCvwa1YDdP900Jy+AZo0n3cwdfIo5qG0iWZhDEeXjTVa0XFCOIb2XcfB2sbyWXrV2OwoZjuEH3A9BgAgEIsMjJT32kcgXihwsMLaBbwMG6JyzL4/+GdpBonOyvqPSGR;
In-Reply-To: <20130529.233757.27789741.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2013-05-29 at 23:37 +0900, Ryusuke Konishi wrote:
> I don't know whether this may be a hint of this trouble, but according
> to the system log, page_buffers() of nilfs_end_page_io() seems to hit
> an Oops due to an invalid page address "0x36cd":
> 

Yes. There are two possible way to be in nilfs_end_page_io(): (1)
nilfs_segctor_complete_write(); (2) nilfs_abort_logs(). Currently, I
suspect the nilfs_abort_logs() because of compiler optimization. But now
I haven't evidence of it. And it needs to investigate issue more deeply
for stating something definitely, I think.

With the best regards,
Vyacheslav Dubeyko.

> May 22 18:53:31 riven kernel: [ 3821.605568] BUG: unable to handle kernel paging request at 00000000000036cd
> May 22 18:53:31 riven kernel: [ 3821.605577] IP: [<ffffffffa027f1a2>] nilfs_end_page_io+0x12/0xc0 [nilfs2]
> May 22 18:53:31 riven kernel: [ 3821.605591] PGD 19636d067 PUD 19636e067 PMD 0 
> May 22 18:53:31 riven kernel: [ 3821.605597] Oops: 0000 [#1] PREEMPT SMP 
> <snip>
> May 22 18:53:31 riven kernel: [ 3821.605829] Code: ff ff ff 48 81 c4 88 00 00 00 5b 41 5c 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 85 ff 48 89 e5 53 48 89 fb 74 4e <48> 8b 07 f6 c4 08 0f 84 8c 00 00 00 48 8b 47 30 48 8b 00 f6 c4 
> May 22 18:53:31 riven kernel: [ 3821.605873] RIP  [<ffffffffa027f1a2>] nilfs_end_page_io+0x12/0xc0 [nilfs2]
> May 22 18:53:31 riven kernel: [ 3821.605881]  RSP <ffff8801960f7b30>
> May 22 18:53:31 riven kernel: [ 3821.605884] CR2: 00000000000036cd
> 
> where the instruction sequence of "<48> 8b 07 f6 c4 08" is "mov
> (%rdi),%rax; test $0x8, %ah", and corresponds to the part testing
> PagePrivate(page) in page_buffers() macro called within
> nilfs_end_page_io() routine:
> 
>       if (buffer_nilfs_node(page_buffers(page)) && !PageWriteback(page)) {
> 
> This cannot happen, but there may be something we missed.
> 
> 
> Regards,
> Ryusuke Konishi


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
