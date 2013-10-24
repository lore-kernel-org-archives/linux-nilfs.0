From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Bug? Kernel doesn't prevent multiple rw nilfs mounts
Date: Thu, 24 Oct 2013 22:07:32 +0400
Message-ID: <76524A8B-8063-4335-9B26-615417123CDE@dubeyko.com>
References: <52695704.3010507@intellitree.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=cg3AQsmnjJSwMh2pez7uVaXFtvWxZwDE6KGK6pi/Wd8=;
	b=XPj8fmhi8hK0zWZpy4E4+nhUK0QAf34LtokasxM5aClRHl7VOPAfxCWkk2K72u/GKJkYqsV3svkfbaq15dc4P1R+EHEBAuejD7Odz4Dbt0RDS+BlOnFBKVL9m2rtDA76;
In-Reply-To: <52695704.3010507-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Michael,

On Oct 24, 2013, at 9:21 PM, Michael Conrad wrote:

> Hi,  When I mount a NILFS partition twice (not on purpose), it correctly prints:
> 
>  mount.nilfs2: the device already has a rw-mount on /mnt/_bak.
>                multiple rw-mount is not allowed.
> 
> But the mount happens anyway?!
> 
>  /dev/sdb4 on /mnt/_bak type nilfs2 (rw,relatime)
>  /dev/sdb4 on /mnt/sdb4 type nilfs2 (rw,relatime)
> 
> I saw this in Linux 3.2.16, then upgraded to 3.10.7 and it still happens.  Writing to these mounts in parallel causes buggy behavior, though it didn't corrupt my partition (yet).
> 
> Has no-one tested this lately?
> 

I can't reproduce such behavior. Could you describe your environment and
reproducing path in more details?

Thanks,
Vyacheslav Dubeyko.

> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
