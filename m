From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Tue, 06 Apr 2010 19:41:33 +0200
Message-ID: <4BBB724D.6040207@prnet.org>
References: <4BB99633.1030701@prnet.org>	<20100405.203450.56374807.ryusuke@osrg.net>	<4BB9E726.8020407@prnet.org> <20100407.010609.179957904.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050005060807080607030203"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100407.010609.179957904.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a multi-part message in MIME format.
--------------050005060807080607030203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

here the updated patch

Thanks in advance
Bye,
David Arendt

On 04/06/10 18:06, Ryusuke Konishi wrote:
> Hi,
> On Mon, 05 Apr 2010 15:35:34 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
>   
>> Hi,
>>
>> here is the patch
>>
>> Thanks in advance
>> Bye,
>> David Arendt
>>     
> Thanks.
>
> Looks functionally fine. Just a matter of coding style:
>
> The following part of cleaner loop looks bloated.  I think it's a good
> opportunity to divide it from the loop.
>
> Also, the length of their lines looks too long.  It's preferable if
> they're naturally wrapped within 80-columns.  This is not a must
> especially for userland tools, however kernel developers often prefer
> this conventional coding rule.  Separating the routine would make this
> easy.
>
>                 if (cleanerd->c_config.cf_min_clean_segments > 0) {
> ---> from
>                         if (cleanerd->c_running) {
>                                 if (sustat.ss_ncleansegs > cleanerd->c_config.c\
> f_max_clean_segments + r_segments) {
>                                         nilfs_cleanerd_clean_check_pause(cleane\
> rd, &timeout);
>                                         goto sleep;
>                                 }
>                         }
>                         else {
>                                 if (sustat.ss_ncleansegs < cleanerd->c_config.c\
> f_min_clean_segments + r_segments)
>                                         nilfs_cleanerd_clean_check_resume(clean\
> erd);
>                                 else
>                                         goto sleep;
>                         }
>
>                         if (sustat.ss_ncleansegs < cleanerd->c_config.cf_min_cl\
> ean_segments + r_segments) {
>                                 cleanerd->c_ncleansegs = cleanerd->c_config.cf_\
> mc_nsegments_per_clean;
>                                 cleanerd->c_cleaning_interval = cleanerd->c_con\
> fig.cf_mc_cleaning_interval;
>                         }
>                         else {
>                                 cleanerd->c_ncleansegs = cleanerd->c_config.cf_\
> nsegments_per_clean;
>                                 cleanerd->c_cleaning_interval = cleanerd->c_con\
> fig.cf_cleaning_interval;
>                         }
> <---- to
>                 }
>
> With regards,
> Ryusuke Konishi
>
>
>   
>> On 04/05/10 13:34, Ryusuke Konishi wrote:
>>     
>>> Hi,
>>> On Mon, 05 Apr 2010 09:50:11 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
>>>   
>>>       
>>>> Hi,
>>>>
>>>> Actually I run with min_clean_segments at 250 and found that to be a
>>>> good value. However for example for a 2 gbyte usb key, this value would
>>>> not work at all, therefor I find it a good idea to set the default at
>>>> 10% as it would be more general for any device size as lots of people
>>>> simply try the defaults without changing configuration files.
>>>>     
>>>>         
>>> Ok, let's start with the 10% min_clean_segments for the default
>>> values.
>>>
>>>   
>>>       
>>>> I really like your idea with having a second set of
>>>> nsegments_per_clean and cleaning_interval_parameters for <
>>>> min_clean_segments. I am wondering if adaptive optimization will be
>>>> good, as I think different people will expect different behavior.
>>>> Someones might prefer the system using 100% io usage for cleaning
>>>> and the disk not getting full. Other ones might prefer the disk
>>>> getting full and using less io usage.
>>>>     
>>>>         
>>> Well, that's true.  Netbook users would prefer suspending the cleaner
>>> wherever possible to avoid their SSD worn out. Meanwhile, NAS users
>>> would expect it to operate safely to avoid trouble.
>>>
>>> For the present, let's try to handle the disk full issue by adding a
>>> few parameters effectively.
>>>
>>>   
>>>       
>>>> Therefor I think it would add a lot of parameters to the
>>>> configuration file for giving people the ability to tune it
>>>> correctly, and this would possibly complicate the configuration to
>>>> much.
>>>>     
>>>>         
>>>   
>>>       
>>>> If you decide for the second set of nsegments_per_clean and
>>>> cleaning_interval_parameters, please tell me if I should implement it or
>>>> if you will implement it, not that we are working on the same
>>>> functionality at the same time.
>>>>     
>>>>         
>>> I'll do the change of default values.  And will give over to you for
>>> this extension ;)
>>>
>>>   
>>>       
>>>> I think good names might be
>>>>
>>>> mc_nsegments_per_clean and
>>>> mc_cleaning_interval
>>>>
>>>> as this would be compatible with the current indentation in
>>>> nilfs_cleanerd.conf.
>>>>     
>>>>         
>>> All right.
>>>  
>>>   
>>>       
>>>> What would you take as default values ? As you always told that it would
>>>> be preferable to reduce cleaning_interval instead of increasing
>>>> nsegments_per_clean
>>>>     
>>>>         
>>> Yes, adjusting mc_cleaning_interval should come before increasing
>>> mc_nsegments_per_clean.  My image is, for example, as follows:
>>>
>>>   mc_cleaning_interval  1 or 2
>>>   mc_nsegments_per_clean  2 ~ 4 (as needed)
>>>
>>>   
>>>       
>>>> would you set cleaning interval to 0 in this case
>>>> causing permanent cleaning and leave nsegements_per_clean at or which
>>>> values would you choose ?
>>>>     
>>>>         
>>> The permanent cleaning may spoil responsiveness of the system.  I
>>> don't know.  Seems that we need some test.
>>>
>>> Thanks,
>>> Ryusuke Konishi
>>>
>>>   
>>>       
>>>> On 04/05/10 05:02, Ryusuke Konishi wrote:
>>>>     
>>>>         
>>>>> Hi!
>>>>> On Mon, 29 Mar 2010 16:39:02 +0900 (JST), Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> wrote:
>>>>>   
>>>>>       
>>>>>           
>>>>>> On Mon, 29 Mar 2010 06:35:27 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
>>>>>>     
>>>>>>         
>>>>>>             
>>>>>>> Hi,
>>>>>>>
>>>>>>> here the changes
>>>>>>>
>>>>>>> Thank in advance,
>>>>>>> David Arendt
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>> Looks fine to me.  Will apply later.
>>>>>>
>>>>>> Thanks for your quick work.
>>>>>>
>>>>>> Ryusuke Konishi
>>>>>>     
>>>>>>         
>>>>>>             
>>>>> I enhanced your change so that min_clean_segments and
>>>>> max_clean_segments can be specified with a ratio (%) or an absolute
>>>>> value (MB, GB, and so on) of capacity.
>>>>>
>>>>> The change is available on the head of util's git repo.
>>>>>
>>>>> Now, my question is how we should set the default value of these
>>>>> parameters.  During test, I got disk full several times, and I feel
>>>>> min_free_segments = 100 is a bit tight.
>>>>>
>>>>> Of course this depends on the usage of each, but I think that the
>>>>> default values are desirable to have some generality (when possible).
>>>>>
>>>>> The following setting is my current idea for this.  How does it look?
>>>>>
>>>>>  min_clean_segments      10%
>>>>>  max_clean_segments      20%
>>>>>  clean_check_interval    10
>>>>>
>>>>> I also feel GC speed should be accelerated than now while the
>>>>> filesystem is close to disk full.  One simple method is adding
>>>>> optional nsegments_per_clean and cleaning_interval parameters for <
>>>>> min_clean_segments.  Or, some sort of adaptive acceleration should be
>>>>> applied.
>>>>>
>>>>> I'm planning to make the next util release after this settles down.
>>>>>
>>>>> Any idea?
>>>>>
>>>>> Thanks,
>>>>> Ryusuke Konishi
>>>>>   
>>>>>   
>>>>>       
>>>>>           
>>     


