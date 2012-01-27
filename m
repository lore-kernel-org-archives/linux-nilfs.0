From: Christian Smith <csmith-r5H9PUQoNxUga4AWyxku7ULnMzgEhdHr@public.gmane.org>
Subject: Re: Odd problem starting nilfs_cleanerd due to an eMMC misbehaviour
Date: Fri, 27 Jan 2012 16:19:21 +0000
Message-ID: <20120127161921.GL750@csmith-bm.vm.bytemark.co.uk>
References: <20120126135203.GM2267@home.lan>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120126135203.GM2267-0MSThuzptbI@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Fertser <fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 26, 2012 at 05:52:03PM +0400, Paul Fertser wrote:
> Hi,
> 
> I'm using nilfs2 for the root filesystem on an ARM-based netbook
> (Toshiba ac100) with Debian hardfloat. Custom kernel is based on 3.0.8
> and nilfs-tools is 2.1.0-1 from the Debian repository.
> 
> I wanted to try the threaded i/o test from the Phoronix test suite and
> somehow it happened that during the test the garbage collecting daemon
> failed and never came back. So i got the filesystem 100% full and
> after i noticed it i tried running the daemon manually. It didn't
> start even after reboot. Suprisingly, the eMMC error went away on its
> own after fully powering off the whole device, and after that the
> daemon started to work properly.
> 
> I'm not sure what conclusion might be made from this but i'd still
> appreciate any comments, especially the suggestions on what to do if
> the error didn't "recover".

Remember, SDCards contain their own embedded controller to do the
block mapping between LBA and FLASH blocks. There may even be an ARM
based controller in the SDCard. Under the stress of a benchmark, the
firmware probably just got itself in a bit of a state and needed a
hard reset to recover.

What brand of SD Card is it? Most SD Cards are designed for low
stress low speed IO in devices such as cameras. Perhaps try a
different brand.

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
