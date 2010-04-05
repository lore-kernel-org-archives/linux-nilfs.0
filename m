From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Mon, 05 Apr 2010 20:34:50 +0900 (JST)
Message-ID: <20100405.203450.56374807.ryusuke@osrg.net>
References: <20100329.163902.263795283.ryusuke@osrg.net>
	<20100405.120226.98047309.ryusuke@osrg.net>
	<4BB99633.1030701@prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BB99633.1030701-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 05 Apr 2010 09:50:11 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
> Hi,
> 
> Actually I run with min_clean_segments at 250 and found that to be a
> good value. However for example for a 2 gbyte usb key, this value would
> not work at all, therefor I find it a good idea to set the default at
> 10% as it would be more general for any device size as lots of people
> simply try the defaults without changing configuration files.

Ok, let's start with the 10% min_clean_segments for the default
values.

> I really like your idea with having a second set of
> nsegments_per_clean and cleaning_interval_parameters for <
> min_clean_segments. I am wondering if adaptive optimization will be
> good, as I think different people will expect different behavior.
> Someones might prefer the system using 100% io usage for cleaning
> and the disk not getting full. Other ones might prefer the disk
> getting full and using less io usage.

Well, that's true.  Netbook users would prefer suspending the cleaner
wherever possible to avoid their SSD worn out. Meanwhile, NAS users
would expect it to operate safely to avoid trouble.

For the present, let's try to handle the disk full issue by adding a
few parameters effectively.

> Therefor I think it would add a lot of parameters to the
> configuration file for giving people the ability to tune it
> correctly, and this would possibly complicate the configuration to
> much.

> If you decide for the second set of nsegments_per_clean and
> cleaning_interval_parameters, please tell me if I should implement it or
> if you will implement it, not that we are working on the same
> functionality at the same time.

I'll do the change of default values.  And will give over to you for
this extension ;)

> I think good names might be
> 
> mc_nsegments_per_clean and
> mc_cleaning_interval
> 
> as this would be compatible with the current indentation in
> nilfs_cleanerd.conf.

All right.
 
> What would you take as default values ? As you always told that it would
> be preferable to reduce cleaning_interval instead of increasing
> nsegments_per_clean

Yes, adjusting mc_cleaning_interval should come before increasing
mc_nsegments_per_clean.  My image is, for example, as follows:

  mc_cleaning_interval  1 or 2
  mc_nsegments_per_clean  2 ~ 4 (as needed)

> would you set cleaning interval to 0 in this case
> causing permanent cleaning and leave nsegements_per_clean at or which
> values would you choose ?

The permanent cleaning may spoil responsiveness of the system.  I
don't know.  Seems that we need some test.

Thanks,
Ryusuke Konishi

> On 04/05/10 05:02, Ryusuke Konishi wrote:
> > Hi!
> > On Mon, 29 Mar 2010 16:39:02 +0900 (JST), Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
> >   
> >> On Mon, 29 Mar 2010 06:35:27 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
> >>     
> >>> Hi,
> >>>
> >>> here the changes
> >>>
> >>> Thank in advance,
> >>> David Arendt
> >>>       
> >> Looks fine to me.  Will apply later.
> >>
> >> Thanks for your quick work.
> >>
> >> Ryusuke Konishi
> >>     
> > I enhanced your change so that min_clean_segments and
> > max_clean_segments can be specified with a ratio (%) or an absolute
> > value (MB, GB, and so on) of capacity.
> >
> > The change is available on the head of util's git repo.
> >
> > Now, my question is how we should set the default value of these
> > parameters.  During test, I got disk full several times, and I feel
> > min_free_segments = 100 is a bit tight.
> >
> > Of course this depends on the usage of each, but I think that the
> > default values are desirable to have some generality (when possible).
> >
> > The following setting is my current idea for this.  How does it look?
> >
> >  min_clean_segments      10%
> >  max_clean_segments      20%
> >  clean_check_interval    10
> >
> > I also feel GC speed should be accelerated than now while the
> > filesystem is close to disk full.  One simple method is adding
> > optional nsegments_per_clean and cleaning_interval parameters for <
> > min_clean_segments.  Or, some sort of adaptive acceleration should be
> > applied.
> >
> > I'm planning to make the next util release after this settles down.
> >
> > Any idea?
> >
> > Thanks,
> > Ryusuke Konishi
> >   
> >   
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
