From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: nilfs2 weird issue - snapshots are gone, cleanerd not running
Date: Mon, 09 Jul 2012 13:49:36 +0400
Message-ID: <1341827376.1965.11.camel@slavad-ubuntu-11>
References: <20120709073300.GP1478@wloczykij>  <10181027.pPHs7IDARt@coil>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=27d8TKXf0ZLRSZOjfzWEMC16DPZgClFwnlP+eY5bo84=;
	b=gdvgVKi/+Jd3FteAVYd50ZsFlj4cpYV2Xt7gIxmjKI9G7dtpgeK3xtMQs0jrdV4Sm/0mkNb/Cs9YSaMhlHbL7DXxd4YC3U+cDg4k6y+AQxBLEDv/Ryu/kIUVriSIwhz7;
In-Reply-To: <10181027.pPHs7IDARt@coil>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>

Hi,

On Mon, 2012-07-09 at 11:33 +0200, dexen deVries wrote:
> using strace -f  on the nilfs_cleanerd should give you a clue what causes the 
> exit. it may exit if can't connect to syslogd.

I think that strace can generate many information. :-) Maybe, firstly,
it makes sense to increase verbosity level of nilfs_cleanerd to debug
level (please, see log_priority parameters in nilfs_cleanerd.conf).

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