--------------050005060807080607030203
Content-Type: text/plain;
 name="mc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mc.patch"

diff -ur nilfs2-utils.orig/man/nilfs_cleanerd.conf.5 nilfs2-utils/man/nilfs_cleanerd.conf.5
--- nilfs2-utils.orig/man/nilfs_cleanerd.conf.5	2010-04-06 19:19:32.874081924 +0200
+++ nilfs2-utils/man/nilfs_cleanerd.conf.5	2010-04-06 19:24:23.027596397 +0200
@@ -56,9 +56,18 @@
 Specify the number of segments reclaimed by a single cleaning step.
 The default value is 2.
 .TP
+.B mc_nsegments_per_clean
+Specify the number of segments reclaimed by a single cleaning step
+if clean segments < min_clean_segments.
+The default value is 4.
+.TP
 .B cleaning_interval
 Specify the cleaning interval in seconds.  The default value is 5.
 .TP
+.B mc_cleaning_interval
+Specify the cleaning interval in seconds
+if clean segments < min_clean_segments.  The default value is 1.
+.TP
 .B retry_interval
 Specify retry interval in seconds.  This value provides the retry
 interval of GC in case of resource shortages.  The default value is
diff -ur nilfs2-utils.orig/sbin/cleanerd/cldconfig.c nilfs2-utils/sbin/cleanerd/cldconfig.c
--- nilfs2-utils.orig/sbin/cleanerd/cldconfig.c	2010-04-06 19:19:32.877083206 +0200
+++ nilfs2-utils/sbin/cleanerd/cldconfig.c	2010-04-06 19:24:23.027596397 +0200
@@ -405,6 +405,26 @@
 }
 
 static int
