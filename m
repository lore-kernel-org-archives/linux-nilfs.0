From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Wed, 17 Mar 2010 20:04:35 +0100
Message-ID: <4BA127C3.9060008@prnet.org>
References: <4B9D6B51.5010202@prnet.org>	<20100316.005815.140047502.ryusuke@osrg.net>	<4B9EA58C.1080402@prnet.org> <20100318.031108.204325310.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100318.031108.204325310.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I have changed cleanerd.c to use cleanerd->c_running instead of sleeping.

Here the changed function for review. I will post a new complete patch
after receiving your comments.

static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
{
    struct nilfs_sustat sustat;
    __u64 prev_nongc_ctime = 0, prottime = 0, oldest = 0;
    __u64 segnums[NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX];
    struct timespec timeout;
    sigset_t sigset;
    int ns, ret;

    sigemptyset(&sigset);
    if (sigprocmask(SIG_SETMASK, &sigset, NULL) < 0) {
        syslog(LOG_ERR, "cannot set signal mask: %m");
        return -1;
    }
    sigaddset(&sigset, SIGHUP);

    if (set_sigterm_handler() < 0) {
        syslog(LOG_ERR, "cannot set SIGTERM signal handler: %m");
        return -1;
    }
    if (set_sighup_handler() < 0) {
        syslog(LOG_ERR, "cannot set SIGHUP signal handler: %m");
        return -1;
    }

    nilfs_cleanerd_reload_config = 0;

    ret = nilfs_cleanerd_init_interval(cleanerd);
    if (ret < 0)
        return -1;

    cleanerd->c_ncleansegs = cleanerd->c_config.cf_nsegments_per_clean;

    if (cleanerd->c_config.cf_min_clean_segments > 0) {
        syslog(LOG_INFO, "cleaner paused");
        cleanerd->c_running = 0;
        timeout.tv_sec = cleanerd->c_config.cf_clean_check_interval;
        timeout.tv_nsec = 0;
    }
    else
      cleanerd->c_running = 1;

    while (1) {
        if (sigprocmask(SIG_BLOCK, &sigset, NULL) < 0) {
            syslog(LOG_ERR, "cannot set signal mask: %m");
            return -1;
        }

        if (nilfs_cleanerd_reload_config) {
            if (nilfs_cleanerd_reconfig(cleanerd)) {
                syslog(LOG_ERR, "cannot configure: %m");
                return -1;
            }
            nilfs_cleanerd_reload_config = 0;
            syslog(LOG_INFO, "configuration file reloaded");
        }

        if (nilfs_get_sustat(cleanerd->c_nilfs, &sustat) < 0) {
            syslog(LOG_ERR, "cannot get segment usage stat: %m");
            return -1;
        }

        if (cleanerd->c_config.cf_min_clean_segments > 0) {
            if (cleanerd->c_running) {
                if (sustat.ss_ncleansegs >
cleanerd->c_config.cf_max_clean_segments) {
                    syslog(LOG_INFO, "cleaner paused");
                    cleanerd->c_running = 0;
                    timeout.tv_sec =
cleanerd->c_config.cf_clean_check_interval;
                    timeout.tv_nsec = 0;
                    goto sleep;
                }
            }
            else {
                if (sustat.ss_ncleansegs <
cleanerd->c_config.cf_min_clean_segments) {
                    syslog(LOG_INFO, "cleaner resumed");
                    cleanerd->c_running = 1;
                }
                else
                    goto sleep;
            }
        }

        if (sustat.ss_nongc_ctime != prev_nongc_ctime) {
            cleanerd->c_running = 1;
            prev_nongc_ctime = sustat.ss_nongc_ctime;
        }

        if (!cleanerd->c_running)
            goto sleep;

        syslog(LOG_DEBUG, "ncleansegs = %llu",
               (unsigned long long)sustat.ss_ncleansegs);

        ns = nilfs_cleanerd_select_segments(
            cleanerd, &sustat, segnums, &prottime, &oldest);
        if (ns < 0) {
            syslog(LOG_ERR, "cannot select segments: %m");
            return -1;
        }
        syslog(LOG_DEBUG, "%d segment%s selected to be cleaned",
               ns, (ns <= 1) ? "" : "s");
        if (ns > 0) {
            ret = nilfs_cleanerd_clean_segments(
                cleanerd, &sustat, segnums, ns, prottime);
            if (ret < 0)
                return -1;
        }

        ret = nilfs_cleanerd_recalc_interval(
            cleanerd, ns, prottime, oldest, &timeout);
        if (ret < 0)
            return -1;
        else if (ret > 0)
            continue;
 sleep:
        if (sigprocmask(SIG_UNBLOCK, &sigset, NULL) < 0) {
            syslog(LOG_ERR, "cannot set signal mask: %m");
            return -1;
        }

        ret = nilfs_cleanerd_sleep(cleanerd, &timeout);
        if (ret < 0)
            return -1;
    }
}

