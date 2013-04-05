From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS2 and data integrity
Date: Fri, 05 Apr 2013 12:01:18 +0400
Message-ID: <1365148878.2112.4.camel@slavad-ubuntu>
References: <201304051545.16927.onlyjob@member.fsf.org>
	 <1365142569.2075.14.camel@slavad-ubuntu>
	 <201304051748.12466.onlyjob@member.fsf.org>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=FzCDhjJw5ZRzveTfkAvy8PEcwZgrfURo6aJ3MOYszkY=;
	b=MwNtcWCp7sGOjXrOhGwXeIYtzi+AO+AtG3YxydHaZZASY4PlpsxS5NAZf1wFWisQjG4w5wrPGzHnFpsJiMlRveeli7QJMPRuLUOZEAy+VACL4TbgbTb+U9BWKcH8Lio4;
In-Reply-To: <201304051748.12466.onlyjob-IGUgQLVVQiRCV4ILt04nZQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dmitry Smirnov <onlyjob-IGUgQLVVQiRCV4ILt04nZQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Dmitry,

On Fri, 2013-04-05 at 17:48 +1100, Dmitry Smirnov wrote:
> Hi Vyacheslav,
> 
> On Fri, 5 Apr 2013 17:16:09 Vyacheslav Dubeyko wrote: 
> > First of all, I think that it needs to distinguish two issues in your
> > e-mail. The first one is the issue with Samsung HDD and the second is
> > the issue with "bad b-tree node".
> 
> I was able to reproduce "bad b-tree node" on data-corrupting HDD.
> I think it is happening when previously corrupted b-tree is read.
> 
> It looks like when only data is corrupted there is no "bad b-tree node"
> problem.
> 

Yes, I think that you are correct. The real reason of visible symptoms
of the issue ("bad b-tree node" messages) is the issue with Samsung HDD.
This issue with HDD generates all corruptions on the volume. So, it
needs to implement data integrity support in NILFS2 driver and
fsck.nilfs2 utility.

With the best regards,
Vyacheslav Dubeyko.

>  
> > Yes, I think that you are really right about necessity to check data
> > integrity during segctor and nilfs_cleanerd activity.
> 
> Thank you. :)
> 
> 
> > The issue with "bad b-tree node" is reported by many guys. But it is not
> > not easy to reproduce the issue for 4 KB block size on my side.
> > Currently, I can reproduce the issue on NILFS2 volume with 1 KB block
> > size. And I am deeply inside investigation of the issue in such
> > environment. But it is possible that such use-case can be a 1 KB block
> > size related. Currently, I doubt that we have one reason for "bad b-tree
> > node" issue.
> 
> I'm sure there might be other reasons for this. However I only experienced
> "bad b-tree node" in connection with data corruption caused by
> malfunctioning HDD with buggy firmware.
> 
> Regards,
>  Dmitry.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
