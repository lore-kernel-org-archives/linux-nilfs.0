From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Fri, 12 Oct 2012 15:07:33 +0400
Message-ID: <1350040053.2026.47.camel@slavad-ubuntu>
References: <20121009135833.GX28032@wloczykij>
	 <20121010.012440.17932600.konishi.ryusuke@lab.ntt.co.jp>
	 <20121010073912.GA28032@wloczykij>
	 <1349870593.1889.107.camel@slavad-ubuntu>
	 <20121010220331.GA27763@wloczykij> <1349938258.1908.3.camel@slavad-ubuntu>
	 <20121011092300.GB27763@wloczykij> <1349950320.1908.11.camel@slavad-ubuntu>
	 <20121011180332.GE27763@wloczykij> <1350025832.2026.43.camel@slavad-ubuntu>
	 <20121012103119.GF27763@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=3I5FXJlpcsfgrVUIrvH6udkJHb8nUCM2oRB7p19ugxY=;
	b=Dit4GxwCnxZrbTgjQ+ze4AkD+hCQwePkpFzqHfj86gwFJG4A5/+k0oKjNERI5ir7czxf12wQ+rrZFNpCF5Sjk7DwY99N7jgnbdYSNsrW9+GHKG+B6I8yKUhr0StGRzyU;
In-Reply-To: <20121012103119.GF27763@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2012-10-12 at 12:31 +0200, Piotr Szymaniak wrote:

> How to dump second superblock?
> Number of segments:	  922
> Device size:		  7741636608
> 
> Should I dump last 4096 bytes of device size?
> 

Yes, as I can understand, dump of last 4096 bytes of device size should contain second superblock.

With the best regards,
Vyacheslav Dubeyko. 

> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