+nilfs_cldconfig_handle_mc_nsegments_per_clean(struct nilfs_cldconfig *config,
+					      char **tokens, size_t ntoks,
+					      struct nilfs *nilfs)
+{
+	unsigned long n;
+
+	if (nilfs_cldconfig_get_ulong_argument(tokens, ntoks, &n) < 0)
+		return 0;
+
+	if (n > NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX) {
+		syslog(LOG_WARNING, "%s: %s: too large, use the maximum value",
+		       tokens[0], tokens[1]);
+		n = NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX;
+	}
+
+	config->cf_mc_nsegments_per_clean = n;
+	return 0;
+}
+
+static int
 nilfs_cldconfig_handle_cleaning_interval(struct nilfs_cldconfig *config,
 					 char **tokens, size_t ntoks,
 					 struct nilfs *nilfs)
@@ -417,6 +437,18 @@
 }
 
 static int
+nilfs_cldconfig_handle_mc_cleaning_interval(struct nilfs_cldconfig *config,
+					    char **tokens, size_t ntoks,
+					    struct nilfs *nilfs)
+{
+	unsigned long sec;
+
+	if (nilfs_cldconfig_get_ulong_argument(tokens, ntoks, &sec) == 0)
+		config->cf_mc_cleaning_interval = sec;
+	return 0;
+}
+
+static int
 nilfs_cldconfig_handle_retry_interval(struct nilfs_cldconfig *config,
 				      char **tokens, size_t ntoks,
 				      struct nilfs *nilfs)
@@ -499,10 +531,18 @@
 		nilfs_cldconfig_handle_nsegments_per_clean
 	},
 	{
+		"mc_nsegments_per_clean", 2, 2,
+		nilfs_cldconfig_handle_mc_nsegments_per_clean
+	},
+	{
 		"cleaning_interval", 2, 2,
 		nilfs_cldconfig_handle_cleaning_interval
 	},
 	{
+		"mc_cleaning_interval", 2, 2,
+		nilfs_cldconfig_handle_mc_cleaning_interval
+	},
+	{
 		"retry_interval", 2, 2,
 		nilfs_cldconfig_handle_retry_interval
 	},
@@ -555,7 +595,10 @@
 	config->cf_max_clean_segments = NILFS_CLDCONFIG_MAX_CLEAN_SEGMENTS;
 	config->cf_clean_check_interval = NILFS_CLDCONFIG_CLEAN_CHECK_INTERVAL;
 	config->cf_nsegments_per_clean = NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN;
+	config->cf_mc_nsegments_per_clean =
+		NILFS_CLDCONFIG_MC_NSEGMENTS_PER_CLEAN;
 	config->cf_cleaning_interval = NILFS_CLDCONFIG_CLEANING_INTERVAL;
+	config->cf_mc_cleaning_interval = NILFS_CLDCONFIG_MC_CLEANING_INTERVAL;
 	config->cf_retry_interval = NILFS_CLDCONFIG_RETRY_INTERVAL;
 	config->cf_use_mmap = NILFS_CLDCONFIG_USE_MMAP;
 	config->cf_log_priority = NILFS_CLDCONFIG_LOG_PRIORITY;
