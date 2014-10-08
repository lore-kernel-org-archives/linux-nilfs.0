From: Hugo Pacheco <hpacheco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: nilfs-diff experimental branch
Date: Wed, 8 Oct 2014 16:53:05 -0400
Message-ID: <CAFK5svByXZfnaEMsdiMhrC62tgsMxiAbVFmCcp8KG90=oLc-SQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=n/O/BZ2WX/47tDUQStP2l9afbnceYtj1OUDwy9SPVU0=;
        b=wfc8is8bVrBhnFxlL0mLynSQlmqFFLZXcy6z0T5SBako8OsBhhCGOME6vMcYU+fyyo
         BhpFyxKPqzPjClWnIeM8aGSKhRdZOOLhMVFaOOd6Vgoz73KkaOC1B/c867Ok5fKkfgus
         lxDWpBy9qNftz6aCSE5EQf/q4ZARY08u/V6iJBRkyV//f3jwf/+W1nViX4xZWfPUwXSM
         3qY5SRFNZzV1OjfhwURp0ZZatwx7n1Pt7j0mRpJR4hN18BZhu6+zR2Bg/rdLEvD/NTG9
         jqxix/IcoEaAsas45y7BggTb+ievs1QwFdPh83LzxmNB+GQBfgNjmzkiK1ylKZfSOthU
         HgFg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi everyone,

I have been experimenting with the versioning capabilities of nilfs-tools
and it works beautifully, but I have now started wanting to explore the
hottest features only in the experimental branch, namely nilfs-diff.

I understand that this diff branch has never made it to mainstream, and
probably won't soon, but has anyone succeeded in installing it for a modern
3.x linux kernel? The latest code available at github seems to require
2.6.x.

A more up-to-date picture would be really appreciated.

Thanks,
hugo
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
