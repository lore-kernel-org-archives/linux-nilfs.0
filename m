From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Mon, 15 Oct 2012 09:58:18 +0400
Message-ID: <1350280698.2488.4.camel@slavad-ubuntu>
References: <20121010220331.GA27763@wloczykij>
	 <1349938258.1908.3.camel@slavad-ubuntu> <20121011092300.GB27763@wloczykij>
	 <1349950320.1908.11.camel@slavad-ubuntu> <20121011180332.GE27763@wloczykij>
	 <1350025832.2026.43.camel@slavad-ubuntu> <20121012103119.GF27763@wloczykij>
	 <1350040053.2026.47.camel@slavad-ubuntu> <20121012114043.GG27763@wloczykij>
	 <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC@dubeyko.com>
	 <20121014204740.GL27763@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=af1dElu58I7TCjNDUZd3IwbiuFD4bDw7zN3RIqWl9lQ=;
	b=kGhS4gvqVns7j0Uny1mfYBPEcNOuZKxq0jEXbDN21xXTasgDzaYFXQbYp10Rw2zbOR+jQk88PqTu0JYHi59TrMP1qw0V32kPBjv40wLCo1G/NgPMjq5xPMhhtBq3mIQJ;
In-Reply-To: <20121014204740.GL27763@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 2012-10-14 at 22:47 +0200, Piotr Szymaniak wrote:
> On Sun, Oct 14, 2012 at 06:55:59PM +0400, Vyacheslav Dubeyko wrote:
> > So, it is clear that #359 segment is empty. Moreover, #357 segment doesn't contain ifile block with blkoff = 2 as I can see from dumpseg output. Currently, I know that #358 segment contains empty ifile block with blkoff = 2. It needs to find segment which contains not empty block of ifile for blkoff = 2. Could you share dumpseg output of all previous segments (for #358)?
> 
> I suppose that the dump was to big for the list, but I hope you guys got
> it.
> 

Please, send the dump only on my personal e-mail. I need in it for analysis.

Thanks,
Vyacheslav Dubeyko. 

> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
