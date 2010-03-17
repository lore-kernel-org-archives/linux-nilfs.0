From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Wed, 17 Mar 2010 20:12:57 +0100
Message-ID: <4BA129B9.9070609@prnet.org>
References: <4B9D6B51.5010202@prnet.org>	<20100316.005815.140047502.ryusuke@osrg.net>	<08886d8962faeee94a5ab900a2a78ad2.squirrel@www.prnet.org> <20100318.033237.203922438.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100318.033237.203922438.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Well I think this parameters never need to be changed as emergency.

However I can imagine that for some situations, it would be useful to
have different parameters for different drives when file systems are
mounted from /etc/fstab.

There was a proposal of another person to modify the configuration file
to handle multiple devices which might be a better solution.

Another solution migh be to leave the configuration file as it is and
add a mount option to specify which configuration file to use.

Bye,
David Arendt

On 03/17/10 19:32, Ryusuke Konishi wrote:
> On Tue, 16 Mar 2010 12:17:53 +0100, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
>   
>> Hi,
>>
>> if it is ok for you, I will create a second patch to add the following
>> mount options: minfree, maxfree (or do you prefer other names ?). So
>> different values can be specified for different mount points.
>>
>> What do you think ?
>>     
> Hmm, I'd like to keep such pseudo mount option to a minimum necessary.
>
> Previous -pp option was adopted since it was helpful for emergency
> use, for dead-end situations like a disk full.  Do you think the same
> is true of these parameters ?
>
> Thanks,
> Ryusuke Konishi
>
>   
>> Thanks,
>> Arendt David
>>
>>     
>>> Hi,
>>> On Mon, 15 Mar 2010 00:03:45 +0100, David Arendt wrote:
>>>       
>>>> Hi,
>>>>
>>>> I am posting this again to the correct mailing list as I cc'ed it to the
>>>> old inactive one.
>>>>
>>>> Maybe I am understanding something wrong, but if I would use the count
>>>> of reclaimed segments, how could I determine if one cleaning pass has
>>>> finished as I don't know in advance how many segments could be reclaimed
>>>> ?
>>>>         
>>> For example, how about this?
>>>
>>>  nmax = (number of segments) - (number of clean segments)
>>>  nblk = (max_clean_segments - (number of clean segments)) *
>>>             (number of blocks per segment)
>>>
>>>  * If (number of clean segments) < min_clean_segments, then start
>>> reclamation
>>>  * Try to reclaim nmax segments (at a maximum).
>>>  * When the cleaner found and freed nblk blocks during the
>>>    reclamation, then end one cleaning pass.
>>>
>>>       
>>>> Another approach would be not basing cleaning on a whole cleaning pass
>>>> but instead creating these addtional configfile options:
>>>>
>>>> # start cleaning if less than 100 free segments
>>>> min_clean_segments 100
>>>>
>>>> # stop cleaning if more than 200 free segments
>>>> max_clean_segments 200
>>>>
>>>> # check free space once an hour
>>>> segment_check_interval 3600
>>>>
>>>> Basically in this example if less than 800mb are free cleaner is run
>>>> until 1600mb are free. If min_clean_segments is 0, the cleaner would do
>>>> normal operation.
>>>>         
>>> The first two parameters look Ok.
>>> (I've already referred to these in the above example.)
>>>
>>> We may well be able to make segment_check_interval more frequent.
>>> or do you have something in mind?
>>>
>>> Do you mean interval of cleaning passes ?
>>>
>>>       
>>>> For this solution only changes in configfile loading and
>>>> nilfs_cleanerd_clean_loop would be necessary which would lower the risk
>>>> of introducing new bugs.
>>>>
>>>> If this solution is ok for you, I will implement it this way and send
>>>> you the patch in a few days. Also tell me if the names I have choosen
>>>> for the options are ok for you or if you would prefer other ones.
>>>>         
>>> The option names look fine to me.
>>> Or should we use percentage for them?
>>> (number of segments is device dependent)
>>>
>>> Is there anything else that isn't clear?
>>>
>>>       
>>>> Thanks in advance
>>>> Bye,
>>>> David Arendt
>>>>         
>>> Thanks,
>>> Ryusuke Konishi
>>>
>>>       
>>>> On 03/14/10 15:28, Ryusuke Konishi wrote:
>>>>         
>>>>> Hi,
>>>>> On Sun, 14 Mar 2010 14:00:19 +0100, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
>>>>>
>>>>>           
>>>>>> Hi,
>>>>>>
>>>>>> I will try to implement this myself then. Concerning the
>>>>>> nilfs_cleanerd_select segments function I was unclear in my post. In
>>>>>> fact I did not mean the return value but the first element from the
>>>>>> segnums array.
>>>>>>
>>>>>>             
>>>>> Ok. So you thought of determining termination of one cleaning pass by
>>>>> the segment number stored preliminarily.
>>>>>
>>>>> Why not just use count of processed (i.e. reclaimed) segments?
>>>>>
>>>>> Note that it's not guranteed that segments are selected in the order
>>>>> of segment number though this premise looks almost right.
>>>>>
>>>>> It depends on the behavior of segment allocator and the current
>>>>> "Select-oldest" algorithm used behind
>>>>> nilfs_cleanerd_select_segments().  Nilfs log writer occasionally
>>>>> behaves differently and disturbs this order.
>>>>>
>>>>> I think you can ignore the exceptional behavior of the segment
>>>>> allocator, and rotate target segments with skipping free or mostly
>>>>> in-use ones.  In that case, nilfs_cleanerd_select_segments() should be
>>>>> modified to select segments in the order of segment number.
>>>>>
>>>>> Cheers,
>>>>> Ryusuke Konishi
>>>>>
>>>>>
>>>>>           
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs"
>>>> in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>         
>>>       
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>     

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
