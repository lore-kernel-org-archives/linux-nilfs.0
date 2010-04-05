From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Mon, 05 Apr 2010 12:02:26 +0900 (JST)
Message-ID: <20100405.120226.98047309.ryusuke@osrg.net>
References: <20100329.125908.56566467.ryusuke@osrg.net>
	<4BB02E0F.90001@prnet.org>
	<20100329.163902.263795283.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100329.163902.263795283.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi!
On Mon, 29 Mar 2010 16:39:02 +0900 (JST), Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> On Mon, 29 Mar 2010 06:35:27 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
> > Hi,
> > 
> > here the changes
> > 
> > Thank in advance,
> > David Arendt
> 
> Looks fine to me.  Will apply later.
> 
> Thanks for your quick work.
> 
> Ryusuke Konishi

I enhanced your change so that min_clean_segments and
max_clean_segments can be specified with a ratio (%) or an absolute
value (MB, GB, and so on) of capacity.

The change is available on the head of util's git repo.

Now, my question is how we should set the default value of these
parameters.  During test, I got disk full several times, and I feel
min_free_segments = 100 is a bit tight.

Of course this depends on the usage of each, but I think that the
default values are desirable to have some generality (when possible).

The following setting is my current idea for this.  How does it look?

 min_clean_segments      10%
 max_clean_segments      20%
 clean_check_interval    10

I also feel GC speed should be accelerated than now while the
filesystem is close to disk full.  One simple method is adding
optional nsegments_per_clean and cleaning_interval parameters for <
min_clean_segments.  Or, some sort of adaptive acceleration should be
applied.

I'm planning to make the next util release after this settles down.

Any idea?

Thanks,
Ryusuke Konishi
  
> > On 03/29/10 05:59, Ryusuke Konishi wrote:
> > > Hi,
> > > On Sun, 28 Mar 2010 23:52:52 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
> > >   
> > >> Hi,
> > >>
> > >> thanks for applying the patches. I did all my tests on 2 gbyte loop
> > >> devices and now that it is officially in git, I deployed it to some
> > >> production systems with big disks. Here I have noticed, that I have
> > >> completely forgotten the reserved segments. Technically this is not a
> > >> problem, but I think people changing configuration files will tend to
> > >> forget about it. I'm thinking it might be useful to add them internally
> > >> to min_free_segments and max_free_segments so users don't need to worry
> > >> about them. What do you think ?
> > >>     
> > > Ahh, we should take into account the number of reserved segments.  If
> > > not so, cleaner control with the two threshold values will not work
> > > properly for large drives.
> > >
> > >   
> > >> If you like to change the current behavior to this behavior, I will
> > >> submit a short update patch.
> > >>     
> > > Yes, please do.
> > >
> > >   
> > >> I am thinking about getting the number of reserved segments this way:
> > >>
> > >> (nilfs_cleanerd->c_nilfs->n_sb->s_nsegments *
> > >> nilfs_cleanerd->c_nilfs->n_sb->s_r_segments_percentage) / 100
> > >>
> > >> or do you know any better way ?
> > >>     
> > > The kernel code calulates the number by:
> > >
> > >   = max(NILFS_MIN_NRSVSEGS,
> > >         DIV_ROUND_UP(nsegments * r_segments_percentage, 100))
> > >
> > >   where NILFS_MIN_NRSVSEGS is defined in include/nilfs2_fs.h, and
> > >   DIV_ROUND_UP is defined as follows:
> > >
> > >  #define DIV_ROUND_UP(n,d)    (((n) +  (d) - 1) / (d))
> > >
> > > The same or some equivelent calculation seems preferable.
> > >  
> > > With regards,
> > > Ryusuke Konishi
> > >
> > >   
> > >> On 03/28/10 17:26, Ryusuke Konishi wrote:
> > >>     
> > >>> Hi,
> > >>> On Sun, 28 Mar 2010 14:17:00 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
> > >>>   
> > >>>       
> > >>>> Hi,
> > >>>>
> > >>>> here the nogc patch
> > >>>>
> > >>>> As changelog description for this one, we could put:
> > >>>>
> > >>>> add mount option to disable garbage collection
> > >>>>
> > >>>> Thanks in advance
> > >>>> Bye,
> > >>>> David Arendt
> > >>>>     
> > >>>>         
> > >>> Hmm, the patch looks perfect.
> > >>>
> > >>> Will queue both in the git tree of utils.
> > >>>
> > >>> Thanks,
> > >>> Ryusuke Konishi
> > >>>   
> > >>>       
> > >>     
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
