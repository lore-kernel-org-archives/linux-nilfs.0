From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: read error on superblock
Date: Mon, 23 Jul 2012 20:19:18 +0900 (JST)
Message-ID: <20120723.201918.94868195.konishi.ryusuke@lab.ntt.co.jp>
References: <1343035048.1974.6.camel@slavad-ubuntu-11>
	<20120723.183907.154986664.konishi.ryusuke@lab.ntt.co.jp>
	<2948186.vfdzh15lNi@coil>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2948186.vfdzh15lNi@coil>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 23 Jul 2012 13:06:57 +0200, dexen deVries wrote:
> Hi again,
> 
> On Monday 23 of July 2012 18:39:07 you wrote:
> > Looks weird.  mount.nilfs2 doesn't output this error message.
> 
> 
> another computer, same drive:
> 
> coil!root!/mnt # mount.nilfs2 -v /dev/sdc3 x -o errors=continue,norecovery
> mount.nilfs2: Error while mounting /dev/sdc3 on x: Input/output error
> 
> 
> also, in dmesg:
> > NILFS warning: mounting unchecked fs
> > ((lotsa ATA read error stuff))
> > NILFS: error searching super root.

Uum, the device seems to have serious problem.
Can you copy the contents of the device by dd command?

 # dd if=/dev/sdc3 of=<path-to-other>/nilfs.img

Regards,
Ryusuke Konishi

> -- 
> dexen deVries
> 
> [[[↓][→]]]
> 
> "all dichotomies are either true or false" is a true paradox because it's 
> paradoxical only if it is a paradox ;)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