Thanks in advance
Bye,
David Arendt



On 03/17/10 19:11, Ryusuke Konishi wrote:
> Hi,
> On Mon, 15 Mar 2010 22:24:28 +0100, David Arendt wrote:
>   
>> Hi,
>>
>> Well I didn't know that a few days can pass as fast :-)
>>
>> I have attached the patch to this mail.
>>
>> Until now the patch has only been shortly tested on a loop device, so it
>> might contain bugs and destroy your data.
>>     
> Thank you for posting the patch!
>
> The patch looks rougly ok to me.
> I'll comment on it later.
>
> At first glance, I felt it would be nice if cleanerd->c_running is
> nicely used instead of adding a local variable "sleeping".
>
> Thanks,
> Ryusuke Konishi
>  
>   
>> If you decide to apply it, please change the default values to the ones
>> you find the most appropriate.
>>
>> Thanks in advance,
>> Bye,
>> David Arendt
>>
>> On 03/15/10 16:58, Ryusuke Konishi wrote:
>>     
>>> Hi,
>>> On Mon, 15 Mar 2010 00:03:45 +0100, David Arendt wrote:
>>>   
>>>       
>>>> Hi,
>>>>
>>>> I am posting this again to the correct mailing list as I cc'ed it to the
>>>> old inactive one.
>>>>
>>>> Maybe I am understanding something wrong, but if I would use the count
>>>> of reclaimed segments, how could I determine if one cleaning pass has
>>>> finished as I don't know in advance how many segments could be reclaimed ?
>>>>     
>>>>         
>>> For example, how about this?
>>>
>>>  nmax = (number of segments) - (number of clean segments)
>>>  nblk = (max_clean_segments - (number of clean segments)) *
>>>             (number of blocks per segment)
>>>
>>>  * If (number of clean segments) < min_clean_segments, then start reclamation
>>>  * Try to reclaim nmax segments (at a maximum).
>>>  * When the cleaner found and freed nblk blocks during the
>>>    reclamation, then end one cleaning pass.
>>>
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
>>>       
>>>> For this solution only changes in configfile loading and
>>>> nilfs_cleanerd_clean_loop would be necessary which would lower the risk
>>>> of introducing new bugs.
>>>>
>>>> If this solution is ok for you, I will implement it this way and send
>>>> you the patch in a few days. Also tell me if the names I have choosen
>>>> for the options are ok for you or if you would prefer other ones.
>>>>     
>>>>         
>>> The option names look fine to me.
>>> Or should we use percentage for them?
>>> (number of segments is device dependent)
>>>
>>> Is there anything else that isn't clear?
>>>
>>>   
>>>       
>>>> Thanks in advance
>>>> Bye,
>>>> David Arendt
>>>>     
>>>>         
>>> Thanks,
>>> Ryusuke Konishi 
>>>
>>>   
>>>       
>>>> On 03/14/10 15:28, Ryusuke Konishi wrote:
>>>>     
>>>>         
>>>>> Hi,
>>>>> On Sun, 14 Mar 2010 14:00:19 +0100, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
>>>>>   
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
>>>>>           
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>     
>>>>         
>>     

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
