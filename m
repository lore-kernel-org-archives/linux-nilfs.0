From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Mon, 29 Mar 2010 12:59:08 +0900 (JST)
Message-ID: <20100329.125908.56566467.ryusuke@osrg.net>
References: <4BAF48BC.8060505@prnet.org>
	<20100329.002619.67908494.ryusuke@osrg.net>
	<4BAFCFB4.5050401@prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BAFCFB4.5050401-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 28 Mar 2010 23:52:52 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
> Hi,
> 
> thanks for applying the patches. I did all my tests on 2 gbyte loop
> devices and now that it is officially in git, I deployed it to some
> production systems with big disks. Here I have noticed, that I have
> completely forgotten the reserved segments. Technically this is not a
> problem, but I think people changing configuration files will tend to
> forget about it. I'm thinking it might be useful to add them internally
> to min_free_segments and max_free_segments so users don't need to worry
> about them. What do you think ?

Ahh, we should take into account the number of reserved segments.  If
not so, cleaner control with the two threshold values will not work
properly for large drives.

> If you like to change the current behavior to this behavior, I will
> submit a short update patch.

Yes, please do.

> I am thinking about getting the number of reserved segments this way:
> 
> (nilfs_cleanerd->c_nilfs->n_sb->s_nsegments *
> nilfs_cleanerd->c_nilfs->n_sb->s_r_segments_percentage) / 100
> 
> or do you know any better way ?

The kernel code calulates the number by:

  = max(NILFS_MIN_NRSVSEGS,
        DIV_ROUND_UP(nsegments * r_segments_percentage, 100))

  where NILFS_MIN_NRSVSEGS is defined in include/nilfs2_fs.h, and
  DIV_ROUND_UP is defined as follows:

 #define DIV_ROUND_UP(n,d)    (((n) +  (d) - 1) / (d))

The same or some equivelent calculation seems preferable.
 
With regards,
Ryusuke Konishi

> On 03/28/10 17:26, Ryusuke Konishi wrote:
> > Hi,
> > On Sun, 28 Mar 2010 14:17:00 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
> >   
> >> Hi,
> >>
> >> here the nogc patch
> >>
> >> As changelog description for this one, we could put:
> >>
> >> add mount option to disable garbage collection
> >>
> >> Thanks in advance
> >> Bye,
> >> David Arendt
> >>     
> > Hmm, the patch looks perfect.
> >
> > Will queue both in the git tree of utils.
> >
> > Thanks,
> > Ryusuke Konishi
> >   
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
