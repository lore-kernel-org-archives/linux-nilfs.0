From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Mon, 15 Mar 2010 00:03:45 +0100
Message-ID: <4B9D6B51.5010202@prnet.org>
References: <hSSjxhQnnRB5.kxy725KN@mail.prnet.org> <20100314.232838.05854811.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100314.232838.05854811.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I am posting this again to the correct mailing list as I cc'ed it to the
old inactive one.

Maybe I am understanding something wrong, but if I would use the count
of reclaimed segments, how could I determine if one cleaning pass has
finished as I don't know in advance how many segments could be reclaimed ?

Another approach would be not basing cleaning on a whole cleaning pass
but instead creating these addtional configfile options:

# start cleaning if less than 100 free segments
min_clean_segments 100

# stop cleaning if more than 200 free segments
max_clean_segments 200

# check free space once an hour
segment_check_interval 3600

Basically in this example if less than 800mb are free cleaner is run
until 1600mb are free. If min_clean_segments is 0, the cleaner would do
normal operation.

For this solution only changes in configfile loading and
nilfs_cleanerd_clean_loop would be necessary which would lower the risk
of introducing new bugs.

If this solution is ok for you, I will implement it this way and send
you the patch in a few days. Also tell me if the names I have choosen
for the options are ok for you or if you would prefer other ones.

Thanks in advance
Bye,
David Arendt


On 03/14/10 15:28, Ryusuke Konishi wrote:
> Hi,
> On Sun, 14 Mar 2010 14:00:19 +0100, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
>   
>> Hi,
>>
>> I will try to implement this myself then. Concerning the
>> nilfs_cleanerd_select segments function I was unclear in my post. In
>> fact I did not mean the return value but the first element from the
>> segnums array.
>>     
> Ok. So you thought of determining termination of one cleaning pass by
> the segment number stored preliminarily.
>
> Why not just use count of processed (i.e. reclaimed) segments?
>
> Note that it's not guranteed that segments are selected in the order
> of segment number though this premise looks almost right.
>
> It depends on the behavior of segment allocator and the current
> "Select-oldest" algorithm used behind
> nilfs_cleanerd_select_segments().  Nilfs log writer occasionally
> behaves differently and disturbs this order.
>
> I think you can ignore the exceptional behavior of the segment
> allocator, and rotate target segments with skipping free or mostly
> in-use ones.  In that case, nilfs_cleanerd_select_segments() should be
> modified to select segments in the order of segment number.
>
> Cheers,
> Ryusuke Konishi
>
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
