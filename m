From: "LinuxBSDos.com" <finid-aEpbUQpJQqXlKS8GlytQkw@public.gmane.org>
Subject: RAID and file system encryption
Date: Tue, 2 Aug 2011 02:22:24 -0600
Message-ID: <889e085c06295b2f79289eb86be534ef.squirrel@linuxbsdos.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=linuxbsdos.com; s=default;
	h=Content-Transfer-Encoding:Content-Type:MIME-Version:To:From:Subject:Date:Message-ID; bh=fkrxJkCQVZgtLZiUs3Oep5RAlBibjhYgo8+DwfxtQIE=;
	b=UVjf8Kcdi/o0r3epCCecuBAvpBrAMcTCmB+sP3TZFlKRrzK7cjst9JJzidTh5EiqfLJU85pSyJsdvLGHuvCoiluaK4r6yL0H81aTbOApC0HM8qu6ISHL83QE2G+WkPRM;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hi,

Just want to find out if nilfs2 supports RAID and native file system
encryption. Any plans to, if it does not?

Also, at this stage in its development, are there any serious drawbacks to
using nilfs2 on a desktop distribution?

TIA,

--
Fini D.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
