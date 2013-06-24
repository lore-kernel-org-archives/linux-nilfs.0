From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Corrupt root inode
Date: Mon, 24 Jun 2013 11:46:13 +0400
Message-ID: <1372059973.2279.31.camel@slavad-ubuntu>
References: <1372043988.4304.140661247622873.2030B278@webmail.messagingengine.com>
	 <1372048664.18072.140661247643486.0DCAEA3F@webmail.messagingengine.com>
	 <1372049607.20711.140661247647122.68C1544E@webmail.messagingengine.com>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=GAzh/f57VrnSh9dMaSTUEJtjyfIIdHTVTDGU6SwnTdc=;
	b=n0O+gSR42wqTToN4m0LzXvQU+E+FqbnNZL54bnt7CzDrQbZZm/ZlOPOFZTKU4mDgmEuDUfjkH07M8Igp8jEqEFLqt6tEYnQG2LFhXxom3NkGsLzj5VU+c9m0pPgiIUXZ;
In-Reply-To: <1372049607.20711.140661247647122.68C1544E-2RFepEojUI2N1INw9kWLP6GC3tUn3ZHUQQ4Iyu8u01E@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Bryce,

Do you have any snapshots on this NILFS2 volume?

If you have snapshots, could you try to mount any of available
snapshots?

Currently, I suspect that you had some issue during last mount.
Probably, you can have issue with "broken bnode" or, maybe, another
issue that corrupted your volume. I suppose that system log on this
NILFS2 volume contains error messages about the initial issue. But, as I
see, you haven't access to the volume content because you can't mount
this volume. So, first of all, I need to understand that you have
snapshots or not.

Thanks,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