diff -ur nilfs2-utils.orig/sbin/cleanerd/cldconfig.h nilfs2-utils/sbin/cleanerd/cldconfig.h
--- nilfs2-utils.orig/sbin/cleanerd/cldconfig.h	2010-04-06 19:19:32.877083206 +0200
+++ nilfs2-utils/sbin/cleanerd/cldconfig.h	2010-04-06 19:24:23.028596802 +0200
@@ -78,7 +78,11 @@
  * @cf_max_clean_segments: high threshold on the number of free segments
  * @cf_clean_check_interval: cleaner check interval
  * @cf_nsegments_per_clean: number of segments reclaimed per clean cycle
+ * @cf_mc_nsegments_per_clean: number of segments reclaimed per clean cycle
+ * if clean segments < min_clean_segments
  * @cf_cleaning_interval: cleaning interval
+ * @cf_mc_cleaning_interval: cleaning interval
+ * if clean segments < min_clean_segments
  * @cf_use_mmap: flag that indicate using mmap
  * @cf_log_priority: log priority level
  */
@@ -89,7 +93,9 @@
 	__u64 cf_max_clean_segments;
 	time_t cf_clean_check_interval;
 	int cf_nsegments_per_clean;
+	int cf_mc_nsegments_per_clean;
 	time_t cf_cleaning_interval;
+	time_t cf_mc_cleaning_interval;
 	time_t cf_retry_interval;
 	int cf_use_mmap;
 	int cf_log_priority;
@@ -103,7 +109,9 @@
 #define	NILFS_CLDCONFIG_MAX_CLEAN_SEGMENTS		200
 #define	NILFS_CLDCONFIG_CLEAN_CHECK_INTERVAL		60
 #define NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN		2
+#define NILFS_CLDCONFIG_MC_NSEGMENTS_PER_CLEAN		4
 #define NILFS_CLDCONFIG_CLEANING_INTERVAL		5
+#define NILFS_CLDCONFIG_MC_CLEANING_INTERVAL		1
 #define NILFS_CLDCONFIG_RETRY_INTERVAL			60
 #define NILFS_CLDCONFIG_USE_MMAP			1
 #define NILFS_CLDCONFIG_LOG_PRIORITY			LOG_INFO
diff -ur nilfs2-utils.orig/sbin/cleanerd/cleanerd.c nilfs2-utils/sbin/cleanerd/cleanerd.c
--- nilfs2-utils.orig/sbin/cleanerd/cleanerd.c	2010-04-06 19:19:32.877083206 +0200
+++ nilfs2-utils/sbin/cleanerd/cleanerd.c	2010-04-06 19:24:23.050595046 +0200
@@ -158,6 +158,8 @@
 		}
 		cleanerd->c_ncleansegs =
 			cleanerd->c_config.cf_nsegments_per_clean;
+		cleanerd->c_cleaning_interval =
+			cleanerd->c_config.cf_cleaning_interval;
 	}
 	return ret;
 }
@@ -1136,13 +1138,13 @@
 	/* curr >= target */
 	if (!timercmp(&curr, &cleanerd->c_target, <)) {
 		cleanerd->c_target = curr;
-		cleanerd->c_target.tv_sec += config->cf_cleaning_interval;
+		cleanerd->c_target.tv_sec += cleanerd->c_cleaning_interval;
 		syslog(LOG_DEBUG, "adjust interval");
 		return 1; /* skip a sleep */
 	}
 	timersub(&cleanerd->c_target, &curr, &diff);
 	timeval_to_timespec(&diff, timeout);
-	cleanerd->c_target.tv_sec += config->cf_cleaning_interval;
+	cleanerd->c_target.tv_sec += cleanerd->c_cleaning_interval;
 	return 0;
 }
 
@@ -1177,6 +1179,41 @@
 	syslog(LOG_INFO, "resume (clean check)");
 }
 
