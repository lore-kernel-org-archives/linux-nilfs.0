From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Which version of nilfs do you use?
Date: Fri, 28 Dec 2012 10:06:50 +0400
Message-ID: <1356674810.2126.4.camel@slavad-ubuntu>
References: <AAEC3976-3D79-4170-B1DC-2A04499392DE@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=LQvFlpbNi300puYeBWV8C5PKOOAfl4WL5EC7JnYNzn8=;
	b=bv7wffD//i/kv5B35+TadNB2CfSlnL0cO+7DsYk1eVmV8xcidvlkq38b6xt+x/nQxwi6rxPlWCRXFwNjTyJ2/ygFlWl0suqTtYssyF9voR2THXdFr7X+BPNm31zQ2Iju;
In-Reply-To: <AAEC3976-3D79-4170-B1DC-2A04499392DE-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Elmer Zhang <freeboy6716-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

On Thu, 2012-12-27 at 17:47 +0800, Elmer Zhang wrote:
> Hi konishi ryusuke,
> 
> I am trying to use NILFS2 to make MySQL cold backup, but  the MySQL tables often be crashed. It seems there is some problems with nilfs filesystem.
> 

As I remember, you reported initially the error message about issue with
(inode number=321775) and (blocknr=710153406). If you have new MySQL
tables' crashes then it means that you have new NILFS error messages in
your syslog. Do you have error messages about new inode numbers and
block numbers or about the same?

With the best regards,
Vyacheslav Dubeyko.

> I have described how I use nilfs in this mail: http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01481.html
> 
> Can I know which version of nilfs do you use, and what do you use nilfs for?
> 
> Thanks,
> Elmer Zhang--
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
