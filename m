From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Sun, 28 Jul 2013 00:32:25 +0200
Message-ID: <51F44A79.10509@antoneliasson.se>
References: <51F2A8A4.4020400@antoneliasson.se> <51F2A945.6050909@antoneliasson.se> <9016EBD5-1E01-476F-B1B9-66AE593F4728@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9016EBD5-1E01-476F-B1B9-66AE593F4728-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vyacheslav Dubeyko skrev 2013-07-27 18:23:
> Hi Anton,
>
> On Jul 26, 2013, at 8:52 PM, Anton Eliasson wrote:
>
> Thank you for your efforts. But, as I understand, currently, you
> don't reproduce the issue and shared system log doesn't contain
> any new details about the issue. Please, see my description below.
That is correct, I just wanted to know if I was on the right track (and 
it turned out that I weren't).
> [snip]
>> I have aborted the experiments for today. kernel.log has 35 million
>> lines and compresses to 220 MB. I've uploaded it here
>> (http://antoneliasson.se/publicdump/kernel.log.20130726.gz). What should
>> I do next?
>>
> Unfortunately, the shared system log content doesn't contain any NILFS2
> error messages. So, it means that the issue doesn't be reproduced. Do you
> really confident that you can reproduce the issue before beginning of getting
> debug output? Could you check firstly the issue reproducibility?
You're right, I should try that first. Unfortunately, I'll be away from 
this computer again for the next week or two. I'll try to allocate some 
time for this investigation after that. I can access it via SSH so I 
might spend an evening recompiling the kernel remotely, but I don't want 
to reboot the computer remotely.
>
> You made one mistake during configuration of debug output. Please, see
> my description below.
>
> [snip]
>> * Append the following lines to config (just in case) and config.x86_64
>> (which I assume I will use):
>>
>>     CONFIG_NILFS2_DEBUG_SHOW_ERRORS=y
>>     CONFIG_NILFS2_DEBUG_BASE_OPERATIONS=y
>>     CONFIG_NILFS2_DEBUG_MDT_FILES=y
>>     CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM=y
>>     CONFIG_NILFS2_DEBUG_BLOCK_MAPPING=y
>>     CONFIG_NILFS2_DEBUG_DUMP_STACK=y
>>
> I think that better to use "make menuconfig" for debug output configuration
> because above-mentioned options have dependencies from other ones.
> Please, use "make menuconfig" way because it is not so easy to describe
> what set of configuration options are valid.
>
> [snip]
>>     * File systems
>>     *
>>     [...]
>>     NILFS2 file system support (NILFS2_FS) [M/n/y/?] m
>>       NILFS2 debugging (NILFS2_DEBUG) [N/y/?] (NEW) y
>>         Use pr_debug() instead of printk() (NILFS2_USE_PR_DEBUG)
>> [N/y/?] (NEW) y
> No, no, no... When you select using pr_debug() then you disable
> CONFIG_NILFS2_DEBUG_BASE_OPERATIONS,
> CONFIG_NILFS2_DEBUG_MDT_FILES, CONFIG_NILFS2_DEBUG_SEGMENTS_SUBSYSTEM,
> CONFIG_NILFS2_DEBUG_BLOCK_MAPPING options because you need to use
> dynamic debug opportunity (please, see Documentation/dynamic-debug-howto.txt).
> Moreover, when you select CONFIG_NILFS2_DEBUG_DUMP_STACK in dynamic
> debug output case then every function emits dump_stack() output. Please, read
> comments for configuration options.
>
> Firstly, I want to get debug output without enabling pr_debug(). We will have debug output
> only from requested subsystems in the case of using simple printk(). So, improper
> configuration of debug output is the reason of huge size of system log. I suggest
> not to use  CONFIG_NILFS2_DEBUG_DUMP_STACK option, firstly.
>
>>         Show internal errors (NILFS2_DEBUG_SHOW_ERRORS) [N/y/?] (NEW) y
>>         Enable dump stack output (NILFS2_DEBUG_DUMP_STACK) [N/y/?] (NEW) y
>>
> So, first of all, we need to reproduce the issue in initial state. Then, it needs to configure
> debug output properly and to get debug output for the case of reproduced issue.
>
> Thanks,
> Vyacheslav Dubeyko.
>
Thanks for all your advice. I'm very new to compiling and configuring 
kernels. I will keep you updated on how my next attempt works out.

-- 
Best Regards,
Anton Eliasson

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
