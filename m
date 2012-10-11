From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Thu, 11 Oct 2012 10:50:58 +0400
Message-ID: <1349938258.1908.3.camel@slavad-ubuntu>
References: <20121009105239.GV28032@wloczykij>
	 <1349784514.1921.9.camel@slavad-ubuntu> <20121009135833.GX28032@wloczykij>
	 <20121010.012440.17932600.konishi.ryusuke@lab.ntt.co.jp>
	 <20121010073912.GA28032@wloczykij>
	 <1349870593.1889.107.camel@slavad-ubuntu>
	 <20121010220331.GA27763@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=CWrHRnfp9khE2c+tLbHSahAdqeaqnmk8XFcAEGFC6e4=;
	b=Pj/5jPzPay1M3IRiunvr7ALvkxdUhnWyQSx41GeeCGRLNGSYylRgUZQumZMSMe7dw7t0Xkh2sYf1qk7wjVyRVl1SSf91154icLEa44Z1Q0IgOerH0cxU5M+bg7AXgyTI;
In-Reply-To: <20121010220331.GA27763@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2012-10-11 at 00:03 +0200, Piotr Szymaniak wrote:
> On Wed, Oct 10, 2012 at 04:03:13PM +0400, Vyacheslav Dubeyko wrote:
> > I need in superblock's content anyway.
> > 
> > Currently, I need in raw dumps from two blocks after dump preliminary analysis. Because you have message about root inode corruption then it needs to check the root inode raw representation in ifile (ino = 6). As I can see from your dump that the third block of ifile is located in 734205 block (blkoff = 2, blocknr = 734205). Also I can see that root inode content (ino = 2) is located in 734158 block ( blkoff = 0, blocknr = 734158).
> > 
> > Could you share these 2 blocks content?
> > 
> > Or you can check that these blocks contains expected metadata info. I expect that some of these blocks doesn't contains valid metadata info.
> 
> How should i make the dump?
> 

You can use dd for dumping (dd if=/dev/<device> of=<file> bs=<block size> skip=<offset to the block> count=<blocks count>).

With the best regards,
Vyacheslav Dubeyko.

> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
