From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Wed, 24 Mar 2010 06:35:00 +0100
Message-ID: <4BA9A484.20809@prnet.org>
References: <4B9D6B51.5010202@prnet.org>	<20100316.005815.140047502.ryusuke@osrg.net>	<4B9EA58C.1080402@prnet.org> <20100318.031108.204325310.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040909000203040605050606"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100318.031108.204325310.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a multi-part message in MIME format.
--------------040909000203040605050606
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

just for completeness, here is a re-post of the complete patch using
cleanerd->c_running instead of local variable "sleeping".

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


--------------040909000203040605050606
Content-Type: text/plain;
 name="nilfs2-utils-min-free-segments.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nilfs2-utils-min-free-segments.patch"

diff -ur nilfs2-utils.orig/man/nilfs_cleanerd.conf.5 nilfs2-utils/man/nilfs_cleanerd.conf.5
--- nilfs2-utils.orig/man/nilfs_cleanerd.conf.5	2010-03-14 15:11:30.916690347 +0100
+++ nilfs2-utils/man/nilfs_cleanerd.conf.5	2010-03-15 22:15:58.320507660 +0100
@@ -25,6 +25,23 @@
 and their blocks whose duration time is less than the value.  The
 default value is 3600, meaning one hour.
 .TP
+.B min_clean_segments
+Specify the minimum number of clean segments. A value of 0 means
+normal cleaner operation. A value greater than 0 means pause cleaning
+until less than min_clean_segments are available. The default value
+is 100.
+.TP
+.B max_clean_segments
+Specify the maximum number of clean segments. If min_clean_segments is
+0, this value is ignored. If more than max_clean_segments are available
+cleaning is paused until less than min_clean_segments are available.
+The default value is 200.
+.TP
+.B clean_check_interval
+Specify the interval to wait between checks of min_clean_segments.
+If min_clean_segments is 0, this value is ignored.
+The default value is 60.
+.TP
 .B selection_policy
 Specify the GC policy. At present, only the `\fBtimestamp\fP' policy,
 which reclaims segments in order from oldest to newest, is support.
diff -ur nilfs2-utils.orig/sbin/cleanerd/cldconfig.c nilfs2-utils/sbin/cleanerd/cldconfig.c
--- nilfs2-utils.orig/sbin/cleanerd/cldconfig.c	2010-03-14 15:11:30.916690347 +0100
+++ nilfs2-utils/sbin/cleanerd/cldconfig.c	2010-03-15 20:20:22.364435601 +0100
@@ -90,6 +90,87 @@
 	return 0;
 }
 
+static int
+nilfs_cldconfig_handle_min_clean_segments(struct nilfs_cldconfig *config,
+					  char **tokens, size_t ntoks)
+{
+	__u64 n;
+	char *endptr;
+
+	if (check_tokens(tokens, ntoks, 2, 2) < 0)
+		return 0;
+
+	errno = 0;
+	n = strtoull(tokens[1], &endptr, 10);
+	if (*endptr != '\0') {
+		syslog(LOG_WARNING, "%s: %s: not a number",
+		       tokens[0], tokens[1]);
+		return 0;
+	}
+	if ((n == ULLONG_MAX) && (errno == ERANGE)) {
+		syslog(LOG_WARNING, "%s: %s: number too large",
+		       tokens[0], tokens[1]);
+		return 0;
+	}
+
+	config->cf_min_clean_segments = n;
+	return 0;
+}
+
+static int
+nilfs_cldconfig_handle_max_clean_segments(struct nilfs_cldconfig *config,
+					  char **tokens, size_t ntoks)
+{
+	__u64 n;
+	char *endptr;
+
+	if (check_tokens(tokens, ntoks, 2, 2) < 0)
+		return 0;
+
+	errno = 0;
+	n = strtoull(tokens[1], &endptr, 10);
+	if (*endptr != '\0') {
+		syslog(LOG_WARNING, "%s: %s: not a number",
+		       tokens[0], tokens[1]);
+		return 0;
+	}
+	if ((n == ULLONG_MAX) && (errno == ERANGE)) {
+		syslog(LOG_WARNING, "%s: %s: number too large",
+		       tokens[0], tokens[1]);
+		return 0;
+	}
+
+	config->cf_max_clean_segments = n;
+	return 0;
+}
+
+static int
+nilfs_cldconfig_handle_clean_check_interval(struct nilfs_cldconfig *config,
+					    char **tokens, size_t ntoks)
+{
+	time_t period;
+	char *endptr;
+
+	if (check_tokens(tokens, ntoks, 2, 2) < 0)
+		return 0;
+
+	errno = 0;
+	period = strtoul(tokens[1], &endptr, 10);
+	if (*endptr != '\0') {
+		syslog(LOG_WARNING, "%s: %s: not a number",
+		       tokens[0], tokens[1]);
+		return 0;
+	}
+	if ((period == ULONG_MAX) && (errno == ERANGE)) {
+		syslog(LOG_WARNING, "%s: %s: number too large",
+		       tokens[0], tokens[1]);
+		return 0;
+	}
+
+	config->cf_clean_check_interval = period;
+	return 0;
+}
+
 static unsigned long long
 nilfs_cldconfig_selection_policy_timestamp(const struct nilfs_suinfo *si)
 {
@@ -277,6 +358,9 @@
 static const struct nilfs_cldconfig_keyword
 nilfs_cldconfig_keyword_table[] = {
 	{"protection_period",	nilfs_cldconfig_handle_protection_period},
+	{"min_clean_segments",	nilfs_cldconfig_handle_min_clean_segments},
+	{"max_clean_segments",	nilfs_cldconfig_handle_max_clean_segments},
+	{"clean_check_interval",nilfs_cldconfig_handle_clean_check_interval},
 	{"selection_policy",	nilfs_cldconfig_handle_selection_policy},
 	{"nsegments_per_clean",	nilfs_cldconfig_handle_nsegments_per_clean},
 	{"cleaning_interval",	nilfs_cldconfig_handle_cleaning_interval},
@@ -313,6 +397,9 @@
 	config->cf_selection_policy.p_threshold =
 		NILFS_CLDCONFIG_SELECTION_POLICY_THRESHOLD;
 	config->cf_protection_period = NILFS_CLDCONFIG_PROTECTION_PERIOD;
+	config->cf_min_clean_segments = NILFS_CLDCONFIG_MIN_CLEAN_SEGMENTS;
+	config->cf_max_clean_segments = NILFS_CLDCONFIG_MAX_CLEAN_SEGMENTS;
+	config->cf_clean_check_interval = NILFS_CLDCONFIG_CLEAN_CHECK_INTERVAL;
 	config->cf_nsegments_per_clean = NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN;
 	config->cf_cleaning_interval = NILFS_CLDCONFIG_CLEANING_INTERVAL;
 	config->cf_retry_interval = NILFS_CLDCONFIG_RETRY_INTERVAL;
diff -ur nilfs2-utils.orig/sbin/cleanerd/cldconfig.h nilfs2-utils/sbin/cleanerd/cldconfig.h
--- nilfs2-utils.orig/sbin/cleanerd/cldconfig.h	2010-03-14 15:11:30.916690347 +0100
+++ nilfs2-utils/sbin/cleanerd/cldconfig.h	2010-03-15 21:58:16.208614224 +0100
@@ -42,6 +42,9 @@
  * struct nilfs_cldconfig -
  * @cf_selection_policy:
  * @cf_protection_period:
+ * @cf_min_clean_segments:
+ * @cf_max_clean_segments:
+ * @cf_clean_check_interval:
  * @cf_nsegments_per_clean
  * @cf_cleaning_interval:
  * @cf_use_mmap:
@@ -50,6 +53,9 @@
 struct nilfs_cldconfig {
 	struct nilfs_selection_policy cf_selection_policy;
 	time_t cf_protection_period;
+	__u64 cf_min_clean_segments;
+	__u64 cf_max_clean_segments;
+	time_t cf_clean_check_interval;
 	int cf_nsegments_per_clean;
 	time_t cf_cleaning_interval;
 	time_t cf_retry_interval;
@@ -61,6 +67,9 @@
 			nilfs_cldconfig_selection_policy_timestamp
 #define NILFS_CLDCONFIG_SELECTION_POLICY_THRESHOLD	0
 #define NILFS_CLDCONFIG_PROTECTION_PERIOD		3600
+#define	NILFS_CLDCONFIG_MIN_CLEAN_SEGMENTS		100
+#define	NILFS_CLDCONFIG_MAX_CLEAN_SEGMENTS		200
+#define	NILFS_CLDCONFIG_CLEAN_CHECK_INTERVAL		60
 #define NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN		2
 #define NILFS_CLDCONFIG_CLEANING_INTERVAL		5
 #define NILFS_CLDCONFIG_RETRY_INTERVAL			60
diff -ur nilfs2-utils.orig/sbin/cleanerd/cleanerd.c nilfs2-utils/sbin/cleanerd/cleanerd.c
--- nilfs2-utils.orig/sbin/cleanerd/cleanerd.c	2010-03-14 15:11:30.916690347 +0100
+++ nilfs2-utils/sbin/cleanerd/cleanerd.c	2010-03-17 19:59:36.845402863 +0100
@@ -1198,9 +1198,17 @@
 	if (ret < 0)
 		return -1;
 
-	cleanerd->c_running = 1;
 	cleanerd->c_ncleansegs = cleanerd->c_config.cf_nsegments_per_clean;
 
+	if (cleanerd->c_config.cf_min_clean_segments > 0) {
+		syslog(LOG_INFO, "cleaner paused");
+		cleanerd->c_running = 0;
+		timeout.tv_sec = cleanerd->c_config.cf_clean_check_interval;
+		timeout.tv_nsec = 0;
+	}
+	else
+	  cleanerd->c_running = 1;
+
 	while (1) {
 		if (sigprocmask(SIG_BLOCK, &sigset, NULL) < 0) {
 			syslog(LOG_ERR, "cannot set signal mask: %m");
@@ -1220,10 +1228,32 @@
 			syslog(LOG_ERR, "cannot get segment usage stat: %m");
 			return -1;
 		}
+
+		if (cleanerd->c_config.cf_min_clean_segments > 0) {
+			if (cleanerd->c_running) {
+				if (sustat.ss_ncleansegs > cleanerd->c_config.cf_max_clean_segments) {
+					syslog(LOG_INFO, "cleaner paused");
+					cleanerd->c_running = 0;
+					timeout.tv_sec = cleanerd->c_config.cf_clean_check_interval;
+					timeout.tv_nsec = 0;
+					goto sleep;
+				}
+			}
+			else {
+				if (sustat.ss_ncleansegs < cleanerd->c_config.cf_min_clean_segments) {
+					syslog(LOG_INFO, "cleaner resumed");
+					cleanerd->c_running = 1;
+				}
+				else
+					goto sleep;
+			}
+		}
+
 		if (sustat.ss_nongc_ctime != prev_nongc_ctime) {
 			cleanerd->c_running = 1;
 			prev_nongc_ctime = sustat.ss_nongc_ctime;
 		}
+
 		if (!cleanerd->c_running)
 			goto sleep;
 
diff -ur nilfs2-utils.orig/sbin/cleanerd/nilfs_cleanerd.conf nilfs2-utils/sbin/cleanerd/nilfs_cleanerd.conf
--- nilfs2-utils.orig/sbin/cleanerd/nilfs_cleanerd.conf	2010-03-14 15:11:30.916690347 +0100
+++ nilfs2-utils/sbin/cleanerd/nilfs_cleanerd.conf	2010-03-15 21:44:02.995587453 +0100
@@ -7,6 +7,17 @@
 # Protection period in second.
 protection_period	3600
 
+# Minium number of clean segements 
+# 0  = normal cleaner behaviour
+# >0 = start cleaning if less segments are available
+min_clean_segments	100
+
+# Maximum number of clean segments
+max_clean_segments	200
+
+# Clean segment check interval in seconds
+clean_check_interval	60
+
 # Segment selection policy.
 # In NILFS version 2.0.0, only the timestamp policy is supported.
 selection_policy	timestamp	# timestamp in ascend order

--------------040909000203040605050606--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
