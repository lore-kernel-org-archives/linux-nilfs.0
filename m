From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 0/9] nilfs2: introduce functionality of creation of
 sysfs groups and attributes
Date: Tue, 29 Apr 2014 18:50:50 +0400
Message-ID: <1398783050.2185.9.camel@slavad-CELSIUS-H720>
References: <1397837240.2178.51.camel@slavad-CELSIUS-H720>
	 <20140421.011825.85418432.konishi.ryusuke@lab.ntt.co.jp>
	 <1398082463.2212.3.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=7mg2nqPVZPpH6YzpUeFLkYkCKeelK49qr5FfooGlwm0=;
	b=UIH6G5obalr9gJrA8wA8E4WxjzYECsRw5hGCNP3Heq/uTgmdRHnCvm7YPKAXn3OLGWCV4GUVDUjlPKClSM6tZCjg+jjylCkqUX6nlVi5aGbrxVXctpc6EWh0K0MJ6qx4;
In-Reply-To: <1398082463.2212.3.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Ryusuke,

> On Mon, 2014-04-21 at 01:18 +0900, Ryusuke Konishi wrote:

> > 
> > One my question is about the "device" name.  Is it guaranteed that
> > every device has canonical single node name?  What will happen for
> > devices such as /dev/mapper/xxx?
> > 

I've checked this by means of using kpartx utility. At first I've
prepared the image with several partitions on it. Then I've created
device maps from partition table:

kpartx -va ./<image-file>

As a result, I can see such situation:

ls -lah /dev/mapper/
total 0
drwxr-xr-x  2 root root     120 Apr 29 18:38 .
drwxr-xr-x 16 root root    4.2K Apr 29 18:38 ..
crw-------  1 root root 10, 236 Apr 29 09:58 control
lrwxrwxrwx  1 root root       7 Apr 29 18:38 loop0p1 -> ../dm-0
lrwxrwxrwx  1 root root       7 Apr 29 18:38 loop0p2 -> ../dm-1
lrwxrwxrwx  1 root root       7 Apr 29 18:38 loop0p3 -> ../dm-2

Finally, namely, dm-0 (and so on) is used as name of device during
creation of /sys/fs/nilfs2/<device> group. Moreover, other file systems
are used sb->s_id for device naming too. I think that it is safe way of
device naming.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
