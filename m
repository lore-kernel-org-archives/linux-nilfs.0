From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Revert system state to snapshot
Date: Fri, 04 Oct 2013 17:06:57 +0400
Message-ID: <1380892017.2413.13.camel@slavad-ubuntu>
References: <CADV-EXEQUt9uP1xeDuMOQ-Qx-ghrvPwdMZL3a8G65e9ndiyeZw@mail.gmail.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=KfAZ+W+xjMZkvx5c/P17kEi7jCwjsv/+RS+lcz9Rz14=;
	b=Xz+Ny3izhltTJRBhQQWhk4FV/Ge5wkjl5k6e9ltLJjMsj4fqP/pqq5OOcW1EYCjM9AhM5mMMddLiFHkVEi/Nr0DNWYRG2Pdy/t8H1X8WXknAi7nzM59coqXUzHb5wSkf;
In-Reply-To: <CADV-EXEQUt9uP1xeDuMOQ-Qx-ghrvPwdMZL3a8G65e9ndiyeZw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yevhen Kyriukha <kirgene-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Yevhen,

On Fri, 2013-10-04 at 15:28 +0300, Yevhen Kyriukha wrote:
> Hi!
> 
> I'm wondering how can revert to snapshot by mounting file system as
> writable in this state.
> 
> I know that NILFS2 currently doesn't support this feature, but I think
> that implementation of such functionality is highly desirable.
> Is there any date or estimates when this feature will be implemented?
> 

If you would like to implement this feature then it will be great
contribution to the NILFS2 project. You are welcome.

Also it can be valuable your vision of this feature. Could you describe
what you expect from this feature and how you want to use it? A user's
vision is different from developer's vision very frequently.

As far as I can judge, we haven't any implementation activity in this
direction. If I am not fully informed then Ryusuke corrects me.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
