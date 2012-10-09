From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Tue, 09 Oct 2012 11:29:53 +0400
Message-ID: <1349767793.3427.7.camel@slavad-ubuntu>
References: <20121008222557.GU28032@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=6BaAN81FA+HxC7RchluE3ABKeEruR8np5AtKWSQt4P8=;
	b=AoS6mg3J2dT6RYMWuWWdRnu38884XOLEU6tw2zDE+qhMs6TwLSmY1UlA+ExPn4xpKdJU+NeruqcOs3szXJuty1O3oqfHC2CKpEMZs5MzZ/LsEhFPausTeHRVCA5GEu8f;
In-Reply-To: <20121008222557.GU28032@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Tue, 2012-10-09 at 00:25 +0200, Piotr Szymaniak wrote:
> Hi list.
> 
> I'm using nilfs2 on my Raspberry Pi rootfs. I've played around with
> Raspberry Pi Turbo Mode and today it refused to boot. It's a headless
> setup so I moved the SD Card to my other machine and tried to mount
> rootfs partition:
> 

As I can understand Raspberry Pi Turbo Mode is a hardware overclocking.
So, I worry about proper working of SD-card controller. It is possible
that the reason of the issue can be not proper controller functioning or
concrete SD-card issue.

Could you try to reproduce the issue with using another SD-card in Turbo
and normal mode?

I think that first of all it needs to detect that it is NILFS2 issue but
not hardware or MMC stack issue.

With the best regards,
Vyacheslav Dubeyko.


> maszyn ~ # mount.nilfs2 /dev/sdf3 /tmp/rpi
> mount.nilfs2: Error while mounting /dev/sdf3 on /tmp/rpi: Invalid
> argument
> 
> dmesg shows:
> (...)
> [43893.754525] segctord starting. Construction interval = 300 seconds,
> CP frequency < 30 seconds
> [43893.760245] NILFS: corrupt root inode.
> 
> Where should I go from here? I can hook it up via HDMI to some screen to
> see if there's some error msg on rPi.
> 
> I'm using official Raspberry Pi linux 3.2.27 from github [1] (last
> updated 2-4 days ago).
> 
> [1] https://github.com/raspberrypi/linux
> 
> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
