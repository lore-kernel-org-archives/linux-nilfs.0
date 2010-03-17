From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Thu, 18 Mar 2010 02:26:55 +0900 (JST)
Message-ID: <20100318.022655.156806263.ryusuke@osrg.net>
References: <4B9D6B51.5010202@prnet.org>
	<20100316.005815.140047502.ryusuke@osrg.net>
	<4B9E69D2.4030803@prnet.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B9E69D2.4030803-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 15 Mar 2010 18:09:38 +0100, David Arendt wrote:
> Hi,
> 
> In fact by segment check interval I mean the time to sleep before
> checking again for free space. I used 3600 in the example as this is
> would be suitable for my workload, but 60 might be a safer default value.
> 
> Specifying a percentage would also be an idea. I thought about segments
> as nsegments_per_clean is also referring to segments. I think I will
> start implementing this now using segments, as changing it to percent
> wouldn't be big changes. Another idea that comes me to mind would be
> that specifying for example 10 in any configfile option accepting
> segments would be 10 segments and 10% ten percent of total segments.

Sounds nice.

As for nsegments_per_clean, seems like the percentage notation should
not be applied because it has a bad effect on memory usage of the
nilfs GC cache in kernel. (So, the parameter is limited by a ceiling.)

But, I agree that the notation is suited for such threshold
parameters.

Regards,
Ryusuke Konishi

> For the rest, I think everything should be clear and I should have a
> patch ready in a few days.
> 
> Bye,
> David Arendt
> 
> On 03/15/10 16:58, Ryusuke Konishi wrote:
> > Hi,
> > On Mon, 15 Mar 2010 00:03:45 +0100, David Arendt wrote:
> >   
> >> Hi,
> >>
> >> I am posting this again to the correct mailing list as I cc'ed it to the
> >> old inactive one.
> >>
> >> Maybe I am understanding something wrong, but if I would use the count
> >> of reclaimed segments, how could I determine if one cleaning pass has
> >> finished as I don't know in advance how many segments could be reclaimed ?
> >>     
> > For example, how about this?
> >
> >  nmax = (number of segments) - (number of clean segments)
> >  nblk = (max_clean_segments - (number of clean segments)) *
> >             (number of blocks per segment)
> >
> >  * If (number of clean segments) < min_clean_segments, then start reclamation
> >  * Try to reclaim nmax segments (at a maximum).
> >  * When the cleaner found and freed nblk blocks during the
> >    reclamation, then end one cleaning pass.
> >
> >   
> >> Another approach would be not basing cleaning on a whole cleaning pass
> >> but instead creating these addtional configfile options:
> >>
> >> # start cleaning if less than 100 free segments
> >> min_clean_segments 100
> >>
> >> # stop cleaning if more than 200 free segments
> >> max_clean_segments 200
> >>
> >> # check free space once an hour
> >> segment_check_interval 3600
> >>
> >> Basically in this example if less than 800mb are free cleaner is run
> >> until 1600mb are free. If min_clean_segments is 0, the cleaner would do
> >> normal operation.
> >>     
> > The first two parameters look Ok.
> > (I've already referred to these in the above example.)
> >
> > We may well be able to make segment_check_interval more frequent.
> > or do you have something in mind? 
> >
> > Do you mean interval of cleaning passes ?
> >
> >   
> >> For this solution only changes in configfile loading and
> >> nilfs_cleanerd_clean_loop would be necessary which would lower the risk
> >> of introducing new bugs.
> >>
> >> If this solution is ok for you, I will implement it this way and send
> >> you the patch in a few days. Also tell me if the names I have choosen
> >> for the options are ok for you or if you would prefer other ones.
> >>     
> > The option names look fine to me.
> > Or should we use percentage for them?
> > (number of segments is device dependent)
> >
> > Is there anything else that isn't clear?
> >
> >   
> >> Thanks in advance
> >> Bye,
> >> David Arendt
> >>     
> > Thanks,
> > Ryusuke Konishi 
> >
> >   
> >> On 03/14/10 15:28, Ryusuke Konishi wrote:
> >>     
> >>> Hi,
> >>> On Sun, 14 Mar 2010 14:00:19 +0100, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
> >>>   
> >>>       
> >>>> Hi,
> >>>>
> >>>> I will try to implement this myself then. Concerning the
> >>>> nilfs_cleanerd_select segments function I was unclear in my post. In
> >>>> fact I did not mean the return value but the first element from the
> >>>> segnums array.
> >>>>     
> >>>>         
> >>> Ok. So you thought of determining termination of one cleaning pass by
> >>> the segment number stored preliminarily.
> >>>
> >>> Why not just use count of processed (i.e. reclaimed) segments?
> >>>
> >>> Note that it's not guranteed that segments are selected in the order
> >>> of segment number though this premise looks almost right.
> >>>
> >>> It depends on the behavior of segment allocator and the current
> >>> "Select-oldest" algorithm used behind
> >>> nilfs_cleanerd_select_segments().  Nilfs log writer occasionally
> >>> behaves differently and disturbs this order.
> >>>
> >>> I think you can ignore the exceptional behavior of the segment
> >>> allocator, and rotate target segments with skipping free or mostly
> >>> in-use ones.  In that case, nilfs_cleanerd_select_segments() should be
> >>> modified to select segments in the order of segment number.
> >>>
> >>> Cheers,
> >>> Ryusuke Konishi
> >>>
> >>>   
> >>>       
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>     
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
