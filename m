From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: Re: cleaner: run one cleaning pass based on minimum free space
Date: Mon, 29 Mar 2010 06:35:27 +0200
Message-ID: <4BB02E0F.90001@prnet.org>
References: <4BAF48BC.8060505@prnet.org>	<20100329.002619.67908494.ryusuke@osrg.net>	<4BAFCFB4.5050401@prnet.org> <20100329.125908.56566467.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000705060509060302010205"
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100329.125908.56566467.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a multi-part message in MIME format.
--------------000705060509060302010205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

here the changes

Thank in advance,
David Arendt

On 03/29/10 05:59, Ryusuke Konishi wrote:
> Hi,
> On Sun, 28 Mar 2010 23:52:52 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
>   
>> Hi,
>>
>> thanks for applying the patches. I did all my tests on 2 gbyte loop
>> devices and now that it is officially in git, I deployed it to some
>> production systems with big disks. Here I have noticed, that I have
>> completely forgotten the reserved segments. Technically this is not a
>> problem, but I think people changing configuration files will tend to
>> forget about it. I'm thinking it might be useful to add them internally
>> to min_free_segments and max_free_segments so users don't need to worry
>> about them. What do you think ?
>>     
> Ahh, we should take into account the number of reserved segments.  If
> not so, cleaner control with the two threshold values will not work
> properly for large drives.
>
>   
>> If you like to change the current behavior to this behavior, I will
>> submit a short update patch.
>>     
> Yes, please do.
>
>   
>> I am thinking about getting the number of reserved segments this way:
>>
>> (nilfs_cleanerd->c_nilfs->n_sb->s_nsegments *
>> nilfs_cleanerd->c_nilfs->n_sb->s_r_segments_percentage) / 100
>>
>> or do you know any better way ?
>>     
> The kernel code calulates the number by:
>
>   = max(NILFS_MIN_NRSVSEGS,
>         DIV_ROUND_UP(nsegments * r_segments_percentage, 100))
>
>   where NILFS_MIN_NRSVSEGS is defined in include/nilfs2_fs.h, and
>   DIV_ROUND_UP is defined as follows:
>
>  #define DIV_ROUND_UP(n,d)    (((n) +  (d) - 1) / (d))
>
> The same or some equivelent calculation seems preferable.
>  
> With regards,
> Ryusuke Konishi
>
>   
>> On 03/28/10 17:26, Ryusuke Konishi wrote:
>>     
>>> Hi,
>>> On Sun, 28 Mar 2010 14:17:00 +0200, David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org> wrote:
>>>   
>>>       
>>>> Hi,
>>>>
>>>> here the nogc patch
>>>>
>>>> As changelog description for this one, we could put:
>>>>
>>>> add mount option to disable garbage collection
>>>>
>>>> Thanks in advance
>>>> Bye,
>>>> David Arendt
>>>>     
>>>>         
>>> Hmm, the patch looks perfect.
>>>
>>> Will queue both in the git tree of utils.
>>>
>>> Thanks,
>>> Ryusuke Konishi
>>>   
>>>       
>>     


--------------000705060509060302010205
Content-Type: text/plain;
 name="nilfs2-utils-min-free-segments-reserved.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nilfs2-utils-min-free-segments-reserved.patch"

diff -ur nilfs2-utils.orig/sbin/cleanerd/cleanerd.c nilfs2-utils/sbin/cleanerd/cleanerd.c
--- nilfs2-utils.orig/sbin/cleanerd/cleanerd.c	2010-03-29 06:05:51.382126765 +0200
+++ nilfs2-utils/sbin/cleanerd/cleanerd.c	2010-03-29 06:32:09.129775882 +0200
@@ -1185,7 +1185,7 @@
 static int nilfs_cleanerd_clean_loop(struct nilfs_cleanerd *cleanerd)
 {
 	struct nilfs_sustat sustat;
-	__u64 prev_nongc_ctime = 0, prottime = 0, oldest = 0;
+	__u64 r_segments, prev_nongc_ctime = 0, prottime = 0, oldest = 0;
 	__u64 segnums[NILFS_CLDCONFIG_NSEGMENTS_PER_CLEAN_MAX];
 	struct timespec timeout;
 	sigset_t sigset;
@@ -1215,6 +1215,10 @@
 
 	cleanerd->c_ncleansegs = cleanerd->c_config.cf_nsegments_per_clean;
 
+	r_segments = ((nilfs_cleanerd->c_nilfs->n_sb->s_nsegments * nilfs_cleanerd->c_nilfs->n_sb->s_r_segments_percentage) + 99) / 100;
+	if (r_segments < NILFS_MIN_NRSVSEGS)
+		r_segments = NILFS_MIN_NRSVSEGS;
+
 	if (cleanerd->c_config.cf_min_clean_segments > 0)
 		nilfs_cleanerd_clean_check_pause(cleanerd, &timeout);
 	else
@@ -1242,13 +1246,13 @@
 
 		if (cleanerd->c_config.cf_min_clean_segments > 0) {
 			if (cleanerd->c_running) {
-				if (sustat.ss_ncleansegs > cleanerd->c_config.cf_max_clean_segments) {
+				if (sustat.ss_ncleansegs > cleanerd->c_config.cf_max_clean_segments + r_segments) {
 					nilfs_cleanerd_clean_check_pause(cleanerd, &timeout);
 					goto sleep;
 				}
 			}
 			else {
-				if (sustat.ss_ncleansegs < cleanerd->c_config.cf_min_clean_segments)
+				if (sustat.ss_ncleansegs < cleanerd->c_config.cf_min_clean_segments + r_segments)
 					nilfs_cleanerd_clean_check_resume(cleanerd);
 				else
 					goto sleep;

--------------000705060509060302010205--
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
