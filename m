From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Fri, 31 May 2013 10:39:45 +0400
Message-ID: <1369982385.2310.8.camel@slavad-ubuntu>
References: <519D2B96.9000106@antoneliasson.se>
	  <1369291449.2673.15.camel@slavad-ubuntu>
	  <51A0A7A0.6010207@antoneliasson.se> <51A0E62D.5060600@antoneliasson.se>
	 <1369809573.2253.31.camel@slavad-ubuntu> <51A70971.40602@antoneliasson.se>
	 <51A770A8.9070105@antoneliasson.se> <51A7BB84.3010505@antoneliasson.se>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=7+0fBgIl0rrQmTB1p9OLU8ErTH6sLdGhRBS4nJAcexg=;
	b=Ivoosdql95tGNC+3F1WDOZ4YgbIVRjPdJFFM3hueys+AvVnwuwk8sdGiuLSOgkTX7hERypDpwLvDgm27xnFATRQjjroLT1iKR13nu/tHUdhtek3TjR7QbTU1gI5JME+D;
In-Reply-To: <51A7BB84.3010505-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Anton,

On Thu, 2013-05-30 at 22:50 +0200, Anton Eliasson wrote:

[snip]
> 
> I'd really like to have my SSD back now. Can I dd /home ("old" home on 
> volume group "riven" that we've been debugging these last few days) to 
> an image file and then reformat? I could keep riven-proto/newhome around 
> if you want to debug that as well. As far as I know, riven-proto/newhome 
> died very cleanly, with no rw mounts after the corruption was first 
> discovered.
> 

Yes, of course, you can reformat your drive and have working file
system. Please, simply make image of corrupted partition with
reproducible issue. It will be a great to have such image for further
opportunity to investigate the issue on your side in the case of
necessity. Anyway, first of all, I'll try to investigate and fix issue
on my side.

Thank you for all information and details that you provided to us.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