+static int nilfs_cleanerd_handle_clean_check(struct nilfs_cleanerd *cleanerd,
+					     struct nilfs_sustat *sustat,
+					     int r_segments,
+					     struct timespec *timeout)
+{
+	if (cleanerd->c_running) {
+		if (sustat->ss_ncleansegs >
+		    cleanerd->c_config.cf_max_clean_segments + r_segments) {
+			nilfs_cleanerd_clean_check_pause(cleanerd, timeout);
+			return -1;
+		}
+	} else {
+		if (sustat->ss_ncleansegs <
+		    cleanerd->c_config.cf_min_clean_segments + r_segments)
+			nilfs_cleanerd_clean_check_resume(cleanerd);
+		else
+			return -1;
+	}
+
+	if (sustat->ss_ncleansegs <
+	    cleanerd->c_config.cf_min_clean_segments + r_segments) {
+		cleanerd->c_ncleansegs =
+			cleanerd->c_config.cf_mc_nsegments_per_clean;
+		cleanerd->c_cleaning_interval =
+			cleanerd->c_config.cf_mc_cleaning_interval;
+	} else {
+		cleanerd->c_ncleansegs =
+			cleanerd->c_config.cf_nsegments_per_clean;
+		cleanerd->c_cleaning_interval =
+			cleanerd->c_config.cf_cleaning_interval;
+	}
+
+	return 0;
+}
+
 /**
  * nilfs_cleanerd_clean_loop - main loop of the cleaner daemon
  * @cleanerd: cleanerd object
@@ -1218,6 +1255,7 @@
 		return -1;
 
 	cleanerd->c_ncleansegs = cleanerd->c_config.cf_nsegments_per_clean;
+	cleanerd->c_cleaning_interval = cleanerd->c_config.cf_cleaning_interval;
 
 	r_segments = nilfs_get_reserved_segments(cleanerd->c_nilfs);
 
@@ -1245,18 +1283,9 @@
 		}
 
 		if (cleanerd->c_config.cf_min_clean_segments > 0) {
-			if (cleanerd->c_running) {
-				if (sustat.ss_ncleansegs > cleanerd->c_config.cf_max_clean_segments + r_segments) {
-					nilfs_cleanerd_clean_check_pause(cleanerd, &timeout);
-					goto sleep;
-				}
-			}
-			else {
-				if (sustat.ss_ncleansegs < cleanerd->c_config.cf_min_clean_segments + r_segments)
-					nilfs_cleanerd_clean_check_resume(cleanerd);
-				else
-					goto sleep;
-			}
+			if (nilfs_cleanerd_handle_clean_check(
+				cleanerd, &sustat, r_segments, &timeout) < 0)
+				goto sleep;
 		}
 
 		if (sustat.ss_nongc_ctime != prev_nongc_ctime) {
diff -ur nilfs2-utils.orig/sbin/cleanerd/cleanerd.h nilfs2-utils/sbin/cleanerd/cleanerd.h
--- nilfs2-utils.orig/sbin/cleanerd/cleanerd.h	2010-04-06 19:19:32.878083926 +0200
+++ nilfs2-utils/sbin/cleanerd/cleanerd.h	2010-04-06 19:24:23.050595046 +0200
@@ -43,6 +43,7 @@
  * @c_running: running state
  * @c_fallback: fallback state
  * @c_ncleansegs: number of semgents cleaned per cycle
+ * @c_cleaning_interval: cleaning interval
  * @c_protcno: the minimum of checkpoint numbers within protection period
  * @c_prottime: start time of protection period
  * @c_target: target time for sleeping
@@ -54,6 +55,7 @@
 	int c_running;
 	int c_fallback;
 	int c_ncleansegs;
+	time_t c_cleaning_interval;
 	nilfs_cno_t c_protcno;
 	__u64 c_prottime;
 	struct timeval c_target;
diff -ur nilfs2-utils.orig/sbin/cleanerd/nilfs_cleanerd.conf nilfs2-utils/sbin/cleanerd/nilfs_cleanerd.conf
--- nilfs2-utils.orig/sbin/cleanerd/nilfs_cleanerd.conf	2010-04-06 19:19:32.878083926 +0200
+++ nilfs2-utils/sbin/cleanerd/nilfs_cleanerd.conf	2010-04-06 19:24:23.050595046 +0200
@@ -37,9 +37,17 @@
 # The maximum number of segments to be cleaned at a time.
 nsegments_per_clean	2
 
+# The maximum number of segments to be cleaned at a time
+# if clean segments < min_clean_segments
+mc_nsegments_per_clean	4
+
 # Cleaning interval in seconds.
 cleaning_interval	5
 
+# Cleaning interval in seconds
+# if clean segments < min_clean_segments
+mc_cleaning_interval	1
+
 # Retry interval in seconds.
 retry_interval		60
 

--------------050005060807080607030203--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
