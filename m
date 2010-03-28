From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Sun, 28 Mar 2010 14:17:00 +0200
Message-ID: <4BAF48BC.8060505@prnet.org>
References: <4BA9A484.20809@prnet.org>	<20100328.024853.37589748.ryusuke@osrg.net>	<4BAE63F4.1040404@prnet.org> <20100328.105542.258871713.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020406080705010305050801"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100328.105542.258871713.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a multi-part message in MIME format.
--------------020406080705010305050801
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

here the nogc patch

As changelog description for this one, we could put:

add mount option to disable garbage collection

Thanks in advance
Bye,
David Arendt

On 03/28/10 03:55, Ryusuke Konishi wrote:
> Hi,
>
> On Sat, 27 Mar 2010 21:00:52 +0100, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
>   
>> Hi,
>>
>> here the revised version of the patch
>>
>> As changelog description we could put:
>>
>> add options for cleaning based on number of free segments
>>     
> Thanks.
>
> Ok, it looks fine to me.
>  
>   
>> In order to pass different config files to cleaner while not increasing
>> mount options, another solution might be adding a mount option
>> nocleanerd to disable staring of cleanerd. I know, there is mount -i,
>> but this option would have the advantage that it could be used in
>> /etc/fstab. In this way, cleaner could be started manually with whatever
>> options are needed. What would you think about it ?
>>     
> Agreed.
>
> Maybe name of the mount option should be "nocleaner" or "nogc" because
> "nocleanerd" implies how it is implemented.
>
>   
>> Anyway I think this should be part of a second patch as it is
>> implementing different functionality.
>>     
> Yes, it should be separate from the first one.
>
> Thanks,
> Ryusuke Konishi
>
>   
>> On 03/27/10 18:48, Ryusuke Konishi wrote:
>>     
>>> Hi David,
>>> On Wed, 24 Mar 2010 06:35:00 +0100, David Arendt wrote:
>>>   
>>>       
>>>> Hi,
>>>>
>>>> just for completeness, here is a re-post of the complete patch using
>>>> cleanerd->c_running instead of local variable "sleeping".
>>>>
>>>> Bye,
>>>> David Arendt
>>>>     
>>>>         
>>> Sorry for my late response.
>>>
>>> I'm planning to apply your patch.
>>>
>>> The patch looks reducible some more, for example, the preparation:
>>>
>>>   
>>>       
>>>> +       if (cleanerd->c_config.cf_min_clean_segments > 0) {
>>>> +               syslog(LOG_INFO, "cleaner paused");
>>>> +               cleanerd->c_running = 0;
>>>> +               timeout.tv_sec = cleanerd->c_config.cf_clean_check_interval;
>>>> +               timeout.tv_nsec = 0;
>>>> +       }
>>>> +       else
>>>> +         cleanerd->c_running = 1;
>>>> +
>>>>     
>>>>         
>>> can be simplified as follows:
>>>
>>> 	if (cleanerd->c_config.cf_min_clean_segments == 0)
>>> 		cleanerd->c_running = 1;
>>>
>>> And, the status control using cleanerd->c_running seems to have room
>>> for improvement.  Except for these trivial matters, your change looks
>>> simple but effective, and is flawlessly keeping compatibility.
>>>
>>> If you have a revised patch, please send me for merge.  Also, I would
>>> appreciate it if you could write some changelog description.
>>>
>>> Thank you in advance,
>>> Ryusuke Konishi
>>>
>>>   
>>>       
>>>> On 03/17/10 19:11, Ryusuke Konishi wrote:
>>>>     
>>>>         
>>>>> Hi,
>>>>> On Mon, 15 Mar 2010 22:24:28 +0100, David Arendt wrote:
>>>>>   
>>>>>       
>>>>>           
>>>>>> Hi,
>>>>>>
>>>>>> Well I didn't know that a few days can pass as fast :-)
>>>>>>
>>>>>> I have attached the patch to this mail.
>>>>>>
>>>>>> Until now the patch has only been shortly tested on a loop device, so it
>>>>>> might contain bugs and destroy your data.
>>>>>>     
>>>>>>         
>>>>>>             
>>>>> Thank you for posting the patch!
>>>>>
>>>>> The patch looks rougly ok to me.
>>>>> I'll comment on it later.
>>>>>
>>>>> At first glance, I felt it would be nice if cleanerd->c_running is
>>>>> nicely used instead of adding a local variable "sleeping".
>>>>>
>>>>> Thanks,
>>>>> Ryusuke Konishi
>>>>>  
>>>>>   
>>>>>       
>>>>>           
>>>>>> If you decide to apply it, please change the default values to the ones
>>>>>> you find the most appropriate.
>>>>>>
>>>>>> Thanks in advance,
>>>>>> Bye,
>>>>>> David Arendt
>>>>>>
>>>>>> On 03/15/10 16:58, Ryusuke Konishi wrote:
>>>>>>     
>>>>>>         
>>>>>>             
>>>>>>> Hi,
>>>>>>> On Mon, 15 Mar 2010 00:03:45 +0100, David Arendt wrote:
>>>>>>>   
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> I am posting this again to the correct mailing list as I cc'ed it to the
>>>>>>>> old inactive one.
>>>>>>>>
>>>>>>>> Maybe I am understanding something wrong, but if I would use the count
>>>>>>>> of reclaimed segments, how could I determine if one cleaning pass has
>>>>>>>> finished as I don't know in advance how many segments could be reclaimed ?
>>>>>>>>     
>>>>>>>>         
>>>>>>>>             
>>>>>>>>                 
>>>>>>> For example, how about this?
>>>>>>>
>>>>>>>  nmax = (number of segments) - (number of clean segments)
>>>>>>>  nblk = (max_clean_segments - (number of clean segments)) *
>>>>>>>             (number of blocks per segment)
>>>>>>>
>>>>>>>  * If (number of clean segments) < min_clean_segments, then start reclamation
>>>>>>>  * Try to reclaim nmax segments (at a maximum).
>>>>>>>  * When the cleaner found and freed nblk blocks during the
>>>>>>>    reclamation, then end one cleaning pass.
>>>>>>>
>>>>>>>   
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>>>> Another approach would be not basing cleaning on a whole cleaning pass
>>>>>>>> but instead creating these addtional configfile options:
>>>>>>>>
>>>>>>>> # start cleaning if less than 100 free segments
>>>>>>>> min_clean_segments 100
>>>>>>>>
>>>>>>>> # stop cleaning if more than 200 free segments
>>>>>>>> max_clean_segments 200
>>>>>>>>
>>>>>>>> # check free space once an hour
>>>>>>>> segment_check_interval 3600
>>>>>>>>
>>>>>>>> Basically in this example if less than 800mb are free cleaner is run
>>>>>>>> until 1600mb are free. If min_clean_segments is 0, the cleaner would do
>>>>>>>> normal operation.
>>>>>>>>     
>>>>>>>>         
>>>>>>>>             
>>>>>>>>                 
>>>>>>> The first two parameters look Ok.
>>>>>>> (I've already referred to these in the above example.)
>>>>>>>
>>>>>>> We may well be able to make segment_check_interval more frequent.
>>>>>>> or do you have something in mind? 
>>>>>>>
>>>>>>> Do you mean interval of cleaning passes ?
>>>>>>>
>>>>>>>   
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>>>> For this solution only changes in configfile loading and
>>>>>>>> nilfs_cleanerd_clean_loop would be necessary which would lower the risk
>>>>>>>> of introducing new bugs.
>>>>>>>>
>>>>>>>> If this solution is ok for you, I will implement it this way and send
>>>>>>>> you the patch in a few days. Also tell me if the names I have choosen
>>>>>>>> for the options are ok for you or if you would prefer other ones.
>>>>>>>>     
>>>>>>>>         
>>>>>>>>             
>>>>>>>>                 
>>>>>>> The option names look fine to me.
>>>>>>> Or should we use percentage for them?
>>>>>>> (number of segments is device dependent)
>>>>>>>
>>>>>>> Is there anything else that isn't clear?
>>>>>>>
>>>>>>>   
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>>>> Thanks in advance
>>>>>>>> Bye,
>>>>>>>> David Arendt
>>>>>>>>     
>>>>>>>>         
>>>>>>>>             
>>>>>>>>                 
>>>>>>> Thanks,
>>>>>>> Ryusuke Konishi 
>>>>>>>
>>>>>>>   
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>>>> On 03/14/10 15:28, Ryusuke Konishi wrote:
>>>>>>>>     
>>>>>>>>         
>>>>>>>>             
>>>>>>>>                 
>>>>>>>>> Hi,
>>>>>>>>> On Sun, 14 Mar 2010 14:00:19 +0100, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org wrote:
>>>>>>>>>   
>>>>>>>>>       
>>>>>>>>>           
>>>>>>>>>               
>>>>>>>>>                   
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> I will try to implement this myself then. Concerning the
>>>>>>>>>> nilfs_cleanerd_select segments function I was unclear in my post. In
>>>>>>>>>> fact I did not mean the return value but the first element from the
>>>>>>>>>> segnums array.
>>>>>>>>>>     
>>>>>>>>>>         
>>>>>>>>>>             
>>>>>>>>>>                 
>>>>>>>>>>                     
>>>>>>>>> Ok. So you thought of determining termination of one cleaning pass by
>>>>>>>>> the segment number stored preliminarily.
>>>>>>>>>
>>>>>>>>> Why not just use count of processed (i.e. reclaimed) segments?
>>>>>>>>>
>>>>>>>>> Note that it's not guranteed that segments are selected in the order
>>>>>>>>> of segment number though this premise looks almost right.
>>>>>>>>>
>>>>>>>>> It depends on the behavior of segment allocator and the current
>>>>>>>>> "Select-oldest" algorithm used behind
>>>>>>>>> nilfs_cleanerd_select_segments().  Nilfs log writer occasionally
>>>>>>>>> behaves differently and disturbs this order.
>>>>>>>>>
>>>>>>>>> I think you can ignore the exceptional behavior of the segment
>>>>>>>>> allocator, and rotate target segments with skipping free or mostly
>>>>>>>>> in-use ones.  In that case, nilfs_cleanerd_select_segments() should be
>>>>>>>>> modified to select segments in the order of segment number.
>>>>>>>>>
>>>>>>>>> Cheers,
>>>>>>>>> Ryusuke Konishi
>>>>>>>>>
>>>>>>>>>   
>>>>>>>>>       
>>>>>>>>>           
>>>>>>>>>               
>>>>>>>>>                   
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>>     
>>>>>>>>         
>>>>>>>>             
>>>>>>>>                 
>>>>>>     
>>>>>>         
>>>>>>             
>>>>     
>>>>         
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>   
>>>       
>>     


--------------020406080705010305050801
Content-Type: text/plain;
 name="nilfs2-utils-nogc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nilfs2-utils-nogc.patch"

diff -ur nilfs2-utils.orig/man/mount.nilfs2.8 nilfs2-utils/man/mount.nilfs2.8
--- nilfs2-utils.orig/man/mount.nilfs2.8	2010-03-14 15:11:30.916690347 +0100
+++ nilfs2-utils/man/mount.nilfs2.8	2010-03-28 12:16:49.785942470 +0200
@@ -108,6 +108,11 @@
 elapsed time from its creation is smaller than
 \fIprotection-period\fP.
 .TP
+.BR nogc
+Disable garbage collection. The cleaner daemon will not be started.
+It can be be started manually, but in that case it must also be
+stopped manually before unmounting.
+.TP
 .BR order=relaxed " / " order=strict
 Specify order semantics for file data.  Metadata is always written to
 follow the POSIX semantics about the order of filesystem operations.
diff -ur nilfs2-utils.orig/sbin/mount/mount.nilfs2.c nilfs2-utils/sbin/mount/mount.nilfs2.c
--- nilfs2-utils.orig/sbin/mount/mount.nilfs2.c	2010-03-14 15:11:30.918691251 +0100
+++ nilfs2-utils/sbin/mount/mount.nilfs2.c	2010-03-28 14:05:28.861362988 +0200
@@ -74,6 +74,9 @@
 const char pp_opt_fmt[] = PPOPT_NAME "=%lu";
 typedef unsigned long pp_opt_t;
 
+const char nogc_opt_fmt[] = NOGCOPT_NAME;
+typedef int nogc_opt_t;
+
 struct mount_options {
 	char *fstype;
 	char *opts;
@@ -329,6 +332,7 @@
 	int type;
 	int mounted;
 	pp_opt_t protperiod;
+	nogc_opt_t nogc;
 };
 
 static int check_mtab(void)
@@ -391,6 +395,8 @@
 	if (find_opt(mc->m.mnt_opts, pp_opt_fmt, &prot_period) >= 0)
 		mi->protperiod = prot_period;
 
+	mi->nogc = (find_opt(mc->m.mnt_opts, nogc_opt_fmt, NULL) >= 0);
+
 	switch (mo->flags & (MS_RDONLY | MS_REMOUNT)) {
 	case 0: /* overlapping rw-mount */
 		error(_("%s: the device already has a rw-mount on %s."
@@ -426,11 +432,13 @@
 static int
 do_mount_one(struct nilfs_mount_info *mi, const struct mount_options *mo)
 {
-	int res, errsv;
-	char *exopts;
+	int res, errsv, mtab_ok;
+	char *tmpexopts, *exopts;
 	pp_opt_t prot_period;
 
-	exopts = change_opt(mo->extra_opts, pp_opt_fmt, &prot_period, "");
+	tmpexopts = change_opt(mo->extra_opts, pp_opt_fmt, &prot_period, "");
+	exopts = change_opt(tmpexopts, nogc_opt_fmt, NULL, "");
+	my_free(tmpexopts);
 
 	res = mount(mi->device, mi->mntdir, fstype, mo->flags & ~MS_NOSYS,
 		    exopts);
@@ -450,9 +458,12 @@
 	}
 	if (mi->type != RW2RO_REMOUNT && mi->type != RW2RW_REMOUNT)
 		goto out;
+
+        mtab_ok = check_mtab();
+
 	/* Cleaner daemon was stopped and it needs to run */
 	/* because filesystem is still mounted */
-	if (check_mtab()) {
+	if (!mi->nogc && mtab_ok) {
 		/* Restarting cleaner daemon */
 		if (start_cleanerd(mi->device, mi->mntdir, mi->protperiod,
 				   &mi->gcpid) == 0) {
@@ -481,7 +492,7 @@
 	char *exopts;
 	int rungc;
 
-	rungc = !(mo->flags & MS_RDONLY) && !(mo->flags & MS_BIND);
+	rungc = (find_opt(mo->extra_opts, nogc_opt_fmt, NULL) < 0) && !(mo->flags & MS_RDONLY) && !(mo->flags & MS_BIND);
 
 	if (!check_mtab()) {
 		if (rungc)
diff -ur nilfs2-utils.orig/sbin/mount/mount.nilfs2.h nilfs2-utils/sbin/mount/mount.nilfs2.h
--- nilfs2-utils.orig/sbin/mount/mount.nilfs2.h	2010-03-14 15:11:30.918691251 +0100
+++ nilfs2-utils/sbin/mount/mount.nilfs2.h	2010-03-28 11:05:38.717647856 +0200
@@ -14,6 +14,7 @@
 #define CLEANERD_NAME		"nilfs_cleanerd"
 #define PIDOPT_NAME		"gcpid"
 #define PPOPT_NAME		"pp"
+#define NOGCOPT_NAME		"nogc"
 
 #define CLEANERD_WAIT_RETRY_COUNT	3
 #define CLEANERD_WAIT_RETRY_INTERVAL	2  /* in seconds */

--------------020406080705010305050801--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
