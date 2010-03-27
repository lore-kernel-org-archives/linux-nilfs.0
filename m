From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Sun, 28 Mar 2010 02:48:53 +0900 (JST)
Message-ID: <20100328.024853.37589748.ryusuke@osrg.net>
References: <4B9EA58C.1080402@prnet.org>
	<20100318.031108.204325310.ryusuke@osrg.net>
	<4BA9A484.20809@prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BA9A484.20809-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi David,
On Wed, 24 Mar 2010 06:35:00 +0100, David Arendt wrote:
> Hi,
> 
> just for completeness, here is a re-post of the complete patch using
> cleanerd->c_running instead of local variable "sleeping".
> 
> Bye,
> David Arendt

Sorry for my late response.

I'm planning to apply your patch.

The patch looks reducible some more, for example, the preparation:

> +       if (cleanerd->c_config.cf_min_clean_segments > 0) {
> +               syslog(LOG_INFO, "cleaner paused");
> +               cleanerd->c_running = 0;
> +               timeout.tv_sec = cleanerd->c_config.cf_clean_check_interval;
> +               timeout.tv_nsec = 0;
> +       }
> +       else
> +         cleanerd->c_running = 1;
> +

can be simplified as follows:

	if (cleanerd->c_config.cf_min_clean_segments == 0)
		cleanerd->c_running = 1;

And, the status control using cleanerd->c_running seems to have room
for improvement.  Except for these trivial matters, your change looks
simple but effective, and is flawlessly keeping compatibility.

If you have a revised patch, please send me for merge.  Also, I would
appreciate it if you could write some changelog description.

Thank you in advance,
Ryusuke Konishi

> On 03/17/10 19:11, Ryusuke Konishi wrote:
> > Hi,
> > On Mon, 15 Mar 2010 22:24:28 +0100, David Arendt wrote:
> >   
> >> Hi,
> >>
> >> Well I didn't know that a few days can pass as fast :-)
> >>
> >> I have attached the patch to this mail.
> >>
> >> Until now the patch has only been shortly tested on a loop device, so it
> >> might contain bugs and destroy your data.
> >>     
> > Thank you for posting the patch!
> >
> > The patch looks rougly ok to me.
> > I'll comment on it later.
> >
> > At first glance, I felt it would be nice if cleanerd->c_running is
> > nicely used instead of adding a local variable "sleeping".
> >
> > Thanks,
> > Ryusuke Konishi
> >  
> >   
> >> If you decide to apply it, please change the default values to the ones
> >> you find the most appropriate.
> >>
> >> Thanks in advance,
> >> Bye,
> >> David Arendt
> >>
> >> On 03/15/10 16:58, Ryusuke Konishi wrote:
> >>     
> >>> Hi,
> >>> On Mon, 15 Mar 2010 00:03:45 +0100, David Arendt wrote:
> >>>   
> >>>       
> >>>> Hi,
> >>>>
> >>>> I am posting this again to the correct mailing list as I cc'ed it to the
> >>>> old inactive one.
> >>>>
> >>>> Maybe I am understanding something wrong, but if I would use the count
> >>>> of reclaimed segments, how could I determine if one cleaning pass has
> >>>> finished as I don't know in advance how many segments could be reclaimed ?
> >>>>     
> >>>>         
> >>> For example, how about this?
> >>>
> >>>  nmax = (number of segments) - (number of clean segments)
> >>>  nblk = (max_clean_segments - (number of clean segments)) *
> >>>             (number of blocks per segment)
> >>>
> >>>  * If (number of clean segments) < min_clean_segments, then start reclamation
> >>>  * Try to reclaim nmax segments (at a maximum).
> >>>  * When the cleaner found and freed nblk blocks during the
> >>>    reclamation, then end one cleaning pass.
> >>>
> >>>   
> >>>       
> >>>> Another approach would be not basing cleaning on a whole cleaning pass
> >>>> but instead creating these addtional configfile options:
> >>>>
> >>>> # start cleaning if less than 100 free segments
> >>>> min_clean_segments 100
> >>>>
> >>>> # stop cleaning if more than 200 free segments
> >>>> max_clean_segments 200
> >>>>
> >>>> # check free space once an hour
> >>>> segment_check_interval 3600
> >>>>
> >>>> Basically in this example if less than 800mb are free cleaner is run
> >>>> until 1600mb are free. If min_clean_segments is 0, the cleaner would do
> >>>> normal operation.
> >>>>     
> >>>>         
> >>> The first two parameters look Ok.
> >>> (I've already referred to these in the above example.)
> >>>
> >>> We may well be able to make segment_check_interval more frequent.
> >>> or do you have something in mind? 
> >>>
> >>> Do you mean interval of cleaning passes ?
> >>>
> >>>   
> >>>       
> >>>> For this solution only changes in configfile loading and
> >>>> nilfs_cleanerd_clean_loop would be necessary which would lower the risk
> >>>> of introducing new bugs.
> >>>>
> >>>> If this solution is ok for you, I will implement it this way and send
> >>>> you the patch in a few days. Also tell me if the names I have choosen
> >>>> for the options are ok for you or if you would prefer other ones.
> >>>>     
> >>>>         
> >>> The option names look fine to me.
> >>> Or should we use percentage for them?
> >>> (number of segments is device dependent)
> >>>
> >>> Is there anything else that isn't clear?
> >>>
> >>>   
> >>>       
> >>>> Thanks in advance
> >>>> Bye,
> >>>> David Arendt
> >>>>     
> >>>>         
> >>> Thanks,
> >>> Ryusuke Konishi 
> >>>
> >>>   
> >>>       
> >>>> On 03/14/10 15:28, Ryusuke Konishi wrote:
> >>>>     
> >>>>         
> >>>>> Hi,
> >>>>> On Sun, 14 Mar 2010 14:00:19 +0100, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
> >>>>>   
> >>>>>       
> >>>>>           
> >>>>>> Hi,
> >>>>>>
> >>>>>> I will try to implement this myself then. Concerning the
> >>>>>> nilfs_cleanerd_select segments function I was unclear in my post. In
> >>>>>> fact I did not mean the return value but the first element from the
> >>>>>> segnums array.
> >>>>>>     
> >>>>>>         
> >>>>>>             
> >>>>> Ok. So you thought of determining termination of one cleaning pass by
> >>>>> the segment number stored preliminarily.
> >>>>>
> >>>>> Why not just use count of processed (i.e. reclaimed) segments?
> >>>>>
> >>>>> Note that it's not guranteed that segments are selected in the order
> >>>>> of segment number though this premise looks almost right.
> >>>>>
> >>>>> It depends on the behavior of segment allocator and the current
> >>>>> "Select-oldest" algorithm used behind
> >>>>> nilfs_cleanerd_select_segments().  Nilfs log writer occasionally
> >>>>> behaves differently and disturbs this order.
> >>>>>
> >>>>> I think you can ignore the exceptional behavior of the segment
> >>>>> allocator, and rotate target segments with skipping free or mostly
> >>>>> in-use ones.  In that case, nilfs_cleanerd_select_segments() should be
> >>>>> modified to select segments in the order of segment number.
> >>>>>
> >>>>> Cheers,
> >>>>> Ryusuke Konishi
> >>>>>
> >>>>>   
> >>>>>       
> >>>>>           
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> >>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>     
> >>>>         
> >>     
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
