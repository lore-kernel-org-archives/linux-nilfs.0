From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Sun, 28 Mar 2010 23:52:52 +0200
Message-ID: <4BAFCFB4.5050401@prnet.org>
References: <4BAE63F4.1040404@prnet.org>	<20100328.105542.258871713.ryusuke@osrg.net>	<4BAF48BC.8060505@prnet.org> <20100329.002619.67908494.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100329.002619.67908494.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

thanks for applying the patches. I did all my tests on 2 gbyte loop
devices and now that it is officially in git, I deployed it to some
production systems with big disks. Here I have noticed, that I have
completely forgotten the reserved segments. Technically this is not a
problem, but I think people changing configuration files will tend to
forget about it. I'm thinking it might be useful to add them internally
to min_free_segments and max_free_segments so users don't need to worry
about them. What do you think ? If you like to change the current
behavior to this behavior, I will submit a short update patch.

I am thinking about getting the number of reserved segments this way:

(nilfs_cleanerd->c_nilfs->n_sb->s_nsegments *
nilfs_cleanerd->c_nilfs->n_sb->s_r_segments_percentage) / 100

or do you know any better way ?

Thanks in advance,
David Arendt

On 03/28/10 17:26, Ryusuke Konishi wrote:
> Hi,
> On Sun, 28 Mar 2010 14:17:00 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
>   
>> Hi,
>>
>> here the nogc patch
>>
>> As changelog description for this one, we could put:
>>
>> add mount option to disable garbage collection
>>
>> Thanks in advance
>> Bye,
>> David Arendt
>>     
> Hmm, the patch looks perfect.
>
> Will queue both in the git tree of utils.
>
> Thanks,
> Ryusuke Konishi
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
