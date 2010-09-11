From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: resizing file system
Date: Sun, 12 Sep 2010 03:34:32 +0900 (JST)
Message-ID: <20100912.033432.247181057.ryusuke@osrg.net>
References: <BAEFA5609CC3AB4BAE1625CAD4C27E5C02986E1D@tdpost.td.tandbergdata.com>
	<20090408.023005.48479195.ryusuke@osrg.net>
	<87iq2cr4sq.fsf_-_@fftw.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87iq2cr4sq.fsf_-_-/JWCw35jmeM@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: athena-/JWCw35jmeM@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sat, 11 Sep 2010 05:46:29 -0400, Matteo Frigo wrote:
> Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> writes:
> 
> > An experimental resize feature did exist, but it's not applicable to
> > the current version.  And, it didn't support shrinking.
> > So the feature you want is not available now.  (Sorry for inconvenience)
> 
> Ryusuke,
> 
> Thanks for developing nilfs2, it is a superb piece of work.
> 
> I am interested in the resize feature and willing to implement it, but I
> need a little help.  My understanding of the nilfs2 source code in
> 2.6.35.4 is that in order to grow a file system it should be sufficient
> to change s_nsegments in both superblocks while the file system is
> unmounted.

Yes, right.

To be precise, you also have to move the secondary superblock, and
s_dev_size should be changed, too.  Anyway, all that's required for
the off-line expansion are these modifications.

> If I understand correctly, the sufile grows automatically to
> accomodate the additional segments because nilfs_sufile_alloc() calls
> nilfs_sufile_get_segment_usage_block() with create=1, which grows the
> sufile as necessary.

Exactly.

> Is this interpretation correct?  If so, it should not be too hard to
> code a little utility that grows an unmounted file system.  (Later we'll
> worry about shrinking and online resize.)
>
> You allude to an experimental resize feature.  Do you have code that I
> can adapt to the current version?

No, the experimental one got completely obsolete.  At least, we have
no applicable patch after the secondary super block was added.

If someone make a new one, I will apply that.

Recently, Jiro SEKIBA added library functions to modify super blocks.
I think, you can implement "nilfs-resize" by enhancing his work, by
amending "nilfs_sb_write" function.

The change is available on the latest util's git repo.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
